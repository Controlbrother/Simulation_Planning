function [l_min, l_max, dp_path_s] = generate_convex_space_path(consider_static_objects_set, plan_start_s)
static_object_num = 10;
% lane keep ͹�ռ䣬�ȳ�ʼ��Ϊ-2 �� 2���ٴ���̬�ϰ���
% �Թ滮�������ǰ80�� ds = 1
sample_s = 1;
dp_path_s = ones(80,1);
for i = 1:80
    dp_path_s(i) = plan_start_s + (i - 2) * sample_s;
end
l_min = ones(1,80)*-2;%�Գ���1.6��
l_max = ones(1,80)*2;
%���ݾ�̬�ϰ�����Сl��͹�ռ�
for i = 1 : static_object_num
    if consider_static_objects_set(i).id == 0
        continue;
    end
    if consider_static_objects_set(i).decision == 1 %decision = 1 nudge
        %���� min_s �� max_s �ҵ���ʼ�ĵ�index
        start_index = inf;
        end_index = inf;
        %���� start index ���� end_index
        for j = 1 : length(dp_path_s) - 1 
            if dp_path_s(j) <= consider_static_objects_set(i).min_s && ...
                dp_path_s(j+1) >= consider_static_objects_set(i).min_s 
                start_index = max(j - 2,1);%�������һ����
                for z = 1 : length(dp_path_s) - 1
                    if dp_path_s(z) <= consider_static_objects_set(i).max_s && ...
                        dp_path_s(z+1) >= consider_static_objects_set(i).max_s 
                        end_index = min(z + 3,length(dp_path_s));%��ǰ����һ����
                    end
                end
            end
        end
        if start_index ~= inf && end_index ~= inf && (start_index <= end_index)
            %�ж�������  1 is site = right 
            if consider_static_objects_set(i).site(1) == 1
                for k = start_index : end_index
                    l_min(k) = max(consider_static_objects_set(i).max_l + 0.2, l_min(k));
                end
            elseif consider_static_objects_set(i).site(1) == 2 % 2 is site = left 
                for k = start_index : end_index
                    l_max(k) = min(consider_static_objects_set(i).min_l - 0.2, l_max(k));
                end
            else
                 %static in middle stop
            end
        end
    end
end

end