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
// Simulation of tsu together with rgs. 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module time_sync_hw_axi_sm_2 (
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
            SET_MSG_MASK_1                = 1,
            SET_MSG_MASK_2                = 2,
            TSU_RESET_1                   = 3,
            TSU_RESET_2                 = 4,
            TSU_RESET_3                 = 5,
            TSU_RESET_4                 = 6,
            READ_N_QUEUE_1              = 7,
            READ_N_QUEUE_2              = 8,
            READ_TSU_DATA_1              = 9,
            READ_TSU_DATA_2              = 10,
            READ_TSU_DATA_3              = 11,
            READ_TSU_DATA_4              = 12,
            READ_TSU_DATA_5              = 13,
            READ_TSU_DATA_6              = 14,
            READ_TSU_DATA_7              = 15,
            READ_TSU_DATA_8              = 16,
            READ_TSU_DATA_9              = 17,
            RTC_RESET_1                 = 18,
            RTC_RESET_2                 = 19;

      
// AXI State Machine
localparam  IDLE                  = 0,
            READ                  = 1,
            WRITE                 = 2,
            DONE                  = 3;



      
// define RTC address values
localparam RTC_CTRL       =32'h43C00000;
localparam RTC_NULL_0x04  =32'h43C00004;
localparam RTC_NULL_0x08  =32'h43C00008;
localparam RTC_NULL_0x0C  =32'h43C0000C;
localparam RTC_TIME_SEC_H =32'h43C00010;
localparam RTC_TIME_SEC_L =32'h43C00014;
localparam RTC_TIME_NSC_H =32'h43C00018;
localparam RTC_TIME_NSC_L =32'h43C0001C;
localparam RTC_PERIOD_H   =32'h43C00020;
localparam RTC_PERIOD_L   =32'h43C00024;
localparam RTC_ADJPER_H   =32'h43C00028;
localparam RTC_ADJPER_L   =32'h43C0002C;
localparam RTC_ADJNUM     =32'h43C00030;
localparam RTC_NULL_0x34  =32'h43C00034;
localparam RTC_NULL_0x38  =32'h43C00038;
localparam RTC_NULL_0x3C  =32'h43C0003C;
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
localparam PORT_3_TSU_RXCTRL        =32'h00000100;
localparam PORT_3_TSU_RXQUE_STATUS  =32'h00000104;
localparam PORT_3_TSU_NULL_0x48     =32'h00000108;
localparam PORT_3_TSU_NULL_0x4C     =32'h0000010C;
localparam PORT_3_TSU_RXQUE_DATA_HH =32'h00000110;
localparam PORT_3_TSU_RXQUE_DATA_HL =32'h00000114;
localparam PORT_3_TSU_RXQUE_DATA_LH =32'h00000118;
localparam PORT_3_TSU_RXQUE_DATA_LL =32'h0000011C;
localparam PORT_3_TSU_TXCTRL        =32'h00000120;
localparam PORT_3_TSU_TXQUE_STATUS  =32'h00000124;
localparam PORT_3_TSU_NULL_0x68     =32'h00000128;
localparam PORT_3_TSU_NULL_0x6C     =32'h0000012C;
localparam PORT_3_TSU_TXQUE_DATA_HH =32'h00000130;
localparam PORT_3_TSU_TXQUE_DATA_HL =32'h00000134;
localparam PORT_3_TSU_TXQUE_DATA_LH =32'h00000138;
localparam PORT_3_TSU_TXQUE_DATA_LL =32'h0000013C;
// define TSU control values
localparam TSU_SET_CTRL_0  =32'h00;
localparam TSU_GET_QUE   =32'h01;
localparam TSU_SET_RST   =32'h02;
// define TSU data values
localparam TSU_MASK_RXMSGID =32'h0D000000;  // FF to enable 0x0 to 0x7
localparam TSU_MASK_TXMSGID =32'h0D000000;  // FF to enable 0x0 to 0x7

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
               axi_state      <= RTC_RESET_1;
            end
         end   
         RTC_RESET_1 : begin
            $display("** Note: Reset RTC.");
            start_access   <= 1;
            writenread     <= 1;
            addr           <= RTC_CTRL;
            axi_wr_data    <= RTC_SET_CTRL_0;
            axi_state      <= RTC_RESET_2;
         end
         RTC_RESET_2 : begin
            start_access   <= 1;
            writenread     <= 1;
            addr           <= RTC_CTRL;
            axi_wr_data    <= RTC_SET_RESET;
            axi_state      <= SET_MSG_MASK_1;
         end
         SET_MSG_MASK_1 : begin
            $display("** Note: SET Port 3 msg mask.");
            start_access   <= 1;
            writenread     <= 1;
            addr           <= PORT_3_TSU_RXQUE_STATUS;
            axi_wr_data    <= TSU_MASK_RXMSGID;
            axi_state      <= SET_MSG_MASK_2;
         end
         SET_MSG_MASK_2 : begin
            start_access   <= 1;
            writenread     <= 1;
            addr           <= PORT_3_TSU_TXQUE_STATUS;
            axi_wr_data    <= TSU_MASK_TXMSGID;
            axi_state      <= TSU_RESET_1;
         end
         TSU_RESET_1 : begin
            start_access   <= 1;
            writenread     <= 1;
            addr           <= PORT_3_TSU_RXCTRL;
            axi_wr_data    <= TSU_SET_CTRL_0;
            axi_state      <= TSU_RESET_2;
         end
         TSU_RESET_2 : begin
            start_access   <= 1;
            writenread     <= 1;
            addr           <= PORT_3_TSU_RXCTRL;
            axi_wr_data    <= TSU_SET_RST;
            axi_state      <= TSU_RESET_3;
         end
         TSU_RESET_3 : begin
            start_access   <= 1;
            writenread     <= 1;
            addr           <= PORT_3_TSU_TXCTRL;
            axi_wr_data    <= TSU_SET_CTRL_0;
            axi_state      <= TSU_RESET_4;
         end
         TSU_RESET_4 : begin
            start_access   <= 1;
            writenread     <= 1;
            addr           <= PORT_3_TSU_TXCTRL;
            axi_wr_data    <= TSU_SET_RST;
            axi_state      <= READ_N_QUEUE_1;
         end
         READ_N_QUEUE_1: begin
            $display("Check n queue.");
            start_access   <= 1;
            writenread     <= 0; 
            addr           <= PORT_3_TSU_RXQUE_STATUS;
            axi_state      <= READ_N_QUEUE_2;
         end
         READ_N_QUEUE_2: begin
             if ((axi_rd_data & 32'h00FF_FFFF) == 0) begin
                 axi_state <= READ_N_QUEUE_1;
             end
             else begin
                 axi_state <= READ_TSU_DATA_1;
             end
         end
         READ_TSU_DATA_1 : begin
            start_access   <= 1;
            writenread     <= 1;
            addr           <= PORT_3_TSU_RXCTRL;
            axi_wr_data    <= TSU_SET_CTRL_0;
            axi_state      <= READ_TSU_DATA_2;
         end
         READ_TSU_DATA_2 : begin
            start_access   <= 1;
            writenread     <= 1;
            addr           <= PORT_3_TSU_RXCTRL;
            axi_wr_data    <= TSU_GET_QUE;
            axi_state      <= READ_TSU_DATA_3;
         end
         READ_TSU_DATA_3: begin
            $display("Check get que.");
            start_access   <= 1;
            writenread     <= 0; 
            addr           <= PORT_3_TSU_RXCTRL;
            axi_state      <= READ_TSU_DATA_4;
         end
         READ_TSU_DATA_4: begin
             if ((axi_rd_data & TSU_GET_QUE) == 0) begin
                 axi_state <= READ_TSU_DATA_3;
             end
             else begin
                 axi_state <= READ_TSU_DATA_5;
             end
         end
         READ_TSU_DATA_5: begin
            start_access   <= 1;
            writenread     <= 0; 
            addr           <= PORT_3_TSU_RXQUE_DATA_HH;
            axi_state      <= READ_TSU_DATA_6;
         end
         READ_TSU_DATA_6: begin
            $display("DATA HH: %H", axi_rd_data);
            start_access   <= 1;
            writenread     <= 0; 
            addr           <= PORT_3_TSU_RXQUE_DATA_HL;
            axi_state      <= READ_TSU_DATA_7;
         end
         READ_TSU_DATA_7: begin
            $display("DATA HL: %H", axi_rd_data);
            start_access   <= 1;
            writenread     <= 0; 
            addr           <= PORT_3_TSU_RXQUE_DATA_LH;
            axi_state      <= READ_TSU_DATA_8;
         end
         READ_TSU_DATA_8: begin
            $display("DATA LH: %H", axi_rd_data);
            start_access   <= 1;
            writenread     <= 0; 
            addr           <= PORT_3_TSU_RXQUE_DATA_LL;
            axi_state      <= READ_TSU_DATA_9;
         end
         READ_TSU_DATA_9: begin
            $display("DATA LL: %H", axi_rd_data);
            axi_state      <= READ_N_QUEUE_1;
         end
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
