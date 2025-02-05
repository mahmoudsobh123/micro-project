module BasicComputer(CLK,AC,AR,PC,DR,IR,E,I);

input clk;
output reg [7:0] IR,DR,AC;
output reg [3:0] AR,PC;
reg [7:0] MEM [15:0]; //16 Locations * 8-bit lenght each  addressed by 4-bit address
reg I;
output reg E;
initial
begin
SC <= 0;
IR <= 0;
DR <= 0;
AC <= 0;
PC <= 0;
AR <=0;
I<=0;
E<=1;
$readmemh("D:\MoWaliD\FINAL PROJECT/memory-data.txt", MEM); 
end

always @(posedge clk)
begin 
	if (SC == 0) begin	//T0
		AR <= PC;
		SC <= SC + 1; end
	
	else if (SC == 1) begin // T1
		IR <= MEM[AR[3:0]];
		PC <= PC + 1;		
		SC <= SC + 1; end
	
	else if (SC == 2) begin //T2
		AR <= IR[3:0];
		I <= IR[7];
		SC <= SC +1; end// T3
	
	else begin
		if (IR[6:4] == 3'b111) begin //D7=1 >> register refrence
			
			if(I == 0) begin
				if(AR[3:0] == 4'b1000) begin//CLEAR AC
					AC <= 0;
					SC <= 0; end
					
				else if(AR[3:0] == 4'b0100) begin//INCREMENT AC
					AC <= AC +1 ;
                    SC <= 0; end
					
				else if(AR[3:0] == 4'b0010) begin //COMPLEMENT AC
					AC <= ~AC;
					SC <= 0; end			
			end
		else begin // Memory reference instructions
		
			if(I == 1) begin// indirect
				if (SC == 3) begin //T3
					AR <= MEM[AR[3:0]];  // GET direct address 
					SC <= SC + 1; end //T4 
				else begin // instuctions
					if(IR[ 6 : 4 ] == 3'b000) begin //AND
						if(SC == 4) begin
							DR <= MEM[AR[3 :0]]; 
							SC <= SC + 1; end
						else begin
							AC <= (AC & DR);
							SC <= 0; end
					end
					else if(IR[ 6 : 4 ] == 3'b001) begin // ADD
						if(SC == 4) begin
							DR <= MEM[AR[3 :0]]; 
							SC <= SC + 1; end
						else begin
							{E,AC} <= AC + DR;
							SC <= 0; end
					end
					
					else if(IR[6:4] == 3'b010) begin //LDA
                        if(SC == 4) begin
                            DR <= MEM[AR[3:0]]; 
                            SC <= SC + 1; end
                        else begin
                            AC <= DR;
                            SC <= 0; end
                    end        
					
					
					else if(IR[ 6 : 4 ] == 3'b011) begin//STA
					  if(SC == 4) begin

						MEM[AR[3 :0]] <= AC ; 
						SC <= 0;
						end
					end
				
					else if(IR[ 6 : 4 ] == 3'b100) begin //ISZ
                        if ( SC == 4) begin
                            DR <= MEM[AR[3 :0]]; 
                            SC <= SC +1; end
                        else if(SC ==5) begin
                            DR <= DR +1;
                            SC <= SC +1; end
                        else if(SC ==6) begin
                            MEM[AR[3 :0]] <= DR; 
                                if(DR == 0)
                                    PC <= PC +1;
                                    SC <= 0;
                            end
					end	
					else begin //do nothing          
                         SC <= 0; end        
			   end
			end
			if(I == 0) begin // direct
				if (SC == 3) //T3
					SC <= SC + 1; //do nothing
				else begin 
					if(IR[ 6 : 4 ] == 3'b000) begin //AND
                    if(SC == 4) begin
                        DR <= MEM[AR[3 :0]]; 
                        SC <= SC + 1; end
                    else begin
                        AC <= (AC & DR);
                        SC <= 0; end
                end
                else if(IR[ 6 : 4 ] == 3'b001) begin //ADD
                    if(SC == 4) begin
                        DR <= MEM[AR[3 :0]]; 
                        SC <= SC + 1; end
                    else begin
                        {E,AC} <= AC + DR;
                        SC <= 0; end
                end
                
                else if(IR[ 6 : 4] == 3'b010) begin //LDA
                    if(SC == 4) begin
                        DR <= MEM[AR[3:0]]; 
                        SC <= SC + 1; end
                    else begin
                        AC <= DR;
                        SC <= 0; end
                end        
                
                
                else if(IR[ 6 : 4 ] == 3'b011) begin//STA
                    MEM[AR[3 :0]] <= AC ; 
                    SC <= 0;
                end
            
                else if(IR[ 6 : 4 ] == 3'b100) begin //ISZ
                    if ( SC == 4) begin
                        DR <= MEM[AR[3 :0]]; 
                        SC <= SC +1; end
                    else if(SC ==5) begin
                        DR <= DR +1;
                        SC <= SC +1; end
                    else if(SC ==6) begin
                        MEM[AR[3 :0]] <= DR; 
                            if(DR == 0) 
                                PC <= PC +1;
                        SC <= 0; end
                        

                  end    
                  else begin //do nothing          
                       SC <= 0; end        
				end
			end
		end 		
	end 
end
endmodule