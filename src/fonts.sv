module fonts #(parameter X_POS = 128,Y_POS = 128)(
  input wire [10:0] hcount_in,
  input wire [9:0] vcount_in,
  input wire valid_in,
  input wire[5:0] letter_in,
  input wire[11:0] color_in,
  input wire[3:0] scale_in,
  output logic [11:0] pixel_out,
  output logic in_sprite);


logic in_sprite_buffer;
logic[10:0] relative_x;
logic[9:0] relative_y;
logic[4:0] modified_x;
logic[4:0] modified_y;

logic[11:0] G_bram[11:0];
/*pixel filling for "G"*/
assign G_bram[0] = 12'h7FF;
assign G_bram[1] = 12'hFFF;
assign G_bram[2] = 12'hF00;
assign G_bram[3] = 12'hF00;
assign G_bram[4] = 12'hF3F;
assign G_bram[5] = 12'hF3F;
assign G_bram[6] = 12'hF3F;
assign G_bram[7] = 12'hF0F;
assign G_bram[8] = 12'hF0F;
assign G_bram[9] = 12'hF0F;
assign G_bram[10] = 12'hFFF;
assign G_bram[11] = 12'h7FF;

/*pixel filling for "A"*/
logic[11:0] a_bram[11:0];
assign a_bram[0] = 12'h7FE;
assign a_bram[1] = 12'hFFF;
assign a_bram[2] = 12'hF9F;
assign a_bram[3] = 12'hF9F;
assign a_bram[4] = 12'hF9F;
assign a_bram[5] = 12'hFFF;
assign a_bram[6] = 12'hFFF;
assign a_bram[7] = 12'hF9F;
assign a_bram[8] = 12'hF9F;
assign a_bram[9] = 12'hF9F;
assign a_bram[10] = 12'hF9F;
assign a_bram[11] = 12'hF9F;

/*pixel fillin for "M"*/
logic[17:0] m_bram[11:0];
assign m_bram[0]  = 18'b111111111111111110;
assign m_bram[1]  = 18'b111111111111111111;
assign m_bram[2]  = 18'b111100011110001111;
assign m_bram[3]  = 18'b111100011110001111;
assign m_bram[4]  = 18'b111100011110001111;
assign m_bram[5]  = 18'b111100011110001111;
assign m_bram[6]  = 18'b111100011110001111;
assign m_bram[7]  = 18'b111100011110001111;
assign m_bram[8]  = 18'b111100011110001111;
assign m_bram[9]  = 18'b111100011110001111;
assign m_bram[10] = 18'b111100011110001111;
assign m_bram[11] = 18'b111100011110001111;

/*pixel filling for "E"*/
logic[11:0] E_bram[11:0];
assign E_bram[0]  = 12'h7FF;
assign E_bram[1]  = 12'hFFF;
assign E_bram[2]  = 12'hF00;
assign E_bram[3]  = 12'hF00;
assign E_bram[4]  = 12'hF00;
assign E_bram[5]  = 12'hFF0;
assign E_bram[6]  = 12'hFF0;
assign E_bram[7]  = 12'hF00;
assign E_bram[8]  = 12'hF00;
assign E_bram[9]  = 12'hF00;
assign E_bram[10] = 12'hFFF;
assign E_bram[11] = 12'h7FF;

/*pixel filling for "O"*/
logic[11:0] O_bram[11:0];
assign O_bram[0] = 12'h7FE;
assign O_bram[1] = 12'hFFF;
assign O_bram[2] = 12'hF9F;
assign O_bram[3] = 12'hF9F;
assign O_bram[4] = 12'hF9F;
assign O_bram[5] = 12'hF9F;
assign O_bram[6] = 12'hF9F;
assign O_bram[7] = 12'hF9F;
assign O_bram[8] = 12'hF9F;
assign O_bram[9] = 12'hF9F;
assign O_bram[10] = 12'hFFF;
assign O_bram[11] = 12'h7FE;

/*pixel filling for "V"*/
logic[11:0] v_bram[11:0];
assign v_bram[0] = 12'hF1F;
assign v_bram[1] = 12'hF1F;
assign v_bram[2] = 12'hF1F;
assign v_bram[3] = 12'hF1F;
assign v_bram[4] = 12'hF1F;
assign v_bram[5] = 12'hF1F;
assign v_bram[6] = 12'hF1F;
assign v_bram[7] = 12'hF1F;
assign v_bram[8] = 12'hF1F;
assign v_bram[9] = 12'hF1F;
assign v_bram[10] = 12'hFFF;
assign v_bram[11] = 12'hFFE;

/*pixel filling for "R"*/
logic[11:0] r_bram[11:0];
assign r_bram[0]  = 12'hFFE;
assign r_bram[1]  = 12'hFFF;
assign r_bram[2]  = 12'hF1F;
assign r_bram[3]  = 12'hF1F;
assign r_bram[4]  = 12'hF1F;
assign r_bram[5]  = 12'hFFE;
assign r_bram[6]  = 12'hFFE;
assign r_bram[7]  = 12'hF1F;
assign r_bram[8]  = 12'hF1F;
assign r_bram[9]  = 12'hF1F;
assign r_bram[10] = 12'hF1F;
assign r_bram[11] = 12'hF1F;

/*pixel filling for "H"*/
logic[11:0] H_bram[11:0];
assign H_bram[0]  = 12'hF0F;
assign H_bram[1]  = 12'hF0F;
assign H_bram[2]  = 12'hF0F;
assign H_bram[3]  = 12'hF0F;
assign H_bram[4]  = 12'hF0F;
assign H_bram[5]  = 12'hFFF;
assign H_bram[6]  = 12'hFFF;
assign H_bram[7]  = 12'hF0F;
assign H_bram[8]  = 12'hF0F;
assign H_bram[9]  = 12'hF0F;
assign H_bram[10] = 12'hF0F;
assign H_bram[11] = 12'hF0F;

/*pixel filling for "P"*/
logic[11:0] p_bram[11:0];
assign p_bram[0]  = 12'hFFC;
assign p_bram[1]  = 12'hFFE;
assign p_bram[2]  = 12'hF07;
assign p_bram[3]  = 12'hF07;
assign p_bram[4]  = 12'hF07;
assign p_bram[5]  = 12'hFFE;
assign p_bram[6]  = 12'hFFC;
assign p_bram[7]  = 12'hF00;
assign p_bram[8]  = 12'hF00;
assign p_bram[9]  = 12'hF00;
assign p_bram[10] = 12'hF00;
assign p_bram[11] = 12'hF00;

/*pixel filling for "T"*/
logic[7:0] T_bram[11:0];
assign T_bram[0]  = 8'hFF;
assign T_bram[1]  = 8'hFF;
assign T_bram[2]  = 8'h18;
assign T_bram[3]  = 8'h18;
assign T_bram[4]  = 8'h18;
assign T_bram[5]  = 8'h18;
assign T_bram[6]  = 8'h18;
assign T_bram[7]  = 8'h18;
assign T_bram[8]  = 8'h18;
assign T_bram[9]  = 8'h18;
assign T_bram[10] = 8'h18;
assign T_bram[11] = 8'h18;

/*pixel filling for "L"*/
logic[7:0] L_bram[11:0];
assign L_bram[0]  = 8'hC0;
assign L_bram[1]  = 8'hC0;
assign L_bram[2]  = 8'hC0;
assign L_bram[3]  = 8'hC0;
assign L_bram[4]  = 8'hC0;
assign L_bram[5]  = 8'hC0;
assign L_bram[6]  = 8'hC0;
assign L_bram[7]  = 8'hC0;
assign L_bram[8]  = 8'hC0;
assign L_bram[9]  = 8'hC0;
assign L_bram[10] = 8'hC0;
assign L_bram[11] = 8'hFF;

/*pixel filling for "h"*/
logic [7:0] h_bram[11:0];
assign h_bram[0]  = 8'hC0;
assign h_bram[1]  = 8'hC0;
assign h_bram[2]  = 8'hC0;
assign h_bram[3]  = 8'hC0;
assign h_bram[4]  = 8'hFC;
assign h_bram[5]  = 8'hFE;
assign h_bram[6]  = 8'hC3;
assign h_bram[7]  = 8'hC3;
assign h_bram[8]  = 8'hC3;
assign h_bram[9]  = 8'hC3;
assign h_bram[10] = 8'hC3;
assign h_bram[11] = 8'hC3;

/*pixel filling for "e"*/
logic [7:0] e_bram[7:0];
assign e_bram[0]  = 8'h7E;
assign e_bram[1]  = 8'hFF;
assign e_bram[2]  = 8'hC1;
assign e_bram[3]  = 8'hFF;
assign e_bram[4]  = 8'hC0;
assign e_bram[5]  = 8'hC3;
assign e_bram[6]  = 8'hFF;
assign e_bram[7]  = 8'h7E;

/*pixel filling for "w"*/
logic [8:0] w_bram[7:0];
assign w_bram[0]  = 9'b110000011;
assign w_bram[1]  = 9'b110010011;
assign w_bram[2]  = 9'b110010011;
assign w_bram[3]  = 9'b110010011;
assign w_bram[4]  = 9'b110010011;
assign w_bram[5]  = 9'b011101110;
assign w_bram[6]  = 9'b011101110;
assign w_bram[7]  = 9'b011101110;

/*pixel flilling for "i"*/
logic[7:0] i_bram[11:0];
assign i_bram[0]  = 8'h18;
assign i_bram[1]  = 8'h18;
assign i_bram[2]  = 8'h00;
assign i_bram[3]  = 8'hF8;
assign i_bram[4]  = 8'h18;
assign i_bram[5]  = 8'h18;
assign i_bram[6]  = 8'h18;
assign i_bram[7]  = 8'h18;
assign i_bram[8]  = 8'h18;
assign i_bram[9]  = 8'h18;
assign i_bram[10] = 8'h18;
assign i_bram[11] = 8'hFF;

/*pixel filling for "n"*/
logic[7:0] n_bram[7:0];
assign n_bram[0]  = 8'hFE;
assign n_bram[1]  = 8'hFE;
assign n_bram[2]  = 8'hC3;
assign n_bram[3]  = 8'hC3;
assign n_bram[4]  = 8'hC3;
assign n_bram[5]  = 8'hC3;
assign n_bram[6]  = 8'hC3;
assign n_bram[7]  = 8'hC3;

/*pixel filling for "d"*/
logic [7:0] d_bram[11:0];
assign d_bram[0]  = 8'h06;
assign d_bram[1]  = 8'h06;
assign d_bram[2]  = 8'h06;
assign d_bram[3]  = 8'h06;
assign d_bram[4]  = 8'h7F;
assign d_bram[5]  = 8'hC3;
assign d_bram[6] = 8'hC3;
assign d_bram[7] = 8'hC3;
assign d_bram[8]  = 8'hC3;
assign d_bram[9]  = 8'hC3;
assign d_bram[10] = 8'hC3;
assign d_bram[11] = 8'h7F;

/*pixel filling for "s"*/
logic [7:0] s_bram[7:0];
assign s_bram[0]  = 8'h7E;
assign s_bram[1]  = 8'hFF;
assign s_bram[2]  = 8'hE0;
assign s_bram[3]  = 8'h7E;
assign s_bram[4]  = 8'h07;
assign s_bram[5]  = 8'h07;
assign s_bram[6]  = 8'hE6;
assign s_bram[7]  = 8'h3C;

/*pixel filling for "o"*/
logic [7:0] o_bram[7:0];
assign o_bram[0]  = 8'h7C;
assign o_bram[1]  = 8'hFE;
assign o_bram[2]  = 8'hC6;
assign o_bram[3]  = 8'hC6;
assign o_bram[4]  = 8'hC6;
assign o_bram[5]  = 8'hC6;
assign o_bram[6]  = 8'hFE;
assign o_bram[7]  = 8'h7C;

/*pixel filling for "l"*/
logic [7:0] l_bram[11:0];
assign l_bram[0]  = 8'hF0;
assign l_bram[1]  = 8'h30;
assign l_bram[2]  = 8'h30;
assign l_bram[3]  = 8'h30;
assign l_bram[4]  = 8'h30;
assign l_bram[5]  = 8'h30;
assign l_bram[6]  = 8'h30;
assign l_bram[7]  = 8'h30;
assign l_bram[8]  = 8'h30;
assign l_bram[9]  = 8'h30;
assign l_bram[10] = 8'h30;
assign l_bram[11]  = 8'hFC;

/*pixel filling for "g"*/
logic [7:0] g_bram[11:0];
assign g_bram[0]   = 8'h7F;
assign g_bram[1]   = 8'hC3;
assign g_bram[2]   = 8'hC3;
assign g_bram[3]   = 8'hC3;
assign g_bram[4]   = 8'hC3;
assign g_bram[5]   = 8'hC3;
assign g_bram[6]   = 8'hC3;
assign g_bram[7]   = 8'h7F;
assign g_bram[8]   = 8'h07;
assign g_bram[9]   = 8'h07;
assign g_bram[10]  = 8'hE6;
assign g_bram[11]  = 8'h3E;

/*pixel filling for "y"*/
logic [7:0] y_bram[11:0];
assign y_bram[0]   = 8'hC3;
assign y_bram[1]   = 8'hC3;
assign y_bram[2]   = 8'hC3;
assign y_bram[3]   = 8'hC3;
assign y_bram[4]   = 8'hC3;
assign y_bram[5]   = 8'hC3;
assign y_bram[6]   = 8'h7F;
assign y_bram[7]   = 8'h03;
assign y_bram[8]   = 8'h03;
assign y_bram[9]   = 8'h03;
assign y_bram[10]  = 8'h7E;
assign y_bram[11]  = 8'h3C;

/*pixel filling for "1"*/
logic[11:0] one_bram[11:0];
assign one_bram[0]  = 12'h0FF;
assign one_bram[1]  = 12'h0FF;
assign one_bram[2]  = 12'h03F;
assign one_bram[3]  = 12'h03F;
assign one_bram[4]  = 12'h03F;
assign one_bram[5]  = 12'h03F;
assign one_bram[6]  = 12'h03F;
assign one_bram[7]  = 12'h03F;
assign one_bram[8]  = 12'h03F;
assign one_bram[9]  = 12'h03F;
assign one_bram[10] = 12'h03F;
assign one_bram[11] = 12'h03F;

/*pixel filling for "2"*/
logic[11:0] two_bram[11:0];
assign two_bram[0] = 12'hFFC;
assign two_bram[1] = 12'hFFC;
assign two_bram[2] = 12'h03C;
assign two_bram[3] = 12'h03C;
assign two_bram[4] = 12'h03C;
assign two_bram[5] = 12'hFFC;
assign two_bram[6] = 12'hFFC;
assign two_bram[7] = 12'hF00;
assign two_bram[8] = 12'hF00;
assign two_bram[9] = 12'hF00;
assign two_bram[10] = 12'hFFE;
assign two_bram[11] = 12'hFFE;

/*pixel filling for "3"*/

logic[11:0] three_bram[11:0];
assign three_bram[0] = 12'hFF0;
assign three_bram[1] = 12'hFF0;
assign three_bram[2] = 12'h030;
assign three_bram[3] = 12'h030;
assign three_bram[4] = 12'h3FE;
assign three_bram[5] = 12'h3FE;
assign three_bram[6] = 12'h3FE;
assign three_bram[7] = 12'h3FE;
assign three_bram[8] = 12'h03C;
assign three_bram[9] = 12'h03C;
assign three_bram[10] = 12'hFFC;
assign three_bram[11] = 12'hFFC;

/*pixel filling for "4"*/
logic[11:0] four_bram[11:0];
assign four_bram[0] = 12'h03C;
assign four_bram[1] = 12'h03C;
assign four_bram[2] = 12'hE3C;
assign four_bram[3] = 12'hE3C;
assign four_bram[4] = 12'hE3C;
assign four_bram[5] = 12'hE3C;
assign four_bram[6] = 12'hFFC;
assign four_bram[7] = 12'hFFC;
assign four_bram[8] = 12'h03E;
assign four_bram[9] = 12'h03E;
assign four_bram[10] = 12'h03E;
assign four_bram[11] = 12'h03E;

/*pixel filling for "5"*/
logic[11:0] five_bram[11:0];
assign five_bram[0] = 12'hFFF;
assign five_bram[1] = 12'hFFF;
assign five_bram[2] = 12'hFC0;
assign five_bram[3] = 12'hFC0;
assign five_bram[4] = 12'hFFF;
assign five_bram[5] = 12'hFFF;
assign five_bram[6] = 12'hFFF;
assign five_bram[7] = 12'h07F;
assign five_bram[8] = 12'h07F;
assign five_bram[9] = 12'h07F;
assign five_bram[10] = 12'hFFC;
assign five_bram[11] = 12'hFFC;

/*pixel filling for "6"*/
logic[11:0] six_bram[11:0];
assign six_bram[0] = 12'hFE0;
assign six_bram[1] = 12'hFE0;
assign six_bram[2] = 12'hF00;
assign six_bram[3] = 12'hF00;
assign six_bram[4] = 12'hFFC;
assign six_bram[5] = 12'hFFC;
assign six_bram[6] = 12'hFFC;
assign six_bram[7] = 12'hC3C;
assign six_bram[8] = 12'hC3C;
assign six_bram[9] = 12'hC3C;
assign six_bram[10] = 12'hFFC;
assign six_bram[11] = 12'hFFC;

/*pixel filling for "7"*/
logic[11:0] seven_bram[11:0];
assign seven_bram[0] = 12'hFFC;
assign seven_bram[1] = 12'hFFC;
assign seven_bram[2] = 12'hFFC;
assign seven_bram[3] = 12'hE3C;
assign seven_bram[4] = 12'hE3C;
assign seven_bram[5] = 12'hE3C;
assign seven_bram[6] = 12'h03C;
assign seven_bram[7] = 12'h03C;
assign seven_bram[8] = 12'h03C;
assign seven_bram[9] = 12'h03C;
assign seven_bram[10] = 12'h03C;
assign seven_bram[11] = 12'h03C;

/*pixel filling for "8"*/
logic[11:0] eight_bram[11:0];
assign eight_bram[0]  = 12'h7F8;
assign eight_bram[1]  = 12'hFFC;
assign eight_bram[2]  = 12'hE1C;
assign eight_bram[3]  = 12'hE1C;
assign eight_bram[4]  = 12'hFFC;
assign eight_bram[5]  = 12'h7F8;
assign eight_bram[6]  = 12'hFFC;
assign eight_bram[7]  = 12'hE1C;
assign eight_bram[8]  = 12'hE1C;
assign eight_bram[9]  = 12'hE1C;
assign eight_bram[10] = 12'hFFC;
assign eight_bram[11] = 12'h7F8;

/*pixel filling for "9"*/
logic[11:0] nine_bram[11:0];
assign nine_bram[0]  = 12'hFFC;
assign nine_bram[1]  = 12'hFFC;
assign nine_bram[2]  = 12'hC1C;
assign nine_bram[3]  = 12'hC1C;
assign nine_bram[4]  = 12'hC1C;
assign nine_bram[5]  = 12'hC1C;
assign nine_bram[6]  = 12'hFFC;
assign nine_bram[7]  = 12'hFFC;
assign nine_bram[8]  = 12'h03C;
assign nine_bram[9]  = 12'h03C;
assign nine_bram[10] = 12'hFFC;
assign nine_bram[11] = 12'hFFC;

/*pixel filling for "0"*/
logic[11:0] zero_bram[11:0];
assign zero_bram[0]  = 12'hFFC;
assign zero_bram[1]  = 12'hFFC;
assign zero_bram[2]  = 12'hFFC;
assign zero_bram[3]  = 12'hE1C;
assign zero_bram[4]  = 12'hE1C;
assign zero_bram[5]  = 12'hE1C;
assign zero_bram[6]  = 12'hE1C;
assign zero_bram[7]  = 12'hE1C;
assign zero_bram[8]  = 12'hE1C;
assign zero_bram[9]  = 12'hFFC;
assign zero_bram[10] = 12'hFFC;
assign zero_bram[11] = 12'hFFC;

/*pixel filling for "S"*/
logic[11:0] S_bram[11:0];
assign S_bram[0]  = 12'h3FC;
assign S_bram[1]  = 12'h7FE;
assign S_bram[2]  = 12'hFFF;
assign S_bram[3]  = 12'hE00;
assign S_bram[4]  = 12'hE00;
assign S_bram[5]  = 12'hFFF;
assign S_bram[6]  = 12'hFFF;
assign S_bram[7]  = 12'h00F;
assign S_bram[8]  = 12'h00F;
assign S_bram[9]  = 12'hFFF;
assign S_bram[10] = 12'h7FE;
assign S_bram[11] = 12'h3FC;

/*pixel filling for "U"*/
logic[11:0] U_bram[11:0];
assign U_bram[0]  = 12'hF0F;
assign U_bram[1]  = 12'hF0F;
assign U_bram[2]  = 12'hF0F;
assign U_bram[3]  = 12'hF0F;
assign U_bram[4]  = 12'hF0F;
assign U_bram[5]  = 12'hF0F;
assign U_bram[6]  = 12'hF0F;
assign U_bram[7]  = 12'hF0F;
assign U_bram[8]  = 12'hFFF;
assign U_bram[9]  = 12'hFFF;
assign U_bram[10] = 12'hFFF;
assign U_bram[11] = 12'h7FE;

/*pixel filling for "N"*/
logic[11:0] N_bram[11:0];
assign N_bram[0]  = 12'hFC7;
assign N_bram[1]  = 12'hFC7;
assign N_bram[2]  = 12'hFC7;
assign N_bram[3]  = 12'hFC7;
assign N_bram[4]  = 12'hFC7;
assign N_bram[5]  = 12'hFFF;
assign N_bram[6]  = 12'hFFF;
assign N_bram[7]  = 12'hE3F;
assign N_bram[8]  = 12'hE3F;
assign N_bram[9]  = 12'hE3F;
assign N_bram[10] = 12'hE3F;
assign N_bram[11] = 12'hE3F;

/*pixel filling for "t"*/
logic [7:0] t_bram[11:0];
assign t_bram[0]  = 8'h18;
assign t_bram[1]  = 8'h18;
assign t_bram[2]  = 8'hFF;
assign t_bram[3]  = 8'h18;
assign t_bram[4]  = 8'h18;
assign t_bram[5]  = 8'h18;
assign t_bram[6]  = 8'h18;
assign t_bram[7]  = 8'h18;
assign t_bram[8]  = 8'h18;
assign t_bram[9]  = 8'h18;
assign t_bram[10] = 8'h1F;
assign t_bram[11] = 8'h07;

/*pixel filling for "/"*/
logic[11:0] slash_bram[11:0];
assign slash_bram[0]  = 12'h007;
assign slash_bram[1]  = 12'h007;
assign slash_bram[2]  = 12'h007;
assign slash_bram[3]  = 12'h03F;
assign slash_bram[4]  = 12'h03F;
assign slash_bram[5]  = 12'h03F;
assign slash_bram[6]  = 12'h1C0;
assign slash_bram[7]  = 12'h1C0;
assign slash_bram[8]  = 12'h1C0;
assign slash_bram[9]  = 12'hE00;
assign slash_bram[10] = 12'hE00;
assign slash_bram[11] = 12'hE00;

/*pixel filling for "F"*/
logic[11:0] F_bram[11:0];
assign F_bram[0]  = 12'hFF0;
assign F_bram[1]  = 12'hFF0;
assign F_bram[2]  = 12'hC00;
assign F_bram[3]  = 12'hC00;
assign F_bram[4]  = 12'hC00;
assign F_bram[5]  = 12'hFE0;
assign F_bram[6]  = 12'hFE0;
assign F_bram[7]  = 12'hC00;
assign F_bram[8]  = 12'hC00;
assign F_bram[9]  = 12'hC00;
assign F_bram[10] = 12'hC00;
assign F_bram[11] = 12'hC00;

/*pixel filling for "I"*/
logic[11:0] I_bram[11:0];
assign I_bram[0]  = 12'hFF0;
assign I_bram[1]  = 12'hFF0;
assign I_bram[2]  = 12'h180;
assign I_bram[3]  = 12'h180;
assign I_bram[4]  = 12'h180;
assign I_bram[5]  = 12'h180;
assign I_bram[6]  = 12'h180;
assign I_bram[7]  = 12'h180;
assign I_bram[8]  = 12'h180;
assign I_bram[9]  = 12'h180;
assign I_bram[10] = 12'hFF0;
assign I_bram[11] = 12'hFF0;

/*pixel filling for "C"*/
logic[11:0] C_bram[11:0];
assign C_bram[0]  = 12'h3FC;
assign C_bram[1]  = 12'h7FE;
assign C_bram[2]  = 12'hFFF;
assign C_bram[3]  = 12'hC07;
assign C_bram[4]  = 12'hC00;
assign C_bram[5]  = 12'hC00;
assign C_bram[6]  = 12'hC00;
assign C_bram[7]  = 12'hC00;
assign C_bram[8]  = 12'hC07;
assign C_bram[9]  = 12'hFFF;
assign C_bram[10] = 12'h7FE;
assign C_bram[11] = 12'h3FC;

/*pixel filling for "Y"*/
logic[11:0] Y_bram[11:0];
assign Y_bram[0]  = 12'hC30;
assign Y_bram[1]  = 12'hC30;
assign Y_bram[2]  = 12'hC30;
assign Y_bram[3]  = 12'hC30;
assign Y_bram[4]  = 12'hC30;
assign Y_bram[5]  = 12'hFF0;
assign Y_bram[6]  = 12'h7E0;
assign Y_bram[7]  = 12'h3C0;
assign Y_bram[8]  = 12'h3C0;
assign Y_bram[9]  = 12'h3C0;
assign Y_bram[10] = 12'h3C0;
assign Y_bram[11] = 12'h3C0;



/*
* 000001 = G
* 000010 = A
* 000011 = M
* 000100 = E
* 000101 = O
* 000110 = V
* 000111 = R
* 001000 = H
* 001001 = P
* 001010 = T
* 001011 = L
* 001100 = h
* 001101 = e
* 001110 = w
* 001111 = i
* 010000 = n
* 010001 = d
* 010010 = s
* 010011 = o
* 010100 = l
* 010101 = g
* 010110 = y
* 010111 = 0
* 011000 = 1
* 011001 = 2
* 011010 = 3
* 011011 = 4
* 011100 = 5
* 011101 = 6
* 011110 = 7
* 011111 = 8
* 100000 = 9
* 100001 = S
* 100010 = U
* 100011 = N
* 100100 = t
* 100101 = slash
* 100110 = F
* 100111 = I
* 101000 = C
* 101001 = Y
*/
always_comb begin
	case(letter_in)
		6'b000001:begin
			relative_x <= hcount_in - X_POS;
                	relative_y <= vcount_in - Y_POS;
                	if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                        	modified_x = 11 - (relative_x >> scale_in);
                        	modified_y = relative_y >> scale_in;
                        	in_sprite_buffer = G_bram[modified_y][modified_x];
                        	//in_sprite_buffer = pixel_bram[3][0];
                	end
                	else
                        	in_sprite_buffer = 0;
		end
		6'b000010:begin
			relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = a_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
		end
		6'b000011:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 18*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 17 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = m_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b000100:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = E_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b000101:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = O_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b000110:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = v_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b000111:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = r_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b001000:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = H_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b001001:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = p_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b001010:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 8*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 7 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = T_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b001011:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 8*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 7 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = L_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b001100:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 8*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 7 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = h_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b001101:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 8*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 8*(2**scale_in)-1)begin
                                modified_x = 7 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = e_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b001110:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 9*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 8*(2**scale_in)-1)begin
                                modified_x = 8 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = w_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b001111:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 8*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 7 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = i_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b010000:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 8*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 8*(2**scale_in)-1)begin
                                modified_x = 7 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = n_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b010001:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 8*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 7 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = d_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b010010:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 8*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 8*(2**scale_in)-1)begin
                                modified_x = 7 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = s_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b010011:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 8*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 8*(2**scale_in)-1)begin
                                modified_x = 7 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = o_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b010100:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 8*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 7 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = l_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b010101:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 8*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 7 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = g_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b010110:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 8*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 7 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = y_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b010111:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = zero_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b011000:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = one_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b011001:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = two_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b011010:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = three_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b011011:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = four_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b011100:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = five_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b011101:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = six_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b011110:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = seven_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b011111:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = eight_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b100000:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = nine_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b100001:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = S_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b100010:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = U_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b100011:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = N_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b100100:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 8*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 7 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = t_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b100101:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = slash_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b100110:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = F_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b100111:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = I_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b101000:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = C_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		6'b101001:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = Y_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end



	endcase

end
assign in_sprite = in_sprite_buffer;
assign pixel_out = (valid_in && in_sprite_buffer) ? color_in : 0;

endmodule
