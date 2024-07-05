`timescale 1ns/10ps

module time_counter_tb();
    reg           clk;
    reg           rst_n;
   
    reg   [1:0]   model;
    reg           date_time_ch;        //时间和日期切换标志位Ｄ?o时间，1为日朠   
    reg   [23:0]  adjust_time_num;          //时间调整倠   
    reg   [23:0]  adjust_date_num;           //日期调整倠 
	
    wire  [23:0]  time_num;
    wire  [23:0]  data_num;
    wire          time_led;  
    
    
	initial clk = 0;
	always #5 clk = ~clk;
	
	time_counter U1(
            .clk                (clk),
            .rst_n              (rst_n),
            .model              (model),
            .date_time_ch       (date_time_ch),        //时间和日期切换标志位Ｄ?o时间，1为日朠   
            .adjust_time_num    (adjust_time_num),          //时间调整倠   
            .adjust_date_num    (adjust_date_num),           //日期调整倠   
            .time_num           (time_num),
            .data_num           (data_num),
            .time_led           (time_led)    
    );
	
	initial begin
        rst_n = 0;
        date_time_ch = 0;
	    #10
	    rst_n = 1;
        model = 2'b00; 
        #20000;
        model = 2'b11;    //修改时间
        adjust_time_num = 24'h16_10_23;
        #10;
        date_time_ch = 1; //修改日期
        adjust_date_num = 24'h20_06_13;
        #10000;
        $stop;
        
                
	end 	
endmodule 