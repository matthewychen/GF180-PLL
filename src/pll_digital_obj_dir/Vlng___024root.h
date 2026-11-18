// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vlng.h for the primary calling header

#ifndef VERILATED_VLNG___024ROOT_H_
#define VERILATED_VLNG___024ROOT_H_  // guard

#include "verilated.h"


class Vlng__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vlng___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(sample_clk,0,0);
    VL_IN8(phase_detector_deadband__02Erst_n,0,0);
    VL_IN8(pll_digital__02Eclk,0,0);
    VL_IN8(pll_digital__02Erst_n,0,0);
    VL_IN8(vco_clk,0,0);
    VL_IN8(phase_detector_deadband__02Eclk,0,0);
    VL_IN8(fb_clk,0,0);
    VL_OUT8(early,0,0);
    VL_OUT8(late,0,0);
    VL_IN8(kp_sel,1,0);
    VL_IN8(ki_sel,1,0);
    VL_OUT8(code,5,0);
    VL_OUT8(clk_out,0,0);
    VL_OUT8(lock,0,0);
    CData/*2:0*/ phase_detector_deadband__DOT__ref_s;
    CData/*2:0*/ phase_detector_deadband__DOT__fb_s;
    CData/*0:0*/ phase_detector_deadband__DOT__ref_first;
    CData/*0:0*/ phase_detector_deadband__DOT__fb_first;
    CData/*7:0*/ phase_detector_deadband__DOT__cnt;
    CData/*0:0*/ phase_detector_deadband__DOT__got_ref;
    CData/*0:0*/ phase_detector_deadband__DOT__got_fb;
    CData/*0:0*/ pll_digital__DOT__early_raw;
    CData/*0:0*/ pll_digital__DOT__nudge_up;
    CData/*0:0*/ pll_digital__DOT__nudge_dn;
    CData/*0:0*/ pll_digital__DOT__freq_ok;
    CData/*0:0*/ pll_digital__DOT__early_sync;
    CData/*2:0*/ pll_digital__DOT__u_fb_divider__DOT__count;
    CData/*4:0*/ pll_digital__DOT__u_freq_acq__DOT__win_cnt;
    CData/*0:0*/ pll_digital__DOT__u_freq_acq__DOT__win_tog;
    CData/*2:0*/ pll_digital__DOT__u_freq_acq__DOT__win_sync;
    CData/*0:0*/ pll_digital__DOT__u_freq_acq__DOT__snap_tog;
    CData/*0:0*/ pll_digital__DOT__u_freq_acq__DOT__win_edge;
    CData/*2:0*/ pll_digital__DOT__u_freq_acq__DOT__snap_sync;
    CData/*0:0*/ pll_digital__DOT__u_freq_acq__DOT__primed;
    CData/*6:0*/ pll_digital__DOT__u_freq_acq__DOT__since_snap;
    CData/*0:0*/ pll_digital__DOT__u_freq_acq__DOT__snap_edge;
    CData/*6:0*/ pll_digital__DOT__u_pi_filter__DOT__code_sum;
    CData/*5:0*/ pll_digital__DOT__u_pi_filter__DOT__code_next;
    CData/*0:0*/ pll_digital__DOT__u_lock_detector__DOT__last_bit;
    CData/*3:0*/ pll_digital__DOT__u_lock_detector__DOT__length_counter;
    CData/*0:0*/ __Vdly__pll_digital__DOT__u_freq_acq__DOT__snap_tog;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __VicoFirstIteration;
    CData/*0:0*/ __Vtrigprevexpr___TOP__phase_detector_deadband__02Erst_n__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__sample_clk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__pll_digital__02Eclk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__pll_digital__02Erst_n__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__vco_clk__0;
    CData/*0:0*/ __VactContinue;
    SData/*9:0*/ pll_digital__DOT__u_freq_acq__DOT__vco_cnt;
    SData/*9:0*/ pll_digital__DOT__u_freq_acq__DOT__cnt_snap;
    SData/*11:0*/ pll_digital__DOT__u_pi_filter__DOT__acc;
    SData/*11:0*/ pll_digital__DOT__u_pi_filter__DOT__acc_next;
    SData/*8:0*/ pll_digital__DOT__u_lock_detector__DOT__quiet_counter;
    SData/*9:0*/ __Vdly__pll_digital__DOT__u_freq_acq__DOT__vco_cnt;
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<6> __VactTriggered;
    VlTriggerVec<6> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vlng__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vlng___024root(Vlng__Syms* symsp, const char* v__name);
    ~Vlng___024root();
    VL_UNCOPYABLE(Vlng___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
