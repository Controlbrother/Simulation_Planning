%%定义道路宽度  
LaneWidth = 4;%
LaneLength = 800;%路长800米
global_path_x = 0: 0.2 : LaneLength;%
num1 = uint16(length(global_path_x));%计算多少个点
global_path_y = zeros(1,num1);
leftLaneMarker = global_path_y + LaneWidth/2;%左车道线y值 +2
rightLaneMarker = global_path_y - LaneWidth/2; 
rightcenterline = global_path_y - LaneWidth;
leftleftLaneMarker = leftLaneMarker + LaneWidth;
rightrightLaneMarker = rightLaneMarker - LaneWidth;

%% replay
ego_state = 1;% 1 lane keep 2 lane change
lane_change_index = 0;
cur_ego_position = 0;
%前车 侧前车 侧后车匀速运动 初始化
cur_velocity_side_front = velocity_side_front;
cur_position_side_front = position_side_front;
cur_velocity_side_rear = velocity_side_rear;
cur_position_side_rear = position_side_rear;
% front vehicle
cur_velocity_front = velocity_front;
cur_position_front = position_front;
% lane change trajectory
trajectory_x = zeros(100,1);
trajectory_y = zeros(100,1);
trajectory_heading = zeros(100,1);
trajectory_kappa = zeros(100,1);


% 循环闭环仿真
for i = 1 : tra_num 
    plot(global_path_x,global_path_y,'b--',  global_path_x,leftLaneMarker,'k-', global_path_x,rightLaneMarker,'k--',...
        global_path_x,rightcenterline,'b--',global_path_x,rightrightLaneMarker,'k-');
    
    EgoWidth = 2;%车宽
    EgoLength = 5;
    if ego_state == 1
        EgoPosX = position_arr(i);
        EgoPosY = 0;
        EgoHeading = 0;
    else
        EgoPosX = trajectory_x(i - lane_change_index);
        EgoPosY = trajectory_y(i - lane_change_index);
        EgoHeading = trajectory_heading(i - lane_change_index);
    end
    
    EgoColor = [0.9 0.9 0.9 0.9];
    Boxyx = zeros(1,4);
    Boxyy = zeros(1,4);
    Boxyx(1) = EgoPosX - EgoWidth/2*sin(EgoHeading);
    Boxyy(1) = EgoPosY + EgoWidth/2*cos(EgoHeading);
    Boxyx(2) = EgoPosX + EgoWidth/2*sin(EgoHeading);
    Boxyy(2) = EgoPosY - EgoWidth/2*cos(EgoHeading);
    Boxyx(3) = Boxyx(2) + EgoLength*cos(EgoHeading);
    Boxyy(3) = Boxyy(2) + EgoLength*sin(EgoHeading);
    Boxyx(4) = Boxyx(1) + EgoLength*cos(EgoHeading);
    Boxyy(4) = Boxyy(1) + EgoLength*sin(EgoHeading);
    patch(Boxyx,Boxyy,EgoColor);
    axis([EgoPosX-30,EgoPosX+80,-20,20]);%坐标范围
    cur_ego_position = EgoPosX;%更新自车当前的位置
    %变道窗口的侧前车
    objWidth = 2;
    objLength = 5;
    objPosX = position_side_front + velocity_side_front * 0.1 * i;
    objPosY = -4;
    objHeading = 0;
    objColor = [0.9 0.9 0.9 0.9];
    Boxyx(1) = objPosX - objWidth/2*sin(objHeading);
    Boxyy(1) = objPosY + objWidth/2*cos(objHeading);
    Boxyx(2) = objPosX + objWidth/2*sin(objHeading);
    Boxyy(2) = objPosY - objWidth/2*cos(objHeading);
    Boxyx(3) = Boxyx(2) + objLength*cos(objHeading);
    Boxyy(3) = Boxyy(2) + objLength*sin(objHeading);
    Boxyx(4) = Boxyx(1) + objLength*cos(objHeading);
    Boxyy(4) = Boxyy(1) + objLength*sin(objHeading);
    patch(Boxyx,Boxyy,objColor);
    cur_position_side_front = objPosX;%更新侧前车的位置
    %变道窗口的后车
    objWidth = 2;
    objLength = 5;
    objPosX = position_side_rear + velocity_side_rear * 0.1 * i;
    objPosY = -4;
    objHeading = 0;
    objColor = [0.9 0.9 0.9 0.9];
    Boxyx(1) = objPosX - objWidth/2*sin(objHeading);
    Boxyy(1) = objPosY + objWidth/2*cos(objHeading);
    Boxyx(2) = objPosX + objWidth/2*sin(objHeading);
    Boxyy(2) = objPosY - objWidth/2*cos(objHeading);
    Boxyx(3) = Boxyx(2) + objLength*cos(objHeading);
    Boxyy(3) = Boxyy(2) + objLength*sin(objHeading);
    Boxyx(4) = Boxyx(1) + objLength*cos(objHeading);
    Boxyy(4) = Boxyy(1) + objLength*sin(objHeading);
    patch(Boxyx,Boxyy,objColor);
    cur_position_side_rear = objPosX;%位置更新侧后车
    %前车
    objWidth = 2;
    objLength = 5;
    objPosX = position_front + velocity_front * 0.1 * i;
    objPosY = 0;
    objHeading = 0;
    objColor = [0.9 0.9 0.9 0.9];
    Boxyx(1) = objPosX - objWidth/2*sin(objHeading);
    Boxyy(1) = objPosY + objWidth/2*cos(objHeading);
    Boxyx(2) = objPosX + objWidth/2*sin(objHeading);
    Boxyy(2) = objPosY - objWidth/2*cos(objHeading);
    Boxyx(3) = Boxyx(2) + objLength*cos(objHeading);
    Boxyy(3) = Boxyy(2) + objLength*sin(objHeading);
    Boxyx(4) = Boxyx(1) + objLength*cos(objHeading);
    Boxyy(4) = Boxyy(1) + objLength*sin(objHeading);
    patch(Boxyx,Boxyy,objColor);
    cur_position_front = objPosX;%更新前车的位置
    pause(0.2);
   %% 增加逻辑判断
   if ego_state == 1 % 自车处于lane keep
       if cur_ego_position >= (cur_position_side_rear + cur_velocity_side_rear * 0.6) && ...
               cur_ego_position <= (cur_position_front - cur_velocity_front * 0.6) && ...
               cur_ego_position <= (cur_position_side_front - cur_velocity_side_front * 0.6)
       ego_state = 2; %进入 lane change
       lane_change_index = i;%
       start_s = position_arr(1,i);
       [path_x, path_y] = bezier_curve(start_s,cut_in_s);
       [path_heading,path_kappa] = CalcPathHeadingAndKappa(path_x,path_y);
        % path点的个数
        n = length(path_x);
        % 输出初始化
        path_s = zeros(n,1);
        % 首先计算以path起点为坐标原点的path_s
        for j = 2:n
            path_s(j) = sqrt((path_x(j) - path_x(j-1))^2 + (path_y(j) - path_y(j-1))^2) + path_s(j-1);
        end
        s = position_arr(1,i:end) - start_s;
        index = n;
        % speed and path stitch
        num = length(s);
        for k = 1:num
            trajectory_x(k) = interp1(path_s(1:index),path_x(1: index), s(k));
            trajectory_y(k) = interp1(path_s(1:index),path_y(1: index), s(k));
            trajectory_heading(k) = interp1(path_s(1:index),path_heading(1:index), s(k));
            trajectory_kappa(k) = interp1(path_s(1:index),path_kappa(1:index), s(k));
        end
       end
   end
    
    
end

%%
function [path_x, path_y] = bezier_curve(start_s,cut_in_s)
%起点 障碍物点 目标点
P0=[start_s 0];
Pob=[cut_in_s 0;
     cut_in_s -4
     ];
Pg=[cut_in_s*2 -4];
P=[P0;Pob;Pg];
i=1;
%% 贝塞尔曲线计算　基本思路Pt＝(1-t)*P1+t*P2
for t=0:0.01:1
    % 一次贝塞尔曲线
    p_t_1=(1-t)*P(1,:)+t*P(2,:);
    p_t_2=(1-t)*P(2,:)+t*P(3,:);
    p_t_3=(1-t)*P(3,:)+t*P(4,:);
    % 二次贝塞尔曲线
    pp_t_1=(1-t)*p_t_1+t*p_t_2;
    pp_t_2=(1-t)*p_t_2+t*p_t_3;
    % 三次贝塞尔曲线
    ppp_t(i,:)=(1-t)*pp_t_1+t*pp_t_2;
    i=i+1;
end
path_x = ppp_t(:,1);
path_y = ppp_t(:,2);
end



