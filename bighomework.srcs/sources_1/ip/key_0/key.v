`timescale 1ns / 1ps



// ����ģ��
module key (
    input wire clk,       // ����ʱ�ӣ���Ƶ
    input wire button,    // �����źţ�������
    output reg debounced_button  // �����������ź�
);
    reg [31:0] delay_counter = 0;   // ��ʱ������
    reg [1:0] state = 2'b00;        // ����״̬��

    parameter DELAY_MAX = 1000000;   // ��ʱ���������ֵ�����ʹ����ʱ�ɼ���20ms

    always @(posedge clk) begin
        case (state)
            2'b00: begin
                if (button == 1) begin
                    delay_counter <= 0;   // ��⵽�������£�������ʱ������
                    state <= 2'b01;       // �л�����һ��״̬
                    end
                else  debounced_button <= 0;   // ��������ź�Ϊ0
            end
            2'b01: begin
                if (button == 1) begin
                    if (delay_counter < DELAY_MAX) begin
                        delay_counter <= delay_counter + 1;   // ��ʱ����������
                    end else begin
                        debounced_button <= 1;   // ��ʱ��������������ź�Ϊ1
                        state <= 2'b10;          // �л�����һ��״̬
                    end
                  end
                else begin
                    delay_counter <= 0;   // ����̧��������ʱ������
                    state <= 2'b00;       // �л�����ʼ״̬
                end
            end
            2'b10:if(~button) state <= 2'b00;   // ����̧���л�����ʼ״̬
                  else state <= 2'b10; 
                  
            default: begin
                state <= 2'b00;   // Ĭ�ϳ�ʼ״̬
            end
        endcase
    end
endmodule
