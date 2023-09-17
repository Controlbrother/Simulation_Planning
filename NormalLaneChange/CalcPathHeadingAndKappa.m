function [path_heading,path_kappa] = CalcPathHeadingAndKappa(path_x,path_y)
%�ú���������path�����߷�����x��ļнǺ�����
%���룺path_x,y·������
%�����path heading kappa ·����heading������
%ԭ�� heading = arctan(dy/dx);
%     kappa = dheading/ds;
%     ds = (dx^2 + dy^2)^0.5

%ע�⣬�ǶȵĶ�ֵ�Ի�����ܴ���鷳����Ҫ���ش���
%����x �� x + 2pi��������ͬһ���Ƕȣ����ֶ�ֵ���ڼ������ʻ�����鷳
%���� ԭ����(0.1 - (-0.1))/ds��������������-0.1����һ��2pi
%kappa�͵���(0.1 - (-0.1 + 2*pi))/ds�����ʻ��÷ǳ���
%�����������е�ŷ��������headingʱ��(��ʹ��(y2 - y1)/(x2 - x1)�ķ����м���һ���Ƕ� ����(y1 - y0)/(x1
%-x0)�ķ������ּ���һ���Ƕȣ�Ȼ�����������2),�����ȷֵ�� (a1 + a2)/2,�����ռ���Ľ��������(a1 + a2 + 2pi)/2
% ���� tan(x) = tan(x + pi) ����arctan(tan(x))���ܵ���x��Ҳ���ܵ���x + pi
% �ǶȵĴ���ǳ��鷳�����ҽǶȴ����������������ִ����Դͷ

dx = diff(path_x);
dy = diff(path_y);
%���е�ŷ����Ҫ����ǰŷ�������ŷ��������ȷ������Ҳ���ܼ�����Ľ���Ⱦ�ȷֵ��һ��pi
%�������dx,dy���е�ŷ������ʹ�������޷����м���Ƕ�
dx_pre = [dx(1);dx];
dx_after = [dx;dx(end)];
dx_final = (dx_pre + dx_after)/2;

dy_pre = [dy(1);dy];
dy_after = [dy;dy(end)];
dy_final = (dy_pre + dy_after)/2;

ds_final = sqrt(dx_final.^2 + dy_final.^2);
path_heading = atan2(dy_final,dx_final);

dheading = diff(path_heading);
dheading_pre = [dheading(1);dheading];
dheading_after = [dheading;dheading(end)];
dheading_final = (dheading_pre + dheading_after) / 2;
%Ϊ�˷�ֹdheading���ֶ�һ��2pi�Ĵ��󣬼�����ʵ��dheading��С����sin(dheading)����dheading
path_kappa = sin(dheading_final) ./ ds_final;
end