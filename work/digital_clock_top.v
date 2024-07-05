module digital_clock_top(
    input        clk,
    input        rst_n,
    input  [6:0] key_in,
    
    output [5:0] sel,                   //数码管位选（选择当前要显示的数码管）
	output [6:0] seg,                   //数码管段选（当前要显示的内容） 
    output       time_led,
    output       beep
);

    wire date_time_ch;                  //时间和日期切换标志位，0为时间，1为日期
    wire [1:0] model;                   //模式：00：时钟，01：闹钟，10：秒表，11：调时
    wire [1:0] adjust_shif;             //调整时间时，调整位置：00：秒个位，01：分个位，10：时个位
    wire key_up;                        //调整时间+
    wire key_down;                      //调整时间-
    wire pause;                         //秒表暂停/开始  0：暂停，1：开始
    wire clear;                         //秒表清除
      
	wire   [23:0]  adjust_time_num;     //时间调整值   
	wire   [23:0]  adjust_date_num;     //日期调整  
    wire   [23:0]  time_num;            //当前时间值
    wire   [23:0]  data_num;            //当前日期值    
    wire   [15:0]  adjust_clock_num;     
    wire   [23:0]  stop_watch_num;        //秒表输出显示    
    
    
    key_module key(
            .clk                (clk),
            .rst_n              (rst_n),
            .key_in             (key_in),        
            .date_time_ch       (date_time_ch),      
            .model              (model),            
            .adjust_shif        (adjust_shif),       
            .key_up             (key_up),           
            .key_down           (key_down),        
            .pause              (pause),             
            .clear              (clear)              
    );
    
    time_counter time1(
            .clk                (clk),
            .rst_n              (rst_n),
            .model              (model),
            .date_time_ch       (date_time_ch),         
            .adjust_time_num    (adjust_time_num),          
            .adjust_date_num    (adjust_date_num),      
            .time_num           (time_num),
            .data_num           (data_num),
            .time_led           (time_led)
    );
    
    adjust_module adjust(
            .clk                (clk),
            .rst_n              (rst_n),    
            .model              (model),               
            .date_time_ch       (date_time_ch),
            .adjust_shif        (adjust_shif),
            .key_up             (key_up),                 
            .key_down           (key_down),                  
            .time_num           (time_num),
            .data_num           (data_num),
            .adjust_time_num    (adjust_time_num),
            .adjust_date_num    (adjust_date_num),
            .adjust_clock_num   (adjust_clock_num)    
    );
    
    stop_watch stop(
            .clk                (clk),
            .rst_n              (rst_n),
            .model              (model),
            .pause              (pause),  
            .clear              (clear),   
            .stop_watch_num     (stop_watch_num)
    );
    
    led_seg7_display len_seg7(  
            .clk                (clk),
            .rst_n              (rst_n),
            .model              (model),
            .date_time_ch       (date_time_ch),                
            .time_num           (time_num),        
            .data_num           (data_num),        
            .adjust_time_num    (adjust_time_num), 
            .adjust_date_num    (adjust_date_num),    
            .adjust_clock_num   (adjust_clock_num), 
            .stop_watch_num     (stop_watch_num),  
            .sel                (sel),  
            .seg                (seg)      
    );

    alarm_music alarm(
            .clk                (clk),
            .rst_n              (rst_n),
            .adjust_clock_num   (adjust_clock_num),        //闹钟调整值,只有小时和分钟
            .time_num           (time_num),
            .beep               (beep)
    );


endmodule