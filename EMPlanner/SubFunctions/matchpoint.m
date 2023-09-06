function [match_point_index,proj_x, proj_y,proj_heading,proj_kappa] = matchpoint(...
    x,y,path_x,path_y,path_heading,path_kappa)

match_point_index = 0;
% ����increase_count�����ڱ�ʾ�ڱ���ʱdistance�������ӵĸ���
increase_count = 0;
% ��ʼ����
min_distance = inf;
for j = 1 : length(path_x)
    distance = (x - path_x(j))^2 + (y - path_y(j))^2;
    if distance < min_distance
        min_distance = distance;
        match_point_index = j;
        increase_count = 0;
    else
        increase_count = increase_count + 1;
    end
    %���distance��������50�ξͲ�Ҫ�ٱ����ˣ���ʡʱ��
    if increase_count > 50
        break;
    end
end
%ȡ��ƥ������Ϣ
match_point_x = path_x(match_point_index);
match_point_y = path_y(match_point_index);
match_point_heading = path_heading(match_point_index);
match_point_kappa = path_kappa(match_point_index);
%����ƥ���ķ��������뷨����
vector_match_point = [match_point_x;match_point_y];
vector_match_point_direction = [cos(match_point_heading);sin(match_point_heading)];
%������ͶӰ���λʸ
vector_r = [x;y];

%ͨ��ƥ������ͶӰ��
vector_d = vector_r - vector_match_point;
ds = vector_d' * vector_match_point_direction;
vector_proj_point = vector_match_point + ds * vector_match_point_direction;
proj_heading = match_point_heading + match_point_kappa * ds;
proj_kappa = match_point_kappa;
%���������
proj_x = vector_proj_point(1);
proj_y = vector_proj_point(2);
end

