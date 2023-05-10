L = 0.139;
W = 0.083;

xvar = -0.0170;
yvar = 0.0090;


coorbegin_btof = {[L/2+xvar+0.02;-W/2-yvar;-0.06],[L/2+xvar;W/2+yvar;-0.07],[-L/2+xvar;W/2+yvar;-0.07],[-L/2+xvar;-W/2-yvar;-0.07]}; % coor begin body to feet
coorbegin_btoc = {[L/2;-W/2;0;1],[L/2;W/2;0;1],[-L/2;W/2;0;1],[-L/2;-W/2;0;1]} ;% coor begin body to coxa    

%Comunication_code
    vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
    vrep.simxFinish(-1); % just in case, close all opened connections
    clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
if (clientID>-1)
        disp('Connected to remote API server');
     
            hanuT = [];%handle nummpy target
            hanuC = []; %handle numpy coxa
            
             
           [returnCode,hanuT(1)] = vrep.simxGetObjectHandle(clientID,'targetLeg1',vrep.simx_opmode_blocking);
           [returnCode,hanuT(2)] = vrep.simxGetObjectHandle(clientID,'targetLeg2',vrep.simx_opmode_blocking);
           [returnCode,hanuT(3)] = vrep.simxGetObjectHandle(clientID,'targetLeg3',vrep.simx_opmode_blocking);
           [returnCode,hanuT(4)] = vrep.simxGetObjectHandle(clientID,'targetLeg4',vrep.simx_opmode_blocking);
           
           [returnCode,hanuC(1)] = vrep.simxGetObjectHandle(clientID,'coxa1',vrep.simx_opmode_blocking);
           [returnCode,hanuC(2)] = vrep.simxGetObjectHandle(clientID,'coxa2',vrep.simx_opmode_blocking);
           [returnCode,hanuC(3)] = vrep.simxGetObjectHandle(clientID,'coxa3',vrep.simx_opmode_blocking);
           [returnCode,hanuC(4)] = vrep.simxGetObjectHandle(clientID,'coxa4',vrep.simx_opmode_blocking);
           
            

               Pos=[0;0; 0; 0];
               Ori=[0 0 0];
               
               temp ={};
               
                [returnCode,Pos(1)]=vrep.simxGetFloatSignal(clientID,'dXtoClient',vrep.simx_opmode_streaming);
                [returnCode,Pos(2)]=vrep.simxGetFloatSignal(clientID,'dYtoClient',vrep.simx_opmode_streaming);
                [returnCode,Pos(3)]=vrep.simxGetFloatSignal(clientID,'dZtoClient',vrep.simx_opmode_streaming);
                [returnCode,Ori(1)]=vrep.simxGetFloatSignal(clientID,'RolltoClient',vrep.simx_opmode_streaming);
                [returnCode,Ori(2)]=vrep.simxGetFloatSignal(clientID,'PitchtoClient',vrep.simx_opmode_streaming);
                [returnCode,Ori(3)]=vrep.simxGetFloatSignal(clientID,'YawtoClient',vrep.simx_opmode_streaming);
                pause(0.1);

              %  fapo = [];%failed position
              %  faor = [];% failed orientation
            while(1>0)
                [fapo1,Pos(1)]=vrep.simxGetFloatSignal(clientID,'dXtoClient',vrep.simx_opmode_buffer);
                [fapo2,Pos(2)]=vrep.simxGetFloatSignal(clientID,'dYtoClient',vrep.simx_opmode_buffer);
                [fapo3,Pos(3)]=vrep.simxGetFloatSignal(clientID,'dZtoClient',vrep.simx_opmode_buffer);
                [faor1,Ori(1)]=vrep.simxGetFloatSignal(clientID,'RolltoClient',vrep.simx_opmode_buffer);
                [faor2,Ori(2)]=vrep.simxGetFloatSignal(clientID,'PitchtoClient',vrep.simx_opmode_buffer);
                [faor3,Ori(3)]=vrep.simxGetFloatSignal(clientID,'YawtoClient',vrep.simx_opmode_buffer);
                %disp(faor);
                %disp(Ori);
                for i=1:4
                    if(faor1~=1 & faor2~=1 & faor3~=1 & fapo1~=1 & fapo2~=1 & fapo3~=1 )
                        coorbegin_btoc = {[L/2;-W/2;0;1]+Pos,[L/2;W/2;0;1]+Pos,[-L/2;W/2;0;1]+Pos,[-L/2;-W/2;0;1]+Pos} ;% coor begin body to coxa    
                        
                        
                        
                        
                        temp{i} = solve(coorbegin_btoc{i},coorbegin_btof{i},[Ori(1)*pi/180 Ori(2)*pi/180 Ori(3)*pi/180]);
                       [returnCode]=vrep.simxSetObjectPosition(clientID,hanuT(i),hanuC(i),[temp{i}(1) temp{i}(2) temp{i}(3) ],vrep.simx_opmode_oneshot);
        
                    end
                end   
               % pause(0.5);
            end
      

         vrep.simxFinish(-1);
else
    disp('fail');
end
  
    disp('End');
 vrep.delete();
 
 
 %%%%%%%%%%% Al_code

 
function temp = Rx(roll)% quay quanh x
    temp = [1 0 0  0;0 cos(roll) -sin(roll) 0; 0 sin(roll) cos(roll) 0; 0 0 0 1];

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

function temp = transform (coor,trans,pos) %tinh goc toa do moi T01
   temp = RTmatrix(trans,pos)*coor; 
end

function temp = solve(coorbegin_btoc,wanted_coor,orien) %temp!!: coor frame 0 to frame 4
    
    new_posifc = transform(coorbegin_btoc,orien, [0 0 0 ]);%1*4
    RTm_btoc   = RTmatrix(orien,new_posifc(1:3)) ;%RT matrix body to coxa 4x4
    RTm_btof   = RTmatrix([0 0 0],wanted_coor');%RT matrix body to feet 4x4
    RTm_ctof   = (inv(RTm_btoc))*RTm_btof;%RT matrix coxa to feet 4x4
    
    temp = RTm_ctof*[0 0 0 1]';
end


