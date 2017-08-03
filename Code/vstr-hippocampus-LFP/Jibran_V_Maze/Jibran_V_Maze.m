%% Control Script for Alcoholic V maze.
%
%                 P ID 4
%                 ^
%               / p \
%              /     \
%             /       \
%            /         \
%    ID 6 p---p       p---p ID 5
%          /             \
%        Alco ID6        H20  ID 7
%
%  p: photobeam
%  Alco: alcohol receptical/valve
%  H20: water receptical/vale
%
%%%%%%%%%%
%% Task %%
%%%%%%%%%%
%  Rat must cross the center of the V (ID5) to be able to recieve either
%  H20 or Alco.  Once ID 5 is crossed both ID6/7 can be triggered by
%  photobeams 5 or 6.  If Alco or H20 is triggered then the rat must cross
%  the middle to start the next trial.
%
% No Cues are used.
%
%%%%%%%%%%%%
% INFO %%%%%
%%%%%%%%%%%%
% this Script the following Matlab functions :
%
% clock : Current date and time as date vector.
%     C = clock returns a six element date vector containing the current time
%     and date in decimal form:
%
% etime : Elapsed time.
%     etime(T1,T0) returns the time in seconds that has elapsed between
%     vectors T1 and T0.  The two vectors must be six elements long, in
%     the format returned by CLOCK:
%
%  by Julien Catanese in mvdmlab 2013


%%
cd('/Users/Matthew/Desktop/vstr-hippocampus-LFP/Jibran_V_Maze')
addpath(genpath('/Users/Matthew/Desktop/vstr-hippocampus-LFP/Jibran_V_Maze'));
clear all; close all; 
%%
success = connectToCheetah();
if ~success
    error('Failed to connect to server. Try again.'); beep;
end
%%
task = 'V Maze';
ratID = input('Rat number? ','s');
date = datestr(date, 'yyyy-mm-dd');
session = input('session? ','s');


%% check for photobeam break
SET_INPUT_port = 1;
middle= 4;
near = 5;
far = 6;
alc = 7;
H20 = 6;
if checksensor(SET_INPUT_port,middle); disp('Middle beam Broken'); end
if checksensor(SET_INPUT_port,far); disp('Far beam Broken'); end
if checksensor(SET_INPUT_port,near); disp('Near beam Broken'); end
% 4 is "middle"
% 5 is "far"
% 6 is "near" (to the door)
for i_o = 1:2
    for id = 0:7
        if checksensor(i_o,id)
            disp(num2str(id))
        end
    end
end
%%

%%%%%%%%%%%%
%%% INIT var %%%
%%%%%%%%%%%%

TTLOutputPort=0; % use with : fireFeeder(TTLOutputPort, activefeeder, number_of_pellets); (see in utility function at the end of this file)
TTLInputPort=1; % use with : checksensor(TTLInputPort, activefeeder, number_of_pellets); (see in utility function at the end of this file)

maxTimeToRun = 11*60;
delay = .5; % 1 sec to nosepoke before rwd
trial_num = 0;
alc_num = 0;
H2O_num = 0;
armed = 0;
t0=clock;
vol = 0.25; % volume output in ml.
%%%%%%%%%%%
%%% RUN %%%
%%%%%%%%%%%
%%
disp('start')
figure(1); h = title('Setting up...');
ylabel('Trials')
while etime(clock, t0) < maxTimeToRun
    if checksensor(TTLInputPort, middle); armed = 1; end% determine if the middle sensor has been broken
    
    switch armed
        
        
        case 0
            status = 'unarmed';
            % check near "Alco" photobeam
            %npoke = checksensor(TTLInputPort, near);
            %[succeeded, cheetahReply] = NlxSendCommand('-PostEvent "Start_Nosepoke" 0 100');  % save a event file (add entry to event log).
            
            lastclock = clock;
            
            title(sprintf('total time %.2f, trial %d, Alcohol %d, H2O %d, Status %s',etime(clock,t0),trial_num, alc_num, H2O_num, status));
            drawnow;
            
        case 1
            status = 'armed';
            % check near "Alco" photobeam
            near_poke = checksensor(TTLInputPort, near);
            npoketime = etime(clock,t0);
            while near_poke ~=0
                [succeeded, cheetahReply] = NlxSendCommand('-PostEvent "alc_nosepoke" 1 30');
                if etime(clock,lastclock) >= delay
                    disp('near broken')
                    alc_num = alc_num+1;
                    trial_num = trial_num +1;
                    [succeeded, cheetahReply] = NlxSendCommand('-PostEvent "Alc_reward" 1 30');
                    fireValve(TTLOutputPort, alc)
                    near_poke = 0;
                    armed = 0;
                end
            end
            
            
            far_poke = checksensor(TTLInputPort, far);
            npoketime = etime(clock,t0);
            while far_poke ~=0
                [succeeded, cheetahReply] = NlxSendCommand('-PostEvent "H20_nosepoke" 1 30');
                
                if etime(clock,lastclock) >= delay
                    disp('far borken')
                    H2O_num = H2O_num+1;
                    trial_num = trial_num +1;
                    [succeeded, cheetahReply] = NlxSendCommand('-PostEvent "H20_reward" 1 30');
                    armed = 0;
                    fireValve(TTLOutputPort, H20)
                    far_poke = 0;
                end
            end
            %             [succeeded, cheetahReply] = NlxSendCommand('-PostEvent "Start_Nosepoke" 0 100');  % save a event file (add entry to event log).
            
            lastclock = clock;
            
            title(sprintf('total time %.2f, trial %d, Alcohol %d, H2O %d, Status %s',etime(clock,t0),trial_num, alc_num, H2O_num, status));
            drawnow;
            
            
            bar([alc_num; H2O_num])
            
            drawnow;
    end
end
%% Consolidate
totaltime =  etime(lastclock, t0);
Session_out.trial_num = trial_num;
Session_out.alc_num = alc_num;
Session_out.H2O_num = H2O_num;
Session_out.totaltime = totaltime;
Session_out.alc_vol = (alc_num * vol) +vol;
Session_out.H2O_vol = (H2O_num * vol) +vol;
Session_out.cfg.delay = delay;
Session_out.cfg.time = maxTimeToRun;
%% save
save(['C:\Users\admin\Documents\CheetahControlScripts\Eric\Jibran_alc' num2str(ratID) '_' task '_session' num2str(session)  '_day' num2str(date) '_ Behavior.mat'], 'Session_out')
%  load (['C:\Users\mvdmlab\Dropbox\data\Julien_Behavior\Rat' ratnumber '_day' num2str(date) '_NoChoiceTask_Behavior.mat'], 'CountPellets','CountTrials', 'rewardstimes', 'nosepokestimes', 'totaltime')
disp (['Trials = ' num2str(trial_num) ])
score = trial_num/(totaltime/60) ;
disp(['score = '  num2str(score) ' trial/minute' ])
disp (['H20 Trials = ' num2str(H2O_num) ])
disp (['Alc Trials = ' num2str(alc_num) ])
disp(['R' num2str(ratID) '-' num2str(date) ' [recording]'])


%             while npoke~=0
%
%                 npoke = checksensor(TTLInputPort, activeFeeder);
%                 npoketime = etime(clock,t0);
%
%                 if etime(clock,lastclock) >= delay
%
%                     beep;
%
%                     [succeeded, cheetahReply] = NlxSendCommand('-PostEvent "End_nosepoke" 1 30');
%
%                     fireFeeder(TTLOutputPort, activeFeeder, number_of_pellets);  % release 1 pellet
%
%                     Count_alc = Count_alc + number_of_pellets;
%                     CountTrials = CountTrials + 1;
%                     rewardstimes(CountTrials) = etime(clock,t0);
%                     nosepokestimes(CountTrials) = npoketime;
%
%                     disp(sprintf('Firing %d pellets from feeder %d', number_of_pellets, activeFeeder));
%
%                     if activeFeeder == 1
%                         [succeeded, cheetahReply] = NlxSendCommand(['-PostEvent "Feed1_' num2str(number_of_pellets) 'pellet_dispensed" 11 30']);
%                         activeFeeder=0;
%                     else
%                         [succeeded, cheetahReply] = NlxSendCommand(['-PostEvent "Feed2_' num2str(number_of_pellets) 'pellet_dispensed" 21 30']);
%                         activeFeeder=1;
%                     end
%
%                     npoke=0;
%                 end
%
