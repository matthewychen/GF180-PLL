// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vlng.h for the primary calling header

#include "Vlng__pch.h"
#include "Vlng__Syms.h"
#include "Vlng___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vlng___024root___dump_triggers__ico(Vlng___024root* vlSelf);
#endif  // VL_DEBUG

void Vlng___024root___eval_triggers__ico(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___eval_triggers__ico\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VicoTriggered.set(0U, (IData)(vlSelfRef.__VicoFirstIteration));
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vlng___024root___dump_triggers__ico(vlSelf);
    }
#endif
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vlng___024root___dump_triggers__act(Vlng___024root* vlSelf);
#endif  // VL_DEBUG

void Vlng___024root___eval_triggers__act(Vlng___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlng___024root___eval_triggers__act\n"); );
    Vlng__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VactTriggered.set(0U, ((~ (IData)(vlSelfRef.phase_detector_deadband__02Erst_n)) 
                                       & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__phase_detector_deadband__02Erst_n__0)));
    vlSelfRef.__VactTriggered.set(1U, ((IData)(vlSelfRef.sample_clk) 
                                       & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__sample_clk__0))));
    vlSelfRef.__VactTriggered.set(2U, ((~ (IData)(vlSelfRef.pll_digital__02Eclk)) 
                                       & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__pll_digital__02Eclk__0)));
    vlSelfRef.__VactTriggered.set(3U, ((~ (IData)(vlSelfRef.pll_digital__02Erst_n)) 
                                       & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__pll_digital__02Erst_n__0)));
    vlSelfRef.__VactTriggered.set(4U, ((IData)(vlSelfRef.vco_clk) 
                                       & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__vco_clk__0))));
    vlSelfRef.__VactTriggered.set(5U, ((IData)(vlSelfRef.pll_digital__02Eclk) 
                                       & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__pll_digital__02Eclk__0))));
    vlSelfRef.__Vtrigprevexpr___TOP__phase_detector_deadband__02Erst_n__0 
        = vlSelfRef.phase_detector_deadband__02Erst_n;
    vlSelfRef.__Vtrigprevexpr___TOP__sample_clk__0 
        = vlSelfRef.sample_clk;
    vlSelfRef.__Vtrigprevexpr___TOP__pll_digital__02Eclk__0 
        = vlSelfRef.pll_digital__02Eclk;
    vlSelfRef.__Vtrigprevexpr___TOP__pll_digital__02Erst_n__0 
        = vlSelfRef.pll_digital__02Erst_n;
    vlSelfRef.__Vtrigprevexpr___TOP__vco_clk__0 = vlSelfRef.vco_clk;
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vlng___024root___dump_triggers__act(vlSelf);
    }
#endif
}
