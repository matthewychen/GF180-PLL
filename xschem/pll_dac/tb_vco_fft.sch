v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 330 260 330 290 {
lab=GND}
N 240 190 330 190 {
lab=vco_out}
N 330 190 330 200 {
lab=vco_out}
N -80 170 -60 170 {
lab=vctrl}
N -80 170 -80 200 {
lab=vctrl}
N 240 170 490 170 {
lab=VDD}
C {gnd.sym} 330 290 0 0 {name=l3 lab=GND}
C {devices/code_shown.sym} 650 -40 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
"}
C {devices/code_shown.sym} 670 80 0 0 {name=NGSPICE only_toplevel=true value="
.ic v(x2.n0)=0 v(x2.n1)=3.3 v(x2.n2)=0 v(x2.n3)=3.3 v(x2.n4)=0
.control
save v(vco_out)
tran 0.1n 40u 10u
plot v(vco_out) xlimit 39.9u 40u
linearize v(vco_out)
set specwindow=hanning
fft v(vco_out)
let mag = db(mag(v(vco_out)))
meas sp f_peak max_at mag from=60e6 to=100e6
meas sp peak max mag from=60e6 to=100e6
plot mag xlimit 70e6 90e6 title VCO_alone_spectrum
.endc
"}
C {GF180-PLL/analog/vco/vco_core.sym} 90 180 0 0 {name=x2}
C {lab_pin.sym} 240 170 0 1 {name=p2 lab=VDD}
C {lab_pin.sym} -60 170 0 0 {name=p5 lab=vctrl}
C {lab_pin.sym} 240 190 0 1 {name=p7 lab=vco_out}
C {capa.sym} 330 230 0 0 {name=C1
m=1
value=12f
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} -80 230 0 0 {name=V1 value=1 savecurrent=false}
C {gnd.sym} -80 260 0 0 {name=l1 lab=GND}
C {vsource.sym} 490 200 0 0 {name=Vdd1 value=3.3 savecurrent=false}
C {gnd.sym} 490 230 0 0 {name=l4 lab=GND}
