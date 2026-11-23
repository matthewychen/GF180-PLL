v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 320 -330 320 -290 {
lab=Y}
N 320 -310 390 -310 {
lab=Y}
N 320 -490 320 -390 {
lab=VDD}
N 320 -230 320 -150 {
lab=VSS}
N 220 -360 280 -360 {
lab=A}
N 220 -360 220 -260 {
lab=A}
N 220 -260 280 -260 {
lab=A}
N 140 -310 220 -310 {
lab=A}
N 320 -360 400 -360 {
lab=VDD}
N 320 -260 420 -260 {
lab=VSS}
N 420 -260 420 -250 {
lab=VSS}
N 320 -200 420 -200 {
lab=VSS}
N 420 -250 420 -200 {
lab=VSS}
N 400 -420 400 -360 {
lab=VDD}
N 320 -420 400 -420 {
lab=VDD}
C {symbols/nfet_03v3.sym} 300 -260 0 0 {name=M1
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
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 300 -360 0 0 {name=M2
L=0.28u
W=5.6u
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
C {ipin.sym} 140 -310 0 0 {name=p1 lab=A}
C {iopin.sym} 320 -490 3 0 {name=p2 lab=VDD}
C {iopin.sym} 320 -150 1 0 {name=p3 lab=VSS
}
C {opin.sym} 390 -310 0 0 {name=p4 lab=Y}
