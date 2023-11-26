from scapy.all import *
from scapy.layers.l2 import Ether
from statistics import mean, variance
import argparse
import csv

'''
    自定义一个TSN的包格式
    继承自以太网的帧，其中已经包含了 src_mac, dst_mac, VLAN_header, 66AB
    剩下的部分包括：
        reserved    : 2 Byte
        tx_timestamp: 8 Byte
        rx_timestamp: 8 Byte
        SEQ_ID      : 2 Byte
        PKT_ID      : 4 Byte
'''
class TSNCriticalEther(Packet):
    name = "TSN Critical Ethernet"
    fields_desc = [
        ShortField("reserved"    , 0),
        LongField ("tx_timestamp", 0),
        LongField ("rx_timestamp", 0),
        ShortField("seq_id"      , 0),
        XIntField ("pkt_id"      , 0),
    ]

'''
    对应上面创建的数据类
'''
class TSNData():
    def __init__(self, tx, rx, s, p):
        self.tx_timestamp = tx
        self.rx_timestamp = rx
        self.seq_id       = s
        self.pkt_id       = p
        self.latency      = rx - tx

'''
    定义 ANSI 转义序列颜色代码
'''
class Color:
    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    BLUE = "\033[34m"
    MAGENTA = "\033[35m"
    CYAN = "\033[36m"
    RESET = "\033[0m"

'''
    处理函数,返回一个 TSNData 的 list
'''
def parse_pcapng(filename):
    packets = rdpcap(filename)

    TSNData_list = []
    for packet in packets:
        custom_ether = TSNCriticalEther(packet.load)

        TSNData_list.append(TSNData(
            custom_ether.tx_timestamp,
            custom_ether.rx_timestamp,
            custom_ether.seq_id,
            custom_ether.pkt_id
        ))

    return TSNData_list
        

'''
    处理的逻辑：
    1. 每收到的(100)个数据包输出一段综合分析情况
    2. 所有包的情况输出到一个csv文件中
'''
def analyse_packets(TSNData_list, step = 100):
    # 将包的顺序排序
    
    # TSNData_list.sort(key = lambda x:  x.pkt_id)
    
    length = len(TSNData_list)
    
    # 需要计算总计的latency mean 以及 variance
    weight_list = list()
    latency_mean_list = list()
    latency_var_list = list()
    
    print(f"{Color.GREEN}{'Seq ID':>{10}},{'Received Number':>{17}},{Color.YELLOW}{'Max pkt_id':>{12}},{'Min pkt_id':>{12}},{Color.RED}{'Loss Rate':>{10}},{Color.BLUE}{'Latency Mean':>{15}},{'Latency Variance':>{18}}")
    
    with open("critical_log.csv", "w", newline="") as csvfile:
        writer =  csv.writer(csvfile)
        writer.writerow(["Seq ID", "Received Number", "Max pkt_id", "Min pkt_id", "Loss Rate", "Latencty Mean", "Latency Variance"])

        for i in range(0, length, step):
            tail_index =  i + step-1 if i + step-1 < length else length - 1

            latency_list = [TSNData_list[j].latency for j in range(i, tail_index+1)]
            mean_latency = mean(latency_list)
            var_latency = variance(latency_list)
            
            seq_id = TSNData_list[i].seq_id
            receive_number = tail_index - i + 1
            max_pkt_id = TSNData_list[tail_index].pkt_id
            min_pkt_id = TSNData_list[i].pkt_id

            loss_rate =  (max_pkt_id - min_pkt_id + 1 - (tail_index - i + 1)) / (max_pkt_id - min_pkt_id + 1)
        
            # print(seq_id, receive_number, max_pkt_id, min_pkt_id, loss_rate, mean_latency, var_latency)
            print(f"{Color.GREEN}{seq_id:>{10}},{receive_number:>{17}},{Color.YELLOW}{max_pkt_id:>{12}},{min_pkt_id:>{12}},{Color.RED}{loss_rate:>{10}.2f},{Color.BLUE}{mean_latency:>{15}.2f},{var_latency:>{18}.2f}")

            # 计算总的mean variance
            weight_list.append(receive_number)
            latency_mean_list.append(mean_latency)
            latency_var_list.append(var_latency)

            writer.writerow([seq_id, receive_number, max_pkt_id, min_pkt_id, loss_rate, mean_latency, var_latency])
    
    total_loss_rate = (TSNData_list[-1].pkt_id - TSNData_list[0].pkt_id + 1 - length)  / (TSNData_list[-1].pkt_id - TSNData_list[0].pkt_id + 1) 
    total_mean_latency = sum(v * w for v, w in zip(latency_mean_list, weight_list)) / length
    total_var_latency  = sum(u * (w-1) + (w) * (total_mean_latency ** 2 - v ** 2) + 2 * (w) * v * (v - total_mean_latency) for u, v, w in zip(latency_var_list, latency_mean_list,weight_list)) / (length-1)
    print()
    print(f"{Color.MAGENTA}-----------TOTAL STATISTICS-----------")
    print(f"{Color.GREEN}Total Receive Number:{length}, {Color.RED}Total Loss Rate:{total_loss_rate:.2f}, {Color.BLUE}Total Latency Mean:{total_mean_latency:.2f}, Total Latency Variance:{total_var_latency:.2f}")



'''
    将所有包相关的数据写入到csv
'''
def write_data_csv(TSNData_list):
    output_file = "packet_log.csv"

    with open(output_file, "w", newline="") as csvfile:
        writer =  csv.writer(csvfile)
        writer.writerow(["Seq ID", "Pkt ID", "TX timestamp", "RX timestamp", "Latency"])

        for data in TSNData_list:
            writer.writerow([data.seq_id, data.pkt_id, data.tx_timestamp, data.rx_timestamp, data.latency])


'''
    按照行哥的要求，每读若干个包输出一次
'''
def analyse_packets_pro(filename, step):
    pcap_reader = PcapReader(filename)
    isBreak = False

    loss_list = []
    latency_mean_list = []
    latency_var_list = []
    weight_list = []
    print(f"{Color.GREEN}{'Seq ID':>{10}},{'Received Number':>{17}},{Color.YELLOW}{'Max pkt_id':>{12}},{'Min pkt_id':>{12}},{Color.RED}{'Loss Rate':>{10}},{Color.BLUE}{'Latency Mean':>{15}},{'Latency Variance':>{18}}")

    with open('packet_log.csv', "w", newline="") as csvfile:
        writer =  csv.writer(csvfile)
        writer.writerow(["Seq ID", "Pkt ID", "TX timestamp", "RX timestamp", "Latency"])

        with open('critical_log.csv', 'w', newline="") as critical_csvfile:
            critical_writer = csv.writer(critical_csvfile)
            critical_writer.writerow(["Seq ID", "Received Number", "Max pkt_id", "Min pkt_id", "Loss Rate", "Latencty Mean", "Latency Variance"])
            while not isBreak:
                TSNData_list = []
                for index in range(0, step):
                    try:
                        packet = pcap_reader.read_packet()
                    except:
                        isBreak = True
                        break

                    custom_ether = TSNCriticalEther(packet.load)
                    TSNData_list.append(TSNData(
                        custom_ether.tx_timestamp,
                        custom_ether.rx_timestamp,
                        custom_ether.seq_id,
                        custom_ether.pkt_id
                    ))

                cur_len = len(TSNData_list)
                if cur_len == 0: break

                for data in TSNData_list:
                    writer.writerow([data.seq_id, data.pkt_id, data.tx_timestamp, data.rx_timestamp, data.latency])

                
                latency_list = [TSNData_list[j].latency for j in range(0, cur_len)]
                mean_latency = mean(latency_list)
                var_latency = variance(latency_list) if cur_len != 1 else 0
                
                seq_id = TSNData_list[0].seq_id
                receive_number = cur_len
                max_pkt_id = TSNData_list[cur_len-1].pkt_id
                min_pkt_id = TSNData_list[0].pkt_id

                loss_rate =  (max_pkt_id - min_pkt_id + 1 - cur_len) / (max_pkt_id - min_pkt_id + 1)
            
                # print(seq_id, receive_number, max_pkt_id, min_pkt_id, loss_rate, mean_latency, var_latency)
                print(f"{Color.GREEN}{seq_id:>{10}},{receive_number:>{17}},{Color.YELLOW}{max_pkt_id:>{12}},{min_pkt_id:>{12}},{Color.RED}{loss_rate:>{10}.4f},{Color.BLUE}{mean_latency:>{15}.2f},{var_latency:>{18}.2f}")

                # 计算总的mean variance
                loss_list.append(max_pkt_id - min_pkt_id + 1 - cur_len)
                weight_list.append(receive_number)
                latency_mean_list.append(mean_latency)
                latency_var_list.append(var_latency)
                critical_writer.writerow([seq_id, receive_number, max_pkt_id, min_pkt_id, loss_rate, mean_latency, var_latency])
    length = sum(weight_list)
    total_loss_rate = sum(loss_list) / length 
    total_mean_latency = sum(v * w for v, w in zip(latency_mean_list, weight_list)) / length
    total_var_latency  = sum(u * (w-1) + (w) * (total_mean_latency ** 2 - v ** 2) + 2 * (w) * v * (v - total_mean_latency) for u, v, w in zip(latency_var_list, latency_mean_list,weight_list)) / (length-1)
    print()
    print(f"{Color.MAGENTA}-----------TOTAL STATISTICS-----------")
    print(f"{Color.GREEN}Total Receive Number:{length}, {Color.RED}Total Loss Rate:{total_loss_rate:.2f}, {Color.BLUE}Total Latency Mean:{total_mean_latency:.2f}, Total Latency Variance:{total_var_latency:.2f}")

    # 写入critical csv
    




if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='一个输出包分析数据的简单脚本\n注意本脚本使用的方差为样本方差！！！')
    parser.add_argument('file', help="需要处理的包的名称")
    parser.add_argument('--step', help="处理的时候的步长，默认100", default=100)
    args = parser.parse_args()
    filename, step = args.file, int(args.step)

    # 绑定一个自定义类型
    bind_layers(Ether, TSNCriticalEther, type=0x88b5)

    # data_list = parse_pcapng(filename)
    # analyse_packets(data_list, step)
    # write_data_csv(data_list)
    analyse_packets_pro(filename, step)