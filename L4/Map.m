%%�����·���  
LaneWidth = 3;%
LaneLength = 800;%·��800��
global_path_x = 0: 0.2 : LaneLength;%
num1 = uint16(length(global_path_x));%������ٸ���
global_path_y = zeros(1,num1);
leftLaneMarker = global_path_y + LaneWidth/2;%�󳵵��ߵ�y����ֵ
rightLaneMarker = global_path_y - LaneWidth/2; 
leftleftLaneMarker = leftLaneMarker + LaneWidth;
rightrightLaneMarker = rightLaneMarker - LaneWidth; 
%��ʾ�Գ�λ��

for i=1:num1
    plot(global_path_x,leftleftLaneMarker,'k-', global_path_x,rightrightLaneMarker,'k-',  global_path_x,leftLaneMarker,'b--', global_path_x,rightLaneMarker,'b--');
    EgoPosX = global_path_x(i);
    EgoPosY = global_path_y(i);
    EgoHeading = 0/180*pi;%
    EgoWidth = 1.8;%����
    EgoLength = 5;
    EgoColor = [0.9 0.9 0.9 0.9];
    Boxyx(1) = EgoPosX - EgoWidth/2*sin(EgoHeading);
    Boxyy(1) = EgoPosY + EgoWidth/2*cos(EgoHeading);
    Boxyx(2) = EgoPosX + EgoWidth/2*sin(EgoHeading);
    Boxyy(2) = EgoPosY - EgoWidth/2*cos(EgoHeading);
    Boxyx(3) = Boxyx(2) + EgoLength*cos(EgoHeading);
    Boxyy(3) = Boxyy(2) + EgoLength*sin(EgoHeading);
    Boxyx(4) = Boxyx(1) + EgoLength*cos(EgoHeading);
    Boxyy(4) = Boxyy(1) + EgoLength*sin(EgoHeading);
    patch(Boxyx,Boxyy,EgoColor);
    axis([EgoPosX-20,EgoPosX+20,-10,10]);%���귶Χ
    pause(0.1);
end







