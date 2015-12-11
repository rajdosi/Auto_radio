
function [zcr] = zcr_test(filewav)


% Read wav file
[aud, fs]= audioread(filewav);

% find length of wav file
len_samp = length(aud);

% Length of frame
fsize = 0.20;
flen = round(fs*fsize);
fps = round(1/fsize); % 50 frames per second

% Calculate number of zero-crossings in each frame
zcr = [];
n = 1;
for frame = 1:flen:len_samp-flen
 frameaud = aud(frame:frame+flen-1);

 % Sum up zero crossings accross frame
 zcr(n) = 0;
 for i = 2:length(frameaud)
 zcr(n) = zcr(n) + abs(sign(frameaud(i)) - sign(frameaud(i-1)));
 end
 zcr(n) = zcr(n)/(2*flen);

 n = n + 1;
end
num_frames = length(zcr);


% Calculate variance in zero-crossing rate from last second of aud
lef = 0;
% If more than 1 second of frames
if (num_frames > fps)
 k =1;
 for j = fps+1:num_frames
 std_zcr(k) = std(zcr(j-fps:j));
 k = k + 1;
 end
end
% Result is mean 1-sec variance in zero crossing rate
zcr = mean(std_zcr);
end