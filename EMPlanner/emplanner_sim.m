%% ���ļ��������Ե�һpath trajectory �滮

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
[consider_static_objects_set] = static_object_filter(...
    ego, static_objects_set, ...
    plan_referenceline_x, plan_referenceline_y, plan_referenceline_heading, plan_referenceline_kappa,...
    plan_referenceline_s);

%% ·���Ķ�̬�滮���͹�ռ�
[l_min, l_max, dp_path_s] = generate_convex_space_path(consider_static_objects_set, plan_start_s);

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
figure(3);
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
axis([ego.x-10,ego.x + 80, -30, 30]);%�����Գ����巶Χ���귶Χ

















