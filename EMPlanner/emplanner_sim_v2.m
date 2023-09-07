%% ���ļ��������Ե�һpath trajectory �滮
% emplanner_sim_v2 ��emplanner_sim_v1������ 
% ����Ҳ�ǵ����� �����ϰ��� ��һ���ջ���Ч��
%% ��ͼ��ʼ��
%ֱ�߹���
ReferenceLine_1_X = 0 : 2 : 1000;
totle_num = length(ReferenceLine_1_X);
ReferenceLine_1_Y = zeros(1,totle_num);
RL1_Left_LaneMarker = zeros(1,totle_num) + 2;
RL1_Right_LaneMarker = zeros(1,totle_num) - 2;
ReferenceLine_2_Y = zeros(1,totle_num) + 4;
RL2_Left_LaneMarker = zeros(1,totle_num) + 6;
% ��ó�����
%����1
lane_1_reference_line_x =  ReferenceLine_1_X';
lane_1_reference_line_y =  ReferenceLine_1_Y';
[line_1_reference_line_heading , lane_1_reference_line_kappa] = CalcPathHeadingAndKappa(...
    lane_1_reference_line_x, lane_1_reference_line_y);
%����2
lane_2_reference_line_x =  ReferenceLine_1_X';
lane_2_reference_line_y =  ReferenceLine_2_Y';
[line_2_reference_line_heading , lane_2_reference_line_kappa] = CalcPathHeadingAndKappa(...
    lane_2_reference_line_x, lane_2_reference_line_y);
%����Գ��ĳ�ʼ״̬�Լ���̬�ϰ���
% ��ʾȫ��·��
figure(1);
plot(ReferenceLine_1_X,ReferenceLine_1_Y,'b--',  ReferenceLine_1_X,RL1_Left_LaneMarker,'k-',...
    ReferenceLine_1_X,RL1_Right_LaneMarker,'k-',...
    ReferenceLine_1_X,ReferenceLine_2_Y,'b--',ReferenceLine_1_X,RL2_Left_LaneMarker,'k-');
axis([-10,300, -50, 50])
%
%% �Գ��;�̬�ϰ�����Ϣ
ego = struct('x',0,'y',0,'vx',0,'vy',0,'ax',0,'ay',0,'length',0,'width',0,'heading',0,'kappa',0);
ego.x = 0;
ego.y = 0;
ego.vx = 5;
ego.vy = 0;
ego.ax = 0;
ego.ay = 0;
ego.kappa = 0/180*pi;
ego.heading = 0/180*pi;
ego.length = 4;
ego.width = 1.6;

object = struct('valid',0,'x',0,'y',0,'v',0,'a',0,'length',0,'width',0,'heading',0);
static_object_num = 10;
static_objects_set = repmat(object,static_object_num,1);
%static object 1
static_objects_set(1).valid = 1;
static_objects_set(1).x = 10;
static_objects_set(1).y = -2;
static_objects_set(1).v = 0;
static_objects_set(1).heading = 0/180*pi;
static_objects_set(1).length = 4;
static_objects_set(1).width = 2;
%static object 2
static_objects_set(2).valid = 1;
static_objects_set(2).x = 30;
static_objects_set(2).y = 1.5;
static_objects_set(2).v = 0;
static_objects_set(2).heading = 0/180*pi;
static_objects_set(2).length = 4;
static_objects_set(2).width = 2;
% static object 3
static_index = 3;
static_objects_set(static_index).valid = 1;
static_objects_set(static_index).x = 35;
static_objects_set(static_index).y = 1.5;
static_objects_set(static_index).v = 0;
static_objects_set(static_index).heading = 0/180*pi;
static_objects_set(static_index).length = 4;
static_objects_set(static_index).width = 2;
% static object 4
static_index = 4;
static_objects_set(static_index).valid = 1;
static_objects_set(static_index).x = 40;
static_objects_set(static_index).y = 1.5;
static_objects_set(static_index).v = 0;
static_objects_set(static_index).heading = 0/180*pi;
static_objects_set(static_index).length = 4;
static_objects_set(static_index).width = 2;

%��ʾego
objWidth = ego.width;
objLength = ego.length;
objPosX = ego.x;
objPosY = ego.y;
objHeading = ego.heading;
Boxyx(3) = objPosX - objWidth/2*sin(objHeading) + objLength/2*cos(objHeading);
Boxyy(3) = objPosY + objWidth/2*cos(objHeading) + objLength/2*sin(objHeading);
Boxyx(4) = objPosX + objWidth/2*sin(objHeading) + objLength/2*cos(objHeading);
Boxyy(4) = objPosY - objWidth/2*cos(objHeading) + objLength/2*sin(objHeading);
Boxyx(1) = objPosX + objWidth/2*sin(objHeading) - objLength/2*cos(objHeading);
Boxyy(1) = objPosY - objWidth/2*cos(objHeading) - objLength/2*sin(objHeading); 
Boxyx(2) = objPosX - objWidth/2*sin(objHeading) - objLength/2*cos(objHeading);
Boxyy(2) = objPosY + objWidth/2*cos(objHeading) - objLength/2*sin(objHeading);
patch(Boxyx,Boxyy,'red');
for i = 1:length(static_objects_set)
    objWidth = static_objects_set(i).width;
    objLength = static_objects_set(i).length;
    objPosX = static_objects_set(i).x;
    objPosY = static_objects_set(i).y;
    objHeading = static_objects_set(i).heading;
    Boxyx(3) = objPosX - objWidth/2*sin(objHeading) + objLength/2*cos(objHeading);
    Boxyy(3) = objPosY + objWidth/2*cos(objHeading) + objLength/2*sin(objHeading);
    Boxyx(4) = objPosX + objWidth/2*sin(objHeading) + objLength/2*cos(objHeading);
    Boxyy(4) = objPosY - objWidth/2*cos(objHeading) + objLength/2*sin(objHeading);
    Boxyx(1) = objPosX + objWidth/2*sin(objHeading) - objLength/2*cos(objHeading);
    Boxyy(1) = objPosY - objWidth/2*cos(objHeading) - objLength/2*sin(objHeading); 
    Boxyx(2) = objPosX - objWidth/2*sin(objHeading) - objLength/2*cos(objHeading);
    Boxyy(2) = objPosY + objWidth/2*cos(objHeading) - objLength/2*sin(objHeading);    
    patch(Boxyx,Boxyy,'green');
end
%% time 30������ �����ڱջ�����
for time = 1:30

%% ����ͶӰ��
%�����Գ���λ����ȫ�ֵ�referenceline�����ҵ��Գ���ͶӰ��
[ego_match_point_index,ego_proj_x, ego_proj_y,ego_proj_heading,ego_proj_kappa] = matchpoint(...
    ego.x ,ego.y ,...
    lane_1_reference_line_x,lane_1_reference_line_y,line_1_reference_line_heading, lane_1_reference_line_kappa);
%��ȫ�ֵ�referenceline�Ͻ�ȡһ����Ϊ�滮��·���ο���plan_referenceline
[plan_referenceline_x,plan_referenceline_y,plan_referenceline_heading,plan_referenceline_kappa] = get_plan_referenceline(...
ego_match_point_index,lane_1_reference_line_x,lane_1_reference_line_y,...
line_1_reference_line_heading , lane_1_reference_line_kappa);
%�Գ���λ��x yͶӰ��·���ο���plan_referenceline���ƥ����ͶӰ�����곯������
[ego_match_point_index,ego_proj_x, ego_proj_y,ego_proj_heading,ego_proj_kappa] = matchpoint(...
    ego.x ,ego.y ,...
    plan_referenceline_x,plan_referenceline_y,plan_referenceline_heading, plan_referenceline_kappa);
%����plan_referenceline_s������ۻ� s��
plan_referenceline_s  = get_referenceline_s(plan_referenceline_x,plan_referenceline_y,ego_proj_x,ego_proj_y,ego_match_point_index);
%�Գ��滮�����Cartesian2Frenet_sl ��ù滮���� s l
[ego_plan_start_s,ego_plan_start_l] = Cartesian2Frenet_sl(ego.x,ego.y,plan_referenceline_x,plan_referenceline_y,...
    ego_proj_x,ego_proj_y,ego_proj_heading,ego_match_point_index,plan_referenceline_s);
%�Գ��滮�����Cartesian2Frenet_sl ��ù滮���� dl
[ego_plan_start_s_dot,ego_plan_start_l_dot,ego_plan_start_dl] = Cartesian2Frenet_dsl(ego_plan_start_l,ego.vx,ego.vy,...
    ego_proj_heading,ego_proj_kappa);
%�Գ��滮�����Cartesian2Frenet_sl ��ù滮���� ddl
[~,~,ego_plan_start_ddl] = Cartesian2Frenet_ddsl(ego.ax,ego.ay,...
    ego_proj_heading,ego_proj_kappa,ego_plan_start_l,ego_plan_start_s_dot,ego_plan_start_dl);
%�滮����frenet
plan_start_s = ego_plan_start_s;
plan_start_l = ego_plan_start_l;
plan_start_dl = ego_plan_start_dl;
plan_start_ddl = ego_plan_start_ddl;
%% ��̬�ϰ���Ĵ���
[filter_static_objects] = static_objects_filter(ego, static_objects_set);
% ��Ҫ�滮������ϰ����Ҽ����ϰ�����ĸ��ǵ�
% consider_static_object_num = 10 ��ദ��10���ϰ���
consider_static_object_num = length(filter_static_objects);
consider_static_object = struct('id',0,'decision',0,'site',0,'x_set',zeros(4,1),'y_set',zeros(4,1),...
    's_set',zeros(4,1),'l_set',zeros(4,1),'min_s',inf,'max_s',-inf,'min_l',inf,'max_l',-inf);
consider_static_objects_set = repmat(consider_static_object,static_object_num,1);%��̬�ϰ���Ĭ��10��
for i = 1 : static_object_num
    if filter_static_objects(i).valid == 0 %invalid
        continue;
    end
    consider_static_objects_set(i).id = i;
    objPosX = filter_static_objects(i).x;
    objPosY = filter_static_objects(i).y;
    objHeading = filter_static_objects(i).heading;
    objWidth = filter_static_objects(i).width;
    objLength = filter_static_objects(i).length;
    consider_static_objects_set(i).x_set(1) = objPosX + objWidth/2*sin(objHeading) - objLength/2*cos(objHeading);
    consider_static_objects_set(i).y_set(1) = objPosY - objWidth/2*cos(objHeading) - objLength/2*sin(objHeading); 

    consider_static_objects_set(i).x_set(2) = objPosX - objWidth/2*sin(objHeading) - objLength/2*cos(objHeading);
    consider_static_objects_set(i).y_set(2) = objPosY + objWidth/2*cos(objHeading) - objLength/2*sin(objHeading);

    consider_static_objects_set(i).x_set(3) = objPosX - objWidth/2*sin(objHeading) + objLength/2*cos(objHeading);
    consider_static_objects_set(i).y_set(3) = objPosY + objWidth/2*cos(objHeading) + objLength/2*sin(objHeading);

    consider_static_objects_set(i).x_set(4) = objPosX + objWidth/2*sin(objHeading) + objLength/2*cos(objHeading);
    consider_static_objects_set(i).y_set(4) = objPosY - objWidth/2*cos(objHeading) + objLength/2*sin(objHeading);
end

% ���㿼�Ǿ�̬���ϰ�����frenet�����sl
for i = 1 : static_object_num
    if consider_static_objects_set(i).id == 0
        continue;
    end
    %��̬�ϰ�����ĸ��ǵ�ͶӰ�� plan_referenceline ��
    for j = 1 : length(consider_static_objects_set(i).x_set)
        static_obj_x = consider_static_objects_set(i).x_set(j);
        static_obj_y = consider_static_objects_set(i).y_set(j);
        [match_point_index, proj_x, proj_y, proj_heading, proj_kappa] = matchpoint(...
        static_obj_x ,static_obj_y ,...
        plan_referenceline_x, plan_referenceline_y, plan_referenceline_heading, plan_referenceline_kappa);
        [static_obj_s,static_obj_l] = Cartesian2Frenet_sl(static_obj_x, static_obj_y,...
            plan_referenceline_x,plan_referenceline_y,...
            proj_x,proj_y,proj_heading,match_point_index,plan_referenceline_s);
        consider_static_objects_set(i).s_set(j) = static_obj_s;
        consider_static_objects_set(i).l_set(j) = static_obj_l;
        if consider_static_objects_set(i).min_s > static_obj_s
            consider_static_objects_set(i).min_s = static_obj_s;
        end
        if consider_static_objects_set(i).max_s < static_obj_s
            consider_static_objects_set(i).max_s = static_obj_s;
        end
        if consider_static_objects_set(i).min_l > static_obj_l
            consider_static_objects_set(i).min_l = static_obj_l;
        end
        if consider_static_objects_set(i).max_l < static_obj_l
            consider_static_objects_set(i).max_l = static_obj_l;
        end
    end
end

% ��ӶԾ�̬�ϰ���ľ���
for i = 1 : static_object_num
    if consider_static_objects_set(i).id == 0
        continue;
    end
    if consider_static_objects_set(i).min_l < 0 && consider_static_objects_set(i).max_l < 0
        %�ϰ�����path_reference�ұ� 1 is site = right 
        consider_static_objects_set(i).site = 1;
        if consider_static_objects_set(i).max_l <= -0.5
            consider_static_objects_set(i).decision = 1;% decision = 1 nudge
        else
            consider_static_objects_set(i).decision = 2;% decision = 2 stop
        end
    end
    if consider_static_objects_set(i).min_l > 0 && consider_static_objects_set(i).max_l > 0
        %�ϰ�����path_reference��� 2 is site = left 
        consider_static_objects_set(i).site = 2;
        if consider_static_objects_set(i).max_l > 0.8
            consider_static_objects_set(i).decision = 1;% decision = 1 nudge
        else
            consider_static_objects_set(i).decision = 2;
        end
    end
    if consider_static_objects_set(i).min_l < 0 && consider_static_objects_set(i).max_l > 0
        %�ϰ�����path_reference�м� ֱ��stop���� 3 is site = right
        consider_static_objects_set(i).site = 3;
        consider_static_objects_set(i).decision = 2;
    end
end 

%% ·���Ķ�̬�滮���͹�ռ�
% lane keep ͹�ռ䣬�ȳ�ʼ��Ϊ-2 �� 2���ٴ���̬�ϰ���
% �Թ滮�������ǰ80�� ds = 1
sample_s = 1;
dp_path_s = ones(80,1);
for i = 1:80
    dp_path_s(i) = plan_start_s + (i - 2) * sample_s;
end
l_min = ones(1,80)*-2;
l_max = ones(1,80)*2;
%���ݾ�̬�ϰ�����Сl��͹�ռ�
for i = 1 : static_object_num
    if consider_static_objects_set(i).id == 0
        continue;
    end
    if consider_static_objects_set(i).decision == 1 %decision = 1 nudge
        %���� min_s �� max_s �ҵ���ʼ�ĵ�index
        start_index = inf;
        end_index = inf;
        %���� start index ���� end_index
        for j = 1 : length(dp_path_s) - 1 
            if dp_path_s(j) <= consider_static_objects_set(i).min_s && ...
                dp_path_s(j+1) >= consider_static_objects_set(i).min_s 
                start_index = max(j - 2,1);%�������һ����
                for z = 1 : length(dp_path_s) - 1
                    if dp_path_s(z) <= consider_static_objects_set(i).max_s && ...
                        dp_path_s(z+1) >= consider_static_objects_set(i).max_s 
                        end_index = min(z + 3,length(dp_path_s));%��ǰ����һ����
                    end
                end
            end
        end
        if start_index ~= inf && end_index ~= inf && (start_index <= end_index)
            %�ж�������  1 is site = right 
            if consider_static_objects_set(i).site(1) == 1
                for k = start_index : end_index
                    l_min(k) = max(consider_static_objects_set(i).max_l + 0.2, l_min(k));
                end
            elseif consider_static_objects_set(i).site(1) == 2 % 2 is site = left 
                for k = start_index : end_index
                    l_max(k) = min(consider_static_objects_set(i).min_l - 0.2, l_max(k));
                end
            else
                 %static in middle stop
            end
        end
    end
end

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
    lb(3*i - 1) = - 1.2; %Լ�� l'
    ub(3*i - 1) = 1.2;
    lb(3*i) = -0.2; %Լ�� l''
    ub(3*i) = 0.2;
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
% add points����
[qp_path_s_final,qp_path_l_final, qp_path_dl_final,qp_path_ddl_final] =...
    add_points_path(qp_path_s,qp_path_l,qp_path_dl,qp_path_ddl);
% frenet����ϵת����������ϵ
[x_set,y_set,heading_set,kappa_set] = Frenet2Cartesian_Path(...
    qp_path_s_final,qp_path_l_final, qp_path_dl_final,qp_path_ddl_final,...
    plan_referenceline_x,plan_referenceline_y,plan_referenceline_heading, plan_referenceline_kappa,plan_referenceline_s);
%% ִ�� 5m/s 5���� ÿ�����ڶ����� ��ʱȡ5
ego.x = x_set(5);
ego.y = y_set(5);
ego.heading = heading_set(5);
%% ��ʾ
%��ʾ�滮·���ο���plan_referenceline
figure(3);
plot(plan_referenceline_x, plan_referenceline_y, 'g--');
dp_tra_s = zeros(80,1);
dp_tra_s = dp_path_s + ego.x;
dp_path_l_min = zeros(80,1);
dp_path_l_max = zeros(80,1);
for i = 1:length(dp_tra_s)
    dp_path_l_min(i) = l_min(i);
    dp_path_l_max(i) = l_max(i);
end
% map + �滮�Ĺ켣��
plot(ReferenceLine_1_X,ReferenceLine_1_Y,'b--',  ReferenceLine_1_X,RL1_Left_LaneMarker,'k-',...
ReferenceLine_1_X,RL1_Right_LaneMarker,'k-',...
ReferenceLine_1_X,ReferenceLine_2_Y,'b--',ReferenceLine_1_X,RL2_Left_LaneMarker,'k-',...
x_set,y_set,'b.',...
dp_tra_s,dp_path_l_min,'r.',dp_tra_s,dp_path_l_max,'r.');

%ego
objWidth = ego.width;
objLength = ego.length;
objPosX = ego.x;
objPosY = ego.y;
objHeading = ego.heading;
Boxyx(3) = objPosX - objWidth/2*sin(objHeading) + objLength/2*cos(objHeading);
Boxyy(3) = objPosY + objWidth/2*cos(objHeading) + objLength/2*sin(objHeading);
Boxyx(4) = objPosX + objWidth/2*sin(objHeading) + objLength/2*cos(objHeading);
Boxyy(4) = objPosY - objWidth/2*cos(objHeading) + objLength/2*sin(objHeading);
Boxyx(1) = objPosX + objWidth/2*sin(objHeading) - objLength/2*cos(objHeading);
Boxyy(1) = objPosY - objWidth/2*cos(objHeading) - objLength/2*sin(objHeading); 
Boxyx(2) = objPosX - objWidth/2*sin(objHeading) - objLength/2*cos(objHeading);
Boxyy(2) = objPosY + objWidth/2*cos(objHeading) - objLength/2*sin(objHeading);
patch(Boxyx,Boxyy,'blue'); 
%��̬�ϰ���
for j = 1:length(static_objects_set)
    objWidth = static_objects_set(j).width;
    objLength = static_objects_set(j).length;
    objPosX = static_objects_set(j).x;
    objPosY = static_objects_set(j).y;
    objHeading = static_objects_set(j).heading;
    Boxyx(3) = objPosX - objWidth/2*sin(objHeading) + objLength/2*cos(objHeading);
    Boxyy(3) = objPosY + objWidth/2*cos(objHeading) + objLength/2*sin(objHeading);
    Boxyx(4) = objPosX + objWidth/2*sin(objHeading) + objLength/2*cos(objHeading);
    Boxyy(4) = objPosY - objWidth/2*cos(objHeading) + objLength/2*sin(objHeading);
    Boxyx(1) = objPosX + objWidth/2*sin(objHeading) - objLength/2*cos(objHeading);
    Boxyy(1) = objPosY - objWidth/2*cos(objHeading) - objLength/2*sin(objHeading); 
    Boxyx(2) = objPosX - objWidth/2*sin(objHeading) - objLength/2*cos(objHeading);
    Boxyy(2) = objPosY + objWidth/2*cos(objHeading) - objLength/2*sin(objHeading);    
    patch(Boxyx,Boxyy,'black');
end
axis([-10,90, -20, 20]);%�����Գ����巶Χ���귶Χ

pause(0.2);

end














