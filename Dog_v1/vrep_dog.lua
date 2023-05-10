function sysCall_init()
    


    simbase = sim.getObject('.')
    --simpitch = sim.getObject('./dummypitch')
    --simknee = sim.getObject('./dummyknee')
    tipleg = sim.getObject('./tipLeg4')
    local simBase = sim.getObject('.')
    dogBase = sim.getObject('./base')
    legBase = sim.getObject('./legBase')
    

    simLegTips={}
    simroll={}
    simpitch={}
    simknee={}
    
    for i=1,4,1 do
        simLegTips[i] = sim.getObject('./tipLeg'..i)
        simroll[i]    = sim.getObject('./roll'..i)
        simpitch[i]   = sim.getObject('./pitch'..i)
        simknee[i]    = sim.getObject('./knee'..i)
    end
    
    stepLegindex = {1,2,3,4}
    
    initialPos = {}
    currentPos = {}
    for i=1,4,1 do
        initialPos[i] = sim.getObjectPosition(simLegTips[i],legBase)
    end
     dem = 0
     times = 0
     vel = 0.65
     L1=0.05
     L2=0.05
     dr = 90
     rot = 0
     hstep = 0.01*0
     astep = 0.02*0
     z_begin=0.07 --z
     y_begin=0.010 --y
     x_begin = 0
     pi = math.pi
     T = 1
     k = 7
     T2 = (2*T)/(k+1) -- T1 = 3T2
     T1 = k*T2
    

    corout = coroutine.create(pr)
    offset ={0,0,0}--{x,y,z)




end

function sysCall_actuation()
    -- put your actuation code here
    coroutine.resume(corout)
    t = sim.getSimulationTimeStep()
    
  
   
    for i=1,4,1 do
    prg = (times+ (stepLegindex[i] - 1) / 2 )%T
    offset={0,0,0}
    --if(prg> 0.25 and prg <0.75)   then  offset[3] = -hstep * math.sin(2*math.pi*(prg-0.25)) end
    --if((i==1 or i==3) and rot==1) then  offset[2] = astep*math.sin(2*math.pi*prg)*math.cos(pi*dr/180)
  --  else                                offset[2] = -astep*math.sin(2*math.pi*prg)*math.cos(pi*dr/180)
   -- end
    --offset[2] = astep*math.sin(2*math.pi*prg)*math.cos(pi*dr/180)
                                        --offset[1] = astep * math.sin(2*math.pi*prg)*math.sin(pi*dr/180)
                                        
    if(prg < T1/4) then 
    
    
        offset[1] = astep * -math.sin(2*math.pi/T1*prg)*math.sin(pi*dr/180)
        offset[2] = astep * -math.sin(2*math.pi/T1*prg)*math.cos(pi*dr/180)
        offset[3] = 0 
    
    elseif(prg>(T1/4+T2/2)) then
    
        offset[1] = astep * math.cos(2*math.pi/T1*(prg-T1/4-T2/2))*math.sin(pi*dr/180)
        offset[2] = astep * math.cos(2*math.pi/T1*(prg-T1/4-T2/2))*math.cos(pi*dr/180)
        offset[3] = 0 
    
    else 
    
        offset[1] = astep * -math.cos(2*math.pi/T2*(prg-T1/4))*math.sin(pi*dr/180)
        offset[2] = astep * -math.cos(2*math.pi/T2*(prg-T1/4))*math.cos(pi*dr/180)
        offset[3] = hstep *  -math.sin(2*math.pi/T2*(prg-T1/4)) 
    
    end
    
    
    apply(x_begin+offset[1] ,y_begin+offset[2],z_begin+offset[3],i)
    end  
       
    times = times + t*vel
       
end

function sysCall_sensing()
    -- put your sensing code here
end

function sysCall_cleanup()
    -- do some clean-up here

end

function pr()
    --setdata(0,0,0)
    sim.wait(3)
    setdata(0.02,0.017,0)
    sim.wait(10)


        



end

setdata = function(amplitude,height,direct)
    
    astep = amplitude
    hstep = height
    dr = direct

        

end


function check23(index)

    if(index==2 or index == 3) then return -1 
    else return 1 end
    




end
function check1(index)
    if(rot==1) then return 1
    elseif(index ==1 or index == 2 ) then return 1
    else return -1 end
    
end

function apply(x,y,z,index)
    local r1 =0 --alpha
    local r2 = 0--bu cua beta
    local r3  =0--gamma
    
     l_sq = x^2+y^2+z^2 
    
    r1 = math.atan(x/z)
    r3 = pi-math.acos((L1^2+L2^2-l_sq)/(2*L1*L2))
    r2 = pi/2 - (math.atan2(math.sqrt(x^2+z^2),y) + math.acos((L1^2+l_sq-L2^2)/(2*L1*math.sqrt(l_sq))))
 
    
    
        sim.setJointTargetPosition(simroll[index],r1*check1(index))
        sim.setJointTargetPosition(simpitch[index],r2*check23(index))
        sim.setJointTargetPosition(simknee[index],r3*check23(index))


    
   print (r2*180/pi.." "..index)
  -- print(z.." "..index)
   --print (r2*180/pi)
    --print(l.." "..l1.." "..l2)
--print((L1^2+l_sq-L2^2)/(2*L1*math.sqrt(l_sq)))
    --print(l_sq)


end



-- See the user manual or the available code snippets for additional callback functions and details
