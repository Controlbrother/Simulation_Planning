function [referenceline_x_init,referenceline_y_init,referenceline_heading_init,referenceline_kappa_init] = get_plan_referenceline(...
host_match_point_index,global_path_x,global_path_y,global_path_heading,global_path_kappa)
%�ú�������ȫ��·������ȡreferenceline��δƽ���ĳ�ֵ
%���룺 host_match_point_index �Գ���λ����ȫ��·����ƥ���ı��
       %global_path_x,global_path_y ȫ��·������
%�����referenceline_x_init,referenceline_y_init δƽ���Ĳο��ߵ�xy����

%����global path ��ÿ1mȡһ���㣬���Դ�ƥ�������ȡ30���㣬��ǰȡ150���㼴�ɣ�һ��181����
%����ĵ㲻���Ļ�����ǰ��ĵ㲹��ǰ��ĵ㲻���Ļ����ú���ĵ㲹����֤������181��

%������ʼ��
start_index = -1;
%�жϺ���ǰ��ĵ��Ƿ��㹻��
if host_match_point_index - 5 < 1
    %ƥ������ĵ�̫���ˣ�����30��
    start_index = 1;
elseif host_match_point_index + 20 > length(global_path_x)
    %ƥ���ǰ��ĵ�̫���ˣ�����150��
    start_index = length(global_path_x) - 20;
    
else
    %ƥ����������
    start_index = host_match_point_index - 5;
end
%��ȡreferenceline
referenceline_x_init = global_path_x(start_index:start_index + 40);
referenceline_y_init = global_path_y(start_index:start_index + 40);
referenceline_heading_init = global_path_heading(start_index:start_index + 40);
referenceline_kappa_init = global_path_kappa(start_index:start_index + 40);
end

