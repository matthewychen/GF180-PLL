// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vlng.h for the primary calling header

#include "Vlng__pch.h"
#include "Vlng___024root.h"

VL_ATTR_COLD void Vlng___024root___eval_static(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___eval_static\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vlng___024root___eval_initial(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___eval_initial\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vtrigprevexpr___TOP__phase_detector_deadband__02Erst_n__0 
        = vlSelfRef.phase_detector_deadband__02Erst_n;
    vlSelfRef.__Vtrigprevexpr___TOP__sample_clk__0 
        = vlSelfRef.sample_clk;
    vlSelfRef.__Vtrigprevexpr___TOP__pll_digital__02Eclk__0 
        = vlSelfRef.pll_digital__02Eclk;
    vlSelfRef.__Vtrigprevexpr___TOP__pll_digital__02Erst_n__0 
        = vlSelfRef.pll_digital__02Erst_n;
    vlSelfRef.__Vtrigprevexpr___TOP__vco_clk__0 = vlSelfRef.vco_clk;
}

VL_ATTR_COLD void Vlng___024root___eval_final(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___eval_final\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vlng___024root___dump_triggers__stl(Vlng___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vlng___024root___eval_phase__stl(Vlng___024root* vlSelf);

VL_ATTR_COLD void Vlng___024root___eval_settle(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___eval_settle\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VstlIterCount;
    CData/*0:0*/ __VstlContinue;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        if (VL_UNLIKELY(((0x64U < __VstlIterCount)))) {
#ifdef VL_DEBUG
            Vlng___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("phase_detector.v", 3, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vlng___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelfRef.__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vlng___024root___dump_triggers__stl(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___dump_triggers__stl\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VstlTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vlng___024root___stl_sequent__TOP__0(Vlng___024root* vlSelf);

VL_ATTR_COLD void Vlng___024root___eval_stl(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___eval_stl\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        Vlng___024root___stl_sequent__TOP__0(vlSelf);
    }
}

VL_ATTR_COLD void Vlng___024root___stl_sequent__TOP__0(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___stl_sequent__TOP__0\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    SData/*11:0*/ pll_digital__DOT__u_pi_filter__DOT__acc_pi;
    pll_digital__DOT__u_pi_filter__DOT__acc_pi = 0;
    // Body
    vlSelfRef.clk_out = (1U & ((IData)(vlSelfRef.pll_digital__DOT__u_fb_divider__DOT__count) 
                               >> 2U));
    vlSelfRef.lock = (0x100U == (IData)(vlSelfRef.pll_digital__DOT__u_lock_detector__DOT__quiet_counter));
    vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__win_edge 
        = (1U & VL_REDXOR_4((6U & (IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__win_sync))));
    vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__snap_edge 
        = (1U & VL_REDXOR_4((6U & (IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__snap_sync))));
    vlSelfRef.phase_detector_deadband__DOT__got_ref 
        = ((IData)(vlSelfRef.phase_detector_deadband__DOT__ref_first) 
           | (2U == (6U & (IData)(vlSelfRef.phase_detector_deadband__DOT__ref_s))));
    vlSelfRef.phase_detector_deadband__DOT__got_fb 
        = ((IData)(vlSelfRef.phase_detector_deadband__DOT__fb_first) 
           | (2U == (6U & (IData)(vlSelfRef.phase_detector_deadband__DOT__fb_s))));
    pll_digital__DOT__u_pi_filter__DOT__acc_pi = (0xfffU 
                                                  & ((IData)(vlSelfRef.pll_digital__DOT__early_sync)
                                                      ? 
                                                     (((IData)(vlSelfRef.pll_digital__DOT__u_pi_filter__DOT__acc) 
                                                       >= 
                                                       (0xfffU 
                                                        & ((IData)(1U) 
                                                           << (IData)(vlSelfRef.ki_sel))))
                                                       ? 
                                                      ((IData)(vlSelfRef.pll_digital__DOT__u_pi_filter__DOT__acc) 
                                                       - 
                                                       ((IData)(1U) 
                                                        << (IData)(vlSelfRef.ki_sel)))
                                                       : 0U)
                                                      : 
                                                     (((IData)(vlSelfRef.pll_digital__DOT__u_pi_filter__DOT__acc) 
                                                       <= 
                                                       (0xfffU 
                                                        & ((IData)(0xfffU) 
                                                           - 
                                                           ((IData)(1U) 
                                                            << (IData)(vlSelfRef.ki_sel)))))
                                                       ? 
                                                      ((IData)(vlSelfRef.pll_digital__DOT__u_pi_filter__DOT__acc) 
                                                       + 
                                                       ((IData)(1U) 
                                                        << (IData)(vlSelfRef.ki_sel)))
                                                       : 0xfffU)));
    vlSelfRef.pll_digital__DOT__u_pi_filter__DOT__acc_next 
        = (0xfffU & (((~ (IData)(vlSelfRef.pll_digital__DOT__nudge_dn)) 
                      & (IData)(vlSelfRef.pll_digital__DOT__nudge_up))
                      ? ((0xfbfU >= (IData)(pll_digital__DOT__u_pi_filter__DOT__acc_pi))
                          ? ((IData)(0x40U) + (IData)(pll_digital__DOT__u_pi_filter__DOT__acc_pi))
                          : 0xfffU) : (((~ (IData)(vlSelfRef.pll_digital__DOT__nudge_up)) 
                                        & (IData)(vlSelfRef.pll_digital__DOT__nudge_dn))
                                        ? ((0x40U <= (IData)(pll_digital__DOT__u_pi_filter__DOT__acc_pi))
                                            ? ((IData)(pll_digital__DOT__u_pi_filter__DOT__acc_pi) 
                                               - (IData)(0x40U))
                                            : 0U) : (IData)(pll_digital__DOT__u_pi_filter__DOT__acc_pi))));
    if (vlSelfRef.pll_digital__DOT__early_sync) {
        vlSelfRef.pll_digital__DOT__u_pi_filter__DOT__code_sum 
            = (0x7fU & ((0x3fU & ((IData)(vlSelfRef.pll_digital__DOT__u_pi_filter__DOT__acc_next) 
                                  >> 6U)) - (0x3fU 
                                             & ((IData)(1U) 
                                                << (IData)(vlSelfRef.kp_sel)))));
        vlSelfRef.pll_digital__DOT__u_pi_filter__DOT__code_next 
            = ((0x40U & (IData)(vlSelfRef.pll_digital__DOT__u_pi_filter__DOT__code_sum))
                ? 0U : (0x3fU & (IData)(vlSelfRef.pll_digital__DOT__u_pi_filter__DOT__code_sum)));
    } else {
        vlSelfRef.pll_digital__DOT__u_pi_filter__DOT__code_sum 
            = (0x7fU & ((0x3fU & ((IData)(vlSelfRef.pll_digital__DOT__u_pi_filter__DOT__acc_next) 
                                  >> 6U)) + (0x3fU 
                                             & ((IData)(1U) 
                                                << (IData)(vlSelfRef.kp_sel)))));
        vlSelfRef.pll_digital__DOT__u_pi_filter__DOT__code_next 
            = ((0x40U & (IData)(vlSelfRef.pll_digital__DOT__u_pi_filter__DOT__code_sum))
                ? 0x3fU : (0x3fU & (IData)(vlSelfRef.pll_digital__DOT__u_pi_filter__DOT__code_sum)));
    }
}

VL_ATTR_COLD void Vlng___024root___eval_triggers__stl(Vlng___024root* vlSelf);

VL_ATTR_COLD bool Vlng___024root___eval_phase__stl(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___eval_phase__stl\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vlng___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelfRef.__VstlTriggered.any();
    if (__VstlExecute) {
        Vlng___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vlng___024root___dump_triggers__ico(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___dump_triggers__ico\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VicoTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VicoTriggered.word(0U))) {
        VL_DBG_MSGF("         'ico' region trigger index 0 is active: Internal 'ico' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vlng___024root___dump_triggers__act(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___dump_triggers__act\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(negedge phase_detector_deadband.rst_n)\n");
    }
    if ((2ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @(posedge sample_clk)\n");
    }
    if ((4ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 2 is active: @(negedge pll_digital.clk)\n");
    }
    if ((8ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 3 is active: @(negedge pll_digital.rst_n)\n");
    }
    if ((0x10ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 4 is active: @(posedge vco_clk)\n");
    }
    if ((0x20ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 5 is active: @(posedge pll_digital.clk)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vlng___024root___dump_triggers__nba(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___dump_triggers__nba\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(negedge phase_detector_deadband.rst_n)\n");
    }
    if ((2ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @(posedge sample_clk)\n");
    }
    if ((4ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 2 is active: @(negedge pll_digital.clk)\n");
    }
    if ((8ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 3 is active: @(negedge pll_digital.rst_n)\n");
    }
    if ((0x10ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 4 is active: @(posedge vco_clk)\n");
    }
    if ((0x20ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 5 is active: @(posedge pll_digital.clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vlng___024root___ctor_var_reset(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___ctor_var_reset\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelf->sample_clk = VL_RAND_RESET_I(1);
    vlSelf->phase_detector_deadband__02Eclk = VL_RAND_RESET_I(1);
    vlSelf->fb_clk = VL_RAND_RESET_I(1);
    vlSelf->phase_detector_deadband__02Erst_n = VL_RAND_RESET_I(1);
    vlSelf->early = VL_RAND_RESET_I(1);
    vlSelf->late = VL_RAND_RESET_I(1);
    vlSelf->pll_digital__02Eclk = VL_RAND_RESET_I(1);
    vlSelf->pll_digital__02Erst_n = VL_RAND_RESET_I(1);
    vlSelf->kp_sel = VL_RAND_RESET_I(2);
    vlSelf->ki_sel = VL_RAND_RESET_I(2);
    vlSelf->vco_clk = VL_RAND_RESET_I(1);
    vlSelf->code = VL_RAND_RESET_I(6);
    vlSelf->clk_out = VL_RAND_RESET_I(1);
    vlSelf->lock = VL_RAND_RESET_I(1);
    vlSelf->phase_detector_deadband__DOT__ref_s = VL_RAND_RESET_I(3);
    vlSelf->phase_detector_deadband__DOT__fb_s = VL_RAND_RESET_I(3);
    vlSelf->phase_detector_deadband__DOT__ref_first = VL_RAND_RESET_I(1);
    vlSelf->phase_detector_deadband__DOT__fb_first = VL_RAND_RESET_I(1);
    vlSelf->phase_detector_deadband__DOT__cnt = VL_RAND_RESET_I(8);
    vlSelf->phase_detector_deadband__DOT__got_ref = VL_RAND_RESET_I(1);
    vlSelf->phase_detector_deadband__DOT__got_fb = VL_RAND_RESET_I(1);
    vlSelf->pll_digital__DOT__early_raw = VL_RAND_RESET_I(1);
    vlSelf->pll_digital__DOT__nudge_up = VL_RAND_RESET_I(1);
    vlSelf->pll_digital__DOT__nudge_dn = VL_RAND_RESET_I(1);
    vlSelf->pll_digital__DOT__freq_ok = VL_RAND_RESET_I(1);
    vlSelf->pll_digital__DOT__early_sync = VL_RAND_RESET_I(1);
    vlSelf->pll_digital__DOT__u_fb_divider__DOT__count = VL_RAND_RESET_I(3);
    vlSelf->pll_digital__DOT__u_freq_acq__DOT__win_cnt = VL_RAND_RESET_I(5);
    vlSelf->pll_digital__DOT__u_freq_acq__DOT__win_tog = VL_RAND_RESET_I(1);
    vlSelf->pll_digital__DOT__u_freq_acq__DOT__win_sync = VL_RAND_RESET_I(3);
    vlSelf->pll_digital__DOT__u_freq_acq__DOT__vco_cnt = VL_RAND_RESET_I(10);
    vlSelf->pll_digital__DOT__u_freq_acq__DOT__cnt_snap = VL_RAND_RESET_I(10);
    vlSelf->pll_digital__DOT__u_freq_acq__DOT__snap_tog = VL_RAND_RESET_I(1);
    vlSelf->pll_digital__DOT__u_freq_acq__DOT__win_edge = VL_RAND_RESET_I(1);
    vlSelf->pll_digital__DOT__u_freq_acq__DOT__snap_sync = VL_RAND_RESET_I(3);
    vlSelf->pll_digital__DOT__u_freq_acq__DOT__primed = VL_RAND_RESET_I(1);
    vlSelf->pll_digital__DOT__u_freq_acq__DOT__since_snap = VL_RAND_RESET_I(7);
    vlSelf->pll_digital__DOT__u_freq_acq__DOT__snap_edge = VL_RAND_RESET_I(1);
    vlSelf->pll_digital__DOT__u_pi_filter__DOT__acc = VL_RAND_RESET_I(12);
    vlSelf->pll_digital__DOT__u_pi_filter__DOT__acc_next = VL_RAND_RESET_I(12);
    vlSelf->pll_digital__DOT__u_pi_filter__DOT__code_sum = VL_RAND_RESET_I(7);
    vlSelf->pll_digital__DOT__u_pi_filter__DOT__code_next = VL_RAND_RESET_I(6);
    vlSelf->pll_digital__DOT__u_lock_detector__DOT__last_bit = VL_RAND_RESET_I(1);
    vlSelf->pll_digital__DOT__u_lock_detector__DOT__length_counter = VL_RAND_RESET_I(4);
    vlSelf->pll_digital__DOT__u_lock_detector__DOT__quiet_counter = VL_RAND_RESET_I(9);
    vlSelf->__Vdly__pll_digital__DOT__u_freq_acq__DOT__vco_cnt = VL_RAND_RESET_I(10);
    vlSelf->__Vdly__pll_digital__DOT__u_freq_acq__DOT__snap_tog = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__phase_detector_deadband__02Erst_n__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__sample_clk__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__pll_digital__02Eclk__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__pll_digital__02Erst_n__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__vco_clk__0 = VL_RAND_RESET_I(1);
}
