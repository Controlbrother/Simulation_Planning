function index2s  = get_referenceline_s(path_x,path_y,origin_x,origin_y,origin_match_point_index)
%�ú��������index��s��ת����ϵ��index2s��ʾ��path_x,path_y����ɢ��ı��Ϊiʱ����Ӧ�Ļ���Ϊindex2s(i)
%���� path_x path_y ��ת������ɢ��ļ���
%     origin_x,y frenetԭ������������ϵ�µ�����
%     origin_match_point_index ԭ���ƥ���ı��
% path��ĸ���
n = length(path_x);
% �����ʼ��
index2s = zeros(n,1);
% ���ȼ�����path���Ϊ����ԭ���index2s
for i = 2:n
    index2s(i) = sqrt((path_x(i) - path_x(i-1))^2 + (path_y(i) - path_y(i-1))^2) + index2s(i-1);
end
% �ټ����Թ켣��㵽frenet_path������ԭ��Ļ�������Ϊs0������index2s - s0 �������յĽ��
% ����s0
% s_temp frenetԭ���ƥ���Ļ���
s_temp = index2s(origin_match_point_index);
%�ж�ԭ����ƥ����ǰ�滹�Ǻ���
%��������match_point_to_origin 
%        match_point_to_match_point_next
vector_match_2_origin = [origin_x;origin_y] - [path_x(origin_match_point_index);path_y(origin_match_point_index)];
vector_match_2_match_next = [path_x(origin_match_point_index + 1);path_y(origin_match_point_index + 1)] - ...
                            [path_x(origin_match_point_index);path_y(origin_match_point_index)];
if vector_match_2_origin'*vector_match_2_match_next > 0
    %����ԭ����ƥ����ǰ��
    s0 = s_temp + sqrt(vector_match_2_origin'*vector_match_2_origin);
else
    %����ԭ����ƥ���ĺ���
    s0 = s_temp - sqrt(vector_match_2_origin'*vector_match_2_origin);
end

index2s = index2s - ones(n,1)*s0;














