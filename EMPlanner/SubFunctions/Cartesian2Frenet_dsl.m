function [s_dot_set,l_dot_set,dl_set] = Cartesian2Frenet_dsl(l_set,vx_set,vy_set,proj_heading_set,proj_kappa_set)
%�ú���������frenet����ϵ�µ�s_dot, l_dot, dl/ds
n = length(vx_set);
% �����ʼ��
s_dot_set = ones(n,1)*nan;
l_dot_set = ones(n,1)*nan;
dl_set = ones(n,1)*nan;

for i = 1 : length(l_set)
    if isnan(l_set(i))
        break;
    end
    v_h = [vx_set(i);vy_set(i)];
    n_r = [-sin(proj_heading_set(i));cos(proj_heading_set(i))];
    t_r = [cos(proj_heading_set(i));sin(proj_heading_set(i))];
    l_dot_set(i) = v_h'*n_r;
    s_dot_set(i) = v_h'*t_r/(1 - proj_kappa_set(i)*l_set(i));
    %%%��������cartesian��frenet��ת��Ҫ���򵥣�����Ҳ��ȱ�㣬���������������ٶȼ��ٶ�
    %l' = l_dot/s_dot �������s_dot = 0 �˷�����ʧЧ��
    if abs(s_dot_set(i)) < 1e-6
        dl_set(i) = 0;
    else
        dl_set(i) = l_dot_set(i)/s_dot_set(i);
    end
end


