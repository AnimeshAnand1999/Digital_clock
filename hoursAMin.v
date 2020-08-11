//'include"Mux.v"
module hoursAmin(
input clock,input rst, output reg[6:0] disp, output reg[3:0] anode);
reg [32:0] clkc; wire clr_clkc;
always@(posedge clock)
	if(!rst || clr_clkc) clkc <= 33'd 0;
	else clkc <= clkc+1;
assign clr_clkc = (clkc == 33'd5999999999);

reg [5:0] min; reg[4:0] hr;
wire clr_min,clr_hr;
always@(posedge clock)
	if(!rst || clr_min) min <=0;
	else if(clr_clkc) min <= min+1;
assign clr_min = (min == 6'd59)&&(clr_clkc);

always@(posedge clock)
	if(!rst || clr_hr) hr <=0;
	else if(clr_min) hr <= hr+1;
assign clr_hr = (hr == 5'd23)&&(clr_min);

wire [6:0] msbhr,lsbhr,msbmin,lsbmin;
Mux m0({1'b0,hr},{msbhr,lsbhr});//getting 7 & 7 bit for the two seven segement display of hour
Mux m1(min,{msbmin,lsbmin});//getting 7 and 7 bit for the two seven segment display of minute

reg [19:0] counter = 20'd0;
always@(posedge clock)
	counter <= counter+1; //generating a milisecond counter

always@(*)	//diplaying hosurrs and minutes on seven segement display
case({counter[19:18]})
	2'b00:begin anode <= 4'b0001; disp <= lsbmin; end
	2'b01:begin anode <= 4'b0010; disp <= msbmin; end
	2'b10:begin anode <= 4'b0100; disp <= lsbhr; end
	2'b11:begin anode <= 4'b1000; disp <= msbhr; end
endcase

endmodule



/*module tb_hoursAMin();

reg sysclk,rst;
wire [6:0]display;
wire [3:0]anode;

hoursAMin h1(sysclk,rst,display,anode);
initial
begin 
sysclk=0;rst=0;
end
always
#10 sysclk <= ~sysclk;
endmodule
*/
