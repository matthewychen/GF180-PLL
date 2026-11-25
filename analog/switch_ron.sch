v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 290 -500 290 -460 {
lab=yn}
N 290 -400 290 -360 {
lab=GND}
N 400 -590 400 -570 {
lab=Vdd}
N 220 -430 250 -430 {
lab=Vdd}
N 220 -530 220 -430 {
lab=Vdd}
N 220 -530 250 -530 {
lab=Vdd}
N 550 -490 550 -450 {
lab=yp}
N 550 -390 550 -350 {
lab=GND}
N 550 -570 550 -550 {
lab=Vdd}
N 480 -420 510 -420 {
lab=GND}
N 480 -520 480 -420 {
lab=GND}
N 480 -520 510 -520 {
lab=GND}
N 450 -470 480 -470 {
lab=GND}
N 400 -660 400 -650 {
lab=GND}
N 430 -660 430 -630 {
lab=GND}
N 400 -660 430 -660 {
lab=GND}
N 290 -570 290 -560 {
lab=Vdd}
N 290 -570 400 -570 {
lab=Vdd}
N 400 -570 550 -570 {
lab=Vdd}
N 220 -570 220 -530 {
lab=Vdd}
N 220 -570 280 -570 {
lab=Vdd}
N 220 -570 280 -570 {
lab=Vdd}
N 280 -570 290 -570 {
lab=Vdd}
N 290 -430 360 -430 {
lab=GND}
N 360 -430 360 -380 {
lab=GND}
N 290 -380 360 -380 {
lab=GND}
N 550 -420 620 -420 {
lab=GND}
N 620 -420 620 -370 {
lab=GND}
N 550 -370 620 -370 {
lab=GND}
N 290 -470 390 -470 {
lab=yn}
N 550 -460 690 -460 {
lab=yp}
C {symbols/nfet_03v3.sym} 270 -430 0 0 {name=M1
L=0.28u
W=4u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 270 -530 0 0 {name=M3
L=0.28u
W=11.2u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 530 -420 0 0 {name=M2
L=0.28u
W=4u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 530 -520 0 0 {name=M4
L=0.28u
W=11.2u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 220 -480 2 0 {name=p1 sig_type=std_logic lab=Vdd
}
C {gnd.sym} 450 -470 0 0 {name=l1 lab=GND}
C {gnd.sym} 550 -350 0 0 {name=l2 lab=GND}
C {gnd.sym} 290 -360 0 0 {name=l3 lab=GND}
C {lab_pin.sym} 290 -480 2 0 {name=p2 sig_type=std_logic lab=yn
}
C {lab_pin.sym} 550 -470 2 0 {name=p3 sig_type=std_logic lab=yp
}
C {vsource.sym} 400 -620 2 0 {name=Vdd value=2.97}
C {gnd.sym} 430 -630 0 0 {name=l5 lab=GND}
C {lab_pin.sym} 480 -570 1 0 {name=p5 sig_type=std_logic lab=Vdd
}
C {lab_pin.sym} 290 -530 2 0 {name=p4 sig_type=std_logic lab=Vdd
}
C {lab_pin.sym} 550 -520 2 0 {name=p6 sig_type=std_logic lab=Vdd
}
C {vsource.sym} 390 -440 0 0 {name=Vfn value=0.01}
C {vsource.sym} 690 -430 0 0 {name=Vfp value=2.96}
C {gnd.sym} 390 -410 0 0 {name=l4 lab=GND}
C {gnd.sym} 690 -400 0 0 {name=l6 lab=GND}
C {devices/code_shown.sym} 10 -90 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice ss
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.temp 85
"}
C {devices/code_shown.sym} 830 -520 0 0 {name=NGSPICE only_toplevel=true value="
.control
op
let ron_n = 0.01/abs(i(Vfn))
let ron_p = 0.01/abs(i(Vfp))
print ron_n ron_p
.endc
" }
