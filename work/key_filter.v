module key_filter(
    input clk,
    input rst_n,
    input key_in,
    output reg key_state,  //预留
    output key_flag
);

    parameter CNT_MAX = 1;   //20ms计数值 1_000_000

    reg [19:0] key_H, key_L;         //计数变量

//------------------按键为低 计数-------------------------------------------------------------------------------------------------
    always@(posedge clk, negedge rst_n) begin
        if(!rst_n)
            key_H <= 20'd0;
        else begin
            if(key_in)
                key_H <= key_H + 1;
            else
                key_H <= 20'd0;       
        end     
    end 

//-------------------按键为高 计数-----------------------------------------------------------------------------------------------------    
    always@(posedge clk, negedge rst_n) begin
        if(!rst_n)
            key_L <= 20'd0;
        else begin
            if(!key_in)
                key_L <= key_L + 1;
            else
                key_L <= 20'd0;       
        end     
    end 

//-------------------key_state输出判断-------------------------------------------------------------------------------------------------------   
    always@(posedge clk, negedge rst_n) begin
        if(!rst_n)
            key_state <= 1'b1;
        else begin
            if(key_H > CNT_MAX)
                key_state <= 1'b1;
            else if(key_L > CNT_MAX)
                key_state <= 1'b0;            
        end 
    end 
//---------------------按键按下 下降沿判断-------------------------------------------------------------  
    reg state1, state2;
    always@(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            state1 <= 1'b0;
            state2 <= 1'b0;
        end 
        else begin
            state1 <= key_state;
            state2 <= state1;
        end    
    end 
    
    assign key_flag = (!state1) & state2;   //按键按下，flag为高

endmodule 