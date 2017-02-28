function code = GradedBlockDelay2TowersGray
% GradedBlockDelay2Towers   Code for the ViRMEn experiment GradedBlockDelay2Towers.
%   code = GradedBlockDelay2Towers   Returns handles to the functions that ViRMEn
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
vr.greyFac = 1/6; %goes from 0 to 1 to signify the amount of maze which is grey
vr.maxGrey = 3/6;
vr.blockThresh = [0 1/6 2/6 3/6 4/6]; %thresholds for blocks
vr.trialBlockThresh = 20;
vr.percBlockThresh = 0.75;
vr.roundVec = 0:(1/60):1;


vr.advCount = 2; %net count value to advance
vr.regCount = -2; %net count value to regress
vr.advRate = 1/60; %must be related to number of textures
vr.regRate = 1/60;

vr.midOff = 0/6;
vr.adaptive = false;
vr.adapSpeed = 20; %number of trials over which to perform adaptive
%breaks
vr.breaks = false; %flag of whether or not breaks should occur
vr.breakDur = 120; %break duration in seconds
vr.breakThreshTime = 600; %time threshold for breaks in seconds
vr.trialTicFlag = true;
vr.breakFlag = true;
vr.inBreak = false;

vr.numRewPer = 1;
%increase ITI
vr.increaseITI = true; %flag of whether or not ITIs should increase
vr.missITIVec = [4 10 15]; %vector of increase in ITIs in response to consecutive missed trials

vr.rewIncrease = false; %increase rewards with block
vr.moveFlag = false;




%initialize important cell information
vr.conds = {'Black Left','Black Right','White Left','White Right'};

vr = initializePathVIRMEN(vr);

%Get initial delay
vr.numTrialsDelayLevel = 0;
vr.numRewardsDelayLevel = 0;
vr.numLeftTurns = 0;
vr.numBlackTurns = 0;
vr.netCount = 0;
vr.block = find(sort(vr.blockThresh) <= vr.greyFac,1,'last');
vr.currBlockThresh = vr.blockThresh(vr.block);

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
vr.LeftWallDelay = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.LeftWallDelay,:);
vr.RightWallDelay = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.RightWallDelay,:);
vr.TTopMiddle = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.TTopMiddle,:);
vr.blackLeftTower = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.blackLeftTower,:);
vr.blackRightTower = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.blackRightTower,:);
vr.whiteLeftTower = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.whiteLeftTower,:);
vr.whiteRightTower = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.whiteRightTower,:);
vr.greyLeftTower = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.greyLeftTower,:);
vr.greyRightTower = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.greyRightTower,:);


%Define groups for mazes
beginBlack = [vr.LeftWallBlack(1):vr.LeftWallBlack(2) vr.RightWallBlack(1):vr.RightWallBlack(2)];
beginWhite = [vr.LeftWallWhite(1):vr.LeftWallWhite(2) vr.RightWallWhite(1):vr.RightWallWhite(2)];
vr.whiteLeft = [vr.RightArmWallBlack(1):vr.RightArmWallBlack(2) vr.RightEndWallBlack(1):vr.RightEndWallBlack(2)...
    vr.TTopWallRightBlack(1):vr.TTopWallRightBlack(2) vr.LeftArmWallWhite(1):vr.LeftArmWallWhite(2)...
    vr.LeftEndWallWhite(1):vr.LeftEndWallWhite(2) vr.TTopWallLeftWhite(1):vr.TTopWallLeftWhite(2)];
vr.whiteRight = [vr.RightArmWallWhite(1):vr.RightArmWallWhite(2) vr.RightEndWallWhite(1):vr.RightEndWallWhite(2)...
    vr.TTopWallRightWhite(1):vr.TTopWallRightWhite(2) vr.LeftArmWallBlack(1):vr.LeftArmWallBlack(2)...
    vr.LeftEndWallBlack(1):vr.LeftEndWallBlack(2) vr.TTopWallLeftBlack(1):vr.TTopWallLeftBlack(2)];
vr.greyTowers = [vr.greyLeftTower(1):vr.greyLeftTower(2) vr.greyRightTower(1):vr.greyRightTower(2)];
vr.whiteRightTowers = [vr.whiteRightTower(1):vr.whiteRightTower(2) vr.blackLeftTower(1):vr.blackLeftTower(2)];
vr.whiteLeftTowers = [vr.whiteLeftTower(1):vr.whiteLeftTower(2) vr.blackRightTower(1):vr.blackRightTower(2)];
backBlack = vr.BackWallBlack(1):vr.BackWallBlack(2);
backWhite = vr.BackWallWhite(1):vr.BackWallWhite(2);
TTopMiddle = vr.TTopMiddle(1):vr.TTopMiddle(2);

vr.blackLeftOn = [beginBlack vr.whiteRight vr.greyTowers backBlack TTopMiddle];
vr.blackRightOn = [beginBlack vr.whiteLeft vr.greyTowers backBlack TTopMiddle];
vr.whiteLeftOn = [beginWhite vr.whiteLeft vr.greyTowers backWhite TTopMiddle];
vr.whiteRightOn = [beginWhite vr.whiteRight vr.greyTowers backWhite TTopMiddle];

vr.Cues=[2 3];
vr.cuePos = randsample(vr.Cues,1);
vr.worlds{1}.surface.visible(:) = 0;
switch vr.cuePos
    case 1
        vr.worlds{1}.surface.visible(vr.blackLeftOn) = 1;
        vr.worlds{1}.surface.visible(vr.LeftWallBlack(1) + ceil((1-vr.greyFac)*(vr.LeftWallBlack(2)-vr.LeftWallBlack(1))):vr.LeftWallBlack(2)) = 0;
        vr.worlds{1}.surface.visible(vr.RightWallBlack(1) + ceil((1-vr.greyFac)*(vr.RightWallBlack(2)-vr.RightWallBlack(1))):vr.RightWallBlack(2)) = 0;
        vr.worlds{1}.surface.visible(vr.LeftWallDelay(1) + ceil((1-vr.greyFac)*(vr.LeftWallDelay(2)-vr.LeftWallDelay(1))):vr.LeftWallDelay(end)) = 1;
        vr.worlds{1}.surface.visible(vr.RightWallDelay(1) + ceil((1-vr.greyFac)*(vr.RightWallDelay(2)-vr.RightWallDelay(1))):vr.RightWallDelay(end)) = 1;
    case 2
        vr.worlds{1}.surface.visible(vr.blackRightOn) = 1;
        vr.worlds{1}.surface.visible(vr.LeftWallBlack(1) + ceil((1-vr.greyFac)*(vr.LeftWallBlack(2)-vr.LeftWallBlack(1))):vr.LeftWallBlack(2)) = 0;
        vr.worlds{1}.surface.visible(vr.RightWallBlack(1) + ceil((1-vr.greyFac)*(vr.RightWallBlack(2)-vr.RightWallBlack(1))):vr.RightWallBlack(2)) = 0;
        vr.worlds{1}.surface.visible(vr.LeftWallDelay(1) + ceil((1-vr.greyFac)*(vr.LeftWallDelay(2)-vr.LeftWallDelay(1))):vr.LeftWallDelay(end)) = 1;
        vr.worlds{1}.surface.visible(vr.RightWallDelay(1) + ceil((1-vr.greyFac)*(vr.RightWallDelay(2)-vr.RightWallDelay(1))):vr.RightWallDelay(end)) = 1;
    case 3
        vr.worlds{1}.surface.visible(vr.whiteLeftOn) = 1;
        vr.worlds{1}.surface.visible(vr.LeftWallWhite(1) + ceil((1-vr.greyFac)*(vr.LeftWallWhite(2)-vr.LeftWallWhite(1))):vr.LeftWallWhite(2)) = 0;
        vr.worlds{1}.surface.visible(vr.RightWallWhite(1) + ceil((1-vr.greyFac)*(vr.RightWallWhite(2)-vr.RightWallWhite(1))):vr.RightWallWhite(2)) = 0;
        vr.worlds{1}.surface.visible(vr.LeftWallDelay(1) + ceil((1-vr.greyFac)*(vr.LeftWallDelay(2)-vr.LeftWallDelay(1))):vr.LeftWallDelay(end)) = 1;
        vr.worlds{1}.surface.visible(vr.RightWallDelay(1) + ceil((1-vr.greyFac)*(vr.RightWallDelay(2)-vr.RightWallDelay(1))):vr.RightWallDelay(end)) = 1;
    case 4
        vr.worlds{1}.surface.visible(vr.whiteRightOn) = 1;
        vr.worlds{1}.surface.visible(vr.LeftWallWhite(1) + ceil((1-vr.greyFac)*(vr.LeftWallWhite(2)-vr.LeftWallWhite(1))):vr.LeftWallWhite(2)) = 0;
        vr.worlds{1}.surface.visible(vr.RightWallWhite(1) + ceil((1-vr.greyFac)*(vr.RightWallWhite(2)-vr.RightWallWhite(1))):vr.RightWallWhite(2)) = 0;
        vr.worlds{1}.surface.visible(vr.LeftWallDelay(1) + ceil((1-vr.greyFac)*(vr.LeftWallDelay(2)-vr.LeftWallDelay(1))):vr.LeftWallDelay(end)) = 1;
        vr.worlds{1}.surface.visible(vr.RightWallDelay(1) + ceil((1-vr.greyFac)*(vr.RightWallDelay(2)-vr.RightWallDelay(1))):vr.RightWallDelay(end)) = 1;
    otherwise
        error('No World');
end

% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)

if vr.inITI == 0 && abs(vr.position(1)) > eval(vr.exper.variables.armLength)/vr.armFac &&...
        vr.position(2) > eval(vr.exper.variables.MazeLengthAhead)
    if vr.position(1) < 0 && ismember(vr.cuePos,[1 3])
        vr = giveReward(vr,vr.numRewPer);
        
        vr.itiDur = vr.itiCorrect;
        vr.numRewards = vr.numRewards + 1;
        vr.trialResults(1,size(vr.trialResults,2)+1) = 1;
        vr.streak = vr.streak + 1;
        vr.netCount = vr.netCount + 1;
        vr.missFlag = false;
    elseif  vr.position(1) > 0 && ismember(vr.cuePos,[2 4])
        vr = giveReward(vr,vr.numRewPer);
        
        vr.itiDur = vr.itiCorrect;
        vr.numRewards = vr.numRewards + 1;
        vr.trialResults(1,size(vr.trialResults,2)+1) = 1;
        vr.streak = vr.streak + 1;
        vr.netCount = vr.netCount + 1;
        vr.missFlag = false;
    else
        vr.isReward = 0;
        vr.trialResults(1,size(vr.trialResults,2)+1) = 0;
        vr.missFlag = true;
        vr.streak = 0;
        vr.netCount = vr.netCount - 1;
    end
    
    vr.worlds{1}.surface.visible(:) = 0;
    vr.itiStartTime = tic;
    vr.inITI = 1;
    vr.numTrials = vr.numTrials + 1;
    vr.cellWrite = false;
    
    if (ismember(vr.cuePos,[1 3]) && vr.isReward ~= 0) || (ismember(vr.cuePos,[2 4]) && vr.isReward == 0)
        vr.numLeftTurns = vr.numLeftTurns + 1;
        vr.trialResults(2,end) = 1;
    else
        vr.trialResults(2,end) = 0;
    end
    if (ismember(vr.cuePos,[1 2]) && vr.isReward ~= 0) || (ismember(vr.cuePos,[3 4]) && vr.isReward == 0)
        vr.numBlackTurns = vr.numBlackTurns + 1;
        vr.trialResults(3,end) = 1;
    else
        vr.trialResults(3,end) = 0;
    end
    vr.trialResults(4,end) = vr.block; %fourth element is block
    
    if vr.increaseITI && vr.missFlag
        if ~any(vr.trialResults(1,:)==1)
            numConsecMiss = size(vr.trialResults,2);
        else
            numConsecMiss = size(vr.trialResults,2) -...
                find(diff(vr.trialResults(1,:))==-1,1,'last'); %find number of consecutive missed trials
        end
        if size(vr.trialResults,2) > 1 &&...
                length(unique(vr.trialResults(2,end-numConsecMiss+1:end)))~=1 &&...
                length(unique(vr.trialResults(3,end-numConsecMiss+1:end)))~=1 %if consecutive missed trials are not the same
            if length(unique(vr.trialResults(2,end-numConsecMiss+1:end)))~=1 %left/right
                numConsecMissSame(1) = size(vr.trialResults(2,end-numConsecMiss+1:end),2) -...
                    find(diff(vr.trialResults(2,end-numConsecMiss+1:end))~=0,1,'last');
            end
            if length(unique(vr.trialResults(3,end-numConsecMiss+1:end)))~=1 %black/white
                numConsecMissSame(2) = size(vr.trialResults(3,end-numConsecMiss+1:end),2) -...
                    find(diff(vr.trialResults(3,end-numConsecMiss+1:end))~=0,1,'last');
            end
            numRewInc = max(numConsecMissSame);
        else
            numRewInc = numConsecMiss;
        end
        if numRewInc > length(vr.missITIVec)
            numRewInc = length(vr.missITIVec);
        elseif ~any(vr.trialResults(1,:)==1)
            numRewInc = size(vr.trialResults,2);
            if numRewInc > length(vr.missITIVec)
                numRewInc = length(vr.missITIVec);
            end
        end
        vr.itiDur = vr.missITIVec(numRewInc);
    elseif vr.missFlag
        vr.itiDur = vr.itiMiss;
    end
else
    vr.isReward = 0;
end

%Set trialsStart tic (must be in runtime so that tic doesn't start long
%before session actually starts
if vr.trialTicFlag
    vr.trialsStart = tic;
    vr.trialTicFlag = false;
end

%Turn on/off gray block
if (vr.position(2) < vr.midOff*str2double(vr.exper.variables.MazeLengthAhead)) && ~vr.inITI
    vr.worlds{1}.surface.visible([vr.whiteLeft vr.whiteRight...
        vr.whiteLeftTowers vr.whiteRightTowers]) = 0;
    vr.worlds{1}.surface.visible(vr.TTopMiddle(1):vr.TTopMiddle(2)) = 1;
    vr.worlds{1}.surface.visible(vr.greyTowers) = 1;
elseif (vr.position(2) >= vr.midOff*str2double(vr.exper.variables.MazeLengthAhead)) && ~vr.inITI
    if vr.cuePos == 1 || vr.cuePos == 4
        vr.worlds{1}.surface.visible(vr.whiteRight) = 1;
        vr.worlds{1}.surface.visible(vr.whiteRightTowers) = 1;
    elseif vr.cuePos == 2 || vr.cuePos == 3
        vr.worlds{1}.surface.visible(vr.whiteLeft) = 1;
        vr.worlds{1}.surface.visible(vr.whiteLeftTowers) = 1;
    end
    vr.worlds{1}.surface.visible(vr.TTopMiddle(1):vr.TTopMiddle(2)) = 0;
    vr.worlds{1}.surface.visible(vr.greyTowers) = 1;
end

if vr.inITI == 1
    vr.itiTime = toc(vr.itiStartTime);
    
    if vr.cellWrite
        [dataStruct] = createSaveStruct(vr.mouseNum,vr.experimenter,...
            vr.conds,vr.whiteMazes,vr.leftMazes,vr.mazeName,vr.cuePos,vr.leftMazes(vr.cuePos),...
            vr.whiteMazes(vr.cuePos),vr.isReward,vr.itiCorrect,vr.itiMiss,vr.isReward ~= 0,vr.leftMazes(vr.cuePos)==(vr.isReward~=0),...
            vr.whiteMazes(vr.cuePos)==(vr.isReward~=0),vr.streak,vr.trialStartTime,rem(now,1),...
            vr.startTime,'greyFac',vr.greyFac,'block',vr.block,'netCount',vr.netCount,...
            'numRewPer',vr.numRewPer); %#ok<NASGU>
        eval(['data',num2str(vr.numTrials),'=dataStruct;']);
        %save datastruct
        if exist(vr.pathTempMatCell,'file')
            save(vr.pathTempMatCell,['data',num2str(vr.numTrials)],'-append');
        else
            save(vr.pathTempMatCell,['data',num2str(vr.numTrials)]);
        end
        vr.cellWrite = false;
    end
    
    %check for break
    if toc(vr.trialsStart) < vr.breakThreshTime || ~vr.breaks
        
        if vr.itiTime > vr.itiDur
            vr.inITI = 0;
            
            %update greyFac
            if vr.moveFlag
                if vr.netCount >= vr.advCount && vr.greyFac < vr.maxGrey
                    vr.greyFac = vr.greyFac + vr.advRate;
                    vr.netCount = 0;
                elseif vr.netCount <= vr.regCount && vr.greyFac >= (vr.currBlockThresh + vr.regRate)
                    vr.greyFac = vr.greyFac - vr.regRate;
                    if vr.greyFac<0;vr.greyFac = 0;end
                    vr.netCount = 0;
                end
            else
                vr.netCount = 0;
            end
            
            %round greyfac to deal with decimal addition error
%             vr.greyFac = roundtowardvec(vr.greyFac,vr.roundVec,'round');
            
            %find current block
            vr.block = find(sort(vr.blockThresh) <= vr.greyFac,1,'last');
            
            %calculate percent correct in current block
            if sum(vr.trialResults(4,:)==vr.block)>=vr.trialBlockThresh
                trialResultsSeg = vr.trialResults(:,end+1-vr.trialBlockThresh:end);
                vr.percCorrectBlock = sum(trialResultsSeg(1,trialResultsSeg(4,:) == vr.block))/vr.trialBlockThresh;
            else
                vr.percCorrectBlock = sum(vr.trialResults(1,vr.trialResults(4,:)...
                    ==vr.block))/sum(vr.trialResults(4,:)==vr.block);
            end
            
            %determine whether we are now in a new block
            if (sum(vr.trialResults(4,:) == vr.block) < vr.trialBlockThresh ||...
                    vr.percCorrectBlock < vr.percBlockThresh) &&...
                    ismember(vr.greyFac,vr.blockThresh)
                vr.moveFlag = false;
            else
                vr.moveFlag = true;
                vr.currBlockThresh = vr.blockThresh(vr.block);
            end
            
            if vr.greyFac == vr.blockThresh(end)
                vr.moveFlag = false;
            end
            
            %increase number of rewards depending on block
            if vr.rewIncrease
                switch vr.block
                    case {1,2}
                        vr.numRewPer = 1;
                    case 3
                        vr.numRewPer = 2;
                end
            end
            
%             %perform adaptation
%             if vr.adaptive
%                 if size(vr.trialResults,2) >= vr.adapSpeed
%                     vr.percLeft = sum(vr.trialResults(2,(end-vr.adapSpeed+1):end))/vr.adapSpeed; %percent trial that we want to set to left
%                 else
%                     vr.percLeft = sum(vr.trialResults(2,1:end))/size(vr.trialResults,2);
%                 end
%                 randLeft = rand;
%                 if randLeft >= vr.percLeft % if he always turns right, percLeft is high and we more often set condition to left
%                     vr.cuePos = 3; %left
%                 else
%                     vr.cuePos = 2; %right
%                 end
%             end
vr.cuePos = randsample(vr.Cues,1);
            
            switch vr.cuePos
                case 2
                    vr.worlds{1}.surface.visible(vr.blackRightOn) = 1;
                    vr.worlds{1}.surface.visible(vr.LeftWallBlack(1) + ceil((1-vr.greyFac)*(vr.LeftWallBlack(2)-vr.LeftWallBlack(1))):vr.LeftWallBlack(2)) = 0;
                    vr.worlds{1}.surface.visible(vr.RightWallBlack(1) + ceil((1-vr.greyFac)*(vr.RightWallBlack(2)-vr.RightWallBlack(1))):vr.RightWallBlack(2)) = 0;
                    vr.worlds{1}.surface.visible(vr.LeftWallDelay(1) + ceil((1-vr.greyFac)*(vr.LeftWallDelay(2)-vr.LeftWallDelay(1))):vr.LeftWallDelay(2)) = 1;
                    vr.worlds{1}.surface.visible(vr.RightWallDelay(1) + ceil((1-vr.greyFac)*(vr.RightWallDelay(2)-vr.RightWallDelay(1))):vr.RightWallDelay(2)) = 1;
                case 3
                    vr.worlds{1}.surface.visible(vr.whiteLeftOn) = 1;
                    vr.worlds{1}.surface.visible(vr.LeftWallWhite(1) + ceil((1-vr.greyFac)*(vr.LeftWallWhite(2)-vr.LeftWallWhite(1))):vr.LeftWallWhite(2)) = 0;
                    vr.worlds{1}.surface.visible(vr.RightWallWhite(1) + ceil((1-vr.greyFac)*(vr.RightWallWhite(2)-vr.RightWallWhite(1))):vr.RightWallWhite(2)) = 0;
                    vr.worlds{1}.surface.visible(vr.LeftWallDelay(1) + ceil((1-vr.greyFac)*(vr.LeftWallDelay(2)-vr.LeftWallDelay(1))):vr.LeftWallDelay(2)) = 1;
                    vr.worlds{1}.surface.visible(vr.RightWallDelay(1) + ceil((1-vr.greyFac)*(vr.RightWallDelay(2)-vr.RightWallDelay(1))):vr.RightWallDelay(2)) = 1;
                otherwise
                    error('No World');
            end
            vr.position = vr.worlds{1}.startLocation;
            
            vr.dp = 0; %prevents movement
            vr.trialStartTime = rem(now,1);
        end
        
    else %if break should occur
        vr.worlds{1}.surface.visible(:) = 0;
        if vr.breakFlag
            vr.breakStart = tic;
            vr.breakFlag = false;
            vr.inBreak = true;
        end
        if toc(vr.breakStart) > vr.breakDur
            vr.trialsStart = tic;
            vr.breakFlag = true;
            vr.inBreak = false;
        end
    end
end

vr.percCorrect = 100*vr.numRewards/vr.numTrials;
if isnan(vr.percCorrect)
    vr.percCorrect = 0;
end

vr.text(1).string = upper(['TIME ' datestr(now-vr.startTime,'HH.MM.SS')]);
vr.text(2).string = upper(['TRIALS ', num2str(vr.numTrials)]);
vr.text(3).string = upper(['REWARDS ',num2str(vr.numRewards)]);
vr.text(4).string = upper(['PERCCORR ',num2str(round(vr.percCorrect))]);
vr.text(5).string = upper(['GREYFAC ',num2str(vr.greyFac)]);

fwrite(vr.fid,[rem(now,1) vr.position([1:2,4]) vr.velocity(1:2) vr.cuePos vr.isReward vr.inITI vr.greyFac vr.breakFlag],'float');


% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
commonTerminationVIRMEN(vr);