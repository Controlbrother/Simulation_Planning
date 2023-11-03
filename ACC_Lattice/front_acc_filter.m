%�˲�ǰ�����ٶ�
filter_front_a_arr = [];
pre_front_a = Front_A_Arr(1);
for i = 1:length(Front_V_Arr)
    cur_front_v = Front_V_Arr(i);%��ǰ�ĳ���
    cur_front_a = Front_A_Arr(i);%��ǰ��ǰ���ļ��ٶ�
    Max_A = ALinearInter(Front_V_Range, Front_Acc_Range, cur_front_v, 6);
    Min_Dece = ALinearInter(Front_V_Range, Front_Dece_Range, cur_front_v, 6);
    limit_front_a = min(max(cur_front_a, Min_Dece), Max_A);
    filter_front_a = 0.1 * limit_front_a + 0.9 * pre_front_a;
    filter_front_a_arr(i) = filter_front_a;
    pre_front_a = filter_front_a;
end

%һ�����Բ�ֵ
% X_Arr ���뵥������
% Y_Arr
% Num X_Arr Y_Arr ����ĸ���
% x ��Ӧ��
function val = ALinearInter(X_Arr, Y_Arr, x, Num)
val = 0;
if x <= X_Arr(1)
    val = Y_Arr(1);
elseif x >= X_Arr(Num)
    val = Y_Arr(Num);
else
    for i = 1 : Num - 1
        if x >= X_Arr(i) && x < X_Arr(i+1)
            ratio = (x - X_Arr(i))/(X_Arr(i+1) - X_Arr(i));
            val = ratio * (Y_Arr(i+1) - Y_Arr(i)) + Y_Arr(i);
            break;
        end
    end
end

end


