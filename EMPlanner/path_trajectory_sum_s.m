function [trajectory_s_end,trajectory_index2s] = path_trajectory_sum_s(trajectory_x,trajectory_y)
% �ú�����������trajectory��s �� x y �Ķ�Ӧ��ϵ�����Կ�����trajectory index2s
n = length(trajectory_x);
trajectory_index2s = zeros(n,1);
sum = 0;
for i = 2:length(trajectory_x)
    if isnan(trajectory_x(i))
        break;
    end
    sum = sum + sqrt((trajectory_x(i) - trajectory_x(i-1))^2 + (trajectory_y(i) - trajectory_y(i-1))^2);
    trajectory_index2s(i) = sum;
end
% �����trajectory�ĳ���
if i == n
    trajectory_s_end = trajectory_index2s(end);
else
    % ��Ϊѭ�����˳�����Ϊisnan(trajectory_x(i)) ���� i ����Ӧ����Ϊ nan 
    trajectory_s_end = trajectory_index2s(i - 1);
end
