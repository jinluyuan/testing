%--------------------------------------------------------------------------	
function CHPilotB2()
    prefs          = Preferences(); %calls all preset parameters for study
    prefs.subNum   = input('Subject number: '); %you enter the subjnum here
    [win,fid,fid2] = Initialize(prefs); %creates screen/font/datafile
    
	% Defines rectangles for drawing the colors into
    [rectangle]    = CreateRectangle(win, prefs.circRad);
    
	% Generate trials for this subject
    [trials]       = SetupTrials(prefs.trialSetSize, prefs.numTrials);
    
    % Record date and condition
    fprintf(fid2, '%s\t%d\t%d\t\n', datestr(now), prefs.subNum, ...
        prefs.condition);
    
    % Make question mark
    fixq = imread('fixq.jpg');
    qmt=Screen('MakeTexture', win, fixq);
    
    %Disable mouse
    HideCursor
    
    %Instructions
    for i=1:7
        img = imread(strcat('instructions',num2str(i),'.jpg'));
        Screen('PutImage', win, img);
        Screen('Flip', win, [], 1);
        WaitSecs(prefs.instrdelay);
        DrawAdvanceText(win, '(press the space bar to continue)');
        Screen('Flip', win);
        % Get response
        [instructions.rt(i)] = TimeResponse(win, prefs);
        % Clear screen
        Screen('Flip', win);
        % Save information to file
        fprintf(fid2, '%s\t%f\t\n', strcat('int_', num2str(i)), instructions.rt(i));
    end
    
    %PRACTICE SERIES
    
    %Instructions
    DrawCenteredText(win, 'Practice Series');
    Screen('Flip', win, [], 1);
    WaitSecs(1);
    DrawAdvanceText(win, '(press the space bar to begin)');
    Screen('Flip', win);
    % Get response
    [rt] = TimeResponse(win, prefs);
    % Clear screen
    Screen('Flip', win);
    % Save information to file
    fprintf(fid2, '%s\t%f\t\n', 'card_0', rt);
    
    %Practice Block
        colors_prac = ColorMaker(prefs.criterion, prefs.min, ...
            prefs.max, prefs.freqP, prefs.colstep, prefs.numPracTrials);
    % For each trial
	for i=1:length(colors_prac)               
		% Draw stimuli
        DrawStim(win, prefs, rectangle, colors_prac(i,:));
        %Draw fixation question mark
        DrawFixQ(win, prefs, qmt);
		% Get response 
		[trials(i).selectedWhich, trials(i).rt] = ...
            GetResponse(win, prefs);
        % Clear screen
        Screen('Flip', win);
		% Save information to file
   		fprintf(fid, '%d\t', colors_prac(i,:));
        fprintf(fid, '%d\t%f\t\n', trials(i).selectedWhich, ...
            trials(i).rt);
		WaitSecs(prefs.betweenTrials);
    end

    %Post-practice Instructions
    img = imread('instructions8.jpg');
    Screen('PutImage', win, img);
    Screen('Flip', win, [], 1);
    WaitSecs(2);
    DrawAdvanceText(win, '(press the space bar to continue)');
    Screen('Flip', win);
    % Get response
    [rt] = TimeResponse(win, prefs);
    % Clear screen
    Screen('Flip', win);
    % Save information to file
    fprintf(fid2, '%s\t%f\t\n', 'int_8', rt);

    %Generate color vectors for initial testing blocks
    for c=1:(prefs.varBlocks-1)
        block(c).colors = ColorMaker(prefs.criterion, prefs.min, ...
            prefs.max, prefs.freq(c), prefs.colstep, prefs.trialsPerBlock);
    end
    
    %TESTING BLOCKS
    for b=1:(prefs.varBlocks-1)
        %Present instruction title card thing
            DrawCenteredText(win, strcat(['Series ', num2str(b)]));
            Screen('Flip', win, [], 1);
            WaitSecs(1);
            DrawAdvanceText(win, '(press the space bar to begin)');
            Screen('Flip', win);
            % Get response
            [instructions.rt(b)] = TimeResponse(win, prefs);
            % Clear screen
            Screen('Flip', win);
            % Save information to file
            fprintf(fid2, '%s\t%f\t\n', strcat('card_', num2str(b)), instructions.rt(b)); 
        
        %Present dot for each trial in the block
        for i=1:length(block(b).colors)
            % Draw stimuli
            DrawStim(win, prefs, rectangle, block(b).colors(i,:));
            %Draw fixation question mark
            DrawFixQ(win, prefs, qmt);
            % Get response 
            [trials(i).selectedWhich, trials(i).rt] = ...
                GetResponse(win, prefs);
            % Clear screen
            Screen('Flip', win);
            % Save information to file
            fprintf(fid, '%d\t', block(b).colors(i,:));
            fprintf(fid, '%d\t%f\t\n', trials(i).selectedWhich, ...
                trials(i).rt);
            WaitSecs(prefs.betweenTrials);
        end
    
        %Record responses from this block in a master vector
        ith = (((b-1)*prefs.trialsPerBlock)+1);
        record.colors(ith:(ith+(prefs.trialsPerBlock-1)),:) = block(b).colors;
        
        %Take a break!
        img = imread('instructions9.jpg');
        Screen('PutImage', win, img);
        Screen('Flip', win);
        WaitSecs(prefs.betweenBlocks);
        
    end
    
    %CALCULATE CRITERION 2
    % ???
        
    %Generate color vectors for treatment blocks
    for c=prefs.varBlocks:prefs.numBlocks
        block(c).colors = ColorMaker(prefs.criterion2, prefs.min,...
            prefs.max, prefs.freq(c), prefs.colstep, prefs.trialsPerBlock);
    end
    
    for b=prefs.varBlocks:prefs.numBlocks
        %Present instruction title card thing
            DrawCenteredText(win, strcat(['Series ', num2str(b)]));
            Screen('Flip', win, [], 1);
            WaitSecs(1);
            DrawAdvanceText(win, '(press the space bar to begin)');
            Screen('Flip', win);
            % Get response
            [instructions.rt(b)] = TimeResponse(win, prefs);
            % Clear screen
            Screen('Flip', win);
            % Save information to file
            fprintf(fid2, '%s\t%f\t\n', strcat('card_', num2str(b)), instructions.rt(b)); 
        
        %Present dot for each trial in the block
        for i=1:length(block(b).colors)
            % Draw stimuli
            DrawStim(win, prefs, rectangle, block(b).colors(i,:));
            %Draw fixation question mark
            DrawFixQ(win, prefs, qmt);
            % Get response 
            [trials(i).selectedWhich, trials(i).rt] = ...
                GetResponse(win, prefs);
            % Clear screen
            Screen('Flip', win);
            % Save information to file
            fprintf(fid, '%d\t', block(b).colors(i,:));
            fprintf(fid, '%d\t%f\t\n', trials(i).selectedWhich, ...
                trials(i).rt);
            WaitSecs(prefs.betweenTrials);
        end
        
%         %Record responses from this block in a master vector
%         ith = (((prefs.trialsPerBlock*prefs.varBlocks)+1)+((b-prefs.varBlocks)*50));
%         record.colors(ith:(ith+49),:) = block(b).colors;
        
        %Record responses from this block in a master vector
        ith = (((prefs.trialsPerBlock*prefs.varBlocks)+1)+...
            ((b-prefs.varBlocks)*prefs.trialsPerBlock));
        record.colors(ith:(ith+(prefs.trialsPerBlock-1)),:)...
            = block(b).colors;
        
        %Take a break!
        img = imread('instructions9.jpg');
        Screen('PutImage', win, img);
        Screen('Flip', win);
        WaitSecs(prefs.betweenBlocks);
    end
        
    DrawCenteredText(win, 'Thanks for your participation.');
    Screen('Flip', win); KbWait;
    
    %DEBUG ONLY: show color struct
    assignin('base', 'record', record.colors);
            
	% Clean up
    ShowCursor
    fclose(fid);
    fclose(fid2);
    Screen('CloseAll');

%--------------------------------------------------------------------------	        
function DrawStim(win, prefs, rectangle, colors)

    % Draw the circle
    Screen('FillOval', win, colors, rectangle);
    rct = Screen('Rect', win);
    [VBLTimestamp]=Screen('Flip', win);
    %Screen('Flip', win, VBLTimestamp+prefs.timeForColors); 
    WaitSecs(prefs.timeDelay);
    
%--------------------------------------------------------------------------
function [selectedWhich,rt]=GetResponse(win, prefs)	

    % Get key from the subject
    start = GetSecs;	   
    while 1
        [keyIsDown, secs, keyCode] = KbCheck;
        if any(keyCode(prefs.keys))
            rt = secs - start;
            keyWhat=find(keyCode);
            selectedWhich = find(prefs.keys == find(keyCode ~= 0, 1, 'last'));
            break;
        end
        if keyCode(prefs.quitKey), sca; error('User quit'); end
    end

%--------------------------------------------------------------------------
function [rt] = TimeResponse(win, prefs)	

    % Get key from the subject
    start = GetSecs;	   
    while 1
        [keyIsDown, secs, keyCode] = KbCheck;
        if any(keyCode(prefs.advanceKey))
            rt = secs - start;
            keyWhat=find(keyCode);
            selectedWhich = find(prefs.advanceKey == find(keyCode ~= 0, 1, 'last'));
            break;
        end
        if keyCode(prefs.quitKey), sca; error('User quit'); end
    end
       
%--------------------------------------------------------------------------	    
function DrawFixCross(win, prefs)
    rct = Screen('Rect', win);
    [xc,yc] = RectCenter(rct);
    FixCross = [xc-prefs.FCwidth,yc-prefs.FClength,xc+prefs.FCwidth,yc+prefs.FClength;xc-prefs.FClength,yc-prefs.FCwidth,xc+prefs.FClength,yc+prefs.FCwidth]; 
    Screen('FillRect', win, prefs.FCcolor, FixCross');
    Screen('Flip', win);
    
%--------------------------------------------------------------------------	    
function DrawFixQ(win, prefs, texture)
    Screen('DrawTexture', win, texture);
    Screen('Flip', win);

%--------------------------------------------------------------------------	    
 function [trials] = SetupTrials(setSize, numTrials)    
     % Generate trials. Not sure if I need this.
 	for i=1:numTrials
         trials(i).colorsToShow = Shuffle(1:setSize);
         trials(i).testWhich = Randi(setSize);
    end
    
%--------------------------------------------------------------------------	
function p = Preferences()
	% Setup preferences for this experiment
    p.studyName       = 'CB1302d';
    p.studyMeta       = 'CB1302m';
    
    % What colors and monitor to use
	p.monitor         = max(Screen('Screens')); %uses largest screen
	p.backColor       = [128 128 128]; %sets a light gray background
	p.foreColor       = [0 0 0]; 
    p.textColor       = [0 0 0];
    
    p.criterion       = 180; %criterion for the initial blocks?
    p.criterion2      = 180; %TEMP: criterion for later blocks
    p.colstep         = 2;
    p.spectrum        = 50;  %How wide will the spectrum be (radius)?
    p.min             = 130; %Lower bound of the spectrum?
    p.max             = 228; %Upper bound of the spectrum?

    %What frequencies are we using for the blocks?
     p.toss = rand();
     if p.toss>=.5
         p.freqP = .5; %practice
         for z = 1:4
            p.freq(z)=.5; %blocks 1-4
         end
         p.freq(5)=.4; %block 5
         p.freq(6)=.28; %block 6
         p.freq(7)=.16; %block 7
         for z = 8:20
            p.freq(z)=.06; %blocks 8-20 %should be .06
         end
         p.condition=1;
     else
        p.freqP = .5; %practice
        for z=1:20
            p.freq(z) = .5;
        end
        p.condition=0;
    end
    
    
    % What keys the subject can use to respond
	p.keys		      = [KbName('LeftShift') KbName('RightShift')];
    p.advanceKey      = KbName('space');
	p.quitKey         = KbName('q');
    
    % Information about the location and size of the stimuli
	p.circRad         = 200;
	p.stimSize        = 85; %??? what is this
    p.FCwidth         = 4;  
    p.FClength        = 20;
    p.FCcolor         = [0,0,0];
    
    % How many trials and how many items per trial
	p.trialSetSize      = 1; %how many dots on the screen
	p.numTrials         = 10;
    p.trialsPerBlock    = 50; 
    p.numPracTrials     = 10;
    p.numBlocks         = 5;
    p.varBlocks         = 3; %what block do you start changing freq on?
    
    % Timing information
    p.timeDelay       = .5;
    p.betweenTrials   = .5;
    p.instrdelay      = 1.0;
    p.betweenBlocks   = 2;
    
%--------------------------------------------------------------------------        
function [rectangle] = CreateRectangle(win, circrad)
    % Define the rectangle where the circles will go,
    % at the center of the screen
    rct = Screen('Rect', win);
    sW = rct(3)-rct(1); % width of screen = right-left
    sH = rct(4)-rct(2); % height of screen = bottom-top (remember, top of screen is 0)
    cX = sW/2; % center of screen is half of screen width
    cY = sH/2; % center of screen is half of screen height
    rectangle = [cX-circrad cY-circrad cX+circrad cY+circrad];

%--------------------------------------------------------------------------        
function colors = ColorMaker(bcf2, smin, smax, freq, colstep, numberoftrials)

    %% noise
    bnoise=smin:colstep:(bcf2-colstep); %define blues
    colornoise=[(255-bnoise).' zeros(1,length(bnoise)).' bnoise.']; %assemble noise color matrices
    
    %% signals
    bsignal=bcf2:colstep:smax; %define blues
    colorsignal=[(255-bsignal).' zeros(1,length(bsignal)).' bsignal.']; %assemble noise color matrices
    
    %% assemble the distribution for this block, given a specified freq
    
    if (round(numberoftrials*(1-freq))) > (length(colorsignal))
        randnoise = colornoise(randsample(size(colornoise,1), round(numberoftrials*(1-freq)), true),:);
        randsignal = colorsignal(randsample(size(colorsignal,1), round(numberoftrials*(freq)), true),:);
    else
        randnoise = colornoise(randsample(size(colornoise,1), round(numberoftrials*(1-freq)), false),:);
        randsignal = colorsignal(randsample(size(colorsignal,1), round(numberoftrials*(freq)), false),:);
    end
    
    randcombined = cat(1,randnoise,randsignal);
    colors = randcombined(randperm(end),:);

%--------------------------------------------------------------------------
function DrawCenteredText(win, text, color, xoff, yoff)
    bbox = Screen('TextBounds', win, text);
    bbox = CenterRect(bbox, Screen('Rect', win));
    x=bbox(RectLeft);
    y=bbox(RectTop);
    Screen('DrawText', win, text, x+0, y-30);
    
%--------------------------------------------------------------------------
function DrawAdvanceText(win, text, color, xoff, yoff)
    bbox = Screen('TextBounds', win, text);
    bbox = CenterRect(bbox, Screen('Rect', win));
    x=bbox(RectLeft);
    y=bbox(RectTop);
    Screen('DrawText', win, text, x+0, y+400);        
    
%--------------------------------------------------------------------------	
function [win,fid,fid2] = Initialize(prefs)	
	% Do setup for the experiment. Makes screen, sets text size/color/font,
	% makes datafile, resets randomizer seed.
	commandwindow;
    rand('state',sum(100*clock)); %resets where you get your random #s from.
	win = Screen('OpenWindow', prefs.monitor, prefs.backColor); %I TOOK OUT screenRect HERE
    Screen('Flip', win, [], 1);
	Screen('FillRect', win, prefs.backColor);
	Screen('Flip', win);
	Screen('TextSize', win, 30);
    Screen(win,'TextFont', 'Helvetica');
	
	% Setup output file
    if (~exist('Data', 'file'))
        mkdir('Data');
    end
	fName = sprintf('Data/%s_sub%d.dat', prefs.studyName, prefs.subNum);
    while exist(fName,'file')
        prefs.subNum = prefs.subNum+100;
        fName = sprintf('Data/%s_sub%d.dat', prefs.studyName, prefs.subNum);
    end
	fid = fopen(fName, 'w'); 
    
    % Setup second output file
	fName2 = sprintf('Data/%s_sub%d.dat', prefs.studyMeta, prefs.subNum);
    while exist(fName2,'file')
        prefs.subNum = prefs.subNum+100;
        fName2 = sprintf('Data/%s_sub%d.dat', prefs.studyMeta, prefs.subNum);
    end
	fid2 = fopen(fName2, 'w'); 