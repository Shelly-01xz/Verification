module i2c_eeprom_sim (
    tb_if.dut intf
    /*
    // general signals
    input  wire        i2c_clk   ,
    input  wire        i2c_rstn  ,

    // APB signals
    input  wire [31:0] apb_addr  ,
    input  wire [31:0] apb_wdata ,
    input  wire        apb_write ,
    input  wire        apb_sel   ,
    input  wire        apb_enable,
    output wire [31:0] apb_rdata ,
    output wire        apb_ready ,
    output wire        apb_slverr
    */
);

// -----------------------------------------------------
// i2c_master module
// -----------------------------------------------------

    wire scl_i ; // scl for input
    wire scl_en; // scl for output

    wire sda_i ; // sda for input
    wire sda_en; // sda for output

    apb_i2c #(
        .APB_ADDR_WIDTH (32)
    ) u_perips_apb_i2c0 (
        .HCLK          (intf.clk       ),
        .HRESETn       (intf.rst_n     ),

        .PADDR         (intf.apb_addr  ),
        .PWDATA        (intf.apb_wdata ),
        .PWRITE        (intf.apb_write ),
        .PSEL          (intf.apb_sel   ),
        .PENABLE       (intf.apb_enable),
        .PRDATA        (intf.apb_rdata ),
        .PREADY        (intf.apb_ready ),
        .PSLVERR       (intf.apb_slverr),

        .interrupt_o   (/*unused*/     ),
        .scl_pad_i     (scl_i          ),
        .scl_pad_o     (/*unused*/     ),
        .scl_padoen_o  (scl_en         ),
        .sda_pad_i     (sda_i          ),
        .sda_pad_o     (/*unused*/     ),
        .sda_padoen_o  (sda_en         )
    );

// -----------------------------------------------------
// iobuf
// -----------------------------------------------------

    wire scl; // io
    wire sda; // io

    i2c_iobuf_sim i2c_iobuf_sim (
        .scl_e (!scl_en),
        .scl_i (scl_i  ),
        .scl   (scl    ),
        .sda_e (!sda_en),
        .sda_i (sda_i  ),
        .sda   (sda    )
    );

// -----------------------------------------------------
// eerprom
// -----------------------------------------------------

    EEPROM_AT24C64 EEPROM_AT24C64 (
      .scl (scl),
      .sda (sda)
    );

    assign intf.i2c_scl    = scl;
    assign intf.i2c_sda    = sda;
    assign intf.i2c_status = u_perips_apb_i2c0.byte_controller.c_state;

endmodule
