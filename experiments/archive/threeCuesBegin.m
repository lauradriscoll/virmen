function code = threeCuesBegin
% dotAltitude   Code for the ViRMEn experiment dotAltitude.
%   code = dotAltitude   Returns handles to the functions that ViRMEn
%   executes during engine initialization, runtime and termination.


% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT




% --- INITIALIZATION code: executes before the ViRMEN engine starts.
function vr = initializationCodeFun(vr)

vr.debugMode=false;

path = ['C:\DATA\Laura\Current Mice\LD' vr.exper.variables.mouseNumber];

if ~exist(path,'dir')
    mkdir(path);
end
vr.filenameMat = ['LD',vr.exper.variables.mouseNumber,'_',datestr(now,'yymmdd'),'.mat'];
vr.filenameDat = ['LD',vr.exper.variables.mouseNumber,'_',datestr(now,'yymmdd'),'.dat'];
fileIndex = 0;
fileList = what(path);
while sum(strcmp(fileList.mat,vr.filenameMat)) > 0
    fileIndex = fileIndex + 1;
    vr.filenameMat = ['LD',vr.exper.variables.mouseNumber,'_',datestr(now,'yymmdd'),'_',num2str(fileIndex),'.mat'];
    vr.filenameDat = ['LD',vr.exper.variables.mouseNumber,'_',datestr(now,'yymmdd'),'_',num2str(fileIndex),'.dat'];
    fileList = what(path);
end
exper = copyVirmenObject(vr.exper); %#ok<NASGU>
vr.pathMat = [path,'\', vr.filenameMat];
vr.pathDat = [path,'\', vr.filenameDat];
save(vr.pathMat,'exper');
vr.fid = fopen(vr.pathDat,'w+');

% Start the DAQ acquisition
if ~vr.debugMode
    daqreset; %reset DAQ in case it's still in use by a previous Matlab program
    vr.ai = analoginput('nidaq','dev1'); % connect to the DAQ card
    addchannel(vr.ai,0:1); % start channels 0 and 1
    set(vr.ai,'samplerate',1000,'samplespertrigger',1e7); % define buffer
    start(vr.ai); % start acquisition
    
    vr.ao = analogoutput('nidaq','dev1');
    addchannel(vr.ao,0);
    set(vr.ao,'samplerate',10000);
    
    % set up output pulse for solenoid
    
    duration = 0.055; %length of pulse in seconds
    
    set (vr.ao,'SampleRate',1000);
    ActualRate = get (vr.ao,'SampleRate');
    pulselength=ActualRate*duration;
    vr.pulsedata=5.0*ones(pulselength,1); %5V amplitude
    vr.pulsedata(pulselength)=0; %reset to 0V at last time point
end

%Get initial biases
vr.adjustmentFactor = 0.01;
vr.minWallLength = eval(vr.exper.variables.wallLengthMin);
vr.lengthFactor = 0;
vr.percentCorrect = 0;
vr.numRightTurns = 0;
vr.numBlackTurns = 0;
vr.trialWindowLRAnswer = zeros(1,20);
vr.trialWindowLRChoice = zeros(1,20);
vr.trialWindowBWAnswer = zeros(1,20);
vr.trialWindowBWChoice = zeros(1,20);

%Define indices of walls
vr.cueWallLeftBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.cueWallLeftBlack,:);
vr.cueWallLeftWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.cueWallLeftWhite,:);
vr.cueWallRightBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.cueWallRightBlack,:);
vr.cueWallRightWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.cueWallRightWhite,:);
vr.backWall = vr.worlds{1}.objects.vertices(vr.worlds{1}.objects.indices.backWall,:);
vr.armWallRightWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.armWallRightWhite,:);
vr.armWallRightBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.armWallRightBlack,:);
vr.armWallLeftBlack = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.armWallLeftBlack,:);
vr.armWallLeftWhite = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.armWallLeftWhite,:);
vr.towerRight = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.towerRight,:);
vr.towerLeft = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.towerLeft,:);
vr.delayWallRight = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.delayWallRight,:);
vr.delayWallLeft = vr.worlds{1}.objects.triangles(vr.worlds{1}.objects.indices.delayWallLeft,:);
vr.startLocationCurrent = vr.worlds{1}.startLocation;

vr.backWallOriginal = vr.worlds{1}.surface.vertices(:,vr.backWall(1):vr.backWall(2));
vr.wallLength = str2double(vr.exper.variables.wallLength);
vr.length = str2double(vr.exper.variables.wallLengthMin);

vr.edgeIndBackWall = vr.worlds{1}.objects.edges(vr.worlds{1}.objects.indices.backWall,1);
vr.backWallEdges = vr.worlds{1}.edges.endpoints(vr.edgeIndBackWall,:);

vr.backWallCurrent = vr.backWallOriginal(2,:) - (vr.lengthFactor)*(vr.wallLength - vr.minWallLength);
vr.worlds{1}.surface.vertices(2,vr.backWall(1):vr.backWall(2)) = vr.backWallCurrent;
vr.worlds{1}.edges.endpoints(vr.edgeIndBackWall,[2,4]) = vr.backWallEdges([2,4]) - (vr.lengthFactor)*(vr.wallLength - vr.minWallLength);
vr.startLocationCurrent(2) = vr.worlds{1}.startLocation(2) - (vr.lengthFactor)*(vr.wallLength - vr.minWallLength);
vr.position = vr.startLocationCurrent;

vr.inITI = 0;
vr.isReward = 0;
vr.cuePos = randi(4);

switch vr.cuePos
    case 1 %RightBlack
        vr.worlds{1}.surface.visible(vr.cueWallRightWhite(1):vr.cueWallRightWhite(2))= 0;
        vr.worlds{1}.surface.visible(vr.cueWallLeftWhite(1):vr.cueWallLeftWhite(2))= 0;
        vr.worlds{1}.surface.visible(vr.towerLeft(1):vr.towerLeft(2))= 0;
        vr.worlds{1}.surface.visible(vr.armWallRightWhite(1):vr.armWallRightWhite(2))= 0;
        vr.worlds{1}.surface.visible(vr.armWallLeftBlack(1):vr.armWallLeftBlack(2))= 0;
        
    case 2 %RightWhite
        vr.worlds{1}.surface.visible(vr.cueWallRightBlack(1):vr.cueWallRightBlack(2))= 0;
        vr.worlds{1}.surface.visible(vr.cueWallLeftBlack(1):vr.cueWallLeftBlack(2))= 0;
        vr.worlds{1}.surface.visible(vr.towerLeft(1):vr.towerLeft(2))= 0;
        vr.worlds{1}.surface.visible(vr.armWallRightBlack(1):vr.armWallRightBlack(2))= 0;
        vr.worlds{1}.surface.visible(vr.armWallLeftWhite(1):vr.armWallLeftWhite(2))= 0;
        
        
    case 3 %LeftBlack
        vr.worlds{1}.surface.visible(vr.cueWallRightWhite(1):vr.cueWallRightWhite(2))= 0;
        vr.worlds{1}.surface.visible(vr.cueWallLeftWhite(1):vr.cueWallLeftWhite(2))= 0;
        vr.worlds{1}.surface.visible(vr.towerRight(1):vr.towerRight(2))= 0;
        vr.worlds{1}.surface.visible(vr.armWallRightBlack(1):vr.armWallRightBlack(2))= 0;
        vr.worlds{1}.surface.visible(vr.armWallLeftWhite(1):vr.armWallLeftWhite(2))= 0;
        
    case 4 %LeftWhite
        vr.worlds{1}.surface.visible(vr.cueWallRightBlack(1):vr.cueWallRightBlack(2))= 0;
        vr.worlds{1}.surface.visible(vr.cueWallLeftBlack(1):vr.cueWallLeftBlack(2))= 0;
        vr.worlds{1}.surface.visible(vr.towerRight(1):vr.towerRight(2))= 0;
        vr.worlds{1}.surface.visible(vr.armWallRightWhite(1):vr.armWallRightWhite(2))= 0;
        vr.worlds{1}.surface.visible(vr.armWallLeftBlack(1):vr.armWallLeftBlack(2))= 0;
        
    otherwise
        error('No World');
end
vr.dp = 0;
vr.startTime = now;
vr.trialTimer = tic;

vr.text(1).string = '0';
vr.text(1).position = [1 .8];
vr.text(1).size = .03;
vr.text(1).color = [1 0 1];
vr.startTime = now;

vr.text(2).string = '0';
vr.text(2).position = [1 .7];
vr.text(2).size = .03;
vr.text(2).color = [1 1 0];
vr.numTrials = 0;

vr.text(3).string = '0';
vr.text(3).position = [1 .6];
vr.text(3).size = .03;
vr.text(3).color = [0 1 1];
vr.numRewards = 0;
vr.tocInd = 1;
vr.tocArray = zeros(1,2000);

vr.text(4).string = '0';
vr.text(4).position = [1 .5];
vr.text(4).size = .03;
vr.text(4).color = [.5 .5 1];
vr.numRewards = 0;
vr.tocInd = 1;
vr.tocArray = zeros(1,2000);


% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)
vr.debugTic = tic;
if vr.inITI == 0 && abs(vr.position(1)) > eval(vr.exper.variables.armLength)/2 && vr.position(2) > (eval(vr.exper.variables.wallLength) + eval(vr.exper.variables.delayLength))
    
    if vr.position(1) > 0 && (vr.cuePos == 1 || vr.cuePos == 2)
        vr.isReward = 1;
        if ~vr.debugMode
                putdata(vr.ao,vr.pulsedata);
                start(vr.ao);
                wait(vr.ao,5);
        end
        vr.itiDur = 2;
        vr.numRewards = vr.numRewards + 1;
    elseif  vr.position(1) < 0 && (vr.cuePos == 3 || vr.cuePos == 4)
        vr.isReward = 1;
        if ~vr.debugMode
                putdata(vr.ao,vr.pulsedata);
                start(vr.ao);
                wait(vr.ao,5);
        end
        vr.itiDur = 2;
        vr.numRewards = vr.numRewards + 1;
    else
        vr.isReward = 0;
        vr.itiDur = 4;
    end
    
    if ((vr.cuePos == 4 || vr.cuePos == 3) && vr.isReward ~= 0) || ((vr.cuePos == 1 || vr.cuePos == 2) && vr.isReward == 0)
        vr.numRightTurns = vr.numRightTurns + 1;
        vr.trialWindowLRChoice = [2,vr.trialWindowLRChoice(1:19)];
    else
        vr.trialWindowLRChoice = [1,vr.trialWindowLRChoice(1:19)];
    end
    if ((vr.cuePos == 1 || vr.cuePos == 3) && vr.isReward == 0) || ((vr.cuePos == 2 || vr.cuePos == 4) && vr.isReward ~= 0)
        vr.numBlackTurns = vr.numBlackTurns + 1;
        vr.trialWindowBWChoice = [2,vr.trialWindowBWChoice(1:19)];
    else
        vr.trialWindowBWChoice = [1,vr.trialWindowBWChoice(1:19)];
    end
    
    vr.worlds{1}.surface.visible(:) = 0;
    vr.itiStartTime = tic;
    vr.inITI = 1;
    vr.numTrials = vr.numTrials + 1;
    
    
else
    vr.isReward = 0;
end

if vr.tocInd <= length(vr.tocArray)
    vr.tocArray(vr.tocInd) = toc(vr.debugTic);
    vr.tocInd = vr.tocInd + 1;
end

if vr.inITI == 1
    vr.itiTime = toc(vr.itiStartTime);
    if vr.itiTime > vr.itiDur
        vr.inITI = 0;
        
        vr.worlds{1}.surface.visible(:) = 1;
        
        vr.cuePos = randi(4);
        switch vr.cuePos
            case 1 %RightBlack
                vr.worlds{1}.surface.visible(vr.cueWallRightWhite(1):vr.cueWallRightWhite(2))= 0;
                vr.worlds{1}.surface.visible(vr.cueWallLeftWhite(1):vr.cueWallLeftWhite(2))= 0;
                vr.worlds{1}.surface.visible(vr.towerLeft(1):vr.towerLeft(2))= 0;
                vr.worlds{1}.surface.visible(vr.armWallRightWhite(1):vr.armWallRightWhite(2))= 0;
                vr.worlds{1}.surface.visible(vr.armWallLeftBlack(1):vr.armWallLeftBlack(2))= 0;
                vr.trialWindowBWAnswer = [2,vr.trialWindowBWAnswer(1:19)];
                vr.trialWindowLRAnswer = [2,vr.trialWindowLRAnswer(1:19)];
                
            case 2 %RightWhite
                vr.worlds{1}.surface.visible(vr.cueWallRightBlack(1):vr.cueWallRightBlack(2))= 0;
                vr.worlds{1}.surface.visible(vr.cueWallLeftBlack(1):vr.cueWallLeftBlack(2))= 0;
                vr.worlds{1}.surface.visible(vr.towerLeft(1):vr.towerLeft(2))= 0;
                vr.worlds{1}.surface.visible(vr.armWallRightBlack(1):vr.armWallRightBlack(2))= 0;
                vr.worlds{1}.surface.visible(vr.armWallLeftWhite(1):vr.armWallLeftWhite(2))= 0;
                vr.trialWindowBWAnswer = [1,vr.trialWindowBWAnswer(1:19)];
                vr.trialWindowLRAnswer = [2,vr.trialWindowLRAnswer(1:19)];
                
            case 3 %LeftBlack
                vr.worlds{1}.surface.visible(vr.cueWallRightWhite(1):vr.cueWallRightWhite(2))= 0;
                vr.worlds{1}.surface.visible(vr.cueWallLeftWhite(1):vr.cueWallLeftWhite(2))= 0;
                vr.worlds{1}.surface.visible(vr.towerRight(1):vr.towerRight(2))= 0;
                vr.worlds{1}.surface.visible(vr.armWallRightBlack(1):vr.armWallRightBlack(2))= 0;
                vr.worlds{1}.surface.visible(vr.armWallLeftWhite(1):vr.armWallLeftWhite(2))= 0;
                vr.trialWindowBWAnswer = [2,vr.trialWindowBWAnswer(1:19)];
                vr.trialWindowLRAnswer = [1,vr.trialWindowLRAnswer(1:19)];
                
            case 4 %LeftWhite
                vr.worlds{1}.surface.visible(vr.cueWallRightBlack(1):vr.cueWallRightBlack(2))= 0;
                vr.worlds{1}.surface.visible(vr.cueWallLeftBlack(1):vr.cueWallLeftBlack(2))= 0;
                vr.worlds{1}.surface.visible(vr.towerRight(1):vr.towerRight(2))= 0;
                vr.worlds{1}.surface.visible(vr.armWallRightWhite(1):vr.armWallRightWhite(2))= 0;
                vr.worlds{1}.surface.visible(vr.armWallLeftBlack(1):vr.armWallLeftBlack(2))= 0;
                vr.trialWindowBWAnswer = [1,vr.trialWindowBWAnswer(1:19)];
                vr.trialWindowLRAnswer = [1,vr.trialWindowLRAnswer(1:19)];
                
            otherwise
                error('No World');
        end
        
        vr.trialWindowLRZeros = vr.trialWindowLRChoice - vr.trialWindowLRAnswer;
        vr.percentCorrect = sum(vr.trialWindowLRZeros==0)/length(vr.trialWindowLRAnswer);
        
        if toc(vr.trialTimer) < 20
            vr.lengthFactor = vr.lengthFactor + vr.adjustmentFactor;
        elseif toc(vr.trialTimer) > 20
            vr.lengthFactor = vr.lengthFactor - vr.adjustmentFactor;
        end
        
        if vr.lengthFactor > 1
            vr.lengthFactor = 1;
        elseif vr.lengthFactor <0
            vr.lengthFactor = 0;
        end
        
        
        vr.backWallCurrent = vr.backWallOriginal(2,:) - (vr.lengthFactor)*(vr.wallLength - vr.minWallLength);
        vr.worlds{1}.surface.vertices(2,vr.backWall(1):vr.backWall(2)) = vr.backWallCurrent;
        vr.worlds{1}.edges.endpoints(vr.edgeIndBackWall,[2,4]) = vr.backWallEdges([2,4]) - (vr.lengthFactor)*(vr.wallLength - vr.minWallLength);
        vr.startLocationCurrent(2) = vr.worlds{1}.startLocation(2) - (vr.lengthFactor)*(vr.wallLength - vr.minWallLength);    
        vr.length = str2double(vr.exper.variables.wallLengthMin)+ (vr.lengthFactor)*(vr.wallLength - vr.minWallLength);
        
        vr.position = vr.startLocationCurrent;
        vr.dp = 0;
        vr.trialTimer = tic;
    end
end

vr.text(1).string = ['TIME ' datestr(now-vr.startTime,'HH.MM.SS')];
vr.text(2).string = ['TRIALS ', num2str(vr.numTrials)];
vr.text(3).string = ['REWARDS ',num2str(vr.numRewards)];
vr.text(4).string = ['LENGTH ',num2str(vr.length)];


fwrite(vr.fid,[rem(now,1) vr.position([1:2,4]) vr.velocity(1:2) vr.cuePos vr.isReward vr.inITI],'float');


% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
fclose all;
fid = fopen(vr.pathDat);
data = fread(fid,'float');
data = reshape(data,9,numel(data)/9);
assignin('base','data',data);
save(vr.pathMat,'vr','-append');
save(vr.pathMat,'data','-append');
fclose all;





