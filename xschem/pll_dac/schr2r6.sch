v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -450 -100 -450 -70 {
lab=d[5:0]}
N -450 -10 -450 10 {
lab=m[5:0]}
N -250 -100 -250 -70 {
lab=m[5:0]}
N -250 -10 -250 10 {
lab=lad,j[4:0]}
N -50 -100 -50 -70 {
lab=j[4:0]}
N -50 -10 -50 10 {
lab=lad,j[4:1]}
N 160 -100 160 -70 {
lab=dt}
N 160 -10 160 10 {
lab=mt}
N 350 -100 350 -70 {
lab=mt}
N 350 -10 350 10 {
lab=j[0]}
N -300 -340 -210 -340 {
lab=b[5:0]}
N 90 -340 180 -340 {
lab=VDD}
N 90 -300 180 -300 {
lab=VSS}
C {pll_dac/sw_inv.sym} -60 -320 0 0 {name=XI[5:0]}
C {lab_pin.sym} 90 -340 0 1 {name=p1 lab=VDD}
C {lab_pin.sym} -210 -340 0 0 {name=p2 lab=b[5:0]}
C {lab_pin.sym} 90 -320 0 1 {name=p3 lab=d[5:0]}
C {lab_pin.sym} 90 -300 0 1 {name=p4 lab=VSS}
C {pll_dac/sw_inv.sym} -60 -200 0 0 {name=XIT}
C {lab_pin.sym} 90 -220 0 1 {name=p5 lab=VDD}
C {lab_pin.sym} -210 -220 0 0 {name=p6 lab=VDD}
C {lab_pin.sym} 90 -200 0 1 {name=p7 lab=dt}
C {lab_pin.sym} 90 -180 0 1 {name=p8 lab=VSS}
C {symbols/ppolyf_u_1k.sym} -450 -40 0 0 {name=RLa[5:0]
W=1u
L=61u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} -450 10 0 1 {name=p15 lab=m[5:0]}
C {lab_pin.sym} -450 -100 0 1 {name=p16 lab=d[5:0]}
C {lab_pin.sym} -470 -40 0 0 {name=p17 lab=VSS}
C {symbols/ppolyf_u_1k.sym} -250 -40 0 0 {name=RLb[5:0]
W=1u
L=61u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} -250 10 0 1 {name=p9 lab=lad,j[4:0]}
C {lab_pin.sym} -250 -100 0 1 {name=p10 lab=m[5:0]}
C {lab_pin.sym} -270 -40 0 0 {name=p11 lab=VSS}
C {symbols/ppolyf_u_1k.sym} -50 -40 0 0 {name=RR[4:0]
W=1u
L=61u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} -50 10 0 1 {name=p12 lab=lad,j[4:1]}
C {lab_pin.sym} -50 -100 0 1 {name=p13 lab=j[4:0]}
C {lab_pin.sym} -70 -40 0 0 {name=p14 lab=VSS}
C {symbols/ppolyf_u_1k.sym} 160 -40 0 0 {name=RTa
W=1u
L=61u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} 160 10 0 1 {name=p18 lab=mt}
C {lab_pin.sym} 160 -100 0 1 {name=p19 lab=dt}
C {lab_pin.sym} 140 -40 0 0 {name=p20 lab=VSS}
C {symbols/ppolyf_u_1k.sym} 350 -40 0 0 {name=RTb
W=1u
L=61u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} 350 10 0 1 {name=p21 lab=j[0]}
C {lab_pin.sym} 350 -100 0 1 {name=p22 lab=mt}
C {lab_pin.sym} 330 -40 0 0 {name=p23 lab=VSS}
C {symbols/ppolyf_u_1k.sym} -50 120 0 0 {name=RDUM[3:0]
W=1u
L=61u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} -50 150 0 1 {name=p24 lab=VSS}
C {lab_pin.sym} -50 90 0 1 {name=p25 lab=VSS}
C {lab_pin.sym} -70 120 0 0 {name=p26 lab=VSS}
C {iopin.sym} 180 -340 0 0 {name=p27 lab=VDD}
C {iopin.sym} 180 -300 0 0 {name=p28 lab=VSS}
C {ipin.sym} -300 -340 0 0 {name=p29 lab=b[5:0]}
C {opin.sym} 360 220 0 0 {name=p30 lab=lad}
