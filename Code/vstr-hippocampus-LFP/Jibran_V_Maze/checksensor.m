function [nosepoke] =  checksensor(TTLIntputPort,Feeder)
[succeeded, cheetahReply] = NlxSendCommand(cat(2,'-GetDigitalIOPortString AcqSystem1_0 ',num2str(TTLIntputPort)));
C = bitget(str2num(cell2mat(cheetahReply)),Feeder+1);

% str2num(cell2mat(cheetahReply)) % for debugging

if(C == 1)
    nosepoke = 1;
else
    nosepoke = 0;
end