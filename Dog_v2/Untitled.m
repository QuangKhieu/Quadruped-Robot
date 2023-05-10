

interval = 0.06;
startTime = second(datetime(),'secondofday');
lastTime = startTime;
lt =startTime;
T = 2;
phi = 0;
list_phi =[];
t=1;
temp=[];
% figure(1) 
% hold on;
% grid on;
% for i=0:10
% temp = [temp;calculateBezier_swing(i/10,20,0)];
% plot(temp(:,1),temp(:,3))
% axis([-1 1 0 1])
% pause(0.5)
% end
for k=1:50000
    s = second(datetime(),'secondofday');

    if(s-lastTime>=interval)       
        lastTime = second(datetime(),'secondofday');
        figure(1)
        hold on; grid on;
        if (phi>=0.99)
            lt = second(datetime(),'secondofday');
            clf()
            hold off
        end
        
        phi =  (second(datetime(),'secondofday')-lt)/T;
        list_phi=[list_phi,phi];
        if(phi<=0.25)
            phi_sw=phi/0.25;
            temp = [temp;calculateBezier_swing(phi_sw,20,0)];
            plot(temp(:,1),temp(:,3))
            axis([-2 2 -1 2])
%         plot(t,list_phi)
%         axis([0 40 0 1.2])
        end
        if(phi>0.25)
            phi_st=(phi-0.25)/0.75;
            temp = [temp;calculateStance(phi_st,20,0)];
            plot(temp(:,1),temp(:,3))
            axis([-2 2 -1 2])
%         plot(t,list_phi)
%         axis([0 40 0 1.2])
        end
        t=[t,t(length(t))+1];
        
        
    end
    
    
    
end

c = unique(list_phi);

function temp = f(n,k)
    temp = factorial(n)/(factorial(k)*factorial(n-k));
end

function temp = be(t,k,point)
    n = 9 ;%10 point bezier curve
    temp = point*f(n,k)*t^k*(1-t)^(n-k);
end
function temp = calculateStance(phi_st , V , angle)%phi_st between [0,1), angle in degrees
    c = cos(deg2rad(angle));%cylindrical coordinates
    s = sin(deg2rad(angle));

    A = 0.0005;
    halfStance = 0.05;
    p_stance=halfStance*(1-2*phi_st);

    stanceX =  c*p_stance*abs(V);
    stanceY = -s*p_stance*abs(V);
    stanceZ = -A*cos(pi/(2*halfStance)*p_stance);

    temp =[ stanceX, stanceY , stanceZ];
end
function temp = calculateBezier_swing( phi_sw , V , angle)%phi between [0,1), angle in degrees
        c = cos(deg2rad(angle));%cylindrical coordinates
         s = sin(deg2rad(angle));
        
        X = abs(V)*c*[-0.05 ,
                      -0.06 ,
                      -0.07 , 
                      -0.07 ,
                      0. ,
                      0. , 
                      0.07 ,
                      0.07 ,
                      0.06 ,
                      0.05 ];
    
        Y = abs(V)*s*[ 0.05 ,
                       0.06 ,
                       0.07 , 
                       0.07 ,
                       0. ,
                       -0. , 
                       -0.07 ,
                       -0.07 ,
                       -0.06 ,
                       -0.05 ];
    
        Z = abs(V)*[0. ,
                    0. ,
                    0.05 , 
                    0.05 ,
                    0.05 ,
                    0.06 , 
                    0.06 ,
                    0.06 ,
                    0. ,
                    0. ];
        swingX = 0.;
        swingY = 0.;
        swingZ = 0.;
        for i=0:9 %in range(10): #sum all terms of the curve
            swingX = swingX + be(phi_sw,i,X(i+1)) ;
            swingY = swingY + be(phi_sw,i,Y(i+1));
            swingZ = swingZ + be(phi_sw,i,Z(i+1));
        end
        temp=[ swingX, swingY , swingZ];
end
