-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
-- Date        : Sun Nov 28 19:51:26 2021
-- Host        : Horace-TNS-win10 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top mult_1e9_gen_0 -prefix
--               mult_1e9_gen_0_ mult_1e9_gen_0_stub.vhdl
-- Design      : mult_1e9_gen_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mult_1e9_gen_0 is
  Port ( 
    A : in STD_LOGIC_VECTOR ( 31 downto 0 );
    P : out STD_LOGIC_VECTOR ( 63 downto 0 )
  );

end mult_1e9_gen_0;

architecture stub of mult_1e9_gen_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "A[31:0],P[63:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "mult_gen_v12_0_16,Vivado 2020.1";
begin
end;
