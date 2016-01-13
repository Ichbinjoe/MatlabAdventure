%%
load Adventure   % Loads the board (World - 10x10 cell array) along with a number of different image, shown below.
figure;imshow([World{1,:};World{2,:};World{3,:};World{4,:};World{5,:};World{6,:};World{7,:};World{8,:};World{9,:};World{10,:}]); %display board
warning('off','all'); % turns off all warning messages
% Definitions

% Type definitions
PLAYER = 1;
MONSTER = 2;
SUPERMONSTER = 3;
DOOR = 4;
HEALTHBOOST = 5;
SWORD = 6;
SHIELD = 7;
BOOT = 8;

% Column Definitions

TYPE = 1;
X_COL = 2;
Y_COL = 3;
ATTACK_COL = 4;
ATTACK_BOOST_COL = 5;
DEFENSE_COL = 6;
DEFENSE_BOOST_COL = 7;
HEALTH_COL = 8;
SPEED_COL = 9;
SPEED_BOOST_COL = 10;

% Init
EL = zeros(33,11);
EL(1,:) = [1 1 1 %Begin player spawn
for r = 1:1:33
    for c = 1:1:11
        
    end
end
% Start Play

% Movement

% Collision

% Combat Start

% Combat End

% End Play