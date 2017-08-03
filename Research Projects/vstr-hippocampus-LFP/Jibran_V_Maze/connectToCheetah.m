function connected = connectToCheetah()
connected = NlxAreWeConnected();
if connected ==1,
    disp 'We are already connected';
else
    serverName = '192.168.3.100';
    disp(sprintf('Connecting to %s...', serverName));
    success = NlxConnectToServer(serverName);
    if success ~= 1
        disp(sprintf('FAILED connect to %s.', serverName));
        return;
    else
        disp(sprintf('Connected to Cheetah at %s.', serverName));
    end
end
