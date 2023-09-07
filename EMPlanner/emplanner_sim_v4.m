%% ���ļ������������Ķ�ܾ�̬�ϰ���
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
static_object = struct('valid',0,'x',0,'y',0,'v',0,'a',0,'length',0,'width',0,'heading',0);
static_object_num = 10;
static_objects_set = repmat(static_object,static_object_num,1);
%static object 1
static_objects_set(1).valid = 1;
static_objects_set(1).x = 120;
static_objects_set(1).y = -1.2;
static_objects_set(1).v = 0;
static_objects_set(1).heading = 0/180*pi;
static_objects_set(1).length = 4;
static_objects_set(1).width = 2;
%static object 2
static_objects_set(2).valid = 1;
static_objects_set(2).x = 180;
static_objects_set(2).y = 4;
static_objects_set(2).v = 0;
static_objects_set(2).heading = 0/180*pi;
static_objects_set(2).length = 4;
static_objects_set(2).width = 2;
% % static object 3
static_index = 3;
static_objects_set(static_index).valid = 1;
static_objects_set(static_index).x = 260;
static_objects_set(static_index).y = - 1.0;
static_objects_set(static_index).v = 0;
static_objects_set(static_index).heading = 0/180*pi;
static_objects_set(static_index).length = 4;
static_objects_set(static_index).width = 2;
% static object 4
static_index = 4;
static_objects_set(static_index).valid = 1;
static_objects_set(static_index).x = 320;
static_objects_set(static_index).y = 2.5;
static_objects_set(static_index).v = 0;
static_objects_set(static_index).heading = 0/180*pi;
static_objects_set(static_index).length = 4;
static_objects_set(static_index).width = 2;

%%
% ego_state % 1 lane_keep  2 lane change
% �Գ�������lane keep��ÿ�ζ��滮�µĹ켣���Գ�����lane change���켣����ֱ��lanechange��ɡ�
% lane_plan-> �Գ��Ƿ���Ҫ���й켣�滮
% lane_num-> ������
% lane_change_plan-> �Գ�����lane change �Ƿ���Ҫ�滮�켣
ego_state = struct('state',1,'lane_plan',1,'plan_type',1,'lane_num',1,'target_lane_num',1,'lane_change_plan',0);
path_num = 180;
ego_cur_path_x = zeros(path_num,1);
ego_cur_path_y = zeros(path_num,1);
ego_cur_path_heading = zeros(path_num,1);
ego_cur_path_kappa = zeros(path_num,1);
path_reuse_count = 1;

for time = 1:120 % sim ѭ��
    
%% �Գ���lane keep �滮�µĹ켣
if ego_state.state == 1 % �Գ�����lane keep
    ego_state.lane_plan = 1;%lanekeepÿһ�ζ���Ҫ�켣�滮
    ego_state.lane_type = 1;
    if ego_state.lane_num == 1 
        % �Գ����ڳ���1
        ego_reference_line_x = lane_1_reference_line_x;
        ego_reference_line_y = lane_1_reference_line_y;
        ego_reference_line_heading = line_1_reference_line_heading;
        ego_reference_line_kappa = lane_1_reference_line_kappa;
    else
        % �Գ����ڳ���2
        ego_reference_line_x = lane_2_reference_line_x;
        ego_reference_line_y = lane_2_reference_line_y;
        ego_reference_line_heading = line_2_reference_line_heading;
        ego_reference_line_kappa = lane_2_reference_line_kappa;
    end
end
if ego_state.state == 2  % �Գ����ڱ����
    if ego_state.lane_change_plan == 1 %�Գ�����lane change����û�й켣����Ҫ�滮
        ego_state.lane_plan = 1;%��Ҫ���й켣�滮
        ego_state.lane_type = 2;
        if ego_state.target_lane_num == 1 %
            % �Գ��򳵵�1�����Ҫ�滮�켣
            ego_reference_line_x = lane_1_reference_line_x;
            ego_reference_line_y = lane_1_reference_line_y;
            ego_reference_line_heading = line_1_reference_line_heading;
            ego_reference_line_kappa = lane_1_reference_line_kappa;
            ego_state.lane_change_plan = 0;%�滮һ�ξͽ�������ʼִ��
        else
            % % �Գ��򳵵�2�����Ҫ�滮�켣
            ego_reference_line_x = lane_2_reference_line_x;
            ego_reference_line_y = lane_2_reference_line_y;
            ego_reference_line_heading = line_2_reference_line_heading;
            ego_reference_line_kappa = lane_2_reference_line_kappa;
            ego_state.lane_change_plan = 0;%�滮һ�ξͽ�������ʼִ��
        end
    else %%�Գ�����lane change�й켣������Ҫ�滮������֮ǰ�Ĺ켣��ֱ�������ɡ�
        ego_state.lane_plan = 0;%����Ҫ���й켣�滮
        %���Ź켣
        ego.x = ego_cur_path_x(path_reuse_count);
        ego.y = ego_cur_path_y(path_reuse_count);
        ego.heading = ego_cur_path_heading(path_reuse_count);
        ego.kappa = ego_cur_path_kappa(path_reuse_count);
        path_reuse_count = path_reuse_count + 3;
        %p�ж��Ƿ�lane change ����
        if ego_state.target_lane_num == 2
             [ego_match_point_index,ego_proj_x, ego_proj_y,ego_proj_heading,ego_proj_kappa] = matchpoint(...
                ego.x ,ego.y ,...
                lane_2_reference_line_x, lane_2_reference_line_y, line_2_reference_line_heading, lane_2_reference_line_kappa);
        else
            [ego_match_point_index,ego_proj_x, ego_proj_y,ego_proj_heading,ego_proj_kappa] = matchpoint(...
                ego.x ,ego.y ,...
                lane_1_reference_line_x, lane_1_reference_line_y, line_1_reference_line_heading, lane_1_reference_line_kappa);
        end
        n_r = [-sin(ego_proj_heading);cos(ego_proj_heading)];
        r_h = [ego.x;ego.y];
        r_r = [ego_proj_x;ego_proj_y];
        l = (r_h - r_r)'*n_r;
        if abs(l) < 0.5 %��Ϊlane change��� ����lane keep�Ĺ滮
            ego_state.state = 1;%�Գ�����lane keep
            ego_state.lane_num = ego_state.target_lane_num;
            ego_state.lane_plan = 1;
            path_reuse_count = 1;
        end
    end
end

if ego_state.lane_plan == 1 %��Ҫ�켣�滮
    % �Գ�ͶӰ��ȫ��·���ϼ���ͶӰ��
    [ego_match_point_index,ego_proj_x, ego_proj_y,ego_proj_heading,ego_proj_kappa] = matchpoint(...
        ego.x ,ego.y ,...
        ego_reference_line_x, ego_reference_line_y, ego_reference_line_heading, ego_reference_line_kappa);
    %��ȫ�ֵ�referenceline�Ͻ�ȡһ����Ϊ�滮��·���ο���plan_referenceline
    [plan_referenceline_x,plan_referenceline_y,plan_referenceline_heading,plan_referenceline_kappa] = get_plan_referenceline(...
        ego_match_point_index,...
        ego_reference_line_x, ego_reference_line_y, ego_reference_line_heading, ego_reference_line_kappa);
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
    %������Գ����ĸ��ǵ�
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
        %�ϰ�����ĸ��ǵ�
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
        if consider_static_objects_set(i).min_s < 0
            continue;
        end
        if consider_static_objects_set(i).min_l < 0 && consider_static_objects_set(i).max_l <= 0
            %�ϰ�����path_reference�ұ� 1 is site = right 
            consider_static_objects_set(i).site = 1;
            if consider_static_objects_set(i).max_l <= -0.8
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
    %% �������Ҫͣ�����ϰ��� ��Ҫ�ı�״̬��
    %�ڵ�ǰlane����ʱ���������ϰ�����Ҫlane change
    for i = 1 : static_object_num
        if consider_static_objects_set(i).id == 0
            continue;
        end
        if consider_static_objects_set(i).decision == 2
            ego_state.state = 2;% ����lane change
            ego_state.lane_change_plan = 1;%��Ҫ�滮�켣
            ego_state.lane_plan = 0;%����Ҫ�����QP�켣�滮
            if ego_state.lane_num == 1 % �Գ�����1 ��2���
                ego_state.target_lane_num = 2;
            else
                ego_state.target_lane_num = 1;
            end
        end
    end
    
    %% �������Ĺ켣�滮
    if ego_state.lane_plan == 1
        % ·���Ķ�̬�滮���͹�ռ�
        % lane keep ͹�ռ䣬�ȳ�ʼ��Ϊ-2 �� 2���ٴ���̬�ϰ���
        % �Թ滮�������ǰ80�� ds = 1
        sample_s = 1;
        dp_path_s = ones(80,1);
        for i = 1:80
            dp_path_s(i) = plan_start_s + (i - 2) * sample_s;
        end
        if ego_state.state == 1
            l_min = ones(1,80)*-2;
            l_max = ones(1,80)*2;
        else
            %�Գ�����lane change�켣�滮
            if ego_state.target_lane_num == 2 %�Գ�����lane 1 �򳵵�2����lane change
                l_min = ones(1,80)*(ego_plan_start_l - 0.4);%add offset
                l_max = ones(1,80)*2;
            else
                l_min = ones(1,80)*-2;
                l_max = ones(1,80)*(ego_plan_start_l + 0.4);
            end
        end
        
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
        %% qp path solver
        [qp_path_s, qp_path_l, qp_path_dl, qp_path_ddl] = qp_path(...
            ego_plan_start_s, ego_plan_start_l, ego_plan_start_dl, ego_plan_start_ddl,...
            l_max, l_min);
        % add points���ܳ�ʼ60�������ӵ�180����
%         [qp_path_s_final,qp_path_l_final, qp_path_dl_final,qp_path_ddl_final] =...
%             add_points_path(qp_path_s,qp_path_l,qp_path_dl,qp_path_ddl);
        % frenet����ϵת����������ϵ
%         [x_set,y_set,heading_set,kappa_set] = Frenet2Cartesian_Path(...
%             qp_path_s_final,qp_path_l_final, qp_path_dl_final,qp_path_ddl_final,...
%             plan_referenceline_x,plan_referenceline_y,plan_referenceline_heading, plan_referenceline_kappa,plan_referenceline_s);
        [x_set,y_set,heading_set,kappa_set] = Frenet2Cartesian_Path(...
            qp_path_s,qp_path_l, qp_path_dl,qp_path_ddl,...
            plan_referenceline_x,plan_referenceline_y,plan_referenceline_heading, plan_referenceline_kappa,plan_referenceline_s);
        %�滮�µĹ켣����
        ego_cur_path_x = x_set;
        ego_cur_path_y = y_set;
        ego_cur_path_heading = heading_set;
        ego_cur_path_kappa = kappa_set;
    end
end

%���Գ���lane keep��
if ego_state.state == 1
    ego.x = ego_cur_path_x(5);
    ego.y = ego_cur_path_y(5);
    ego.heading = ego_cur_path_heading(5);
    ego.kappa = ego_cur_path_kappa(5);
end
%% ��ʾģ��
% figure(3);
% plot(plan_referenceline_x, plan_referenceline_y, 'g--');
% dp_tra_s = zeros(80,1);
% dp_tra_s = dp_path_s + ego.x;
% dp_path_l_min = zeros(80,1);
% dp_path_l_max = zeros(80,1);
% for i = 1:length(dp_tra_s)
%     dp_path_l_min(i) = l_min(i);
%     dp_path_l_max(i) = l_max(i);
% end
% map + �滮�Ĺ켣��
plot(ReferenceLine_1_X,ReferenceLine_1_Y,'b--',  ReferenceLine_1_X,RL1_Left_LaneMarker,'k-',...
ReferenceLine_1_X,RL1_Right_LaneMarker,'k-',...
ReferenceLine_1_X,ReferenceLine_2_Y,'b--',ReferenceLine_1_X,RL2_Left_LaneMarker,'k-',...
ego_cur_path_x,ego_cur_path_y,'b.');

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
x = ego.x;
axis([(x - 10), (x+80), -20, 20]);%�����Գ����巶Χ���귶Χ
pause(0.5);

end % ����ѭ�� end












