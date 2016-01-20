%%
close all;
clear all;
load Adventure   % Loads the board (World - 10x10 cell array) along with a number of different image, shown below.
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
EL(1,:) = [1 1 1 10 0 10 0 10 10 0]; %Begin player spawn (10 attack, health, Speed, Defense is default Placeholder)
rng('shuffle'); %Seeds the random function based on current time
EL(2,:) = [2 randi([7 8]) randi([7 8]) 0 0 0 0 100000 0 0]; %Randomly spawns door location
EL(3,:) = [3 EL(2,2)-1 EL(2,3)-1 EL(1,4) 0 EL(1,6) 0 EL(1,8) EL(1,9) 0]; %Randomly spawns monster location within a 3 coordinate radius of the door. Also indexes into the players health, speed and defense stats to create a metroid-esque evil player (see Ryan for more details) 
for r = 4:1:33
    for c = 1:1:10
        rng('shuffle'); %randomly seeds entity generation based on current time
        if c == 1
            EL(r,c) = randi([4 8]); %Assigns random entity calues
        elseif c == 2
            EL(r,c) = randi([2 10]);
        elseif c==3
            EL(r,c) = randi([1 10]);
        end
    end
end
%The use of shuffled x y coordinates leads to some repitition in entity
%location. This is resolved by the random generation. While an entity will
%oscillate between two x y coordinates in each new instance of a game, it
%has an 80% chance of being a different type of entity (i.e. a health
%potion at coordinate (3,4) may be a monster the next match, or something
%else at coordinate (4,3).
World{EL(1,2),EL(1,3)} = Player; %indexes into World location for player based on x y coordinates given in the Entity List. Assigns Cell values to the values in the Player image (Test)
for r = 4:1:33
    if EL(r,1) == 4
        while World{EL(r,2), EL(r,3)} ~= Blank
            EL(r,2) = randi([2 10]);
            EL(r,3) = randi([1 10]);
        end
        World{EL(r,2), EL(r,3)} = Monster; %Checks Entity type for Monster
    elseif EL(r,1) == 5
        while World{EL(r,2), EL(r,3)} ~= Blank
            EL(r,2) = randi([2 10]);
            EL(r,3) = randi([1 10]);
        end
        World{EL(r,2), EL(r,3)} = Health; %Checks Entity type for Health
    elseif EL(r,1) == 6
        while World{EL(r,2), EL(r,3)} ~= Blank
            EL(r,2) = randi([2 10]);
            EL(r,3) = randi([1 10]);
        end
        World{EL(r,2), EL(r,3)} = Sword; %Checks Entity type for Sword
    elseif EL(r,1) == 7
        while World{EL(r,2), EL(r,3)} ~= Blank
            EL(r,2) = randi([2 10]);
            EL(r,3) = randi([1 10]);
        end
        World{EL(r,2), EL(r,3)} = Shield; %Checks Entity type for Shield
    elseif EL(r,1) == 8
        while World{EL(r,2), EL(r,3)} ~= Blank
            EL(r,2) = randi([2 10]);
            EL(r,3) = randi([1 10]);
        end
        World{EL(r,2), EL(r,3)} = Boots; %Checks Entity type for Health
    end
end
World{EL(2,2), EL(2,3)} = Door;
World{EL(3,2), EL(3,3)} = Monster-60;
imshow([World{1,:};World{2,:};World{3,:};World{4,:};World{5,:};World{6,:};World{7,:};World{8,:};World{9,:};World{10,:}]); %displays updated board with Player entity displayed in assigned location
% Start Play

% Movement

% Collision

% Combat Start

% Combat End

% End Play