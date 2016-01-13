# MatlabAdventure

Basic adventure game with premade graphics in Matlab


## Principle

The board is a 10x10 grid. Player will have 1 square radius circle vision centered on the player, with objects outside of viewable zone not viewable by the player.

The board is populated by one player, with one door, with multiple boots (speed boosts), Sword (attack), Shields (defense), Health (health), and Monsters.

## Power ups

### Boots

Stepping on boots will result increase the speed to 2 blocks per move. If the user steps over the door, the user will be counted as going through the door.

### Health

The user will gain a set amount of health back (10?) Overhealing is possible, as there is no real maximum health.

### Sword

The sword will increase the attack by a set amount (10?). This will be used when attacking monsters.

### Shield

The shield will increase defense by a set amount (10?). This will be used when taking damage from monsters.


## Monster Mechanics

### Movement

Monster will always move one square directly next to its current position (up, down, left, right) and will never occupy a space taken up by another monster, or the door. In the event a player or monster collide, a fight will commence, doing shit. If a monster interacts with a power up, the power up is applied to the monster, and disappears.







## Datastructure

The entities in the game will be stored in a matlab vector. Within each element, another vector will store bullshit that we are doing.

Entity Types: 
+ 1 - Player
+ 2 - Monster
+ 3 - SuperMonster
+ 4 - Door
+ 5 - Health
+ 6 - Sword
+ 7 - Shields
+ 8 - Boots

Basic Entity Entry Format: 

| Type | x | y | Attack | Attack Boost | Defense | Defense Boost | Health | Speed | Speed Boost |