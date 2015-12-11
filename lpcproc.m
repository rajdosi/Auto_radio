% lpcproc.m
% Perform LPC analyis on input data
% Return LPC filter coefficients, residuals, and residual stream
% Adapted from Reference [5]:
% G.C. Orsak, et al, "Collaborative SP education using the Internet and
% MATLAB" IEEE Signal Processing Magazine, Vol. 12, No. 6, pp. 23-32, Nov. 1995.


function [A,resid,stream] = lpcproc(data,fs,N,frameRate,frameSize)

if (nargin<3), N =13; end
if (nargin<4), frameRate = 20; end
if (nargin<5), frameSize = 30; end
if (nargin<6), preemp = .9378; end

[row col] = size(data);
if col==1 data=data; end

% Set up
nframe =0;
samp_between_frames = round(fs/1000*frameRate);
samp_per_frame = round(fs/1000*frameSize);
duration = length(data);
samp_overlap = samp_per_frame - samp_between_frames;

% Function to add overlapping frames back together
ramp = [0:1/(samp_overlap-1):1]';

% Preemphasize speech
speech = filter([1 -preemp], 1, data)';

% For each frame of data
for frameIndex=1:samp_between_frames:duration-samp_per_frame+1

 % Pick out frame data
 frameData = speech(frameIndex:(frameIndex+samp_per_frame-1));
 nframe = nframe + 1;

 autoCor = xcorr(frameData); % Compute the cross correlation
 autoCorVec = autoCor(samp_per_frame+[0:N]);
 
% Levinson's method
 err(1) = autoCorVec(1);
 k(1) = 0;
 a = [];
 for index=1:N
 numerator = [1 a.']*autoCorVec(index+1:-1:2);
 denominator = -1*err(index);
 k(index) = numerator/denominator; % PARCOR coeffs
 a = [a+k(index)*flipud(a); k(index)]; 
 err(index+1) = (1-k(index)^2)*err(index);
 end
 
 % LPC coefficients and gain
 A(:,nframe) = [1 ; a];
 G(nframe) = sqrt(err(N+1));

 % Inverse filter to get error signal
 errSig = filter([1 a'],1,frameData);
 resid(:,nframe) = errSig/G(nframe);

 % Add residuals together by frame to get continuous residual signal
 if(frameIndex==1)
    stream = resid(1:samp_between_frames,nframe);
 else
    stream = [stream];
    overlap+resid(1:samp_overlap,nframe).*ramp;
    resid(samp_overlap+1:samp_between_frames,nframe);
 end
 
 if(frameIndex+samp_between_frames+samp_per_frame-1 > duration)
    stream = [stream resid(samp_between_frames+1:samp_per_frame,nframe)];
 else
    overlap = resid(samp_between_frames+1:samp_per_frame,nframe).*flipud(ramp);
 end
end
stream = filter(1, [1 -preemp], stream);
end