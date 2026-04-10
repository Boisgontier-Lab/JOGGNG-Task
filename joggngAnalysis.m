close all
clear all

% accelMain = readtable('JOGGNG STUDY_Summary.csv');
dataMain = readtable('JOGGNGStudyPartInfo_260407.xlsx','Sheet','Main');
joggngRT = readtable('JOGGNGStudyPartInfo_260407.xlsx','Sheet','JOGGNGRT');
joggngErr = readtable('JOGGNGStudyPartInfo_260407.xlsx','Sheet','JOGGNGError');
joggngSpeed = readtable('JOGGNGStudyPartInfo_260407.xlsx','Sheet','JOGGNGSpeed');

% dataMain([1,2,3,13,14,15,34,35,36],:) = []; %remove all incomplete data
compInterData = [2,4,5,7];
incompInter = [1,5,12];
parts = 14;
params = 15;
xplots = 3;
yplots = 5;
jitter = 0.05;
dirFullFile = ['C:\Users\apark2\OneDrive\KayneWork\OttawaPostDoc\JOGGNGPaper'];

%% table to cells

cont = 1;
for (k = 1:parts)
    for (j = 1:3)
        partData{k}(j,1) = dataMain.InterGroup(k*3-(3-j));
        partData{k}(j,2) = dataMain.InterGroup2(k*3-(3-j));
        partData{k}(j,3) = dataMain.Steps(k*3-(3-j));
        partData{k}(j,4) = dataMain.inactivePrc(k*3-(3-j));
        partData{k}(j,5) = dataMain.lightPrc(k*3-(3-j));
        partData{k}(j,6) = dataMain.modPrc(k*3-(3-j));
        partData{k}(j,7) = dataMain.vigPrc(k*3-(3-j));
        partData{k}(j,8) = dataMain.AATapa(k*3-(3-j));
        partData{k}(j,9) = dataMain.AATaps(k*3-(3-j));
        partData{k}(j,10) = dataMain.AATava(k*3-(3-j));
        partData{k}(j,11) = dataMain.AATavs(k*3-(3-j));
        partData{k}(j,12) = dataMain.PES(k*3-(3-j));
        partData{k}(j,13) = dataMain.WHOQOL(k*3-(3-j));
        partData{k}(j,14) = dataMain.Affect(k*3-(3-j));
        partData{k}(j,15) = dataMain.Instrum(k*3-(3-j));
        partData{k}(j,16) = dataMain.x6MWT(k*3-(3-j));
        partData{k}(j,17) = dataMain.Grip_KG_N_(k*3-(3-j));
        partData{k}(j,18) = dataMain.inactiveMins(k*3-(3-j));
        partData{k}(j,19) = dataMain.lightMins(k*3-(3-j));
        partData{k}(j,20) = dataMain.modMins(k*3-(3-j));
        partData{k}(j,21) = dataMain.vigMins(k*3-(3-j));
    end
end
dataCont = dataMain;
dataCont([2,3,5,6,8,9,11,12,14,15,17,18,20,21,23,24,26,27,29,30,32,33,35,36,38,39,41,42],:) = [];

%% split parts into control and inter and plot all and avg
labelNames = [{'group'};{'flipDir'};{'Steps'};{'Inactive'};{'Light'};{'Moderate'};{'Vigorous'};{'AppPA'};{'AppSB'};{'AvoidPA'};{'AvoidSB'};{'PES'};{'WHOQOL'};{'Affective'};{'Instrum'};{'6MWT'};{'Grip'};];
inter = 1;
cont = 1;
opacity = 0.3;
limitYFull = [0 25000; 0 100; 0 100; 0 100; 0 100; -700 500; -500 1500; -400 700; -200 1000;  0 5; 50 150; 0 15; 0 15; 250 650; 10 50];
limitY = [-3000 3000; -10 10; -10 10; -10 10; -10 10; -500 100; -500 100; -500 100; -500 100; -0.1 1; -1 3.5; -0.8 1; -0.8 1; -40 50; 0.6 3;];
paramFullFig = figure,
for (k = 1:size(partData,2))
    for (i = 1:params)
        subplot(xplots,yplots,i)

        hold on
        if (partData{k}(1,1)==1)
            plotCol = [1,0,0,opacity];
            iconUse = '-';
            if (find(k==incompInter))
                iconUse = '--';
            end
            interFull{1}(inter,i) = partData{k}(1,i+2);
            interFull{2}(inter,i) = partData{k}(2,i+2);
            interFull{3}(inter,i) = partData{k}(3,i+2);
        else
            plotCol = [0,0,0,opacity];
            iconUse = '-';
            contFull{1}(cont,i) = partData{k}(1,i+2);
            contFull{2}(cont,i) = partData{k}(2,i+2);
            contFull{3}(cont,i) = partData{k}(3,i+2);
        end
        % yyaxis("left")
        plot(1:3,partData{k}(1:3,2+i),iconUse,'Color',plotCol);
        % if (i > 1 && i < 6)
        %     yyaxis("right")
        %     plot(1:3,partData{k}(1:3,2+i+14),iconUse,'Color',plotCol);
        % end
        ylabel(labelNames{2+i});
        ylim(limitYFull(i,:))
        xlim([0.5 3.5])
    end
    
    if (partData{k}(1,1)==1)
        inter = inter + 1;
    else
        cont = cont + 1;
    end
    
    
end

for (i = 1:3)
    for (j = 1:params)
        interAvg(i,j) = mean(interFull{i}(compInterData,j));
        contAvg(i,j) = mean(contFull{i}(:,j));
        interStd(i,j) = nanstd(interFull{i}(compInterData,j));
        contStd(i,j) = nanstd(contFull{i}(:,j));
    end
end

for (i = 1:params)
    subplot(xplots,yplots,i)
    hold on
    errorbar((1:3)-jitter,contAvg(1:3,i),contStd(1:3,i),'-o','Color',[0,0,0],'MarkerFaceColor',[0,0,0])
    errorbar((1:3)+jitter,interAvg(1:3,i),interStd(1:3,i),'-o','Color',[1,0,0],'MarkerFaceColor',[1,0,0])
end
print(paramFullFig,fullfile(dirFullFile,'paramsFull'),'-dsvg');

%% plots pre/post intervention (21) and post inter/followup (32)
count = 1;
paramChangeFig = figure,
for (i = 1:params)
    subplot(xplots,yplots,i)
    interDiff21(i) = interAvg(2,i)-interAvg(1,i);
    interDiff32(i) = interAvg(3,i)-interAvg(2,i);
    interIndiv21(i) = interFull{2}(i)-interFull{1}(i);
    interIndiv32(i) = interFull{3}(i)-interFull{2}(i);
    contDiff21(i) = contAvg(2,i)-contAvg(1,i);
    contDiff32(i) = contAvg(3,i)-contAvg(2,i);
    contIndiv21(i) = contFull{2}(i)-contFull{1}(i);
    contIndiv32(i) = contFull{3}(i)-contFull{2}(i);

    interDiff31(i) = interAvg(3,i)-interAvg(1,i);
    interIndiv31(i) = interFull{3}(i)-interFull{1}(i);
    contDiff31(i) = contAvg(3,i)-contAvg(1,i);
    contIndiv31(i) = contFull{3}(i)-contFull{1}(i);

    scatter(1.5+jitter,interDiff21(i),'ro','filled')
    hold on
    scatter(2.5+jitter,interDiff32(i),'ro','filled')
    scatter(3.5+jitter,interDiff31(i),'ro','filled')
    % scatter(1.5+jitter,interIndiv21(i),'ro','filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3)
    % scatter(2.5+jitter,interIndiv32(i),'ro','filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3)
    % scatter(3.5+jitter,interIndiv31(i),'ro','filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3)
    scatter(1.5-jitter,contDiff21(i),'ko','filled')
    scatter(2.5-jitter,contDiff32(i),'ko','filled')
    scatter(3.5-jitter,contDiff31(i),'ko','filled')
    % scatter(1.5-jitter,contIndiv21(i),'ko','filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3)
    % scatter(2.5-jitter,contIndiv31(i),'ko','filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3)
    % scatter(3.5-jitter,contIndiv32(i),'ko','filled','MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3)
    % errorbar(1.5+jitter,interDiff21(i),sdInter21(i),'Color','r','MarkerFaceColor','r')
    % hold on
    % errorbar(2.5+jitter,interDiff32(i),sdInter32(i),'Color','r','MarkerFaceColor','r')
    % errorbar(3.5+jitter,interDiff31(i),sdInter31(i),'Color','r','MarkerFaceColor','r')
    % errorbar(1.5-jitter,contDiff21(i),sdCont21(i),'Color','k','MarkerFaceColor','k')
    % errorbar(2.5-jitter,contDiff32(i),sdCont32(i),'Color','k','MarkerFaceColor','k')
    % errorbar(3.5-jitter,contDiff31(i),sdCont31(i),'Color','k','MarkerFaceColor','k')
    if (i == 1||i == 2||i==3||i==4||i==5||i==6||i==7||i==8||i==9||i==10||i==11||i==12 || i == 13)
        line([0.5 4.5],[0 0],'Color','k')
    end
    xticks([0.5 1.5 2.5 3.5 4.5])
    xlim([0.5 4.5])
    ylabel(labelNames{2+i});
    ylim(limitY(i,:))
end
print(paramChangeFig,fullfile(dirFullFile,'paramChange'),'-dsvg');

%% joggngRT plots
% inter = 0;
% cont = 0;
% %rt between cont/inter
% rtAll(1:9,:) = table2array(joggngRT(1:9,4:12));
% 
% jogRTFig = figure,
% for (k = 1:size(joggngRT,1)) 
%     hold on
%     if (table2array(joggngRT(k,2))==1)
%         plot(1:9,table2array(joggngRT(k,4:12)),'-','Color',[1,0,0,opacity])
%         inter = inter + 1;
%         jogRTInter(inter,:) = table2array(joggngRT(k,4:12));
%     else
%         plot(1:9,table2array(joggngRT(k,4:12)),'-','Color',[0,0,0,opacity])
%         cont = cont + 1;
%         jogRTCont(cont,:) = table2array(joggngRT(k,4:12));
%     end
% end
% errorbar((1:9)+jitter,mean(jogRTInter,'omitnan'),nanstd(jogRTInter),'-o','Color','r','MarkerFaceColor','r')
% errorbar((1:9)-jitter,mean(jogRTCont,'omitnan'),nanstd(jogRTCont),'-o','Color','k','MarkerFaceColor','k')
% ylabel('Reaction Time')
% xlabel('Intervention Session')
% xlim([0.5 9.5])
% title('Red is inter, black is cont')
% print(jogRTFig,fullfile(dirFullFile,'joggngRT'),'-dsvg');
% %controls and intervention were similar RT
% 
% inter = 0;
% cont = 0;
% %rt between cont/inter
% errAll(1:9,:) = table2array(joggngErr(1:9,4:12));
% 
% jogErrFig = figure,
% for (k = 1:size(joggngErr,1)) 
%     hold on
%     if (table2array(joggngErr(k,2))==1)
%         plot(1:9,table2array(joggngErr(k,4:12)),'-','Color',[1,0,0,opacity])
%         inter = inter + 1;
%         jogErrInter(inter,:) = table2array(joggngErr(k,4:12));
%     else
%         plot(1:9,table2array(joggngErr(k,4:12)),'-','Color',[0,0,0,opacity])
%         cont = cont + 1;
%         jogErrCont(cont,:) = table2array(joggngErr(k,4:12));
%     end
% end
% errorbar((1:9)+jitter,mean(jogErrInter,'omitnan'),nanstd(jogErrInter),'-o','Color','r','MarkerFaceColor','r')
% errorbar((1:9)-jitter,mean(jogErrCont,'omitnan'),nanstd(jogErrCont),'-o','Color','k','MarkerFaceColor','k')
% ylabel('Error (%)')
% xlabel('Intervention Session')
% xlim([0.5 9.5])
% title('Red is inter, black is cont')
% print(jogErrFig,fullfile(dirFullFile,'joggngErr'),'-dsvg');
% %controls and intervention were similar Err
% 
% inter = 0;
% cont = 0;
% %rt between cont/inter
% speedAll(1:9,:) = table2array(joggngSpeed(1:9,4:12));
% 
% jogErrFig = figure,
% for (k = 1:size(joggngSpeed,1)) 
%     hold on
%     if (table2array(joggngSpeed(k,2))==1)
%         plot(1:9,table2array(joggngSpeed(k,4:12)),'-','Color',[1,0,0,opacity])
%         inter = inter + 1;
%         jogSpeedInter(inter,:) = table2array(joggngSpeed(k,4:12));
%     else
%         plot(1:9,table2array(joggngSpeed(k,4:12)),'-','Color',[0,0,0,opacity])
%         cont = cont + 1;
%         jogSpeedCont(cont,:) = table2array(joggngSpeed(k,4:12));
%     end
% end
% errorbar((1:9)+jitter,mean(jogSpeedInter,'omitnan'),nanstd(jogSpeedInter),'-o','Color','r','MarkerFaceColor','r')
% errorbar((1:9)-jitter,mean(jogSpeedCont,'omitnan'),nanstd(jogSpeedCont),'-o','Color','k','MarkerFaceColor','k')
% ylabel('Speed (m/s)')
% xlabel('Intervention Session')
% xlim([0.5 9.5])
% title('Red is inter, black is cont')
% print(jogErrFig,fullfile(dirFullFile,'joggngSpeed'),'-dsvg');
% %controls and intervention were similar speed
% 
% %rt between cw/ccw
% ccw = 0;
% cw = 0;
% figure,
% for (k = 1:size(joggngRT,1))
%     hold on
%     if (table2array(joggngRT(k,3))==1)
%         plot(1:9,table2array(joggngRT(k,4:12)),'-','Color',[0,0,1,opacity])
%         cw = cw + 1;
%         jogRTcw(cw,:) = table2array(joggngRT(k,4:12));
%     else
%         plot(1:9,table2array(joggngRT(k,4:12)),'-','Color',[0,1,0,opacity])
%         ccw = ccw + 1;
%         jogRTccw(ccw,:) = table2array(joggngRT(k,4:12));
%     end
% end
% errorbar((1:9)+jitter,mean(jogRTcw,'omitnan'),nanstd(jogRTcw),'-o','Color','b','MarkerFaceColor','b')
% errorbar((1:9)-jitter,mean(jogRTccw,'omitnan'),nanstd(jogRTccw),'-o','Color','g','MarkerFaceColor','g')
% xlim([0.5 9.5])
% %clockwise was slower until the last sessions

% parameter correlations
mainLabel = [{'Steps'};{'Inactive'};{'Light'};{'Moderate'};{'Vigorous'};{'AppPA'};{'AppSB'};{'AvoidPA'};{'AvoidSB'};{'PES'};{'WHOQOL'};{'Affective'};{'Instrum'};{'6MWT'};{'Grip'};];
counter = 1;
dataStart = 13;
heatMapFig = figure,
for (i = 1:params)
    for (j = 1:params)
        [corrCompare(i,j),pvalCompare(i,j)] = corr(table2array(dataCont(:,i+dataStart)),table2array(dataCont(:,j+dataStart)),'type','Spearman');
        xlabel(mainLabel{i})
        ylabel(mainLabel{j})
        title(['r = ', num2str(round(corrCompare(i,j),2))])
        counter = counter + 1;
    end
end
roundedCompare = abs(round(corrCompare,2));
heatmap(mainLabel,mainLabel,roundedCompare)
print(heatMapFig,fullfile(dirFullFile,'paramHeatmap'),'-dsvg');
% ,"Colormap",hot