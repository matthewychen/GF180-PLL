v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 450 30 530 30 {
lab=#net1}
N 830 50 870 50 {
lab=Vout}
N 870 50 870 80 {
lab=Vout}
N 830 30 940 30 {
lab=#net2}
C {vsource.sym} 940 60 0 0 {name=V1 value=3.3 savecurrent=false}
C {gnd.sym} 940 90 0 0 {name=l2 lab=GND}
C {vsource.sym} 450 60 0 0 {name=V2 value=1 savecurrent=false}
C {gnd.sym} 450 90 0 0 {name=l3 lab=GND}
C {code_shown.sym} 530 230 0 0 {name=vctrl_domain_sweep only_toplevel=false value=".include /usr/local/share/pdk/gf180mcuD/libs.tech/ngspice/design.ngspice
.lib /usr/local/share/pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /usr/local/share/pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.ic v(n0)=0 v(n1)=3.3 v(n2)=0 v(n3)=3.3 v(n4)=0
.control
dc V2 0 3.3 0.01
plot v(vbiasn) v(vbiasp) xlabel Vctrl ylabel Volts title Bias_voltages
setplot new
set results = $curplot
let vc = vector(21)*0.1
let f = vector(21)*0
let i = 0
while i < 21
  let vnow = vc[i]
  alter V2 dc = $&vnow
  tran 100p 1.6u 0 100p
  set runplot = $curplot
  meas tran t1 when v(n0)=1.65 rise=8
  meas tran t2 when v(n0)=1.65 rise=28
  let fnow = 20/(t2-t1)/1e6
  set fval = $&fnow
  setplot $results
  let f[i] = $fval
  destroy $runplot
  let i = i + 1
end
print vc f
plot f vs vc xlabel Vctrl ylabel MHz title VCO_frequency
alter V2 dc = 1
alter C6 = 5f
tran 20p 540n 0 20p
let n4in = v(n4)
let v5f = v(vout)
set p5 = $curplot
alter C6 = 10f
tran 20p 540n 0 20p
let v10f = v(vout)
set p10 = $curplot
alter C6 = 15f
tran 20p 540n 0 20p
let v15f = v(vout)
set p15 = $curplot
plot \{$p5\}.n4in \{$p5\}.v5f \{$p10\}.v10f \{$p15\}.v15f xlimit 500n 540n title C6_sweep
plot v(n0) v(n1) v(n2) xlimit 500n 540n xlabel Time ylabel Volts title Ring_nodes
alter C6 = 20f
.endc
"
}
C {lab_pin.sym} 870 50 2 0 {name=p9 sig_type=std_logic lab=Vout}
C {capa.sym} 870 110 0 0 {name=C6
m=1
value=12f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 870 140 0 0 {name=l17 lab=GND}
C {vco.sym} 680 50 0 0 {name=x1}
C {gnd.sym} 830 70 0 0 {name=l1 lab=GND}
