module fb_divider (fb_clk,
    rst_n,
    vco_clk);
 output fb_clk;
 input rst_n;
 input vco_clk;

 wire _00_;
 wire _01_;
 wire _02_;
 wire _03_;
 wire \count[0] ;
 wire \count[1] ;
 wire net2;
 wire net1;
 wire clknet_0_vco_clk;
 wire clknet_1_0__leaf_vco_clk;
 wire clknet_1_1__leaf_vco_clk;

 gf180mcu_fd_sc_mcu7t5v0__fillcap_32 FILLER_0_104 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_0_138 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_0_146 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_0_150 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_32 FILLER_0_2 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_32 FILLER_0_36 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_32 FILLER_0_70 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_10_101 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_32 FILLER_10_107 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_10_139 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_10_147 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_10_151 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_32 FILLER_10_2 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_10_34 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_64 FILLER_10_37 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_32 FILLER_11_104 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_11_138 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_11_146 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_11_150 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_32 FILLER_11_2 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_32 FILLER_11_36 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_32 FILLER_11_70 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_1_136 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_1_142 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_1_150 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_64 FILLER_1_2 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_1_66 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_64 FILLER_1_72 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_2_101 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_32 FILLER_2_107 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_2_139 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_2_147 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_2_151 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_32 FILLER_2_2 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_2_34 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_16 FILLER_2_37 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_2_53 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_2_57 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_2_93 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_3_136 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_3_142 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_3_150 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_64 FILLER_3_2 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_3_66 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_64 FILLER_3_72 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_4_101 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_4_107 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_4_109 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_16 FILLER_4_123 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_4_139 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_4_147 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_4_151 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_32 FILLER_4_2 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_4_34 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_4_37 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_4_45 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_4_49 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_5_136 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_5_142 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_64 FILLER_5_2 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_5_66 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_5_84 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_6_101 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_6_107 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_6_109 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_6_144 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_32 FILLER_6_2 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_6_34 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_16 FILLER_6_37 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_6_53 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_6_61 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_7_142 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_7_150 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_64 FILLER_7_2 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_7_66 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_7_76 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_7_84 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_7_88 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_8_101 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_8_107 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_8_111 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_8_113 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_16 FILLER_8_122 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_8_138 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_8_146 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_8_150 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_32 FILLER_8_2 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_8_34 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_64 FILLER_8_37 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_9_136 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_9_142 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_9_150 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_64 FILLER_9_2 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_9_66 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_64 FILLER_9_72 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_0_Left_12 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_0_Right_0 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_10_Left_22 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_10_Right_10 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_11_Left_23 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_11_Right_11 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_1_Left_13 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_1_Right_1 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_2_Left_14 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_2_Right_2 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_3_Left_15 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_3_Right_3 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_4_Left_16 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_4_Right_4 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_5_Left_17 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_5_Right_5 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_6_Left_18 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_6_Right_6 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_7_Left_19 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_7_Right_7 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_8_Left_20 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_8_Right_8 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_9_Left_21 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_9_Right_9 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_0_24 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_0_25 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_0_26 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_0_27 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_10_46 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_10_47 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_11_48 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_11_49 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_11_50 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_11_51 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_1_28 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_1_29 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_2_30 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_2_31 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_3_32 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_3_33 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_4_34 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_4_35 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_5_36 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_5_37 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_6_38 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_6_39 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_7_40 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_7_41 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_8_42 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_8_43 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_9_44 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_9_45 ();
 gf180mcu_fd_sc_mcu7t5v0__clkinv_1 _04_ (.I(\count[0] ),
    .ZN(_00_));
 gf180mcu_fd_sc_mcu7t5v0__nand2_1 _05_ (.A1(\count[0] ),
    .A2(\count[1] ),
    .ZN(_03_));
 gf180mcu_fd_sc_mcu7t5v0__xor2_1 _06_ (.A1(\count[0] ),
    .A2(\count[1] ),
    .Z(_01_));
 gf180mcu_fd_sc_mcu7t5v0__xnor2_1 _07_ (.A1(net2),
    .A2(_03_),
    .ZN(_02_));
 gf180mcu_fd_sc_mcu7t5v0__dffrnq_1 _08_ (.D(_00_),
    .RN(net1),
    .CLK(clknet_1_0__leaf_vco_clk),
    .Q(\count[0] ));
 gf180mcu_fd_sc_mcu7t5v0__dffrnq_1 _09_ (.D(_01_),
    .RN(net1),
    .CLK(clknet_1_0__leaf_vco_clk),
    .Q(\count[1] ));
 gf180mcu_fd_sc_mcu7t5v0__dffrnq_1 _10_ (.D(_02_),
    .RN(net1),
    .CLK(clknet_1_1__leaf_vco_clk),
    .Q(net2));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_16 clkbuf_0_vco_clk (.I(vco_clk),
    .Z(clknet_0_vco_clk));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_16 clkbuf_1_0__f_vco_clk (.I(clknet_0_vco_clk),
    .Z(clknet_1_0__leaf_vco_clk));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_16 clkbuf_1_1__f_vco_clk (.I(clknet_0_vco_clk),
    .Z(clknet_1_1__leaf_vco_clk));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 clkload0 (.I(clknet_1_1__leaf_vco_clk));
 gf180mcu_fd_sc_mcu7t5v0__buf_1 input1 (.I(rst_n),
    .Z(net1));
 gf180mcu_fd_sc_mcu7t5v0__buf_1 output2 (.I(net2),
    .Z(fb_clk));
endmodule
