clc;
clear;
close all;
%% ������·���滮
%jubobolv
clc;
clear;
close all;
%% ������Ϣ ·�� ·��
road_width = 3.6;
road_length = 40;
%��� �ϰ���� Ŀ���
P0=[2 2];
Pob=[10 2.2;
     18 5.4;
     30 4;];
Pg=[39 5.5];
P=[P0;Pob;Pg];
i=1;
%% ���������߼��㡡����˼·Pt��(1-t)*P1+t*P2
for t=0:0.01:1
    % һ�α���������
    p_t_1=(1-t)*P(1,:)+t*P(2,:);
    p_t_2=(1-t)*P(2,:)+t*P(3,:);
    p_t_3=(1-t)*P(3,:)+t*P(4,:);
    p_t_4=(1-t)*P(4,:)+t*P(5,:);
    % ���α���������
    pp_t_1=(1-t)*p_t_1+t*p_t_2;
    pp_t_2=(1-t)*p_t_2+t*p_t_3;
    pp_t_3=(1-t)*p_t_3+t*p_t_4;
    % ���α���������
    ppp_t_1=(1-t)*pp_t_1+t*pp_t_2;
    ppp_t_2=(1-t)*pp_t_2+t*pp_t_3;
    % �Ĵα���������
    pppp_t(i,:)=(1-t)*ppp_t_1+t*ppp_t_2;
    i=i+1;
end
%% ��ͼ
figure
% ��·�������
fill([0 road_length road_length 0],[0 0 2*road_width 2*road_width],[0.5,0.5,0.5]);
 
hold on
%�����м��ߣ��������м䣩
plot([0 road_length],[road_width road_width],'--w','linewidth',2);
%���
plot(P0(:,1),P0(:,2),'*b');
%�ϰ����
plot(Pob(:,1),Pob(:,2),'ob');
%Ŀ���
plot(Pg(:,1),Pg(:,2),'pm');
%���Ʊ������滮��·����
plot(pppp_t(:,1),pppp_t(:,2),'.r');
 
axis equal
set(gca,'XLim',[0 road_length])
set(gca,'YLim',[0 2*road_width])




