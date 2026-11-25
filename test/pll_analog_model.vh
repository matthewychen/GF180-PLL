// Behavioral DAC + VCO model shared by the closed-loop testbenches. `include it inside the module.
// DAC: VCTRL = V_FS - code * V_LSB (Hugh's simulation: 1.95 V full scale, 30.9 mV/code).
// VCO: Matthew's simulated frequency vs VCTRL, 5 points per corner, linear between them.
//      Frequency FALLS as VCTRL rises, so a higher code gives a higher frequency.
// Provides: tab_idx (0 tt, 1 ss, 2 ff), scale (extra frequency factor), f_of_code(real code).

localparam real V_FS  = 1.95;
localparam real V_LSB = 0.0309;

real tab_v [0:4];
real tab_f [0:14];     // [corner*5 + point]; Icarus 11 has no 2-D real arrays
initial begin
    tab_v[0] = 0.00;  tab_v[1] = 0.56;  tab_v[2] = 0.90;  tab_v[3] = 1.32;  tab_v[4] = 2.00;
    tab_f[0] = 137.0e6; tab_f[1] = 103.0e6; tab_f[2] =  80.0e6; tab_f[3] = 55.0e6; tab_f[4] = 19.0e6; // tt
    tab_f[5] = 112.0e6; tab_f[6] =  80.0e6; tab_f[7] =  58.0e6; tab_f[8] = 35.0e6; tab_f[9] =  5.9e6; // ss
    tab_f[10]= 169.0e6; tab_f[11]= 134.0e6; tab_f[12]= 107.0e6; tab_f[13]= 80.0e6; tab_f[14]= 39.0e6; // ff
end

integer tab_idx = 0;
real    scale   = 1.0;

function real vctrl_of_r(input real code_r);
    vctrl_of_r = V_FS - code_r * V_LSB;
endfunction

// linear interpolation in the table, clamped at the ends
function real f_table(input integer ci, input real v);
    integer i;
    begin
        if (v <= tab_v[0])      f_table = tab_f[ci*5];
        else if (v >= tab_v[4]) f_table = tab_f[ci*5+4];
        else begin
            f_table = tab_f[ci*5+4];
            for (i = 0; i < 4; i = i + 1)
                if (v >= tab_v[i] && v < tab_v[i+1])
                    f_table = tab_f[ci*5+i] + (tab_f[ci*5+i+1] - tab_f[ci*5+i])
                                              * (v - tab_v[i]) / (tab_v[i+1] - tab_v[i]);
        end
    end
endfunction

function real f_of_code(input real code_r);
    f_of_code = scale * f_table(tab_idx, vctrl_of_r(code_r));
endfunction
