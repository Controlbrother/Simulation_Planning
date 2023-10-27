%% ����Ѳ���Ĺ켣����

%% �Գ�״̬��Ŀ���ٶ�
%�Գ�״̬
ego_s0 = 10;
ego_v = 78/3.6;
ego_a = 0;
%�յ�״̬
end_v = 80/3.6;% Ѳ���ĳ���
end_a = 0;
end_time = 3;

%% �����ķ�ʽ
% ��ĩ��Ĳ�������ʱ��Ϊ8s���������1s������ʵ�ʵĲ��������ʱ���Ϊ��[0.01, 1, 2, 3, 4...7, 8]s��
% ÿ������ʱ�̽���6�β��������ݳ����ļӡ����ٶ����ֵ�������ǷǾ��Ҽ�ʻ�µ����ֵ���Լ����Ѳ���ٶȣ�
% �����ʱ�̳��ٵķ�Χ��Ȼ����Ȳ���4���� 
coef_ = ComputeCoefficients(ego_s0, ego_v, ego_a,  end_v, end_a,  end_time);

%% figure trajectory
tra_result = true;
tra_time = end_time;
tra_coef = coef_;
if tra_result == true
    time_arr = [];
    position_arr = [];
    velocity_arr = [];
    accelerate_arr = [];
    jerk_arr = [];
    tra_num = tra_time/0.1; % 0.1 get one point
    for i = 1:tra_num
        time_arr(i) = i*0.1;
        position_arr(i) = Evaluate(tra_coef, 0, i*0.1);
        velocity_arr(i) = Evaluate(tra_coef, 1, i*0.1);
        accelerate_arr(i) = Evaluate(tra_coef, 2, i*0.1);
        jerk_arr(i) = Evaluate(tra_coef, 3, i*0.1);    
    end
    cut_in_s = position_arr(tra_num);
    figure(1);
    plot(time_arr,position_arr);
    title('����S');
    figure(2);
    plot(time_arr,velocity_arr);
    title('�ٶ�V');
    figure(3);
    plot(time_arr,accelerate_arr);
    title('���ٶ�A');
    figure(4);
    plot(time_arr,jerk_arr);
    title('�����jerk');
end

%% get value from s = f(t) quintic polynomial
% order derivation
% p time of all
function value = Evaluate(tra_coef, order, p)
    value = 0;
    switch (order) 
        case 0 % position
            value = (((tra_coef(5) * p + tra_coef(4)) * p + tra_coef(3)) * p + ...
                tra_coef(2)) * p + tra_coef(1);
        case 1 % velocity
            value = ((4.0 * tra_coef(5) * p + 3.0 * tra_coef(4)) * p + ...
                2.0 * tra_coef(3)) * p + tra_coef(2);
        case 2 % accelerate
            value = (( 12.0 * tra_coef(5)) * p + 6.0 * tra_coef(4)) * p + ...
             2.0 * tra_coef(3);
        case 3 %jerk
            value =  24.0 * tra_coef(5) * p + 6.0 * tra_coef(4);
        case 4 % djerk
            value = 24.0 * tra_coef(5);
    end
end

%�Ĵζ���ʽ����ϵ��
%x0 = s0 dx0 = s_dot ddx0 = s_dotdot
%dx1 ��Ŀ���ٶ� ddx1Ŀ����ٶ�
% p = ti ʱ��ϵ��
function coef = ComputeCoefficients(x0, dx0, ddx0,  dx1, ddx1,  p) 
    coef(1) = x0;
    coef(2) = dx0;
    coef(3) = ddx0 / 2.0;
    p2 = p * p;
    p3 = p * p2;
    b0 = dx1 - ddx0 * p - dx0;
    b1 = ddx1 - ddx0;
    coef(4) = (3 * b0 - b1 * p) / (3 * p2);
    coef(5) = (-2 * b0 + b1 * p) / (4 * p3);
end










