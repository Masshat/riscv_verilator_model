`include "config_soc.v"

module artix_wrapper (
  input   clk_sys,
  input   reset_n,
  // JTAG Interface
  input   jtag_tck,
  input   jtag_tms,
  input   jtag_tdi,
  output  jtag_tdo,
  input   jtag_trstn,
  // Peripherals
  output  [11:0] gpio_out,
  input   [3:0] gpio_in
);
  logic core_clk;
  logic periph_clk;
  logic fetch_enable;

  mmcm clk_mmcm (
    // Clock in ports
    .clk_in(clk_sys),
    // Clock out ports
    .core_clk(core_clk),
    .periph_clk(periph_clk),
    // Status and control signals
    .resetn(reset_n),
    .locked(fetch_enable)
  );

  riscv_soc #(
    .USE_SAME_CLOCK_CORE_PERIPH(0)
  ) riscv (
    .core_clk(core_clk),
    .periph_clk(periph_clk),
    .reset_n(reset_n),
    .boot_addr_i(32'h1A00_0080),    // Fixed in boot loop
    .fetch_enable_i(fetch_enable),
    .gpio_out(gpio_out),
    .gpio_in(gpio_in),
    .jtag_tck(jtag_tck),
    .jtag_tms(jtag_tms),
    .jtag_tdi(jtag_tdi),
    .jtag_tdo(jtag_tdo),
    .jtag_trstn(jtag_trstn)
  );
endmodule
