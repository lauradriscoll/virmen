function code = SingleTower4Cond
% SingleTower4Cond   Code for the ViRMEn experiment SingleTower4Cond.
%   code = SingleTower4Cond   Returns handles to the functions that ViRMEn
%   executes during engine initialization, runtime and termination.


% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT

% --- INITIALIZATION code: executes before the ViRMEN engine starts.
function vr = initializationCodeFun(vr)

vr.debugMode = true;
vr.mouseNum = 999;
vr.mulRewards = 0;

%initialize important cell information
vr.conds = {'Black Left','Black Right','White Left','White Right'};

vr = initializePathVIRMEN(vr);

%Define indices of walls
vr.LeftWallBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.LeftWallBlack,:);
vr.RightWallBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.RightWallBlack,:);
vr.BackWallBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.BackWallBlack,:);
vr.RightArmWallBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.RightArmWallBlack,:);
vr.LeftArmWallBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.LeftArmWallBlack,:);
vr.LeftEndWallBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.LeftEndWallBlack,:);
vr.RightEndWallBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.RightEndWallBlack,:);
vr.TTopWallLeftBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.TTopWallLeftBlack,:);
vr.TTopWallRightBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.TTopWallRightBlack,:);
vr.LeftWallWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.LeftWallWhite,:);
vr.RightWallWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.RightWallWhite,:);
vr.BackWallWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.BackWallWhite,:);
vr.RightArmWallWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.RightArmWallWhite,:);
vr.LeftArmWallWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.LeftArmWallWhite,:);
vr.LeftEndWallWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.LeftEndWallWhite,:);
vr.RightEndWallWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.RightEndWallWhite,:);
vr.TTopWallLeftWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.TTopWallLeftWhite,:);
vr.TTopWallRightWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.TTopWallRightWhite,:);
vr.WhiteLeftTower = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.WhiteLeftTower,:);
vr.WhiteRightTower = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.WhiteRightTower,:);
vr.BlackLeftTower = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.BlackLeftTower,:);
vr.BlackRightTower = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.BlackRightTower,:);

%Define groups for mazes
beginBlack = [vr.LeftWallBlack(1):vr.LeftWallBlack(2) vr.RightWallBlack(1):vr.RightWallBlack(2)];
beginWhite = [vr.LeftWallWhite(1):vr.LeftWallWhite(2) vr.RightWallWhite(1):vr.RightWallWhite(2)];
whiteLeft = [vr.RightArmWallBlack(1):vr.RightArmWallBlack(2) vr.RightEndWallBlack(1):vr.RightEndWallBlack(2)...
    vr.TTopWallRightBlack(1):vr.TTopWallRightBlack(2) vr.LeftArmWallWhite(1):vr.LeftArmWallWhite(2)...
    vr.LeftEndWallWhite(1):vr.LeftEndWallWhite(2) vr.TTopWallLeftWhite(1):vr.TTopWallLeftWhite(2)];
whiteRight = [vr.RightArmWallWhite(1):vr.RightArmWallWhite(2) vr.RightEndWallWhite(1):vr.RightEndWallWhite(2)...
    vr.TTopWallRightWhite(1):vr.TTopWallRightWhite(2) vr.LeftArmWallBlack(1):vr.LeftArmWallBlack(2)...
    vr.LeftEndWallBlack(1):vr.LeftEndWallBlack(2) vr.TTopWallLeftBlack(1):vr.TTopWallLeftBlack(2)];
backBlack = vr.BackWallBlack(1):vr.BackWallBlack(2);
backWhite = vr.BackWallWhite(1):vr.BackWallWhite(2);
whiteLeftTower = vr.WhiteLeftTower(1):vr.WhiteLeftTower(2);
blackLeftTower = vr.BlackLeftTower(1):vr.BlackLeftTower(2);
whiteRightTower = vr.WhiteRightTower(1):vr.WhiteRightTower(2);
blackRightTower = vr.BlackRightTower(1):vr.BlackRightTower(2);


vr.blackLeftTower = [beginBlack whiteRight backBlack blackLeftTower];
vr.blackRightTower = [beginBlack whiteLeft backBlack blackRightTower];
vr.whiteLeftTower = [beginWhite whiteLeft backWhite whiteLeftTower];
vr.whiteRightTower = [beginWhite whiteRight backWhite whiteRightTower];

vr.worlds{1}.surface.visible(:) = 0;
vr.cuePos = randi(4);
if vr.cuePos == 1
    vr.currentCueWorld = 1;
    vr.worlds{1}.surface.visible(vr.blackLeftTower) = 1;
elseif vr.cuePos == 2
    vr.currentCueWorld = 2;
    vr.worlds{1}.surface.visible(vr.blackRightTower) = 1;
elseif vr.cuePos == 3
    vr.currentCueWorld = 3;
    vr.worlds{1}.surface.visible(vr.whiteLeftTower) = 1;
elseif vr.cuePos == 4
    vr.currentCueWorld = 4;
    vr.worlds{1}.surface.visible(vr.whiteRightTower) = 1;
else
    error('No World');
end

vr.numBlackLeftTurn = 0;
vr.numBlackTrials = 0;
vr.numWhiteRightTurn = 0;
vr.numWhiteTrials = 0;

% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)

if vr.inITI == 0 && abs(vr.position(1)) > eval(vr.exper.variables.armLength)/2 &&...
        vr.position(2) > eval(vr.exper.variables.MazeLengthAhead)
    if vr.position(1) < 0 && (vr.cuePos == 1 || vr.cuePos == 3)
        if vr.streak == 0 || vr.mulRewards == 0
            vr = giveReward(vr,1);
        elseif (vr.streak == 1 && vr.mulRewards == 2) || (vr.streak >= 1 && vr.mulRewards == 1)
            vr = giveReward(vr,2);
        elseif vr.streak >= 2 && vr.mulRewards >= 2
            vr = giveReward(vr,3);
        end
        vr.numRewards = vr.numRewards + 1;
        vr.itiDur = vr.itiCorrect;
        vr.streak = vr.streak + 1;
    elseif  vr.position(1) > 0 && (vr.cuePos == 2 || vr.cuePos == 4)
        if vr.streak == 0 || vr.mulRewards == 0
            vr = giveReward(vr,1);
        elseif (vr.streak == 1 && vr.mulRewards == 2) || (vr.streak >= 1 && vr.mulRewards == 1)
            vr = giveReward(vr,2);
        elseif vr.streak >= 2 && vr.mulRewards >= 2
            vr = giveReward(vr,3);
        end
        vr.itiDur = vr.itiCorrect;
        vr.numRewards = vr.numRewards + 1;
        vr.streak = vr.streak + 1;
    else
        vr.isReward = 0;
        vr.itiDur = vr.itiMiss;
        vr.streak = 0;
    end
    
    if (vr.isReward == 0 && vr.cuePos == 1) || (vr.isReward ~= 0 && vr.cuePos == 2)
        vr.numWhiteRightTurn = vr.numWhiteRightTurn + 1;
    elseif (vr.isReward == 0 && vr.cuePos == 4) || (vr.isReward ~=0 && vr.cuePos == 3);
        vr.numBlackLeftTurn = vr.numBlackLeftTurn + 1;
    end
    
    if vr.cuePos == 1 || vr.cuePos == 2
        vr.numWhiteTrials = vr.numWhiteTrials + 1;
    elseif vr.cuePos == 4 || vr.cuePos == 3
        vr.numBlackTrials = vr.numBlackTrials + 1;
    end
    
    vr.worlds{1}.surface.visible(:) = 0;
    vr.itiStartTime = tic;
    vr.inITI = 1;
    vr.numTrials = vr.numTrials + 1;
    vr.cellWrite = false;
else
    vr.isReward = 0;
end

if vr.inITI == 1
    vr.itiTime = toc(vr.itiStartTime);
    
    if vr.cellWrite
        [dataStruct] = createSaveStruct(vr.mouseNum,vr.experimenter,...
            vr.conds,vr.whiteMazes,vr.leftMazes,vr.mazeName,vr.cuePos,vr.leftMazes(vr.cuePos),...
            vr.whiteMazes(vr.cuePos),vr.isReward,vr.itiCorrect,vr.itiMiss,vr.isReward ~= 0,vr.leftMazes(vr.cuePos)==(vr.isReward~=0),...
            vr.whiteMazes(vr.cuePos)==(vr.isReward~=0),vr.streak,vr.trialStartTime,rem(now,1),vr.startTime); %#ok<NASGU>
        eval(['data',num2str(vr.numTrials),'=dataStruct;']);
        %save datastruct
        if exist(vr.pathTempMatCell,'file')
            save(vr.pathTempMatCell,['data',num2str(vr.numTrials)],'-append');
        else
            save(vr.pathTempMatCell,['data',num2str(vr.numTrials)]);
        end
        vr.cellWrite = false;
    end
    
    if vr.itiTime > vr.itiDur
        vr.inITI = 0;
        vr.percBlackLeftTurn = vr.numBlackLeftTurn/vr.numBlackTrials;
        vr.percWhiteRightTurn = vr.numWhiteRightTurn/vr.numWhiteTrials;
        if isnan(vr.percBlackLeftTurn)
            vr.percBlackLeftTurn = 0;
        end
        if isnan(vr.percWhiteRightTurn)
            vr.percWhiteRightTurn = 0;
        end
        vr.randCueTurn = rand;
        vr.randCueColor = rand;
        if vr.randCueColor >= .5
            if vr.randCueTurn >= vr.percWhiteRightTurn
                vr.cuePos = 2;
            elseif vr.randCueTurn < vr.percWhiteRightTurn
                vr.cuePos = 1;
            end
        elseif vr.randCueColor < .5
            if vr.randCueTurn >= vr.percBlackLeftTurn
                vr.cuePos = 3;
            elseif vr.randCueTurn < vr.percBlackLeftTurn
                vr.cuePos = 4;
            end
        else
            disp('error');
        end
        if vr.cuePos == 1
            vr.currentCueWorld = 1;
            vr.worlds{1}.surface.visible(vr.blackLeftTower) = 1;
        elseif vr.cuePos == 2
            vr.currentCueWorld = 2;
            vr.worlds{1}.surface.visible(vr.blackRightTower) = 1;
        elseif vr.cuePos == 3
            vr.currentCueWorld = 3;
            vr.worlds{1}.surface.visible(vr.whiteLeftTower) = 1;
        elseif vr.cuePos == 4
            vr.currentCueWorld = 4;
            vr.worlds{1}.surface.visible(vr.whiteRightTower) = 1;
        else
            error('No World');
        end
        vr.position = vr.worlds{1}.startLocation;
        
        vr.dp = 0; %prevents movement
        vr.trialStartTime = rem(now,1);
    end
end

vr.text(1).string = ['TIME ' datestr(now-vr.startTime,'HH.MM.SS')];
vr.text(2).string = ['TRIALS ', num2str(vr.numTrials)];
vr.text(3).string = ['REWARDS ',num2str(vr.numRewards)];

fwrite(vr.fid,[rem(now,1) vr.position([1:2,4]) vr.velocity(1:2) vr.cuePos vr.isReward vr.inITI],'float');


% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
commonTerminationVIRMEN(vr);