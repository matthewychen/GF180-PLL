v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 270 310 270 350 {
lab=Y}
N 270 330 340 330 {
lab=Y}
N 270 150 270 250 {
lab=VDD}
N 270 410 270 490 {
lab=VSS}
N 170 280 230 280 {
lab=A}
N 170 280 170 380 {
lab=A}
N 170 380 230 380 {
lab=A}
N 90 330 170 330 {
lab=A}
N 270 280 350 280 {
lab=VDD}
N 270 380 370 380 {
lab=VSS}
N 370 380 370 390 {
lab=VSS}
N 270 440 370 440 {
lab=VSS}
N 370 390 370 440 {
lab=VSS}
N 350 220 350 280 {
lab=VDD}
N 270 220 350 220 {
lab=VDD}
C {symbols/nfet_03v3.sym} 250 380 0 0 {name=M1
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
C {symbols/pfet_03v3.sym} 250 280 0 0 {name=M2
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
C {ipin.sym} 90 330 0 0 {name=p1 lab=A}
C {iopin.sym} 270 150 3 0 {name=p2 lab=VDD}
C {iopin.sym} 270 490 1 0 {name=p3 lab=VSS
}
C {opin.sym} 340 330 0 0 {name=p4 lab=Y}
