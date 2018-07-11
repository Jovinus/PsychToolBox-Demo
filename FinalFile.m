sca; clear; clc;
SessionN = input('Typing Session Number: ');
GridOnOff = input('Grid On = 1, Grid Off =0 : ');
t_a = 'Test';
t_b = int2str(SessionN);
t_c = '.txt';
t_name = [t_a,t_b,t_c];
fid = fopen(t_name,'w+'); 
%% Trial setting
trial = {};  
for i=1:2 % Degree(Orientation Setting)
    for j=1:3 % Garbor 개수 설정
        for k=1:3 % Spacial Frequency 설정
            trial = [trial {[i j k]}]; 
        end 
    end 
end 
t_trial_randperm = randperm(36); 
trial = [trial trial];
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
%KbName('UnifyKeyNames'); 
horizontal = KbName('z');
vertical = KbName('/?');


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
totaltrial = 36; 
responseC = 0; responseW = 0; 
response = zeros(1,totaltrial);
%% Main
fprintf(fid,'%6s %6s %6s %6s %6s %6s\n ', 'trial', 'Spatial Freq','GarborNumber','Response Time','Answer','Response');
if GridOnOff ==1
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
       %% Setting Option Distractor Gabor
        if trial_random{i}(1) == 1 
            degm = 0; 
            degR = 90 + degm; % 1번 설정
        else
            degm = 90; 
            degR = 90 + degm ;
        end 
             
        if trial_random{i}(2) == 1 
            Gabor_number = 2; 
        elseif trial_random{i}(2) == 2 
            Gabor_number = 6; 
        else
            Gabor_number = 8; 
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
        % DIstractor Garbor Setting
        for ga=1:Gabor_number          
            freq_matrix = [0.005 0.010 0.0075]; %Distractor에 설정되어있는 Spatial Fequency 종류
            deg = randi(15)*10+105+degm; 
            while deg == 0 || deg == 90 
                deg = randi(15)*10+105+degm; 
            end 
            gabor_location=random_coordinate(order); 
            order=order+1; 
            gabor_coor=coordinate(gabor_location, :); %최종 가버 위치
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
        %response = zeros(1,totaltrial); 
        timeover = 1; 
        Screen('Flip',win);
        StartSess = GetSecs; 
        t_time=0;
        tn = 0;
        while kGO==1 
            [keyIsDown, secs, keyCode] = KbCheck; 
            if keyIsDown == 1
                if tn == 0
                    if keyCode(horizontal) == 1
                        if degR == 90
                            StopSess = GetSecs;
                            response(i)=1;
                        elseif degR == 180
                            StopSess = GetSecs;
                            response(i)=0;
                        end
                        tn = tn +1;
                    elseif keyCode(vertical) == 1
                        if degR == 90
                            StopSess = GetSecs;
                            response(i)=0;
                        elseif degR == 180
                            StopSess = GetSecs;
                            response(i)=1;
                        end
                        tn = tn + 1;
                    end 
                end
            else
                t_time=GetSecs - StartSess;
            end
            if floor(t_time) == 3
                kGO=0;
                if tn == 0
                    StopSess = GetSecs;
                    response(i) = 0;
                end
            end
        end
        Screen('DrawLine', win, [0 0 0 1], ((w-h)/2)+(2.4*h/5), (2.5*h/5), ((w-h)/2)+(2.6*h/5), (2.5*h/5), [5]); 
        Screen('DrawLine', win, [0 0 0 1], ((w-h)/2)+(2.5*h/5), (2.4*h/5), ((w-h)/2)+(2.5*h/5), (2.6*h/5), [5]);        
        Screen('Flip',win);
        responsetime(i) = StopSess  - StartSess; 
        %% Writing Spec
        t_r=[i,freq,Gabor_number,responsetime(i),degR,response(i)];
        fprintf(fid,'%d %3f %d %3f %d %d\n',t_r);
        if response(i) == 1            
            responseC = responseC + 1;
        elseif response(i) == 0
            responseW = responseW + 1;
        end
        WaitSecs(0.5);
end
end
if GridOnOff ==0
for i=1:totaltrial        
       %% Fixation Point and 5x5 Matrix
        Screen('DrawLine', win, [0 0 0 1], ((w-h)/2)+(2.4*h/5), (2.5*h/5), ((w-h)/2)+(2.6*h/5), (2.5*h/5), 5); %Setting Fixation Point
        Screen('DrawLine', win, [0 0 0 1], ((w-h)/2)+(2.5*h/5), (2.4*h/5), ((w-h)/2)+(2.5*h/5), (2.6*h/5), 5); %Setting Fixation Point
        Screen('Flip', win); 
        WaitSecs(0.5); 
       %% Setting Option Distractor Gabor
        if trial_random{i}(1) == 1 
            degm = 0; 
            degR = 90 + degm; % 1번 설정
        else
            degm = 90; 
            degR = 90 + degm ;
        end 
             
        if trial_random{i}(2) == 1 
            Gabor_number = 2; 
        elseif trial_random{i}(2) == 2 
            Gabor_number = 6; 
        else
            Gabor_number = 8; 
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
        % DIstractor Garbor Setting
        for ga=1:Gabor_number          
            freq_matrix = [0.005 0.010 0.0075]; %Distractor에 설정되어있는 Spatial Fequency 종류
            deg = randi(15)*10+105+degm; 
            while deg == 0 || deg == 90 
                deg = randi(15)*10+105+degm; /
            end 
            gabor_location=random_coordinate(order); 
            order=order+1; 
            gabor_coor=coordinate(gabor_location, :); %최종 가버 위치
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
        % Fixation Point Again         
        Screen('DrawLine', win, [0 0 0 1], ((w-h)/2)+(2.4*h/5), (2.5*h/5), ((w-h)/2)+(2.6*h/5), (2.5*h/5), [5]); 
        Screen('DrawLine', win, [0 0 0 1], ((w-h)/2)+(2.5*h/5), (2.4*h/5), ((w-h)/2)+(2.5*h/5), (2.6*h/5), [5]);          
       %% Key Step Ordor        
        kGO = 1;
        %response = zeros(1,totaltrial); 
        timeover = 1; 
        Screen('Flip',win);
        StartSess = GetSecs; 
        tn=0;
        while kGO==1 
            [keyIsDown, secs, keyCode] = KbCheck; 
            if keyIsDown == 1
                if tn == 0
                    if keyCode(horizontal) == 1
                        if degR == 90
                            response(i)=1;
                            StopSess = GetSecs;
                        elseif degR == 180
                            response(i)=0;
                            StopSess = GetSecs;
                        end
                        tn = tn + 1;
                    elseif keyCode(vertical) == 1
                        if degR == 90
                            response(i)=0;
                            StopSess = GetSecs;
                        elseif degR == 180
                            response(i)=1;
                            StopSess = GetSecs;
                        end
                    tn = tn + 1;
                    end 
                end
            end
            t_time=GetSecs - StartSess;           
            if floor(t_time) == 3
                kGO=0;
                if tn == 0
                    StopSess = GetSecs;
                    response(i)=-1;
                end
            end
        end
        Screen('DrawLine', win, [0 0 0 1], ((w-h)/2)+(2.4*h/5), (2.5*h/5), ((w-h)/2)+(2.6*h/5), (2.5*h/5), 5); %Setting Fixation Point
        Screen('DrawLine', win, [0 0 0 1], ((w-h)/2)+(2.5*h/5), (2.4*h/5), ((w-h)/2)+(2.5*h/5), (2.6*h/5), 5); %Setting Fixation Point
        Screen('Flip',win);
        responsetime(i) = StopSess  - StartSess; 
        %% Writing Spec

        t_r=[i,freq,Gabor_number,responsetime(i),degR,response(i)];
        fprintf(fid,'%d %3f %d %3f %d %d \n',t_r);
        if response(i) == 1
            
            responseC = responseC + 1;
        elseif response(i) == 0
           
            responseW = responseW + 1;
        end
        WaitSecs(0.5);
end
end

%% End - Result
accuracy = responseC*100/(responseC + responseW);
responsetime_mean=mean(responsetime);
fprintf(fid,'Total accuracy is %f percent\n',accuracy); 
fprintf(fid,'Mean of response time is %f\n',responsetime_mean); 
fclose(fid); 
Screen('Flip', win); 
KbStrokeWait; 
sca;