#  互联互通测试TestBed搭建流程

## TestBed简单介绍
我们内部对自己研发的Switch进行了Qbv互联互通测试，采用的网络拓扑如下所示。
（图中的SW代表ZIGGO交换机，Device0可以使用普通Linux PC，Device1代表ZIGGO Evaluation Toolkit）
![topo](../figs/topo.PNG)

该拓扑由三个Device和两个Switch组成，Device 0负责发送背景流量，路径为黑色箭头；Device 1负责发送测试流量（关键流量），路径为红色箭头。

## 互联互通测试项目介绍
### 1. 基准测试
- 目的：测试无背景流量情况下，高优先级流量的两跳端到端延迟、丢包率、抖动，作为比较基准。
- 预期：延迟符合规划，抖动较低（100ns左右）。

### 2. 门控能力
- 目的：测试通用情况下流量调度效果，和两个交换机的门控对接能力。
- 方案：
  背景流量（VLAN priority = 0）打到线速，每个调度周期预留长度为 3 的时隙给高优先级流量，
  1. 每个周期定时发送 4 个数据包长度为 1500Byte 的高优先级（VLAN priority = 1）测试流量，记录端到端平均延迟、抖动、丢包率、到达顺序
  2. 每个周期定时发送 8 个数据包长度为 1500Byte 的高优先级（VLAN priority = 1）测试流量，记录是否每个周期通过且仅 n 个包
- 预期：
  1. 延迟、抖动、丢包率和基准一致
  2. 每个周期定时发送 4 个数据包时，丢包率为0
  3. 每个周期定时发送 8 个数据包时，每个周期通过且仅通过 5 个包（每8个包丢3个，因为每个时隙里恰好可以把第五个包发出去，余下三个包丢掉），丢包率为37.5%

### 3. 带宽保证
- 目的：测试交换机能够进行带宽预留，且两个交换机优先级映射、运行 cycle 和 offset 基本一致。
- 方案：
  背景流量（VLAN priority = 0）打到线速（1Gbps），配置交换机预留 50% 时隙给高优先级流量（VLAN priority = 1），其余 50% 只允许低优先级流量，
  1. 测试流量高优先级（VLAN priority = 1）情况下打到线速（经测试，每个周期[33ms]连续发送2752个1500B的包，基本达到1000Mbps），记录端到端平均延迟、抖动、丢包率、到达顺序
  2. 测试流量高优先级（VLAN priority = 1）情况下打到50%线速（每个周期[33ms]连续发送1376个1500B的包），记录端到端平均延迟、抖动、丢包率、到达顺序
- 预期：
  1. 高优先级测试流量100%线速：延迟、抖动和基准一致，丢包率 50% 左右
  2. 高优先级测试流量50%线速：延迟、抖动和基准一致，0丢包率

### 4. 门控精度
- 目的：测试门控时隙长度的设置精度
- 方案：(n=1,2,4,8,...)
  1. 每个调度周期预留长度为 1 的时隙给高优先级流量
  2. 每个周期发送 n 个数据包长度为1/n*1500Byte的高优先级（VLAN priority = 1）测试流量，记录是否每个周期通过 n 个包
    1. n=1, 
- 预期：
  1. n=1,2,4,8 情况下都能每个周期通过且仅通过 n 个包

> 如果您按照下文的配置使用我们开源的ZIGGO交换机和Evalution Toolkit，则您可以在上面四个测试中得到和预期相类似的效果。如果出现了任何问题，欢迎在github上提出issue。

## 设备参数设置与部署

Switch软硬件代码在仓库 【TODO】中，使用主分支即可。

Evaluation Toolkit的软硬件代码在本仓库。
> 注意：带宽能力测试中的Toolkit需要使用offline_analyze分支，门控精度测试中的Toolkit需要使用packet_resize分支【用于自定义测试包大小】。测试中请勿忘记切换分支。

所有设备的IP、MAC和ID如下所示，与本文档后面提供的JSON配置文件对应：

![topo config](../figs/topo_config.png)

对应的config文件可见`config.json`

## TestBed运行流程

### 1 准备工作
#### 控制脚本准备
1. 运行脚本前，在batch.mjs中要配置好以下变量：
```javascript
// IP address format: 192.168.137.*
// 测试数据
const conf_default = "<需要执行的配置名称>"
// 时钟主节点
const master = 40

const hosts = {
    device: [43, 44],
    switch: [40, 41],
}
```

安装好需要的依赖：
```bash
sudo npm install -g zx@4.3.0
pip install -r requirements.txt
npm install
```
配置好环境变量，在.bashrc中加入：
```bash
export PYTHONPATH="/home/<用户名>/scripts"
```
2. 下载好Switch和Toolkit的软件代码（记得提前配置好树莓派和所有板子之间的ssh public key，方便免密登录）
```bash
./batch.mjs clone
```

3. 拉取最新的软件代码并同步到远程板子上，默认时master分支，如果需要指定分支，需要修改batch.mjs文件中的pull()函数，具体参考注释的部分
```javascript
// pull all the latest code
const pull = async () => {
    cd(`${os.homedir()}/repos`)
    // 如果需要指定分支，类似下面指定qbv-test分支的操作
    // await $`cd pkt_gen_app; git stash; git checkout qbv-test; git pull origin qbv-test; cd ..`
    // await $`cd time_sync_app; git stash; git checkout qbv-test; git pull origin qbv-test; cd ..`

    await Promise.all(hosts.all.map(host => {
        const type = hosts.device.includes(host) ? 'device' : 'switch'

        if (type === 'device') {
            return $`rsync -avPh ${os.homedir}/repos/pkt_gen_app root@192.168.137.${host}:~/`
        } else if (type === 'switch') {
            return $`rsync -avPh ${os.homedir}/repos/time_sync_app root@192.168.137.${host}:~/;`
        }
    }))
}
```
同步到所有板子上：
```bash
./batch.mjs pull
```

4. 使远程所有板子编译代码
```bash
./batch.mjs build
```
5. 将配置文件下发到所有板子上
```bash
./batch.mjs distribute
```
6. 开始启动所有板子的程序
```bash
./batch.mjs launch
```
7. 收集延迟和抖动的统计信息
```bash
./batch.mjs collect
```

> 注意，带宽保证测试无法使用此项，因为数据包需要转到PC上进行分析，请使用offline_analyze分支

#### 背景流量发送
可以直接在Linux PC中运行`send.py`脚本。（需要安装scapy,tcpreplay）

### 基准测试
Switch Toolkit 的软硬件都使用主分支。

测试步骤：
1. 修改batch.mjs修改正确的配置文件名
2. ./batch.mjs pull（注意分支正确）
3. ./batch.mjs distribute
  Device每次发送4个数据包，每个Switch都预留了3个时隙，将以下两个配置文件下发即可：
  `base/d3s2-baseline-3t-config.json`，
  `base/d3s2-baseline-3t-schedule-base.json`
4. ./batch.mjs launch
5. ./batch.mjs collect

### 门控能力
Switch Toolkit 的软硬件都使用主分支。

1. 让背景流量Device发包（基准测试不需要发送背景流量）
2. 修改batch.mjs修改正确的配置文件名
3. ./batch.mjs pull（注意分支正确）
4. ./batch.mjs distribute
  Device1每次发送4个数据包，每个Switch都预留了3个时隙，将以下两个配置文件下发即可：
  `gate/d3s2-baseline-3t-config.json`，
  `gate/d3s2-baseline-3t-schedule-gate.json`
5. ./batch.mjs launch
6. ./batch.mjs collect
7. 将上述的schedule.json中的Device发包个数从4改为8，再从上述步骤4重新测试，修改后的schedule.json如下所示

```json
{
    "type": "link",
    "from": 3,
    "to": 0,
    "from_port": 0,
    "id": 7,
    "schedule": [
        {
            "period": 2048,
            "start": 0,
            "end": 8,
            "job_id": 1,
            "flow_id": 1
        }
    ]
},
```

### 带宽保证
Switch代码使用主分支，Toolkit代码使用offline_analyze分支。

测试步骤：
1. 让背景流量Device发包（基准测试不需要发送背景流量）
2. 修改batch.mjs修改正确的配置文件名
3. ./batch.mjs pull（注意分支正确）
4. ./batch.mjs distribute
  Device1每次发送1376个数据包，每个Switch都预留了1024个时隙，将以下两个配置文件下发即可：
  `bandwidth/d3s2-baseline-50%t-config.json`，
  `bandwidth/d3s2-baseline-50%t-schedule.json`
5. ./batch.mjs launch
6. 使用离线分析
7. 将上述的schedule.json中的Device发包个数从1376改为2752，再从上述步骤4重新测试，修改后的schedule.json如下所示
```json
{
    "type": "link",
    "from": 3,
    "to": 0,
    "from_port": 0,
    "id": 7,
    "schedule": [
        {
            "period": 2048,
            "start": 0,
            "end": 2752,
            "job_id": 1,
            "flow_id": 1
        }
    ]
},
```

### 门控精度
Switch代码使用主分支，Toolkit代码使用packet_resize分支。
1. 修改batch.mjs修改正确的配置文件名
2. ./batch.mjs pull（注意分支正确）
3. ./batch.mjs distribute
  Device1每次发送1个1500B的数据包，每个Switch都预留了1个时隙，将以下两个配置文件下发即可：
  `accuracy/d3s2-baseline-1t-config.json`，
  `accuracy/d3s2-baseline-1t-schedule.json`
4. ./batch.mjs launch
5. ./batch.mjs collect
6. 将上述的schedule.json中的Device发包个数从1分别改为2,4,8，包长度分别改为750, 375和187，再从上述步骤4重新测试，发包个数修改为2后的schedule.json如下所示
```json
{
    "type": "link",
    "from": 3,
    "to": 0,
    "from_port": 0,
    "id": 7,
    "schedule": [
        {
            "period": 2048,
            "start": 0,
            "end": 2, 
            "pkt_size": 750, // 1500/2 = 750 
            "job_id": 1,
            "flow_id": 1
        }
    ]
},
```
