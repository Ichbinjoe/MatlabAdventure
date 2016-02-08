GameMaster = 1;
while GameMaster == 1;
close all;
clear all;
load Adventure   % Loads the board (World - 10x10 cell array) along with a number of different image, shown below.
warning('off','all'); % turns off all warning messages
% Definitions
msgbox('Warning: It has been found that the some audio files are not properly read on certain operating systems, and this may cause errors. This is not an error due to this script, but rather due to incompatability of the audio file format with the users chosen operating system. If choosing to play with audio yields errors, restart the game and choose no audio. Thanks for playing!')
SOUND = menu('Would you like audio?','Yes','No');

% Type definitions
PLAYERT = 1;
DOORT = 2;
SUPERMONSTERT = 3;
MONSTERT = 4;
HEALTHBOOSTT = 5;
SWORDT = 6;
SHIELDT = 7;
BOOTT = 8;

IMG = {Player, Door, Smiley, Monster, Health, Sword, Shield, Boots};
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
EL(3,:) = [3 EL(2,X_COL)-1 EL(2,Y_COL)-1 13 0 12 0 20 17 0]; %Randomly spawns monster location within a 3 coordinate radius of the door. Also indexes into the players health, speed and defense stats to create a metroid-esque evil player (see Ryan for more details) 
for r = 4:1:33
    for c = 1:1:10
        rng('shuffle'); %randomly seeds entity generation based on current time
        if c == 1
            EL(r,c) = randi([4 8]); %Assigns random entity values
            if EL(r,c) == MONSTERT
                EL(r,MONSTERT) = randi([5 10]);
                EL(r,8) = randi([5 10]);
                EL(r,DEFENSE_COL) = randi([5 10]);
                EL(r,SPEED_COL) = randi([5 10]);
            elseif EL(r,c) == HEALTHBOOSTT
                EL(r,8) = randi([1 5]);
            elseif EL(r,c) == SWORDT
                EL(r,ATTACK_BOOST_COL) = randi([1 5]);
            elseif EL(r,c) == SHIELDT
                EL(r,DEFENSE_BOOST_COL) = randi([1 5]);
            elseif EL(r,c) == BOOTT
                EL(r,SPEED_BOOST_COL) = randi([1 5]);
            end
        elseif c == 2
            EL(r,c) = randi([2 10]);
        elseif c == 3
            EL(r,c) = randi([1 10]);
        end
        
    end
end
if SOUND == 1
    [y Fs] = audioread('Theme.mp3'); % Reads file � must be in current directory
    Theme = audioplayer(.3*y,Fs);  
    % Saves as song using sampling rate, Fs
    [y Fs] = audioread('Sword.mp3');
    Sword1 = audioplayer(.1*y,Fs);
    [y Fs] = audioread('Shield.wav');
    Shield1 = audioplayer(.1*y,Fs);
    [y Fs] = audioread('Health.wav');
    Health1 = audioplayer(.2*y,Fs);
    [y Fs] = audioread('Speed.wav');
    Speed1 = audioplayer(.1*y,Fs);
    [y Fs] = audioread('Boss.mp3');
    Boss = audioplayer(.5*y,Fs);
    [y Fs] = audioread('Victory.wav');
    Victory = audioplayer(.1*y,Fs);
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
% Start Play
Health = 1;
Game = 1;
Encounter = 1;
endfight = -999;
if SOUND == 1
    play(Theme)   % Plays the song
end
while Game == 1 && Health == 1
   World{EL(2,X_COL), EL(2,Y_COL)} = Door;
   clc;
   disp 'Health: ';disp(EL(PLAYERT,HEALTH_COL));disp ' Attack: ';disp(EL(PLAYERT,ATTACK_COL));disp ' Defense: ';disp(EL(PLAYERT,DEFENSE_COL));disp ' Speed: ';disp(EL(PLAYERT,SPEED_COL));
   if EL(PLAYERT,HEALTH_COL) <= 0
       Health = 0;
   elseif (EL(PLAYERT,X_COL) == EL(DOORT,X_COL)) && (EL(PLAYERT,Y_COL) == EL(DOORT,Y_COL)) && EL(3,HEALTH_COL) <= 0
       Game = 0;
   end
   World{EL(1,X_COL),EL(1,Y_COL)} = Player; %indexes into World location for player based on x y coordinates given in the Entity List. Assigns Cell values to the values in the Player image (Test)
playerx = EL(1, X_COL);
playery = EL(1, Y_COL);
for x = 1:10
    for y = 1:10
        if (x > playerx + 1 || x < playerx - 1 || y > playery + 1 || y < playery -1)
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
        if (EL(PLAYERT,X_COL) == EL(row,X_COL) && EL(PLAYERT,Y_COL) == EL(row,Y_COL)) && EL(row,TYPE) ~= 2
            %Insert Combat Block Here
            while (EL(row,TYPE) == MONSTERT || EL(row,TYPE) == SUPERMONSTERT)
                j = cputime;
                if j-endfight < 3
                    break;
                end
                if EL(row,HEALTH_COL) <= 0
                    EL(row,HEALTH_COL) = 0;
                    EL(row, X_COL) = 11;
                    EL(row,Y_COL) = 11;
                    fprintf('Monster Health: %i. Monster defeated!!',EL(row,HEALTH_COL));
                    endfight = cputime;
                    break;
                elseif EL(PLAYERT,HEALTH_COL) <= 0
                    Health = 0;
                    break;
                end
                if EL(row,TYPE) == SUPERMONSTERT && Encounter == 1;
                   if SOUND == 1
                    stop(Theme)
                    play(Boss)
                   end
                   fprintf('You stumble upon a shady looking creature. Unlike all the other monsters, this one mimicks your every move, darting his eyes back and forth as he analyzes his alternate. Prepare for a fight.\n');
                   Encounter = 0;
                end
                choice = menu('You have stumbled upon a monster! What do you do?','Attack','Defend','Run');
                clc;
                chance = randi([1 10]);
                if choice == 1 && chance > 4 %60 percent chance of dealing a good hit
                    damagedealt = floor((EL(PLAYERT,ATTACK_COL)/randi([1 10])));
                    EL(row,HEALTH_COL) = EL(row,HEALTH_COL) - damagedealt;
                    fprintf('You landed a great hit against the monster and did %0.2f damage!\n Monster health: %0.2f\n',damagedealt,EL(row,HEALTH_COL));
                elseif choice == 1 && chance < 4 %20 percent chance of a glancing shot
                    damagedealt = floor((EL(PLAYERT,ATTACK_COL)/chance));
                    EL(row,HEALTH_COL) = EL(row,HEALTH_COL) - damagedealt;
                    fprintf('You stumbled as you swung and did %0.2f damage! \nMonster health: %0.2f\n',damagedealt,EL(row,HEALTH_COL));
                elseif choice == 1 && chance < 2 %20 percent chance of missing entirely
                    damagedealt = 0;
                    fprintf('What an amatuer! You missed and did %0.2f damage! \nMonster health: %0.2f\n',damagedealt,EL(row,HEALTH_COL));
                elseif choice == 2 && chance > 4
                    damagetaken = floor((EL(PLAYERT,DEFENSE_COL)/randi([1 10])));
                    EL(row,DEFENSE_COL) = EL(row,DEFENSE_COL) - damagetaken;
                    fprintf('You planted your shield firmly and protected yourself against a brutal blow! \nYour shield lost %0.2f durability\n',damagedealt,EL(row,DEFENSE_COL));
                    if EL(row,DEFENSE_COL) < 0
                        EL(row, DEFENSE_COL) = 0;
                    end
                elseif choice == 2 && chance < 4
                    damagetaken = floor((EL(PLAYERT,DEFENSE_COL)/chance));
                    EL(row,DEFENSE_COL) = EL(row,DEFENSE_COL) - damagetaken;
                    fprintf('You raise your shield but just barely block the blow. You get the wind knocked out of you and you lose %0.2f Defense.\n',damagetaken);
               elseif choice == 2 && chance < 2
                    damagetaken = floor(EL(PLAYERT,DEFENSE_COL)/chance);
                    EL(row,DEFENSE_COL) = EL(row,DEFENSE_COL) - damagetaken;
                    EL(row,HEALTH_COL) = EL(row,HEALTH_COL)- .75*damagetaken;
                    fprintf('You planted your shield but failed to cover your left shoulder. Your left shoulder is now gone, as is your shield. \nDefense lost: %0.2f. Health lost: %0.2f\n',damagetaken,.5*damagetaken);
               elseif choice == 3 || EL(PLAYERT,SPEED_COL) > 0
                   EL(PLAYERT,SPEED_COL) = EL(PLAYERT,SPEED_COL) - 10;
                   EL(PLAYERT,X_COL) = EL(PLAYERT,X_COL)+1;
                   if EL(PLAYERT,SPEED_COL) < 0
                      EL(PLAYERT,SPEED_COL) = 0;
                      EL(PLAYERT,HEALTH_COL) = EL(PLAYERT,HEALTH_COL) - 2;
                   end
                   break;
                end
               monsterc = randi([0 10]);
               if monsterc > 4 && choice ~= 2 && choice ~= 3
                   damagedealt = (randi([1 10])/10)*EL(row,ATTACK_COL);
                   EL(PLAYERT,DEFENSE_COL) = EL(PLAYERT,DEFENSE_COL) - damagedealt;
                   if EL(PLAYERT,DEFENSE_COL) < 0
                   EL(PLAYERT,DEFENSE_COL) = 0;
                   EL(PLAYERT,HEALTH_COL) = EL(PLAYERT,HEALTH_COL) - damagedealt;
                   fprintf('The monster grabs your battered shield and stabs over it. He decreases your health by %0.2f\n',damagedealt);
                   else
                   fprintf('Monster grabs your shield at your shield and removes %0.2f defense\n',damagedealt);
                   end
               elseif monsterc < 4 && choice ~= 2 && choice ~=3
                   damagedealt = (randi([1 10])/10)*EL(row,ATTACK_COL);
                   EL(PLAYERT,HEALTH_COL) = EL(PLAYERT,HEALTH_COL) - damagedealt;
                   fprintf('He stabs at your face and deals %0.2f damage. Why do you heroes never wear helmets?\n',damagedealt);
               elseif monsterc < 2 && choice ~= 2 && choice ~= 3
                   damagedealt = (randi([1 6])/10)*EL(row,ATTACK_COL);
                   EL(PLAYERT,HEALTH_COL) = EL(PLAYERT,HEALTH_COL) - damagedealt;
                   fprintf('The monster decides to use a bow on you. You take an arrow to the knee and lose %0.2f health.\n',damagedealt);
               end
               monsterc = randi([0 100]);
               if monsterc < 5 && choice ~=2 && choice ~= 3
                   EL(row,HEALTH_COL) = 0;
                   fprintf('The monster is so awed by your sick moves he is ashamed of himself and commits sudoku. Congrats. Jerk.\n')
               end
               fprintf('Health: %0.2f \n',(EL(PLAYERT,HEALTH_COL)));fprintf('Attack: %0.2f \n',(EL(PLAYERT,ATTACK_COL)));fprintf('Defense: %0.2f \n',(EL(PLAYERT,DEFENSE_COL)));fprintf('Speed: %0.2f \n',(EL(PLAYERT,SPEED_COL)));
            end
            if EL(3,HEALTH_COL) <=0 && Encounter == 0
                Encounter = 1;
                stop(Boss)
                play(Victory)
                msgbox('You have defeated your alternate! Now quick, take a moment to celebrate and get to the door before it disappears!');
            end
            if EL(row,TYPE) == 5
                if SOUND == 1
                    play(Health1)
                end
                PreviousHealth = EL(PLAYERT, HEALTH_COL);
                EL(PLAYERT, HEALTH_COL) = EL(PLAYERT, HEALTH_COL) + EL(row,HEALTH_COL); %Checks pickup type for Health, adds the random health value to the player health column (keeps it less than 20)
                fprintf('Health Vat added %0.2f health!\n',EL(PLAYERT,HEALTH_COL) - PreviousHealth)
                if EL(PLAYERT, HEALTH_COL) > 20
                    EL(PLAYERT, HEALTH_COL) = 20;
                elseif EL(PLAYERT, HEALTH_COL) < 0
                    EL(PLAYERT, HEALTH_COL) = 0;
                end
                EL(row,HEALTH_COL) = 0;
            elseif EL(row,TYPE) == 6
                PreviousAttack = EL(PLAYERT,ATTACK_BOOST_COL);
                if SOUND == 1
                    play(Sword1)
                end
                EL(PLAYERT, ATTACK_BOOST_COL) = EL(PLAYERT, ATTACK_BOOST_COL) + EL(row,ATTACK_BOOST_COL); %Checks pickup type for sword, adds the random value to the player attack boost column, which is then added to the attack (keeps it less than 20)
                EL(PLAYERT, ATTACK_COL) = EL(PLAYERT, ATTACK_COL) + (EL(PLAYERT,ATTACK_BOOST_COL)-PreviousAttack);
                if EL(PLAYERT, ATTACK_COL) > 20
                    EL(PLAYERT, ATTACK_COL) = 20;
                elseif EL(PLAYERT, ATTACK_COL) < 0
                    EL(PLAYERT, ATTACK_COL) = 0;
                end
                fprintf('Sword added %0.2f attack!\n',EL(PLAYERT,ATTACK_BOOST_COL) - PreviousAttack)
            elseif EL(row,TYPE) == 7
                PreviousDefense = EL(PLAYERT, DEFENSE_BOOST_COL);
                if SOUND == 1
                    play(Shield1)
                end
                EL(PLAYERT, DEFENSE_BOOST_COL) = EL(PLAYERT, DEFENSE_BOOST_COL) + EL(row,DEFENSE_BOOST_COL); %Checks pickup type for shield, adds the random value to the player defense boost column, which is then added to the player defense (keeps it less than 20)
                EL(PLAYERT, DEFENSE_COL) = EL(PLAYERT, DEFENSE_COL) + (EL(PLAYERT,DEFENSE_BOOST_COL)-PreviousDefense);
                fprintf('Shield added %0.2f defense!\n',EL(PLAYERT,DEFENSE_BOOST_COL) - PreviousDefense)                
                if EL(PLAYERT, DEFENSE_COL) > 20
                    EL(PLAYERT, DEFENSE_COL) = 20;
                elseif EL(PLAYERT, DEFENSE_COL) < 1
                    EL(PLAYERT, DEFENSE_COL) = 0;
                end
            elseif EL(row,TYPE) == 8
                if SOUND == 1
                    play(Speed1)
                end
                PreviousSpeed = EL(PLAYERT, SPEED_COL);
                EL(PLAYERT, SPEED_COL) = EL(PLAYERT, SPEED_COL) + EL(row,SPEED_BOOST_COL); %Checks pickup type for boots, adds the random value to the player speed boost column column, which is then added to the player speed column (keeps it less than 20)
                fprintf('You picked up %0.2f speed boost to use in battle!\n',EL(PLAYERT,SPEED_COL) - PreviousSpeed)                
                if EL(PLAYERT, SPEED_COL) > 20
                    EL(PLAYERT, SPEED_COL) = 20;
                elseif EL(PLAYERT, SPEED_COL) < 0
                    EL(PLAYERT, SPEED_COL) = 0;
                end
            end
            World{EL(row,X_COL), EL(row,Y_COL)} = Blank;
            World{EL(row,X_COL), EL(row,Y_COL)} = IMG{PLAYERT};
            if EL(row,HEALTH_COL) <= 0
            EL(row, X_COL) = 11;
            EL(row,Y_COL) = 11;
            end
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
               py = dy + player(Y_COL);
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
       if max ~= 0

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
if Health == 0
  close all;
  GameMaster = menu('You have died a warriors death. Would you like to play again?','Yes','No');
else
  close all;
  GameMaster = menu('Congratulations! You won the game! Would you like to play again?','Yes','No');  
end
end
clear all;
clc;
% Combat Start

% Combat End

% End Play