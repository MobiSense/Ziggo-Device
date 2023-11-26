from scapy.all import Ether, sendpfast, IP, TCP

# 创建一个以太网数据帧
eth_frame = Ether(src='11:11:11:11:11:11', dst='22:22:22:22:22:22', type='IPv4') / IP() / TCP()/ "eraser!!!"

# 替换为您的网络接口名称
sendpfast(eth_frame, iface="enx000ec674f78b", mbps=1000, loop=1e10)  
