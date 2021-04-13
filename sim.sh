#! /bin/bash

ghdl -a ./pwm.vhd ./pwm_tb.vhd
ghdl -s ./pwm.vhd ./pwm_tb.vhd
ghdl -e pwm_tb
ghdl -r pwm_tb --vcd=pwm_tb.vcd --stop-time=100000us
gtkwave pwm_tb.vcd
