`timescale 1ns/10ps

module key_module_tb();
    reg clk;
    reg rst_n;
    reg [6:0] key_in;
    
    wire date_time_ch;
    wire [1:0] model;        
    wire [1:0] adjust_shif; 
    wire key_up;       
    wire key_down;     
    wire pause;       
    wire clear;

    initial clk = 0;
    always #5 clk = ~clk;
       
//---- key1 日期，时间切换
//---- key2 模式切换 （时间显示，校准时间，闹钟， 秒表换
//---- key3 调时和设置闹钟时，小时、分钟左右切换
//---- key4 +1 
//---- key5 -1
//---- key6 秒表暂停（开始）切换
//---- key7 秒表清除    
    initial begin
	   rst_n = 0;
	   #5
	   rst_n = 1;
       key_in = 8'b11111111;
       
       // 时间 日期切换
       #50
       key_in[0] = 0;   //日期
       #30
       key_in[0] = 1;   
       #30
       key_in[0] = 0;   //时间
       #30
       key_in[0] = 1;
       #30
       key_in[0] = 0;   //日期 
       #30
       key_in[0] = 1;
       #30
       key_in[0] = 0;    //时间
       #30
       key_in[0] = 1;
       
      
      //  模式切换     
       #50       
       key_in[1] = 0;   //闹钟
       #30           
       key_in[1] = 1;
       #30           
       key_in[1] = 0;   //秒表
       #30           
       key_in[1] = 1;
       #30           
       key_in[1] = 0;   //调时
       #30           
       key_in[1] = 1;
       #30           
       key_in[1] = 0;   //常规
       #30           
       key_in[1] = 1;
       #30
       key_in[1] = 0;  //闹钟模式
       #30
       key_in[1] = 1;  
 
       
       //左右位置切换
       #50              
       key_in[2] = 0;   //01
       #30
       key_in[2] = 1;  
       #30
       key_in[2] = 0;  //10
       #30
       key_in[2] = 1;
       #30
       key_in[2] = 0;  //00
       #30
       key_in[2] = 1;
       #30
       key_in[2] = 0;  //01
       #30
       key_in[2] = 1;
       
       #50
       key_in[1] = 0;  //秒表模式
       #30
       key_in[1] = 1; 
       
       #50
       key_in[5] = 0;  //开始
       #30
       key_in[5] = 1;  
       #30
       key_in[5] = 0;
       #30
       key_in[5] = 1;
       #30
       key_in[5] = 0;   //开始
       #30
       key_in[5] = 1;  

       
       #50
       key_in[1] = 0;  //闹钟模式
       #30
       key_in[1] = 1;
       
       #50
       key_in[6] = 0;  //清除	
       #30
       key_in[6] = 1;
	end 
	
	key_module key_module1(
        .clk            (clk),
        .rst_n          (rst_n),
        .key_in         (key_in),
        
        .date_time_ch  (date_time_ch),      //时间和日期切换标志位，0为时间，1为日期        
        .model          (model),            //模式：00：时钟，01：闹钟，10：秒表，11：调时       
        .adjust_shif    (adjust_shif),  //调整时间时，调整位置：00：秒个位，01：分个位，10：时个位
        .key_up         (key_up),                 //调整时间+
        .key_down       (key_down),               //调整时间-
        .pause          (pause),                  //秒表暂停/开始  0：暂停，1：开始
        .clear          (clear)                  //秒表清除
    );


endmodule 