
close all;
clear all;
load Adventure   % Loads the board (World - 10x10 cell array) along with a number of different image, shown below.
warning('off','all'); % turns off all warning messages
% Definitions

SOUND = 0;

% Type definitions
PLAYERT = 1;
DOORT = 2;
SUPERMONSTERT = 3;
MONSTERT = 4;
HEALTHBOOSTT = 5;
SWORDT = 6;
SHIELDT = 7;
BOOTT = 8;

IMG = {Player, Door, Monster, Monster, Health, Sword, Shield, Boots};
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
            EL(r,c) = randi([4 8]); %Assigns random entity values
            if EL(r,c) == MONSTERT
                EL(r,MONSTERT) = randi([10 20]);
                EL(r,8) = randi([10 20]);
                EL(r,DEFENSE_COL) = randi([10 20]);
                EL(r,SPEED_COL) = randi([10 20]);
            elseif EL(r,c) == HEALTHBOOSTT
                EL(r,8) = randi([1 10]);
            elseif EL(r,c) == SWORDT
                EL(r,ATTACK_BOOST_COL) = randi([2 10]);
            elseif EL(r,c) == SHIELDT
                EL(r,DEFENSE_BOOST_COL) = randi([2 10]);
            elseif EL(r,c) == BOOTT
                EL(r,SPEED_BOOST_COL) = randi([2 10]);
            end
        elseif c == 2
            EL(r,c) = randi([2 10]);
        elseif c==3
            EL(r,c) = randi([1 10]);
        end
        
    end
end
if SOUND == 1
    [y Fs] = audioread('Theme.mp3'); % Reads file � must be in current directory
    Theme = audioplayer(.3*y,Fs);  
    % Saves as song using sampling rate, Fs
    [y Fs] = audioread('Sword.mp3');
    Sword = audioplayer(.1*y,Fs);
    [y Fs] = audioread('Shield.wav');
    Shield = audioplayer(.1*y,Fs);
    [y Fs] = audioread('Health.wav');
    Health = audioplayer(.5*y,Fs);
end
%The use of shuffled x y coordinates leads to some repitition in entity
%location. This is resolved by the random generation. While an entity will
%oscillate between two x y coordinates in each new instance of a game, it
%has an 80% chance of being a different type of entity (i.e. a health
%potion at coordinate (3,4) may be a monster the next match, or something
%else at coordinate (4,3).
World{EL(1,X_COL),EL(1,Y_COL)} = Player; %indexes into World location for player based on x y coordinates given in the Entity List. Assigns Cell values to the values in the Player image (Test)
for r = 4:1:33
        while World{EL(r,2), EL(r,3)} ~= Blank %Checks to make sure the initial spawn point is blank, and creates new spawn point if it isn't
            EL(r,X_COL) = randi([2 10]);
            EL(r,Y_COL) = randi([1 10]);
        end
        World{EL(r,X_COL), EL(r,Y_COL)} = IMG{EL(r,TYPE)}; %Checks entity location on entity list, then indexes into the image master matrix for the entities image
end
World{EL(2,X_COL), EL(2,Y_COL)} = Door;
World{EL(3,X_COL), EL(3,Y_COL)} = Monster-60;

% Start Play
Game = 1;
if SOUND == 1
    play(Theme)   % Plays the song
end
while Game == 1
   clc;
   disp 'Health: ';disp(EL(PLAYERT,HEALTH_COL));disp ' Attack: ';disp(EL(PLAYERT,ATTACK_COL));disp ' Defense: ';disp(EL(PLAYERT,DEFENSE_COL));disp ' Speed: ';disp(EL(PLAYERT,SPEED_COL));
   if EL(PLAYERT,HEALTH_COL) == 0
       Game = 0;
   elseif EL(SUPERMONSTERT,HEALTH_COL) == 0
       Game = 0;
   elseif (EL(PLAYERT,X_COL) == EL(DOORT,X_COL)) && (EL(PLAYERT,Y_COL) == EL(DOORT,Y_COL))
       game = 0;
   end
   World{EL(1,X_COL),EL(1,Y_COL)} = Player; %indexes into World location for player based on x y coordinates given in the Entity List. Assigns Cell values to the values in the Player image (Test)
for r = 1:10
    for c = 1:10
        World{r,c} = Blank; %Clears all world tiles in order for entity locations to be reset
        if (r > EL(PLAYERT,X_COL) + 1 || r < EL(PLAYERT,X_COL)-1) || (c > EL(PLAYERT,Y_COL) + 1 || c < EL(PLAYERT,Y_COL) - 1)
            World{r,c} = Blank-255; %Sets all blank blocks outside the vision radius of the player to black
        end
    end
end
playerx = EL(1, X_COL);
playery = EL(1, Y_COL);
for x = 1:10
    for y = 1:10
        if 0 && (x > playerx + 1 || x < playerx - 1 || y > playery + 1 || y < playery -1)
            World{x,y} = Blank-255;
        else
            matchingEntries = EL(:,X_COL) == x & EL(:,Y_COL) == y;
            if sum(matchingEntries) == 0
                World{x,y} = Blank;
            else
                entityInCell = find(matchingEntries == 1);
                etype = EL(entityInCell,TYPE);
                World{x,y} = IMG{etype};
            end
        end
    end
end
imshow([World{1,:};World{2,:};World{3,:};World{4,:};World{5,:};World{6,:};World{7,:};World{8,:};World{9,:};World{10,:}]); %displays updated board with Player entity displayed in assigned location
    

for r = 1:1:size(EL)
    for row = 2:1:size(EL)
        if EL(PLAYERT,X_COL) == EL(row,X_COL) && EL(PLAYERT,Y_COL) == EL(row,Y_COL)
            %Insert Combat Block Here
            if EL(row,TYPE) == 5
                if SOUND == 1
                    play(Health)
                end
                PreviousHealth = EL(PLAYERT, HEALTH_COL);
                EL(PLAYERT, HEALTH_COL) = EL(PLAYERT, HEALTH_COL) + EL(row,HEALTH_COL); %Checks pickup type for Health, adds the random health value to the player health column (keeps it less than 20)
                if EL(PLAYERT, HEALTH_COL) > 20
                    EL(PLAYERT, HEALTH_COL) = 20;
                end
                fprintf('Health Vat added %i health!',EL(PLAYERT,HEALTH_COL) - PreviousHealth)
            elseif EL(row,TYPE) == 6
                PreviousAttack = EL(PLAYERT,ATTACK_BOOST_COL);
                if SOUND == 1
                    play(Sword)
                end
                EL(PLAYERT, ATTACK_BOOST_COL) = EL(PLAYERT, ATTACK_BOOST_COL) + EL(row,ATTACK_BOOST_COL); %Checks pickup type for sword, adds the random value to the player attack boost column, which is then added to the attack (keeps it less than 20)
                EL(PLAYERT, ATTACK_COL) = EL(PLAYERT, ATTACK_COL) + EL(PLAYERT,ATTACK_BOOST_COL);
                fprintf('Sword added %i attack!',EL(PLAYERT,ATTACK_BOOST_COL) - PreviousAttack)
            elseif EL(row,TYPE) == 7
                PreviousDefense = EL(PLAYERT, DEFENSE_BOOST_COL);
                if SOUND == 1
                    play(Shield)
                end
                EL(PLAYERT, DEFENSE_BOOST_COL) = EL(PLAYERT, DEFENSE_BOOST_COL) + EL(row,DEFENSE_BOOST_COL); %Checks pickup type for shield, adds the random value to the player defense boost column, which is then added to the player defense (keeps it less than 20)
                EL(PLAYERT, DEFENSE_COL) = EL(PLAYERT, DEFENSE_COL) + EL(PLAYERT,DEFENSE_BOOST_COL);
                fprintf('Shield added %i defense!',EL(PLAYERT,DEFENSE_BOOST_COL) - PreviousDefense)
            elseif EL(row,TYPE) == 8
                PreviousSpeed = EL(PLAYERT, SPEED_BOOST_COL);
                EL(PLAYERT, SPEED_BOOST_COL) = EL(PLAYERT, SPEED_BOOST_COL) + EL(row,SPEED_BOOST_COL); %Checks pickup type for boots, adds the random value to the player speed boost column column, which is then added to the player speed column (keeps it less than 20)
                EL(PLAYERT, SPEED_COL) = EL(PLAYERT, SPEED_COL) + EL(PLAYERT,SPEED_BOOST_COL);
                fprintf('Boots added %i speed!',EL(PLAYERT,SPEED_BOOST_COL) - PreviousSpeed)
            end
            World{EL(row,X_COL), EL(row,Y_COL)} = Blank;
            World{EL(row,X_COL), EL(row,Y_COL)} = IMG{PLAYERT};
            EL(row, X_COL) = 11;
            EL(row,Y_COL) = 11;
        end
    end
end
% Movement
player = EL(1,:);
MOBVIEWDISTANCE = 4;
for i = 1:length(EL)
    entity = EL(i,:);
   if entity(TYPE) == PLAYERT
       %Player movement
       VALID = 0;
       dx = 0;
       dy = 0;
       while VALID == 0
           h = figure(1);
           waitforbuttonpress;
           k = get(h,'CurrentKey');
           switch (k)
               case 'downarrow'
                   dx = 1;
                   VALID = 1;
               case 'uparrow'
                   dx = -1;
                   VALID = 1;
               case 'leftarrow'
                   dy = -1;
                   VALID = 1;
               case 'rightarrow'
                   dy = 1;
                   VALID = 1;
           end
           if VALID == 1
               px = dx + player(X_COL);
               py = dx + player(Y_COL);
               if px > 10 || px < 1 || py > 10 || py < 1
                   VALID = 0;
               end
           end
       end
       EL(i,X_COL) = EL(i,X_COL) + dx;
       EL(i,Y_COL) = EL(i,Y_COL) + dy;
   elseif entity(TYPE) == MONSTERT
       %Lets see if a player is around
       ex = entity(X_COL);
       ey = entity(Y_COL);
       px = player(X_COL);
       py = player(Y_COL);
       
       availableLocations = [1 0 0; 0 1 0; -1 0 0; 0 -1 0; 0 0 Inf]; % x y weight
       %lower is better
       %we want to avoid going nowhere unless we have nowhere to go or we
       %agro to right there
       
       if 1 || ((ex - px)^2 + (ey - py)^2 < 16)
           % need to use distance to weight
           for j = 1:5
               availableLocations(j,3) = ((ex+availableLocations (j,1))-px) ^ 2 + ((ey + availableLocations(j,2))-px)^2;
           end
       end
       appropriateLocations = zeros([5 3]);
       max = 0;
       for j = 1:5
           newx = availableLocations(j,1) + ex;
           newy = availableLocations(j,2) + ey;
           if newx > 10 || newx < 1 || newy > 10 || newy < 1
               continue;
           end
           collisions = (EL(X_COL)==newx & EL(Y_COL) == newy & (EL(TYPE) == MONSTERT || EL(TYPE) == DOORT || EL(TYPE) == SUPERMONSTERT));
           collisions(i) = 0; %don't care if colides with self
           if sum(collisions) == 0 %no collisions with monsters, doors, or supermosters
               max = max + 1;
               appropriateLocations(max,:) = availableLocations(j,:);
           end
       end
       if ~isempty(appropriateLocations)

           weights = appropriateLocations(1:max,3);
           bestWeight = min(weights);
           bestWeightPositions = find(appropriateLocations(:,3) == bestWeight);
           bestLocations = appropriateLocations(bestWeightPositions, :);

           entries = length(bestWeightPositions);
       else
           entries = 0;
       end
       movementChoice = [0 0];
       if entries == 0
           continue;
       elseif entries == 1
           movementChoice = bestLocations(1,[1 2]); %extract xy
       else
           movementChoice = bestLocations(randi(entries),[1 2]); %extract random entry from appropriateLocations xy
       end
       EL(i,X_COL) = ex + movementChoice(1);
       EL(i,Y_COL) = ey + movementChoice(2);
   end
end
end
if SOUND == 1
    stop(Theme) % Stops the song
end
% Combat Start

% Combat End

% End Play