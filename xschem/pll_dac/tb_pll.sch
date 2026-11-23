v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 830 -90 830 -50 {
lab=GND}
N 270 -110 270 -50 {
lab=GND}
N 270 -110 400 -110 {
lab=GND}
N 700 -90 830 -90 {
lab=GND}
N 700 -110 920 -110 {
lab=VDD}
N 920 -110 920 -100 {
lab=VDD}
N 700 -70 740 -70 {
lab=vctrl}
N 740 -70 740 -50 {
lab=vctrl}
N 750 310 750 340 {
lab=GND}
N 700 -130 800 -130 {
lab=vpad}
N 860 -130 990 -130 {
lab=GND}
N 990 -130 990 -100 {
lab=GND}
N 920 -40 920 -10 {
lab=GND}
C {pll_dac/dac6.sym} 550 -100 0 0 {name=x1}
C {lab_pin.sym} 400 -130 0 0 {name=p1 lab=b5,b4,b3,b2,b1,b0}
C {lab_pin.sym} 700 -130 0 1 {name=p3 lab=vpad}
C {lab_pin.sym} 700 -110 0 1 {name=p4 lab=VDD}
C {lab_pin.sym} 700 -70 0 1 {name=p6 lab=vctrl}
C {gnd.sym} 830 -50 0 0 {name=l1 lab=GND}
C {gnd.sym} 270 -50 0 0 {name=l2 lab=GND}
C {vsource.sym} 920 -70 0 0 {name=V1 value=3.3 savecurrent=false}
C {gnd.sym} 750 340 0 0 {name=l3 lab=GND}
C {res.sym} 830 -130 3 0 {name=R1
value=10Meg
footprint=1206
device=resistor
m=1}
C {gnd.sym} 990 -100 0 0 {name=l4 lab=GND}
C {gnd.sym} 920 -10 0 0 {name=l5 lab=GND}
C {devices/code_shown.sym} 1090 -130 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
"}
C {devices/code_shown.sym} 1110 -10 0 0 {name=NGSPICE only_toplevel=true
value="
.control
save v(vctrl) v(lock) v(clk_out) v(ref_clk) v(vco_out) v(b5) v(b4) v(b3) v(b2) v(b1) v(b0)
tran 0.1n 5u
let code = (32*v(b5) + 16*v(b4) + 8*v(b3) + 4*v(b2) + 2*v(b1) + v(b0)) / 3.3
plot code
plot v(vctrl)
plot v(ref_clk) v(clk_out)
.endc
"}
C {code_shown.sym} 1120 200 0 0 {name=DIGITAL only_toplevel=true value="
.include /home/h58ding/pll_sim/digital.spice
"}
C {vsource.sym} -90 -60 0 0 {name=Vrst value=PWL(0 0 300n 0 301n 3.3) savecurrent=false}
C {lab_pin.sym} -90 -90 0 1 {name=rst_n lab=rst_n}
C {vsource.sym} -260 -50 0 0 {name=Vref1 value=PULSE(0 3.3 0 1n 1n 49n 100n) savecurrent=false}
C {lab_pin.sym} -260 -80 0 1 {name=ref_clk1 lab=ref_clk}
C {vsource.sym} -80 100 0 0 {name=Vkp0 value=0 savecurrent=false}
C {lab_pin.sym} -80 70 0 1 {name=kp0 lab=kp0}
C {vsource.sym} -270 110 0 0 {name=Vkp1 value=0 savecurrent=false}
C {lab_pin.sym} -270 80 0 1 {name=kp1 lab=kp1}
C {vsource.sym} -80 250 0 0 {name=Vki0 value=0 savecurrent=false}
C {lab_pin.sym} -80 220 0 1 {name=ki0 lab=ki0}
C {vsource.sym} -270 270 0 0 {name=Vki1 value=0 savecurrent=false}
C {lab_pin.sym} -270 240 0 1 {name=ki1 lab=ki1
}
C {gnd.sym} -260 -20 0 0 {name=l6 lab=GND}
C {gnd.sym} -90 -30 0 0 {name=l7 lab=GND}
C {gnd.sym} -80 130 0 0 {name=l8 lab=GND}
C {gnd.sym} -270 140 0 0 {name=l9 lab=GND}
C {gnd.sym} -270 300 0 0 {name=l10 lab=GND}
C {gnd.sym} -80 280 0 0 {name=l11 lab=GND}
