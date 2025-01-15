clc;
clear;

KbName('UnifyKeyNames');

% User Input
subjectName = input('Please enter your name: ', 's');
subject_ID = input('Please enter the Subject ID: ', 's');
stepNumber = input('Please enter the step number (1 or 2): ');

% Set block parameters based on step number
if stepNumber == 1
    startsBlock = 0;
    blocksNumber = 4;
    
elseif stepNumber == 2
    startsBlock = 4;
    blocksNumber = 4;
end
    
% Define the blocks for the subject
subjectsBlocks = startsBlock : (startsBlock + blocksNumber - 1);

% Directory setup
base_path = fullfile('/Users/alimotahharynia/Desktop/sequentialParadigm/');
images_path = fullfile(base_path, 'images');
results_path = fullfile(base_path, 'Results Data');

% Colors and display parameters
gray = [127 127 127];
white = [255 255 255];
red = [255, 0, 0];
blue = [0, 0, 255];
green = [0, 255, 0];
bkColor = gray; % background
length = 80; % arrow length
arrowInterval = 10; % interval between arrows orientation in degree
fixationPoint = 4; % fixation point size
fbSize = 7; % feedback circle size
frameSize = 50;

% Psychtoolbox Iitialization
AssertOpenGL;
screens = Screen('Screens');
screenNumber = max(screens);
Screen('Preference', 'SkipSyncTests', 0);
[window, rect] = Screen('OpenWindow', screenNumber, bkColor);
[centerX, centerY] = RectCenter(rect);
HideCursor;

try
    rng('shuffle');
    for blockIdx = subjectsBlocks
        % Define parameters based on block type
        if blockIdx == 0 % training block (1-bar, block 100)
            blockIdx = 100
            numTrials = 15; % should be a multiple of 3
            arrowColorCount = 1;
            
        elseif blockIdx == 7 % 1-bar paradigm (block 7)
            numTrials = 30;
            arrowColorCount = 1;
            
        else
            numTrials = 30; % 3-bar paradigm (block 1-6)
            arrowColorCount = 3;
        end
                
        % setting the background color
        Screen('FillRect', window, bkColor);
        
        % preallocate data storage
        startDateTime = NaN(1,6, numTrials);
        endDateTime = NaN(1,6, numTrials);
        daylightSavingTime = NaN(numTrials, 1);
        reactionTime = NaN(numTrials, 1);
        reactionTimeFirstAndLastClick = NaN(numTrials, 1);
        barsColor = NaN(arrowColorCount, 3, numTrials);
        barsOrientation = NaN(1, arrowColorCount, numTrials);
        matchColor = NaN(1, 3, numTrials);
        matchOrientation = NaN(numTrials, 1);
        startPointDegree = NaN(numTrials, 1);
        responseOrientation = NaN(numTrials, 1);
        responseError = NaN(numTrials, 1);
        barAnswerOrder = NaN(numTrials, 1);
        
        % Fixation point coordinate
        circleCoordinates = [centerX-fixationPoint...
            centerY-fixationPoint, centerX+fixationPoint...
            centerY+fixationPoint];
        
        % Color distribution
            arrow1 = [ones(1, numTrials/3), repmat(2, 1, numTrials/3),...
                repmat(3, 1, numTrials/3)];
            arrow1Dist = randperm(numTrials);
        
        for traitsGenerator =  1:numTrials
            
            barColorGenerator = randperm(arrowColorCount); % color
            
            if arrowColorCount == 1
                colcol_1(traitsGenerator) = arrow1(arrow1Dist(traitsGenerator));
            else
                
            colcol{traitsGenerator} = barColorGenerator;
            end
            
            randomOrientation = randperm(180/arrowInterval); % Orientation in degree
            randomOrientation = randomOrientation(1, 1:arrowColorCount);
            barDegreeGenerator{traitsGenerator} = randomOrientation;
        end
        
        % Bar presentation
        cEqualDistribution = [];
        for rep = 1:arrowColorCount
            
            cEqualDistributionp = repmat(rep, 1, numTrials/arrowColorCount);
            cEqualDistribution = [cEqualDistribution, cEqualDistributionp];
        end
        
        % Equal distribution randomness
        eqDist = randperm(numTrials);
        
        % Start message
        cd(images_path)
        start1 = imread('start.png');
        startImg = Screen('MakeTexture', window, start1);
        Screen('DrawTexture', window, startImg, [], [centerX-centerX/2-150, centerY-400,...
            centerX+centerX/2+150, centerY+400], 0);
        Screen('Flip', window)
        
        % Wait for key press to start
        kb_wait = 0;
        while kb_wait ~= KbName('space')
            [wait_key_down, ~, wait_key_code] = KbCheck;

            if (wait_key_down)

               kb_wait = find(wait_key_code, 1);
            end
        end
        
        [s_d_t, dst] = clock; % date and time of the task
        
        % Press any key to continue
        cd(images_path)
        continue1 = imread('continue_1.png');
        continueTexture = Screen('MakeTexture', window, continue1);
        Screen('DrawTexture', window, continueTexture, [], [centerX-centerX/2-150, centerY-400,...
            centerX+centerX/2+150, centerY+400], 0);
        cd(base_path)
        Screen('Flip', window)
        
        kb_wait = 0;
        while kb_wait ~= KbName('space')
            [wait_key_down, ~, wait_key_code] = KbCheck;

            if (wait_key_down)
               kb_wait = find(wait_key_code, 1);
            end
        end
        Screen('Flip', window)
        WaitSecs(2);
        
        for trialCounter = 1:numTrials
            
            startDateTime(:,:,trialCounter) = s_d_t;
            daylightSavingTime(trialCounter) = dst;
            
            rng shuffle
            
            % Possible number of orientation
            startPoint = randi(179)*(pi/180); % Start point orientation
            
            orietationPermutation = linspace(startPoint, pi + startPoint,...
                (180/arrowInterval) + 1);
            orietationPermutation(end) = [];
            
            % Orientation of the presented bar
            responseOrientaionDegree = 90;
            c_or = (responseOrientaionDegree/180)*pi;
            
            % Bars color
            if blockIdx == 100 || blockIdx == 7
                randColor = colcol_1(trialCounter);
            else
                randColor = colcol{trialCounter};
            end
            
            % Bars orientation
            randOrientation = barDegreeGenerator{trialCounter};
            
            barOrientationColor = [];
            barOrientation_rad = [];
            
            matchOrientationColor = {red, blue, green};
            
            % Fixation point
            Screen ('FillOval',window, white, circleCoordinates);
            Screen('Flip', window)
            WaitSecs(1);
            
            % Orientation presentation
            for c_number = 1:arrowColorCount
                
                % Select bar orientation
                arrowOrientation = orietationPermutation(randOrientation(c_number));
                
                % Presented bar orientation
                barOrientation_rad = [barOrientation_rad; arrowOrientation];
                
                % Select bar color
                oColor = matchOrientationColor{randColor(c_number)};
                
                % Presented bar orientation
                barOrientationColor = [barOrientationColor; oColor];
                
                Screen('DrawLine', window, oColor, centerX + (length/2)*cos(arrowOrientation), centerY - (length/2)*sin(arrowOrientation),...
                    centerX - (length/2)*cos(arrowOrientation), centerY + (length/2)*sin(arrowOrientation), 6);
                Screen('Flip', window)
                WaitSecs(0.5);
                
                Screen('Flip', window)
                
                % Delay time between bars presentation
                WaitSecs(0.5);
            end
            
            % Convert orientation data to degree
            barOrientationDegree = (barOrientation_rad/pi)*180;
            
            % Fixation point
            Screen ('FillOval',window, white, circleCoordinates);
            Screen('Flip', window)
            WaitSecs(1);
            
            % Match orientation
            which = cEqualDistribution(eqDist(trialCounter));
            
            % Match color
            mColor = barOrientationColor(which,:);
            
            frameCoordinate = [centerX-frameSize...
                centerY - frameSize, centerX + frameSize, centerY + frameSize];
            
            Screen ('FrameOval',window, white, frameCoordinate, 3, 3);
            Screen('DrawLine', window, mColor, centerX + (length/2)*cos(c_or), centerY - (length/2)*sin(c_or),...
                centerX - (length/2)*cos(c_or), centerY + (length/2)*sin(c_or), 6);
            
            matchOrientationDegree = barOrientationDegree(which);
            
            SetMouse(centerX, centerY) % locate mouse on center
            ShowCursor('Hand', window)
            Screen('Flip', window)
            
            db = [];
            leftClickGs = [];
            leftClickKbC = [];
            leftClickKb = [];
            rightClickT = [];
            indices = [];
            
            initialTime = GetSecs; % Start time of trial
            
            % Get mouse response
            buttons(2) = 0; % change this to 3 if using linux or windows
            
            while buttons(2) == 0
                [~, responseTime, ~] = KbCheck;
                time = GetSecs - initialTime;
                [x,y,buttons] = GetMouse;
                rightClickT = time; % reaction time
                
                while buttons(1) == 1
                    [x,y,buttons] = GetMouse;
                    
                    left_click_rt = GetSecs-initialTime;
                    
                    % Dynamic reaction time while bar is moving
                    leftClickGs = [leftClickGs; left_click_rt];
                    
                    % Store start and end time of subjects each click
                    leftClickKbC = [leftClickKbC; responseTime - initialTime];
                    [leftClickKb, indices] = unique(leftClickKbC);
                    
                    r = atan((y-centerY)/(x-centerX));
                    teta = (r) - pi/2;
                    
                    % saving subjects response in degree
                    responseOrientaionDegree = (-r/pi)*180;
                    
                    if responseOrientaionDegree < 0
                        responseOrientaionDegree = responseOrientaionDegree + 180;
                    end
                    
                    db = [db; responseOrientaionDegree];
                    a_sin = (length/2) * sin(teta);
                    b_cos = (length/2) * cos(teta);
                    
                    if isnan(teta)
                        
                        Screen('DrawLine', window, mColor, centerX + (length/2)*cos(c_or), centerY - (length/2)*sin(c_or),...
                            centerX - (length/2)*cos(c_or), centerY + (length/2)*sin(c_or), 6);
                    else
                        Screen('DrawLine', window, mColor, centerX + a_sin, centerY - b_cos ,...
                            centerX - a_sin, centerY + b_cos, 6);
                    end
                    Screen('Flip', window)
                end
                
                % terminate the task at will
                [~, ~, escape_key] = KbCheck;
                if escape_key(KbName('q')) == 1 % terminate suddenly, nothing will be saved
                    % terminate the task
                    Screen('Close', window);
                    Screen('CloseAll');
                    Priority(0);
                    sca;
                    ShowCursor;
                elseif escape_key(KbName('escape')) == 1 % data will be saved but take a little longer
                    break
                end
            end
            
            if numel(rightClickT) == 0
                rightClickT = NaN;
            end
            if numel(leftClickGs) == 0
                leftClickGs = NaN;
            end
            
            % substitute response degree with NaN, if the right
            % click is not pressed
            if isnan(rightClickT)
                responseOrientaionDegree = NaN;
            end
            
            % Saving trials data
            barsColor(:, :, trialCounter) = barOrientationColor;
            startPointDegree(trialCounter) = startPoint*(180/pi);
            barsOrientation(:, :, trialCounter) = barOrientationDegree;
            matchColor(:, :, trialCounter) = mColor;
            matchOrientation(trialCounter) = matchOrientationDegree;
            responseOrientation(trialCounter) = responseOrientaionDegree;
            reactionTime(trialCounter) = rightClickT; % time between match presentation and the end(right click, reaction time)
            reactionTimeFirstAndLastClick(trialCounter) = rightClickT-leftClickGs(1); % time between first click and the end
            responseError(trialCounter) = abs(responseOrientaionDegree - matchOrientationDegree);
            barAnswerOrder(trialCounter) = which;
            dynamic_motion{trialCounter} = db;
            dynamic_time{trialCounter} = leftClickGs;
            linear_motion_start{trialCounter} = db(indices);
            linear_time_start{trialCounter} = leftClickGs(indices);
            
            % convert_indice_for_end
            cie = indices - 1;
            cie = cie(2:end);
            
            if numel(leftClickKbC) > 0
                cie = [cie; numel(leftClickKbC)];
                linearMotionEnd{trialCounter} = db(cie);
                linearTimeEnd{trialCounter} = leftClickGs(cie);
            else
                linearMotionEnd{trialCounter} = [];
                linearTimeEnd{trialCounter} = [];
            end
            
            if responseError(trialCounter) > 90 && responseError(trialCounter) <= 180
                responseError(trialCounter) = 180 - responseError(trialCounter);
                
            elseif responseError(trialCounter) > 180 && responseError(trialCounter) <= 270
                responseError(trialCounter) = responseError(trialCounter) - 180;
                
            elseif responseError(trialCounter) > 270 && responseError(trialCounter) <= 360
                responseError(trialCounter) = 360 - responseError(trialCounter);
                
            end
            
            round_response_error = round(responseError);
            HideCursor
            
            Screen('DrawText' , window , num2str(round_response_error(trialCounter)) , centerX - 14, centerY - 80 ,mColor); % Feedback
            Screen('DrawLine', window, mColor, centerX +...
                (length/2)*cos(matchOrientationDegree*(pi/180)),...
                centerY - (length/2)*sin(matchOrientationDegree*(pi/180)),...
                centerX - (length/2)*cos(matchOrientationDegree*(pi/180)), centerY +...
                (length/2)*sin(matchOrientationDegree*(pi/180)), 6);
            
            circle_f_location = length + 18;
            
            feedbackCircle = [centerX + (circle_f_location/2)*cos(responseOrientaionDegree*(pi/180))-fbSize,...
                centerY - (circle_f_location/2)*sin(responseOrientaionDegree*(pi/180))-fbSize,...
                centerX + (circle_f_location/2)*cos(responseOrientaionDegree*(pi/180))+fbSize,...
                centerY - (circle_f_location/2)*sin(responseOrientaionDegree*(pi/180))+fbSize];
            
            feedbackCircle_mirror =  [centerX - (circle_f_location/2)*cos(responseOrientaionDegree*(pi/180))-fbSize,...
                centerY + (circle_f_location/2)*sin(responseOrientaionDegree*(pi/180))-fbSize,...
                centerX - (circle_f_location/2)*cos(responseOrientaionDegree*(pi/180))+fbSize,...
                centerY + (circle_f_location/2)*sin(responseOrientaionDegree*(pi/180))+fbSize];
                      
            Screen ('FrameOval',window, [255 255 255], frameCoordinate, 3, 3);
            Screen ('FillOval',window, mColor, feedbackCircle);
            Screen ('FillOval',window, mColor, feedbackCircle_mirror);
            Screen('Flip', window)
            WaitSecs(2);
            
            % terminate the task
            if escape_key(KbName('escape')) == 1
                % terminate the task
                break
            end
        end
        
        Screen('FillRect', window, bkColor);
        
        % Press key to continue
        cd(images_path)
        continue2 = imread('continue_2.png');
        continue2Texture = Screen('MakeTexture', window, continue2);
        Screen('DrawTexture', window, continue2Texture, [], [centerX-centerX/2-150, centerY-400,...
            centerX+centerX/2+150, centerY+400], 0);
        cd(base_path)
        Screen('Flip', window)
        
        kb_wait = 0;
        while kb_wait ~= KbName('space')
            [wait_key_down, ~, wait_key_code] = KbCheck;

            if (wait_key_down)

               kb_wait = find(wait_key_code, 1);
            end
        end

        % Date and time at the end of the block
        [e_d_t] = clock;
        endDateTime(:,:,blockIdx) = e_d_t;
        
        for filling = 1:numTrials
            
            endDateTime(1,1:6,filling) = endDateTime(:,:,blockIdx);
        end
        
        % Save data
        % create folder name
        subjectFolder = fullfile(append('Subject',' ',subject_ID));
        % create directory
        mrDirectory = append(base_path,'/Results Data/',subjectFolder);
        mkdir (mrDirectory);
        % save results
        saveResults = fullfile(append(base_path,'/Results Data/',subjectFolder));
        cd(saveResults)
        
        % Results to structure
        results.subject_name = subjectName;
        results.start_blocks_date = startDateTime;
        results.end_blocks_date = endDateTime;
        results.daylight_saving_time = daylightSavingTime;
        results.response_error = responseError;
        results.reaction_time = reactionTime;
        results.bars_orientation = barsOrientation; % all orientations in each trial
        results.bars_color = barsColor; % all orientations color in each trial
        results.match_color = matchColor; % the desired orientation to remember
        results.match_orientation = matchOrientation;
        results.responce_orientation = responseOrientation;
        results.start_point = startPointDegree;
        results.answer_order = barAnswerOrder;
        results.dynamic_motion = dynamic_motion;
        results.dynamic_time = dynamic_time;
        results.linear_motion_start = linear_motion_start;
        results.linear_time_start = linear_time_start;
        results.linear_motion_end = linearMotionEnd;
        results.linear_time_end = linearTimeEnd;
        results.reaction_time_firstANDlast_click = reactionTimeFirstAndLastClick;

        % Sub-folder for subjects data
        dataFolder = fullfile(append('Subject',' ',subject_ID),...
            append('Block',' ',num2str(blockIdx)),'Data');
        m_s_r_directory = append(base_path,'/Results Data/',dataFolder);
        mkdir (m_s_r_directory);
        save_sPath = fullfile(append(base_path,'/Results Data/',dataFolder));
        cd (save_sPath)
        blocksData = append('Block',' ',num2str(blockIdx),'.mat');
        save(blocksData, 'results')
        
        % Save all data in one place
        m_all_resultsDirectory = append(base_path,...
            '/Results Data/All_Subjects');
        mkdir(m_all_resultsDirectory)
        save_all_results = fullfile(append(base_path,...
            '/Results Data/All_Subjects'));
        cd (save_all_results)
        all_data = append('Subject', ' ',subject_ID, ' ', 'Block',' ',num2str(blockIdx),'.mat');
        % the last blocks contains the information of all block and that was
        % the problem I had with merge which I solved it xD
        all_results(blockIdx) = results;
        save(all_data, 'all_results')
    end
catch
    rethrow(lasterror)
end
Screen('Close', window);
Screen('CloseAll');
Priority(0);
sca;