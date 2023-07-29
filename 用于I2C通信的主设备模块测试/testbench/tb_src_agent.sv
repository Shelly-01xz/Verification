`timescale 1ns/1ps
program tb_src_agent #
(
    TEST_NUM = 256
)
(
    tb_if.src intf
);

`include "tb_def.sv"

int i;

//=====================================
// Generator
//=====================================
bit [12:0] eeprom_addr  [$];
bit [7:0]  eeprom_wdata [$];
bit [7:0]  eeprom_rdata [$];

class gen;
    task set();
        for(i = 0; i < TEST_NUM; i++) begin
            eeprom_addr.push_front(i);
            eeprom_wdata.push_front(i);
        end
    endtask
endclass

//=====================================
// Driver
//=====================================
class apb_bfm;
    // APB Initial
    task apb_init();
        intf.apb_addr   <= #1000 32'd0;
        intf.apb_wdata  <= #1000 32'd0;
        intf.apb_write  <= #1000 1'b1;
        intf.apb_sel    <= #1000 1'b0;
        intf.apb_enable <= #1000 1'b0;
    endtask

    // APB write & read
    task apb_wr(bit sel = 1'b0, bit [31:0] addr = 32'd0, bit [31:0] data = 32'd0);  // sel - 0:Read 1:Write
        @(posedge intf.clk) begin
            intf.apb_addr  <= #1000 addr;
            intf.apb_wdata <= #1000 sel ? data : 32'd0;
            intf.apb_write <= #1000 sel ? 1'b1 : 1'b0;
            intf.apb_sel   <= #1000 1'b1;
        end
        @(posedge intf.clk) begin
            intf.apb_enable <= #1000 1'b1;
        end
        wait(intf.apb_ready == 1'b1) begin
            @(posedge intf.clk) apb_init();
        end
    endtask
endclass

class drv extends apb_bfm;
    // I2C setup
    task i2c_setup();
        apb_wr(1'b1, `I2C_REG_PRE, 32'h0000_001f);
        repeat(4) @(posedge intf.clk);
        apb_wr(1'b1, `I2C_REG_CTR, 32'h0000_0080);
        repeat(4) @(posedge intf.clk);
    endtask

    // I2C write
    task i2c_eeprom_write_test();
        bit [12:0] addr;
        bit [7:0]  data;
        addr = eeprom_addr.pop_back();
        data = eeprom_wdata.pop_back();
        // -------------------------------------------------------------------------
        // Write Operation
        // -------------------------------------------------------------------------
        // passage 1 : start label + control byte(8bit) + ack_check
        apb_wr(1'b1, `I2C_REG_TX, `I2C_START_READ);
        repeat(11) @(posedge intf.clk);
        apb_wr(1'b1, `I2C_REG_CMD, `I2C_START_WRITE);
        repeat(9) @(posedge intf.clk);
        repeat(178) begin
            apb_wr(1'b0, `I2C_REG_STATUS);
            repeat(9) @(posedge intf.clk);
        end
        // -------------------------------------------------------------------------
        // passage 2 : address_h(8bit) + ack_check + address_l(8bit) + ack_check    // note that the real address[12:0] = addr_h[4:0] + addr_l
        for(i = 0; i < 2; i++) begin
            apb_wr(1'b1, `I2C_REG_TX, ((i == 0) ? addr[12:8] : addr[7:0]));
            repeat(11) @(posedge intf.clk);
            apb_wr(1'b1, `I2C_REG_CMD, `I2C_WRITE);
            repeat(9) @(posedge intf.clk);
            repeat(178) begin
                apb_wr(1'b0, `I2C_REG_STATUS);
                repeat(9) @(posedge intf.clk);
            end
        end
        // -------------------------------------------------------------------------
        // passage 3 : data(8bit) + ack_check
        apb_wr(1'b1, `I2C_REG_TX, data);
        repeat(11) @(posedge intf.clk);
        apb_wr(1'b1, `I2C_REG_CMD, `I2C_WRITE);
        repeat(9) @(posedge intf.clk);
        repeat(178) begin
            apb_wr(1'b0, `I2C_REG_STATUS);
            repeat(9) @(posedge intf.clk);
        end
        // -------------------------------------------------------------------------
        // passage 4 : stop label
        apb_wr(1'b1, `I2C_REG_CMD, `I2C_STOP);
        repeat(9) @(posedge intf.clk);
        repeat(178) begin
            apb_wr(1'b0, `I2C_REG_STATUS);
            repeat(9) @(posedge intf.clk);
        end
        // -------------------------------------------------------------------------
        $display("I2C write done (waddr: %3d, wdata: %3d)", addr, data);
    endtask

    // I2C read
    task i2c_eeprom_read_test();
        bit [12:0] addr;
        addr = eeprom_addr.pop_back();
        // -------------------------------------------------------------------------
        // Read Operation
        // -------------------------------------------------------------------------
        // passage 1 : start label + control byte(8bit) + ack_check
        apb_wr(1'b1, `I2C_REG_TX, `I2C_START_READ);
        repeat(11) @(posedge intf.clk);
        apb_wr(1'b1, `I2C_REG_CMD, `I2C_START_WRITE);
        repeat(9) @(posedge intf.clk);
        repeat(178) begin
            apb_wr(1'b0, `I2C_REG_STATUS);
            repeat(9) @(posedge intf.clk);
        end
        // -------------------------------------------------------------------------
        // passage 2 : address_h(8bit) + ack_check + address_l(8bit) + ack_check
        for(i = 0; i < 2; i++) begin
            apb_wr(1'b1, `I2C_REG_TX, ((i == 0) ? addr[12:8] : addr[7:0]));
            repeat(11) @(posedge intf.clk);
            apb_wr(1'b1, `I2C_REG_CMD, `I2C_WRITE);
            repeat(9) @(posedge intf.clk);
            repeat(178) begin
                apb_wr(1'b0, `I2C_REG_STATUS);
                repeat(9) @(posedge intf.clk);
            end
        end
        // -------------------------------------------------------------------------
        // passage 3 : re-start label + control byte(8bit) + ack_check
        apb_wr(1'b1, `I2C_REG_TX, 32'h0000_00a1);
        repeat(11) @(posedge intf.clk);
        apb_wr(1'b1, `I2C_REG_CMD, `I2C_START_WRITE);
        repeat(9) @(posedge intf.clk);
        repeat(178) begin
            apb_wr(1'b0, `I2C_REG_STATUS);
            repeat(9) @(posedge intf.clk);
        end
        // -------------------------------------------------------------------------
        // passage 4 : read_data(8bit) + ack_check + stop label
        apb_wr(1'b1, `I2C_REG_CMD, `I2C_STOP_READ);
        repeat(11000) @(posedge intf.clk);
        apb_wr(1'b0, `I2C_REG_RX);
        // -------------------------------------------------------------------------
        wait(intf.apb_sel & intf.apb_enable & intf.apb_ready) begin
            eeprom_rdata.push_front(intf.apb_rdata);
            $display("I2C read done (raddr: %3d, rdata: %3d)", addr, intf.apb_rdata);
        end
    endtask
endclass

//=====================================
// Monitor
//=====================================
class mon;
    task rcv();
        if(eeprom_rdata.size() != 0)
            intf.dut_data_buf.push_front(eeprom_rdata.pop_back());
    endtask
endclass

//=====================================
// Main
//=====================================
gen u_gen;
drv u_drv;
mon u_mon;

initial begin
    u_gen = new();
    u_drv = new();

    // Reset
    @(negedge intf.rst_n);
    u_drv.apb_init();
    @(posedge intf.rst_n);

    // I2C setup
    u_drv.i2c_setup();
    repeat(1000) @(posedge intf.clk);

    // I2C write test (addr,data: 0-255)
    $display("\n");
    $display("=========================================================");
    $display("I2C write test start");
    $display("=========================================================");
    u_gen.set();
    while(eeprom_addr.size() != 0) u_drv.i2c_eeprom_write_test();
    $display("=========================================================");
    $display("I2C write test end");
    $display("=========================================================");
    $display("\n");

    // I2C read test (addr,data: 0-255)
    $display("\n");
    $display("=========================================================");
    $display("I2C read test start");
    $display("=========================================================");
    u_gen.set();
    while(eeprom_addr.size() != 0) u_drv.i2c_eeprom_read_test();
    $display("=========================================================");
    $display("I2C read test end");
    $display("=========================================================");
    $display("\n");

end

initial begin
    u_mon = new();

    while(1) begin
        @(posedge intf.clk);
        u_mon.rcv();
    end
end

endprogram
