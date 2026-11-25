v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 20 -210 20 -200 {
lab=vctrl}
N -80 -210 20 -210 {
lab=vctrl}
N 20 -140 20 -130 {
lab=#net1}
C {lab_pin.sym} -80 -250 0 1 {name=p1 lab=VDD}
C {lab_pin.sym} -380 -250 0 0 {name=p2 lab=b[6:0]}
C {lab_pin.sym} -80 -230 0 1 {name=p3 lab=VSS}
C {lab_pin.sym} -80 -210 0 1 {name=p4 lab=vctrl}
C {symbols/ppolyf_u_1k.sym} -200 -40 0 0 {name=RD1
W=1u
L=61u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} -200 -10 0 1 {name=p5 lab=rd}
C {lab_pin.sym} -200 -70 0 1 {name=p6 lab=vctrl}
C {lab_pin.sym} -220 -40 0 0 {name=p7 lab=VSS}
C {symbols/ppolyf_u_1k.sym} 30 -40 0 0 {name=RD2[1:0]
W=1u
L=61u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} 30 -10 0 1 {name=p8 lab=VSS}
C {lab_pin.sym} 30 -70 0 1 {name=p9 lab=rd}
C {lab_pin.sym} 10 -40 0 0 {name=p10 lab=VSS}
C {lab_pin.sym} -80 -160 0 1 {name=p11 lab=VDD}
C {lab_pin.sym} -380 -160 0 0 {name=p12 lab=ol_en}
C {lab_pin.sym} -80 -140 0 1 {name=p13 lab=ol_en_b}
C {lab_pin.sym} -80 -120 0 1 {name=p14 lab=VSS}
C {symbols/pfet_03v3.sym} 170 -240 0 0 {name=M2
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
C {symbols/nfet_03v3.sym} 170 -120 0 0 {name=M1
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
C {lab_pin.sym} 190 -210 0 1 {name=p15 lab=vctrl}
C {lab_pin.sym} 150 -240 0 0 {name=p16 lab=ol_en_b}
C {lab_pin.sym} 190 -270 0 1 {name=p17 lab=vpad}
C {lab_pin.sym} 190 -240 0 0 {name=p18 lab=VDD}
C {lab_pin.sym} 190 -150 0 1 {name=p19 lab=vctrl}
C {lab_pin.sym} 150 -120 0 0 {name=p20 lab=ol_en}
C {lab_pin.sym} 190 -90 0 1 {name=p21 lab=vpad}
C {lab_pin.sym} 190 -120 0 0 {name=p22 lab=VSS}
C {ipin.sym} -490 80 0 0 {name=p23 lab=b[6:0]}
C {ipin.sym} -490 130 0 0 {name=p24 lab=ol_en}
C {iopin.sym} -490 180 2 0 {name=p25 lab=vpad}
C {iopin.sym} -490 220 2 0 {name=p26 lab=VDD}
C {iopin.sym} -490 260 2 0 {name=p27 lab=VSS}
C {opin.sym} -490 300 2 0 {name=p28 lab=vctrl}
C {pll_dac/sw_inv7.sym} -230 -140 0 0 {name=XOL1}
C {pll_dac/r2r7.sym} -230 -230 0 0 {name=x2}
C {symbols/cap_mim_2f0fF.sym} 20 -170 0 0 {name=C1
W=12.3e-6
L=12.3e-6
model=cap_mim_2f0fF
spiceprefix=X
m=1}
C {lab_pin.sym} 20 -130 0 1 {name=p29 lab=VSS}
