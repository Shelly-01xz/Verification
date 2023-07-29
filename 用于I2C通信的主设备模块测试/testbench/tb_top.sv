`timescale 1ns/1ps

module tb_top;

parameter TEST_NUM = 256;

logic clk;
logic rst_n;

//=====================================
// Clock & Reset
//=====================================
// clk
initial begin
	clk = 1'b0;
	forever clk = #2000 ~clk;
end

// rst_n
initial begin
	rst_n = 1'b1;
	@(negedge clk);
	rst_n = 1'b0;
	repeat(100) @(negedge clk);
	rst_n = 1'b1;
end

//=====================================
// Instance
//=====================================
tb_if                         u_tb_if          ( clk, rst_n );
tb_src_agent   # ( TEST_NUM ) u_tb_src_agent   ( u_tb_if    );
i2c_eeprom_sim                u_i2c_eeprom_sim ( u_tb_if    );
tb_scoreboard  # ( TEST_NUM ) u_tb_scoreboard  ( u_tb_if    );
tb_assertion                  u_tb_assertion   ( u_tb_if    );
tb_coverage                   u_tb_coverage    ( u_tb_if    );

endmodule
