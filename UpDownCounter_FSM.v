`timescale 1ns / 1ps
module UpDownCounter_FSM(
    reset,
    enable,
    clk,
    count
    );
	 
	input clk;
	input reset;
	input enable;
	output count;
	
	wire clk;
	wire reset;
	wire enable;
	reg [4:0] count;
	
	parameter [4:0] max = 15;
	parameter [1:0] UP  = 2'b00,
	                DOWN = 2'b01,
	                RESET = 2'b11,
	                IDLE = 2'b10;
	
	reg [1:0] state, next, saved_state;
	
	always @(posedge clk)
		if(reset)
			state = RESET;
		else
			state = next;
	
	always @(negedge clk)
		if(state == RESET) begin
			count <= 0;
			next <= UP;
		end else if (enable)
			case (state)
				UP:
					if(count == max) begin
						next <= DOWN;
						count <= count - 1;
					end else
						count <= count + 1;
				DOWN:
					if(count == 0) begin
						next <= UP;
						count <= count + 1;
					end else
						count <= count - 1;
				IDLE:
					next <= saved_state;
			endcase
		else
			next <= IDLE;
					
endmodule 