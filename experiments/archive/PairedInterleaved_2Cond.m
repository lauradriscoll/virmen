function code = PairedInterleaved_2Cond
% PairedInterleaved   Code for the ViRMEn experiment PairedInterleaved.
%   code = PairedInterleaved   Returns handles to the functions that ViRMEn
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

vr.mulRewards = 1;
vr.adapSpeed = 20;

%initialize important cell information
vr.conds = {'Black Left Tower','Black Left No Tower','Black Right Tower',...
    'Black Right No Tower','White Left Tower','White Left No Tower',...
    'White Right Tower','White Right No Tower'};

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
vr.directionTowerEnd = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.directionTowerEnd,:);
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
dirTower = vr.directionTowerEnd(1):vr.directionTowerEnd(2);
backBlack = vr.BackWallBlack(1):vr.BackWallBlack(2);
backWhite = vr.BackWallWhite(1):vr.BackWallWhite(2);
whiteLeftTower = vr.WhiteLeftTower(1):vr.WhiteLeftTower(2);
blackLeftTower = vr.BlackLeftTower(1):vr.BlackLeftTower(2);
whiteRightTower = vr.WhiteRightTower(1):vr.WhiteRightTower(2);
blackRightTower = vr.BlackRightTower(1):vr.BlackRightTower(2);


vr.blackLeftTower = [beginBlack whiteRight backBlack blackLeftTower];
vr.blackLeftNoTower = [beginBlack whiteRight blackLeftTower whiteRightTower backBlack];

vr.blackRightTower = [beginBlack whiteLeft backBlack blackRightTower];
vr.blackRightNoTower = [beginBlack whiteLeft blackRightTower whiteLeftTower backBlack];

vr.whiteLeftTower = [beginWhite whiteLeft backWhite whiteLeftTower];
vr.whiteLeftNoTower = [beginWhite whiteLeft  blackRightTower whiteLeftTower  backWhite];

vr.whiteRightTower = [beginWhite whiteRight backWhite whiteRightTower];
vr.whiteRightNoTower = [beginWhite whiteRight  blackLeftTower whiteRightTower backWhite];

vr.worlds{1}.surface.visible(:) = 0;
vr.currentCueWorld = 1+2*randi([1 2]);
switch vr.currentCueWorld
    case 1
        vr.worlds{1}.surface.visible(vr.blackLeftTower) = 1;
    case 3
        vr.worlds{1}.surface.visible(vr.blackRightTower) = 1;
    case 5
        vr.worlds{1}.surface.visible(vr.whiteLeftTower) = 1;
    case 7
        vr.worlds{1}.surface.visible(vr.whiteRightTower) = 1;
    otherwise
        display('No World');
        return;
end
vr.whichWorldFlag = 0;

vr.numTrialsTower = 0;
vr.numTrialsNoTower = 0;
vr.numRewardsNoTower = 0;
vr.numRewardsTower = 0;

vr.iterationNum=0;
if ~vr.debugMode
    putsample(vr.aoCOUNT,-5); %count is -5 inbetween count 'ticks'
end

% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)

if ~vr.debugMode
    if vr.iterationNum == 1
        putsample(vr.aoCOUNT,10),
    elseif mod(vr.iterationNum,1e4)==0
        putsample(vr.aoCOUNT,vr.iterationNum/1e5),
    else
        putsample(vr.aoCOUNT,-1),
    end
end
vr.iterationNum=vr.iterationNum+1;
if vr.inITI == 0 && abs(vr.position(1)) > eval(vr.exper.variables.armLength)/2 &&...
        vr.position(2) > eval(vr.exper.variables.MazeLengthAhead)
    if vr.position(1) < 0 && ismember(vr.currentCueWorld,[1 2 5 6])
        if vr.currentCueWorld == 1 || vr.currentCueWorld == 5
            vr = giveReward(vr,1);
            vr.whichWorldFlag = vr.currentCueWorld + 1;
            vr.numRewardsTower = vr.numRewardsTower + 1;
        elseif vr.currentCueWorld == 2 || vr.currentCueWorld == 6
        if ~vr.debugMode
            wait(vr.aoCOUNT,1); %Make sure iteration num is sent before giving reward to prevent AO conflicts
            if vr.streak == 0 || vr.mulRewards == 0
                vr = giveReward(vr,1);
            elseif (vr.streak == 1 && vr.mulRewards == 2) || (vr.streak >= 1 && vr.mulRewards == 1)
                vr = giveReward(vr,2);
            elseif vr.streak >= 2 && vr.mulRewards >= 2
                vr = giveReward(vr,3);
            end
        end
            vr.whichWorldFlag = 0;
            vr.numRewardsNoTower = vr.numRewardsNoTower + 1;
        end
        vr.itiDur = vr.itiCorrect;
        vr.trialResults(1,size(vr.trialResults,2)+1) = 1;
        vr.streak = vr.streak + 1;
    elseif  vr.position(1) > 0 && ismember(vr.currentCueWorld,[3 4 7 8])
       if vr.currentCueWorld == 3 || vr.currentCueWorld == 7
            vr = giveReward(vr,1);
            vr.whichWorldFlag = vr.currentCueWorld + 1;
            vr.numRewardsTower = vr.numRewardsTower + 1;
        elseif vr.currentCueWorld == 4 || vr.currentCueWorld == 8
        if ~vr.debugMode
            wait(vr.aoCOUNT,1); %Make sure iteration num is sent before giving reward to prevent AO conflicts
            if vr.streak == 0 || vr.mulRewards == 0
                vr = giveReward(vr,1);
            elseif (vr.streak == 1 && vr.mulRewards == 2) || (vr.streak >= 1 && vr.mulRewards == 1)
                vr = giveReward(vr,2);
            elseif vr.streak >= 2 && vr.mulRewards >= 2
                vr = giveReward(vr,3);
            end
        end
            vr.whichWorldFlag = 0;
            vr.numRewardsNoTower = vr.numRewardsNoTower + 1;
        end
        vr.itiDur = vr.itiCorrect;
        vr.trialResults(1,size(vr.trialResults,2)+1) = 1;
        vr.streak = vr.streak + 1;
    else
        vr.isReward = 0;
        vr.itiDur = vr.itiMiss;
        vr.whichWorldFlag = 0;
        vr.trialResults(1,size(vr.trialResults,2)+1) = 0;
        vr.streak = 0;
    end
    
    if vr.isReward ~= 0 && ismember(vr.currentCueWorld,[1 2 3 4]) %is black?
        vr.trialResults(3,end) = 1;
    elseif vr.isReward == 0 && ismember(vr.currentCueWorld,[5 6 7 8])
        vr.trialResults(3,end) = 1;
    else
        vr.trialResults(3,end) = 0;
    end
    
    if vr.isReward ~= 0 && ismember(vr.currentCueWorld,[1 2 5 6]) %is left?
        vr.trialResults(2,end) = 1;
    elseif vr.isReward == 0 && ismember(vr.currentCueWorld,[3 4 7 8])
        vr.trialResults(2,end) = 1;
    else
        vr.trialResults(2,end) = 0;
    end
    
    vr.worlds{1}.surface.visible(:) = 0;
    vr.itiStartTime = tic;
    vr.inITI = 1;
    vr.numTrials = vr.numTrials + 1;
    vr.cellWrite = false;
    if ismember(vr.currentCueWorld,[1 3 5 7])
        vr.numTrialsTower = vr.numTrialsTower + 1;
    elseif ismember(vr.currentCueWorld,[2 4 6 8])
        vr.numTrialsNoTower = vr.numTrialsNoTower + 1;
    end
else
    vr.isReward = 0;
end

if vr.inITI == 1
    vr.itiTime = toc(vr.itiStartTime);
    
    if vr.cellWrite
        [dataStruct] = createSaveStruct(vr.mouseNum,vr.experimenter,...
            vr.conds,vr.whiteMazes,vr.leftMazes,vr.mazeName,vr.currentCueWorld,...
            vr.leftMazes(vr.currentCueWorld),vr.whiteMazes(vr.currentCueWorld),...
            vr.isReward,vr.itiCorrect,vr.itiMiss,vr.isReward~=0,vr.leftMazes(vr.currentCueWorld)==(vr.isReward~=0),...
            vr.whiteMazes(vr.currentCueWorld)==(vr.isReward~=0),vr.streak,vr.trialStartTime,...
            rem(now,1),vr.startTime,'Tower',ismember(vr.currentCueWorld,[1 3 5 7])); %#ok<NASGU>
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
        
        if size(vr.trialResults,2) >= vr.adapSpeed
            vr.percBlack = sum(vr.trialResults(3,(end-vr.adapSpeed+1):end))/vr.adapSpeed;
            vr.percLeft = sum(vr.trialResults(2,(end-vr.adapSpeed+1):end))/vr.adapSpeed;
        else
            vr.percBlack = sum(vr.trialResults(3,1:end))/size(vr.trialResults,2);
            vr.percLeft = sum(vr.trialResults(2,1:end))/size(vr.trialResults,2);
        end
        randLeft = rand;
        if vr.whichWorldFlag == 0
            if randLeft >= vr.percLeft                
                vr.currentCueWorld = 5;                
            else
                vr.currentCueWorld = 3;                
            end
        else
            vr.currentCueWorld = vr.whichWorldFlag; 
        end        
        switch vr.currentCueWorld
            case 3
                vr.worlds{1}.surface.visible(vr.blackRightTower) = 1;
            case 4
                vr.worlds{1}.surface.visible(vr.blackRightNoTower) = 1;
            case 5
                vr.worlds{1}.surface.visible(vr.whiteLeftTower) = 1;
            case 6
                vr.worlds{1}.surface.visible(vr.whiteLeftNoTower) = 1;
           
            otherwise
                display('No World');
                return;
        end
        vr.position = vr.worlds{1}.startLocation;
        
        vr.dp = 0; %prevents movement
        vr.trialStartTime = rem(now,1);
    end         
end

if ~vr.debugMode
putsample(vr.aoCOUNT,-5),
end

vr.text(1).string = ['TIME ' datestr(now-vr.startTime,'HH.MM.SS')];
vr.text(2).string = ['TRIALSTOWER ', num2str(vr.numTrialsTower)];
vr.text(3).string = ['TRIALSNOTOWER ', num2str(vr.numTrialsNoTower)];
vr.text(4).string = ['REWARDSTOWER ',num2str(vr.numRewardsTower)];
vr.text(5).string = ['REWARDSNOTOWER ',num2str(vr.numRewardsNoTower)];

fwrite(vr.fid,[rem(now,1) vr.position([1:2,4]) vr.velocity(1:2) vr.currentCueWorld vr.isReward vr.inITI],'float');


% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
commonTerminationVIRMEN(vr);