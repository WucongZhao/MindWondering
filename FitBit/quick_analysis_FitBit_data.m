clear all;
close all;

%% Build a for loop to plot the average number of steps per minute for each participant
step_files=dir('treadmill_fitbit_september2020_step*.csv');
for nFile=1:length(step_files)
    
    fileName=step_files(nFile).name;
    data = importfile_fitbit_data(fileName);
    datamat=table2array(data);
    
    %
    figure; 
    plot(datamat(:,1)/60,mean(datamat(:,2:end),2))
    xlabel('Time (h)')
    ylabel('Average step count')
    %format_fig;
    title(fileName)
    
    %
    figure; 
    datavec=reshape(datamat(:,2:end),1,numel(datamat(:,2:end)));
    datavec(datavec==0)=[];
    histogram(datavec,'Normalization','probability');
    xlabel('Step Count')
    ylabel('Probability')
    %format_fig;
    title(fileName)
end

%% Build a for loop to plot the average number of heartbeat per minute for each participant
heartbeat_files=dir('treadmill_fitbit_september2020_heartbeat*.csv');
for nFile=1:length(heartbeat_files)
    
    fileName=heartbeat_files(nFile).name;
    data = importfile_heartbeat_data(fileName);
    datamat=table2array(data);
    
    %
    figure;
    set(gcf,'Position',[132         622        1644         348])
    
    subplot(1,3,1);
    plot(datamat(:,1)/60,nanmean(datamat(:,2:end),2))
    xlabel('Time (h)')
    ylabel('Average Heart Rate (bpm)')
    %format_fig;
    title(fileName)
    
    %
    subplot(1,3,2);
    datavec=reshape(datamat(:,2:end),1,numel(datamat(:,2:end)));
    datavec(datavec==0)=[];
    histogram(datavec,'Normalization','probability');
    xlabel('Heartbeat (bpm)')
    ylabel('Probability')
    %format_fig;
%     title(fileName)
    
    %
    subplot(1,3,3);
    imagesc(datamat(:,1)/60,1:31,datamat(:,2:end)')
    xlabel('Time (h)')
    ylabel('Day')
    set(gca,'Xtick',0:24)
%     format_fig;
    colorbar;
%     title(fileName)
end