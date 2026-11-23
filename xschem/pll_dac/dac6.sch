v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
C {pll_dac/schr2r6.sym} -50 -210 0 0 {name=x1}
C {lab_pin.sym} 100 -230 0 1 {name=p1 lab=VDD}
C {lab_pin.sym} -200 -230 0 0 {name=p2 lab=b[5:0]}
C {lab_pin.sym} 100 -210 0 1 {name=p3 lab=VSS}
C {lab_pin.sym} 100 -190 0 1 {name=p4 lab=vctrl}
C {symbols/ppolyf_u_1k.sym} -20 -20 0 0 {name=RD1
W=1u
L=61u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} -20 10 0 1 {name=p5 lab=rd}
C {lab_pin.sym} -20 -50 0 1 {name=p6 lab=vctrl}
C {lab_pin.sym} -40 -20 0 0 {name=p7 lab=VSS}
C {symbols/ppolyf_u_1k.sym} 210 -20 0 0 {name=RD2[1:0]
W=1u
L=61u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} 210 10 0 1 {name=p8 lab=VSS}
C {lab_pin.sym} 210 -50 0 1 {name=p9 lab=rd}
C {lab_pin.sym} 190 -20 0 0 {name=p10 lab=VSS}
C {pll_dac/sw_inv.sym} -50 -120 0 0 {name=XOL}
C {lab_pin.sym} 100 -140 0 1 {name=p11 lab=VDD}
C {lab_pin.sym} -200 -140 0 0 {name=p12 lab=ol_en}
C {lab_pin.sym} 100 -120 0 1 {name=p13 lab=ol_en_b}
C {lab_pin.sym} 100 -100 0 1 {name=p14 lab=VSS}
C {symbols/pfet_03v3.sym} 350 -220 0 0 {name=M2
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
C {symbols/nfet_03v3.sym} 350 -100 0 0 {name=M1
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
C {lab_pin.sym} 370 -190 0 1 {name=p15 lab=vctrl}
C {lab_pin.sym} 330 -220 0 0 {name=p16 lab=ol_en_b}
C {lab_pin.sym} 370 -250 0 1 {name=p17 lab=vpad}
C {lab_pin.sym} 370 -220 0 0 {name=p18 lab=VDD}
C {lab_pin.sym} 370 -130 0 1 {name=p19 lab=vctrl}
C {lab_pin.sym} 330 -100 0 0 {name=p20 lab=ol_en}
C {lab_pin.sym} 370 -70 0 1 {name=p21 lab=vpad}
C {lab_pin.sym} 370 -100 0 0 {name=p22 lab=VSS}
C {ipin.sym} -310 100 0 0 {name=p23 lab=b[5:0]}
C {ipin.sym} -310 150 0 0 {name=p24 lab=ol_en}
C {iopin.sym} -310 200 2 0 {name=p25 lab=vpad}
C {iopin.sym} -310 240 2 0 {name=p26 lab=VDD}
C {iopin.sym} -310 280 2 0 {name=p27 lab=VSS}
C {opin.sym} -310 320 2 0 {name=p28 lab=vctrl}
