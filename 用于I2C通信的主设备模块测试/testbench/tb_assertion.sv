program tb_assertion
(
    tb_if.ast intf
);

//=====================================
// APB assertion 
//=====================================
initial begin
    @(posedge intf.rst_n);
    while(1) begin
        @(posedge intf.clk)
        assert(~(~intf.apb_sel & intf.apb_enable)) else intf.apb_err_num++;
    end
end

//=====================================
// I2C assertion 
//=====================================
sequence i2c_start;
    @(posedge intf.clk) intf.i2c_scl & $fell(intf.i2c_sda);
endsequence

sequence i2c_work;
    @(posedge intf.clk) ((($rose(intf.i2c_scl))[*8]) ##1 $fell(intf.i2c_sda))[*1:$];
endsequence

sequence i2c_end;
    @(posedge intf.clk) $rose(intf.i2c_sda);
endsequence

property i2c_check;
    i2c_start |-> i2c_work |-> i2c_end
endproperty

initial begin
    @(posedge intf.rst_n);
    while(1) begin
        @(posedge intf.clk);
        assert((intf.i2c_status == 5'b0_0000) |
               (intf.i2c_status == 5'b0_0001) |
               (intf.i2c_status == 5'b0_0010) |
               (intf.i2c_status == 5'b0_0100) |
               (intf.i2c_status == 5'b0_1000) |
               (intf.i2c_status == 5'b1_0000)) else intf.i2c_err_num++;
        assert property (i2c_check) else intf.i2c_err_num++;
    end
end

endprogram
