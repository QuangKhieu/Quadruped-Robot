function [angles] = IK_solve(L,coor,side)%coor so vo frame coxa
    l1 = L(1);%Lhip
    l2 = L(2); %LThigh
    l3 = L(3); %L shin
    
    %chuan hoa coor
    coor = [1 0 0  0;0 cos(pi) -sin(pi) 0; 0 sin(pi) cos(pi) 0; 0 0 0 1]*[coor;1];
    if (side==1) %side phai chan 3,4
        x = coor(1);
        y = coor(2);
        z = coor(3);
        %check domain
        D1 = (l1^2+l2^2+l3^2 -x^2-y^2-z^2)/(2*l2*l3);
        D2 = (x^2+y^2+z^2+l1^2+l2^2-l3^2)/(2*l2*sqrt(x^2+y^2+z^2-l1^2));
        D1 = checkdomain(D1);
        D2 = checkdomain(D2);      
        % cal
        alpha = atan2(y,z) -atan2(l1,sqrt(y^2+z^2-l1^2))*check(y);
        theta  = acos (D1);
        beta = atan2(x,sqrt(y^2+z^2-l1^2)) - acos(D2)*check(x);  
    elseif(side==0)      %side trai chan 1,2
        x = coor(1);
        y = -coor(2);
        z = coor(3)

        % cal
        D1 = (l1^2+l2^2+l3^2 -x^2-y^2-z^2)/(2*l2*l3);
        D2 = (x^2+y^2+z^2+l1^2+l2^2-l3^2)/(2*l2*sqrt(x^2+y^2+z^2-l1^2));
        D1 = checkdomain(D1);
        D2 = checkdomain(D2);      
        % cal
        alpha = atan2(y,z) -atan2(l1,sqrt(y^2+z^2-l1^2))*check(y)
        theta  = acos (D1);
        beta = atan2(x,sqrt(y^2+z^2-l1^2)) - acos(D2)*check(x);  
    end
    angles = [alpha,beta,theta];
end
function check = check(value)
    if(value>=0)
       check =1; 
    else
        check=-1;
    end
end
function Do = checkdomain(D)
    if (D > 1 || D < -1)
        disp("____OUT OF DOMAIN____")
        if D > 1 
            Do = 0.99
        elseif D < -1
            Do = -0.99
        end
     else
            Do = D;
        end
end

