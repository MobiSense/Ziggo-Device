-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
-- Date        : Tue Apr 26 21:31:14 2022
-- Host        : DESKTOP-5H7SBV0 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               d:/repositories/tsn_device/IP/axis_switch_1_2/axis_switch_1_2_sim_netlist.vhdl
-- Design      : axis_switch_1_2
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg484-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axis_switch_1_2_axis_register_slice_v1_1_21_axisc_register_slice is
  port (
    \gen_AB_reg_slice.state_reg[1]_0\ : out STD_LOGIC;
    m_axis_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_tlast : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tdest : out STD_LOGIC_VECTOR ( 0 to 0 );
    areset_r : in STD_LOGIC;
    aclk : in STD_LOGIC;
    \gen_AB_reg_slice.sel_rd_reg_0\ : in STD_LOGIC;
    m_axis_tready : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_AB_reg_slice.state_reg[1]_1\ : in STD_LOGIC;
    aclken : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_AB_reg_slice.state_reg[1]_2\ : in STD_LOGIC;
    D : in STD_LOGIC_VECTOR ( 9 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of axis_switch_1_2_axis_register_slice_v1_1_21_axisc_register_slice : entity is "axis_register_slice_v1_1_21_axisc_register_slice";
end axis_switch_1_2_axis_register_slice_v1_1_21_axisc_register_slice;

architecture STRUCTURE of axis_switch_1_2_axis_register_slice_v1_1_21_axisc_register_slice is
  signal \gen_AB_reg_slice.payload_a\ : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal \gen_AB_reg_slice.payload_a_1\ : STD_LOGIC;
  signal \gen_AB_reg_slice.payload_b\ : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal \gen_AB_reg_slice.payload_b_0\ : STD_LOGIC;
  signal \gen_AB_reg_slice.sel\ : STD_LOGIC;
  signal \gen_AB_reg_slice.sel_rd_i_1__0_n_0\ : STD_LOGIC;
  signal \gen_AB_reg_slice.sel_wr\ : STD_LOGIC;
  signal \gen_AB_reg_slice.sel_wr_i_1__0_n_0\ : STD_LOGIC;
  signal \gen_AB_reg_slice.state[0]_i_1_n_0\ : STD_LOGIC;
  signal \gen_AB_reg_slice.state[1]_i_1_n_0\ : STD_LOGIC;
  signal \^gen_ab_reg_slice.state_reg[1]_0\ : STD_LOGIC;
  signal \gen_AB_reg_slice.state_reg_n_0_[0]\ : STD_LOGIC;
  attribute FSM_ENCODING : string;
  attribute FSM_ENCODING of \gen_AB_reg_slice.state_reg[0]\ : label is "none";
  attribute FSM_ENCODING of \gen_AB_reg_slice.state_reg[1]\ : label is "none";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \m_axis_tdata[0]_INST_0\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \m_axis_tdata[1]_INST_0\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \m_axis_tdata[2]_INST_0\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \m_axis_tdata[3]_INST_0\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \m_axis_tdata[4]_INST_0\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \m_axis_tdata[5]_INST_0\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \m_axis_tdata[6]_INST_0\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \m_axis_tdata[7]_INST_0\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \m_axis_tdest[0]_INST_0\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \m_axis_tlast[0]_INST_0\ : label is "soft_lutpair4";
begin
  \gen_AB_reg_slice.state_reg[1]_0\ <= \^gen_ab_reg_slice.state_reg[1]_0\;
\gen_AB_reg_slice.payload_a[9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4404"
    )
        port map (
      I0 => \gen_AB_reg_slice.sel_wr\,
      I1 => aclken,
      I2 => \gen_AB_reg_slice.state_reg_n_0_[0]\,
      I3 => \^gen_ab_reg_slice.state_reg[1]_0\,
      O => \gen_AB_reg_slice.payload_a_1\
    );
\gen_AB_reg_slice.payload_a_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_a_1\,
      D => D(0),
      Q => \gen_AB_reg_slice.payload_a\(0),
      R => '0'
    );
\gen_AB_reg_slice.payload_a_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_a_1\,
      D => D(1),
      Q => \gen_AB_reg_slice.payload_a\(1),
      R => '0'
    );
\gen_AB_reg_slice.payload_a_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_a_1\,
      D => D(2),
      Q => \gen_AB_reg_slice.payload_a\(2),
      R => '0'
    );
\gen_AB_reg_slice.payload_a_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_a_1\,
      D => D(3),
      Q => \gen_AB_reg_slice.payload_a\(3),
      R => '0'
    );
\gen_AB_reg_slice.payload_a_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_a_1\,
      D => D(4),
      Q => \gen_AB_reg_slice.payload_a\(4),
      R => '0'
    );
\gen_AB_reg_slice.payload_a_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_a_1\,
      D => D(5),
      Q => \gen_AB_reg_slice.payload_a\(5),
      R => '0'
    );
\gen_AB_reg_slice.payload_a_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_a_1\,
      D => D(6),
      Q => \gen_AB_reg_slice.payload_a\(6),
      R => '0'
    );
\gen_AB_reg_slice.payload_a_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_a_1\,
      D => D(7),
      Q => \gen_AB_reg_slice.payload_a\(7),
      R => '0'
    );
\gen_AB_reg_slice.payload_a_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_a_1\,
      D => D(8),
      Q => \gen_AB_reg_slice.payload_a\(8),
      R => '0'
    );
\gen_AB_reg_slice.payload_a_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_a_1\,
      D => D(9),
      Q => \gen_AB_reg_slice.payload_a\(9),
      R => '0'
    );
\gen_AB_reg_slice.payload_b[9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8808"
    )
        port map (
      I0 => aclken,
      I1 => \gen_AB_reg_slice.sel_wr\,
      I2 => \gen_AB_reg_slice.state_reg_n_0_[0]\,
      I3 => \^gen_ab_reg_slice.state_reg[1]_0\,
      O => \gen_AB_reg_slice.payload_b_0\
    );
\gen_AB_reg_slice.payload_b_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_b_0\,
      D => D(0),
      Q => \gen_AB_reg_slice.payload_b\(0),
      R => '0'
    );
\gen_AB_reg_slice.payload_b_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_b_0\,
      D => D(1),
      Q => \gen_AB_reg_slice.payload_b\(1),
      R => '0'
    );
\gen_AB_reg_slice.payload_b_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_b_0\,
      D => D(2),
      Q => \gen_AB_reg_slice.payload_b\(2),
      R => '0'
    );
\gen_AB_reg_slice.payload_b_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_b_0\,
      D => D(3),
      Q => \gen_AB_reg_slice.payload_b\(3),
      R => '0'
    );
\gen_AB_reg_slice.payload_b_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_b_0\,
      D => D(4),
      Q => \gen_AB_reg_slice.payload_b\(4),
      R => '0'
    );
\gen_AB_reg_slice.payload_b_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_b_0\,
      D => D(5),
      Q => \gen_AB_reg_slice.payload_b\(5),
      R => '0'
    );
\gen_AB_reg_slice.payload_b_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_b_0\,
      D => D(6),
      Q => \gen_AB_reg_slice.payload_b\(6),
      R => '0'
    );
\gen_AB_reg_slice.payload_b_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_b_0\,
      D => D(7),
      Q => \gen_AB_reg_slice.payload_b\(7),
      R => '0'
    );
\gen_AB_reg_slice.payload_b_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_b_0\,
      D => D(8),
      Q => \gen_AB_reg_slice.payload_b\(8),
      R => '0'
    );
\gen_AB_reg_slice.payload_b_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_AB_reg_slice.payload_b_0\,
      D => D(9),
      Q => \gen_AB_reg_slice.payload_b\(9),
      R => '0'
    );
\gen_AB_reg_slice.sel_rd_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"557FFFFFAA800000"
    )
        port map (
      I0 => \gen_AB_reg_slice.state_reg_n_0_[0]\,
      I1 => \gen_AB_reg_slice.sel_rd_reg_0\,
      I2 => m_axis_tready(0),
      I3 => \gen_AB_reg_slice.state_reg[1]_1\,
      I4 => aclken,
      I5 => \gen_AB_reg_slice.sel\,
      O => \gen_AB_reg_slice.sel_rd_i_1__0_n_0\
    );
\gen_AB_reg_slice.sel_rd_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => aclk,
      CE => '1',
      D => \gen_AB_reg_slice.sel_rd_i_1__0_n_0\,
      Q => \gen_AB_reg_slice.sel\,
      R => areset_r
    );
\gen_AB_reg_slice.sel_wr_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => \^gen_ab_reg_slice.state_reg[1]_0\,
      I1 => aclken,
      I2 => s_axis_tvalid(0),
      I3 => \gen_AB_reg_slice.sel_wr\,
      O => \gen_AB_reg_slice.sel_wr_i_1__0_n_0\
    );
\gen_AB_reg_slice.sel_wr_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => aclk,
      CE => '1',
      D => \gen_AB_reg_slice.sel_wr_i_1__0_n_0\,
      Q => \gen_AB_reg_slice.sel_wr\,
      R => areset_r
    );
\gen_AB_reg_slice.state[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF02AAAAAAAAAAAA"
    )
        port map (
      I0 => \gen_AB_reg_slice.state_reg_n_0_[0]\,
      I1 => \gen_AB_reg_slice.state_reg[1]_1\,
      I2 => \gen_AB_reg_slice.state_reg[1]_2\,
      I3 => s_axis_tvalid(0),
      I4 => aclken,
      I5 => \^gen_ab_reg_slice.state_reg[1]_0\,
      O => \gen_AB_reg_slice.state[0]_i_1_n_0\
    );
\gen_AB_reg_slice.state[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FDFFFFFFFDFD0000"
    )
        port map (
      I0 => \gen_AB_reg_slice.state_reg_n_0_[0]\,
      I1 => \gen_AB_reg_slice.state_reg[1]_1\,
      I2 => \gen_AB_reg_slice.state_reg[1]_2\,
      I3 => s_axis_tvalid(0),
      I4 => aclken,
      I5 => \^gen_ab_reg_slice.state_reg[1]_0\,
      O => \gen_AB_reg_slice.state[1]_i_1_n_0\
    );
\gen_AB_reg_slice.state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => aclk,
      CE => '1',
      D => \gen_AB_reg_slice.state[0]_i_1_n_0\,
      Q => \gen_AB_reg_slice.state_reg_n_0_[0]\,
      R => areset_r
    );
\gen_AB_reg_slice.state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => aclk,
      CE => '1',
      D => \gen_AB_reg_slice.state[1]_i_1_n_0\,
      Q => \^gen_ab_reg_slice.state_reg[1]_0\,
      R => areset_r
    );
\m_axis_tdata[0]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \gen_AB_reg_slice.payload_b\(0),
      I1 => \gen_AB_reg_slice.payload_a\(0),
      I2 => \gen_AB_reg_slice.sel\,
      O => m_axis_tdata(0)
    );
\m_axis_tdata[1]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \gen_AB_reg_slice.payload_b\(1),
      I1 => \gen_AB_reg_slice.payload_a\(1),
      I2 => \gen_AB_reg_slice.sel\,
      O => m_axis_tdata(1)
    );
\m_axis_tdata[2]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \gen_AB_reg_slice.payload_b\(2),
      I1 => \gen_AB_reg_slice.payload_a\(2),
      I2 => \gen_AB_reg_slice.sel\,
      O => m_axis_tdata(2)
    );
\m_axis_tdata[3]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \gen_AB_reg_slice.payload_b\(3),
      I1 => \gen_AB_reg_slice.payload_a\(3),
      I2 => \gen_AB_reg_slice.sel\,
      O => m_axis_tdata(3)
    );
\m_axis_tdata[4]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \gen_AB_reg_slice.payload_b\(4),
      I1 => \gen_AB_reg_slice.payload_a\(4),
      I2 => \gen_AB_reg_slice.sel\,
      O => m_axis_tdata(4)
    );
\m_axis_tdata[5]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \gen_AB_reg_slice.payload_b\(5),
      I1 => \gen_AB_reg_slice.payload_a\(5),
      I2 => \gen_AB_reg_slice.sel\,
      O => m_axis_tdata(5)
    );
\m_axis_tdata[6]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \gen_AB_reg_slice.payload_b\(6),
      I1 => \gen_AB_reg_slice.payload_a\(6),
      I2 => \gen_AB_reg_slice.sel\,
      O => m_axis_tdata(6)
    );
\m_axis_tdata[7]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \gen_AB_reg_slice.payload_b\(7),
      I1 => \gen_AB_reg_slice.payload_a\(7),
      I2 => \gen_AB_reg_slice.sel\,
      O => m_axis_tdata(7)
    );
\m_axis_tdest[0]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \gen_AB_reg_slice.payload_b\(9),
      I1 => \gen_AB_reg_slice.payload_a\(9),
      I2 => \gen_AB_reg_slice.sel\,
      O => m_axis_tdest(0)
    );
\m_axis_tlast[0]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \gen_AB_reg_slice.payload_b\(8),
      I1 => \gen_AB_reg_slice.payload_a\(8),
      I2 => \gen_AB_reg_slice.sel\,
      O => m_axis_tlast(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \axis_switch_1_2_axis_register_slice_v1_1_21_axisc_register_slice__parameterized0\ is
  port (
    \gen_AB_reg_slice.state_reg[0]_0\ : out STD_LOGIC;
    m_axis_tvalid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axis_tready_0_sp_1 : out STD_LOGIC;
    \gen_AB_reg_slice.payload_a_reg[1]_0\ : out STD_LOGIC;
    areset_r : in STD_LOGIC;
    aclk : in STD_LOGIC;
    aclken : in STD_LOGIC;
    s_decode_err : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axis_tvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tdest : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \axis_switch_1_2_axis_register_slice_v1_1_21_axisc_register_slice__parameterized0\ : entity is "axis_register_slice_v1_1_21_axisc_register_slice";
end \axis_switch_1_2_axis_register_slice_v1_1_21_axisc_register_slice__parameterized0\;

architecture STRUCTURE of \axis_switch_1_2_axis_register_slice_v1_1_21_axisc_register_slice__parameterized0\ is
  signal \gen_AB_reg_slice.payload_a\ : STD_LOGIC;
  signal \gen_AB_reg_slice.payload_a[0]_i_1_n_0\ : STD_LOGIC;
  signal \gen_AB_reg_slice.payload_a[1]_i_1_n_0\ : STD_LOGIC;
  signal \^gen_ab_reg_slice.payload_a_reg[1]_0\ : STD_LOGIC;
  signal \gen_AB_reg_slice.payload_a_reg_n_0_[0]\ : STD_LOGIC;
  signal \gen_AB_reg_slice.payload_a_reg_n_0_[1]\ : STD_LOGIC;
  signal \gen_AB_reg_slice.payload_b\ : STD_LOGIC;
  signal \gen_AB_reg_slice.payload_b[0]_i_1_n_0\ : STD_LOGIC;
  signal \gen_AB_reg_slice.payload_b[1]_i_1_n_0\ : STD_LOGIC;
  signal \gen_AB_reg_slice.payload_b_reg_n_0_[0]\ : STD_LOGIC;
  signal \gen_AB_reg_slice.payload_b_reg_n_0_[1]\ : STD_LOGIC;
  signal \gen_AB_reg_slice.sel\ : STD_LOGIC;
  signal \gen_AB_reg_slice.sel_rd_i_1_n_0\ : STD_LOGIC;
  signal \gen_AB_reg_slice.sel_wr\ : STD_LOGIC;
  signal \gen_AB_reg_slice.sel_wr_i_1_n_0\ : STD_LOGIC;
  signal \gen_AB_reg_slice.state[0]_i_1_n_0\ : STD_LOGIC;
  signal \gen_AB_reg_slice.state[1]_i_1_n_0\ : STD_LOGIC;
  signal \gen_AB_reg_slice.state_reg_n_0_[1]\ : STD_LOGIC;
  signal \gen_tdest_routing.m_axis_tvalid_req\ : STD_LOGIC;
  signal m_axis_tready_0_sn_1 : STD_LOGIC;
  signal \^m_axis_tvalid\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \gen_AB_reg_slice.payload_a[0]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \gen_AB_reg_slice.payload_a[1]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \gen_AB_reg_slice.payload_a[1]_i_2\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \gen_AB_reg_slice.payload_b[0]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \gen_AB_reg_slice.payload_b[1]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \gen_AB_reg_slice.payload_b[1]_i_2\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \gen_AB_reg_slice.state[1]_i_3\ : label is "soft_lutpair5";
  attribute FSM_ENCODING : string;
  attribute FSM_ENCODING of \gen_AB_reg_slice.state_reg[0]\ : label is "none";
  attribute FSM_ENCODING of \gen_AB_reg_slice.state_reg[1]\ : label is "none";
  attribute SOFT_HLUTNM of \m_axis_tvalid[1]_INST_0\ : label is "soft_lutpair5";
begin
  \gen_AB_reg_slice.payload_a_reg[1]_0\ <= \^gen_ab_reg_slice.payload_a_reg[1]_0\;
  m_axis_tready_0_sp_1 <= m_axis_tready_0_sn_1;
  m_axis_tvalid(1 downto 0) <= \^m_axis_tvalid\(1 downto 0);
\gen_AB_reg_slice.payload_a[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F20"
    )
        port map (
      I0 => s_axis_tvalid(0),
      I1 => s_axis_tdest(0),
      I2 => \gen_AB_reg_slice.payload_a\,
      I3 => \gen_AB_reg_slice.payload_a_reg_n_0_[0]\,
      O => \gen_AB_reg_slice.payload_a[0]_i_1_n_0\
    );
\gen_AB_reg_slice.payload_a[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8F80"
    )
        port map (
      I0 => s_axis_tvalid(0),
      I1 => s_axis_tdest(0),
      I2 => \gen_AB_reg_slice.payload_a\,
      I3 => \gen_AB_reg_slice.payload_a_reg_n_0_[1]\,
      O => \gen_AB_reg_slice.payload_a[1]_i_1_n_0\
    );
\gen_AB_reg_slice.payload_a[1]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4404"
    )
        port map (
      I0 => \gen_AB_reg_slice.sel_wr\,
      I1 => aclken,
      I2 => \gen_tdest_routing.m_axis_tvalid_req\,
      I3 => \gen_AB_reg_slice.state_reg_n_0_[1]\,
      O => \gen_AB_reg_slice.payload_a\
    );
\gen_AB_reg_slice.payload_a_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_AB_reg_slice.payload_a[0]_i_1_n_0\,
      Q => \gen_AB_reg_slice.payload_a_reg_n_0_[0]\,
      R => '0'
    );
\gen_AB_reg_slice.payload_a_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_AB_reg_slice.payload_a[1]_i_1_n_0\,
      Q => \gen_AB_reg_slice.payload_a_reg_n_0_[1]\,
      R => '0'
    );
\gen_AB_reg_slice.payload_b[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F20"
    )
        port map (
      I0 => s_axis_tvalid(0),
      I1 => s_axis_tdest(0),
      I2 => \gen_AB_reg_slice.payload_b\,
      I3 => \gen_AB_reg_slice.payload_b_reg_n_0_[0]\,
      O => \gen_AB_reg_slice.payload_b[0]_i_1_n_0\
    );
\gen_AB_reg_slice.payload_b[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8F80"
    )
        port map (
      I0 => s_axis_tvalid(0),
      I1 => s_axis_tdest(0),
      I2 => \gen_AB_reg_slice.payload_b\,
      I3 => \gen_AB_reg_slice.payload_b_reg_n_0_[1]\,
      O => \gen_AB_reg_slice.payload_b[1]_i_1_n_0\
    );
\gen_AB_reg_slice.payload_b[1]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8808"
    )
        port map (
      I0 => aclken,
      I1 => \gen_AB_reg_slice.sel_wr\,
      I2 => \gen_tdest_routing.m_axis_tvalid_req\,
      I3 => \gen_AB_reg_slice.state_reg_n_0_[1]\,
      O => \gen_AB_reg_slice.payload_b\
    );
\gen_AB_reg_slice.payload_b_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_AB_reg_slice.payload_b[0]_i_1_n_0\,
      Q => \gen_AB_reg_slice.payload_b_reg_n_0_[0]\,
      R => '0'
    );
\gen_AB_reg_slice.payload_b_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_AB_reg_slice.payload_b[1]_i_1_n_0\,
      Q => \gen_AB_reg_slice.payload_b_reg_n_0_[1]\,
      R => '0'
    );
\gen_AB_reg_slice.sel_rd_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"07FFFFFFF8000000"
    )
        port map (
      I0 => \^m_axis_tvalid\(1),
      I1 => m_axis_tready(1),
      I2 => m_axis_tready_0_sn_1,
      I3 => \gen_tdest_routing.m_axis_tvalid_req\,
      I4 => aclken,
      I5 => \gen_AB_reg_slice.sel\,
      O => \gen_AB_reg_slice.sel_rd_i_1_n_0\
    );
\gen_AB_reg_slice.sel_rd_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => aclk,
      CE => '1',
      D => \gen_AB_reg_slice.sel_rd_i_1_n_0\,
      Q => \gen_AB_reg_slice.sel\,
      R => areset_r
    );
\gen_AB_reg_slice.sel_wr_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => \gen_AB_reg_slice.state_reg_n_0_[1]\,
      I1 => aclken,
      I2 => s_axis_tvalid(0),
      I3 => \gen_AB_reg_slice.sel_wr\,
      O => \gen_AB_reg_slice.sel_wr_i_1_n_0\
    );
\gen_AB_reg_slice.sel_wr_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => aclk,
      CE => '1',
      D => \gen_AB_reg_slice.sel_wr_i_1_n_0\,
      Q => \gen_AB_reg_slice.sel_wr\,
      R => areset_r
    );
\gen_AB_reg_slice.state[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF02AAAAAAAAAAAA"
    )
        port map (
      I0 => \gen_tdest_routing.m_axis_tvalid_req\,
      I1 => m_axis_tready_0_sn_1,
      I2 => \^gen_ab_reg_slice.payload_a_reg[1]_0\,
      I3 => s_axis_tvalid(0),
      I4 => aclken,
      I5 => \gen_AB_reg_slice.state_reg_n_0_[1]\,
      O => \gen_AB_reg_slice.state[0]_i_1_n_0\
    );
\gen_AB_reg_slice.state[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FDFFFFFFFDFD0000"
    )
        port map (
      I0 => \gen_tdest_routing.m_axis_tvalid_req\,
      I1 => m_axis_tready_0_sn_1,
      I2 => \^gen_ab_reg_slice.payload_a_reg[1]_0\,
      I3 => s_axis_tvalid(0),
      I4 => aclken,
      I5 => \gen_AB_reg_slice.state_reg_n_0_[1]\,
      O => \gen_AB_reg_slice.state[1]_i_1_n_0\
    );
\gen_AB_reg_slice.state[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF8A008000"
    )
        port map (
      I0 => m_axis_tready(0),
      I1 => \gen_AB_reg_slice.payload_b_reg_n_0_[0]\,
      I2 => \gen_AB_reg_slice.sel\,
      I3 => \gen_tdest_routing.m_axis_tvalid_req\,
      I4 => \gen_AB_reg_slice.payload_a_reg_n_0_[0]\,
      I5 => s_decode_err(0),
      O => m_axis_tready_0_sn_1
    );
\gen_AB_reg_slice.state[1]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"C8080000"
    )
        port map (
      I0 => \gen_AB_reg_slice.payload_a_reg_n_0_[1]\,
      I1 => \gen_tdest_routing.m_axis_tvalid_req\,
      I2 => \gen_AB_reg_slice.sel\,
      I3 => \gen_AB_reg_slice.payload_b_reg_n_0_[1]\,
      I4 => m_axis_tready(1),
      O => \^gen_ab_reg_slice.payload_a_reg[1]_0\
    );
\gen_AB_reg_slice.state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => aclk,
      CE => '1',
      D => \gen_AB_reg_slice.state[0]_i_1_n_0\,
      Q => \gen_tdest_routing.m_axis_tvalid_req\,
      R => areset_r
    );
\gen_AB_reg_slice.state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => aclk,
      CE => '1',
      D => \gen_AB_reg_slice.state[1]_i_1_n_0\,
      Q => \gen_AB_reg_slice.state_reg_n_0_[1]\,
      R => areset_r
    );
\gen_tdest_routing.decode_err_r_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00FF0400"
    )
        port map (
      I0 => \^m_axis_tvalid\(0),
      I1 => \gen_tdest_routing.m_axis_tvalid_req\,
      I2 => \^m_axis_tvalid\(1),
      I3 => aclken,
      I4 => s_decode_err(0),
      O => \gen_AB_reg_slice.state_reg[0]_0\
    );
\m_axis_tvalid[0]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B080"
    )
        port map (
      I0 => \gen_AB_reg_slice.payload_b_reg_n_0_[0]\,
      I1 => \gen_AB_reg_slice.sel\,
      I2 => \gen_tdest_routing.m_axis_tvalid_req\,
      I3 => \gen_AB_reg_slice.payload_a_reg_n_0_[0]\,
      O => \^m_axis_tvalid\(0)
    );
\m_axis_tvalid[1]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B080"
    )
        port map (
      I0 => \gen_AB_reg_slice.payload_b_reg_n_0_[1]\,
      I1 => \gen_AB_reg_slice.sel\,
      I2 => \gen_tdest_routing.m_axis_tvalid_req\,
      I3 => \gen_AB_reg_slice.payload_a_reg_n_0_[1]\,
      O => \^m_axis_tvalid\(1)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axis_switch_1_2_axis_switch_v1_1_21_axisc_decoder is
  port (
    s_decode_err : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tvalid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \gen_AB_reg_slice.state_reg[1]\ : out STD_LOGIC;
    m_axis_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_tlast : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tdest : out STD_LOGIC_VECTOR ( 0 to 0 );
    areset_r : in STD_LOGIC;
    aclk : in STD_LOGIC;
    aclken : in STD_LOGIC;
    m_axis_tready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axis_tvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tdest : in STD_LOGIC_VECTOR ( 0 to 0 );
    D : in STD_LOGIC_VECTOR ( 8 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of axis_switch_1_2_axis_switch_v1_1_21_axisc_decoder : entity is "axis_switch_v1_1_21_axisc_decoder";
end axis_switch_1_2_axis_switch_v1_1_21_axisc_decoder;

architecture STRUCTURE of axis_switch_1_2_axis_switch_v1_1_21_axisc_decoder is
  signal \gen_tdest_routing.gen_tdest_decoder.axisc_register_slice_1_n_0\ : STD_LOGIC;
  signal \gen_tdest_routing.gen_tdest_decoder.axisc_register_slice_1_n_3\ : STD_LOGIC;
  signal \gen_tdest_routing.gen_tdest_decoder.axisc_register_slice_1_n_4\ : STD_LOGIC;
  signal \^m_axis_tvalid\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \^s_decode_err\ : STD_LOGIC_VECTOR ( 0 to 0 );
begin
  m_axis_tvalid(1 downto 0) <= \^m_axis_tvalid\(1 downto 0);
  s_decode_err(0) <= \^s_decode_err\(0);
\gen_tdest_routing.decode_err_r_reg\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_tdest_routing.gen_tdest_decoder.axisc_register_slice_1_n_0\,
      Q => \^s_decode_err\(0),
      R => areset_r
    );
\gen_tdest_routing.gen_tdest_decoder.axisc_register_slice_0\: entity work.axis_switch_1_2_axis_register_slice_v1_1_21_axisc_register_slice
     port map (
      D(9) => s_axis_tdest(0),
      D(8 downto 0) => D(8 downto 0),
      aclk => aclk,
      aclken => aclken,
      areset_r => areset_r,
      \gen_AB_reg_slice.sel_rd_reg_0\ => \^m_axis_tvalid\(1),
      \gen_AB_reg_slice.state_reg[1]_0\ => \gen_AB_reg_slice.state_reg[1]\,
      \gen_AB_reg_slice.state_reg[1]_1\ => \gen_tdest_routing.gen_tdest_decoder.axisc_register_slice_1_n_3\,
      \gen_AB_reg_slice.state_reg[1]_2\ => \gen_tdest_routing.gen_tdest_decoder.axisc_register_slice_1_n_4\,
      m_axis_tdata(7 downto 0) => m_axis_tdata(7 downto 0),
      m_axis_tdest(0) => m_axis_tdest(0),
      m_axis_tlast(0) => m_axis_tlast(0),
      m_axis_tready(0) => m_axis_tready(1),
      s_axis_tvalid(0) => s_axis_tvalid(0)
    );
\gen_tdest_routing.gen_tdest_decoder.axisc_register_slice_1\: entity work.\axis_switch_1_2_axis_register_slice_v1_1_21_axisc_register_slice__parameterized0\
     port map (
      aclk => aclk,
      aclken => aclken,
      areset_r => areset_r,
      \gen_AB_reg_slice.payload_a_reg[1]_0\ => \gen_tdest_routing.gen_tdest_decoder.axisc_register_slice_1_n_4\,
      \gen_AB_reg_slice.state_reg[0]_0\ => \gen_tdest_routing.gen_tdest_decoder.axisc_register_slice_1_n_0\,
      m_axis_tready(1 downto 0) => m_axis_tready(1 downto 0),
      m_axis_tready_0_sp_1 => \gen_tdest_routing.gen_tdest_decoder.axisc_register_slice_1_n_3\,
      m_axis_tvalid(1 downto 0) => \^m_axis_tvalid\(1 downto 0),
      s_axis_tdest(0) => s_axis_tdest(0),
      s_axis_tvalid(0) => s_axis_tvalid(0),
      s_decode_err(0) => \^s_decode_err\(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axis_switch_1_2_axis_switch_v1_1_21_axis_switch is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    aclken : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tdata : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axis_tstrb : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tkeep : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tlast : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tdest : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tvalid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axis_tready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axis_tdata : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_axis_tstrb : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axis_tkeep : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axis_tlast : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axis_tid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axis_tdest : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axis_tuser : out STD_LOGIC_VECTOR ( 1 downto 0 );
    arb_req : out STD_LOGIC_VECTOR ( 1 downto 0 );
    arb_done : out STD_LOGIC_VECTOR ( 1 downto 0 );
    arb_gnt : in STD_LOGIC_VECTOR ( 1 downto 0 );
    arb_sel : in STD_LOGIC_VECTOR ( 1 downto 0 );
    arb_last : out STD_LOGIC_VECTOR ( 1 downto 0 );
    arb_id : out STD_LOGIC_VECTOR ( 1 downto 0 );
    arb_dest : out STD_LOGIC_VECTOR ( 1 downto 0 );
    arb_user : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_req_suppress : in STD_LOGIC_VECTOR ( 0 to 0 );
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
    s_decode_err : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute C_ARB_ALGORITHM : integer;
  attribute C_ARB_ALGORITHM of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 0;
  attribute C_ARB_ON_MAX_XFERS : integer;
  attribute C_ARB_ON_MAX_XFERS of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute C_ARB_ON_NUM_CYCLES : integer;
  attribute C_ARB_ON_NUM_CYCLES of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 0;
  attribute C_ARB_ON_TLAST : integer;
  attribute C_ARB_ON_TLAST of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 0;
  attribute C_AXIS_SIGNAL_SET : integer;
  attribute C_AXIS_SIGNAL_SET of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 83;
  attribute C_AXIS_TDATA_WIDTH : integer;
  attribute C_AXIS_TDATA_WIDTH of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 8;
  attribute C_AXIS_TDEST_WIDTH : integer;
  attribute C_AXIS_TDEST_WIDTH of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute C_AXIS_TID_WIDTH : integer;
  attribute C_AXIS_TID_WIDTH of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute C_AXIS_TUSER_WIDTH : integer;
  attribute C_AXIS_TUSER_WIDTH of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute C_COMMON_CLOCK : integer;
  attribute C_COMMON_CLOCK of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 0;
  attribute C_DECODER_REG : integer;
  attribute C_DECODER_REG of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute C_FAMILY : string;
  attribute C_FAMILY of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is "zynq";
  attribute C_INCLUDE_ARBITER : integer;
  attribute C_INCLUDE_ARBITER of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute C_LOG_SI_SLOTS : integer;
  attribute C_LOG_SI_SLOTS of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute C_M_AXIS_BASETDEST_ARRAY : string;
  attribute C_M_AXIS_BASETDEST_ARRAY of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is "2'b10";
  attribute C_M_AXIS_CONNECTIVITY_ARRAY : string;
  attribute C_M_AXIS_CONNECTIVITY_ARRAY of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is "2'b11";
  attribute C_M_AXIS_HIGHTDEST_ARRAY : string;
  attribute C_M_AXIS_HIGHTDEST_ARRAY of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is "2'b10";
  attribute C_NUM_MI_SLOTS : integer;
  attribute C_NUM_MI_SLOTS of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 2;
  attribute C_NUM_SI_SLOTS : integer;
  attribute C_NUM_SI_SLOTS of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute C_OUTPUT_REG : integer;
  attribute C_OUTPUT_REG of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 0;
  attribute C_ROUTING_MODE : integer;
  attribute C_ROUTING_MODE of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 0;
  attribute C_S_AXI_CTRL_ADDR_WIDTH : integer;
  attribute C_S_AXI_CTRL_ADDR_WIDTH of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 7;
  attribute C_S_AXI_CTRL_DATA_WIDTH : integer;
  attribute C_S_AXI_CTRL_DATA_WIDTH of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 32;
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is "yes";
  attribute G_INDX_SS_TDATA : integer;
  attribute G_INDX_SS_TDATA of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute G_INDX_SS_TDEST : integer;
  attribute G_INDX_SS_TDEST of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 6;
  attribute G_INDX_SS_TID : integer;
  attribute G_INDX_SS_TID of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 5;
  attribute G_INDX_SS_TKEEP : integer;
  attribute G_INDX_SS_TKEEP of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 3;
  attribute G_INDX_SS_TLAST : integer;
  attribute G_INDX_SS_TLAST of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 4;
  attribute G_INDX_SS_TREADY : integer;
  attribute G_INDX_SS_TREADY of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 0;
  attribute G_INDX_SS_TSTRB : integer;
  attribute G_INDX_SS_TSTRB of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 2;
  attribute G_INDX_SS_TUSER : integer;
  attribute G_INDX_SS_TUSER of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 7;
  attribute G_MASK_SS_TDATA : integer;
  attribute G_MASK_SS_TDATA of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 2;
  attribute G_MASK_SS_TDEST : integer;
  attribute G_MASK_SS_TDEST of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 64;
  attribute G_MASK_SS_TID : integer;
  attribute G_MASK_SS_TID of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 32;
  attribute G_MASK_SS_TKEEP : integer;
  attribute G_MASK_SS_TKEEP of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 8;
  attribute G_MASK_SS_TLAST : integer;
  attribute G_MASK_SS_TLAST of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 16;
  attribute G_MASK_SS_TREADY : integer;
  attribute G_MASK_SS_TREADY of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute G_MASK_SS_TSTRB : integer;
  attribute G_MASK_SS_TSTRB of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 4;
  attribute G_MASK_SS_TUSER : integer;
  attribute G_MASK_SS_TUSER of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 128;
  attribute G_TASK_SEVERITY_ERR : integer;
  attribute G_TASK_SEVERITY_ERR of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 2;
  attribute G_TASK_SEVERITY_INFO : integer;
  attribute G_TASK_SEVERITY_INFO of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 0;
  attribute G_TASK_SEVERITY_WARNING : integer;
  attribute G_TASK_SEVERITY_WARNING of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 1;
  attribute LP_CTRL_REG_WIDTH : integer;
  attribute LP_CTRL_REG_WIDTH of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 15;
  attribute LP_MERGEDOWN_MUX : integer;
  attribute LP_MERGEDOWN_MUX of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 0;
  attribute LP_NUM_SYNCHRONIZER_STAGES : integer;
  attribute LP_NUM_SYNCHRONIZER_STAGES of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 4;
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is "axis_switch_v1_1_21_axis_switch";
  attribute P_DECODER_CONNECTIVITY_ARRAY : string;
  attribute P_DECODER_CONNECTIVITY_ARRAY of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is "2'b11";
  attribute P_SINGLE_SLAVE_CONNECTIVITY_ARRAY : string;
  attribute P_SINGLE_SLAVE_CONNECTIVITY_ARRAY of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is "2'b11";
  attribute P_TPAYLOAD_WIDTH : integer;
  attribute P_TPAYLOAD_WIDTH of axis_switch_1_2_axis_switch_v1_1_21_axis_switch : entity is 10;
end axis_switch_1_2_axis_switch_v1_1_21_axis_switch;

architecture STRUCTURE of axis_switch_1_2_axis_switch_v1_1_21_axis_switch is
  signal \<const0>\ : STD_LOGIC;
  signal \<const1>\ : STD_LOGIC;
  signal areset_r : STD_LOGIC;
  signal areset_r_i_1_n_0 : STD_LOGIC;
  signal \^m_axis_tdata\ : STD_LOGIC_VECTOR ( 15 downto 8 );
  signal \^m_axis_tdest\ : STD_LOGIC_VECTOR ( 1 to 1 );
  signal \^m_axis_tlast\ : STD_LOGIC_VECTOR ( 1 to 1 );
begin
  arb_dest(1) <= \<const0>\;
  arb_dest(0) <= \<const0>\;
  arb_done(1) <= \<const0>\;
  arb_done(0) <= \<const0>\;
  arb_id(1) <= \<const0>\;
  arb_id(0) <= \<const0>\;
  arb_last(1) <= \<const0>\;
  arb_last(0) <= \<const0>\;
  arb_req(1) <= \<const0>\;
  arb_req(0) <= \<const0>\;
  arb_user(1) <= \<const0>\;
  arb_user(0) <= \<const0>\;
  m_axis_tdata(15 downto 8) <= \^m_axis_tdata\(15 downto 8);
  m_axis_tdata(7 downto 0) <= \^m_axis_tdata\(15 downto 8);
  m_axis_tdest(1) <= \^m_axis_tdest\(1);
  m_axis_tdest(0) <= \^m_axis_tdest\(1);
  m_axis_tid(1) <= \<const0>\;
  m_axis_tid(0) <= \<const0>\;
  m_axis_tkeep(1) <= \<const1>\;
  m_axis_tkeep(0) <= \<const1>\;
  m_axis_tlast(1) <= \^m_axis_tlast\(1);
  m_axis_tlast(0) <= \^m_axis_tlast\(1);
  m_axis_tstrb(1) <= \<const0>\;
  m_axis_tstrb(0) <= \<const0>\;
  m_axis_tuser(1) <= \<const0>\;
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
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
VCC: unisim.vcomponents.VCC
     port map (
      P => \<const1>\
    );
areset_r_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => aresetn,
      O => areset_r_i_1_n_0
    );
areset_r_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => areset_r_i_1_n_0,
      Q => areset_r,
      R => '0'
    );
\gen_decoder[0].axisc_decoder_0\: entity work.axis_switch_1_2_axis_switch_v1_1_21_axisc_decoder
     port map (
      D(8) => s_axis_tlast(0),
      D(7 downto 0) => s_axis_tdata(7 downto 0),
      aclk => aclk,
      aclken => aclken,
      areset_r => areset_r,
      \gen_AB_reg_slice.state_reg[1]\ => s_axis_tready(0),
      m_axis_tdata(7 downto 0) => \^m_axis_tdata\(15 downto 8),
      m_axis_tdest(0) => \^m_axis_tdest\(1),
      m_axis_tlast(0) => \^m_axis_tlast\(1),
      m_axis_tready(1 downto 0) => m_axis_tready(1 downto 0),
      m_axis_tvalid(1 downto 0) => m_axis_tvalid(1 downto 0),
      s_axis_tdest(0) => s_axis_tdest(0),
      s_axis_tvalid(0) => s_axis_tvalid(0),
      s_decode_err(0) => s_decode_err(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axis_switch_1_2 is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tdata : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axis_tlast : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tdest : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tvalid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axis_tready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axis_tdata : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_axis_tlast : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axis_tdest : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_decode_err : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of axis_switch_1_2 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of axis_switch_1_2 : entity is "axis_switch_1_2,axis_switch_v1_1_21_axis_switch,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of axis_switch_1_2 : entity is "yes";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of axis_switch_1_2 : entity is "axis_switch_v1_1_21_axis_switch,Vivado 2020.1";
end axis_switch_1_2;

architecture STRUCTURE of axis_switch_1_2 is
  signal NLW_inst_s_axi_ctrl_arready_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_s_axi_ctrl_awready_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_s_axi_ctrl_bvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_s_axi_ctrl_rvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_s_axi_ctrl_wready_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_arb_dest_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_arb_done_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_arb_id_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_arb_last_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_arb_req_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_arb_user_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_m_axis_tid_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_m_axis_tkeep_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_m_axis_tstrb_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_m_axis_tuser_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
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
  attribute C_AXIS_SIGNAL_SET of inst : label is 83;
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
  attribute C_DECODER_REG of inst : label is 1;
  attribute C_FAMILY : string;
  attribute C_FAMILY of inst : label is "zynq";
  attribute C_INCLUDE_ARBITER : integer;
  attribute C_INCLUDE_ARBITER of inst : label is 1;
  attribute C_LOG_SI_SLOTS : integer;
  attribute C_LOG_SI_SLOTS of inst : label is 1;
  attribute C_M_AXIS_BASETDEST_ARRAY : string;
  attribute C_M_AXIS_BASETDEST_ARRAY of inst : label is "2'b10";
  attribute C_M_AXIS_CONNECTIVITY_ARRAY : string;
  attribute C_M_AXIS_CONNECTIVITY_ARRAY of inst : label is "2'b11";
  attribute C_M_AXIS_HIGHTDEST_ARRAY : string;
  attribute C_M_AXIS_HIGHTDEST_ARRAY of inst : label is "2'b10";
  attribute C_NUM_MI_SLOTS : integer;
  attribute C_NUM_MI_SLOTS of inst : label is 2;
  attribute C_NUM_SI_SLOTS : integer;
  attribute C_NUM_SI_SLOTS of inst : label is 1;
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
  attribute P_SINGLE_SLAVE_CONNECTIVITY_ARRAY of inst : label is "2'b11";
  attribute P_TPAYLOAD_WIDTH : integer;
  attribute P_TPAYLOAD_WIDTH of inst : label is 10;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of aclk : signal is "xilinx.com:signal:clock:1.0 CLKIF CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of aclk : signal is "XIL_INTERFACENAME CLKIF, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of aresetn : signal is "xilinx.com:signal:reset:1.0 RSTIF RST";
  attribute X_INTERFACE_PARAMETER of aresetn : signal is "XIL_INTERFACENAME RSTIF, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m_axis_tdata : signal is "xilinx.com:interface:axis:1.0 M00_AXIS TDATA [7:0] [7:0], xilinx.com:interface:axis:1.0 M01_AXIS TDATA [7:0] [15:8]";
  attribute X_INTERFACE_INFO of m_axis_tdest : signal is "xilinx.com:interface:axis:1.0 M00_AXIS TDEST [0:0] [0:0], xilinx.com:interface:axis:1.0 M01_AXIS TDEST [0:0] [1:1]";
  attribute X_INTERFACE_PARAMETER of m_axis_tdest : signal is "XIL_INTERFACENAME M00_AXIS, TDATA_NUM_BYTES 1, TDEST_WIDTH 1, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, INSERT_VIP 0, XIL_INTERFACENAME M01_AXIS, TDATA_NUM_BYTES 1, TDEST_WIDTH 1, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m_axis_tlast : signal is "xilinx.com:interface:axis:1.0 M00_AXIS TLAST [0:0] [0:0], xilinx.com:interface:axis:1.0 M01_AXIS TLAST [0:0] [1:1]";
  attribute X_INTERFACE_INFO of m_axis_tready : signal is "xilinx.com:interface:axis:1.0 M00_AXIS TREADY [0:0] [0:0], xilinx.com:interface:axis:1.0 M01_AXIS TREADY [0:0] [1:1]";
  attribute X_INTERFACE_INFO of m_axis_tvalid : signal is "xilinx.com:interface:axis:1.0 M00_AXIS TVALID [0:0] [0:0], xilinx.com:interface:axis:1.0 M01_AXIS TVALID [0:0] [1:1]";
  attribute X_INTERFACE_INFO of s_axis_tdata : signal is "xilinx.com:interface:axis:1.0 S00_AXIS TDATA";
  attribute X_INTERFACE_INFO of s_axis_tdest : signal is "xilinx.com:interface:axis:1.0 S00_AXIS TDEST";
  attribute X_INTERFACE_PARAMETER of s_axis_tdest : signal is "XIL_INTERFACENAME S00_AXIS, TDATA_NUM_BYTES 1, TDEST_WIDTH 1, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axis_tlast : signal is "xilinx.com:interface:axis:1.0 S00_AXIS TLAST";
  attribute X_INTERFACE_INFO of s_axis_tready : signal is "xilinx.com:interface:axis:1.0 S00_AXIS TREADY";
  attribute X_INTERFACE_INFO of s_axis_tvalid : signal is "xilinx.com:interface:axis:1.0 S00_AXIS TVALID";
begin
inst: entity work.axis_switch_1_2_axis_switch_v1_1_21_axis_switch
     port map (
      aclk => aclk,
      aclken => '1',
      arb_dest(1 downto 0) => NLW_inst_arb_dest_UNCONNECTED(1 downto 0),
      arb_done(1 downto 0) => NLW_inst_arb_done_UNCONNECTED(1 downto 0),
      arb_gnt(1 downto 0) => B"00",
      arb_id(1 downto 0) => NLW_inst_arb_id_UNCONNECTED(1 downto 0),
      arb_last(1 downto 0) => NLW_inst_arb_last_UNCONNECTED(1 downto 0),
      arb_req(1 downto 0) => NLW_inst_arb_req_UNCONNECTED(1 downto 0),
      arb_sel(1 downto 0) => B"00",
      arb_user(1 downto 0) => NLW_inst_arb_user_UNCONNECTED(1 downto 0),
      aresetn => aresetn,
      m_axis_tdata(15 downto 0) => m_axis_tdata(15 downto 0),
      m_axis_tdest(1 downto 0) => m_axis_tdest(1 downto 0),
      m_axis_tid(1 downto 0) => NLW_inst_m_axis_tid_UNCONNECTED(1 downto 0),
      m_axis_tkeep(1 downto 0) => NLW_inst_m_axis_tkeep_UNCONNECTED(1 downto 0),
      m_axis_tlast(1 downto 0) => m_axis_tlast(1 downto 0),
      m_axis_tready(1 downto 0) => m_axis_tready(1 downto 0),
      m_axis_tstrb(1 downto 0) => NLW_inst_m_axis_tstrb_UNCONNECTED(1 downto 0),
      m_axis_tuser(1 downto 0) => NLW_inst_m_axis_tuser_UNCONNECTED(1 downto 0),
      m_axis_tvalid(1 downto 0) => m_axis_tvalid(1 downto 0),
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
      s_axis_tdata(7 downto 0) => s_axis_tdata(7 downto 0),
      s_axis_tdest(0) => s_axis_tdest(0),
      s_axis_tid(0) => '0',
      s_axis_tkeep(0) => '1',
      s_axis_tlast(0) => s_axis_tlast(0),
      s_axis_tready(0) => s_axis_tready(0),
      s_axis_tstrb(0) => '1',
      s_axis_tuser(0) => '0',
      s_axis_tvalid(0) => s_axis_tvalid(0),
      s_decode_err(0) => s_decode_err(0),
      s_req_suppress(0) => '0'
    );
end STRUCTURE;
