# CNC User Manual

## 1. 运行脚本前，在batch.mjs中要配置好以下变量：

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

## 2. 下载好Switch和Device的软件代码

>  （记得提前配置好树莓派和所有板子之间的ssh public key，方便免密登录）

```bash
./batch.mjs clone
```

## 3. 拉取最新的软件代码并同步到远程板子上

> 默认时master分支，如果需要指定分支，需要修改batch.mjs文件中的pull()函数，具体参考注释的部分

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

## 4. 使远程所有板子编译代码

```bash
./batch.mjs build
```

## 5. 将配置文件下发到所有板子上

```bash
./batch.mjs distribute
```

## 6. 开始启动所有板子的程序

```bash
./batch.mjs launch
```

## 7. 收集延迟和抖动的统计信息

```bash
./batch.mjs collect
```
