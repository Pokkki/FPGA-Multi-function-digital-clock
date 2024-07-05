`timescale 1ns/10ps

module adjust_module_tb();
    reg clk;
    reg rst_n;    
    reg [1:0] model;            // 模式：00：时钟，01：闹钟，10：秒表，11：调时
    reg date_time_ch;           // 时间/日期
    reg [1:0] adjust_shif;      // 调整时间时，调整位置：00：秒个位，01：分个位，10：时个位
    reg key_up;                 // 调整时间+
    reg key_down;               // 调整时间- 
    reg [23:0] time_num;
    reg [23:0] data_num;
  //  input pause;              // 秒表暂停/开始  0：暂停，1：开始
  //  input clear;              // 秒表清除
    wire [23:0] adjust_time_num;
    wire [23:0] adjust_date_num;
    wire [15:0] adjust_clock_num;
    
    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin
        rst_n = 0;
        model = 0;            // 模式：00：时钟，01：闹钟，10：秒表，11：调时
        date_time_ch = 0;           // 时间/日期
        adjust_shif = 0;      // 调整时间时，调整位置：00：秒个位，01：分个位，10：时个位
        key_up = 0;                 // 调整时间+
        key_down = 0;               // 调整时间- 
        time_num = 0;
        data_num = 0;
        #10;
        rst_n = 1;
        time_num = 24'h23_58_46;
        #10;  

//------------------------------------------------ 闹钟设置 -------------------------------------------------------        
        model = 2'b01; //闹钟模式
        repeat(15) begin  //分个位=5
            #10;
            key_up = 1;  //一个时钟周期的高电平脉冲
            #10;
            key_up = 0;
        end 
        #10;
        adjust_shif = 2'b01;   //分十位
        repeat(17) begin  //分十位=7
            #10
            key_up = 1;  //一个时钟周期的高电平脉冲
            #10
            key_up = 0;
        end
        #10;
        adjust_shif = 2'b10;   //分十位
        repeat(25) begin  //时个位=1
            #10
            key_up = 1;  //一个时钟周期的高电平脉冲
            #10
            key_up = 0;
        end
//--------------------------------------------------- 调整时间 ----------------------------------------------------------------    
        model = 2'b11; //调时模式
        adjust_shif = 2'b00;
        repeat(20) begin  // 秒 15
            #10;
            key_up = 1;  //一个时钟周期的高电平脉冲
            #10;
            key_up = 0;
        end 
        #10;
        adjust_shif = 2'b01;   //分十位
        repeat(15) begin  // 分 26
            #10
            key_up = 1;  //一个时钟周期的高电平脉冲
            #10
            key_up = 0;
        end
        #10;
        adjust_shif = 2'b10;   //分十位
        repeat(15) begin  //时个位=1
            #10
            key_up = 1;  //一个时钟周期的高电平脉冲
            #10
            key_up = 0;
        end
     //-------------- 载入当前时间 ---------------   
        #10
        model = 2'b00;        
        time_num = 24'h15_19_56;
        adjust_shif = 2'b00;
        #10
        model = 2'b11;
        repeat(5) begin  //
            #10;
            key_up = 1;  //一个时钟周期的高电平脉冲
            #10;
            key_up = 0;
        end 
        #10;
        adjust_shif = 2'b01;   
        repeat(6) begin  // 分 26
            #10
            key_up = 1;  //一个时钟周期的高电平脉冲
            #10
            key_up = 0;
        end
        #10;
        adjust_shif = 2'b10;  
        repeat(7) begin  
            #10
            key_up = 1;  //一个时钟周期的高电平脉冲
            #10
            key_up = 0;
        end                
//-------------------------------------------------------------------------------
        #10;
        model = 2'b00;
        data_num = 24'h20_06_28;
        #10;
        model = 2'b11;
        date_time_ch = 1;  //日期
        adjust_shif = 2'b00; 
        repeat(15) begin  // 
            #10;
            key_up = 1;  //一个时钟周期的高电平脉冲
            #10;
            key_up = 0;
        end 
        #10;
        adjust_shif = 2'b01;   //分十位
        repeat(15) begin  // 分 26
            #10
            key_up = 1;  //一个时钟周期的高电平脉冲
            #10
            key_up = 0;
        end
        #10;
        adjust_shif = 2'b10;   //分十位
        repeat(15) begin  //时个位=1
            #10
            key_up = 1;  //一个时钟周期的高电平脉冲
            #10
            key_up = 0;
        end
        
    
    
    
    
    
    end
    
    adjust_module U2(
        .clk             (clk),  
        .rst_n           (rst_n),        
        .model           (model),            //模式：00：时钟，01：闹钟，10：秒表，11：调时
        .date_time_ch    (date_time_ch),
        .adjust_shif     (adjust_shif),  //调整时间时，调整位置：00：秒个位，01：分个位，10：时个位
        .key_up          (key_up),                 //调整时间+
        .key_down        (key_down),               //调整时间-    
        .time_num        (time_num),
        .data_num        (data_num),
         //t pause,                  //秒表暂停/开始  0：暂停，1：开始
         //t clear                  //秒表清除
        .adjust_time_num (adjust_time_num),
        .adjust_date_num (adjust_date_num),
        .adjust_clock_num(adjust_clock_num)    
    );
endmodule