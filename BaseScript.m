%%
load Adventure   % Loads the board (World - 10x10 cell array) along with a number of different image, shown below.
figure;imshow([World{1,:};World{2,:};World{3,:};World{4,:};World{5,:};World{6,:};World{7,:};World{8,:};World{9,:};World{10,:}]); %display board
warning('off','all'); % turns off all warning messages
% Definitions

% Type definitions
PLAYERT = 1;
DOORT = 2;
SUPERMONSTERT = 3;
MONSTERT = 4;
HEALTHBOOSTT = 5;
SWORDT = 6;
SHIELDT = 7;
BOOTT = 8;

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
EL = zeros(33,10); %Preallocating space for the Entity List
EL(1,:) = [1 1 1 100 0 100 0 100 100 0]; %Begin player spawn (100 attack, health, Speed, Defense is default Placeholder)
EL(2,:) = [2 randi(10) randi(10) 0 0 0 0 100000 0 0]; %Randomly spawns door location
for r = 2:1:33
    for c = 1:1:10
        if c == 1
            EL(r,c) = randi([5:8])
        elseif c == 2
            EL(r,c) = randi(10);
        elseif c == 3
            EL(r,c) = randi(10);
        end
        
    end
end
% Start Play

% Movement

% Collision

% Combat Start

% Combat End

% End Play