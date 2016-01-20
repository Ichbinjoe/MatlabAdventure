close all;
clear all;

for i = 0 : 0.1 :  5;

aXmin = i; 
aYmin = 3.5 *sin(i);
aXmax = aXmin + 1;
aYmax = aYmin*sin(i) + 2;

set(rectangle, 'Position', [aXmin, aYmin, 1, 1]);

bXmin = 3;
bYmin = 3;
bXmax = 3.4;
bYmax = 7;

set(rectangle, 'Position', [bXmin, bYmin, 0.4, 4]);

if ((aXmin < bXmax && aXmax > bXmin) && (aYmin < bYmax && aYmax > bYmin))

display('error')
else 
display('OK')
end
pause(0.1);
end