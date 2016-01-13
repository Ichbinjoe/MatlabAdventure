%%
load Adventure   % Loads the board (World - 10x10 cell array) along with a number of different image, shown below.
figure;imshow([World{1,:};World{2,:};World{3,:};World{4,:};World{5,:};World{6,:};World{7,:};World{8,:};World{9,:};World{10,:}]); %display board
warning('off','all'); % turns off all warning messages
