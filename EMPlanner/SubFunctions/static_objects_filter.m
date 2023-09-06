function [filter_static_objects] = static_objects_filter(ego, static_objects)
% �ú�����ɸѡ�ϰ������[-10,60] ����[-10,10]���ϰ���Żᱻ����
% �ú���ֻ��һ�ֵ���������ʱ�취�����ǵ��೵���������ʹ�ϰ�������ԶҲӦ�ÿ���
% EM Planner��ȫ���Ƕ೵�����м���ģ�ÿ�����������ɲο���Ȼ���м���������켣����ѡ�����ŵĹ켣��Ϊ���
object = struct('valid',0,'x',0,'y',0,'v',0,'a',0,'length',0,'width',0,'heading',0);
filter_static_objects = repmat(object,10,1);%��̬�ϰ���Ĭ��10��
count = 1;
for i = 1:length(static_objects)
    if static_objects(i).valid == 0
        continue;
    end
    %�Գ���heading�ķ��������뷨����
    tor = [cos(ego.heading);sin(ego.heading)];
    nor = [-sin(ego.heading);cos(ego.heading)];
    %�ϰ������Գ��ľ�������
    vector_obs = [static_objects(i).x;static_objects(i).y] - [ego.x;ego.y];
    %�ϰ����������
    lon_distance = vector_obs'*tor;
    %�ϰ���������
    lat_distance = vector_obs'*nor;
    
    if (lon_distance < 60) && (lon_distance > -10) && (lat_distance > -10) && (lat_distance < 10)
        filter_static_objects(count).x = static_objects(i).x;
        filter_static_objects(count).y = static_objects(i).y;
        filter_static_objects(count).heading = static_objects(i).heading;
        filter_static_objects(count).v = static_objects(i).v;
        filter_static_objects(count).length = static_objects(i).length;
        filter_static_objects(count).width = static_objects(i).width;
        filter_static_objects(count).valid = 1;
        count = count + 1;
    end
end