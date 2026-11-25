v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -90 230 -90 260 {
lab=d[6:0]}
N -90 320 -90 340 {
lab=m[6:0]}
N 110 230 110 260 {
lab=m[6:0]}
N 110 320 110 340 {
lab=lad,j[5:0]}
N 310 230 310 260 {
lab=j[5:0]}
N 310 320 310 340 {
lab=lad,j[5:1]}
N 520 230 520 260 {
lab=dt}
N 520 320 520 340 {
lab=mt}
N 710 230 710 260 {
lab=mt}
N 710 320 710 340 {
lab=j[0]}
N 60 -10 150 -10 {
lab=b[6:0]}
N 450 -10 540 -10 {
lab=VDD}
N 450 30 540 30 {
lab=VSS}
C {lab_pin.sym} 450 -10 0 1 {name=p1 lab=VDD}
C {lab_pin.sym} 150 -10 0 0 {name=p2 lab=b[6:0]}
C {lab_pin.sym} 450 10 0 1 {name=p3 lab=d[6:0]}
C {lab_pin.sym} 450 30 0 1 {name=p4 lab=VSS}
C {lab_pin.sym} 450 110 0 1 {name=p5 lab=VDD}
C {lab_pin.sym} 150 110 0 0 {name=p6 lab=VDD}
C {lab_pin.sym} 450 130 0 1 {name=p7 lab=dt}
C {lab_pin.sym} 450 150 0 1 {name=p8 lab=VSS}
C {symbols/ppolyf_u_1k.sym} -90 290 0 0 {name=RLa[6:0]
W=1u
L=61u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} -90 340 0 1 {name=p15 lab=m[6:0]}
C {lab_pin.sym} -90 230 0 1 {name=p16 lab=d[6:0]}
C {lab_pin.sym} -110 290 0 0 {name=p17 lab=VSS}
C {symbols/ppolyf_u_1k.sym} 110 290 0 0 {name=RLb[6:0]
W=1u
L=61u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} 110 340 0 1 {name=p9 lab=lad,j[5:0]}
C {lab_pin.sym} 110 230 0 1 {name=p10 lab=m[6:0]}
C {lab_pin.sym} 90 290 0 0 {name=p11 lab=VSS}
C {symbols/ppolyf_u_1k.sym} 310 290 0 0 {name=RR[5:0]
W=1u
L=61u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} 310 340 0 1 {name=p12 lab=lad,j[5:1]}
C {lab_pin.sym} 310 230 0 1 {name=p13 lab=j[5:0]}
C {lab_pin.sym} 290 290 0 0 {name=p14 lab=VSS}
C {symbols/ppolyf_u_1k.sym} 520 290 0 0 {name=RTa
W=1u
L=61u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} 520 340 0 1 {name=p18 lab=mt}
C {lab_pin.sym} 520 230 0 1 {name=p19 lab=dt}
C {lab_pin.sym} 500 290 0 0 {name=p20 lab=VSS}
C {symbols/ppolyf_u_1k.sym} 710 290 0 0 {name=RTb
W=1u
L=61u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} 710 340 0 1 {name=p21 lab=j[0]}
C {lab_pin.sym} 710 230 0 1 {name=p22 lab=mt}
C {lab_pin.sym} 690 290 0 0 {name=p23 lab=VSS}
C {symbols/ppolyf_u_1k.sym} 310 450 0 0 {name=RDUM[3:0]
W=1u
L=61u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} 310 480 0 1 {name=p24 lab=VSS}
C {lab_pin.sym} 310 420 0 1 {name=p25 lab=VSS}
C {lab_pin.sym} 290 450 0 0 {name=p26 lab=VSS}
C {iopin.sym} 540 -10 0 0 {name=p27 lab=VDD}
C {iopin.sym} 540 30 0 0 {name=p28 lab=VSS}
C {ipin.sym} 60 -10 0 0 {name=p29 lab=b[6:0]}
C {opin.sym} 720 550 0 0 {name=p30 lab=lad}
C {pll_dac/sw_inv7.sym} 300 10 0 0 {name=XI1[6:0]}
C {pll_dac/sw_inv7.sym} 300 130 0 0 {name=XIT}
