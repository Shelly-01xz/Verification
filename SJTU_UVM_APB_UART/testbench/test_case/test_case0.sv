`ifndef TEST_CASE0_SV
`define TEST_CASE0_SV

/*
寄存器读写测试
测试内容：通过 APB 总线配置 UART 模块寄存器，所有控制寄存器的读写测试、所有状态寄存器的读写测试。
测试通过标准：读写值是否正确。
*/

class case0_sequence extends uvm_sequence #(transaction);

    `uvm_object_utils(case0_sequence)

    extern function new  (string name = "case0_sequence");
    extern task     body ();

endclass
// new
function case0_sequence::new (string name = "case0_sequence");
    super.new(name);
endfunction
// body
task case0_sequence::body();

    if(this.starting_phase != null) begin
        this.starting_phase.raise_objection(this);
    end
    
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h00;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::IDLE;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h00;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::READ; req.paddr == 32'h00;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::READ; req.paddr == 32'h04;})
    get_response(rsp);

    #6000000;

    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h08;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::READ; req.paddr == 32'h08;})
    get_response(rsp);
    
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h0c;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::READ; req.paddr == 32'h0c;})
    get_response(rsp);
    
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h10;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::READ; req.paddr == 32'h10;})
    get_response(rsp);
    
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h14;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::READ; req.paddr == 32'h14;})
    get_response(rsp);
    
    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h18;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::READ; req.paddr == 32'h18;})
    get_response(rsp);

    `uvm_do_with(req, {req.ttype == transaction::WRITE; req.paddr == 32'h1c;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::READ; req.paddr == 32'h1c;})
    get_response(rsp);

    `uvm_do_with(req, {req.ttype == transaction::READ; req.paddr == 32'h20;})
    get_response(rsp);
    `uvm_do_with(req, {req.ttype == transaction::READ; req.paddr == 32'h24;})
    get_response(rsp);

    #100;
    

    if(this.starting_phase != null) begin
        starting_phase.drop_objection(this);
    end

endtask


class test_case0 extends base_test;

    `uvm_component_utils(test_case0)

    extern         function      new         (string name = "test_case0", uvm_component parent = null);
    extern virtual function void build_phase (uvm_phase phase); 

endclass
// new
function test_case0::new (string name = "test_case0", uvm_component parent = null);
    super.new(name, parent, "test_case0");
endfunction
// build_phase
function void test_case0::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.agt_i.sqr.main_phase", "default_sequence", case0_sequence::type_id::get());

endfunction


`endif