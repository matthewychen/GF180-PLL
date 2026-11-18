// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vlng.h for the primary calling header

#include "Vlng__pch.h"
#include "Vlng___024root.h"

void Vlng___024root___ico_sequent__TOP__0(Vlng___024root* vlSelf);

void Vlng___024root___eval_ico(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___eval_ico\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VicoTriggered.word(0U))) {
        Vlng___024root___ico_sequent__TOP__0(vlSelf);
    }
}

VL_INLINE_OPT void Vlng___024root___ico_sequent__TOP__0(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___ico_sequent__TOP__0\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    SData/*11:0*/ pll_digital__DOT__u_pi_filter__DOT__acc_pi;
    pll_digital__DOT__u_pi_filter__DOT__acc_pi = 0;
    // Body
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

void Vlng___024root___eval_triggers__ico(Vlng___024root* vlSelf);

bool Vlng___024root___eval_phase__ico(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___eval_phase__ico\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VicoExecute;
    // Body
    Vlng___024root___eval_triggers__ico(vlSelf);
    __VicoExecute = vlSelfRef.__VicoTriggered.any();
    if (__VicoExecute) {
        Vlng___024root___eval_ico(vlSelf);
    }
    return (__VicoExecute);
}

void Vlng___024root___eval_act(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___eval_act\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

void Vlng___024root___nba_sequent__TOP__0(Vlng___024root* vlSelf);
void Vlng___024root___nba_sequent__TOP__1(Vlng___024root* vlSelf);
void Vlng___024root___nba_sequent__TOP__2(Vlng___024root* vlSelf);
void Vlng___024root___nba_sequent__TOP__3(Vlng___024root* vlSelf);
void Vlng___024root___nba_sequent__TOP__4(Vlng___024root* vlSelf);
void Vlng___024root___nba_sequent__TOP__5(Vlng___024root* vlSelf);
void Vlng___024root___nba_sequent__TOP__6(Vlng___024root* vlSelf);

void Vlng___024root___eval_nba(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___eval_nba\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((3ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vlng___024root___nba_sequent__TOP__0(vlSelf);
    }
    if ((0x18ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vlng___024root___nba_sequent__TOP__1(vlSelf);
    }
    if ((0x28ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vlng___024root___nba_sequent__TOP__2(vlSelf);
    }
    if ((0x18ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vlng___024root___nba_sequent__TOP__3(vlSelf);
    }
    if ((0xcULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vlng___024root___nba_sequent__TOP__4(vlSelf);
    }
    if ((0x28ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vlng___024root___nba_sequent__TOP__5(vlSelf);
    }
    if ((0x2cULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vlng___024root___ico_sequent__TOP__0(vlSelf);
    }
    if ((0x18ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vlng___024root___nba_sequent__TOP__6(vlSelf);
    }
}

VL_INLINE_OPT void Vlng___024root___nba_sequent__TOP__0(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___nba_sequent__TOP__0\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*7:0*/ __Vdly__phase_detector_deadband__DOT__cnt;
    __Vdly__phase_detector_deadband__DOT__cnt = 0;
    // Body
    __Vdly__phase_detector_deadband__DOT__cnt = vlSelfRef.phase_detector_deadband__DOT__cnt;
    if (vlSelfRef.phase_detector_deadband__02Erst_n) {
        vlSelfRef.phase_detector_deadband__DOT__ref_s 
            = ((6U & ((IData)(vlSelfRef.phase_detector_deadband__DOT__ref_s) 
                      << 1U)) | (IData)(vlSelfRef.phase_detector_deadband__02Eclk));
        vlSelfRef.phase_detector_deadband__DOT__fb_s 
            = ((6U & ((IData)(vlSelfRef.phase_detector_deadband__DOT__fb_s) 
                      << 1U)) | (IData)(vlSelfRef.fb_clk));
        if (((IData)(vlSelfRef.phase_detector_deadband__DOT__got_ref) 
             & (IData)(vlSelfRef.phase_detector_deadband__DOT__got_fb))) {
            vlSelfRef.late = ((IData)(vlSelfRef.phase_detector_deadband__DOT__ref_first) 
                              & (2U < (IData)(vlSelfRef.phase_detector_deadband__DOT__cnt)));
            vlSelfRef.early = ((IData)(vlSelfRef.phase_detector_deadband__DOT__fb_first) 
                               & (2U < (IData)(vlSelfRef.phase_detector_deadband__DOT__cnt)));
            __Vdly__phase_detector_deadband__DOT__cnt = 0U;
        } else if ((((IData)(vlSelfRef.phase_detector_deadband__DOT__got_ref) 
                     | (IData)(vlSelfRef.phase_detector_deadband__DOT__got_fb)) 
                    & (~ (IData)((0xffU == (IData)(vlSelfRef.phase_detector_deadband__DOT__cnt)))))) {
            __Vdly__phase_detector_deadband__DOT__cnt 
                = (0xffU & ((IData)(1U) + (IData)(vlSelfRef.phase_detector_deadband__DOT__cnt)));
        }
    } else {
        vlSelfRef.phase_detector_deadband__DOT__ref_s = 0U;
        vlSelfRef.phase_detector_deadband__DOT__fb_s = 0U;
        __Vdly__phase_detector_deadband__DOT__cnt = 0U;
        vlSelfRef.early = 0U;
        vlSelfRef.late = 0U;
    }
    vlSelfRef.phase_detector_deadband__DOT__cnt = __Vdly__phase_detector_deadband__DOT__cnt;
    vlSelfRef.phase_detector_deadband__DOT__ref_first 
        = ((IData)(vlSelfRef.phase_detector_deadband__02Erst_n) 
           && ((1U & (~ ((IData)(vlSelfRef.phase_detector_deadband__DOT__got_ref) 
                         & (IData)(vlSelfRef.phase_detector_deadband__DOT__got_fb)))) 
               && (IData)(vlSelfRef.phase_detector_deadband__DOT__got_ref)));
    vlSelfRef.phase_detector_deadband__DOT__fb_first 
        = ((IData)(vlSelfRef.phase_detector_deadband__02Erst_n) 
           && ((1U & (~ ((IData)(vlSelfRef.phase_detector_deadband__DOT__got_ref) 
                         & (IData)(vlSelfRef.phase_detector_deadband__DOT__got_fb)))) 
               && (IData)(vlSelfRef.phase_detector_deadband__DOT__got_fb)));
    vlSelfRef.phase_detector_deadband__DOT__got_ref 
        = ((IData)(vlSelfRef.phase_detector_deadband__DOT__ref_first) 
           | (2U == (6U & (IData)(vlSelfRef.phase_detector_deadband__DOT__ref_s))));
    vlSelfRef.phase_detector_deadband__DOT__got_fb 
        = ((IData)(vlSelfRef.phase_detector_deadband__DOT__fb_first) 
           | (2U == (6U & (IData)(vlSelfRef.phase_detector_deadband__DOT__fb_s))));
}

VL_INLINE_OPT void Vlng___024root___nba_sequent__TOP__1(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___nba_sequent__TOP__1\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vdly__pll_digital__DOT__u_freq_acq__DOT__snap_tog 
        = vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__snap_tog;
    vlSelfRef.__Vdly__pll_digital__DOT__u_freq_acq__DOT__vco_cnt 
        = vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__vco_cnt;
    if (vlSelfRef.pll_digital__02Erst_n) {
        vlSelfRef.pll_digital__DOT__u_fb_divider__DOT__count 
            = (7U & ((IData)(1U) + (IData)(vlSelfRef.pll_digital__DOT__u_fb_divider__DOT__count)));
        if (vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__win_edge) {
            vlSelfRef.__Vdly__pll_digital__DOT__u_freq_acq__DOT__snap_tog 
                = (1U & (~ (IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__snap_tog)));
        }
        vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__win_sync 
            = ((6U & ((IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__win_sync) 
                      << 1U)) | (IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__win_tog));
    } else {
        vlSelfRef.pll_digital__DOT__u_fb_divider__DOT__count = 0U;
        vlSelfRef.__Vdly__pll_digital__DOT__u_freq_acq__DOT__snap_tog = 0U;
        vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__win_sync = 0U;
    }
}

VL_INLINE_OPT void Vlng___024root___nba_sequent__TOP__2(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___nba_sequent__TOP__2\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*4:0*/ __Vdly__pll_digital__DOT__u_freq_acq__DOT__win_cnt;
    __Vdly__pll_digital__DOT__u_freq_acq__DOT__win_cnt = 0;
    CData/*6:0*/ __Vdly__pll_digital__DOT__u_freq_acq__DOT__since_snap;
    __Vdly__pll_digital__DOT__u_freq_acq__DOT__since_snap = 0;
    SData/*8:0*/ __Vdly__pll_digital__DOT__u_lock_detector__DOT__quiet_counter;
    __Vdly__pll_digital__DOT__u_lock_detector__DOT__quiet_counter = 0;
    // Body
    __Vdly__pll_digital__DOT__u_freq_acq__DOT__win_cnt 
        = vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__win_cnt;
    __Vdly__pll_digital__DOT__u_freq_acq__DOT__since_snap 
        = vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__since_snap;
    __Vdly__pll_digital__DOT__u_lock_detector__DOT__quiet_counter 
        = vlSelfRef.pll_digital__DOT__u_lock_detector__DOT__quiet_counter;
    if (vlSelfRef.pll_digital__02Erst_n) {
        __Vdly__pll_digital__DOT__u_freq_acq__DOT__win_cnt 
            = (0x1fU & ((IData)(1U) + (IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__win_cnt)));
        if ((0x1fU == (IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__win_cnt))) {
            vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__win_tog 
                = (1U & (~ (IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__win_tog)));
        }
        vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__snap_sync 
            = ((6U & ((IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__snap_sync) 
                      << 1U)) | (IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__snap_tog));
        if (vlSelfRef.pll_digital__DOT__freq_ok) {
            if (((IData)(vlSelfRef.pll_digital__DOT__early_sync) 
                 == (IData)(vlSelfRef.pll_digital__DOT__u_lock_detector__DOT__last_bit))) {
                if ((8U == (IData)(vlSelfRef.pll_digital__DOT__u_lock_detector__DOT__length_counter))) {
                    __Vdly__pll_digital__DOT__u_lock_detector__DOT__quiet_counter = 0U;
                } else {
                    vlSelfRef.pll_digital__DOT__u_lock_detector__DOT__length_counter 
                        = (0xfU & ((IData)(1U) + (IData)(vlSelfRef.pll_digital__DOT__u_lock_detector__DOT__length_counter)));
                    if ((0x100U != (IData)(vlSelfRef.pll_digital__DOT__u_lock_detector__DOT__quiet_counter))) {
                        __Vdly__pll_digital__DOT__u_lock_detector__DOT__quiet_counter 
                            = (0x1ffU & ((IData)(1U) 
                                         + (IData)(vlSelfRef.pll_digital__DOT__u_lock_detector__DOT__quiet_counter)));
                    }
                }
            } else {
                vlSelfRef.pll_digital__DOT__u_lock_detector__DOT__length_counter = 1U;
                if ((0x100U != (IData)(vlSelfRef.pll_digital__DOT__u_lock_detector__DOT__quiet_counter))) {
                    __Vdly__pll_digital__DOT__u_lock_detector__DOT__quiet_counter 
                        = (0x1ffU & ((IData)(1U) + (IData)(vlSelfRef.pll_digital__DOT__u_lock_detector__DOT__quiet_counter)));
                }
            }
        } else {
            vlSelfRef.pll_digital__DOT__u_lock_detector__DOT__length_counter = 1U;
            __Vdly__pll_digital__DOT__u_lock_detector__DOT__quiet_counter = 0U;
        }
        vlSelfRef.code = vlSelfRef.pll_digital__DOT__u_pi_filter__DOT__code_next;
        vlSelfRef.pll_digital__DOT__u_pi_filter__DOT__acc 
            = vlSelfRef.pll_digital__DOT__u_pi_filter__DOT__acc_next;
        vlSelfRef.pll_digital__DOT__nudge_up = 0U;
        vlSelfRef.pll_digital__DOT__nudge_dn = 0U;
        if (vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__snap_edge) {
            __Vdly__pll_digital__DOT__u_freq_acq__DOT__since_snap = 0U;
            if (vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__primed) {
                vlSelfRef.pll_digital__DOT__nudge_up 
                    = VL_GTS_III(12, 0xff6U, (0xfffU 
                                              & ((IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__cnt_snap) 
                                                 - (IData)(0x100U))));
                vlSelfRef.pll_digital__DOT__nudge_dn 
                    = VL_LTS_III(12, 0xaU, (0xfffU 
                                            & ((IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__cnt_snap) 
                                               - (IData)(0x100U))));
                vlSelfRef.pll_digital__DOT__freq_ok 
                    = (VL_LTES_III(12, 0xffaU, (0xfffU 
                                                & ((IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__cnt_snap) 
                                                   - (IData)(0x100U)))) 
                       & VL_GTES_III(12, 6U, (0xfffU 
                                              & ((IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__cnt_snap) 
                                                 - (IData)(0x100U)))));
            } else {
                vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__primed = 1U;
            }
        } else if ((0x7fU != (IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__since_snap))) {
            __Vdly__pll_digital__DOT__u_freq_acq__DOT__since_snap 
                = (0x7fU & ((IData)(1U) + (IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__since_snap)));
        } else {
            vlSelfRef.pll_digital__DOT__freq_ok = 0U;
        }
    } else {
        __Vdly__pll_digital__DOT__u_freq_acq__DOT__win_cnt = 0U;
        vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__win_tog = 0U;
        vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__snap_sync = 0U;
        vlSelfRef.pll_digital__DOT__u_lock_detector__DOT__length_counter = 0U;
        __Vdly__pll_digital__DOT__u_lock_detector__DOT__quiet_counter = 0U;
        vlSelfRef.code = 0x20U;
        vlSelfRef.pll_digital__DOT__u_pi_filter__DOT__acc = 0x800U;
        vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__primed = 0U;
        vlSelfRef.pll_digital__DOT__nudge_up = 0U;
        vlSelfRef.pll_digital__DOT__nudge_dn = 0U;
        vlSelfRef.pll_digital__DOT__freq_ok = 0U;
        __Vdly__pll_digital__DOT__u_freq_acq__DOT__since_snap = 0U;
    }
    vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__win_cnt 
        = __Vdly__pll_digital__DOT__u_freq_acq__DOT__win_cnt;
    vlSelfRef.pll_digital__DOT__u_lock_detector__DOT__quiet_counter 
        = __Vdly__pll_digital__DOT__u_lock_detector__DOT__quiet_counter;
    vlSelfRef.lock = (0x100U == (IData)(vlSelfRef.pll_digital__DOT__u_lock_detector__DOT__quiet_counter));
    vlSelfRef.pll_digital__DOT__u_lock_detector__DOT__last_bit 
        = ((IData)(vlSelfRef.pll_digital__02Erst_n) 
           && (IData)(vlSelfRef.pll_digital__DOT__early_sync));
    vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__snap_edge 
        = (1U & VL_REDXOR_4((6U & (IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__snap_sync))));
    vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__since_snap 
        = __Vdly__pll_digital__DOT__u_freq_acq__DOT__since_snap;
}

VL_INLINE_OPT void Vlng___024root___nba_sequent__TOP__3(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___nba_sequent__TOP__3\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__snap_tog 
        = vlSelfRef.__Vdly__pll_digital__DOT__u_freq_acq__DOT__snap_tog;
    if (vlSelfRef.pll_digital__02Erst_n) {
        if (vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__win_edge) {
            vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__cnt_snap 
                = vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__vco_cnt;
            vlSelfRef.__Vdly__pll_digital__DOT__u_freq_acq__DOT__vco_cnt = 1U;
        } else if ((0x3ffU != (IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__vco_cnt))) {
            vlSelfRef.__Vdly__pll_digital__DOT__u_freq_acq__DOT__vco_cnt 
                = (0x3ffU & ((IData)(1U) + (IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__vco_cnt)));
        }
    } else {
        vlSelfRef.__Vdly__pll_digital__DOT__u_freq_acq__DOT__vco_cnt = 0U;
        vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__cnt_snap = 0U;
    }
    vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__win_edge 
        = (1U & VL_REDXOR_4((6U & (IData)(vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__win_sync))));
    vlSelfRef.pll_digital__DOT__u_freq_acq__DOT__vco_cnt 
        = vlSelfRef.__Vdly__pll_digital__DOT__u_freq_acq__DOT__vco_cnt;
}

VL_INLINE_OPT void Vlng___024root___nba_sequent__TOP__4(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___nba_sequent__TOP__4\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.pll_digital__DOT__early_sync = ((IData)(vlSelfRef.pll_digital__02Erst_n) 
                                              & (IData)(vlSelfRef.pll_digital__DOT__early_raw));
}

VL_INLINE_OPT void Vlng___024root___nba_sequent__TOP__5(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___nba_sequent__TOP__5\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.pll_digital__DOT__early_raw = ((IData)(vlSelfRef.pll_digital__02Erst_n) 
                                             & (IData)(vlSelfRef.clk_out));
}

VL_INLINE_OPT void Vlng___024root___nba_sequent__TOP__6(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___nba_sequent__TOP__6\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.clk_out = (1U & ((IData)(vlSelfRef.pll_digital__DOT__u_fb_divider__DOT__count) 
                               >> 2U));
}

void Vlng___024root___eval_triggers__act(Vlng___024root* vlSelf);

bool Vlng___024root___eval_phase__act(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___eval_phase__act\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    VlTriggerVec<6> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vlng___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelfRef.__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelfRef.__VactTriggered, vlSelfRef.__VnbaTriggered);
        vlSelfRef.__VnbaTriggered.thisOr(vlSelfRef.__VactTriggered);
        Vlng___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vlng___024root___eval_phase__nba(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___eval_phase__nba\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelfRef.__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vlng___024root___eval_nba(vlSelf);
        vlSelfRef.__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vlng___024root___dump_triggers__ico(Vlng___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vlng___024root___dump_triggers__nba(Vlng___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vlng___024root___dump_triggers__act(Vlng___024root* vlSelf);
#endif  // VL_DEBUG

void Vlng___024root___eval(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___eval\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VicoIterCount;
    CData/*0:0*/ __VicoContinue;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VicoIterCount = 0U;
    vlSelfRef.__VicoFirstIteration = 1U;
    __VicoContinue = 1U;
    while (__VicoContinue) {
        if (VL_UNLIKELY(((0x64U < __VicoIterCount)))) {
#ifdef VL_DEBUG
            Vlng___024root___dump_triggers__ico(vlSelf);
#endif
            VL_FATAL_MT("phase_detector.v", 3, "", "Input combinational region did not converge.");
        }
        __VicoIterCount = ((IData)(1U) + __VicoIterCount);
        __VicoContinue = 0U;
        if (Vlng___024root___eval_phase__ico(vlSelf)) {
            __VicoContinue = 1U;
        }
        vlSelfRef.__VicoFirstIteration = 0U;
    }
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY(((0x64U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vlng___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("phase_detector.v", 3, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelfRef.__VactIterCount = 0U;
        vlSelfRef.__VactContinue = 1U;
        while (vlSelfRef.__VactContinue) {
            if (VL_UNLIKELY(((0x64U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                Vlng___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("phase_detector.v", 3, "", "Active region did not converge.");
            }
            vlSelfRef.__VactIterCount = ((IData)(1U) 
                                         + vlSelfRef.__VactIterCount);
            vlSelfRef.__VactContinue = 0U;
            if (Vlng___024root___eval_phase__act(vlSelf)) {
                vlSelfRef.__VactContinue = 1U;
            }
        }
        if (Vlng___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vlng___024root___eval_debug_assertions(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___eval_debug_assertions\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (VL_UNLIKELY(((vlSelfRef.sample_clk & 0xfeU)))) {
        Verilated::overWidthError("sample_clk");}
    if (VL_UNLIKELY(((vlSelfRef.phase_detector_deadband__02Eclk 
                      & 0xfeU)))) {
        Verilated::overWidthError("phase_detector_deadband.clk");}
    if (VL_UNLIKELY(((vlSelfRef.fb_clk & 0xfeU)))) {
        Verilated::overWidthError("fb_clk");}
    if (VL_UNLIKELY(((vlSelfRef.phase_detector_deadband__02Erst_n 
                      & 0xfeU)))) {
        Verilated::overWidthError("phase_detector_deadband.rst_n");}
    if (VL_UNLIKELY(((vlSelfRef.pll_digital__02Eclk 
                      & 0xfeU)))) {
        Verilated::overWidthError("pll_digital.clk");}
    if (VL_UNLIKELY(((vlSelfRef.pll_digital__02Erst_n 
                      & 0xfeU)))) {
        Verilated::overWidthError("pll_digital.rst_n");}
    if (VL_UNLIKELY(((vlSelfRef.kp_sel & 0xfcU)))) {
        Verilated::overWidthError("kp_sel");}
    if (VL_UNLIKELY(((vlSelfRef.ki_sel & 0xfcU)))) {
        Verilated::overWidthError("ki_sel");}
    if (VL_UNLIKELY(((vlSelfRef.vco_clk & 0xfeU)))) {
        Verilated::overWidthError("vco_clk");}
}
#endif  // VL_DEBUG
