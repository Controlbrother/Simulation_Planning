%% ����ǰ��
clear all;
%% �Գ�״̬��Ŀ���ٶ�
end_time = 5;%�೤ʱ�䵽��Ŀ��λ�� Ŀ���ٶ�
%�Գ�״̬
ego_s0 = 20;
ego_v = 60/3.6;
ego_a = -0.0;
%ǰ����״̬
front_s1 = 100;
front_v = 0/3.6;
front_a = 0;
% end time ʱ���
target_s = front_s1 + front_v * end_time - front_v * 1.5;
target_v = front_v;
target_a = 0;

%%
InitS(1) = ego_s0; InitS(2) = ego_v; InitS(3) = ego_a;
Ti = 3;
State = CalcStateOfTrajectory(InitS, Ti);

%% �����ķ�ʽ
coef_ = QuinticPolynomialComputeCoefficients(ego_s0, ego_v, ego_a,  target_s, target_v, target_a, end_time);
[JerkMax, JerkMin] = CalcJerkRangeOfTrajectory(coef_, end_time, 0);
[AccMax, AccMin] = CalcAccRangeOfTrajectory(coef_, end_time, 0);
[VMax, VMin] = CalcVRangeOfTrajectory(coef_,  end_time, 0);
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
        position_arr(i) = QuinticPolynomialEvaluate(tra_coef, 0, i*0.1);
        velocity_arr(i) = QuinticPolynomialEvaluate(tra_coef, 1, i*0.1);
        accelerate_arr(i) = QuinticPolynomialEvaluate(tra_coef, 2, i*0.1);
        jerk_arr(i) = QuinticPolynomialEvaluate(tra_coef, 3, i*0.1);    
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
function value = QuinticPolynomialEvaluate(tra_coef, order, p)
    value = 0;
    switch (order) 
        case 0 % position
            value = ((((tra_coef(6) * p + tra_coef(5)) * p + tra_coef(4)) * p + tra_coef(3)) * p + ...
                tra_coef(2)) * p + tra_coef(1);
        case 1 % velocity
            value = (((5.0 * tra_coef(6) * p + 4.0 * tra_coef(5)) * p + 3.0 * tra_coef(4)) * p + ...
                2.0 * tra_coef(3)) * p + tra_coef(2);
        case 2 % accelerate ax^3 + bx^2 + cx + d = 0;
            value = (((20.0 * tra_coef(6) * p + 12.0 * tra_coef(5)) * p) + 6.0 * tra_coef(4)) * p +...
             2.0 * tra_coef(3);
        case 3 %jerk ax^2 + bx + c = 0;
            value = (60.0 * tra_coef(6) * p + 24.0 * tra_coef(5)) * p + 6.0 * tra_coef(4);
        case 4 % djerk ax + b 
            value = 120.0 * tra_coef(6) * p + 24.0 * tra_coef(5);
        case 5 %ddjerk
            value = 120.0 * tra_coef(6);
    end
end

%% brief calculate coefficients of quintic polynomial
%  s = f(t)
% x0 start point x0 position dx0 velocity ddx0 accelerate 
% x1 end point x1 position dx1 velocity ddx1 accelerate 
% time of from start point to end point
function Coef = QuinticPolynomialComputeCoefficients(x0, dx0, ddx0,  x1, dx1, ddx1,  p) 
    Coef(1) = x0;
    Coef(2) = dx0;
    Coef(3) = ddx0 / 2.0;
  
    p2 = p * p;
    p3 = p * p2;
  
    % the direct analytical method is at least 6 times faster than using matrix inversion.
    c0 = (x1 - 0.5 * p2 * ddx0 - dx0 * p - x0) / p3;
    c1 = (dx1 - ddx0 * p - dx0) / p2;
    c2 = (ddx1 - ddx0) / p;

    Coef(4) = 0.5 * (20.0 * c0 - 8.0 * c1 + c2);
    Coef(5) = (-15.0 * c0 + 7.0 * c1 - c2) / p;
    Coef(6) = (6.0 * c0 - 3.0 * c1 + 0.5 * c2) / p2;
end


%% calculate jerk max min and zero point t0 and t1
% Coef ��ζ���ʽ��ϵ�� y = a0 + a1*x + a2*x^2 + a3*x^3 + a4*x^4 + a5*x^5
% Tmin_ ��ζ���ʽ��ʼ��ʱ�� Tmax_ ��ζ���ʽ������ʱ��
% JerkMax, JerkMin����������С��jerk
function [JerkMax, JerkMin] = CalcJerkRangeOfTrajectory(Coef, Tmax_, Tmin_)
    % jerk equation ax^2 + bx + c = 0; djerk equation ax + b = 0
    %����jerk���������Ķ˵�
    jerk_1 = QuinticPolynomialEvaluate(Coef, 3, Tmin_);
    jerk_2 = QuinticPolynomialEvaluate(Coef, 3, Tmax_);
    JerkMax = max(jerk_1, jerk_2);
    JerkMin = min(jerk_1, jerk_2);
    %����������
    a = 120.0 * Coef(6);
    b = 24.0 * Coef(5);
    if b ~= 0
        x = -b/a;
        if x >= Tmin_ && x <= Tmax_
            jerk = QuinticPolynomialEvaluate(Coef, 3, x);
            JerkMax = max(JerkMax, jerk);
            JerkMin = min(JerkMin, jerk);
        end  
    end
end

%% calculate Acc max min and zero point t0 and t1
% Coef ��ζ���ʽ��ϵ�� y = a0 + a1*x + a2*x^2 + a3*x^3 + a4*x^4 + a5*x^6
% Tmin_ ��ζ���ʽ��ʼ��ʱ�� Tmax_ ��ζ���ʽ������ʱ��
% JerkMax, JerkMin����������С�ļ��ٶ�
function [AccMax, AccMin] = CalcAccRangeOfTrajectory(Coef, Tmax_, Tmin_)
    %�������˵ļ��ٶ�ֵ
    a0 = QuinticPolynomialEvaluate(Coef, 2, Tmin_);
    a1 = QuinticPolynomialEvaluate(Coef, 2, Tmax_);
    AccMax = max(a0, a1);
    AccMin = min(a0, a1);
    %�������ĸ���
    %jerk equation ax^2 + bx + c = 0;
    a = 60.0 * Coef(6);
    b = 24.0 * Coef(5);
    c = 6 * Coef(4);
    delta = b * b - 4 * a * c;
    if a == 0
        if b ~= 0
            %��һ�����
             x = -b/a;
            if x >= Tmin_ && x <= Tmax_
                acc = QuinticPolynomialEvaluate(Coef, 2, x);
                AccMax = max(AccMax, acc);
                AccMin = min(AccMin, acc);
            end
        end
    else
        if delta > 0
            %�������
            x1 = (-b - sqrt(delta))/(2 * a);
            if x1 >= Tmin_ && x1 <= Tmax_
                acc_1 = QuinticPolynomialEvaluate(Coef, 2, x1);
                AccMax = max(AccMax, acc_1);
                AccMin = min(AccMin, acc_1);
            end 
            x2 = (-b + sqrt(delta))/(2 * a);
            if x2 >= Tmin_ && x2 <= Tmax_
                acc_2 = QuinticPolynomialEvaluate(Coef, 2, x2);
                AccMax = max(AccMax, acc_2);
                AccMin = min(AccMin, acc_2);
            end 
        elseif delta == 0
                %һ�����
                 x = -b / (2*a);
                if x >= Tmin_ && x <= Tmax_
                    acc = QuinticPolynomialEvaluate(Coef, 2, x);
                    AccMax = max(AccMax, acc);
                    AccMin = min(AccMin, acc);
                end
        else
            %û�����
        end
    end
end

%% calculate V max min
% Coef ��ζ���ʽ��ϵ�� y = a0 + a1*x + a2*x^2 + a3*x^3 + a4*x^4 + a5*x^6
% Tmin_ ��ζ���ʽ��ʼ��ʱ�� Tmax_ ��ζ���ʽ������ʱ��
% VMax, VMin ����������С�ļ��ٶ�
function [VMax, VMin] = CalcVRangeOfTrajectory(Coef, Tmax_, Tmin_)
    %�������˵ļ��ٶ�ֵ
    VMax = 0;
    VMin = 0;
    for i = Tmin_:0.05:Tmax_
        t = i;
        v0 = QuinticPolynomialEvaluate(Coef, 1, t);
        VMax = max(v0, VMax);
        VMin = min(v0, VMin);
    end
end

%% calculate s_upper s_lower v_upper v_lower
%InitS(1) λ�� InitS(2)�ٶ� InitS(3)���ٶ�
%ʱ��ti
function State = CalcStateOfTrajectory(InitS, Ti)
State = struct('s_upper',0, 's_lower',0 , 'v_upper', 0 , 'v_lower',0);
max_deceleration = -5;
max_acceleration = 2;
v_max = 30;%�Գ������
%���ٵ�0ʱ��ʱ���λ��
t_at_zero_speed = InitS(2) / max_deceleration;
s_at_zero_speed = InitS(1) + abs(InitS(2) * InitS(2) / (2.0 * max_deceleration));
% ���ٵ�v_maxʱ��
t_at_v_max = (v_max - InitS(2)) / max_acceleration;

if Ti <= t_at_v_max
    %�ȼ��� s0+ v0 * t + 0.5 * acc * t^2
    State.s_upper = InitS(1) + InitS(2) * Ti + 0.5 * max_acceleration * Ti^2;
    %v0 + at
    State.v_upper = InitS(2) + max_acceleration * Ti;
else
    %�ȼ��ټ����� s0+ v0 * t + 0.5 * acc * t^2 + v_max * (Ti - t_at_v_max)
    State.s_upper = InitS(1) + InitS(2) * t_at_v_max + 0.5 * max_acceleration * t_at_v_max^2 +  v_max * (Ti - t_at_v_max);
    State.v_upper = v_max;
end

if Ti < t_at_zero_speed
    %�ȼ���
    State.s_lower = InitS(1) + InitS(2) * Ti + 0.5 * max_deceleration * Ti^2;
    % v0 + at
    State.v_lower = InitS(2) + max_deceleration * Ti; 
else
    State.s_lower = s_at_zero_speed;
    State.v_lower = 0;
end

end


























