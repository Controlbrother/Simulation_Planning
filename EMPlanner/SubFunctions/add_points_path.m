function [qp_path_s_final,qp_path_l_final, qp_path_dl_final,qp_path_ddl_final] =...
    add_points_path(qp_path_s,qp_path_l,qp_path_dl,qp_path_ddl)
% �ú���������qp_path
n_init = 60;
% ���ܵĵ�ĸ���
n = 120;
% �����ʼ��
qp_path_s_final = zeros(n,1);
qp_path_l_final = zeros(n,1);
qp_path_dl_final = zeros(n,1);
qp_path_ddl_final = zeros(n,1);
ds = (qp_path_s(end) - qp_path_s(1))/(n-1);
index = 1;
for i = 1:n
    x = qp_path_s(1) + (i-1) * ds;
    qp_path_s_final(i) = x;
    while x >= qp_path_s(index)
        index = index + 1;
        if index == n_init
            break;
        end
    end
    % while ѭ���˳���������x<qp_path_s(index)������x��Ӧ��ǰһ��s�ı����index-1 ��һ�������index
    pre = index - 1;
    cur = index;
    % ����ǰһ�����l l' l'' ds �ͺ�һ����� l''
    delta_s = x - qp_path_s(pre);
    l_pre = qp_path_l(pre);
    dl_pre = qp_path_dl(pre);
    ddl_pre = qp_path_ddl(pre);
    ddl_cur = qp_path_ddl(cur);
    % �ֶμӼ��ٶ��Ż� 
    qp_path_l_final(i) = l_pre + dl_pre * delta_s + (1/3)* ddl_pre * delta_s^2 + (1/6) * ddl_cur * delta_s^2;
    qp_path_dl_final(i) = dl_pre + 0.5 * ddl_pre * delta_s + 0.5 * ddl_cur * delta_s;
    qp_path_ddl_final(i) = ddl_pre + (ddl_cur - ddl_pre) * delta_s/(qp_path_s(cur) - qp_path_s(pre));
    %  ��Ϊ��ʱx�ĺ�һ�������index ����x < qp_path_s(index),����һ��ѭ����x = x + ds Ҳδ�ش���
    %  qp_path_s(index)�������ͽ��벻��whileѭ��������index Ҫ����һλ
    index = index - 1;   
end