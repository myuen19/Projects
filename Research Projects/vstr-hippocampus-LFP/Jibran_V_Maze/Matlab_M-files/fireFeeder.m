
function fireFeeder(TTLIOPort,Feeder,PelletCount)

% connected = NlxAreWeConnected();
% if connected ==1,
%     disp 'We are already connected';
% else
% serverName = '192.168.3.100';
% disp(sprintf('Connecting to %s...', serverName));
% succeeded = NlxConnectToServer(serverName);
% if succeeded ~= 1
%     disp(sprintf('FAILED connect to %s. Exiting script.', serverName));
%     return;
% end
% end
% 

pulseDuration = PelletCount*700;

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

end
