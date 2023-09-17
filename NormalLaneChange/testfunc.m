
% ��� cut in ��  �յ�
start_s = 50;
cut_in_s = 100;
[path_x, path_y] = bezier_curve(start_s,cut_in_s);
plot(path_x, path_y, 'r.');
axis([40,160,-50,50]);
[path_heading,path_kappa] = CalcPathHeadingAndKappa(path_x,path_y);
% path��ĸ���
n = length(path_x);
% �����ʼ��
path_s = zeros(n,1);
% ���ȼ�����path���Ϊ����ԭ���path_s
for i = 2:n
    path_s(i) = sqrt((path_x(i) - path_x(i-1))^2 + (path_y(i) - path_y(i-1))^2) + path_s(i-1);
end

%     trajectory_x(i) = interp1(path_s(1:index),trajectory_x_init(1:index),s(i));
%     trajectory_y(i) = interp1(path_s(1:index),trajectory_y_init(1:index),s(i));
%     trajectory_heading(i) = interp1(path_s(1:index),trajectory_heading_init(1:index),s(i));
%     trajectory_kappa(i) = interp1(path_s(1:index),trajectory_kappa_init(1:index),s(i));


function [path_x, path_y] = bezier_curve(start_s,cut_in_s)
%��� �ϰ���� Ŀ���
P0=[start_s 0];
Pob=[cut_in_s 0;
     cut_in_s -4
     ];
Pg=[cut_in_s*2 -4];
P=[P0;Pob;Pg];
i=1;
%% ���������߼��㡡����˼·Pt��(1-t)*P1+t*P2
for t=0:0.01:1
    % һ�α���������
    p_t_1=(1-t)*P(1,:)+t*P(2,:);
    p_t_2=(1-t)*P(2,:)+t*P(3,:);
    p_t_3=(1-t)*P(3,:)+t*P(4,:);
    % ���α���������
    pp_t_1=(1-t)*p_t_1+t*p_t_2;
    pp_t_2=(1-t)*p_t_2+t*p_t_3;
    % ���α���������
    ppp_t(i,:)=(1-t)*pp_t_1+t*pp_t_2;
    i=i+1;
end
path_x = ppp_t(:,1);
path_y = ppp_t(:,2);
end


