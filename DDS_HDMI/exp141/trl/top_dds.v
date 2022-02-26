`timescale  1ns/1ns
module  top_dds
(
    input   wire            sys_clk     ,   //系统时钟,50MHz
    input   wire            sys_rst_n   ,   //复位信号,低电平有效
    input   wire            [1:0]key    , //输入2位按键选择波形
    input   wire	        key_add,       //频率加
    input   wire            key_sub,        //频率减
    output  wire            dac_clk,   //输入DAC模块时钟
    
    //output   wire        [5:0]seg_sel,
    //output   wire        [7:0]seg_led, 
    output   wire         [7:0]dac_data ,       //输入DAC模块波形数据
	 
	 
	 output  wire            ddc_scl     ,
    output  wire            ddc_sda     ,
    output  wire            tmds_clk_p  ,
    output  wire            tmds_clk_n  ,   //HDMI时钟差分信号
    output  wire    [2:0]   tmds_data_p ,
    output  wire    [2:0]   tmds_data_n     //HDMI图像差分信号
	 
);              

//********************************************************************//
//****************** Parameter and Internal Signal *******************//
//********************************************************************//
//wire  define
wire    [1:0]   wave_select ;   //波形选择
wire    [31:0]   FREQ_CTRL ;

wire            clk_25m         ;   //25MHz
wire            clk_125m        ;
wire            locked          ;   //时钟输出有效
wire            rst_n           ;   //系统复位信号
wire            hsync           ;   //输出行同步信号
wire            vsync           ;   //输出场同步信号
wire    [23:0]  vga_rgb         ;   //输出像素点色彩信息
wire            rgb_valid       ;
wire            eth_rxdv        ;
wire    [3:0]   eth_rx_data     ;


wire                            grid_hs;
wire                            grid_vs;
wire                            grid_de;
wire[7:0]                       grid_r;
wire[7:0]                       grid_g;
wire[7:0]                       grid_b;

wire                            wave0_hs;
wire                            wave0_vs;
wire                            wave0_de;
wire[7:0]                       wave0_r;
wire[7:0]                       wave0_g;
wire[7:0]                       wave0_b;


//dac_clka:DAC模块时钟
assign  dac_clk  = ~sys_clk;
assign  rst_n   = sys_rst_n & locked;
assign  ddc_scl = 1'b1;
assign  ddc_sda = 1'b1;

//********************************************************************//
//*************************** Instantiation **************************//
//********************************************************************//
//-------------------------- dds_inst -----------------------------
dds     dds_inst
(
    .sys_clk        (sys_clk    ),   //系统时钟,50MHz
    .sys_rst_n      (sys_rst_n  ),   //复位信号,低电平有效
    .wave_select    (wave_select),   //输出波形选择
    .FREQ_CTRL      (FREQ_CTRL ),   //频率字送入
    .data_out       (dac_data   )    //波形输出
);

//----------------------- key_control_inst ------------------------
key_ctl key_trl_inst
(
    .sys_clk        (sys_clk    ),   //系统时钟,50MHz
    .sys_rst_n      (sys_rst_n  ),   //复位信号,低电平有效
    .key            (key        ),   //输入4位按键
    .wave_select    (wave_select)    //输出波形选择
 );


/*seg_led seg_led_insit( 
  
      .sys_clk(sys_clk),       // 全局时钟信号
      .sys_rst_n(sys_rst_n),       // 复位信号（低有效）
      .cn(FREQ_CTRL),       //频率字输入
      .seg_sel(seg_sel),       // 数码管位选信号
      .seg_led(seg_led)          // 数码管段选信号
    
);*/
 
 f_word_set  f_word_set_insit(
.sys_clk(sys_clk),
.sys_rst_n(sys_rst_n),
. key_add(key_add),//按键部分传过来的加法信号
 .key_sub( key_sub),//按键部分传过来的加法信号
.FREQ_CTRL(FREQ_CTRL)  //输出确定的频率值	
	);
	
	
	vga_ctrl    vga_ctrl_inst
(
    .vga_clk     (clk_25m           ),  //输入工作时钟,频率25MHz
    .sys_rst_n   (rst_n         ),  //输入复位信号,低电平有效
    .pix_data    (24'hffffff          ),  //输入待显示像素信息

    .rgb_valid   (rgb_valid         ),   //VGA有效显示区域
    .pix_data_req(                  ),  //VGA数据请求信号
    .hsync       (hsync             ),  //输出行同步信号
    .vsync       (vsync             ),  //输出场同步信号
    .rgb         (vga_rgb           )   //输出像素信息
);

//------------- hdmi_ctrl_inst -------------
hdmi_ctrl   hdmi_ctrl_inst
(
    .clk_1x      (clk_25m           ),   //输入系统时钟
    .clk_5x      (clk_125m          ),   //输入5倍系统时钟
    .sys_rst_n   (rst_n             ),   //复位信号,低有效
    .rgb_blue    (wave0_b[7:3]   ),   //蓝色分量
    .rgb_green   (wave0_g[7:2]  ),   //绿色分量
    .rgb_red     (wave0_r[7:3] ),   //红色分量
    .hsync       (wave0_hs             ),   //行同步信号
    .vsync       (wave0_vs             ),   //场同步信号
    .de          (wave0_de          ),   //使能信号
    .hdmi_clk_p  (tmds_clk_p        ),
    .hdmi_clk_n  (tmds_clk_n        ),   //时钟差分信号
    .hdmi_r_p    (tmds_data_p[2]    ),
    .hdmi_r_n    (tmds_data_n[2]    ),   //红色分量差分信号
    .hdmi_g_p    (tmds_data_p[1]    ),
    .hdmi_g_n    (tmds_data_n[1]    ),   //绿色分量差分信号
    .hdmi_b_p    (tmds_data_p[0]    ),
    .hdmi_b_n    (tmds_data_n[0]    )    //蓝色分量差分信号
);
	
clk_gen clk_gen_inst
(
    .inclk0     (sys_clk        ),  //输入时钟
    .areset     (~sys_rst_n     ),  //复位信号,高有效
    .c0         (clk_25m        ),  //输出25MHz时钟
    .c1         (clk_125m       ),  //输出100MHz时钟
    .locked     (locked         )   //时钟信号有效标志
);


grid_display  grid_display_m0(
	.rst_n                 (rst_n                     ),
	.pclk                  (clk_25m                  ),
	.i_hs                  (hsync                   ),
	.i_vs                  (vsync                   ),
	.i_de                  (rgb_valid                   ),
	.i_data                (vga_rgb  ),
	.o_hs                  (grid_hs                    ),
	.o_vs                  (grid_vs                    ),
	.o_de                  (grid_de                    ),
	.o_data                ({grid_r,grid_g,grid_b}     )
);


wav_display wav_display_m0(
	.rst_n                 (rst_n                     ),
	.pclk                  (clk_25m                  ),
	.wave_color            (24'hff0000                 ),
	.dac_buf_data          (             ),
	.i_hs                  (grid_hs                    ),
	.i_vs                  (grid_vs                    ),
	.i_de                  (grid_de                    ),
	.i_data                ({grid_r,grid_g,grid_b}     ),
	.wave_select           (wave_select),
	.FREQ_CTRL   (FREQ_CTRL),
	.o_hs                  (wave0_hs                   ),
	.o_vs                  (wave0_vs                   ),
	.o_de                  (wave0_de                   ),
	.o_data                ({wave0_r,wave0_g,wave0_b}  )
);
	
endmodule
