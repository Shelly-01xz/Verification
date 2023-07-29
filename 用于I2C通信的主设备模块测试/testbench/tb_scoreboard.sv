program tb_scoreboard #
(
    TEST_NUM = 256
)
(
    tb_if.sb intf
);

int i;
int wr_test_num;
int wr_test_err_num;

bit [7:0] ref_data_buf [$];
bit [7:0] dut_data;
bit [7:0] ref_data;

//=====================================
// Goden model
//=====================================
class gdn;
    task set();
        for(i = 0; i < TEST_NUM; i++) ref_data_buf.push_front(i);
    endtask
endclass

//=====================================
// Main
//=====================================
gdn u_gdn;

initial begin
    u_gdn = new();
    u_gdn.set();
end

initial begin
    intf.sim_end    = 1'b0;
    wr_test_num     = 0;
    wr_test_err_num = 0;
    while(wr_test_num != TEST_NUM) begin
        @(posedge intf.clk);
        if(intf.dut_data_buf.size() != 0) begin
            dut_data = intf.dut_data_buf.pop_back();
            ref_data = ref_data_buf.pop_back();
            wr_test_err_num  = (dut_data == ref_data) ? wr_test_err_num : (wr_test_err_num + 1);
            wr_test_num++;
        end
    end
    $display("\n");
    $display("+------------+-------+------+------+");
    $display("|    Type    | Total | Pass | Fail |");
    $display("+------------+-------+------+------+");
    $display("|  wr_test   |  %3d  | %3d  | %3d  |", wr_test_num, (wr_test_num - wr_test_err_num), wr_test_err_num);
    $display("+------------+-------+------+------+");
    $display("| apb_assert |   /   |   /  | %3d  |", intf.apb_err_num);
    $display("+------------+-------+------+------+");
    $display("| i2c_assert |   /   |   /  | %3d  |", intf.i2c_err_num);
    $display("+------------+-------+------+------+");
    $display("\n");
    intf.sim_end = 1'b1;
    @(posedge intf.clk);
    $finish;
end

endprogram
