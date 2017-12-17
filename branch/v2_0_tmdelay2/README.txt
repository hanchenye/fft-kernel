dif_radix2_64p_fft: TOP module
dif_radix2_pe: Radix-2 butterfly computing module
dif_radix2_tm: Middle twiddle factors multiplier
dif_radix2_da: Output data arranger (sort)
dif_radix2_ctrl: Control module

fft-----ctrl
|
|
pe5 --> pe4 --> pe3 --> tm --> pe2 --> pe1 --> pe0 --> da
|                       |                              |
|                       |                              |
radix2_butterfly        twiddle64_const                da_regfile
shift_register
twiddle8_multiplier
