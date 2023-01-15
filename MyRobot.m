function [move,mem] = MyRobot(env,mem)
%Strategy for robot tournament game, following opponent
%
%Environment Struct
% field:
% info,  STRUCT{team, fuel, myPos, oppPos}
% basic, STRUCT{walls, rRbt, rMF, lmax}
% mines, STRUCT{nMine, mPos, mineScr, mineExist}
% fuels, STRUCT{nFuel, fPos, fuelScr, fExist}
%
%Memory Struct
% field:
% path, STRUCT{start, dest, pathpt, nPt, proc, lv}

mypos=env.info.myPos;
delekPos = env.fuels.fPos;
fuelDelta =(delekPos - mypos);
closeFuel = 9;
index = 1;

    

opFuel = env.info.fuel_op;
myFuel = env.info.fuel;
opDelta =(env.info.opPos - mypos);
opDist = sqrt( (mypos(1) - env.info.opPos(1))^2 + (mypos(2) - env.info.opPos(2))^2 );

for(ii=1:env.fuels.nFuel)  %FIND CLOSE FUEL
    tempClose = sqrt( (mypos(1) - delekPos(ii,1))^2 + (mypos(2) - delekPos(ii,2))^2 );
    if(( tempClose < closeFuel) && env.fuels.fExist(ii) == 1)
        closeFuel = tempClose;
        index = ii;
    end
end
if(myFuel > opFuel && closeFuel > opDist) %ATTACK
    moveX = opDelta(1);
    moveY = opDelta(2);
elseif(myFuel < opFuel && closeFuel > opDist/1.1) %ESCAPE
    moveX = -opDelta(1);
    moveY = -opDelta(2);

elseif(1 && all(env.fuels.fExist == 0)) %NO MORE FUEL
    if(myFuel > opFuel)
         moveX = opDelta(1); 
         moveY = opDelta(2);
    else
        moveX = -opDelta(1);
        moveY = -opDelta(2);
    end
else                          %CHASE FUEL
moveX = fuelDelta(index, 1);
moveY = fuelDelta(index, 2);
end

if(abs(moveX) > 0.25 && moveX >0) %LMAX FOR NEXT POS CALCULATION
    moveX = 0.25;
elseif(abs(moveX) > 0.25 && moveX <0)
    moveX = -0.25;
end
if(abs(moveY) > 0.25 && moveY >0)
    moveY = 0.25;
    elseif(abs(moveY) > 0.25 && moveY <0)
    moveY = -0.25;
end

nextPos = [mypos(1)+moveX, mypos(2)+moveY];

    


bombPos = env.mines.mPos;
bombDelta =(bombPos - mypos);
avoidRadius = env.basic.rMF + 0.02;
closeBomb = 9;
bIndex = 1;
for(jj=1:env.mines.nMine)         %FIND CLOSE BOMB
    tempCloseB = sqrt( (nextPos(1) - bombPos(jj,1))^2 + (nextPos(2) - bombPos(jj,2))^2 );
    if(( tempCloseB < closeBomb) && env.mines.mExist(jj) == 1)
        closeBomb = tempCloseB;
        bIndex = jj;
    end
end

% WALLS
if(mypos(1) < 0.26)
    if(mypos(2) >9.84)
    move = [0.2, -1];
    else
        move = [0.2, 1];
    end
elseif(mypos(1) >9.84)
    if(mypos(2) > 9.84)
    move = [-0.2, -1];
    else
        move = [-0.2, 1];
    end
elseif(mypos(2) <0.26)
    if(mypos(1) > 9.84)
    move = [-1, 0.2];
    else
        move = [1, 0.2];
    end
elseif(mypos(2) >9.84)
    if(mypos(1) > 9.84)
    move = [-1, -0.2];
    else
        move = [1, -0.2];
    end
 %AVOID BOMBS
elseif(closeBomb < avoidRadius)
    if(mypos(2) > bombPos(bIndex, 2))    %% if bomb is down 
        if(mypos(1) < bombPos(bIndex(1)))   %% if bomb is right X
            if(bombPos(bIndex, 1) > delekPos(index, 1)) %% if bombRightFuel
                move = [bombDelta(bIndex, 2), -bombDelta(bIndex, 1)];
            else
                move = [-bombDelta(bIndex, 2), bombDelta(bIndex, 1)];
            end
        else %% if bomb is left X
            if(bombPos(bIndex, 1) > delekPos(index, 1)) %% if bombRightFuel
                move = [bombDelta(bIndex, 2), -bombDelta(bIndex, 1)];
            else
                move = [-bombDelta(bIndex, 2), bombDelta(bIndex, 1)];
            end
        end
    else %% if bomb is up Y
        if(mypos(1) < bombPos(bIndex(1)))   %% if bomb is right X
            if(bombPos(bIndex, 1) > delekPos(index, 1)) %% if bombRightFuel
                move = [-bombDelta(bIndex, 2), bombDelta(bIndex, 1)];
            else
                move = [-bombDelta(bIndex, 2), bombDelta(bIndex, 1)];
            end
        else %% if bomb is left 
            if(bombPos(bIndex, 1) > delekPos(index, 1)) %% if bombRightFuel
                move = [-bombDelta(bIndex, 2), bombDelta(bIndex, 1)];
            else
                move = [bombDelta(bIndex, 2), -bombDelta(bIndex, 1)];
            end
        end
    
    end


        

else
    move = [moveX,moveY];

end





