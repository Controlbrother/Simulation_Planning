%% ����Ѳ���Ĺ켣����
clear all;
%% �Գ�״̬��Ŀ���ٶ�
%�Գ�״̬
ego_s0 = 10;
ego_v = 80/3.6;
ego_a = 2;
%�յ�״̬
end_v = 60/3.6;% Ѳ���ĳ���
end_a = 0;
end_time = 3;

%% �����ķ�ʽ
% ��ĩ��Ĳ�������ʱ��Ϊ8s���������1s������ʵ�ʵĲ��������ʱ���Ϊ��[0.01, 1, 2, 3, 4...7, 8]s��
% ÿ������ʱ�̽���6�β��������ݳ����ļӡ����ٶ����ֵ�������ǷǾ��Ҽ�ʻ�µ����ֵ���Լ����Ѳ���ٶȣ�
% �����ʱ�̳��ٵķ�Χ��Ȼ����Ȳ���4���� 
coef_ = QuarticPolynomialComputeCoefficients(ego_s0, ego_v, ego_a,  end_v, end_a,  end_time);
 [JerkMax, JerkMin] = CalcJerkRangeOfQuartic(coef_, end_time, 0);
 [AccMax, AccMin] = CalcAccRangeOfQuartic(coef_, end_time, 0);
 [VMax, VMin] = CalcVRangeOfQuartic(coef_,  end_time, 0);
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
        position_arr(i) = QuarticPolynomialEvaluate(tra_coef, 0, i*0.1);
        velocity_arr(i) = QuarticPolynomialEvaluate(tra_coef, 1, i*0.1);
        accelerate_arr(i) = QuarticPolynomialEvaluate(tra_coef, 2, i*0.1);
        jerk_arr(i) = QuarticPolynomialEvaluate(tra_coef, 3, i*0.1);    
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

%% �Ĵζ���ʽ get value from s = f(t) quintic polynomial
% order derivation
% p time of all
function value = QuarticPolynomialEvaluate(tra_coef, order, p)
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
%x0 = s0 dx0 = s_dot ddx0 = s_dotdot �Գ���ǰ��λ�� �ٶ� ���ٶ�
%dx1 ��Ŀ���ٶ� ddx1Ŀ����ٶ�
% p = ti ʱ��ϵ��
function coef = QuarticPolynomialComputeCoefficients(x0, dx0, ddx0,  dx1, ddx1,  p) 
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

%% calculate jerk max min 
% Coef �Ĵζ���ʽ��ϵ�� y = a0 + a1*x + a2*x^2 + a3*x^3 + a4*x^4 
% Tmin_ ��ζ���ʽ��ʼ��ʱ�� Tmax_ ��ζ���ʽ������ʱ��
% JerkMax, JerkMin����������С��jerk
function [JerkMax, JerkMin] = CalcJerkRangeOfQuartic(Coef, Tmax_, Tmin_)
    % ax + b = 0 jerk��ֵ�������˵�
    jerk_1 = QuarticPolynomialEvaluate(Coef, 3, Tmin_);
    jerk_2 = QuarticPolynomialEvaluate(Coef, 3, Tmax_);
    JerkMax = max(jerk_1, jerk_2);
    JerkMin = min(jerk_1, jerk_2);
end

%% calculate Acc max min and zero point t0 and t1
% Coef �Ĵζ���ʽ��ϵ�� y = a0 + a1*x + a2*x^2 + a3*x^3 + a4*x^4 
% Tmin_ �Ĵζ���ʽ��ʼ��ʱ�� Tmax_ �Ĵζ���ʽ������ʱ��
% AccMax, AccMin ����������С�ļ��ٶ�
function [AccMax, AccMin] = CalcAccRangeOfQuartic(Coef, Tmax_, Tmin_)
    % acc equation ax^2 + bx + c = 0; jerk equation ax + b = 0
    %����jerk���������Ķ˵�
    acc_1 = QuarticPolynomialEvaluate(Coef, 2, Tmin_);
    acc_2 = QuarticPolynomialEvaluate(Coef, 2, Tmax_);
    AccMax = max(acc_1, acc_2);
    AccMin = min(acc_1, acc_2);
    %����������
    a = 24.0 * Coef(5);
    b = 6.0 * Coef(4);
    if b ~= 0
        x = -b/a;
        if x >= Tmin_ && x <= Tmax_
            acc = QuarticPolynomialEvaluate(Coef, 2, x);
            AccMax = max(AccMax, acc);
            AccMin = min(AccMin, acc);
        end  
    end
end

%% calculate V max min
% Coef �Ĵζ���ʽ��ϵ�� y = a0 + a1*x + a2*x^2 + a3*x^3 + a4*x^4 
% Tmin_ �Ĵζ���ʽ��ʼ��ʱ�� Tmax_ ��ζ���ʽ������ʱ��
% VMax, VMin ����������С�ļ��ٶ�
function [VMax, VMin] = CalcVRangeOfQuartic(Coef, Tmax_, Tmin_)
    %�������˵ļ��ٶ�ֵ
    v0 = QuarticPolynomialEvaluate(Coef, 1, Tmin_);
    v1 = QuarticPolynomialEvaluate(Coef, 1, Tmax_);
    VMax = max(v0, v1);
    VMin = min(v0, v1);
    %�������ĸ���
    %jerk equation ax^2 + bx + c = 0;
    a = 12.0 * Coef(5);
    b = 6.0 * Coef(4);
    c = 2.0 * Coef(3);
    delta = b * b - 4 * a * c;
    if a == 0
        if b ~= 0
            %��һ�����
             x = -b/a;
            if x >= Tmin_ && x <= Tmax_
                v = QuarticPolynomialEvaluate(Coef, 1, x);
                VMax = max(VMax, v);
                VMin = min(VMin, v);
            end
        end
    else
        if delta > 0
            %�������
            x1 = (-b - sqrt(delta))/(2 * a);
            if x1 >= Tmin_ && x1 <= Tmax_
                v_1 = QuarticPolynomialEvaluate(Coef, 1, x1);
                VMax = max(VMax, v_1);
                VMin = min(VMin, v_1);
            end 
            x2 = (-b + sqrt(delta))/(2 * a);
            if x2 >= Tmin_ && x2 <= Tmax_
                v_2 = QuarticPolynomialEvaluate(Coef, 1, x2);
                VMax = max(VMax, v_2);
                VMin = min(VMin, v_2);
            end 
        elseif delta == 0
                %һ�����
                 x = -b / (2*a);
                if x >= Tmin_ && x <= Tmax_
                  v = QuarticPolynomialEvaluate(Coef, 1, x);
                  VMax = max(VMax, v);
                  VMin = min(VMin, v);
                end
        else
            %û�����
        end
    end
end




