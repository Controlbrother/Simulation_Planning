%% ����jerkԤ��
%�����˲�֮��ļ��ٶ�Ԥ��ǰ���ĳ���
%���� ǰ����λ�� �ٶ� ���ٶ� ���ǰ��tiʱ�̵�״̬ ti�ķ�Χ0-16��
%Ԥ��ǰ���������׶� 1��jerk = a 2��jerk = 0 3��jerk = -a  4��jerk = 0 �� a = 0;
front_s = 0;%wλ��
front_v = 5;%�ٶ�
front_a = -2;%�ȼ���
front_jerk = 0;%��ǰ���Ƶ�ǰ��jerkֵ
ti = 5;
if abs(front_a) <= 0.3
    %Ԥ��ǰ������ֱ���˶�
    %tiʱ�̵�״̬
    st = front_s + front_v * ti;
    vt = front_v;
    at = 0;
else
    %ǰ�������˶�
    if front_a < 0
        %���1 front_a С��0 front_jerkΪ��
        if front_jerk > 0
            t1 = (0 - front_a)/front_jerk;%
            jerk1 = front_jerk;
            %���Ǽ���front_jerk��С��front_a�Ƚϴ�t1��Ƚϴ�
            %���ǿ��t1���6��
            if t1 > 6
                jerk1 = (0 - front_a)/6;
                t1 = 6;
            end
            %���1�£�ǰ�����ٶ�Ԥ�������
            if ti <= t1
                %tiʱ�̵�״̬
                st = front_s + front_v * ti + 0.5 * front_a * ti^2 + 1/6 * jerk1 * ti^3;
                vt = min(front_v + front_a * ti + 0.5 * jerk1 * ti^2, 0);%����Ҫ���ǳ��ٿ����Ǹ������
                at = front_a + jerk1 * ti;
            else
                %�� ti > t1 ��jerk + ����
                vt = min(front_v + front_a * t1 + 0.5 * jerk1 * t1^2, 0);%����Ҫ���ǳ��ٿ����Ǹ������
                st = front_s + front_v * t1 + 0.5 * front_a * t1^2 + 1/6 * jerk1 * t1^3  + vt * (ti - t1);
                at = 0;
            end
        else
            %���2 front_a С��0 front_jerkΪ��
            %������ 1��ǰ��jerk��  2��jerk = 0 3��jerk �� 4������
            %����Ԥ���ĳһ���ٶ�Ϊ0
            t1 = 2;%�����2�� ����
            jerk1 = front_jerk;
            a1 = front_a + jerk1 * t1;%��һ�ν���ʱ�ļ��ٶ�
            v1 = front_v + front_a * t1 + 0.5 * jerk1 * t1^2; % t1����ʱ���ٶ�
            
            t2 = 1;%���� ����
            jerk2 = 0;
            a2 = a1;
            v2 = v1 + a2 * t2;
            
            jerk3 = 1.6;%�Ƚ����ʵļ���
            t3 = (0 - a2)/jerk3;
            a3 = 0;
            v3 = v2 + a2 * t3 + 0.5 * jerk3 * t3^2;
            
        end  
    else
        
    end
end

%% ����Ԥ�� 1���ȼ��� 2�����ʵ�jerk�˶� 3������
front_s = 0;%wλ��
front_v = 5;%�ٶ�
front_a = -2;%�ȼ���
front_jerk = 0;%��ǰ���Ƶ�ǰ��jerkֵ
ti = 5;
if abs(front_a) <= 0.3
    %Ԥ��ǰ������ֱ���˶�
    %tiʱ�̵�״̬
    st = front_s + front_v * ti;
    vt = front_v;
    at = 0;
else
    if front_a > 0
        %ǰ�����ٴ���0 ֱ������ jerk = 0 jerk ��
        %�����һ��jerk = 0 ʱ�� t1 = 2�� 
        t1 = 2;
        jerk1 = 0;
        a1 = front_a;
        v1 = front_v + front_a * t1;
        s1 = front_s + front_v * t1 + 0.5 * front_a * t1^2;
        %����ڶ��� jerk = -1.6 ���ʵ�����
        jerk2 = -1.6;
        t2 = abs((front_a - 0)/jerk2);
        a2 = 0;
        v2 = v1 + front_a * t2 + 0.5 * jerk2 * t2^2;
        s2 = s1 + v1 * t2 + 0.5 * a1 * t2^2 + 1/6 * jerk2 * t2^3;
        %����tiʱ��ǰ����״̬
        if ti <= t1
            st = front_s + front_v * ti + 0.5 * front_a * ti^2;
            vt = front_v + front_a * ti;
            at = front_a; 
        elseif ti <= (t1 + t2)
            %���ٶ� -> 0kph
            t = (ti - t1);
            st = s1 + v1 * t + 0.5 * a1 * t^2 + 1/6 * jerk2 * t^3;
            vt = v1 + a1 * t + 0.5 * jerk2 * t^2;
            at = a1 + jerk2 * t; 
        else
            % ti > (t1 + t2) ����
            t = ti - (t1 + t2);
            st = s2 + v2 * t;
            vt = v2;
            at = 0;
        end
    else
        % front_a < 0
        %����ǰ�����ʵļ��� front_a -> 0 jerk = 1.6
        t1 = 0; jerk1 = 0; a1 = 0; v1 = 0;
        t2 = 0; jerk2 = 0; a2 = 0; v2 = 0;
        
        jerk = 1.6;
        t_end = (0 - front_a)/jerk;
        v_end = front_v + front_a * t_end + 0.5 * jerk * t_end^2;
        if v_end < 0
            %һ��jerk = 1.6 Ȼ��һ������
            a = 0.5 * jerk;
            b = front_a;
            c = front_v ;
            [res, val] = CalcLinearEquation(a, b, c, 0, t_end);
            if (res)
                t1 = val; 
                jerk1 = 1.6; 
                a1 = 0; 
                v1 = 0;
                s1 = front_s + front_v * t1 + 0.5 * front_a * t1^2 + 1/6 * jerk1 * t1^3;
                
                t2 = 0; 
                jerk2 = 0; 
                a2 = 0; 
                v2 = 0;
            else
                %�޽� ��ֱ���ȼ��ٳ��ٵ�0
                t1 = (0 - front_a)/front_v; 
                jerk1 = 0; 
                a1 = 0; 
                v1 = 0;
                t2 = 0; 
                jerk2 = 0; 
                a2 = 0; 
                v2 = 0; 
            end
        else
            %v_end > 0
            
        end
    end
    
end


function [res, val] = CalcLinearEquation(a, b, c, min, max)
res = 0;
val = 0;
delta = b^2 - 4 * a * c;
if delta < 0
    %�޽�
    res = 0;
elseif delta == 0
    %һ���� 
    x = -b/2;
    if x >= max && x <= min
        val = x;
        res = 1;
    end
else
    x_1 = (-b + sqrt(delta))/(2 * a);
    if x_1 >= max && x_1 <= min
        val = x_1;
        res = 1;
    else
        x_2 = (-b - sqrt(delta))/(2 * a);
        if x_2 >= max && x_2 <= min
            val = x_2;
            res = 1;
        end
    end
    
end

end




























