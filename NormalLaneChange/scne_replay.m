%%�����·���  
LaneWidth = 4;%
LaneLength = 800;%·��800��
global_path_x = 0: 0.2 : LaneLength;%
num1 = uint16(length(global_path_x));%������ٸ���
global_path_y = zeros(1,num1);
leftLaneMarker = global_path_y + LaneWidth;%�󳵵��ߵ�y����ֵ
rightLaneMarker = global_path_y - LaneWidth; 
leftleftLaneMarker = leftLaneMarker + LaneWidth;
rightrightLaneMarker = rightLaneMarker - LaneWidth;
%%
%��ʾ�Գ�λ��   %%���ƹ켣��
%plot(global_path_x,global_path_y,'b--',  global_path_x,leftLaneMarker,'k-', global_path_x,rightLaneMarker,'k-');
for i = 1 : tra_num
    plot(global_path_x,global_path_y,'b--',  global_path_x,leftLaneMarker,'k-', global_path_x,rightLaneMarker,'k-');
    EgoWidth = 2;%����
    EgoLength = 5;
    EgoPosX = position_arr(i);
    EgoPosY = 0;
    EgoHeading = 0;
    EgoColor = [0.9 0.9 0.9 0.9];
    Boxyx = zeros(1,4);
    Boxyy = zeros(1,4);
    Boxyx(1) = EgoPosX - EgoWidth/2*sin(EgoHeading);
    Boxyy(1) = EgoPosY + EgoWidth/2*cos(EgoHeading);
    Boxyx(2) = EgoPosX + EgoWidth/2*sin(EgoHeading);
    Boxyy(2) = EgoPosY - EgoWidth/2*cos(EgoHeading);
    Boxyx(3) = Boxyx(2) + EgoLength*cos(EgoHeading);
    Boxyy(3) = Boxyy(2) + EgoLength*sin(EgoHeading);
    Boxyx(4) = Boxyx(1) + EgoLength*cos(EgoHeading);
    Boxyy(4) = Boxyy(1) + EgoLength*sin(EgoHeading);
    patch(Boxyx,Boxyy,EgoColor);
    axis([EgoPosX-30,EgoPosX+30,-30,30]);%���귶Χ
    %������ڵ�ǰ��
    objWidth = 2;
    objLength = 5;
    objPosX = position_side_front + velocity_side_front * 0.1 * i;
    objPosY = -4;
    objHeading = 0;
    objColor = [0.9 0.9 0.9 0.9];
    Boxyx(1) = objPosX - objWidth/2*sin(objHeading);
    Boxyy(1) = objPosY + objWidth/2*cos(objHeading);
    Boxyx(2) = objPosX + objWidth/2*sin(objHeading);
    Boxyy(2) = objPosY - objWidth/2*cos(objHeading);
    Boxyx(3) = Boxyx(2) + objLength*cos(objHeading);
    Boxyy(3) = Boxyy(2) + objLength*sin(objHeading);
    Boxyx(4) = Boxyx(1) + objLength*cos(objHeading);
    Boxyy(4) = Boxyy(1) + objLength*sin(objHeading);
    patch(Boxyx,Boxyy,objColor);
    %������ڵĺ�
    objWidth = 2;
    objLength = 5;
    objPosX = position_side_rear + velocity_side_rear * 0.1 * i;
    objPosY = -4;
    objHeading = 0;
    objColor = [0.9 0.9 0.9 0.9];
    Boxyx(1) = objPosX - objWidth/2*sin(objHeading);
    Boxyy(1) = objPosY + objWidth/2*cos(objHeading);
    Boxyx(2) = objPosX + objWidth/2*sin(objHeading);
    Boxyy(2) = objPosY - objWidth/2*cos(objHeading);
    Boxyx(3) = Boxyx(2) + objLength*cos(objHeading);
    Boxyy(3) = Boxyy(2) + objLength*sin(objHeading);
    Boxyx(4) = Boxyx(1) + objLength*cos(objHeading);
    Boxyy(4) = Boxyy(1) + objLength*sin(objHeading);
    patch(Boxyx,Boxyy,objColor);
    %ǰ��
    objWidth = 2;
    objLength = 5;
    objPosX = position_front + velocity_front * 0.1 * i;
    objPosY = 0;
    objHeading = 0;
    objColor = [0.9 0.9 0.9 0.9];
    Boxyx(1) = objPosX - objWidth/2*sin(objHeading);
    Boxyy(1) = objPosY + objWidth/2*cos(objHeading);
    Boxyx(2) = objPosX + objWidth/2*sin(objHeading);
    Boxyy(2) = objPosY - objWidth/2*cos(objHeading);
    Boxyx(3) = Boxyx(2) + objLength*cos(objHeading);
    Boxyy(3) = Boxyy(2) + objLength*sin(objHeading);
    Boxyx(4) = Boxyx(1) + objLength*cos(objHeading);
    Boxyy(4) = Boxyy(1) + objLength*sin(objHeading);
    patch(Boxyx,Boxyy,objColor);
    pause(0.2);
end