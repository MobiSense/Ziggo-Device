#!/usr/bin/env zx

import { chalk } from "zx"
import { question } from "zx"
const { clock } = require('cli-spinners')
const createLogger = require('progress-estimator')
const logger = createLogger({ spinner: clock })
const fs = require('fs')
// Usage: ./batch.mjs <command> <group>

// IP address format: 192.168.137.*
// 测试数据
// IP address format: 192.168.137.*
// 测试数据
const conf_default = "<需要执行的配置名称>"
// 时钟主节点
const master = 40

const hosts = {
    device: [43, 44],
    switch: [40, 41],
}

// all is the concatenation of all the hosts
hosts.all = hosts.device.concat(hosts.switch)

const log = {
    info: (msg) => {
        console.log(chalk.green(msg))
    },
    error: (msg) => {
        console.log(chalk.red(msg))
    },
    bell: async () => {
        await $`echo -e "\\a done"`
    }
}

const getDateTime = () => {
    const now = new Date()
    const offsetMs = now.getTimezoneOffset() * 60 * 1000
    const dateLocal = new Date(now.getTime() - offsetMs)
    return dateLocal
        .toISOString()
        .slice(0, 19)
        .replaceAll('-', '.')
        .replace('T', '-')
}

// run cmd on single host
// returns a promise
const run = async (host, cmd) => {
    return new Promise(async (resolve, reject) => {
        let result
        try {
            result = await $`ssh root@192.168.137.${host} ${cmd}`
        } catch (p) {
            log.error(`[${host}]: Exit code: ${p.exitCode}`)
            console.log(`[${host}]: Error: ${p.stderr}`)
            reject()
        }

        resolve(result)
    })
}

// run cmd on the group asynchroneously
// returns a promise
const runOn = async (group, cmd) => {
    return Promise.all(hosts[group].map((host) => run(host, cmd)))
}

// clone pkt_gen & time_sync repo in CNC locally
const clone = async () => {
    await $`mkdir -p ~/repos/`
    cd(`${os.homedir()}/repos`)
    await $`git clone https://github.com/Horacehxw/Ziggo-Evaluation-Toolkit.git device;`
    await $`git clone https://github.com/Horacehxw/Ziggo-CaaS-Switch.git switch;`
}


// pull all the latest code
const pull = async () => {
    cd(`${os.homedir()}/repos`)
    await $`cd device; git stash; git checkout master; git pull; cd ..`
    await $`cd switch; git stash; git checkout master; git pull origin master; cd ..`
    

    await Promise.all(hosts.all.map(host => {
        const type = hosts.device.includes(host) ? 'device' : 'switch'

        if (type === 'device') {
            return $`rsync -avPh ${os.homedir}/repos/device/software root@192.168.137.${host}:~/pkt_gen_app/`
        } else if (type === 'switch') {
            return $`rsync -avPh ${os.homedir}/repos/switch/Software/Time-Synchronization root@192.168.137.${host}:~/time_sync_app/;`
        }
    }))
}


// build the project
const build = async () => {
    await Promise.all([
        runOn(
            "device",
            "mkdir -p ~/pkt_gen_app/build/; cd ~/pkt_gen_app/build/; make clean; cmake ../; make"
        ),
        runOn(
            "switch",
            "mkdir -p ~/time_sync_app/build/; cd ~/time_sync_app/build/; make clean; cmake ../; make"
        ),
    ])
    await log.bell()
}

// distribute config file to build dir
const distribute = async (input_flow_path, input_config_path, conf) => {
    conf = conf || conf_default
    // await schedule(input_flow_path, input_config_path, conf)

    cd(`${os.homedir}/scripts/config/`)
    await $`cp ${conf}-schedule.json schedule.json`
    await $`cp ${conf}-config.json config.json`
    return Promise.all(hosts.all.map(host => {
        const type = hosts.device.includes(host) ? 'device' : 'switch'

        if (type === 'device') {
            return $`scp ${os.homedir}/scripts/config/{config,schedule}.json root@192.168.137.${host}:/home/root/pkt_gen_app/build/`
        } else {
            return $`scp ${os.homedir}/scripts/config/{config,schedule}.json root@192.168.137.${host}:/home/root/time_sync_app/build/;`
        }
    }))
}

// launch device running
const runDevice = async (date) => {
    return new Promise(async (resolve, reject) => {
        log.info("Start device")
        // time sync log
        const ts_filename = date + "-timesync.log"
        await Promise.all(
            hosts.device.map((host) =>
                run(
                    host,
                    "rm ~/pkt_gen_app/build/critical_log.csv 2>/dev/null; cd ~/pkt_gen_app/build/; screen -dmS task -L -Logfile " +
                    ts_filename +
                    " bash -c './time_sync; exec sh'"
                )
            )
        )
        log.info("devices started")
        resolve()
    })
}

// launch switch running
const runSwitch = async (date) => {
    return new Promise(async (resolve, reject) => {
        log.info("Start switches")
        // device: time_sync
        // switch: time_sync -> 主节点要最后
        // time sync log
        const ts_filename = date + "-timesync.log"
        await Promise.all(
            hosts.switch.map((host) => {
                const extra = host === master ? "sleep 1;" : ""
                return run(
                    host,
                    extra +
                    "cd ~/time_sync_app/build/; screen -dmS task -L -Logfile " +
                    ts_filename +
                    " bash -c './time_sync; exec sh'"
                )
            })
        )
        log.info("switches started")
        resolve(date)
    })
}

const checkTimeSync = async (date) => {
    return new Promise(async (resolve, reject) => {
        const ts_filename = date + "-timesync.log"

        log.info("Checking time sync running state")
        // check running state
        let all_found = true
        for (const host of hosts.all) {
            const type = hosts.device.includes(host) ? "device" : "switch"
            const filepath =
                (type === "device"
                    ? "~/pkt_gen_app/build/"
                    : "~/time_sync_app/build/") + ts_filename

            const output = (await run(host, "cat " + filepath)).toString()
            const found = output.indexOf("******Sync Time******") > -1
            const not_match = output.indexOf("not match") > -1

            if (found && !not_match) {
                log.info(`${type} 192.168.137.${host}: time synced`)
            } else {
                all_found = false
                if (not_match) {
                    log.error(`${type} 192.168.137.${host} not_match`)
                }
                if (!found) {
                    log.error(`${type} 192.168.137.${host} is not time synced`)
                }
                reject(`${type} not synced`)
                return
            }
        }

        log.info(`time sync successfully`)
        resolve(true)
    })
}

const runPktGen = async (date) => {
    return new Promise(async (resolve, reject) => {
        log.info("Start pkt_gen")
        // start pkt_gen
        // packet gen log
        const pg_filename = date + "-pktgen.log"

        await Promise.all(
            hosts.device.map((host) =>
                run(
                    host,
                    "cd ~/pkt_gen_app/build/; screen -dmS task_pkt -L -Logfile " +
                    pg_filename +
                    " bash -c './pkt_gen; exec sh'"
                )
            )
        )
        log.info("pkt_gen started")
        resolve()
    })
}


const power = async (action) => {
    const flags = [
        'device',
        '--ip',
        '11.11.128.16',
        '--token',
        '2aa99f046bcc7f9875d733449b5e542d',
        'raw_command',
    ]


    if (typeof (action) === 'undefined' || ['on', 'off'].includes(action) === false) {
        const cmd = `[{'did': 'MYDID', 'siid': 2, 'piid': 1}]`

        const result = (await $`miiocli ${flags} get_properties ${cmd}`).toString()
        let state = 'unknown'
        let isOn = false
        if (result.indexOf('True') > -1) {
            state = 'on ✅'
            isOn = true
        } else if (result.indexOf('False') > -1) {
            state = 'off ❎'
            isOn = false
        }

        log.info('power: ' + state)
        return isOn
    }
    
    const arg = action === 'on' ? 'True' : 'False'
    const cmd = `[{'did': 'MYDID', 'siid': 2, 'piid': 1, 'value': ${arg}}]`
    
    log.info('set power: ' + action)
    await $`miiocli ${flags} set_properties ${cmd}`
}

const warmup = async () => {
    try {
        await runOn("all", "date")
    } catch(p) {
        log.error(p)
        log.error('warmup failed, cannot run on all hosts')
    }
}

const launch = async () => {
    const date = getDateTime()

    await Promise.all([runDevice(date), runSwitch(date)])
    log.info("device and switch started")

    // wait for 10 secs
    await wait(10, "waiting for checking")

    await checkTimeSync(date)
    log.info("device and switch synced")

    await runPktGen(date)
}

const collect = async (date, log_dir) => {
    date = date || getDateTime()
    log_dir = log_dir || `${os.homedir()}/logs/device/${date}`
    // wait 5mins

    // await runOn('device', 'cd ~/pkt_gen_app/build; scp ')

    // cd device:pkt_gen/build
    // get critical_log.csv
    await $`mkdir -p ${log_dir}`

    for (const host of hosts.device) {
        const log_name = `${log_dir}/critical_log_${host}.csv`

        try {
            await $`scp root@192.168.137.${host}:~/pkt_gen_app/build/critical_log.csv ${log_name} 2>/dev/null`

            const header = (await $`cat ${log_name} | head -n1`).stdout.replace(/ /g, "\t")
            const latency = (await $`cat ${log_name} | tail -n5`).stdout.replace(/ /g,"\t")
            log.info(`device ${host} latency: \n${header}${latency}`)    
        } catch (p) {
            log.info(`device ${host} has no critical log`)
        }
    }

    // "Seq ID, Received Number, Max pkt_id, Min pkt_id, Loss Rate, Latency Mean, Latency Variance\r\n"
    // check whether `Latency Mean` last a few lines are greater than 100000000
}

// const restart = async () => {
//     const isOn = await power()

//     if (isOn) {
//         try {
//             await runOn('all', '/bin/sync')
//         } catch (e) {
//             log.error(e)
//         }
//         log.info('restarting')
//         await power('off')
//         await wait(5, 'waiting for restart')
//     } else {
//         log.info('starting')
//     }

//     await power('on')
    
//     await wait(15, 'waiting for waking up')
//     await warmup()
//     log.info('restarted')
// }

const restart = async () => {
    const all = [...hosts.all]
    all.sort()

    try {
        await runOn('all', '/bin/sync')
    } catch (e) {
        log.error(e)
    }

    await Promise.all(all.map((host) => run(host, "/sbin/reboot")))

    await wait(20, "waiting for rebooting")
    await warmup()
    all.reverse()

    await Promise.all(all.map((host) => run(host, "/sbin/reboot")))
    await wait(20, "waiting for rebooting")
    await warmup()
    log.info('restarted')
}


// wait for time seconds
const wait = async (time, msg) => {
    time = time || 1
    msg = msg || ('waiting for ' + time + ' seconds')
    const time_ms = time * 1000

    return logger(sleep(time_ms), msg, { estimate: time_ms }).then(time > 5 ? log.bell : 0)
}

const help = async () => {
    console.log(chalk.cyan("commands: " + Object.keys(methods).join(", ")))
}

// call internal command
const execute = async (cmd, args) => {
    const method = methods[cmd]
    if (method) {
        try {
            if (args.length > 0) {
                await method(...args)
            } else {
                await method()
            }
        } catch (e) {
            log.error(e)
        }
    } else {
        console.log("unknown command")
    }
}

const methods = {
    clone,
    pull,
    build,
    distribute,
    runDevice,
    runSwitch,
    collect,
    runOn,
    launch,
    power,
    restart,
    warmup,
    wait,
    help,
};

//error handling code within middleware
process.on('uncaughtException', err => {
    log.error(`global error: ${err.toString()}`)
});

(async () => {
    help()
    const args = process.argv.slice(2)

    if (args.length > 1) {
        // run from command line
        args.shift()
        const cmd = args.shift()
        await execute(cmd, args)

        return
    }

    while (true) {
        // run from interactive mode
        const input = await question("> ", {
            choices: Object.keys(methods)
        })

        const args = input.split(" ")
        const cmd = args.shift()

        await execute(cmd, args)
    }
})()
