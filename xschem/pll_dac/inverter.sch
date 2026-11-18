v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 340 -260 340 -220 {
lab=out}
N 340 -240 410 -240 {
lab=out}
N 340 -420 340 -320 {
lab=#net1}
N 340 -160 340 -80 {
lab=GND}
N 240 -290 300 -290 {
lab=in}
N 240 -290 240 -190 {
lab=in}
N 240 -190 300 -190 {
lab=in}
N 160 -240 240 -240 {
lab=in}
N 340 -290 420 -290 {
lab=#net1}
N 420 -340 420 -290 {
lab=#net1}
N 340 -340 420 -340 {
lab=#net1}
N 340 -190 440 -190 {
lab=GND}
N 440 -190 440 -140 {
lab=GND}
N 340 -140 440 -140 {
lab=GND}
N 340 -490 340 -480 {
lab=GND}
N 370 -490 370 -460 {
lab=GND}
N 340 -490 370 -490 {
lab=GND}
C {symbols/nfet_03v3.sym} 320 -190 0 0 {name=M1
L=0.28u
W=1u
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
C {symbols/pfet_03v3.sym} 320 -290 0 0 {name=M2
L=0.28u
W=2u
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
C {vsource.sym} 340 -450 2 0 {name=Vdd value=3.3}
C {gnd.sym} 370 -460 0 0 {name=l1 lab=GND}
C {gnd.sym} 340 -80 0 0 {name=l2 lab=GND}
C {devices/code_shown.sym} 530 -320 0 0 {name=NGSPICE only_toplevel=true
value="
.control
save all
dc Vin 0 3.3 0.01
meas dc vm when v(out)=v(in)
plot v(in) v(out)
.endc
"}
C {vsource.sym} 160 -210 0 0 {name=Vin value=0}
C {gnd.sym} 160 -180 0 0 {name=l4 lab=GND}
C {lab_pin.sym} 160 -240 0 0 {name=p1 sig_type=std_logic lab=in
}
C {lab_pin.sym} 300 -290 0 0 {name=p2 sig_type=std_logic lab=in
}
C {lab_pin.sym} 300 -190 0 0 {name=p3 sig_type=std_logic lab=in
}
C {lab_pin.sym} 410 -240 0 0 {name=p4 sig_type=std_logic lab=out

}
C {devices/code_shown.sym} -10 -70 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
