clear all;

% Set up training data :
train_mus = {'music1.wav','music2.wav','music3.wav','music4.wav'};
train_spe = {'speech1.wav','speech2.wav','speech3.wav','speech4.wav'};


% Music samples:
for i = 1:length(train_mus)
 t_lpc_mus(i) = lpc_test(cell2mat(train_mus(i)));
 t_zcr_mus(i) = zcr_test(cell2mat(train_mus(i)));
 t_rms_mus(i) = rms_test(cell2mat(train_mus(i)));
end
mean_t_lpc_mus = mean(t_lpc_mus);
mean_t_zcr_mus = mean(t_zcr_mus);
mean_t_rms_mus = mean(t_rms_mus);

% Speech samples:
for i = 1:length(train_spe)
 t_lpc_spe(i) = lpc_test(cell2mat(train_spe(i)));
 t_zcr_spe(i) = zcr_test(cell2mat(train_spe(i)));
 t_rms_spe(i) = rms_test(cell2mat(train_spe(i)));
end
mean_t_lpc_spe = mean(t_lpc_spe);
mean_t_zcr_spe = mean(t_zcr_spe);
mean_t_rms_spe = mean(t_rms_spe);




% Set up testing data:
music_files = dir(['m_*.wav']);
speech_files = dir(['s_*.wav']);


% Music samples:
for i = 1:length(music_files)
 lpc_mus(i) = lpc_test(music_files(i).name);
 zcr_mus(i) = zcr_test(music_files(i).name);
 rms_mus(i) = rms_test(music_files(i).name);
end

% Speech samples:
for i = 1:length(speech_files)
 lpc_spe(i) = lpc_test(speech_files(i).name);
 zcr_spe(i) = zcr_test(speech_files(i).name);
 rms_spe(i) = rms_test(speech_files(i).name);
end



% Scale all three features between 0 and 1 to normalize distances:
min_lpc = min([min(t_lpc_mus), min(t_lpc_spe), min(lpc_mus), min(lpc_spe)]);
max_lpc = max([max(t_lpc_mus), max(t_lpc_spe), max(lpc_mus), max(lpc_spe)]);
min_zcr = min([min(t_zcr_mus), min(t_zcr_spe), min(zcr_mus), min(zcr_spe)]);
max_zcr = max([max(t_zcr_mus), max(t_zcr_spe), max(zcr_mus), max(zcr_spe)]);
min_rms = min([min(t_rms_mus), min(t_rms_spe), min(rms_mus), min(rms_spe)]);
max_rms = max([max(t_rms_mus), max(t_rms_spe), max(rms_mus), max(rms_spe)]);


t_lpc_mus = (t_lpc_mus - min_lpc)/(max_lpc - min_lpc);
t_zcr_mus = (t_zcr_mus - min_zcr)/(max_zcr - min_zcr);
t_rms_mus = (t_rms_mus - min_rms)/(max_rms - min_rms);
t_lpc_spe = (t_lpc_spe - min_lpc)/(max_lpc - min_lpc);
t_zcr_spe = (t_zcr_spe - min_zcr)/(max_zcr - min_zcr);
t_rms_spe = (t_rms_spe - min_rms)/(max_rms - min_rms);


lpc_mus = (lpc_mus - min_lpc)/(max_lpc - min_lpc);
zcr_mus = (zcr_mus - min_zcr)/(max_zcr - min_zcr);
rms_mus = (rms_mus - min_rms)/(max_rms - min_rms);
lpc_spe = (lpc_spe - min_lpc)/(max_lpc - min_lpc);
zcr_spe = (zcr_spe - min_zcr)/(max_zcr - min_zcr);
rms_spe = (rms_spe - min_rms)/(max_rms - min_rms);


% Combine independent measures into one matrix for each set of data:
muc_train = [t_lpc_mus; t_zcr_mus; t_rms_mus];
spe_train = [t_lpc_spe; t_zcr_spe; t_rms_spe];
mus_test = [lpc_mus; zcr_mus; rms_mus];
spe_test = [lpc_spe; zcr_spe; rms_spe];

% Plot 3-D decision space:


% Plot training data:
plot3(muc_train(1,:), muc_train(2,:), muc_train(3,:), '*r');
hold on;
plot3(spe_train(1,:), spe_train(2,:), spe_train(3,:), '*b');

% Plot test data:
plot3(mus_test(1,:), mus_test(2,:), mus_test(3,:), '*g');
plot3(spe_test(1,:), spe_test(2,:), spe_test(3,:), '*k');

plot(muc_train(2,:), muc_train(3,:), '*r');
plot(spe_train(2,:), spe_train(3,:), '*b');

plot(mus_test(2,:), mus_test(3,:), '*g');
plot(spe_test(2,:), spe_test(3,:), '*k');

% Label:
xlabel('LPC Residual Energy Measure');
ylabel('Variance of Zero-Crossing Rate');
zlabel('Percentage of Low Energy Frames');
legend('Music Training Data','Speech Training Data','Music Test Data','Speech Test Data');
grid on;


% K-Nearest Neighbor Classification:
% Classify music samples:

music_classification = [];
for i = 1:length(mus_test)
% Calculate distaces to each of 8 training samples
 for j = 1:length(muc_train)
    dist(j) = sqrt((mus_test(1,i)-muc_train(1,j))^2 + (mus_test(1,i)-muc_train(1,j))^2 + (mus_test(1,i)-muc_train(1,j))^2);
 end
 for j = 1:length(spe_train)
    dist(j+4) = sqrt((mus_test(1,i)-spe_train(1,j))^2 + (mus_test(1,i)-spe_train(1,j))^2 + (mus_test(1,i)-spe_train(1,j))^2);
 end

 % Find three closest neighbors
 neighbor=[];
 sort_dist = sort(dist);
 n1 = find(dist == sort_dist(1));
 n2 = find(dist == sort_dist(2));
 n3 = find(dist == sort_dist(3));
 neighbor = [n1,n2,n3];
 %neighbor = neighbor(1:);

 % If 2 or more neighbors are music, classify as music
 % else classify as speech
 num_music_neighbors = find(neighbor <= 4);
 if (length(num_music_neighbors) >= 2)
 music_classification(i) = 0;
 else
 music_classification(i) = 1;
 end
end


% Classify speech samples:
speech_classification = [];
for i = 1:length(spe_test)

 % Calculate distaces to each of 8 training samples
 for j = 1:length(muc_train)
    dist(j) = sqrt((spe_test(1,i)-muc_train(1,j))^2 + (spe_test(1,i)-muc_train(1,j))^2 + (spe_test(1,i)-muc_train(1,j))^2);
 end
 for j = 1:length(spe_train)
    dist(j+4) = sqrt((spe_test(1,i)-spe_train(1,j))^2 + (spe_test(1,i)-spe_train(1,j))^2 + (spe_test(1,i)-spe_train(1,j))^2);
 end

 % Find three closest neighbors
 sort_dist = sort(dist);
 n1 = find(dist == sort_dist(1));
 n2 = find(dist == sort_dist(2));
 n3 = find(dist == sort_dist(3));
 neighbor = [n1,n2,n3];
 %neighbor = neighbor(1:3);

 % If 2 or more neighbors are music, classify as music
 % else classify as speech
 num_music_neighbors = find(neighbor <= 4);
 if (length(num_music_neighbors) >= 2)
 speech_classification(i) = 0;
 else
 speech_classification(i) = 1;
 end
end



% Calculate success measures:

music_correct = length(find(music_classification == 1));
speech_correct = length(find(speech_classification == 1));
total_correct = music_correct + speech_correct;

music_percent_correct = music_correct / length(music_classification);
speech_percent_correct = speech_correct / length(speech_classification);
total_percent_correct = total_correct / (length(music_classification)+length(speech_classification));


disp(['Music Sample Classification: ', num2str(music_percent_correct*100), ' %']);
disp(['Speech Sample Classification: ', num2str(speech_percent_correct*100), ' %']);
disp(['Total Sample Classification: ', num2str(total_percent_correct*100), ' %']);
%**********************************************************************
