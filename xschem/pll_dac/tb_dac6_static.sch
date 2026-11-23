v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 300 -80 300 -40 {
lab=GND}
N -260 -100 -260 -40 {
lab=GND}
N -260 -100 -130 -100 {
lab=GND}
N 170 -80 300 -80 {
lab=GND}
N 170 -100 390 -100 {
lab=VDD}
N 390 -100 390 -90 {
lab=VDD}
N 170 -60 210 -60 {
lab=vctrl}
N 210 -60 210 -40 {
lab=vctrl}
N 210 20 210 50 {
lab=GND}
N 170 -120 270 -120 {
lab=vpad}
N 330 -120 460 -120 {
lab=GND}
N 460 -120 460 -90 {
lab=GND}
N 390 -30 390 -0 {
lab=GND}
C {pll_dac/dac6.sym} 20 -90 0 0 {name=x1}
C {lab_pin.sym} -130 -120 0 0 {name=p1 lab=b5,b4,b3,b2,b1,b0}
C {lab_pin.sym} 170 -120 0 1 {name=p3 lab=vpad}
C {lab_pin.sym} 170 -100 0 1 {name=p4 lab=VDD}
C {lab_pin.sym} 170 -60 0 1 {name=p6 lab=vctrl}
C {gnd.sym} 300 -40 0 0 {name=l1 lab=GND}
C {gnd.sym} -260 -40 0 0 {name=l2 lab=GND}
C {vsource.sym} 390 -60 0 0 {name=V1 value=3.3 savecurrent=false}
C {capa.sym} 210 -10 0 0 {name=C1
m=1
value=100f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 210 50 0 0 {name=l3 lab=GND}
C {res.sym} 300 -120 3 0 {name=R1
value=10Meg
footprint=1206
device=resistor
m=1}
C {gnd.sym} 460 -90 0 0 {name=l4 lab=GND}
C {devices/code_shown.sym} 540 -130 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
"}
C {devices/code_shown.sym} 560 80 0 0 {name=NGSPICE only_toplevel=true
value="
.control
save v(vctrl) i(V1)
tran 1n 32u
plot v(vctrl) title 'VCTRL vs time'
linearize v(vctrl) i(V1)
let vcode = vector(64)
let icode = vector(64)
let k = 0
while k < 64
  let idx = (k+1)*500 - 25
  let vcode[k] = v(vctrl)[idx]
  let icode[k] = -i(V1)[idx]
  let k = k + 1
end
let lsb = (vcode[63] - vcode[0]) / 63
let code = vector(64)
let trans = vector(63)
let stp = vcode[1,63] - vcode[0,62]
let dnl = stp / lsb - 1
let inl = (vcode - (vcode[0] + lsb * code)) / lsb
let worst = vecmin(dnl)
let k = 0
while k < 63
  if dnl[k] = worst
    let wcode = k
  end
  let k = k + 1
end
let wnext = wcode + 1
let v0 = vcode[0]
let v63 = vcode[63]
let lsbmv = abs(lsb) * 1000
let dmax = vecmax(dnl)
let imin = vecmin(inl)
let imx = vecmax(inl)
let d7 = dnl[7]
let d15 = dnl[15]
let d31 = dnl[31]
let d47 = dnl[47]
let iua = vecmax(icode) * 1e6
echo =================== DAC static results ===================
echo V(code 0) = $&v0 V     V(code 63) = $&v63 V
echo LSB        = $&lsbmv mV
echo Worst DNL  = $&worst LSB  (at code $&wcode to $&wnext)
echo Max DNL    = $&dmax LSB
echo INL range  = $&imin to $&imx LSB
echo Major carries:  7-8: $&d7   15-16: $&d15   31-32: $&d31   47-48: $&d47
echo Highest settled supply current = $&iua uA
if worst > -1
  echo MONOTONIC: yes (every step goes the same way)
else
  echo MONOTONIC: NO, at least one step goes backwards
end
echo ==========================================================
plot vcode vs code title 'VCTRL at each code' xlabel 'code' ylabel 'V'
plot dnl vs trans title 'DNL per step (step k to k+1)' xlabel 'step k' ylabel 'LSB'
plot inl vs code title 'INL per code' xlabel 'code' ylabel 'LSB'
.endc
"}
C {gnd.sym} 390 0 0 0 {name=l5 lab=GND}
C {vsource.sym} -800 -90 0 0 {name=Vb0 value="PULSE(0 3.3 500n 1n 1n 499n 1u)" savecurrent=false}
C {vsource.sym} -800 140 0 0 {name=Vb2 value="PULSE(0 3.3 2u 1n 1n 1.999u 4u)" savecurrent=false}
C {vsource.sym} -800 30 0 0 {name=Vb1 value="PULSE(0 3.3 1u 1n 1n 999n 2u)" savecurrent=false}
C {vsource.sym} -800 250 0 0 {name=Vb3 value="PULSE(0 3.3 4u 1n 1n 3.999u 8u)" savecurrent=false}
C {vsource.sym} -800 380 0 0 {name=Vb4 value="PULSE(0 3.3 8u 1n 1n 7.999u 16u)" savecurrent=false}
C {vsource.sym} -800 490 0 0 {name=Vb5 value="PULSE(0 3.3 16u 1n 1n 15.999u 32u)" savecurrent=false}
C {lab_pin.sym} -800 -120 0 1 {name=p7 lab=b0}
C {lab_pin.sym} -800 0 0 1 {name=p9 lab=b1}
C {lab_pin.sym} -800 110 0 1 {name=p11 lab=b2}
C {lab_pin.sym} -800 220 0 1 {name=p13 lab=b3}
C {lab_pin.sym} -800 350 0 1 {name=p15 lab=b4}
C {lab_pin.sym} -800 460 0 1 {name=p17 lab=b5}
C {gnd.sym} -800 -60 0 0 {name=l6 lab=GND}
C {gnd.sym} -800 60 0 0 {name=l7 lab=GND}
C {gnd.sym} -800 170 0 0 {name=l8 lab=GND}
C {gnd.sym} -800 280 0 0 {name=l9 lab=GND}
C {gnd.sym} -800 410 0 0 {name=l10 lab=GND}
C {gnd.sym} -800 520 0 0 {name=l11 lab=GND}
