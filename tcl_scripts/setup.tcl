# setup name of the clock in your design.
set clkname PHI

# set variable "modname" to the name of topmost module in design
set modname accumulator

# set variable "RTL_DIR" to the HDL directory w.r.t synthesis directory
set RTL_DIR .

# set variable "GATE_DIR" to the output directory w.r.t synthesis directory
set GATE_DIR    .

# set variable "type" to a name that distinguishes this synthesis run
set type tut1

#set the number of digits to be used for delay results
set report_default_significant_digits 4

suppress_message "OPT-106"
suppress_message "UID-401"

