v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 120 -210 210 -210 {
lab=#net1}
N 210 -210 210 -200 {
lab=#net1}
N -220 -280 -220 -230 {
lab=in}
N -180 -280 130 -280 {
lab=in}
N 130 -280 130 -230 {
lab=in}
N 120 -230 130 -230 {
lab=in}
N 120 -190 130 -190 {
lab=GND}
N 130 -190 130 -160 {
lab=GND}
N -220 -230 -180 -230 {
lab=in}
N -220 -280 -180 -280 {
lab=in}
C {pll_dac/sw_inv.sym} -30 -210 0 0 {name=x1}
C {vsource.sym} -220 -200 0 0 {name=Vdd value=3.3
}
C {gnd.sym} -220 -170 0 0 {name=l4 lab=GND}
C {lab_pin.sym} -220 -230 0 0 {name=p1 sig_type=std_logic lab=in
}
C {vsource.sym} 210 -170 0 0 {name=Vfn value=0.01}
C {gnd.sym} 130 -160 0 0 {name=l1 lab=GND}
C {devices/code_shown.sym} -220 -50 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/code_shown.sym} -280 -480 0 0 {name=NGSPICE only_toplevel=true
value="
.control
op
let ron_n = 0.01/abs(i(Vfn))
print ron_n
.endc
"}
C {gnd.sym} 210 -140 0 0 {name=l2 lab=GND}
