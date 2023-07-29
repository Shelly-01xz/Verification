program tb_coverage
(
    tb_if.cov intf
);

`include "tb_def.sv"

//=====================================
// Covergroup 
//=====================================
covergroup i2c_reg;
    coverpoint intf.apb_addr {
        bins PRE    = {`I2C_REG_PRE};  
        bins CTR    = {`I2C_REG_CTR};  
        bins RX     = {`I2C_REG_RX};  
        bins STATUS = {`I2C_REG_STATUS};  
        bins TX     = {`I2C_REG_TX};  
        bins CMD    = {`I2C_REG_CMD};  
    }
endgroup

covergroup i2c_reg_cmd;
    coverpoint intf.apb_wdata {
        bins START_WR = {`I2C_START_WRITE};  
        bins START_RD = {`I2C_START_READ};  
        bins STOP_RD  = {`I2C_STOP_READ};  
        bins WR       = {`I2C_WRITE};  
        bins STOP     = {`I2C_STOP};  
    }
endgroup

covergroup i2c_reg_status;
    coverpoint intf.apb_rdata {
        bins RXA  = {`I2C_STATUS_RXACK};  
        bins BUSY = {`I2C_STATUS_BUSY};  
        bins TIP  = {`I2C_STATUS_TIP};  
    }
endgroup

//=====================================
// Main 
//=====================================
i2c_reg        u_i2c_reg;
i2c_reg_cmd    u_i2c_reg_cmd;
i2c_reg_status u_i2c_reg_status;

initial begin
    u_i2c_reg        = new();
    u_i2c_reg_cmd    = new();
    u_i2c_reg_status = new();

    while(1) begin
        @(posedge intf.clk);
        if(intf.apb_sel & intf.apb_enable) begin
            u_i2c_reg.sample();
            if(intf.apb_write) 
                u_i2c_reg_cmd.sample();
            else
                u_i2c_reg_status.sample();
        end
        if(intf.sim_end) begin
            $display("\n");
            $display("=========================================================");
            $display("Coverage rate: %0d%%", $get_coverage());
            $display("=========================================================");
            $display("\n");
        end
    end
end

endprogram
