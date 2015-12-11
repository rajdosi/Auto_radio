
function [rms] = rms_test(filewav)

% Read wav file
[aud, fs]= audioread(filewav);

% find length of wav file
len_samp = length(aud);

% Length of frames
fsize = 0.020;
flen = round(fs*fsize);
fps = round(1/fsize); % 50 frames per second
% Calculate RMS value of each frame
rms = [];
n = 1;
for frame = 1:flen:len_samp-flen
 frameaud = aud(frame:frame+flen-1);

 % Calculate RMS value of frame
 rms(n) = sqrt(sum(frameaud.^2)/length(frameaud));
 n = n +1;
end
num_frames = length(rms);

% Calculate number of low energy frames
lef = 0;
% If more than 1 second of frames
if (num_frames > fps)
 for j = fps+1:num_frames
    meanRMS(j) = mean(rms(j-fps:j));
    if (rms(j) < 0.5*meanRMS(j))
    lef = lef + 1;
    end
 end
end
% Result is percentage of low energy frames
rms = lef/(num_frames-fps);
end