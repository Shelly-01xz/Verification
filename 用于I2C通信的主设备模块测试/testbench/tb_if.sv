interface tb_if
(
    input logic clk,
    input logic rst_n
);

//=====================================
// Signal
//=====================================
// apb
logic [31:0] apb_addr;
logic [31:0] apb_wdata;
logic        apb_write;
logic        apb_sel;
logic        apb_enable;
logic [31:0] apb_rdata;
logic        apb_ready;
logic        apb_slverr;

// i2c
logic       i2c_scl;
logic       i2c_sda;
logic [4:0] i2c_status;

// scoreboard
int       apb_err_num;
int       i2c_err_num;
bit [7:0] dut_data_buf [$];

// sim
bit sim_end;

//=====================================
// Modport
//=====================================
// src_agent
modport src
(
    input  clk,
    input  rst_n,
    // i2c_eeprom 
    output apb_addr,
    output apb_wdata,
    output apb_write,
    output apb_sel,
    output apb_enable,
    input  apb_rdata,
    input  apb_ready,
    input  apb_slverr,
    // scoreboard
    output dut_data_buf
);

// i2c_eeprom
modport dut
(
    input  clk,
    input  rst_n,
    // src_agent 
    input  apb_addr,
    input  apb_wdata,
    input  apb_write,
    input  apb_sel,
    input  apb_enable,
    output apb_rdata,
    output apb_ready,
    output apb_slverr,
    // assertion 
    output i2c_scl,
    output i2c_sda,
    output i2c_status
);

// scoreboard
modport sb
(
    input  clk,
    input  rst_n,
    // src_agent 
    input  dut_data_buf,
    // assertion 
    input  apb_err_num,
    input  i2c_err_num,
    // coverage 
    output sim_end
);

// assertion 
modport ast
(
    input  clk,
    input  rst_n,
    // src_agent 
    input  apb_sel,
    input  apb_enable,
    // i2c_eeprom 
    input  i2c_scl,
    input  i2c_sda,
    input  i2c_status,
    // scoreboard
    output apb_err_num,
    output i2c_err_num
);

// coverage 
modport cov 
(
    input clk,
    input rst_n,
    // src_agent 
    input apb_addr,
    input apb_wdata,
    input apb_write,
    input apb_sel,
    input apb_enable,
    // i2c_eeprom
    input apb_rdata,
    // scoreboard
    input sim_end
);

endinterface
