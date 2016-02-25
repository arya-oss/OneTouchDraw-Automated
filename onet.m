clear;
system('adb shell screencap -p /sdcard/one.png');
system('adb pull /sdcard/one.png');
im = imread('one.png');
im = imcrop(im, [0 100 720 920]);
red = im(:,:,1);
green = im(:,:,2);
blue = im(:,:,3);
BW = red >= 186 & red <= 200 & green >= 186 & green <= 200 & blue >= 186 & blue <= 200;
[centres,radii] = imfindcircles(im,[18 23], 'ObjectPolarity', 'bright', 'Sensitivity', 0.97);

g = zeros(length(centres));
%BW1 = edge(BW, 'prewitt');
%BW2 = edge(BW, 'canny');
[H,T,R] = hough(BW);
P = houghpeaks(H,35,'threshold',ceil(0.1*max(H(:))));
lines = houghlines(BW,T,R,P);
%figure, imshow(BW), hold on

for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   % plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   % Plot beginnings and ends of lines
   % plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   % plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
   i = getIndex(xy(1,1),xy(1,2),centres, 21);
   j = getIndex(xy(2,1),xy(2,2),centres, 21);
   if i ~= 0 && j ~= 0 && i ~= j
        g(i,j) = 1;
        g(j,i) = 1;
   end
end
for i = 1:length(centres)
    centres(i,1) = int16(centres(i,1));
    centres(i,2)= int16(centres(i,2)+100);
end
%disp(g);
str='';
for i=1:numel(g)
    str = strcat(str, num2str(g(i)));
end
disp(str);
[st, out] = system(['python euler.py ' str]);
if strcmp(out, 'error')
    disp('Error !!');
else
disp(out);

out = strsplit(out);
j = str2num(cell2mat(out(1)))+1;
system(['adb shell input tap ' num2str(centres(j,1)) ' ' num2str(centres(j,2))]);
for i=1:length(out)-2
    j = str2num(cell2mat(out(i)))+1;
    k = str2num(cell2mat(out(i+1)))+1;
    system(['adb shell input swipe ' num2str(centres(j,1)) ' ' num2str(centres(j,2)) ' ' num2str(centres(k,1)) ' ' num2str(centres(k,2)) ' 500']);
end
end