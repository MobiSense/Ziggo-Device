-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
-- Date        : Mon Apr 25 21:27:10 2022
-- Host        : DESKTOP-5H7SBV0 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim -rename_top axis_switch_2_1 -prefix
--               axis_switch_2_1_ axis_switch_0_sim_netlist.vhdl
-- Design      : axis_switch_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg484-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axis_switch_2_1_axis_switch_v1_1_21_arb_rr is
  port (
    s_axis_tready : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \arb_gnt_r_reg[0]_0\ : out STD_LOGIC;
    s_axis_tvalid_0_sp_1 : out STD_LOGIC;
    \arb_gnt_r_reg[1]_0\ : out STD_LOGIC;
    \gen_tdest_routing.busy_ns\ : out STD_LOGIC;
    \gen_tdest_routing.busy_ns_0\ : out STD_LOGIC;
    m_axis_tvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_tlast : out STD_LOGIC_VECTOR ( 0 to 0 );
    \port_priority_r_reg[0]_0\ : in STD_LOGIC;
    aclken : in STD_LOGIC;
    aclk : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC_VECTOR ( 1 downto 0 );
    \gen_tdest_router.busy_r\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axis_tready : in STD_LOGIC_VECTOR ( 0 to 0 );
    valid_i : in STD_LOGIC;
    \arb_req_i__1\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    \gen_tdest_routing.busy_r_reg[0]\ : in STD_LOGIC;
    \gen_tdest_routing.busy_r_reg[0]_0\ : in STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axis_tlast : in STD_LOGIC_VECTOR ( 1 downto 0 );
    \arb_gnt_r_reg[1]_1\ : in STD_LOGIC
  );
end axis_switch_2_1_axis_switch_v1_1_21_arb_rr;

architecture STRUCTURE of axis_switch_2_1_axis_switch_v1_1_21_arb_rr is
  signal arb_busy_ns : STD_LOGIC;
  signal arb_busy_r : STD_LOGIC;
  signal arb_busy_r_i_5_n_0 : STD_LOGIC;
  signal \arb_gnt_r[0]_i_1_n_0\ : STD_LOGIC;
  signal \arb_gnt_r[1]_i_1_n_0\ : STD_LOGIC;
  signal \arb_gnt_r[1]_i_3_n_0\ : STD_LOGIC;
  signal \^arb_gnt_r_reg[0]_0\ : STD_LOGIC;
  signal \^arb_gnt_r_reg[1]_0\ : STD_LOGIC;
  signal arb_sel_i : STD_LOGIC;
  signal \arb_sel_r[0]_i_1_n_0\ : STD_LOGIC;
  signal \barrel_cntr[0]_i_1_n_0\ : STD_LOGIC;
  signal \barrel_cntr_reg_n_0_[0]\ : STD_LOGIC;
  signal \m_axis_tvalid[0]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal port_priority_ns : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \port_priority_r[0]_i_1_n_0\ : STD_LOGIC;
  signal \port_priority_r[1]_i_1_n_0\ : STD_LOGIC;
  signal s_axis_tvalid_0_sn_1 : STD_LOGIC;
  signal sel_i : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of arb_busy_r_i_1 : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of arb_busy_r_i_5 : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \gen_tdest_routing.busy_r[0]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \m_axis_tdata[0]_INST_0\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \m_axis_tdata[1]_INST_0\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \m_axis_tdata[2]_INST_0\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \m_axis_tdata[3]_INST_0\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \m_axis_tdata[4]_INST_0\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \m_axis_tdata[5]_INST_0\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \m_axis_tdata[6]_INST_0\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \m_axis_tdata[7]_INST_0\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \m_axis_tvalid[0]_INST_0_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \s_axis_tready[0]_INST_0\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \s_axis_tready[1]_INST_0\ : label is "soft_lutpair1";
begin
  \arb_gnt_r_reg[0]_0\ <= \^arb_gnt_r_reg[0]_0\;
  \arb_gnt_r_reg[1]_0\ <= \^arb_gnt_r_reg[1]_0\;
  s_axis_tvalid_0_sp_1 <= s_axis_tvalid_0_sn_1;
arb_busy_r_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BA"
    )
        port map (
      I0 => valid_i,
      I1 => s_axis_tvalid_0_sn_1,
      I2 => arb_busy_r,
      O => arb_busy_ns
    );
arb_busy_r_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EE00E0E000000000"
    )
        port map (
      I0 => arb_busy_r_i_5_n_0,
      I1 => \m_axis_tvalid[0]_INST_0_i_1_n_0\,
      I2 => s_axis_tvalid(0),
      I3 => s_axis_tvalid(1),
      I4 => arb_sel_i,
      I5 => m_axis_tready(0),
      O => s_axis_tvalid_0_sn_1
    );
arb_busy_r_i_5: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \^arb_gnt_r_reg[0]_0\,
      I1 => \gen_tdest_router.busy_r\(0),
      O => arb_busy_r_i_5_n_0
    );
arb_busy_r_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => aclken,
      D => arb_busy_ns,
      Q => arb_busy_r,
      R => \port_priority_r_reg[0]_0\
    );
\arb_gnt_r[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000030000000AAAA"
    )
        port map (
      I0 => \^arb_gnt_r_reg[0]_0\,
      I1 => sel_i,
      I2 => valid_i,
      I3 => \arb_gnt_r[1]_i_3_n_0\,
      I4 => \port_priority_r_reg[0]_0\,
      I5 => aclken,
      O => \arb_gnt_r[0]_i_1_n_0\
    );
\arb_gnt_r[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000C0000000AAAA"
    )
        port map (
      I0 => \^arb_gnt_r_reg[1]_0\,
      I1 => sel_i,
      I2 => valid_i,
      I3 => \arb_gnt_r[1]_i_3_n_0\,
      I4 => \port_priority_r_reg[0]_0\,
      I5 => aclken,
      O => \arb_gnt_r[1]_i_1_n_0\
    );
\arb_gnt_r[1]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BA8C8A80"
    )
        port map (
      I0 => port_priority_ns(1),
      I1 => \arb_req_i__1\(1),
      I2 => \barrel_cntr_reg_n_0_[0]\,
      I3 => \arb_req_i__1\(0),
      I4 => port_priority_ns(0),
      O => sel_i
    );
\arb_gnt_r[1]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A2800000FFFFFFFF"
    )
        port map (
      I0 => m_axis_tready(0),
      I1 => arb_sel_i,
      I2 => s_axis_tvalid(1),
      I3 => s_axis_tvalid(0),
      I4 => \arb_gnt_r_reg[1]_1\,
      I5 => arb_busy_r,
      O => \arb_gnt_r[1]_i_3_n_0\
    );
\arb_gnt_r_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \arb_gnt_r[0]_i_1_n_0\,
      Q => \^arb_gnt_r_reg[0]_0\,
      R => '0'
    );
\arb_gnt_r_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \arb_gnt_r[1]_i_1_n_0\,
      Q => \^arb_gnt_r_reg[1]_0\,
      R => '0'
    );
\arb_sel_r[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BFBBFFFF80880000"
    )
        port map (
      I0 => sel_i,
      I1 => aclken,
      I2 => s_axis_tvalid_0_sn_1,
      I3 => arb_busy_r,
      I4 => valid_i,
      I5 => arb_sel_i,
      O => \arb_sel_r[0]_i_1_n_0\
    );
\arb_sel_r_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \arb_sel_r[0]_i_1_n_0\,
      Q => arb_sel_i,
      R => \port_priority_r_reg[0]_0\
    );
\barrel_cntr[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"10FFEF00"
    )
        port map (
      I0 => \^arb_gnt_r_reg[1]_0\,
      I1 => \^arb_gnt_r_reg[0]_0\,
      I2 => arb_busy_r,
      I3 => aclken,
      I4 => \barrel_cntr_reg_n_0_[0]\,
      O => \barrel_cntr[0]_i_1_n_0\
    );
\barrel_cntr_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \barrel_cntr[0]_i_1_n_0\,
      Q => \barrel_cntr_reg_n_0_[0]\,
      R => \port_priority_r_reg[0]_0\
    );
\gen_tdest_routing.busy_r[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"0E"
    )
        port map (
      I0 => \gen_tdest_routing.busy_r_reg[0]\,
      I1 => \^arb_gnt_r_reg[1]_0\,
      I2 => s_axis_tvalid_0_sn_1,
      O => \gen_tdest_routing.busy_ns\
    );
\gen_tdest_routing.busy_r[0]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"0E"
    )
        port map (
      I0 => \gen_tdest_routing.busy_r_reg[0]_0\,
      I1 => \^arb_gnt_r_reg[0]_0\,
      I2 => s_axis_tvalid_0_sn_1,
      O => \gen_tdest_routing.busy_ns_0\
    );
\m_axis_tdata[0]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"CA"
    )
        port map (
      I0 => s_axis_tdata(0),
      I1 => s_axis_tdata(8),
      I2 => arb_sel_i,
      O => m_axis_tdata(0)
    );
\m_axis_tdata[1]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"CA"
    )
        port map (
      I0 => s_axis_tdata(1),
      I1 => s_axis_tdata(9),
      I2 => arb_sel_i,
      O => m_axis_tdata(1)
    );
\m_axis_tdata[2]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"CA"
    )
        port map (
      I0 => s_axis_tdata(2),
      I1 => s_axis_tdata(10),
      I2 => arb_sel_i,
      O => m_axis_tdata(2)
    );
\m_axis_tdata[3]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"CA"
    )
        port map (
      I0 => s_axis_tdata(3),
      I1 => s_axis_tdata(11),
      I2 => arb_sel_i,
      O => m_axis_tdata(3)
    );
\m_axis_tdata[4]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"CA"
    )
        port map (
      I0 => s_axis_tdata(4),
      I1 => s_axis_tdata(12),
      I2 => arb_sel_i,
      O => m_axis_tdata(4)
    );
\m_axis_tdata[5]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"CA"
    )
        port map (
      I0 => s_axis_tdata(5),
      I1 => s_axis_tdata(13),
      I2 => arb_sel_i,
      O => m_axis_tdata(5)
    );
\m_axis_tdata[6]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"CA"
    )
        port map (
      I0 => s_axis_tdata(6),
      I1 => s_axis_tdata(14),
      I2 => arb_sel_i,
      O => m_axis_tdata(6)
    );
\m_axis_tdata[7]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"CA"
    )
        port map (
      I0 => s_axis_tdata(7),
      I1 => s_axis_tdata(15),
      I2 => arb_sel_i,
      O => m_axis_tdata(7)
    );
\m_axis_tlast[0]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"CA"
    )
        port map (
      I0 => s_axis_tlast(0),
      I1 => s_axis_tlast(1),
      I2 => arb_sel_i,
      O => m_axis_tlast(0)
    );
\m_axis_tvalid[0]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"D8D8D8D8D8D8D800"
    )
        port map (
      I0 => arb_sel_i,
      I1 => s_axis_tvalid(1),
      I2 => s_axis_tvalid(0),
      I3 => \m_axis_tvalid[0]_INST_0_i_1_n_0\,
      I4 => \^arb_gnt_r_reg[0]_0\,
      I5 => \gen_tdest_router.busy_r\(0),
      O => m_axis_tvalid(0)
    );
\m_axis_tvalid[0]_INST_0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \^arb_gnt_r_reg[1]_0\,
      I1 => \gen_tdest_router.busy_r\(1),
      O => \m_axis_tvalid[0]_INST_0_i_1_n_0\
    );
\port_priority_r[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BBBBBBFB88888808"
    )
        port map (
      I0 => port_priority_ns(0),
      I1 => aclken,
      I2 => arb_busy_r,
      I3 => \^arb_gnt_r_reg[0]_0\,
      I4 => \^arb_gnt_r_reg[1]_0\,
      I5 => port_priority_ns(1),
      O => \port_priority_r[0]_i_1_n_0\
    );
\port_priority_r[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BBBBBBFB88888808"
    )
        port map (
      I0 => port_priority_ns(1),
      I1 => aclken,
      I2 => arb_busy_r,
      I3 => \^arb_gnt_r_reg[0]_0\,
      I4 => \^arb_gnt_r_reg[1]_0\,
      I5 => port_priority_ns(0),
      O => \port_priority_r[1]_i_1_n_0\
    );
\port_priority_r_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \port_priority_r[0]_i_1_n_0\,
      Q => port_priority_ns(1),
      R => \port_priority_r_reg[0]_0\
    );
\port_priority_r_reg[1]\: unisim.vcomponents.FDSE
     port map (
      C => aclk,
      CE => '1',
      D => \port_priority_r[1]_i_1_n_0\,
      Q => port_priority_ns(0),
      S => \port_priority_r_reg[0]_0\
    );
\s_axis_tready[0]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A800"
    )
        port map (
      I0 => s_axis_tvalid(0),
      I1 => \^arb_gnt_r_reg[0]_0\,
      I2 => \gen_tdest_router.busy_r\(0),
      I3 => m_axis_tready(0),
      O => s_axis_tready(0)
    );
\s_axis_tready[1]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A800"
    )
        port map (
      I0 => s_axis_tvalid(1),
      I1 => \^arb_gnt_r_reg[1]_0\,
      I2 => \gen_tdest_router.busy_r\(1),
      I3 => m_axis_tready(0),
      O => s_axis_tready(1)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axis_switch_2_1_axis_switch_v1_1_21_axisc_arb_responder is
  port (
    \busy_r_reg[0]_0\ : out STD_LOGIC;
    \gen_tdest_router.busy_r\ : out STD_LOGIC_VECTOR ( 1 downto 0 );
    arb_gnt_i : in STD_LOGIC_VECTOR ( 1 downto 0 );
    aclken : in STD_LOGIC;
    arb_done_i : in STD_LOGIC;
    areset_r : in STD_LOGIC;
    aclk : in STD_LOGIC
  );
end axis_switch_2_1_axis_switch_v1_1_21_axisc_arb_responder;

architecture STRUCTURE of axis_switch_2_1_axis_switch_v1_1_21_axisc_arb_responder is
  signal \busy_r[0]_i_1_n_0\ : STD_LOGIC;
  signal \busy_r[1]_i_1_n_0\ : STD_LOGIC;
  signal \^gen_tdest_router.busy_r\ : STD_LOGIC_VECTOR ( 1 downto 0 );
begin
  \gen_tdest_router.busy_r\(1 downto 0) <= \^gen_tdest_router.busy_r\(1 downto 0);
\arb_gnt_r[1]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^gen_tdest_router.busy_r\(0),
      I1 => arb_gnt_i(0),
      I2 => \^gen_tdest_router.busy_r\(1),
      I3 => arb_gnt_i(1),
      O => \busy_r_reg[0]_0\
    );
\busy_r[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000AEA"
    )
        port map (
      I0 => \^gen_tdest_router.busy_r\(0),
      I1 => arb_gnt_i(0),
      I2 => aclken,
      I3 => arb_done_i,
      I4 => areset_r,
      O => \busy_r[0]_i_1_n_0\
    );
\busy_r[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000AEA"
    )
        port map (
      I0 => \^gen_tdest_router.busy_r\(1),
      I1 => arb_gnt_i(1),
      I2 => aclken,
      I3 => arb_done_i,
      I4 => areset_r,
      O => \busy_r[1]_i_1_n_0\
    );
\busy_r_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \busy_r[0]_i_1_n_0\,
      Q => \^gen_tdest_router.busy_r\(0),
      R => '0'
    );
\busy_r_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \busy_r[1]_i_1_n_0\,
      Q => \^gen_tdest_router.busy_r\(1),
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axis_switch_2_1_axis_switch_v1_1_21_axisc_decoder is
  port (
    \gen_tdest_routing.busy_r_reg[0]_0\ : out STD_LOGIC;
    \arb_req_i__1\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    areset_r : in STD_LOGIC;
    aclken : in STD_LOGIC;
    \gen_tdest_routing.busy_ns\ : in STD_LOGIC;
    aclk : in STD_LOGIC;
    s_req_suppress : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    arb_gnt_i : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end axis_switch_2_1_axis_switch_v1_1_21_axisc_decoder;

architecture STRUCTURE of axis_switch_2_1_axis_switch_v1_1_21_axisc_decoder is
  signal \^gen_tdest_routing.busy_r_reg[0]_0\ : STD_LOGIC;
begin
  \gen_tdest_routing.busy_r_reg[0]_0\ <= \^gen_tdest_routing.busy_r_reg[0]_0\;
\arb_gnt_r[1]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0004"
    )
        port map (
      I0 => s_req_suppress(0),
      I1 => s_axis_tvalid(0),
      I2 => \^gen_tdest_routing.busy_r_reg[0]_0\,
      I3 => arb_gnt_i(0),
      O => \arb_req_i__1\(0)
    );
\gen_tdest_routing.busy_r_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => aclken,
      D => \gen_tdest_routing.busy_ns\,
      Q => \^gen_tdest_routing.busy_r_reg[0]_0\,
      R => areset_r
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axis_switch_2_1_axis_switch_v1_1_21_axisc_decoder_0 is
  port (
    \gen_tdest_routing.busy_r_reg[0]_0\ : out STD_LOGIC;
    \arb_req_i__1\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    valid_i : out STD_LOGIC;
    areset_r : in STD_LOGIC;
    aclken : in STD_LOGIC;
    \gen_tdest_routing.busy_ns\ : in STD_LOGIC;
    aclk : in STD_LOGIC;
    s_req_suppress : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axis_tvalid : in STD_LOGIC_VECTOR ( 1 downto 0 );
    arb_gnt_i : in STD_LOGIC_VECTOR ( 1 downto 0 );
    arb_busy_r_reg : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of axis_switch_2_1_axis_switch_v1_1_21_axisc_decoder_0 : entity is "axis_switch_v1_1_21_axisc_decoder";
end axis_switch_2_1_axis_switch_v1_1_21_axisc_decoder_0;

architecture STRUCTURE of axis_switch_2_1_axis_switch_v1_1_21_axisc_decoder_0 is
  signal \^arb_req_i__1\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \^gen_tdest_routing.busy_r_reg[0]_0\ : STD_LOGIC;
begin
  \arb_req_i__1\(0) <= \^arb_req_i__1\(0);
  \gen_tdest_routing.busy_r_reg[0]_0\ <= \^gen_tdest_routing.busy_r_reg[0]_0\;
arb_busy_r_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AAAAABAA"
    )
        port map (
      I0 => \^arb_req_i__1\(0),
      I1 => arb_gnt_i(0),
      I2 => arb_busy_r_reg,
      I3 => s_axis_tvalid(0),
      I4 => s_req_suppress(0),
      O => valid_i
    );
arb_busy_r_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0004"
    )
        port map (
      I0 => s_req_suppress(1),
      I1 => s_axis_tvalid(1),
      I2 => \^gen_tdest_routing.busy_r_reg[0]_0\,
      I3 => arb_gnt_i(1),
      O => \^arb_req_i__1\(0)
    );
\gen_tdest_routing.busy_r_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => aclken,
      D => \gen_tdest_routing.busy_ns\,
      Q => \^gen_tdest_routing.busy_r_reg[0]_0\,
      R => areset_r
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axis_switch_2_1_axis_switch_v1_1_21_axis_switch_arbiter is
  port (
    areset_r : out STD_LOGIC;
    s_axis_tready : out STD_LOGIC_VECTOR ( 1 downto 0 );
    arb_gnt_i : out STD_LOGIC_VECTOR ( 1 downto 0 );
    arb_done_i : out STD_LOGIC;
    \gen_tdest_routing.busy_ns\ : out STD_LOGIC;
    \gen_tdest_routing.busy_ns_0\ : out STD_LOGIC;
    m_axis_tvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_tlast : out STD_LOGIC_VECTOR ( 0 to 0 );
    aclk : in STD_LOGIC;
    aclken : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC_VECTOR ( 1 downto 0 );
    \gen_tdest_router.busy_r\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axis_tready : in STD_LOGIC_VECTOR ( 0 to 0 );
    valid_i : in STD_LOGIC;
    \arb_req_i__1\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    \gen_tdest_routing.busy_r_reg[0]\ : in STD_LOGIC;
    \gen_tdest_routing.busy_r_reg[0]_0\ : in STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axis_tlast : in STD_LOGIC_VECTOR ( 1 downto 0 );
    aresetn : in STD_LOGIC;
    \arb_gnt_r_reg[1]\ : in STD_LOGIC
  );
end axis_switch_2_1_axis_switch_v1_1_21_axis_switch_arbiter;

architecture STRUCTURE of axis_switch_2_1_axis_switch_v1_1_21_axis_switch_arbiter is
  signal \^areset_r\ : STD_LOGIC;
  signal p_0_in : STD_LOGIC;
begin
  areset_r <= \^areset_r\;
areset_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => aresetn,
      O => p_0_in
    );
areset_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => p_0_in,
      Q => \^areset_r\,
      R => '0'
    );
\gen_mi_arb[0].gen_arb_algorithm.gen_round_robin.inst_arb_rr_0\: entity work.axis_switch_2_1_axis_switch_v1_1_21_arb_rr
     port map (
      aclk => aclk,
      aclken => aclken,
      \arb_gnt_r_reg[0]_0\ => arb_gnt_i(0),
      \arb_gnt_r_reg[1]_0\ => arb_gnt_i(1),
      \arb_gnt_r_reg[1]_1\ => \arb_gnt_r_reg[1]\,
      \arb_req_i__1\(1 downto 0) => \arb_req_i__1\(1 downto 0),
      \gen_tdest_router.busy_r\(1 downto 0) => \gen_tdest_router.busy_r\(1 downto 0),
      \gen_tdest_routing.busy_ns\ => \gen_tdest_routing.busy_ns\,
      \gen_tdest_routing.busy_ns_0\ => \gen_tdest_routing.busy_ns_0\,
      \gen_tdest_routing.busy_r_reg[0]\ => \gen_tdest_routing.busy_r_reg[0]\,
      \gen_tdest_routing.busy_r_reg[0]_0\ => \gen_tdest_routing.busy_r_reg[0]_0\,
      m_axis_tdata(7 downto 0) => m_axis_tdata(7 downto 0),
      m_axis_tlast(0) => m_axis_tlast(0),
      m_axis_tready(0) => m_axis_tready(0),
      m_axis_tvalid(0) => m_axis_tvalid(0),
      \port_priority_r_reg[0]_0\ => \^areset_r\,
      s_axis_tdata(15 downto 0) => s_axis_tdata(15 downto 0),
      s_axis_tlast(1 downto 0) => s_axis_tlast(1 downto 0),
      s_axis_tready(1 downto 0) => s_axis_tready(1 downto 0),
      s_axis_tvalid(1 downto 0) => s_axis_tvalid(1 downto 0),
      s_axis_tvalid_0_sp_1 => arb_done_i,
      valid_i => valid_i
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axis_switch_2_1_axis_switch_v1_1_21_axisc_transfer_mux is
  port (
    \busy_r_reg[0]\ : out STD_LOGIC;
    \gen_tdest_router.busy_r\ : out STD_LOGIC_VECTOR ( 1 downto 0 );
    arb_gnt_i : in STD_LOGIC_VECTOR ( 1 downto 0 );
    aclken : in STD_LOGIC;
    arb_done_i : in STD_LOGIC;
    areset_r : in STD_LOGIC;
    aclk : in STD_LOGIC
  );
end axis_switch_2_1_axis_switch_v1_1_21_axisc_transfer_mux;

architecture STRUCTURE of axis_switch_2_1_axis_switch_v1_1_21_axisc_transfer_mux is
begin
\gen_tdest_router.axisc_arb_responder\: entity work.axis_switch_2_1_axis_switch_v1_1_21_axisc_arb_responder
     port map (
      aclk => aclk,
      aclken => aclken,
      arb_done_i => arb_done_i,
      arb_gnt_i(1 downto 0) => arb_gnt_i(1 downto 0),
      areset_r => areset_r,
      \busy_r_reg[0]_0\ => \busy_r_reg[0]\,
      \gen_tdest_router.busy_r\(1 downto 0) => \gen_tdest_router.busy_r\(1 downto 0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axis_switch_2_1_axis_switch_v1_1_21_axis_switch is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    aclken : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axis_tready : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axis_tdata : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axis_tstrb : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axis_tkeep : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axis_tlast : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axis_tid : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axis_tdest : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axis_tuser : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axis_tvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tready : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_tstrb : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tkeep : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tlast : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tid : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tdest : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tuser : out STD_LOGIC_VECTOR ( 0 to 0 );
    arb_req : out STD_LOGIC_VECTOR ( 1 downto 0 );
    arb_done : out STD_LOGIC_VECTOR ( 0 to 0 );
    arb_gnt : in STD_LOGIC_VECTOR ( 1 downto 0 );
    arb_sel : in STD_LOGIC_VECTOR ( 0 to 0 );
    arb_last : out STD_LOGIC_VECTOR ( 1 downto 0 );
    arb_id : out STD_LOGIC_VECTOR ( 1 downto 0 );
    arb_dest : out STD_LOGIC_VECTOR ( 1 downto 0 );
    arb_user : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_req_suppress : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_ctrl_aclk : in STD_LOGIC;
    s_axi_ctrl_aresetn : in STD_LOGIC;
    s_axi_ctrl_awvalid : in STD_LOGIC;
    s_axi_ctrl_awready : out STD_LOGIC;
    s_axi_ctrl_awaddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s_axi_ctrl_wvalid : in STD_LOGIC;
    s_axi_ctrl_wready : out STD_LOGIC;
    s_axi_ctrl_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_ctrl_bvalid : out STD_LOGIC;
    s_axi_ctrl_bready : in STD_LOGIC;
    s_axi_ctrl_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_ctrl_arvalid : in STD_LOGIC;
    s_axi_ctrl_arready : out STD_LOGIC;
    s_axi_ctrl_araddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s_axi_ctrl_rvalid : out STD_LOGIC;
    s_axi_ctrl_rready : in STD_LOGIC;
    s_axi_ctrl_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_ctrl_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_decode_err : out STD_LOGIC_VECTOR ( 1 downto 0 )
  );
  attribute C_ARB_ALGORITHM : integer;
  attribute C_ARB_ALGORITHM of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 0;
  attribute C_ARB_ON_MAX_XFERS : integer;
  attribute C_ARB_ON_MAX_XFERS of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute C_ARB_ON_NUM_CYCLES : integer;
  attribute C_ARB_ON_NUM_CYCLES of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 0;
  attribute C_ARB_ON_TLAST : integer;
  attribute C_ARB_ON_TLAST of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 0;
  attribute C_AXIS_SIGNAL_SET : integer;
  attribute C_AXIS_SIGNAL_SET of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 19;
  attribute C_AXIS_TDATA_WIDTH : integer;
  attribute C_AXIS_TDATA_WIDTH of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 8;
  attribute C_AXIS_TDEST_WIDTH : integer;
  attribute C_AXIS_TDEST_WIDTH of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute C_AXIS_TID_WIDTH : integer;
  attribute C_AXIS_TID_WIDTH of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute C_AXIS_TUSER_WIDTH : integer;
  attribute C_AXIS_TUSER_WIDTH of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute C_COMMON_CLOCK : integer;
  attribute C_COMMON_CLOCK of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 0;
  attribute C_DECODER_REG : integer;
  attribute C_DECODER_REG of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 0;
  attribute C_FAMILY : string;
  attribute C_FAMILY of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is "zynq";
  attribute C_INCLUDE_ARBITER : integer;
  attribute C_INCLUDE_ARBITER of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute C_LOG_SI_SLOTS : integer;
  attribute C_LOG_SI_SLOTS of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute C_M_AXIS_BASETDEST_ARRAY : string;
  attribute C_M_AXIS_BASETDEST_ARRAY of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is "1'b0";
  attribute C_M_AXIS_CONNECTIVITY_ARRAY : string;
  attribute C_M_AXIS_CONNECTIVITY_ARRAY of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is "2'b11";
  attribute C_M_AXIS_HIGHTDEST_ARRAY : string;
  attribute C_M_AXIS_HIGHTDEST_ARRAY of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is "1'b0";
  attribute C_NUM_MI_SLOTS : integer;
  attribute C_NUM_MI_SLOTS of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute C_NUM_SI_SLOTS : integer;
  attribute C_NUM_SI_SLOTS of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 2;
  attribute C_OUTPUT_REG : integer;
  attribute C_OUTPUT_REG of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 0;
  attribute C_ROUTING_MODE : integer;
  attribute C_ROUTING_MODE of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 0;
  attribute C_S_AXI_CTRL_ADDR_WIDTH : integer;
  attribute C_S_AXI_CTRL_ADDR_WIDTH of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 7;
  attribute C_S_AXI_CTRL_DATA_WIDTH : integer;
  attribute C_S_AXI_CTRL_DATA_WIDTH of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 32;
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is "yes";
  attribute G_INDX_SS_TDATA : integer;
  attribute G_INDX_SS_TDATA of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute G_INDX_SS_TDEST : integer;
  attribute G_INDX_SS_TDEST of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 6;
  attribute G_INDX_SS_TID : integer;
  attribute G_INDX_SS_TID of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 5;
  attribute G_INDX_SS_TKEEP : integer;
  attribute G_INDX_SS_TKEEP of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 3;
  attribute G_INDX_SS_TLAST : integer;
  attribute G_INDX_SS_TLAST of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 4;
  attribute G_INDX_SS_TREADY : integer;
  attribute G_INDX_SS_TREADY of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 0;
  attribute G_INDX_SS_TSTRB : integer;
  attribute G_INDX_SS_TSTRB of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 2;
  attribute G_INDX_SS_TUSER : integer;
  attribute G_INDX_SS_TUSER of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 7;
  attribute G_MASK_SS_TDATA : integer;
  attribute G_MASK_SS_TDATA of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 2;
  attribute G_MASK_SS_TDEST : integer;
  attribute G_MASK_SS_TDEST of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 64;
  attribute G_MASK_SS_TID : integer;
  attribute G_MASK_SS_TID of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 32;
  attribute G_MASK_SS_TKEEP : integer;
  attribute G_MASK_SS_TKEEP of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 8;
  attribute G_MASK_SS_TLAST : integer;
  attribute G_MASK_SS_TLAST of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 16;
  attribute G_MASK_SS_TREADY : integer;
  attribute G_MASK_SS_TREADY of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute G_MASK_SS_TSTRB : integer;
  attribute G_MASK_SS_TSTRB of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 4;
  attribute G_MASK_SS_TUSER : integer;
  attribute G_MASK_SS_TUSER of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 128;
  attribute G_TASK_SEVERITY_ERR : integer;
  attribute G_TASK_SEVERITY_ERR of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 2;
  attribute G_TASK_SEVERITY_INFO : integer;
  attribute G_TASK_SEVERITY_INFO of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 0;
  attribute G_TASK_SEVERITY_WARNING : integer;
  attribute G_TASK_SEVERITY_WARNING of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute LP_CTRL_REG_WIDTH : integer;
  attribute LP_CTRL_REG_WIDTH of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 15;
  attribute LP_MERGEDOWN_MUX : integer;
  attribute LP_MERGEDOWN_MUX of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 0;
  attribute LP_NUM_SYNCHRONIZER_STAGES : integer;
  attribute LP_NUM_SYNCHRONIZER_STAGES of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 4;
  attribute P_DECODER_CONNECTIVITY_ARRAY : string;
  attribute P_DECODER_CONNECTIVITY_ARRAY of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is "2'b11";
  attribute P_SINGLE_SLAVE_CONNECTIVITY_ARRAY : string;
  attribute P_SINGLE_SLAVE_CONNECTIVITY_ARRAY of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is "1'b0";
  attribute P_TPAYLOAD_WIDTH : integer;
  attribute P_TPAYLOAD_WIDTH of axis_switch_2_1_axis_switch_v1_1_21_axis_switch : entity is 9;
end axis_switch_2_1_axis_switch_v1_1_21_axis_switch;

architecture STRUCTURE of axis_switch_2_1_axis_switch_v1_1_21_axis_switch is
  signal \<const0>\ : STD_LOGIC;
  signal \<const1>\ : STD_LOGIC;
  signal arb_done_i : STD_LOGIC;
  signal arb_gnt_i : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal areset_r : STD_LOGIC;
  signal \gen_decoder[0].axisc_decoder_0_n_0\ : STD_LOGIC;
  signal \gen_decoder[1].axisc_decoder_0_n_0\ : STD_LOGIC;
  signal \gen_mi_arb[0].gen_arb_algorithm.gen_round_robin.inst_arb_rr_0/arb_req_i__1\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \gen_mi_arb[0].gen_arb_algorithm.gen_round_robin.inst_arb_rr_0/valid_i\ : STD_LOGIC;
  signal \gen_tdest_router.busy_r\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \gen_tdest_routing.busy_ns\ : STD_LOGIC;
  signal \gen_tdest_routing.busy_ns_0\ : STD_LOGIC;
  signal \gen_transfer_mux[0].axisc_transfer_mux_0_n_0\ : STD_LOGIC;
begin
  arb_dest(1) <= \<const0>\;
  arb_dest(0) <= \<const0>\;
  arb_done(0) <= \<const0>\;
  arb_id(1) <= \<const0>\;
  arb_id(0) <= \<const0>\;
  arb_last(1) <= \<const0>\;
  arb_last(0) <= \<const0>\;
  arb_req(1) <= \<const0>\;
  arb_req(0) <= \<const0>\;
  arb_user(1) <= \<const0>\;
  arb_user(0) <= \<const0>\;
  m_axis_tdest(0) <= \<const0>\;
  m_axis_tid(0) <= \<const0>\;
  m_axis_tkeep(0) <= \<const1>\;
  m_axis_tstrb(0) <= \<const0>\;
  m_axis_tuser(0) <= \<const0>\;
  s_axi_ctrl_arready <= \<const0>\;
  s_axi_ctrl_awready <= \<const0>\;
  s_axi_ctrl_bresp(1) <= \<const0>\;
  s_axi_ctrl_bresp(0) <= \<const0>\;
  s_axi_ctrl_bvalid <= \<const0>\;
  s_axi_ctrl_rdata(31) <= \<const0>\;
  s_axi_ctrl_rdata(30) <= \<const0>\;
  s_axi_ctrl_rdata(29) <= \<const0>\;
  s_axi_ctrl_rdata(28) <= \<const0>\;
  s_axi_ctrl_rdata(27) <= \<const0>\;
  s_axi_ctrl_rdata(26) <= \<const0>\;
  s_axi_ctrl_rdata(25) <= \<const0>\;
  s_axi_ctrl_rdata(24) <= \<const0>\;
  s_axi_ctrl_rdata(23) <= \<const0>\;
  s_axi_ctrl_rdata(22) <= \<const0>\;
  s_axi_ctrl_rdata(21) <= \<const0>\;
  s_axi_ctrl_rdata(20) <= \<const0>\;
  s_axi_ctrl_rdata(19) <= \<const0>\;
  s_axi_ctrl_rdata(18) <= \<const0>\;
  s_axi_ctrl_rdata(17) <= \<const0>\;
  s_axi_ctrl_rdata(16) <= \<const0>\;
  s_axi_ctrl_rdata(15) <= \<const0>\;
  s_axi_ctrl_rdata(14) <= \<const0>\;
  s_axi_ctrl_rdata(13) <= \<const0>\;
  s_axi_ctrl_rdata(12) <= \<const0>\;
  s_axi_ctrl_rdata(11) <= \<const0>\;
  s_axi_ctrl_rdata(10) <= \<const0>\;
  s_axi_ctrl_rdata(9) <= \<const0>\;
  s_axi_ctrl_rdata(8) <= \<const0>\;
  s_axi_ctrl_rdata(7) <= \<const0>\;
  s_axi_ctrl_rdata(6) <= \<const0>\;
  s_axi_ctrl_rdata(5) <= \<const0>\;
  s_axi_ctrl_rdata(4) <= \<const0>\;
  s_axi_ctrl_rdata(3) <= \<const0>\;
  s_axi_ctrl_rdata(2) <= \<const0>\;
  s_axi_ctrl_rdata(1) <= \<const0>\;
  s_axi_ctrl_rdata(0) <= \<const0>\;
  s_axi_ctrl_rresp(1) <= \<const0>\;
  s_axi_ctrl_rresp(0) <= \<const0>\;
  s_axi_ctrl_rvalid <= \<const0>\;
  s_axi_ctrl_wready <= \<const0>\;
  s_decode_err(1) <= \<const0>\;
  s_decode_err(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
VCC: unisim.vcomponents.VCC
     port map (
      P => \<const1>\
    );
\gen_decoder[0].axisc_decoder_0\: entity work.axis_switch_2_1_axis_switch_v1_1_21_axisc_decoder
     port map (
      aclk => aclk,
      aclken => aclken,
      arb_gnt_i(0) => arb_gnt_i(0),
      \arb_req_i__1\(0) => \gen_mi_arb[0].gen_arb_algorithm.gen_round_robin.inst_arb_rr_0/arb_req_i__1\(0),
      areset_r => areset_r,
      \gen_tdest_routing.busy_ns\ => \gen_tdest_routing.busy_ns\,
      \gen_tdest_routing.busy_r_reg[0]_0\ => \gen_decoder[0].axisc_decoder_0_n_0\,
      s_axis_tvalid(0) => s_axis_tvalid(0),
      s_req_suppress(0) => s_req_suppress(0)
    );
\gen_decoder[1].axisc_decoder_0\: entity work.axis_switch_2_1_axis_switch_v1_1_21_axisc_decoder_0
     port map (
      aclk => aclk,
      aclken => aclken,
      arb_busy_r_reg => \gen_decoder[0].axisc_decoder_0_n_0\,
      arb_gnt_i(1 downto 0) => arb_gnt_i(1 downto 0),
      \arb_req_i__1\(0) => \gen_mi_arb[0].gen_arb_algorithm.gen_round_robin.inst_arb_rr_0/arb_req_i__1\(1),
      areset_r => areset_r,
      \gen_tdest_routing.busy_ns\ => \gen_tdest_routing.busy_ns_0\,
      \gen_tdest_routing.busy_r_reg[0]_0\ => \gen_decoder[1].axisc_decoder_0_n_0\,
      s_axis_tvalid(1 downto 0) => s_axis_tvalid(1 downto 0),
      s_req_suppress(1 downto 0) => s_req_suppress(1 downto 0),
      valid_i => \gen_mi_arb[0].gen_arb_algorithm.gen_round_robin.inst_arb_rr_0/valid_i\
    );
\gen_int_arbiter.gen_arbiter.axis_switch_v1_1_21_axis_switch_arbiter\: entity work.axis_switch_2_1_axis_switch_v1_1_21_axis_switch_arbiter
     port map (
      aclk => aclk,
      aclken => aclken,
      arb_done_i => arb_done_i,
      arb_gnt_i(1 downto 0) => arb_gnt_i(1 downto 0),
      \arb_gnt_r_reg[1]\ => \gen_transfer_mux[0].axisc_transfer_mux_0_n_0\,
      \arb_req_i__1\(1 downto 0) => \gen_mi_arb[0].gen_arb_algorithm.gen_round_robin.inst_arb_rr_0/arb_req_i__1\(1 downto 0),
      areset_r => areset_r,
      aresetn => aresetn,
      \gen_tdest_router.busy_r\(1 downto 0) => \gen_tdest_router.busy_r\(1 downto 0),
      \gen_tdest_routing.busy_ns\ => \gen_tdest_routing.busy_ns_0\,
      \gen_tdest_routing.busy_ns_0\ => \gen_tdest_routing.busy_ns\,
      \gen_tdest_routing.busy_r_reg[0]\ => \gen_decoder[1].axisc_decoder_0_n_0\,
      \gen_tdest_routing.busy_r_reg[0]_0\ => \gen_decoder[0].axisc_decoder_0_n_0\,
      m_axis_tdata(7 downto 0) => m_axis_tdata(7 downto 0),
      m_axis_tlast(0) => m_axis_tlast(0),
      m_axis_tready(0) => m_axis_tready(0),
      m_axis_tvalid(0) => m_axis_tvalid(0),
      s_axis_tdata(15 downto 0) => s_axis_tdata(15 downto 0),
      s_axis_tlast(1 downto 0) => s_axis_tlast(1 downto 0),
      s_axis_tready(1 downto 0) => s_axis_tready(1 downto 0),
      s_axis_tvalid(1 downto 0) => s_axis_tvalid(1 downto 0),
      valid_i => \gen_mi_arb[0].gen_arb_algorithm.gen_round_robin.inst_arb_rr_0/valid_i\
    );
\gen_transfer_mux[0].axisc_transfer_mux_0\: entity work.axis_switch_2_1_axis_switch_v1_1_21_axisc_transfer_mux
     port map (
      aclk => aclk,
      aclken => aclken,
      arb_done_i => arb_done_i,
      arb_gnt_i(1 downto 0) => arb_gnt_i(1 downto 0),
      areset_r => areset_r,
      \busy_r_reg[0]\ => \gen_transfer_mux[0].axisc_transfer_mux_0_n_0\,
      \gen_tdest_router.busy_r\(1 downto 0) => \gen_tdest_router.busy_r\(1 downto 0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axis_switch_2_1 is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axis_tready : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axis_tdata : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axis_tlast : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axis_tvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tready : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_tlast : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_req_suppress : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_decode_err : out STD_LOGIC_VECTOR ( 1 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of axis_switch_2_1 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of axis_switch_2_1 : entity is "axis_switch_0,axis_switch_v1_1_21_axis_switch,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of axis_switch_2_1 : entity is "yes";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of axis_switch_2_1 : entity is "axis_switch_v1_1_21_axis_switch,Vivado 2020.1";
end axis_switch_2_1;

architecture STRUCTURE of axis_switch_2_1 is
  signal NLW_inst_s_axi_ctrl_arready_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_s_axi_ctrl_awready_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_s_axi_ctrl_bvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_s_axi_ctrl_rvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_s_axi_ctrl_wready_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_arb_dest_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_arb_done_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_arb_id_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_arb_last_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_arb_req_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_arb_user_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_m_axis_tdest_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_m_axis_tid_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_m_axis_tkeep_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_m_axis_tstrb_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_m_axis_tuser_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_s_axi_ctrl_bresp_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_s_axi_ctrl_rdata_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_inst_s_axi_ctrl_rresp_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute C_ARB_ALGORITHM : integer;
  attribute C_ARB_ALGORITHM of inst : label is 0;
  attribute C_ARB_ON_MAX_XFERS : integer;
  attribute C_ARB_ON_MAX_XFERS of inst : label is 1;
  attribute C_ARB_ON_NUM_CYCLES : integer;
  attribute C_ARB_ON_NUM_CYCLES of inst : label is 0;
  attribute C_ARB_ON_TLAST : integer;
  attribute C_ARB_ON_TLAST of inst : label is 0;
  attribute C_AXIS_SIGNAL_SET : integer;
  attribute C_AXIS_SIGNAL_SET of inst : label is 19;
  attribute C_AXIS_TDATA_WIDTH : integer;
  attribute C_AXIS_TDATA_WIDTH of inst : label is 8;
  attribute C_AXIS_TDEST_WIDTH : integer;
  attribute C_AXIS_TDEST_WIDTH of inst : label is 1;
  attribute C_AXIS_TID_WIDTH : integer;
  attribute C_AXIS_TID_WIDTH of inst : label is 1;
  attribute C_AXIS_TUSER_WIDTH : integer;
  attribute C_AXIS_TUSER_WIDTH of inst : label is 1;
  attribute C_COMMON_CLOCK : integer;
  attribute C_COMMON_CLOCK of inst : label is 0;
  attribute C_DECODER_REG : integer;
  attribute C_DECODER_REG of inst : label is 0;
  attribute C_FAMILY : string;
  attribute C_FAMILY of inst : label is "zynq";
  attribute C_INCLUDE_ARBITER : integer;
  attribute C_INCLUDE_ARBITER of inst : label is 1;
  attribute C_LOG_SI_SLOTS : integer;
  attribute C_LOG_SI_SLOTS of inst : label is 1;
  attribute C_M_AXIS_BASETDEST_ARRAY : string;
  attribute C_M_AXIS_BASETDEST_ARRAY of inst : label is "1'b0";
  attribute C_M_AXIS_CONNECTIVITY_ARRAY : string;
  attribute C_M_AXIS_CONNECTIVITY_ARRAY of inst : label is "2'b11";
  attribute C_M_AXIS_HIGHTDEST_ARRAY : string;
  attribute C_M_AXIS_HIGHTDEST_ARRAY of inst : label is "1'b0";
  attribute C_NUM_MI_SLOTS : integer;
  attribute C_NUM_MI_SLOTS of inst : label is 1;
  attribute C_NUM_SI_SLOTS : integer;
  attribute C_NUM_SI_SLOTS of inst : label is 2;
  attribute C_OUTPUT_REG : integer;
  attribute C_OUTPUT_REG of inst : label is 0;
  attribute C_ROUTING_MODE : integer;
  attribute C_ROUTING_MODE of inst : label is 0;
  attribute C_S_AXI_CTRL_ADDR_WIDTH : integer;
  attribute C_S_AXI_CTRL_ADDR_WIDTH of inst : label is 7;
  attribute C_S_AXI_CTRL_DATA_WIDTH : integer;
  attribute C_S_AXI_CTRL_DATA_WIDTH of inst : label is 32;
  attribute DowngradeIPIdentifiedWarnings of inst : label is "yes";
  attribute G_INDX_SS_TDATA : integer;
  attribute G_INDX_SS_TDATA of inst : label is 1;
  attribute G_INDX_SS_TDEST : integer;
  attribute G_INDX_SS_TDEST of inst : label is 6;
  attribute G_INDX_SS_TID : integer;
  attribute G_INDX_SS_TID of inst : label is 5;
  attribute G_INDX_SS_TKEEP : integer;
  attribute G_INDX_SS_TKEEP of inst : label is 3;
  attribute G_INDX_SS_TLAST : integer;
  attribute G_INDX_SS_TLAST of inst : label is 4;
  attribute G_INDX_SS_TREADY : integer;
  attribute G_INDX_SS_TREADY of inst : label is 0;
  attribute G_INDX_SS_TSTRB : integer;
  attribute G_INDX_SS_TSTRB of inst : label is 2;
  attribute G_INDX_SS_TUSER : integer;
  attribute G_INDX_SS_TUSER of inst : label is 7;
  attribute G_MASK_SS_TDATA : integer;
  attribute G_MASK_SS_TDATA of inst : label is 2;
  attribute G_MASK_SS_TDEST : integer;
  attribute G_MASK_SS_TDEST of inst : label is 64;
  attribute G_MASK_SS_TID : integer;
  attribute G_MASK_SS_TID of inst : label is 32;
  attribute G_MASK_SS_TKEEP : integer;
  attribute G_MASK_SS_TKEEP of inst : label is 8;
  attribute G_MASK_SS_TLAST : integer;
  attribute G_MASK_SS_TLAST of inst : label is 16;
  attribute G_MASK_SS_TREADY : integer;
  attribute G_MASK_SS_TREADY of inst : label is 1;
  attribute G_MASK_SS_TSTRB : integer;
  attribute G_MASK_SS_TSTRB of inst : label is 4;
  attribute G_MASK_SS_TUSER : integer;
  attribute G_MASK_SS_TUSER of inst : label is 128;
  attribute G_TASK_SEVERITY_ERR : integer;
  attribute G_TASK_SEVERITY_ERR of inst : label is 2;
  attribute G_TASK_SEVERITY_INFO : integer;
  attribute G_TASK_SEVERITY_INFO of inst : label is 0;
  attribute G_TASK_SEVERITY_WARNING : integer;
  attribute G_TASK_SEVERITY_WARNING of inst : label is 1;
  attribute LP_CTRL_REG_WIDTH : integer;
  attribute LP_CTRL_REG_WIDTH of inst : label is 15;
  attribute LP_MERGEDOWN_MUX : integer;
  attribute LP_MERGEDOWN_MUX of inst : label is 0;
  attribute LP_NUM_SYNCHRONIZER_STAGES : integer;
  attribute LP_NUM_SYNCHRONIZER_STAGES of inst : label is 4;
  attribute P_DECODER_CONNECTIVITY_ARRAY : string;
  attribute P_DECODER_CONNECTIVITY_ARRAY of inst : label is "2'b11";
  attribute P_SINGLE_SLAVE_CONNECTIVITY_ARRAY : string;
  attribute P_SINGLE_SLAVE_CONNECTIVITY_ARRAY of inst : label is "1'b0";
  attribute P_TPAYLOAD_WIDTH : integer;
  attribute P_TPAYLOAD_WIDTH of inst : label is 9;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of aclk : signal is "xilinx.com:signal:clock:1.0 CLKIF CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of aclk : signal is "XIL_INTERFACENAME CLKIF, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of aresetn : signal is "xilinx.com:signal:reset:1.0 RSTIF RST";
  attribute X_INTERFACE_PARAMETER of aresetn : signal is "XIL_INTERFACENAME RSTIF, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m_axis_tdata : signal is "xilinx.com:interface:axis:1.0 M00_AXIS TDATA";
  attribute X_INTERFACE_INFO of m_axis_tlast : signal is "xilinx.com:interface:axis:1.0 M00_AXIS TLAST";
  attribute X_INTERFACE_PARAMETER of m_axis_tlast : signal is "XIL_INTERFACENAME M00_AXIS, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m_axis_tready : signal is "xilinx.com:interface:axis:1.0 M00_AXIS TREADY";
  attribute X_INTERFACE_INFO of m_axis_tvalid : signal is "xilinx.com:interface:axis:1.0 M00_AXIS TVALID";
  attribute X_INTERFACE_INFO of s_axis_tdata : signal is "xilinx.com:interface:axis:1.0 S00_AXIS TDATA [7:0] [7:0], xilinx.com:interface:axis:1.0 S01_AXIS TDATA [7:0] [15:8]";
  attribute X_INTERFACE_INFO of s_axis_tlast : signal is "xilinx.com:interface:axis:1.0 S00_AXIS TLAST [0:0] [0:0], xilinx.com:interface:axis:1.0 S01_AXIS TLAST [0:0] [1:1]";
  attribute X_INTERFACE_PARAMETER of s_axis_tlast : signal is "XIL_INTERFACENAME S00_AXIS, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, INSERT_VIP 0, XIL_INTERFACENAME S01_AXIS, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axis_tready : signal is "xilinx.com:interface:axis:1.0 S00_AXIS TREADY [0:0] [0:0], xilinx.com:interface:axis:1.0 S01_AXIS TREADY [0:0] [1:1]";
  attribute X_INTERFACE_INFO of s_axis_tvalid : signal is "xilinx.com:interface:axis:1.0 S00_AXIS TVALID [0:0] [0:0], xilinx.com:interface:axis:1.0 S01_AXIS TVALID [0:0] [1:1]";
begin
inst: entity work.axis_switch_2_1_axis_switch_v1_1_21_axis_switch
     port map (
      aclk => aclk,
      aclken => '1',
      arb_dest(1 downto 0) => NLW_inst_arb_dest_UNCONNECTED(1 downto 0),
      arb_done(0) => NLW_inst_arb_done_UNCONNECTED(0),
      arb_gnt(1 downto 0) => B"00",
      arb_id(1 downto 0) => NLW_inst_arb_id_UNCONNECTED(1 downto 0),
      arb_last(1 downto 0) => NLW_inst_arb_last_UNCONNECTED(1 downto 0),
      arb_req(1 downto 0) => NLW_inst_arb_req_UNCONNECTED(1 downto 0),
      arb_sel(0) => '0',
      arb_user(1 downto 0) => NLW_inst_arb_user_UNCONNECTED(1 downto 0),
      aresetn => aresetn,
      m_axis_tdata(7 downto 0) => m_axis_tdata(7 downto 0),
      m_axis_tdest(0) => NLW_inst_m_axis_tdest_UNCONNECTED(0),
      m_axis_tid(0) => NLW_inst_m_axis_tid_UNCONNECTED(0),
      m_axis_tkeep(0) => NLW_inst_m_axis_tkeep_UNCONNECTED(0),
      m_axis_tlast(0) => m_axis_tlast(0),
      m_axis_tready(0) => m_axis_tready(0),
      m_axis_tstrb(0) => NLW_inst_m_axis_tstrb_UNCONNECTED(0),
      m_axis_tuser(0) => NLW_inst_m_axis_tuser_UNCONNECTED(0),
      m_axis_tvalid(0) => m_axis_tvalid(0),
      s_axi_ctrl_aclk => '0',
      s_axi_ctrl_araddr(6 downto 0) => B"0000000",
      s_axi_ctrl_aresetn => '0',
      s_axi_ctrl_arready => NLW_inst_s_axi_ctrl_arready_UNCONNECTED,
      s_axi_ctrl_arvalid => '0',
      s_axi_ctrl_awaddr(6 downto 0) => B"0000000",
      s_axi_ctrl_awready => NLW_inst_s_axi_ctrl_awready_UNCONNECTED,
      s_axi_ctrl_awvalid => '0',
      s_axi_ctrl_bready => '0',
      s_axi_ctrl_bresp(1 downto 0) => NLW_inst_s_axi_ctrl_bresp_UNCONNECTED(1 downto 0),
      s_axi_ctrl_bvalid => NLW_inst_s_axi_ctrl_bvalid_UNCONNECTED,
      s_axi_ctrl_rdata(31 downto 0) => NLW_inst_s_axi_ctrl_rdata_UNCONNECTED(31 downto 0),
      s_axi_ctrl_rready => '0',
      s_axi_ctrl_rresp(1 downto 0) => NLW_inst_s_axi_ctrl_rresp_UNCONNECTED(1 downto 0),
      s_axi_ctrl_rvalid => NLW_inst_s_axi_ctrl_rvalid_UNCONNECTED,
      s_axi_ctrl_wdata(31 downto 0) => B"00000000000000000000000000000000",
      s_axi_ctrl_wready => NLW_inst_s_axi_ctrl_wready_UNCONNECTED,
      s_axi_ctrl_wvalid => '0',
      s_axis_tdata(15 downto 0) => s_axis_tdata(15 downto 0),
      s_axis_tdest(1 downto 0) => B"00",
      s_axis_tid(1 downto 0) => B"00",
      s_axis_tkeep(1 downto 0) => B"11",
      s_axis_tlast(1 downto 0) => s_axis_tlast(1 downto 0),
      s_axis_tready(1 downto 0) => s_axis_tready(1 downto 0),
      s_axis_tstrb(1 downto 0) => B"11",
      s_axis_tuser(1 downto 0) => B"00",
      s_axis_tvalid(1 downto 0) => s_axis_tvalid(1 downto 0),
      s_decode_err(1 downto 0) => s_decode_err(1 downto 0),
      s_req_suppress(1 downto 0) => s_req_suppress(1 downto 0)
    );
end STRUCTURE;
