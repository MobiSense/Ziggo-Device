#include <fstream>
#include <iostream>
#include <string>
#include <cstring>
#include <algorithm>
#include <assert.h>
#include <cstdint>
#include <unordered_map>
#include <unordered_set>
#include <vector>

extern "C" {
#include "pkt_gen_control/pkt_gen.h"
}

#include "json.hpp"

using json = nlohmann::json;
using namespace std;

string toUpper(const string& s) {
	string ret = s;
	int n = s.length();
	for (int i = 0; i < n; i++) {
		if (ret[i] >= 'a' && ret[i] <= 'z')
		    ret[i] = ret[i] - 'a' + 'A';
	}
	return ret;
}

class MacAddr {
public:
    MacAddr(const string& addr) {
        string s = addr;
        string::size_type p;
        for (int i = 0; i < 6; i++) {
            this->addr[i] = uint8_t(stoi(s, &p, 16));
            assert(addr[p] == ':' && p == 2);
            if (i < 5) s = s.substr(p+1);
        }
    }

    uint8_t* get_addr() { return addr; }

    friend ostream& operator <<(ostream& os, const MacAddr& maddr) {
        os << hex << uppercase;
        for (int i = 0; i < 5; i++) {
            os << setw(2) << setfill('0') << unsigned(maddr.addr[i]) << ":";
        }
        os << setw(2) << setfill('0') << unsigned(maddr.addr[5]);
        os << dec;
        return os;
    }

private:
    uint8_t addr[6];
};

class PktGenSlotParameters {
public:
    PktGenSlotParameters(uint16_t seq_id,
                         uint16_t pkt_number,
                         uint32_t pkt_id_start,
                         uint32_t pkt_id_update,
                         int64_t tx_offset,
                         int src_id,
                         int dst_id) {
        this->seq_id = seq_id;
        this->pkt_number = pkt_number;
        this->pkt_id_start = pkt_id_start;
        this->pkt_id_update = pkt_id_update;
        this->tx_offset = tx_offset;
        this->src_id = src_id;
        this->dst_id = dst_id;
    }

    bool operator < (const PktGenSlotParameters& param) const {
        return (this->tx_offset < param.tx_offset) || 
               (this->tx_offset == param.tx_offset && this->pkt_id_start < param.pkt_id_start);
    }

// private:
    uint16_t seq_id;
    uint16_t pkt_number;
    uint32_t pkt_id_start;
    uint32_t pkt_id_update;
    int64_t tx_offset;
    int src_id, dst_id;
};

int gcd(int a, int b) {
    if (b == 0) return a;
    return gcd(b, a % b);
}

int lcm(int a, int b) { return a / gcd(a, b) * b; }

json* get_topo() {
    static json *topo;
    if (topo) return topo;

    topo = new json();
    std::ifstream file("config.json");
    file >> *topo;
    return topo;
}

json* get_schedule() {
    static json *schedule;
    if (schedule) return schedule;

    schedule = new json();
    std::ifstream file("schedule.json");
    file >> *schedule;
    return schedule;
}

string get_mac_address() {
    ifstream file("/sys/class/net/eth1/address");
    string mac;
    file >> mac;
    return toUpper(mac);
    // return "00:0A:35:00:1E:02"; // device0
}

bool find_src_dst(const json& sche, int job_id, int flow_id, int& src_id, int& dst_id) {
    unordered_set<int> sOutflow;
    unordered_set<int> sInflow;
    sOutflow.clear();
    sInflow.clear();
    for (const auto& elem: sche) {
        if (elem["type"] != "link")
            continue;
        int from = elem["from"].get<int>();
        int to = elem["to"].get<int>();

        for (const auto& flow: elem["schedule"]) {
            if (job_id == flow["job_id"].get<int>() &&
                flow_id == flow["flow_id"].get<int>()) {
                sOutflow.insert(from);
                sInflow.insert(to);
            }
        }
    }

    src_id = -1;
    for (int id: sOutflow) {
        if (sInflow.find(id) == sInflow.end()) {
            if (src_id != -1) return false;
            src_id = id;
        }
    }
    
    dst_id = -1;
    for (int id: sInflow) {
        if (sOutflow.find(id) == sOutflow.end()) {
            if (dst_id != -1) return false;
            dst_id = id;
        }
    }

    return src_id != -1 && dst_id != -1;
}

void config_pkg_gen() {
    const std::string my_mac_addr = get_mac_address();
    json topo = *get_topo();
    int my_id = -1;
    std::string my_type;

    MacAddr myMacAddr(my_mac_addr);

    unordered_map<int, std::string> mId2mac;
    unordered_map<int, std::string> mId2type;
    for (const auto &node: topo["nodes"]) {
        const std::string node_mac = toUpper(node["mac"].get<string>());
        const std::string node_type = node["type"].get<string>();
        const int node_id = node["id"].get<int>();
        mId2mac[node_id] = node_mac;
        mId2type[node_id] = node_type;

        if (node_mac == my_mac_addr) {
            my_id = node_id;
            my_type = node_type;
        }
    }

    if (my_id == -1) {
        std::cout << "[ERROR] Could not find node with mac address " << my_mac_addr << std::endl;
        exit(1);
    }
    
    json sche = *get_schedule();

    start_pkt_gen_config(25);
    
    for (const auto& elem: sche) {
        if (elem["type"] != "link")
            continue;
        if (elem["from"].get<int>() != my_id)
            continue;

        int to_id = elem["to"].get<int>();
        MacAddr toMacAddr(mId2mac[to_id]);
        
        int superperiod = 1;
        for (const auto& flow: elem["schedule"]) {
            superperiod = lcm(superperiod, flow["period"].get<int>());
        }

        vector<PktGenSlotParameters> vParams;
        for (const auto& flow: elem["schedule"]) {
            int period = flow["period"].get<int>();
            int start = flow["start"].get<int>() % period;
            int end = flow["end"].get<int>() % period;
            int job_id = flow["job_id"].get<int>();
            int flow_id = flow["flow_id"].get<int>();
            int seq_id = (job_id << 8) | flow_id;
            // 1 schedule slot = 2^14ns = 16.384us, 1500Byte/1000Mbps=12us
            int pkt_number = (int)((float)(end - start) * (16.384 / 12.0)); // [start, end)
            // int pkt_number = 1;

            int src_id, dst_id;
            if (!find_src_dst(sche, job_id, flow_id, src_id, dst_id)) {
                cerr << "[Error] Flow#" << flow_id << " in job#" << job_id << " is not valid!" << endl;
                exit(1);
            }
            
            for (int i = 0, t = start; i < superperiod / period; i++, t += period) {
                vParams.emplace_back(seq_id, pkt_number, i * pkt_number, (superperiod / period)*pkt_number,
                                     (int64_t)t << 14, src_id, dst_id);
            }
        }

        sort(vParams.begin(), vParams.end());
        int N = vParams.size();
        for (int i = 0; i < N; i++) {
            cout << "set_pkt_gen_slot(" << i << ", 0x"
                     << setw(4) << setfill('0') << hex << vParams[i].seq_id << dec << ", "
                     << vParams[i].pkt_number << ", "
                     << vParams[i].pkt_id_start << ", "
                     << vParams[i].pkt_id_update << ", "
                     << (vParams[i].tx_offset >> 14) << "<<14, "
                     << "device#" << vParams[i].src_id << ", "
                     << "device#" << vParams[i].dst_id << ")" << endl;
            MacAddr src_addr(mId2mac[vParams[i].src_id]);
            MacAddr dst_addr(mId2mac[vParams[i].dst_id]);
            cout << src_addr << endl;
            cout << dst_addr << endl;
            set_pkt_gen_slot(i, vParams[i].seq_id,
                            vParams[i].pkt_number,
                            vParams[i].pkt_id_start,
                            vParams[i].pkt_id_update,
                            vParams[i].tx_offset,
                            src_addr.get_addr(),
                            dst_addr.get_addr());
        }
    }

    finish_pkt_gen_config();
}


int main() {
    pkt_gen_init();

    config_pkg_gen();
    return 0;
}
