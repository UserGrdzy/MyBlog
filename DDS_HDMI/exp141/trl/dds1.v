`timescale  1ns/1ns
module  dds1
(
    input   wire            sys_clk     ,   //系统时钟,50MHz
    input   wire            sys_rst_n   ,   //复位信号,低电平有效
    input   wire    [1:0]   wave_select ,   //输出波形选择，通过之前的key_trl选好了波形
    input   wire    [31:0]  FREQ_CTRL,      //频率选择，通过之前的f_word_set选好频率了
	 input   wire            region_active     ,   //系统时钟,50MHz
    input   wire            pos_de   ,   //复位信号,低电平有效
    output  reg             sin_wave_lab,
    output  reg             squ_wave_lab,
    output  reg             tri_wave_lab,
    output  reg             saw_wave_lab,
    output  wire    [7:0]   data_out        //波形输出
);

//********************************************************************//
//****************** Parameter and Internal Signal *******************//
//********************************************************************//
//parameter define
parameter   sin_wave    =   2'b11     ,   //正弦波
            squ_wave    =   2'b10     ,   //方波
            tri_wave    =   2'b01     ,   //三角波
            saw_wave    =   2'b00     ;   //锯齿波
  //FREQ_CTRL   =   32'd42949   ,   //相位累加器单次累加值500HZ  
parameter   PHASE_CTRL  =   12'd1024    ;   //相位偏移量


//reg   define
reg     [31:0]  fre_add     ;   //相位累加器
reg     [11:0]  rom_addr_reg;   //相位调制后的相位码
reg     [13:0]  rom_addr    ;   //ROM读地址
//wire     [13:0]  rom_addr1    ;
//assign  dac_clk  = ~sys_clk;
//reg     sin_wave_lab=1'b1;
//reg     squ_wave_lab=1'b1;
//reg     tri_wave_lab=1'b1;
//reg     saw_wave_lab=1'b1;
//********************************************************************//
//***************************** Main Code ****************************//
//********************************************************************//
//fre_add:相位累加器

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        fre_add <=  32'd0;
    else begin
        //fre_add <=  fre_add + 32'd8589934;
			  if(fre_add[31:20]>12'd3656 || region_active == 1'b0 || pos_de == 1'b0 )
					fre_add <=  32'd0;
			  else
					fre_add <=  fre_add + FREQ_CTRL*1000 + (FREQ_CTRL/8859)*934;
				end
//rom_addr:ROM读地址
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        begin
            rom_addr        <=  14'd0;
            rom_addr_reg    <=  11'd0;
        end
    else 
		 begin
		 if(region_active == 1'b0 || pos_de == 1'b0)
					rom_addr        <=  14'd0;
		 else
			 case(wave_select)
				  sin_wave:
						begin
							 squ_wave_lab    <=1'b0;
							 tri_wave_lab    <=1'b0;
							 saw_wave_lab    <=1'b0;
							 rom_addr_reg    <=  fre_add[31:20] + PHASE_CTRL;
							 rom_addr        <=  rom_addr_reg;
							 sin_wave_lab    <=1'b1;
							 
						end     //正弦波
				  squ_wave:
						begin
							 sin_wave_lab    <=1'b0;
							 tri_wave_lab    <=1'b0;
							 saw_wave_lab    <=1'b0;
							 rom_addr_reg    <=  fre_add[31:20] + PHASE_CTRL;
							 rom_addr        <=  rom_addr_reg + 14'd4096;
							 squ_wave_lab    <=1'b1;
						end     //方波
				  tri_wave:
						begin
							 sin_wave_lab    <=1'b0;
							 squ_wave_lab    <=1'b0;
							 saw_wave_lab    <=1'b0;
							 rom_addr_reg    <=  fre_add[31:20] + PHASE_CTRL;
							 rom_addr        <=  rom_addr_reg + 14'd8192;
							 tri_wave_lab    <=1'b1;
						end     //三角波
				  saw_wave:
				  begin   
							 sin_wave_lab    <=1'b0;
							 squ_wave_lab    <=1'b0;
							 tri_wave_lab    <=1'b0;
							 rom_addr_reg    <=  fre_add[31:20] + PHASE_CTRL;
							 rom_addr        <=  rom_addr_reg + 14'd12288;
							 saw_wave_lab    <= 1'b1;
						end     //锯齿波
				  default:
						begin
							 squ_wave_lab    <=1'b0;
							 tri_wave_lab    <=1'b0;
							 saw_wave_lab    <=1'b0;
							 rom_addr_reg    <=  fre_add[31:20] + PHASE_CTRL;
							 rom_addr        <=  rom_addr_reg;
							 sin_wave_lab    <=1'b1;
						end     //正弦波
			endcase
		end
//********************************************************************//
//*************************** Instantiation **************************//
//********************************************************************//
//------------------------- rom_wave_inst ------------------------
rom_wave    rom_wave_inst1
(
    .address    (rom_addr   ),  //ROM读地址
    .clock      (sys_clk    ),  //读时钟

    .q          (data_out   )   //读出波形数据
);



endmodule
