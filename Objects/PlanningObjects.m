%% ���·���滮 x �� y
%������Ϣ�����յ�λ�á����������
%�滮�������յ���Ϣ
plan_start_x = 0;
plan_start_y = 0;
plan_start_heading = (-5/180)*pi;
plan_start_kappa = 0.0;
plan_end_x = 10;
plan_end_y = 2;
plan_end_heading = (5/180)*pi;%����30��
plan_send_kappa = 0.0;
[trajectory_x,trajectory_y]= Path_S_L(plan_start_x,plan_start_y,plan_start_heading,plan_start_kappa,...
    plan_end_x,plan_end_y,plan_end_heading,plan_send_kappa);
% figure(1);
% plot(trajectory_x,trajectory_y,'.')
%% ���·���滮 x v a
plan_start_s = 0;%���x�����ϵ�λ��
plan_start_s_dot = 2;%�����ٶ� m/s
plan_start_s_dot2 = 0.2;%���ļ��ٶ� m/s^2
plan_end_s = 10 ;%�յ�x�����ϵ�λ��
plan_end_s_dot = 1;%�յ���ٶ� m/s
plan_end_dot2 = 0.1;%�յ�ļ��ٶ� m/s^2
recommend_T = 5;%Ԥ��ʱ��
[trajectory_s,trajectory_v,trajectory_a] = Path_S_T(plan_start_s,plan_start_s_dot,plan_start_s_dot2,...
        plan_end_s,plan_end_s_dot,plan_end_dot2,recommend_T);
% figure(2);
% plot(trajectory_s);
% figure(3);
% plot(trajectory_v);
% figure(4);
% plot(trajectory_a);

%% ���Բ�ֵ�켣���
final_trajectory_x = trajectory_s;
final_trajectory_y = [];
final_trajectory_theta = [];
final_trajectory_kappa = [];
final_trajectory_v = trajectory_v;
final_trajectory_a = trajectory_a;
index = length(trajectory_s);
for i = 1 : index
    final_trajectory_y(i) = interp1(trajectory_x(1:end),trajectory_y(1:end),trajectory_s(i));
end
plot(final_trajectory_x,final_trajectory_y,'.')
%final_trajectory_y(end) = 
%% cal_heading_kappa
%[final_trajectory_theta ,final_trajectory_kappa] = cal_heading_kappa(final_trajectory_x,final_trajectory_y);











