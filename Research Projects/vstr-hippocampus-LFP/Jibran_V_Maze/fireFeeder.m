function fireValve(TTLIOPort,Feeder)
pulseDuration = 200; % in ms
if (PelletCount ~= 0) % nonzero number
    [succeeded, cheetahReply] = NlxSendCommand(cat(2,'-SetDigitalIOPulseDuration AcqSystem1_0 ',num2str(TTLIOPort), ' ' ,num2str(pulseDuration)));
    if succeeded == 0
        disp 'FAILED to Set duration'
        return;
    end
    [succeeded, cheetahReply] = NlxSendCommand(cat(2,'-DigitalIOTTLPulse AcqSystem1_0 ',num2str(TTLIOPort), ' ' ,num2str(Feeder), ' High'));
    if succeeded == 0
        disp 'FAILED to Pulse'
        return;
    end
else
    [succeeded, cheetahReply] = NlxSendCommand('-PostEvent "Null Pellet" 128 666');
    if succeeded == 0
        disp 'FAILED to Set duration'
        return;
    end
end
