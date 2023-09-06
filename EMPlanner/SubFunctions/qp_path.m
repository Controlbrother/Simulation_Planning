function [qp_path_s, qp_path_l, qp_path_dl, qp_path_ddl] = qp_path(...
    ego_plan_start_s, ego_plan_start_l, ego_plan_start_dl, ego_plan_start_ddl,...
    l_max, l_min)

%�滮�����
plan_start_s = ego_plan_start_s;
plan_start_l = ego_plan_start_l;
plan_start_dl = ego_plan_start_dl;
plan_start_ddl = ego_plan_start_ddl;
%% ·�����ι滮
% 0.5*x'Hx + f'*x = min
% subject to A*x <= b
%            Aeq*x = beq
%            lb <= x <= ub;
% ���룺l_min l_max ���͹�ռ�
%       w_cost_l �ο��ߴ���
%       w_cost_dl ddl dddl �⻬�Դ���
%       w_cost_centre ͹�ռ��������
%       w_cost_end_l dl dd1 �յ��״̬���� (ϣ��path���յ�״̬Ϊ(0,0,0))
%       host_d1,d2 host���ĵ�ǰ����ľ���
%       host_w host�Ŀ��
%       plan_start_l,dl,ddl �滮���
% ��� qp_path_l dl ddl ���ι滮���������
%�ͷ����� w_cost_l ���������� 
%�ͷ����� w_cost_centre ����͹�ռ�
%����w_cost_dl �����ٶ�
w_cost_l = 2; w_cost_dl = 25000; w_cost_ddl = 50;w_cost_dddl = 20;
w_cost_centre = 1500;
w_cost_end_l = 15;w_cost_end_dl = 15;w_cost_end_ddl = 15;
host_d1 = 2; host_d2 = 2; host_w = 1.6;
delta_dl_max = 2; delta_ddl_max = 1;

% ���Ż��ı���������
n = 60;
% �����ʼ��
qp_path_l = zeros(n,1);
qp_path_dl = zeros(n,1);
qp_path_ddl = zeros(n,1);
qp_path_s = zeros(n,1);
% H_L H_DL H_DDL H_DDDL Aeq beq A b ��ʼ��
H_L = zeros(3*n, 3*n);
H_DL = zeros(3*n, 3*n);
H_DDL = zeros(3*n, 3*n);
H_DDDL = zeros(n-1, 3*n);
H_CENTRE = zeros(3*n, 3*n);
H_L_END = zeros(3*n, 3*n);
H_DL_END = zeros(3*n, 3*n);
H_DDL_END = zeros(3*n, 3*n);
Aeq = zeros(2*n-2, 3*n);%�����Ե�ʽԼ��
beq = zeros(2*n-2, 1);
A = zeros(8*n, 3*n);%͹�ռ��Լ��
b = zeros(8*n, 1);%
% ���£����� dl(i+1) - dl(i) ddl(i+1) - ddl(i) ��Լ��
A_dl_minus = zeros(n - 1,3*n);
b_dl_minus = zeros(n - 1,1);
A_ddl_minus = zeros(n - 1,3*n);
b_ddl_minus = zeros(n - 1,1);
for i = 1:n-1
    row = i;
    col = 3*i - 2;
    A_dl_minus(row,col:col+5) = [0 -1 0 0 1 0];
    b_dl_minus(row) = delta_dl_max;
    A_ddl_minus(row,col:col+5) = [0 0 -1 0 0 1];
    b_ddl_minus(row) = delta_ddl_max;
end
% -max < a*x < max => ax < max && -ax < -(-max)
A_minus = [A_dl_minus;
          -A_dl_minus;
           A_ddl_minus;
          -A_ddl_minus];%��ʱû��
      
b_minus = [b_dl_minus;
           b_dl_minus;
          b_ddl_minus;
          b_ddl_minus]; %��ʱҲû��

%  �������յ�״̬
end_l_desire = 0;
end_dl_desire = 0;
end_ddl_desire = 0;

% Aeq_sub ������Լ��
ds = 1;%������ default 3��
% plan_start_s = 0 n = 10
%[0 3 6 9 12 15 ... 57]
for i = 1:n
    qp_path_s(i) = plan_start_s + (i-1)*ds;
end

Aeq_sub = [1 ds ds^2/3 -1 0 ds^2/6;
           0 1  ds/2   0 -1 ds/2];%2��6�� �������Ӿ���
% A_sub;
d1 = host_d1;%�Գ������ĵ�ǰ��
d2 = host_d2;%�Գ����ĵ�����
w = host_w;%�Գ��Ŀ�
A_sub = [1  d1 0;
         1  d1 0;
         1 -d2 0;
         1 -d2 0;
        -1 -d1 0;
        -1 -d1 0;
        -1  d2 0;
        -1  d2 0];%8��3�� �Գ��ĸ��ǵ�Լ��
    
% ����Aeq 38��60��
for i = 1:n-1
    % ����ֿ�������Ͻǵ��к���
    row = 2*i - 1;%[1 3 5 7 ...37]
    col = 3*i - 2;%[1 4 7 ... ]
    Aeq(row:row + 1,col:col + 5) = Aeq_sub;
    %Aeq_sub2��6��
    %row:row + 1 �� col:col + 5 = 1��2����1��6��
    %3��4����4��9�� ... 37��38����55�е�60��
end
% ����A -> 160*60 ͹�ռ�Ĳ���ʽԼ��
%A_sub 8��3�� 20����
for i = 2:n
    row = 8*i - 7;%[1 9 ... ]
    col = 3*i - 2;%[1 4 ... ]
    A(row:row + 7,col:col + 2) = A_sub;
    %��һ���Գ��ĸ��ǵ��͹�ռ�Լ�����Ӿ������ 1��8����1��3��
    %��һ���Գ��ĸ��ǵ��͹�ռ�Լ�����Ӿ������ 9��16����4��6�� ...
end

% ��Ƶ���õ���(s(i) - d2,s(i) + d1)�ķ������ڱ��أ�������������
% ֻҪ�ҵ��ĸ��ǵ�����Ӧ��l_min l_max ����
% ����������������������������
%    [    .   ]<- 
%    [        ]
% ��������������������������
%�Գ����ĵ�ǰ�����Ķ���2�� ds1�� ���front_index = 2 back_index = 2
front_index = ceil(d1/ds); % d1��ͷλ�� d2��βλ��
back_index = ceil(d2/ds);  % ceil����ȡ�� ceil(3) = 3 ceil(3.1) = 4
% ����b �Գ��ĸ��ǵ��͹�ռ�Լ�� A*X < b
for i = 2:n
    % ��ǰ ��ǰ��index = min(i + front_index,60)
    % ��� �Һ��index = max(i - back_index,1)
    % l_min l_max ����60����
    % l��max��min��һ��һ����ds������һ������˲���[1 4 7 ]
    % dp_s �ӹ滮�������ǰ80�ף� n=60,��˲��ᳬ
    index1 = i + front_index + 1;
    index2 = max(i - back_index + 1,1);
    b(8*i - 7:8*i,1) = [l_max(index1) - w/2; %l_max ��߽�
                        l_max(index1) + w/2;
                        l_max(index2) - w/2;
                        l_max(index2) + w/2;
                       -l_min(index1) + w/2; %l_min �ұ߽�
                       -l_min(index1) - w/2;
                       -l_min(index2) + w/2;
                       -l_min(index2) - w/2;];
end

%���� lb ub ��Ҫ�ǶԹ滮�����Լ��
% lb < x < ub
lb = ones(3*n,1)*-inf;
ub = ones(3*n,1)*inf;
lb(1) = plan_start_l;%����Լ��
lb(2) = plan_start_dl;
lb(3) = plan_start_ddl;
ub(1) = lb(1);%����ʽԼ��
ub(2) = lb(2);
ub(3) = lb(3);
for i = 2:n
    lb(3*i - 1) = - 0.2; %Լ�� l'
    ub(3*i - 1) = 0.2;
    lb(3*i) = -0.02; %Լ�� l''
    ub(3*i) = 0.02;
end

% ����H_L,H_DL,H_DDL,H_CENTRE
for i = 1:n
    H_L(3*i - 2,3*i - 2) = 1;
    H_DL(3*i - 1,3*i - 1) = 1;
    H_DDL(3*i, 3*i) = 1;
end
H_CENTRE = H_L;
% ����H_DDDL;
H_dddl_sub = [0 0 1 0 0 -1];%1����6��
for i = 1:n-1
    row = i;%      [1 2 3 .. 19]
    col = 3*i - 2;%[1 4 7 .. ]
    H_DDDL(row,col:col + 5) = H_dddl_sub;
    %��һ���Ӿ������ 1����1��6��
    %�ڶ����Ӿ������ 2����7��12��
    %  19����55��60��
end
% ����H_L_END H_DL_END H_DDL_END ���һ����
H_L_END(3*n - 2,3*n - 2) = 1;% 58����58�� 
H_DL_END(3*n - 1,3*n - 1) = 1;% 59����59��
H_DDL_END(3*n,3*n) = 1;% 60����60��
% ���ɶ��ι滮��H ��Ϊds ��= 1 ���� dddl = delta_ddl/ds;
H = w_cost_l * (H_L'*H_L) + w_cost_dl * (H_DL'*H_DL) + w_cost_ddl * (H_DDL'*H_DDL)...
   + w_cost_dddl * (H_DDDL'*H_DDDL)/(ds*ds) + w_cost_centre * (H_CENTRE'*H_CENTRE) + w_cost_end_l * (H_L_END'*H_L_END)...
   + w_cost_end_dl * (H_DL_END'* H_DL_END) + w_cost_ddl * (H_DDL_END'*H_DDL_END);
H = 2 * H;%H��60����60��
% ����f
f = zeros(3*n,1);% l��max��min��һ��һ����ds������һ������˲�����
centre_line = 0.5 * (l_min + l_max); % ��ʱcentre line ����60����
% centre_line = dp_path_l_final;
for i = 1:n
%     f(3*i - 2) = -2 * centre_line(3*i - 2);
    f(3*i - 2) = -2 * centre_line(i);% ds = 1
end
% ����centrelineȨ�ع���Ӱ��켣ƽ˳��
for i = 1:n
    if abs(f(i)) > 0.01
        f(i) = w_cost_centre * f(i);
    end
end
% �յ�Ҫ�ӽ�end_l dl ddl desire
f(3*n - 2) = f(3*n - 2) -2 * end_l_desire * w_cost_end_l;
f(3*n - 1) = f(3*n - 1) -2 * end_dl_desire * w_cost_end_dl;
f(3*n) = f(3*n) -2 * end_ddl_desire * w_cost_end_ddl;

X = quadprog(H,f,A,b,Aeq,beq,lb,ub);

for i = 1:n
    qp_path_l(i) = X(3*i - 2);
    qp_path_dl(i) = X(3*i - 1);
    qp_path_ddl(i) = X(3*i);
end

end