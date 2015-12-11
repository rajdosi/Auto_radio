
function [lpcv] = lpc_test(filewav)

% Read wav file
[aud, fs]= audioread(filewav);

% LPC Order
N =10;
% Length of frame
fsize = 0.020;
flen = round(fs*fsize);
fps = round(1/fsize); % 50 frames per second

% Perform LPC analysis
[A,strm] = lpc(aud,N);

% Find length of residual strm
len_samp = length(strm);

% Calculate normalized energy of each frame
energy = [];
n =1;
for frame = 1:flen:len_samp-flen
 energy(n) = sum(abs(strm(frame:frame+flen-1)).^2)/flen;
 n = n + 1;
end
num_frames = length(energy);

% Calculate percentage of high spikes
highpoints = 0;
% If more than 1 second of frames
if (num_frames > fps)
 for j = fps+1:num_frames
 % Mean energy over last second
 meanEnergy(j) = mean(energy(j-fps:j));
    if (energy(j) > 1.25*meanEnergy(j))
    highpoints = highpoints +1;
    end
 end
end
lpcv = highpoints/(num_frames-fps);
end