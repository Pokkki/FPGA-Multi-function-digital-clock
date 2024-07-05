//----------------------------数码管显示-------------------------------------------------------------
module led_seg7_display(  
    input clk,
    input rst_n,
    input [1:0] model,
    input date_time_ch,           // 时钟/日期    
    input [23:0] time_num,        // 时钟数据
    input [23:0] data_num,        // 日期数据
    input [23:0] adjust_time_num, // 调整时钟数据
    input [23:0] adjust_date_num, // 调整日期数据    
    input [15:0] adjust_clock_num,// 调整闹钟数据
    input [23:0] stop_watch_num,  // 秒表

    output [5:0] sel,             // 数码管位选（选择当前要显示的数码管）
	output reg [6:0] seg          // 数码管段选（当前要显示的内容） 
);

//--------------------------------------------- 显示数据选择 -------------------------------------------------------------------------------   
    reg [23:0] show_num;
    
    always@(posedge clk, negedge rst_n) begin
        if(!rst_n)
            show_num <= 24'h0;
        else begin
            if(model == 2'b00) begin      //常规显示
                if(!date_time_ch)          //显示时间
                    show_num <= time_num;
                else                      //日期显示
                    show_num <= data_num;
            end 
            else if(model == 2'b01)       //闹钟显示
                show_num <= {adjust_clock_num, 8'b00000000};  //闹钟只有小时和分钟，这里默认秒位
            else if(model == 2'b10)       //秒表显示
                show_num <= stop_watch_num;
            else begin                    //调整时间
                if(!date_time_ch)         //调整时间显示
                    show_num <= adjust_time_num;
                else                      //调整日期显示
                    show_num <= adjust_date_num;
            end
        end 
    end
//--------------------------------------------- 数码管显示逻辑 ----------------------------------------------------------------------------------                
    wire clk_1ms;  //数码管扫描周期1ms
	 	 
    clk_div #(.CNT_MAX(1)) clk_div_1ms(   //为了缩短仿真时间，参数设置，即为一个时钟周期
    .clk_in  (clk),
    .rst_n   (rst_n),
    .clk_out (clk_1ms)
    );
    
    reg [5:0]sel_r;    //位选缓存
    reg [3:0]data_tmp; //数据缓存
    
    always@(posedge clk_1ms or negedge rst_n)
	if(!rst_n)
		sel_r <= 6'b0000_01;
	else if(sel_r == 6'b1000_00)
		sel_r <= 6'b0000_01;
	else
		sel_r <=  sel_r << 1;
		
	always@(*)
		case(sel_r)
			8'b0000_01:data_tmp = show_num[3:0];
			8'b0000_10:data_tmp = show_num[7:4];
			8'b0001_00:data_tmp = show_num[11:8];
			8'b0010_00:data_tmp = show_num[15:12];
			8'b0100_00:data_tmp = show_num[19:16];
			8'b1000_00:data_tmp = show_num[23:20];
			default:   data_tmp = 4'b0000;
		endcase
		
	always@(*)
		case(data_tmp)
			4'h0:seg = 7'b1000000;
			4'h1:seg = 7'b1111001;
			4'h2:seg = 7'b0100100;
			4'h3:seg = 7'b0110000;
			4'h4:seg = 7'b0011001;
			4'h5:seg = 7'b0010010;
			4'h6:seg = 7'b0000010;
			4'h7:seg = 7'b1111000;
			4'h8:seg = 7'b0000000;
			4'h9:seg = 7'b0010000;
			4'ha:seg = 7'b0001000;
			4'hb:seg = 7'b0000011;
			4'hc:seg = 7'b1000110;
			4'hd:seg = 7'b0100001;
			4'he:seg = 7'b0000110;
			4'hf:seg = 7'b0001110;
            default:
                 seg = 7'b1000000;
		endcase
		
	assign sel = sel_r;

endmodule