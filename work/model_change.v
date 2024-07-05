module model_change(
    input clk,
    input rst_n,
    input key_in,
    output [1:0] model
);

//------------------------------------------- 模式：00：时钟，01：闹钟，10：秒表，11：调时 --------------------------------------------------------------------------
    reg [1:0] cnt;

    always@(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            cnt <= 2'd0;
        end
        else if(key_in)  //按键按下
            cnt <= cnt + 1'b1;   // 00 01 10 11循环
        else 
            cnt <= cnt;
    end 

    assign model = cnt;  //是否需要用时序逻辑同步输出？？？？


endmodule 