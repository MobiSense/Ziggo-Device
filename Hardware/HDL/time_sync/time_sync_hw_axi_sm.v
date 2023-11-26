`timescale 1 ps/1 ps
////////////////////////////////////////////////////////////////////////////////// // Company: 
// Engineer: 
// 
// Create Date: 2021/01/08 15:25:53
// Design Name: 
// Module Name: time_sync_hw_axi_sm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module time_sync_hw_axi_sm (
      input                s_axi_aclk,
      input                s_axi_resetn,

      output reg  [31:0]   s_axi_awaddr = 0,
      output reg           s_axi_awvalid = 0,
      input                s_axi_awready,

      output reg  [31:0]   s_axi_wdata = 0,
      output reg           s_axi_wvalid = 0,
      input                s_axi_wready,

      input       [1:0]    s_axi_bresp,
      input                s_axi_bvalid,
      output reg           s_axi_bready = 0,

      output reg  [31:0]   s_axi_araddr = 0,
      output reg           s_axi_arvalid = 0,
      input                s_axi_arready,

      input       [31:0]   s_axi_rdata,
      input       [1:0]    s_axi_rresp,
      input                s_axi_rvalid,
      output reg           s_axi_rready = 0
);


// main state machine

localparam  START_UP                 = 0,
            RESET_1_1                = 1,
            RESET_1_2                = 8,
            WAIT200_1                = 2,
            SET_PERIOD_1             = 3,
            SET_PERIOD_2             = 4,
            SET_PERIOD_3             = 5,
            SET_PERIOD_4             = 6,
            RESET_2_1                = 9,
            RESET_2_2                = 10,
            FINISH                   = 7;

      
// AXI State Machine
localparam  IDLE                  = 0,
            READ                  = 1,
            WRITE                 = 2,
            DONE                  = 3;



      
// define RTC address values
localparam RTC_CTRL       =32'h00000000;
localparam RTC_NULL_0x04  =32'h00000004;
localparam RTC_NULL_0x08  =32'h00000008;
localparam RTC_NULL_0x0C  =32'h0000000C;
localparam RTC_TIME_SEC_H =32'h00000010;
localparam RTC_TIME_SEC_L =32'h00000014;
localparam RTC_TIME_NSC_H =32'h00000018;
localparam RTC_TIME_NSC_L =32'h0000001C;
localparam RTC_PERIOD_H   =32'h00000020;
localparam RTC_PERIOD_L   =32'h00000024;
localparam RTC_ADJPER_H   =32'h00000028;
localparam RTC_ADJPER_L   =32'h0000002C;
localparam RTC_ADJNUM     =32'h00000030;
localparam RTC_NULL_0x34  =32'h00000034;
localparam RTC_NULL_0x38  =32'h00000038;
localparam RTC_NULL_0x3C  =32'h0000003C;
// define RTC control values
localparam RTC_SET_CTRL_0 =32'h00;
localparam RTC_GET_TIME   =32'h01;
localparam RTC_SET_ADJ    =32'h02;
localparam RTC_SET_PERIOD =32'h04;
localparam RTC_SET_TIME   =32'h08;
localparam RTC_SET_RESET  =32'h10;
// define RTC data values
localparam RTC_SET_PERIOD_H =32'h10;     // 16ns
localparam RTC_SET_PERIOD_L =32'h0;
// define RTC constant
localparam RTC_ACCMOD_H =32'h3B9ACA00;  // 1,000,000,000 for 30bit
localparam RTC_ACCMOD_L =32'h0;         // 256 for 8bit

// define TSU address values
localparam TSU_RXCTRL        =32'h00000040;
localparam TSU_RXQUE_STATUS  =32'h00000044;
localparam TSU_NULL_0x48     =32'h00000048;
localparam TSU_NULL_0x4C     =32'h0000004C;
localparam TSU_RXQUE_DATA_HH =32'h00000050;
localparam TSU_RXQUE_DATA_HL =32'h00000054;
localparam TSU_RXQUE_DATA_LH =32'h00000058;
localparam TSU_RXQUE_DATA_LL =32'h0000005C;
localparam TSU_TXCTRL        =32'h00000060;
localparam TSU_TXQUE_STATUS  =32'h00000064;
localparam TSU_NULL_0x68     =32'h00000068;
localparam TSU_NULL_0x6C     =32'h0000006C;
localparam TSU_TXQUE_DATA_HH =32'h00000070;
localparam TSU_TXQUE_DATA_HL =32'h00000074;
localparam TSU_TXQUE_DATA_LH =32'h00000078;
localparam TSU_TXQUE_DATA_LL =32'h0000007C;
// define TSU control values
localparam TSU_SET_CTRL_0  =32'h00;
localparam TSU_GET_RXQUE   =32'h01;
localparam TSU_SET_RXRST   =32'h02;
localparam TSU_GET_TXQUE   =32'h01;
localparam TSU_SET_TXRST   =32'h02;
// define TSU data values
localparam TSU_MASK_RXMSGID =32'hFF000000;  // FF to enable 0x0 to 0x7
localparam TSU_MASK_TXMSGID =32'hFF000000;  // FF to enable 0x0 to 0x7

// Wire/reg declarations
reg      [4:0]    axi_status;          // used to keep track of axi transactions
      
reg      [31:0]   axi_rd_data;
reg      [31:0]   axi_wr_data;
      
reg      [5:0]    axi_state;           // main state machine to configure example design
      
reg      [1:0]    axi_access_sm;       // axi state machine - handles the 5 channels

reg               start_access;        // used to kick the axi acees state machine
      
reg               writenread;
reg      [31:0]   addr;

reg      [200:0]   count_shift = {201{1'b1}};

reg      [36:0]   serial_command_shift;
reg               load_data;
reg               capture_data;
reg               write_access;
reg               read_access;

wire              s_axi_reset;

reg      [7:0]    wait_counter;

assign s_axi_reset = !s_axi_resetn;

//----------------------------------------------------------------------------
// Management process. This process sets up the configuration by
// turning off flow control, then checks gathered statistics at the
// end of transmission
//----------------------------------------------------------------------------
always @(posedge s_axi_aclk)
begin
   if (s_axi_reset) begin
      axi_state      <= START_UP;
      start_access   <= 0;
      writenread     <= 0;
      addr           <= 0;
      axi_wr_data    <= 0;
   end
   // main state machine is kicking off multi cycle accesses in each state so has to
   // stall while they take place
      
   else if (axi_access_sm == IDLE && !start_access) begin
      case (axi_state)
         START_UP : begin
            // this state will be ran after reset to wait for count_shift
            if (count_shift[200] == 1'b0) begin
               $display("** Note: Time Sync. SM starts.");
               axi_state      <= RESET_1_1;
            end
         end   
         RESET_1_1 : begin
            $display("** Note: RESET RTC.");
            start_access   <= 1;
            writenread     <= 1;
            addr           <= RTC_CTRL;
            axi_wr_data    <= RTC_SET_CTRL_0;
            axi_state      <= RESET_1_2;
         end
         RESET_1_2 : begin
            start_access   <= 1;
            writenread     <= 1;
            addr           <= RTC_CTRL;
            axi_wr_data    <= RTC_SET_RESET;
            wait_counter   <= 0;
            axi_state      <= WAIT200_1;
         end
         WAIT200_1 : begin
            if (wait_counter == 8'hf) begin
               axi_state   <= SET_PERIOD_1;
            end
            else begin
               wait_counter <= wait_counter + 1;
            end
         end
         SET_PERIOD_1 : begin
            $display("** Note: Set period of RTC to 16ns.");
            $display("** Note: Set RTC_PERIOD_H.");
            start_access   <= 1;
            writenread     <= 1;
            addr           <= RTC_PERIOD_H;
            axi_wr_data    <= RTC_SET_PERIOD_H;
            axi_state      <= SET_PERIOD_2;
         end   
         SET_PERIOD_2 : begin
            $display("** Note: Set RTC_PERIOD_L.");
            start_access   <= 1;
            writenread     <= 1;
            addr           <= RTC_PERIOD_L;
            axi_wr_data    <= RTC_SET_PERIOD_L;
            axi_state      <= SET_PERIOD_3;
         end
         SET_PERIOD_3 : begin
            $display("** Note: Set RTC_CTRL to RTC_SET_CTRL_0.");
            start_access   <= 1;
            writenread     <= 1;
            addr           <= RTC_CTRL;
            axi_wr_data    <= RTC_SET_CTRL_0;
            axi_state      <= SET_PERIOD_4;
         end
         SET_PERIOD_4 : begin
            $display("** Note: Set RTC_CTRL to RTC_SET_PERIOD.");
            start_access   <= 1;
            writenread     <= 1;
            addr           <= RTC_CTRL;
            axi_wr_data    <= RTC_SET_PERIOD;
            axi_state      <= FINISH;
         end
         // RESET_2_1 : begin
         //    $display("** Note: RESET RTC.");
         //    start_access   <= 1;
         //    writenread     <= 1;
         //    addr           <= RTC_CTRL;
         //    axi_wr_data    <= RTC_SET_CTRL_0;
         //    axi_state      <= RESET_2_2;
         // end
         // RESET_2_2 : begin
         //    start_access   <= 1;
         //    writenread     <= 1;
         //    addr           <= RTC_CTRL;
         //    axi_wr_data    <= RTC_SET_RESET;
         //    wait_counter   <= 0;
         //    axi_state      <= FINISH;
         // end
         FINISH : begin
             axi_state <= FINISH;
         end
         // program the MAC to the required speed
    //      UPDATE_SPEED : begin
    //         $display("** Note: Programming MAC speed");
            
    //         drive_mdio     <= 0;
            
    //         start_access   <= 1;
    //         writenread     <= 1;
    //         addr           <= SPEED_CONFIG_ADD;
    //         // bits 31:30 are used
    //         axi_wr_data    <= {speed, 30'h0};
      
    //         axi_state      <= MDIO_RD;
                  
    //      end
   
    //      MDIO_RD : begin
    //         // read phy status - if response is all ones then do not perform any
    //         // further MDIO accesses
    //         $display("** Note: Checking for PHY");
    //         drive_mdio     <= 1;   // switch axi transactions to use mdio values..
    //         start_mdio     <= 1;
    //         writenread     <= 0;
    //         mdio_reg_addr  <= PHY_STATUS_REG;
    //         mdio_op        <= MDIO_OP_RD;
    //         axi_state      <= MDIO_POLL_CHECK;
    //      end
    //      MDIO_POLL_CHECK : begin
    //         if (axi_rd_data[16:0] == 17'h1ffff) begin
    //            // if status is all ones then no PHY exists at this address
    //            // (this is used by the tri_mode_ethernet_mac_avb_0_demo_tb to avoid performing lots of phy accesses)
    //            design_on_board <= 1'b0;
    //            axi_state      <= RESET_MAC_RX;
    //            end
    //         else begin
    //            design_on_board <= 1'b1;
    //            axi_state      <= MDIO_1G;
    //            end
    //      end
    //      MDIO_1G : begin
    //         // set 1G advertisement
    //         $display("** Note: Setting PHY 1G advertisement");
    //         start_mdio     <= 1;
    //         mdio_reg_addr  <= PHY_1000BASET_CONTROL_REG;
    //         mdio_op        <= MDIO_OP_WR;
    //         // 0x200 is 1G full duplex, 0x100 is 1G half duplex
    //         // only advertise the mode we want..
    //         axi_wr_data    <= {16'h0, 6'h0, speed[1], 9'h0};
    //         axi_state      <= MDIO_10_100;
    //      end
    //      MDIO_10_100 : begin
    //         // set 10/100 advertisement
    //         $display("** Note: Setting PHY 10/100M advertisement");
    //         start_mdio     <= 1;
    //         mdio_reg_addr  <= PHY_ABILITY_REG;
    //         mdio_op        <= MDIO_OP_WR;
    //         // bit8 : full 100M, bit7 : half 100M, bit6 : full 10M, bit5 : half 10M
    //         // only advertise the mode we want..
    //         axi_wr_data    <= {16'h0, 7'h0, !speed[1] & speed[0], 1'b0, !speed[1] & !speed[0], 6'h0};
    //         axi_state      <= MDIO_PAGE2;
    //      end
    //      MDIO_PAGE2 : begin
    //         // change to page 2
    //         $display("** Note: Setting page");
    //         start_mdio     <= 1;
    //         mdio_reg_addr  <= PHY_PAGE_REG;
    //         mdio_op        <= MDIO_OP_WR;
    //         // bits 7:0 page number - set to 2
    //         axi_wr_data    <= {24'h0, 8'h2};
    //         axi_state      <= MDIO_DELAY_RD;
    //      end
    //      // may not need the following three states
    //      MDIO_DELAY_RD : begin
    //         $display("** Note: Checking current config");
    //         start_mdio     <= 1;
    //         writenread     <= 0;
    //         mdio_reg_addr  <= PHY_MODE_CTL_REG;
    //         mdio_op        <= MDIO_OP_RD;
    //         axi_state      <= MDIO_DELAY_RD_POLL;
    //      end
    //      MDIO_DELAY_RD_POLL : begin
    //         axi_state      <= MDIO_DELAY;
    //         // prepare write_data for the next state
    //         axi_wr_data    <= {16'h0000, axi_rd_data[15:6], 1'b1, 1'b0, axi_rd_data[3:0]}; // either force bits 5 and 4 high or low
    //      end
    //      MDIO_DELAY : begin
    //         // add/remove the clock delay
    //         $display("** Note: Setting PHY RGMII delay - assumes Xilinx Standard Connectivity Board PHY");
    //         start_mdio     <= 1;
    //         mdio_reg_addr  <= PHY_MODE_CTL_REG;
    //         mdio_op        <= MDIO_OP_WR;
    //         axi_state      <= MDIO_RESTART;
    //      end
    //      MDIO_RESTART : begin
    //         // set autoneg and reset
    //         // if loopback is selected then do not set autonegotiate and program the required speed directly
    //         // otherwise set autonegotiate
    //         $display("** Note: Applying PHY software reset");
    //         start_mdio     <= 1;
    //         mdio_reg_addr  <= PHY_CONTROL_REG;
    //         mdio_op        <= MDIO_OP_WR;
    //         if (phy_loopback) begin
    //            // bit15: software reset, bit13 : speed LSB, bit 8 : full duplex, bit 6 : speed MSB
    //            axi_wr_data    <= {16'h0, 2'b10, !speed[1] & speed[0], 4'h0, 1'b1,  1'b0, speed[1], 6'h0};
    //            axi_state   <= MDIO_LOOPBACK;
    //         end
    //         else begin
    //         // bit15: software reset, bit12 : AN enable (set after power up)
    //            axi_wr_data    <= {16'h0, 4'h9, 12'h0};
    //            axi_state   <= MDIO_STATS;
    //         end
    //      end
    //      MDIO_LOOPBACK : begin
    //         // set phy loopback
    //         $display("** Note: Settling PHY Loopback");
    //         start_mdio     <= 1;
    //         mdio_reg_addr  <= PHY_CONTROL_REG;
    //         mdio_op        <= MDIO_OP_WR;
    //         // bit14: loopback, bit13 : speed LSB, bit 8 : full duplex, bit 6 : speed MSB
    //         axi_wr_data    <= {16'h0, 2'b01, !speed[1] & speed[0], 4'h0, 1'b1,  1'b0, speed[1], 6'h0};
    //         axi_state      <= RESET_MAC_RX;
    //      end
    //      MDIO_STATS : begin
    //         start_mdio     <= 1;
    //         $display("** Note: Wait for Autonegotiation to complete");
    //         mdio_reg_addr  <= PHY_STATUS_REG;
    //         mdio_op        <= MDIO_OP_RD;
    //         axi_state      <= MDIO_STATS_POLL_CHECK;
    //      end
    //      MDIO_STATS_POLL_CHECK : begin
    //         // bit 5 is autoneg complete - assume required speed is selected
    //         if (axi_rd_data[5] == 1'b1 && axi_rd_data[16] == 1'b1)
    //            axi_state      <= RESET_MAC_RX;
    //         else
    //            axi_state      <= MDIO_STATS;
    //      end

    //      // once here the PHY is ACTIVE - NOTE only IEEE registers are used
    //      // this state will drive the reset to the example design (apart from this block)
    //      // this will be separately captured and synched into the various clock domains
    //      RESET_MAC_RX : begin
    //         $display("** Note: Reseting MAC RX");
            
    //         drive_mdio     <= 0;
            
    //         start_access   <= 1;
    //         writenread     <= 1;
    //         addr           <= RECEIVER_ADD;
    //         axi_wr_data    <= 32'h90000000;
    //         axi_state      <= RESET_MAC_TX;
    //      end
    //      // this state will drive the reset to the example design (apart from this block)
    //      // this will be separately captured and synched into the various clock domains
    //      RESET_MAC_TX : begin
    //         $display("** Note: Reseting MAC TX");
    //         start_access   <= 1;
    //         writenread     <= 1;
    //         addr           <= TRANSMITTER_ADD;
    //         axi_wr_data    <= 32'h90000000;
            
    //         axi_state      <= CNFG_MDIO;
            
    //      end
            
    //      CNFG_MDIO : begin
    //         // set up MDC frequency. Write 2E to Management configuration
    //         // register (Add=340). This will enable MDIO and set MDC to 2.5MHz
    //         // (set CLOCK_DIVIDE value to 50 dec. for 125MHz s_axi_aclk and
    //         // enable mdio)
    //         $display("** Note: Setting MDC Frequency to 2.5MHZ....");
    //         start_access   <= 1;
    //         writenread     <= 1;
    //         addr           <= CONFIG_MANAGEMENT_ADD;
    //         axi_wr_data    <= 32'h68;
    //         axi_state      <= CNFG_FLOW;
    //      end
         
    //      CNFG_FLOW : begin
    //         $display("** Note: Disabling Flow control....");
    //         start_access   <= 1;
    //         writenread     <= 1;
    //         addr           <= CONFIG_FLOW_CTRL_ADD;
    //         axi_wr_data    <= 32'h0;
    //         axi_state      <= CNFG_FILTER;
    //      end
    //     CNFG_FILTER : begin
         
    //         if (design_on_board == 1'b0) begin
    //             $display("** Note: Setting core to non-promiscuous mode ...");
    //             end
    //         else begin
    //             $display("** Note: Setting core to promiscuous mode ...");
    //         end
    //         start_access   <= 1;
    //         writenread     <= 1;
    //         addr           <= CONFIG_ADDR_CTRL_ADD;
    //         axi_wr_data    <= {design_on_board ,31'h00000000};
    //         axi_state      <= CNFG_FRM_FILTER_1;
    //      end
         
    //      CNFG_FRM_FILTER_1 : begin
    //         $display("** Note: Configuring FRAME FILTER 1 ...");
    //         start_access   <= 1;
    //         writenread     <= 1;
    //         addr           <= CONFIG_FRAME_FILTER_1;
    //         axi_wr_data    <= 32'h040302DA;
    //         axi_state      <= CNFG_FRM_FILTER_MASK_1;
    //      end
    //      CNFG_FRM_FILTER_MASK_1 : begin
    //         $display("** Note: Configuring FRAME FILTER mask 1 ...");
    //         start_access   <= 1;
    //         writenread     <= 1;
    //         addr           <= CONFIG_FRAME_FILTER_MASK_1;
    //         axi_wr_data    <= 32'hFFFFFFFF;
    //         axi_state      <= CNFG_FRM_FILTER_2;
    //      end
    //       CNFG_FRM_FILTER_2 : begin
    //         $display("** Note: Configuring FRAME FILTER 2 ...");
    //         start_access   <= 1;
    //         writenread     <= 1;
    //         addr           <= CONFIG_FRAME_FILTER_2;
    //         axi_wr_data    <= 32'h025A0605;
    //         axi_state      <= CNFG_FRM_FILTER_MASK_2;
    //      end
    //      CNFG_FRM_FILTER_MASK_2 : begin
    //         $display("** Note: Configuring FRAME FILTER mask 2 ...");
    //         start_access   <= 1;
    //         writenread     <= 1;
    //         addr           <= CONFIG_FRAME_FILTER_MASK_2;
    //         axi_wr_data    <= 32'hFFFFFFF;
    //         axi_state      <= CNFG_FRM_FILTER_3;
    //      end
    //      CNFG_FRM_FILTER_3 : begin
    //         $display("** Note: Configuring FRAME FILTER 3 ...");
    //         start_access   <= 1;
    //         writenread     <= 1;
    //         addr           <= CONFIG_FRAME_FILTER_3;
    //         axi_wr_data    <= 32'h06050403;
    //         axi_state      <= CNFG_FRM_FILTER_MASK_3;
    //      end
    //      CNFG_FRM_FILTER_MASK_3 : begin
    //         $display("** Note: Configuring FRAME FILTER mask 3 ...");
    //         start_access   <= 1;
    //         writenread     <= 1;
    //         addr           <= CONFIG_FRAME_FILTER_MASK_3;
    //         axi_wr_data    <= 32'hFFFFFFFF;
    //         axi_state      <= START_RTC;
    //      end
    //      START_RTC : begin
    //         $display("** Note: Starting the Real Time Clock....");
    //         start_access   <= 1;
    //         writenread     <= 1;
    //         addr           <= RTC_INCREMENT_ADDR;
    //         axi_wr_data    <= 32'h00500000;
    //         axi_state      <= WAIT_FOR_MODE;
    //      end
    //      WAIT_FOR_MODE : begin
    //         if (update_speed_reg) begin
    //           axi_state      <= UPDATE_SPEED;
    //           speed          <= mac_speed;
    //         end
    //         else if (gen_tx_data) begin
    //           axi_state    <= TX_PTP;
    //         end
    //      end
    //      TX_PTP : begin
    //         $display("** Note: Transmitting PTP frames....");
    //         start_access   <= 1;
    //         writenread     <= 1;
    //         addr           <= PTP_TX_CONTROL_ADDR;
    //         axi_wr_data    <= 32'h00000003;
    //         axi_state      <= WAIT_FOR_INTERUPT;
    //      end
    //      WAIT_FOR_INTERUPT : begin
    //         if (update_speed_reg) begin
    //           axi_state      <= UPDATE_SPEED;
    //           speed          <= mac_speed;
    //         end
    //         else if (interrupt_ptp_rx) begin
    //           $display("** Note: Received PTP frames....");
    //           axi_state    <= READ_RX_PTP;
    //         end
    //      end
    //      READ_RX_PTP : begin
    //         $display("** Note: Read the type bytes of the rx frame");
    //         start_access   <= 1;
    //         writenread     <= 0;
    //         addr           <= RTC_PTP_RD_OFFSET_TYPE;
    //         axi_state      <= CHECK_RX_PTP;
    //      end
    //      CHECK_RX_PTP : begin
    //         $display("** Note: Check the frame type");
    //         if (axi_rd_data[31:0] == 32'h0210f788 ) begin
    //            $display("** Note: Found a SYNC frame as expected");
    //            axi_state      <= CHECK_SPEED;
    //         end
    //         else begin
    //            $display("** Error: Incorrect frame type found.  Expected a SYNC frame");
    //            // stay in this state so that an error condition is detected in the testbench
    //            axi_state      <= FAILED_CHECK;
    //         end
    //      end
    //      FAILED_CHECK, CHECK_SPEED : begin
    //         if (update_speed_reg) begin
    //           axi_state      <= UPDATE_SPEED;
    //           speed          <= mac_speed;
    //         end
    //         else begin
    //            if (capture_data)
    //               axi_wr_data <= serial_command_shift[33:2];
    //            if (write_access || read_access) begin
    //               addr         <= {5'b0, serial_command_shift[13:2]};
    //               start_access <= 1;
    //               writenread   <= write_access;
    //            end
    //         end
    //      end
      endcase
   end
   else begin
      start_access <= 0;
   end
end
            
//-------------------------------------------------------------------------------------------
// processes to generate the axi transactions - only simple reads and write can be generated

always @(posedge s_axi_aclk)
begin
   if (s_axi_reset) begin
      axi_access_sm <= IDLE;
   end
   else begin
      case (axi_access_sm)
         IDLE : begin
            
            if (start_access) begin
               if (writenread) begin
                  axi_access_sm <= WRITE;
               end
               else begin
                  axi_access_sm <= READ;
               end
            end
         end
         
         WRITE : begin
            // wait in this state until axi_status signals the write is complete
            if (axi_status[4:2] == 3'b111)
               axi_access_sm <= DONE;
         end
         READ : begin
            // wait in this state until axi_status signals the read is complete
            if (axi_status[1:0] == 2'b11)
               axi_access_sm <= DONE;
         end
         DONE : begin
            axi_access_sm <= IDLE;
         end
      endcase
   end
end

// need a process per axi interface (i.e 5)
// in each case the interface is driven accordingly and once acknowledged a sticky
// status bit is set and the process waits until the access_sm moves on
// READ ADDR
always @(posedge s_axi_aclk)
begin
    if (axi_access_sm == READ) begin
        if (!axi_status[0]) begin
            s_axi_araddr   <= addr;
            s_axi_arvalid  <= 1'b1;
            if (s_axi_arready == 1'b1 && s_axi_arvalid) begin
                axi_status[0] <= 1;
                s_axi_araddr      <= 0;
                s_axi_arvalid     <= 0;
            end
        end
    end
    else begin
        axi_status[0]     <= 0;
        s_axi_araddr      <= 0;
        s_axi_arvalid     <= 0;
    end
end

// READ DATA/RESP
always @(posedge s_axi_aclk)
begin
   if (axi_access_sm == READ) begin
      if (!axi_status[1]) begin
         s_axi_rready  <= 1'b1;
         if (s_axi_rvalid == 1'b1 && s_axi_rready) begin
            axi_status[1] <= 1;
            s_axi_rready  <= 0;
            axi_rd_data   <= s_axi_rdata;
         end
      end
   end
   else begin
      s_axi_rready      <= 0;
      axi_status[1]     <= 0;
            
      if (axi_access_sm == IDLE & start_access) begin
         axi_rd_data    <= 0;
      end
   end
end

// WRITE ADDR
always @(posedge s_axi_aclk)
begin
   if (axi_access_sm == WRITE) begin
      if (!axi_status[2]) begin
            
        s_axi_awaddr   <= addr;
         s_axi_awvalid  <= 1'b1;
         if (s_axi_awready == 1'b1 && s_axi_awvalid) begin
            axi_status[2] <= 1;
            s_axi_awaddr      <= 0;
            s_axi_awvalid     <= 0;
         end
      end
   end
   else begin
      s_axi_awaddr      <= 0;
      s_axi_awvalid     <= 0;
      axi_status[2]     <= 0;
   end
end

// WRITE DATA
always @(posedge s_axi_aclk)
begin
   if (axi_access_sm == WRITE) begin
      if (!axi_status[3]) begin
            
        s_axi_wdata   <= axi_wr_data;
        s_axi_wvalid  <= 1'b1;
        if (s_axi_wready == 1'b1 && s_axi_wvalid) begin
            axi_status[3] <= 1;
            s_axi_wvalid     <= 0;
        end
      end
   end
   else begin
      s_axi_wdata      <= 0;
      s_axi_wvalid     <= 0;
      axi_status[3]     <= 0;
   end
end

// WRITE RESP
always @(posedge s_axi_aclk)
begin
   if (axi_access_sm == WRITE) begin
      if (!axi_status[4]) begin
         s_axi_bready  <= 1'b1;
         if (s_axi_bvalid == 1'b1 && s_axi_bready) begin
            axi_status[4] <= 1;
            s_axi_bready     <= 0;
         end
      end
   end
   else begin
      s_axi_bready     <= 0;
      axi_status[4]     <= 0;
   end
end

// //-------------------------------------------------------------------------------------------------------
// // to avoid logic being stripped a serial input is included which enables an address/data and control to be setup for
// // a user config access..
// always @(posedge s_axi_aclk)
// begin
//     if (load_data)
//        serial_command_shift <= {serial_command_shift[35:33], axi_rd_data, serial_command_shift[0], serial_command};
//     else
//        serial_command_shift <= {serial_command_shift[35:0], serial_command};
// end

// // only deassert serial_response once we reach the state in which we can use the serial_command
// assign serial_response = (axi_state == CHECK_SPEED) ? serial_command_shift[35] : 1'b1;

// // the serial command is expected to have a start and stop bit - to avoid a counter -
// // and a two bit code field in the uppper two bits.
// // these decode as follows:
// // 00 - read address
// // 01 - write address
// // 10 - write data
// // 11 - read data - slightly more involved - when detected the read data is registered into the shift and passed out
// // 11 is used for read data as if the input is tied high the output will simply reflect whatever was
// // captured but will not result in any activity
// // it is expected that the write data is setup BEFORE the write address
// always @(posedge s_axi_aclk)
// begin
//     load_data <= 0;
//     capture_data <= 0;
//     write_access <= 0;
//     read_access  <= 0;
//     if (!serial_command_shift[36] & serial_command_shift[35] & serial_command_shift[0])
//        if (serial_command_shift[34] & serial_command_shift[33])       // READ DATA
//           load_data <= 1;
//        else if (serial_command_shift[34] & !serial_command_shift[33]) // WRITE DATA
//           capture_data <= 1;
//        else if (!serial_command_shift[34] & serial_command_shift[33]) // WRITE ADDRESS
//           write_access <= 1;
//        else                                                           // READ ADDRESS
//           read_access <= 1;
// end

// don't reset this  - it will always be updated before it is used..
// it does need an init value (all ones)
always @(posedge s_axi_aclk)
begin
    count_shift <= {count_shift[199:0], s_axi_reset};
end

endmodule
