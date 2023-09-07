%% ���ļ��������Ե�һ path trajectory �滮��
%����ǲ�������ĺ���켣
% �Գ�ǰ���ж����̬���ϰ������apollo��public rode planner����͹�ռ� Ȼ��qpƽ���켣��
% �滮��Ϻ� ����single_trajectory_display.m�鿴�Ƿ����
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
% % ��ʾȫ��·��
% figure(1);
% plot(ReferenceLine_1_X,ReferenceLine_1_Y,'b--',  ReferenceLine_1_X,RL1_Left_LaneMarker,'k-',...
%     ReferenceLine_1_X,RL1_Right_LaneMarker,'k-',...
%     ReferenceLine_1_X,ReferenceLine_2_Y,'b--',ReferenceLine_1_X,RL2_Left_LaneMarker,'k-');
% axis([-10,300, -50, 50])

%% �Գ��;�̬�ϰ�����Ϣ
ego = struct('x',0,'y',0,'vx',0,'vy',0,'ax',0,'ay',0,'length',0,'width',0,'heading',0,'kappa',0);
ego.x = 5;%
ego.y = 0;%
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
static_objects_set(1).x = 25;
static_objects_set(1).y = 1.5;
static_objects_set(1).v = 0;
static_objects_set(1).heading = 0/180*pi;
static_objects_set(1).length = 4;
static_objects_set(1).width = 2;


%% ����ͶӰ��
%�����Գ���λ����ȫ�ֵ�referenceline�����ҵ��Գ���ͶӰ��
[ego_match_point_index,ego_proj_x, ego_proj_y,ego_proj_heading,ego_proj_kappa] = matchpoint(...
    ego.x ,ego.y ,...
    lane_2_reference_line_x,lane_2_reference_line_y,line_2_reference_line_heading, lane_2_reference_line_kappa);
%��ȫ�ֵ�referenceline�Ͻ�ȡһ����Ϊ�滮��·���ο���plan_referenceline
[plan_referenceline_x,plan_referenceline_y,plan_referenceline_heading,plan_referenceline_kappa] = get_plan_referenceline(...
ego_match_point_index,lane_2_reference_line_x,lane_2_reference_line_y,...
line_2_reference_line_heading , lane_2_reference_line_kappa);
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
% �����͹�ռ�
l_min = ones(1,80)*(ego_plan_start_l - 0.4);%add offset
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
[qp_path_s, qp_path_l, qp_path_dl, qp_path_ddl] = qp_path(...
    ego_plan_start_s, ego_plan_start_l, ego_plan_start_dl, ego_plan_start_ddl,...
    l_max, l_min);
% frenet����ϵת����������ϵ ��ó�ʼ��·��
[trajectory_x_init, trajectory_y_init, trajectory_heading_init, trajectory_kappa_init] = Frenet2Cartesian_Path(...  
 qp_path_s,qp_path_l, qp_path_dl,qp_path_ddl,...
 plan_referenceline_x,plan_referenceline_y,plan_referenceline_heading, plan_referenceline_kappa,plan_referenceline_s);

%% ��̬�ϰ���



%% ��ʾ������ �Գ� �ϰ���
%��ʾ�滮·���ο���plan_referenceline
figure(2);
% map + �滮�Ĺ켣��
plot(ReferenceLine_1_X,ReferenceLine_1_Y,'b--',  ReferenceLine_1_X,RL1_Left_LaneMarker,'k-',...
ReferenceLine_1_X,RL1_Right_LaneMarker,'k-',...
ReferenceLine_1_X,ReferenceLine_2_Y,'b--',ReferenceLine_1_X,RL2_Left_LaneMarker,'k-',...
trajectory_x_init, trajectory_y_init,'b.');

% ego
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
%patch(Boxyx,Boxyy,'blue'); 
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
axis([ego.x-10,ego.x + 80, -30, 30]);%�����Գ����巶Χ���귶Χ

















