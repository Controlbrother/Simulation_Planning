function [s_set,l_set] = Cartesian2Frenet_sl(x_set,y_set,frenet_path_x,frenet_path_y,...
    proj_x_set,proj_y_set,proj_heading_set,proj_match_point_index_set,index2s)
    %�ú�����������������ϵ�µ�x_set��y_set�ϵĵ���frenet_path�µ�����s l
    %���� x_set,y_set ������ת���ĵ�
    %     frenet_path_x,frenet_path_y   frenet������
    %     proj_x,y,heading,kappa,proj_match_point_index ������ת���ĵ��ͶӰ�����Ϣ
    %     index2s   frenet_path��index��s��ת����

    % ���ڲ�֪���ж��ٸ�����Ҫ������ת����������Ҫ������
    n = length(x_set);%��ദ��128����
    %�����ʼ��
    s_set = ones(n,1)*nan;
    l_set = ones(n,1)*nan;
    for i = 1:length(x_set)
        if isnan(x_set(i))
            break;
        end
        %����s��д���Ӻ���
        s_set(i) = CalcSFromIndex2S(index2s,frenet_path_x,frenet_path_y,proj_x_set(i),proj_y_set(i),...
            proj_match_point_index_set(i));
        n_r = [-sin(proj_heading_set(i));cos(proj_heading_set(i))];
        r_h = [x_set(i);y_set(i)];
        r_r = [proj_x_set(i);proj_y_set(i)];
        l_set(i) = (r_h - r_r)'*n_r;
    end
end

function s = CalcSFromIndex2S(index2s,path_x,path_y,proj_x,proj_y,proj_match_point_index)
  %�ú��������㵱ָ��index2s��ӳ���ϵ�󣬼����proj_x,proj_y�Ļ���
  vector_1 = [proj_x;proj_y] - [path_x(proj_match_point_index);path_y(proj_match_point_index)];
  %����Ҫ���ǵĸ�ȫ��һЩ����ΪҪ���ǵ�proj_match_point_index�п�����path�������յ�
  if (proj_match_point_index < length(path_x))
      vector_2 = [path_x(proj_match_point_index + 1);path_y(proj_match_point_index + 1)] - ...
          [path_x(proj_match_point_index);path_y(proj_match_point_index)];
  else
      vector_2 = [path_x(proj_match_point_index);path_y(proj_match_point_index)] - ...
          [path_x(proj_match_point_index - 1);path_y(proj_match_point_index - 1)];
  end
  
  if vector_1'*vector_2 > 0
      s = index2s(proj_match_point_index) + sqrt(vector_1'*vector_1);
  else
      s = index2s(proj_match_point_index) - sqrt(vector_1'*vector_1);
  end
end









