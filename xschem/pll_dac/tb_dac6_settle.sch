v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 300 -320 300 -280 {
lab=GND}
N -260 -340 -260 -280 {
lab=GND}
N -260 -340 -130 -340 {
lab=GND}
N 170 -320 300 -320 {
lab=GND}
N 170 -340 390 -340 {
lab=VDD}
N 390 -340 390 -330 {
lab=VDD}
N 170 -300 210 -300 {
lab=vctrl}
N 210 -300 210 -280 {
lab=vctrl}
N 210 -220 210 -190 {
lab=GND}
N 170 -360 270 -360 {
lab=vpad}
N 330 -360 460 -360 {
lab=GND}
N 460 -360 460 -330 {
lab=GND}
N 390 -270 390 -240 {
lab=GND}
C {pll_dac/dac6.sym} 20 -330 0 0 {name=x1}
C {lab_pin.sym} -130 -360 0 0 {name=p1 lab=b5,b4,b3,b2,b1,b0}
C {lab_pin.sym} 170 -360 0 1 {name=p3 lab=vpad}
C {lab_pin.sym} 170 -340 0 1 {name=p4 lab=VDD}
C {lab_pin.sym} 170 -300 0 1 {name=p6 lab=vctrl}
C {gnd.sym} 300 -280 0 0 {name=l1 lab=GND}
C {gnd.sym} -260 -280 0 0 {name=l2 lab=GND}
C {vsource.sym} 390 -300 0 0 {name=V1 value=3.3 savecurrent=false}
C {capa.sym} 210 -250 0 0 {name=C1
m=1
value=100f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 210 -190 0 0 {name=l3 lab=GND}
C {res.sym} 300 -360 3 0 {name=R1
value=10Meg
footprint=1206
device=resistor
m=1}
C {gnd.sym} 460 -330 0 0 {name=l4 lab=GND}
C {devices/code_shown.sym} -400 -130 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
"}
C {devices/code_shown.sym} 190 -100 0 0 {name=NGSPICE only_toplevel=true
value="
.control
save v(vctrl)
tran 0.1n 1u
linearize v(vctrl)
let vv = v(vctrl)
let codes = vector(10)
let codes[0]=31
let codes[1]=32
let codes[2]=31
let codes[3]=15
let codes[4]=16
let codes[5]=47
let codes[6]=48
let codes[7]=0
let codes[8]=63
let codes[9]=0
let tol = 0.5 * 0.0309
let e = 1
while e < 10
  let i0 = e*1000
  let i1 = e*1000 + 950
  let vstart = vv[i0-10]
  let vfinal = vv[i1]
  let w = vv[i0,i1]
  let hi = vecmax(w)
  let lo = vecmin(w)
  let top = vfinal
  let bot = vstart
  if vstart > vfinal
    let top = vstart
    let bot = vfinal
  end
  let glitch = 0
  if hi - top > glitch
    let glitch = hi - top
  end
  if bot - lo > glitch
    let glitch = bot - lo
  end
  let k = i1
  let last = i0
  while k >= i0
    if abs(vv[k] - vfinal) > tol
      let last = k
      let k = i0 - 1
    end
    let k = k - 1
  end
  let tset = (last - i0) * 0.1
  let cfrom = codes[e-1]
  let cto = codes[e]
  echo $&cfrom to $&cto :  settle $&tset ns   glitch $&glitch V   final $&vfinal V
  let e = e + 1
end
plot v(vctrl) title 'VCTRL during fast code changes'
.endc
"}
C {gnd.sym} 390 -240 0 0 {name=l5 lab=GND}
C {vsource.sym} -800 -330 0 0 {name=Vb0 value="PWL(0 3.3 99n 3.3 100n 0 199n 0 200n 3.3 299n 3.3 300n 3.3 399n 3.3 400n 0 499n 0 500n 3.3 599n 3.3 600n 0 699n 0 700n 0 799n 0 800n 3.3 899n 3.3 900n 0 999n 0)" savecurrent=false}
C {vsource.sym} -800 -100 0 0 {name=Vb2 value="PWL(0 3.3 99n 3.3 100n 0 199n 0 200n 3.3 299n 3.3 300n 3.3 399n 3.3 400n 0 499n 0 500n 3.3 599n 3.3 600n 0 699n 0 700n 0 799n 0 800n 3.3 899n 3.3 900n 0 999n 0)" savecurrent=false}
C {vsource.sym} -800 -210 0 0 {name=Vb1 value="PWL(0 3.3 99n 3.3 100n 0 199n 0 200n 3.3 299n 3.3 300n 3.3 399n 3.3 400n 0 499n 0 500n 3.3 599n 3.3 600n 0 699n 0 700n 0 799n 0 800n 3.3 899n 3.3 900n 0 999n 0)" savecurrent=false}
C {vsource.sym} -800 10 0 0 {name=Vb3 value="PWL(0 3.3 99n 3.3 100n 0 199n 0 200n 3.3 299n 3.3 300n 3.3 399n 3.3 400n 0 499n 0 500n 3.3 599n 3.3 600n 0 699n 0 700n 0 799n 0 800n 3.3 899n 3.3 900n 0 999n 0)" savecurrent=false}
C {vsource.sym} -800 140 0 0 {name=Vb4 value="PWL(0 3.3 99n 3.3 100n 0 199n 0 200n 3.3 299n 3.3 300n 0 399n 0 400n 3.3 499n 3.3 500n 0 599n 0 600n 3.3 699n 3.3 700n 0 799n 0 800n 3.3 899n 3.3 900n 0 999n 0)" savecurrent=false}
C {vsource.sym} -800 250 0 0 {name=Vb5 value="PWL(0 0 99n 0 100n 3.3 199n 3.3 200n 0 299n 0 300n 0 399n 0 400n 0 499n 0 500n 3.3 599n 3.3 600n 3.3 699n 3.3 700n 0 799n 0 800n 3.3 899n 3.3 900n 0 999n 0)" savecurrent=false}
C {lab_pin.sym} -800 -360 0 1 {name=p7 lab=b0}
C {lab_pin.sym} -800 -240 0 1 {name=p9 lab=b1}
C {lab_pin.sym} -800 -130 0 1 {name=p11 lab=b2}
C {lab_pin.sym} -800 -20 0 1 {name=p13 lab=b3}
C {lab_pin.sym} -800 110 0 1 {name=p15 lab=b4}
C {lab_pin.sym} -800 220 0 1 {name=p17 lab=b5}
C {gnd.sym} -800 -300 0 0 {name=l6 lab=GND}
C {gnd.sym} -800 -180 0 0 {name=l7 lab=GND}
C {gnd.sym} -800 -70 0 0 {name=l8 lab=GND}
C {gnd.sym} -800 40 0 0 {name=l9 lab=GND}
C {gnd.sym} -800 170 0 0 {name=l10 lab=GND}
C {gnd.sym} -800 280 0 0 {name=l11 lab=GND}
