import uvm_pkg::*; 

`include "uvm_macros.svh"

`include "./interface/apb_uart_interface.sv"

`include "./object/transaction.sv"

// `include "./object/sequence/base_sequence.sv"

`include "./coverage.sv"

`include "./reg_model/reg_tx.sv"
`include "./reg_model/reg_rx.sv"
`include "./reg_model/reg_baud.sv"
`include "./reg_model/reg_conf.sv"
`include "./reg_model/reg_delay.sv"
`include "./reg_model/reg_status.sv"
`include "./reg_model/reg_rxtrig.sv"
`include "./reg_model/reg_txtrig.sv"
`include "./reg_model/reg_rxfifo_stat.sv"
`include "./reg_model/reg_txfifo_stat.sv"
`include "./reg_model/reg_model.sv"

`include "./component/apb_input_driver.sv"
`include "./component/apb_input_monitor.sv"
`include "./component/uart_output_monitor.sv"
`include "./component/sequencer.sv"
`include "./component/input_agent.sv"
`include "./component/output_agent.sv"
`include "./component/model.sv"
`include "./component/scoreboard.sv"
`include "./component/environment.sv"

`include "./test_case/base_test.sv"
`include "./test_case/test_case0.sv"
`include "./test_case/test_case1.sv"
`include "./test_case/test_case2.sv"
`include "./test_case/test_case3.sv"
`include "./test_case/test_case4.sv"
`include "./test_case/test_case5.sv"