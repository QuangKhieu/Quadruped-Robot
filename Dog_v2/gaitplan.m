








new_RT = RTm_ctrans([ 5; 5;0],[0 0 +pi/24]);
cal_ctof([5;5;-5],new_RT)
inv(RTmatrix([0 0 10/180*pi],[0 0 0]))* [1; 0; 0;1];

function temp = Rx(roll)% quay quanh x
 
                temp= [1 0 0  0;0 cos(roll) -sin(roll) 0; 0 sin(roll) cos(roll) 0; 0 0 0 1];
               

end

function temp = Ry(pitch)%QUAY QUANH Y
    temp = [cos(pitch) 0 sin(pitch)  0;0 1 0 0; -sin(pitch) 0 cos(pitch) 0; 0 0 0 1];

end

function temp = Rz(yaw) %quay quanh z
        temp = [cos(yaw) -sin(yaw) 0  0;sin(yaw) cos(yaw) 0 0; 0 0 1 0; 0 0 0 1];
end

function temp = Rxyz(roll,pitch,yaw)%quay tong hop
    if(roll==0 & pitch ==0 & yaw==0)
        temp = eye(4);
    else    
        temp = Rx(roll)*Ry(pitch)*Rz(yaw);
    end
end

function temp = RTmatrix(orien, pos)% create RT matrix 
    roll = orien(1);
    pitch = orien(2);
    yaw  = orien(3);
    x0 = pos(1);
    y0 = pos(2);
    z0 = pos(3);

    trans = [1 0 0 pos(1); 0 1 0 pos(2); 0 0 1 pos(3); 0 0 0 1  ];% Tmatrix
    ros   = Rxyz(roll,pitch,yaw);%Rmatrix

    temp = trans*ros;%4*4
end

function temp = transform (coor,trans,pos) %tinh goc toa do coxa moi  Or transform through 1 coor transform vector
         temp = RTmatrix(trans,pos)*[coor;1]; %4*1
         temp = temp(1:3);%3*1
end

function temp = RTm_ctrans(coor,orien) %RT matrix coxa to body tranform
         new_origin = (RTmatrix(orien,[0 0 0]))*[coor;1];
         temp = RTmatrix (orien,new_origin);

end

function temp = cal_ctof(co_btof,RTm_btoc)
        temp = inv(RTm_btoc)*[co_btof;1];
        temp = temp(1:3);
end

