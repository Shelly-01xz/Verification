`define I2C_REG_PRE    32'h1002_5000
`define I2C_REG_CTR    32'h1002_5004
`define I2C_REG_RX     32'h1002_5008
`define I2C_REG_STATUS 32'h1002_500C
`define I2C_REG_TX     32'h1002_5010
`define I2C_REG_CMD    32'h1002_5014

`define I2C_START   (32'h1 << 7)
`define I2C_STOP    (32'h1 << 6)
`define I2C_READ    (32'h1 << 5)
`define I2C_WRITE   (32'h1 << 4)
`define I2C_CLR_INT (32'h1 << 0)

`define I2C_START_READ  32'h0000_00A0
`define I2C_STOP_READ   32'h0000_0060
`define I2C_START_WRITE 32'h0000_0090
`define I2C_STOP_WRITE  32'h0000_0050

`define I2C_CTR_EN       (32'h1 << 7)   // enable only
`define I2C_CTR_INTEN    (32'h1 << 6)   // interrupt enable only
`define I2C_CTR_EN_INTEN 32'h0000_00C0  // enable i2c and interrupts

`define I2C_STATUS_RXACK (32'h1 << 7)
`define I2C_STATUS_BUSY  (32'h1 << 6)
`define I2C_STATUS_AL    (32'h1 << 5)
`define I2C_STATUS_TIP   (32'h1 << 1)
`define I2C_STATUS_IF    (32'h1 << 0)
