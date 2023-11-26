<!--
 * @Date: 2021-12-12 18:58:15
 * @LastEditors: Jiahang Wu
 * @LastEditTime: 2022-03-13 14:06:35
 * @FilePath: \tsn_drivers\README.md
 * @Description: 
-->
# tsn_drivers

This repo contains some uio drivers to operate:
- GCL: GCL values and time intervals.
- RTC: get and set RTC timestamp.
- TSU: get TX/RX timestamp.
- Tagger: enable/disable the tagger VLAN header.
- GPIO reset: reset PL by GPIO EMIO.

## Usage
The main function is in `time_sync_main_loop.c`. You can modify this file to test.

- Compile  
    this script will compile the files and generate executable file - `main` .
    ```
    ./compile.sh
    ```

- Run
    ```
    ./main
    ```