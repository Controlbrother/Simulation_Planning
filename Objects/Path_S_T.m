function [trajectory_x,trajectory_v,trajectory_a] = Path_S_T(plan_start_s,plan_start_s_dot,plan_start_s_dot2,...
        plan_end_s,plan_end_s_dot,plan_end_dot2,recommend_T)
    %%
    trajectory_x =[];
    trajectory_v = [];
    trajectory_a = [];
    n = round(recommend_T / 0.025);
    s_init = zeros(n,1);
    s_dot_init = zeros(n,1);
    s_dot2_init = zeros(n,1);
    %% Aeq .* X = 0 X=[S1 S1' S1" ...Sn Sn' Sn" ] n���� ��ʽԼ��
    Aeq = zeros(3*n,2*n - 2);
    beq = zeros(2*n - 2,1);
    lb = ones(3*n,1);
    ub = lb;
    dt = 0.025;%
    A_sub =[1,0;
            dt,1;
            (1/3)*dt^2,(1/2)*dt;
            -1,0;
            0,-1;
            (1/6)*dt^2,dt/2];
    for i = 1:n - 1
        Aeq(3*i-2:3*i+3,2*i-1:2*i) = A_sub;
    end
    %% ����ʽԼ������ 
    %�м��һЩ�� S(λ��) �ٶ� ���ٶȵ�Լ�� ������ͨ��ͶӰ��STͼ�ϵ��ϰ��� ��̬�滮���
    for i = 1:n
       lb(3*i - 2) = -inf;% S��Լ�� ��Сֵ
       lb(3*i - 1) = 0;%�ٶȵ�Լ��  ��Сֵ
       lb(3*i) = -2;%���ٶ�Լ��  ��Сֵ
       ub(3*i - 2) = inf;
       ub(3*i - 1) = 10;
       ub(3*i) = 3;
    end
    %�����յ�Լ��
    lb(1) = plan_start_s;
    lb(2) = plan_start_s_dot;
    lb(3) = plan_start_s_dot2;
    ub(1) = lb(1);
    ub(2) = lb(2);
    ub(3) = lb(3);
    lb(3*n - 2) = plan_end_s;
    lb(3*n - 1) = plan_end_s_dot;
    lb(3*n) = plan_end_dot2;
    ub(3*n - 2) = lb(3*n - 2);
    ub(3*n - 1) = lb(3*n - 1);
    ub(3*n) = lb(3*n);
    %% ���ۺ��� ֻ��ƽ���ԵĴ��ۺ��� 
    A3 = zeros(3*n,3*n);
    A4 = zeros(3*n,n - 1);
    A4_sub =[0;0;1;0;0;-1];
    for i = 1:n - 1
       A3(3*i,3*i) = 1;%���׵���������С
       A4(3*i-2:3*i+3,i:i) = A4_sub;%���׵���������С
    end
    A3(3*n,3*n) = 1;
    H = A3 + 100*(A4*A4');
    H = 2*H;
    f = zeros(3*n,1);%ֻ��ƽ���Դ��� f=[0]����
    %% �������
    X = quadprog(H,f,[],[],Aeq',beq,lb,ub);
    for i = 1:n
       s_init(i) = X(3*i - 2);
       s_dot_init(i) = X(3*i - 1);
       s_dot2_init(i) = X(3*i);
    end
    trajectory_x =s_init;
    trajectory_v = s_dot_init;
    trajectory_a = s_dot2_init;
end


