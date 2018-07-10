# PsychToolBox-Demo

sca; clear; clc;
%% Trial setting
trial = {};  
for i=1:2 
    for j=1:3 
        for k=1:3 
            trial = [trial {[i j k]}]; 
        end 
    end 
end 
t_trial_randperm = randperm(18); 
trial_random = trial(t_trial_randperm); % Design Matrix를 섞는 과정
%% Define Colour
res = 1*[700, 700]; 
screenid = max(Screen('Screens')); %화면에 띄울 스크린 선택
rect=[0,0,800,800];  % 출력 싸이즈 결정  
white = WhiteIndex(screenid); 
grey = white / 2; 
black = BlackIndex(screenid); 
%% Open the Window
[win, windowRect] = PsychImaging('OpenWindow', screenid, grey, rect , 32, 2); 
tw = res(1); 
th = res(2); 
[w, h]=Screen('WindowSize', win, [0]); 
%% Garbor Parameters
nonsymmetric = 0; 
phase = 0; 
sc = 120.0; 
contrast = 100.0; 
aspectratio = 3.0; 
%Gabor_number = 2;       
%degm = 0;               
%freq = 0.0075;            
gabortex = CreateProceduralGabor(win, tw, th, nonsymmetric, [0.5 0.5 0.5 0.0]);  
%Screen('Flip', win); 
%% Key Setting
KbName('UnifyKeyNames'); 
nextkey = KbName('RightArrow');
spacekey = KbName('Space');

%% Garbor Position
coordinate = []; 
for k = 1:5 
    for l = 1:5 
        coordinate = [coordinate ; [k l]]; 
    end 
end 
coordinate_1 = coordinate(1:12,:); 
coordinate_2 = coordinate(14:25,:); 
coordinate = [coordinate_1; coordinate_2]; 
%% Total Trial Information
totaltrial = 5; 
responsec = 0; responsew = 0; 
%% Main      
for i=1:totaltrial        
       %% Fixation Point and 5x5 Matrix
        for k=0:5 
            Screen('DrawLine', win, [1 1 1 1], ((w-h)/2)+(k*h/5), 0, ((w-h)/2)+(k*h/5), h, 5); 
            Screen('DrawLine', win, [1 1 1 1], (w-h)/2, k*h/5, (w+h)/2, k*h/5, 5); 
        end 
        Screen('DrawLine', win, [0 0 0 1], ((w-h)/2)+(2.4*h/5), (2.5*h/5), ((w-h)/2)+(2.6*h/5), (2.5*h/5), 5); %Setting Fixation Point
        Screen('DrawLine', win, [0 0 0 1], ((w-h)/2)+(2.5*h/5), (2.4*h/5), ((w-h)/2)+(2.5*h/5), (2.6*h/5), 5); %Setting Fixation Point
        Screen('Flip', win); 
        WaitSecs(0.5); 
       %% Setting Option
        if trial_random{i}(1) == 1 
            degm = 0; 
            degR = 90 + degm; 
        else
            degm = 90; 
            degR = 90 + degm; 
        end 
             
        if trial_random{i}(2) == 1 
            Gabor_number = 2; 
        elseif trial_random{i}(2) == 2 
            Gabor_number = 4; 
        else
            Gabor_number = 6; 
        end 
             
        if trial_random{i}(3) == 1 
            freq = 0.005; 
        elseif trial_random{i}(3) == 2 
            freq = 0.010; 
        else 
            freq = 0.0075; 
        end 
                         
       %% Setting Garbor 
        random_coordinate=randperm(24); 
        order=1; 
        % Garbor Type Setting 
        for ga=1:Gabor_number          
            freq_matrix = [0.005 0.010 0.0075]; 
            deg = randi(15)*10+105+degm; 
            while deg == 0 || deg == 90 
                deg = randi(15)*10+105+degm; 
            end 
            gabor_location=random_coordinate(order); 
            order=order+1; 
            gabor_coor=coordinate(gabor_location, :); 
            g=gabor_coor(1,1); 
            t=gabor_coor(1,2); 
            Screen('DrawTexture', win, gabortex, [0 0 700 700], [(t-1)*h/5+(w-h)/2 (g-1)*h/5 t*h/5+(w-h)/2 g*h/5], deg, [], [], [], [], kPsychDontDoRotation, [phase+180, freq_matrix(randi(3,1)), sc, contrast, aspectratio, 0, 0, 0]); 
        end  
        % Target gabor 
        gabor_location=random_coordinate(order);  
        gabor_coor=coordinate(gabor_location, :); 
        g=gabor_coor(1,1); 
        t=gabor_coor(1,2); 
        Screen('DrawTexture', win, gabortex, [0 0 700 700], [(t-1)*h/5+(w-h)/2 (g-1)*h/5 t*h/5+(w-h)/2 g*h/5], degR, [], [], [], [], kPsychDontDoRotation, [phase+180, freq, sc, contrast, aspectratio, 0, 0, 0]);
       %% 5X5 Matrix 
        for k=0:5 
        Screen('DrawLine', win, [1 1 1 1], ((w-h)/2)+(k*h/5), 0, ((w-h)/2)+(k*h/5), h, [5]); 
        Screen('DrawLine', win, [1 1 1 1], (w-h)/2, k*h/5, (w+h)/2, k*h/5, [5]); 
        end          
        % Fixation Point Again         
        Screen('DrawLine', win, [0 0 0 1], ((w-h)/2)+(2.4*h/5), (2.5*h/5), ((w-h)/2)+(2.6*h/5), (2.5*h/5), [5]); 
        Screen('DrawLine', win, [0 0 0 1], ((w-h)/2)+(2.5*h/5), (2.4*h/5), ((w-h)/2)+(2.5*h/5), (2.6*h/5), [5]);          
       %% Key Step Ordor        
        kGO = 1;
        while kGO==1 
            [keyIsDown, secs, keyCode] = KbCheck; 
            if keyIsDown == 1
                if keyCode(nextkey) == 1
                    % elseif keyCode(spacekey) == 1;
                    % [keyIsDown, secs, keyCode] = KbCheck;
                    % if keyCode(spacekey)==1;
                        Screen('Flip', win);
                        kGO = 0;
                end 
            end
        end
        WaitSecs(2);
end 
Screen('Flip', win); 
KbStrokeWait; 
sca;
