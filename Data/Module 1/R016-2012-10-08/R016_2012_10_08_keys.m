ExpKeys.BehaviorOrder = {'Value','Risk'}; % note order matches elements of TimeOnTrack, TimeOffTrack
ExpKeys.Protocol = 'Hyperdrive';
ExpKeys.Target = {'Striatum','Hippocampus'};
ExpKeys.Target2 = {'Ventral','CA1'};
ExpKeys.TetrodeTargets = [2 2 1 1 1 1];
ExpKeys.TetrodeDepths = [2000 1960 6300 6380 6460 1920]; 

ExpKeys.TimeOnTrack(1) =  1.030e+03;
ExpKeys.TimeOffTrack(1) = 2.268e+03;

ExpKeys.TimeOnTrack(2) = 2.285e+03;
ExpKeys.TimeOffTrack(2) = 3.194e+03;

ExpKeys.Prerecord = [643 975];
ExpKeys.Postrecord = [3200 3523];

ExpKeys.Delay = [0.5 0.5]; % nosepoke-reward delay in seconds (matches BehaviorOrder)

ExpKeys.goodGamma = {'R016-2012-10-08-CSC04d.ncs','R016-2012-10-08-CSC03d.ncs'};
ExpKeys.goodSWR = {'R016-2012-10-08-CSC02b.ncs'};
ExpKeys.goodTheta = {'R016-2012-10-08-CSC02b.ncs'};

ExpKeys.CueToneMap = {'S3','S2','S4','S1','S2','S5'}; % tone IDs for 1, 3, 5, lowrisk, highrisk
