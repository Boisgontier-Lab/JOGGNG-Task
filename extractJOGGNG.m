clearvars -except data loaded nameList excelName
close all

%can only run 1 participant at a time
%be in each participants folder
%task was sampled at 200hz

%% load in data
if (~exist('loaded','var'))
    findFiles = dir(pwd);
    partIdsChar = char(findFiles(3:end).name);
    partId = str2num(partIdsChar(:,1:9));
    idIndex = unique(partId);
    for (i = 3:length(findFiles))
        dataID = findFiles(i).name;
        dataPre = exam_load(dataID);
        dataPost = KINARM_add_hand_kinematics(dataPre.c3d);
        dataFilt = filter_double_pass(dataPost, 'enhanced', 'fc', 10);
        data{i-2,1} = partId(i-2);
        data{i-2,2} = dataFilt;
        clear dataPost dataPre dataFilt
    end
    loaded = 1;
end

%% calculate reaction time
for (i = 1:size(data,1)) %go through each run
    for (j = 1:size(data{i,2},2))
        dataXPos = data{i,2}(j).Left_HandX; %xpos
        dataYPos = data{i,2}(j).Left_HandY; %ypos
        maxSpeed(i,j) = max(hypot(data{i,2}(j).Left_HandXVel,data{i,2}(j).Left_HandYVel)); %hand speed
        dataAccel = hypot(data{i,2}(j).Left_HandXAcc,data{i,2}(j).Left_HandYAcc); %hand acceleration
        
        if (~isempty((find(contains(data{i,2}(j).EVENTS.LABELS,'TOO_EARLY'))))||isempty(find(contains(data{i,2}(j).EVENTS.LABELS,'RECT_TILTED')))) %if the trial is not too early
            startTime(i,j) = nan;
            tiltTime(i,j) = nan;
            jumpTime(i,j) = nan;
            trialResult(i,j) = nan;
            maxSpeed(i,j) = nan;
        else %empty the value if there was a time out
            startTime(i,j) = round(data{i,2}(j).EVENTS.TIMES(find(contains(data{i,2}(j).EVENTS.LABELS,'TRIAL_START')))*1000); %get start of trial time
            tiltTime(i,j) = round(data{i,2}(j).EVENTS.TIMES(find(contains(data{i,2}(j).EVENTS.LABELS,'RECT_TILTED')))*1000); %get target appearance time
            if (find(contains(data{i,2}(j).EVENTS.LABELS,'CORRECT_RESP')))
                trialResult(i,j) = 1;
                if (find(contains(data{i,2}(j).EVENTS.LABELS,'INCORRECT_RESP')))
                    trialResult(i,j) = 0;
                end
            else
                trialResult(i,j) = 0; %too slow
            end
            if (find(contains(data{i,2}(j).EVENTS.LABELS,'AVA_JUMPED')))
                jumpTime(i,j) = round(data{i,2}(j).EVENTS.TIMES(find(contains(data{i,2}(j).EVENTS.LABELS,'AVA_JUMPED')))*1000); %time of jump
            else
                jumpTime(i,j) = nan;
            end
        end
        
        if (~isnan(jumpTime(i,j)) || ~isnan(tiltTime(i,j)))
            reactTimeFull(i,j) = jumpTime(i,j) - tiltTime(i,j);
        else
            reactTimeFull(i,j) = nan;
        end
    end
end
trialResult(isnan(trialResult)) = 0;
reactTimeFull(reactTimeFull == 0) = nan;

%% reorganize reaction time
dataVals = cell2mat(data(:,1));
c = arrayfun(@(x)length(find(dataVals == x)), unique(dataVals), 'Uniform', false);
interSess = cell2mat(c)/3;
interCur = 1;

part = 1;
sess = 1;
j = 1;
for (i  = 1:size(data,1))
    reactFull(i,1) = mean(reactTimeFull(i,:),'omitnan');
    errorFull(i,1) = 100*(240-sum(trialResult(i,:)))/240;
    reactRun(j) = mean(reactTimeFull(i,:),'omitnan');
    errorRun(j) = 100*(240-sum(trialResult(i,:)))/240;
    speedRun(i,1) = mean(maxSpeed(i,:),'omitnan');
    j = j + 1;
    if (j == 4)
        reactAvg(part,sess) = mean(reactRun,'omitnan');
        errorTrials(part,sess) = mean(errorRun,'omitnan');
        speedAvg(part,sess) = mean(speedRun,'omitnan');
        j = 1;
        sess = sess + 1;
        if (sess == (interSess(part))+1)
            part = part + 1;
            sess = 1;
        end
    end
end

listNames = [3,7,13,4,12,8,14,10,9,2,5,11,6,1]';
tempArray = cat(2,listNames,reactAvg);
reactOut = sortrows(tempArray,1);

tempArray = cat(2,listNames,errorTrials);
errorOut = (sortrows(tempArray,1));

tempArray = cat(2,listNames,speedAvg);
speedOut = (sortrows(tempArray,1));