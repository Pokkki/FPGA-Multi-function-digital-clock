module clk_div( //clk_out的周期，可在上层模块例化时修改 
    input clk_in,
    input rst_n,
    output clk_out
);
    
//--------------------------------------------------------------------------------       
    parameter CNT_MAX = 25_000_000;  //分频数/2
    
    reg clk_reg;
    reg [27:0] cnt;

//-------------------------------------------------------------------------------------     
    assign clk_out = clk_reg;
   
    always@(posedge clk_in, negedge rst_n) begin
        if(!rst_n) begin
            clk_reg <= 1'b0;
            cnt <= 28'd0;
        end 
        else begin
            if(cnt == CNT_MAX - 1) begin
                cnt <= 28'd0;
                clk_reg <= ~clk_reg;           
            end 
            else begin            
                cnt <= cnt + 1'b1;
                clk_reg <= clk_reg;
            end
        end 
    end
            
endmodule 