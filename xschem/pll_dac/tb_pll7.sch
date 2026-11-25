v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 320 -160 320 -120 {
lab=GND}
N -240 -180 -240 -120 {
lab=GND}
N -240 -180 -110 -180 {
lab=GND}
N 190 -160 320 -160 {
lab=GND}
N 190 -180 410 -180 {
lab=VDD}
N 410 -180 410 -170 {
lab=VDD}
N 260 100 260 130 {
lab=GND}
N 190 -200 290 -200 {
lab=vpad}
N 350 -200 480 -200 {
lab=GND}
N 480 -200 480 -170 {
lab=GND}
N 410 -110 410 -80 {
lab=GND}
N 170 30 260 30 {
lab=vco_out}
N 260 30 260 40 {
lab=vco_out}
C {lab_pin.sym} -110 -200 0 0 {name=p1 lab=b6,b5,b4,b3,b2,b1,b0}
C {lab_pin.sym} 190 -200 0 1 {name=p3 lab=vpad}
C {lab_pin.sym} 190 -180 0 1 {name=p4 lab=VDD}
C {lab_pin.sym} 190 -140 0 1 {name=p6 lab=vctrl}
C {gnd.sym} 320 -120 0 0 {name=l1 lab=GND}
C {gnd.sym} -240 -120 0 0 {name=l2 lab=GND}
C {vsource.sym} 410 -140 0 0 {name=V1 value=3.3 savecurrent=false}
C {gnd.sym} 260 130 0 0 {name=l3 lab=GND}
C {res.sym} 320 -200 3 0 {name=R1
value=10Meg
footprint=1206
device=resistor
m=1}
C {gnd.sym} 480 -170 0 0 {name=l4 lab=GND}
C {gnd.sym} 410 -80 0 0 {name=l5 lab=GND}
C {devices/code_shown.sym} 590 -250 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
"}
C {devices/code_shown.sym} 600 -80 0 0 {name=NGSPICE only_toplevel=true value="
.ic v(x2.n0)=0 v(x2.n1)=3.3 v(x2.n2)=0 v(x2.n3)=3.3 v(x2.n4)=0
.control
save v(vco_out) v(vctrl)
tran 0.1n 40u 10u
plot v(vctrl)
linearize v(vco_out)
set specwindow=hanning
fft v(vco_out)
let mag = db(mag(v(vco_out)))
meas sp f_peak max_at mag from=60e6 to=100e6
meas sp peak max mag from=60e6 to=100e6
meas sp spur_low max mag from=75e6 to=79e6
meas sp spur_high max mag from=81e6 to=85e6
let dbc_low = spur_low - peak
let dbc_high = spur_high - peak
print dbc_low dbc_high
plot mag xlimit 70e6 90e6 title VCO_spectrum
.endc
"}
C {code_shown.sym} 600 330 0 0 {name=DIGITAL only_toplevel=true value="
.include /home/h58ding/pll_sim7/digital.spice
"}
C {vsource.sym} -600 -130 0 0 {name=Vrst value="PWL(0 0 300n 0 301n 3.3)"}
C {lab_pin.sym} -600 -160 0 1 {name=rst_n lab=rst_n}
C {vsource.sym} -770 -120 0 0 {name=Vref value="PULSE(0 3.3 0 1n 1n 49n 100n)"}
C {lab_pin.sym} -770 -150 0 1 {name=ref_clk1 lab=ref_clk}
C {vsource.sym} -590 30 0 0 {name=Vkp0 value=0 savecurrent=false}
C {lab_pin.sym} -590 0 0 1 {name=kp0 lab=kp0}
C {vsource.sym} -780 40 0 0 {name=Vkp1 value=0 savecurrent=false}
C {lab_pin.sym} -780 10 0 1 {name=kp1 lab=kp1}
C {vsource.sym} -590 180 0 0 {name=Vki0 value=0 savecurrent=false}
C {lab_pin.sym} -590 150 0 1 {name=ki0 lab=ki0}
C {vsource.sym} -780 200 0 0 {name=Vki1 value=0 savecurrent=false}
C {lab_pin.sym} -780 170 0 1 {name=ki1 lab=ki1
}
C {gnd.sym} -770 -90 0 0 {name=l6 lab=GND}
C {gnd.sym} -600 -100 0 0 {name=l7 lab=GND}
C {gnd.sym} -590 60 0 0 {name=l8 lab=GND}
C {gnd.sym} -780 70 0 0 {name=l9 lab=GND}
C {gnd.sym} -780 230 0 0 {name=l10 lab=GND}
C {gnd.sym} -590 210 0 0 {name=l11 lab=GND}
C {GF180-PLL/analog/vco/vco_core.sym} 20 20 0 0 {name=x2}
C {lab_pin.sym} 170 10 0 1 {name=p2 lab=VDD}
C {lab_pin.sym} -130 10 0 0 {name=p5 lab=vctrl}
C {lab_pin.sym} 170 30 0 1 {name=p7 lab=vco_out}
C {capa.sym} 260 70 0 0 {name=C1
m=1
value=12f
footprint=1206
device="ceramic capacitor"}
C {pll_dac/dac7.sym} 40 -170 0 0 {name=x1}
