function code = linearTrack2Cond
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
vr.conds = {'Black','White'};

vr = initializePathVIRMEN(vr);

%Define indices of walls
vr.LeftWallBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.LeftWallBlack,:);
vr.RightWallBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.RightWallBlack,:);
vr.BackWallBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.BackWallBlack,:);
vr.LeftEndWallBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.LeftEndWallBlack,:);
vr.RightEndWallBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.RightEndWallBlack,:);
vr.TTopWallLeftBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.TTopWallLeftBlack,:);
vr.TTopWallRightBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.TTopWallRightBlack,:);
vr.LeftWallWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.LeftWallWhite,:);
vr.RightWallWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.RightWallWhite,:);
vr.BackWallWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.BackWallWhite,:);
vr.LeftEndWallWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.LeftEndWallWhite,:);
vr.RightEndWallWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.RightEndWallWhite,:);
vr.TTopWallLeftWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.TTopWallLeftWhite,:);
vr.TTopWallRightWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.TTopWallRightWhite,:);
vr.WhiteLeftTower = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.WhiteLeftTower,:);
vr.BlackRightTower = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.BlackRightTower,:);

%Define groups for mazes
beginBlack = [vr.LeftWallBlack(1):vr.LeftWallBlack(2) vr.RightWallBlack(1):vr.RightWallBlack(2)];
beginWhite = [vr.LeftWallWhite(1):vr.LeftWallWhite(2) vr.RightWallWhite(1):vr.RightWallWhite(2)];
black = [vr.RightEndWallBlack(1):vr.RightEndWallBlack(2)...
    vr.TTopWallRightBlack(1):vr.TTopWallRightBlack(2)...
    vr.LeftEndWallBlack(1):vr.LeftEndWallBlack(2) vr.TTopWallLeftBlack(1):vr.TTopWallLeftBlack(2)];
white = [vr.RightEndWallWhite(1):vr.RightEndWallWhite(2)...
    vr.TTopWallRightWhite(1):vr.TTopWallRightWhite(2) ...
    vr.LeftEndWallWhite(1):vr.LeftEndWallWhite(2) vr.TTopWallLeftWhite(1):vr.TTopWallLeftWhite(2)];
backBlack = vr.BackWallBlack(1):vr.BackWallBlack(2);
backWhite = vr.BackWallWhite(1):vr.BackWallWhite(2);
whiteLeftTower = vr.WhiteLeftTower(1):vr.WhiteLeftTower(2);
blackRightTower = vr.BlackRightTower(1):vr.BlackRightTower(2);


vr.blackRightTower = [beginBlack black backBlack blackRightTower];

vr.whiteLeftTower = [beginWhite white backWhite whiteLeftTower];

vr.worlds{1}.surface.visible(:) = 0;
vr.cuePos = randi(2);
if vr.cuePos == 1
    vr.currentCueWorld = 1;
    vr.worlds{1}.surface.visible(vr.blackRightTower) = 1;
elseif vr.cuePos == 2
    vr.currentCueWorld = 2;
    vr.worlds{1}.surface.visible(vr.whiteLeftTower) = 1;
else
    error('No World');
end

vr.numBlackLeftTurn = 0;
vr.numBlackTrials = 0;
vr.numWhiteRightTurn = 0;
vr.numWhiteTrials = 0;


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

if vr.inITI == 0 && abs(vr.position(2)) > eval(vr.exper.variables.MazeLengthAhead)
    if ~vr.debugMode
            wait(vr.aoCOUNT,1); %Make sure iteration num is sent before giving reward to prevent AO conflicts
    end
            vr = giveReward(vr,1);
        vr.numRewards = vr.numRewards + 1;
        vr.itiDur = vr.itiCorrect;
        
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
        
        vr.cuePos = randi(2);
        if vr.cuePos == 1
            vr.currentCueWorld = 1;
            vr.worlds{1}.surface.visible(vr.blackRightTower) = 1;
        elseif vr.cuePos == 2
            vr.currentCueWorld = 2;
            vr.worlds{1}.surface.visible(vr.whiteLeftTower) = 1;
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