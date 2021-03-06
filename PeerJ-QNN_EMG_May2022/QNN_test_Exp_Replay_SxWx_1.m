%----------------------------------------------------------------------------------------------------------
%------- ESCUELA POLITECNICA NACIONAL - LABORATORIO DE INTELIGENCIA Y VISION ARTIFICIAL ALAN TURING -------
%----------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------
%
% SISTEMA HGR de 5 gestos de la mano - EMG - Myo - modelo usuario espec?fico - sin toolbox de matlab
%
% 1. En carpeta C:\Users\juanp\Desktop\Respaldos C?digos\1.QNN_EMG_RandomData_7ok_var_wind_size-NoToolbox-Ene2021\Data\Specific
% poner usuario que se desea procesar.
%
% 2. Correr archivo QNN_train_emg_Exp_Replay_SxWx_1.m para entrenar
%
% 3. Correr archivo QNN_test_Exp_Replay_SxWx_1.m para obtener archivo 

% Nota: Dataset de entrenamiento y de testeo contienen 306 usuarios c/u. Cada usuario tiene 5
% gestos y el gesto de relajaci?n (no gessto). Para cada gesto se tienen
% 25 repeticiones. Durante el entrenamiento, los datos de cada gesto se
% envian al agente de manera alternada, un gesto de cada clase, hasta
% terminar con los datos de entrenamiento.
% Se puede cambiar el tama?o de la ventana, stride, y del numero de epocas que todos los datos 
% de un usuario se pasan por el algoritmo.
%----------------------------------------------------------------------

function QNN_test_Exp_Replay()
addpath('Multivariate Regression Neural Network Toolbox');
addpath('Visualization Toolbox');
addpath('QNN Toolbox');
addpath('Gridworld Toolbox');

%------------------------------------
addpath(genpath('FeatureExtraction'));
addpath(genpath('Data'));
addpath(genpath('PreProcessing'));
addpath(genpath('testingJSON'));
addpath(genpath('trainingJSON'));

num_prev_actions=3;    % CAMBIAR - 0 si no quiero acciones previas en vector de caracteristicas ; 1 hasta N CAMBIAR NUMERO DE ACCIONES PREVIAS a considerar
assignin('base','num_prev_actions',num_prev_actions); 

assignin('base','Stride',  40);        %CAMBIAR - 20
assignin('base','WindowsSize',  300);   %CAMBIAR - 200
RepTraining        = 13;       %numero de muestras que voy a usar en el entrenamiento x cada usuario en la carpeta C:\Users\juanp\Desktop\QNN - EMG - RandomData - Copy\Data\Specific
on  = true;
off = false;
assignin('base','Reward_type',     on);%on si quiero recompensa -1 x ventana (clasif) y -10 x recog
                                     %off si quiero solo recomp -10 x recog 

assignin('base','post_processing',     on);   %on si quiero post procesamiento en vector de etiquetas resultadnte                                                                                        
Reward_type      =  evalin('base', 'Reward_type');
post_processing      =  evalin('base', 'post_processing');

assignin('base','RepTraining',  RepTraining); 
assignin('base','randomGestures',     off);   %on si quiero leer datos randomicamente
assignin('base','noGestureDetection', off);  %off si no quiero considerar muestras con nogesture - OJO> actualmente el gesto predicho es la moda sin incluir no gesto
%limite superior de rango de muestras a leer
assignin('base','rangeValues', 150);  %up to 300 - rango de muestras PERMITIDO que uso dentro del dataset, del cual tomo "RepTraining" muestras
assignin('base','packetEMG',     off); % NO TOCAR PARA TESTEO

rangeDown=126;  %limite inferior de rango de muestras a leer
assignin('base','rangeDown', rangeDown); 
Code_0(rangeDown);
dataPacketSize1     = evalin('base', 'dataPacketSize');

% EMG_window_size = 200;                                                  %AQUI PONER WINDOW SIZE
% stride = 20;                                                            %AQUI PONER STRIDE


%assignin('base','Reward_type',     on);   %on si quiero leer datos randomicamente
Stride = evalin('base', 'Stride');                                                %AQUI PONER WINDOW SIZE
EMG_window_size = evalin('base', 'WindowsSize'); 


% Esto es nuevo 
%Code_0;
%dataPacketSize1   = evalin('base', 'dataPacketSize');

%RepTraining      = 100;  % CAMBIAR numero de repeticiones por cada usuario (CAMBIAR SEGUN SE REQUIERA - up to 300)  CAMBIAR CAMBIAR CAMBIAR
%assignin('base','RepTraining',RepTraining);
numEpochs  = RepTraining*(dataPacketSize1-2);  %numero total de muestras de todos los usuarios
%------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('QNN_Trained_Model_1.mat');     %CAMBIAR -> Aqui se carga el modelo entrenado
      s1 = 'Full_dataTEST_';
      assignin('base','s1', s1);  
      s2   = '1';                    %CAMBIAR -> Aqui se pone el numero de experimetno
      assignin('base','s2', s2); 
      s3 = '.csv';
      assignin('base','s3', s3); 
      s = strcat(s1,s2,s3);
      assignin('base','s', s); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning off all;
%numEvaluations = 4; %25
score = 0;
%figNum = gcf;

%------------------------------------------------------------------
%Code_0(rangeDown);
dataPacketSize   = evalin('base', 'dataPacketSize');
orientation      = evalin('base', 'orientation');
RepTraining      =  evalin('base', 'RepTraining'); %RepTraining1; 2 %;  %options.epsilon +2; %2;  %numero de repeticiones por cada usuario (CAMBIAR SEGUN SE REQUIERA - up to 300)  CAMBIAR CAMBIAR CAMBIAR
RepTotalTraining =  RepTraining*(dataPacketSize-2);
%------------------------------------------------------------------
numIterationTotal = 0;
window_n=0; %contador de numero de ventanas
conta=1;
etiquetas_labels_predichas_matrix=strings(42,numEpochs);

countWins=0;
countLoses=0;
countWins2=0;
countLoses2=0;
number_classif_ok=0;
number_classif_failed=0;


for i = 1:numEpochs %numEvaluations
    %figure(figNum.Number + 1);
    %result = testQNN(weights, transferFunctions, options, typeWorld, 'AI');
    
    cumulativeIterationReward = 0;
    
    %Leo ventana inicial de cierta muestra --------------------------------------------
    [Numero_Ventanas_GT,EMG_GT,Features_GT,Tiempos_GT,Puntos_GT,Usuario_GT,gestureName_GT,groundTruthIndex_GT,groundTruth_GT] = ...
        Code_1(orientation,dataPacketSize,RepTraining,RepTotalTraining);
    
    while Usuario_GT=="NaN"
        
        if Usuario_GT~="NaN"
            break
        end
        
        [Numero_Ventanas_GT,EMG_GT,Features_GT,Tiempos_GT,Puntos_GT,Usuario_GT,gestureName_GT,groundTruthIndex_GT,groundTruth_GT] = ...
            Code_1(orientation,dataPacketSize,RepTraining,RepTotalTraining);
    end
    
    %Creo vector con limite derecho de cada ventana
        gt_gestures_pts=zeros(1,Numero_Ventanas_GT);
        gt_gestures_pts(1,1)=EMG_window_size;
        
        for k = 1:Numero_Ventanas_GT-1
            gt_gestures_pts(1,k+1)=gt_gestures_pts(1,k)+Stride;
        end
        %disp('gt_gestures_pts');disp(gt_gestures_pts);
        assignin('base','gt_gestures_pts',gt_gestures_pts);
        
        %Creo vector de etiquetas para Ground truth x ventana
        gt_gestures_labels=strings;
        %gt_gestures_labels(1,1)="noGesture";
        for k2 = 1:Numero_Ventanas_GT
            if gt_gestures_pts(1,k2) >= (groundTruthIndex_GT(1,1) + EMG_window_size/5) && gt_gestures_pts(1,k2) <= groundTruthIndex_GT(1,2)
                %disp('case1')
                gt_gestures_labels(1,k2)=string(gestureName_GT);
            elseif  gt_gestures_pts(1,k2)-EMG_window_size <= (groundTruthIndex_GT(1,2)-EMG_window_size/5 ) && gt_gestures_pts(1,k2) >= groundTruthIndex_GT(1,2)
                %Considero 1/5 el tama?o de la ventana
                %disp('case2')
                gt_gestures_labels(1,k2)=string(gestureName_GT);
            else
                %disp('case3')
                gt_gestures_labels(1,k2)="noGesture";
            end
        end
        %disp('gt_gestures_labels');disp(gt_gestures_labels);
        assignin('base','gt_gestures_labels',gt_gestures_labels);
        %Creo vector de etiquetas de Ground truth con valores numericos
        gt_gestures_labels_num=zeros(Numero_Ventanas_GT-1,1);
        %gt_gestures_labels_num(1,1)=6;
        for k3 = 2:Numero_Ventanas_GT
            if gt_gestures_labels(1,k3) == "waveOut"
                gt_gestures_labels_num(k3,1)=1;
            elseif gt_gestures_labels(1,k3) == "waveIn"
                gt_gestures_labels_num(k3,1)=2;        %CAMBIAR
            elseif gt_gestures_labels(1,k3) == "fist"
                gt_gestures_labels_num(k3,1)=3 ;         %CAMBIAR
            elseif gt_gestures_labels(1,k3) == "open"
                gt_gestures_labels_num(k3,1)=4;         %CAMBIAR
            elseif gt_gestures_labels(1,k3) == "pinch"
                gt_gestures_labels_num(k3,1)=5;       %CAMBIAR
            elseif gt_gestures_labels(1,k3) == "noGesture"
                gt_gestures_labels_num(k3,1)=6;        %CAMBIAR
            end
        end
        %disp('gt_gestures_labels_num');disp(gt_gestures_labels_num);
        assignin('base','gt_gestures_labels_num',gt_gestures_labels_num);
        %----------------------------------------------

    
    %-----------------------------------------------------------------------------------
    window_n=window_n+1;                               %window_n == 1
    Vector_EMG_Tiempos_GT=zeros(1,Numero_Ventanas_GT); %creo vector de tiempos de gt
    Vector_EMG_Puntos_GT=zeros(1,Numero_Ventanas_GT);  %creo vector de puntos de gt
    Vector_EMG_Tiempos_GT(1,window_n)=Tiempos_GT;      %copio primer valor en vector de tiempos de gt
    Vector_EMG_Puntos_GT(1,window_n)=Puntos_GT;        %copio primer valor en vector de tiempos de gt
    
    %---- Defino estado inicial en base a cada ventana EMG  -----------------------------------------------------*
    %state = rand(1, 40);
    state =table2array(Features_GT);           %Defino ESTADO inicial
    disp('initial state')
    
    %---------------feb----------------------
    prev_action_0=zeros(1, num_prev_actions*6);
    if num_prev_actions>0
        state=[state prev_action_0];
    end
    %---------------------------------------
    
    %disp(state)
    %disp('state')
    %disp(size(state))
    
    %Each_complete_signal = rand(1, 40*Numero_Ventanas_GT); %rand(1, 40*maxWindowsAllowed);      %AQUI CAMBIAR, HAY QUE PONER CADA SE?AL COMPLETA AQUI  %&&&&&&&&&&&&&&&&
    
    % ---- Inicializo variables requeridas para guardar datos de prediccion
    %etiquetas = 1+round((5)*rand(Numero_Ventanas_GT,1));   %1+round((5)*rand(maxWindowsAllowed,1)); %%%%%%%% AQUI PONER ground truth de cada ventana EMG - gestos de 1 a 6
    
    etiquetas = gt_gestures_labels_num; %1+round((5)*rand(Numero_Ventanas_GT,1));   %1+round((5)*rand(maxWindowsAllowed,1)); %%%%%%%% AQUI PONER ground truth de cada ventana EMG - gestos de 1 a 6
 
    etiquetas_labels_predichas_vector=strings;
    %etiquetas_labels_predichas_matrix=strings;
    etiquetas_labels_predichas_vector_without_NoGesture=strings;
    %etiquetas_GT_vector=strings; %gestureName_GT
    %etiquetas_labels_predichas_matrix_without_NoGesture=strings;
    acciones_predichas_vector = zeros(Numero_Ventanas_GT,1);%zeros(maxWindowsAllowed,1);         %%%%%%%%   EN ESTE VECTOR VAN A IR LAS ACCIONES PREDICHAS, LAS
    
    % ---- inicializo parametros medicion tiempo, y vectores de prediccion
    % necesarios para evaluar reconocimiento en cada epoca -----------------
    ProcessingTimes_vector=[];
    TimePoints_vector=[];
    n1=0;
    etiquetas_labels_predichas_vector_simplif=strings;
    %----------------------------------------------------------------
    
    % if strcmp(typeControl, 'AI')
    %     displayWorld(state);
    % else
    %     displayWorld(state, false);
    % end
    
        % Interaction of agent with the world
    gameOn = true;                                               % Indicator of reaching a final state
    cumulativeGameReward = 0;                                    % Inicializo reward acumulado
    numIteration = 0;                                            % Inicializo  numIteration
    

    %maxNumSteps = 10;
    stepNum = 0;
    
    tic
    
    while gameOn
        
        numIterationTotal = numIterationTotal + 1;
        numIteration = numIteration + 1;
        
        stepNum = stepNum + 1;
        %if strcmp(typeControl, 'AI')
        [dummyVar, A] = forwardPropagation(state(:)', weights,...
            transferFunctions, options);
        Qval = A{end}(:, 2:end);
        [dummyVar, action] = max(Qval);
        
        acciones_predichas_vector(numIteration,1)=action;   % AQUI SE VAN GUARDADNO LAS ACCIONES PREDICHAS DENTRO DEl vector de UNA EPOCA
        
        %     else
        %         % Read the action from keyboard
        %         keyPressed = getkey();
        %         % up = 30, down = 31, left = 28, right = 29
        %         if keyPressed == 30, action = 1; end
        %         if keyPressed == 31, action = 2; end
        %         if keyPressed == 28, action = 3; end
        %         if keyPressed == 29, action = 4; end
        %     end
        % Taking the selected action
        %     if strcmp(typeControl, 'AI')
        %         displayAction(state, action);
        %     else
        %         displayAction(state, action, false);
        %     end
        
                %2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
        % Numero_Ventanas     %   Escalar: ejem: 40 ventanas
        % EMG                 %   200 points x 8 channels
        % Vector_EMG_Features %   1x40 feature column - table type
        % Vector_EMG_Tiempos  %   Escalar - es necesario vectorizar y procesar
        % Vector_EMG_Puntos   %   Escalar - es necesario vectorizar y procesar
        % Nombre_Usuario      %   String - ej: 'user3'
        % gestureName         %   categorical - ej: noGesture
        % groundTruthIndex    %   [0 1] since is Nogesture
        % groundTruth         %   1x1000 points logical array
        
        % WO    = 1 % WI    = 2 % FIST  = 3 % OPEN  = 4 % PINCH = 5 % RELAX = 6
        %              _________
        % 1 |---------|        |------------| 1000
        
        [Numero_Ventanas_GT,EMG_GT,Features_GT,Tiempos_GT,Puntos_GT,Usuario_GT,gestureName_GT,groundTruthIndex_GT,groundTruth_GT] = ...
            Code_1(orientation,dataPacketSize,RepTraining,RepTotalTraining);
       
        
        while Usuario_GT=="NaN"
            if Usuario_GT~="NaN"
                break
            end
            [Numero_Ventanas_GT,EMG_GT,Features_GT,Tiempos_GT,Puntos_GT,Usuario_GT,gestureName_GT,groundTruthIndex_GT,groundTruth_GT] = ...
                Code_1(orientation,dataPacketSize,RepTraining,RepTotalTraining);
        end
        
        window_n=window_n+1; %window_n == 2 hasta window final
        
        %---- Vectorizo datos necesarios de vectores de timpos y de puntos de Ground truth -----------------*
        %  if window_n==Numero_Ventanas_GT -> FIN DE JUEGO
        if window_n==Numero_Ventanas_GT%+1  %REV este +1  %window_n==Numero_Ventanas_GT
            Vector_EMG_Tiempos_GT(1,window_n)=Tiempos_GT;  % al final tengo vector de tiempos ej: (1xNumero_Ventanas_GT) - ultima ventana
            Vector_EMG_Puntos_GT(1,window_n)=Puntos_GT;    % al final tengo vector de puntos ej: (1xNumero_Ventanas_GT) - ultima ventana
            fin_del_juego=1;                               % bandera fin de juego
            window_n=0;                                    % reinicio cont ventana
            disp('fin del juego')
        else % EN ESTE ELSE se hace el barrido de ventanas, y se concatena datos en vectores
            Vector_EMG_Tiempos_GT(1,window_n)=Tiempos_GT;  %dato escalar guardo en vector
            Vector_EMG_Puntos_GT(1,window_n)=Puntos_GT;    %dato escalar guardo en vector
            fin_del_juego=0;
        end
        
        %new_state = getState(state, action);
        new_state = table2array(Features_GT);
        
        if numIteration==1
            new_state_full=horzcat(new_state,prev_action_0);
        elseif numIteration>1
            new_state_full=horzcat(new_state,new_state_full(41:num_prev_actions*6+40));
        end
        
        %--------------feb--------------
        %funcion concatena 'N=num_prev_actions' acciones pasadas predichas en vector de caracteristicas
        new_state_full=action_despl(new_state_full,num_prev_actions,action);
        disp('new_state_full');disp(new_state_full)
        %------------------------------
        
        
        %disp("etiquetas");disp(etiquetas);
        %disp(size(etiquetas))
        assignin('base','etiquetas',etiquetas);
        %disp("numIteration");disp(numIteration);
        assignin('base','numIteration',numIteration);
        etiqueta_actual=etiquetas(numIteration,1);                           % ground truth de cada ventana EMG - CAMBIAR -
        %disp("etiqueta_actual");disp(etiqueta_actual);
        assignin('base','etiqueta_actual',etiqueta_actual);
        
        acciones_predichas_actual=acciones_predichas_vector(numIteration,1); % accion predicha por ANN
        
        
        %reward = getReward(new_state);
        %reward = getReward_emg_0reward(acciones_predichas_actual, etiqueta_actual); % AQUI HAY QUE DEFINIR RECOMPENSAS EN BASE A GROUNDTRUTH EMG
        
        if Reward_type ==true
            %disp('-1 reward')
            reward = getReward_emg(acciones_predichas_actual, etiqueta_actual); % AQUI HAY QUE DEFINIR RECOMPENSAS EN BASE A GROUNDTRUTH EMG
            score = score + reward;
        else
            %disp('0 reward')
            reward = getReward_emg_0reward(acciones_predichas_actual, etiqueta_actual);
            score = score + reward;
        end
        
       if  acciones_predichas_actual ~= etiqueta_actual  %conteo de clasificaciones exitosas
           countLoses2 = countLoses2 +1;
           disp("countLoses2");disp(countLoses2);
       else
           countWins2 = countWins2 + 1;
           disp("countWins2");disp(countWins2);
       end
        
        %     if strcmp(typeControl, 'AI')
        %         displayWorld(new_state);
        %     else
        %         displayWorld(new_state, false);
        %     end
        
        %title(['Trial = ' num2str(stepNum) ' of ' num2str(maxNumSteps)]);
        %pause(0.10);
        %     if reward == +10
        %         result = 1;
        %         title('Game over: Your agent WON :)');
        %         drawnow;
        %         break;
        %     elseif reward == -10
        %         result = 0;
        %         title('Game over: Your agent LOST :(');
        %         drawnow;
        %         break;
        %     end
        %     if stepNum >= maxNumSteps
        %         result = 0;
        %         title('Game over: Your agent LOST :(');
        %         drawnow;
        %         break;
        %     end
        
        assignin('base','acciones_predichas_vector',acciones_predichas_vector);
        % asigno a gesto --1 a 6-- una etiqueta categorica  %ESTO CAMBIAR - Etiquetas de PREDICCIONES
        % class(etiquetas_labels_predichas_vector)
        if acciones_predichas_actual == 1
            etiquetas_labels_predichas_vector(numIteration,1)="waveOut";
        elseif acciones_predichas_actual == 2
            etiquetas_labels_predichas_vector(numIteration,1)="waveIn";        %CAMBIAR
        elseif acciones_predichas_actual == 3
            etiquetas_labels_predichas_vector(numIteration,1)="fist" ;         %CAMBIAR
        elseif acciones_predichas_actual == 4
            etiquetas_labels_predichas_vector(numIteration,1)="open";         %CAMBIAR
        elseif acciones_predichas_actual == 5
            etiquetas_labels_predichas_vector(numIteration,1)="pinch" ;       %CAMBIAR
        elseif acciones_predichas_actual == 6
            etiquetas_labels_predichas_vector(numIteration,1)="noGesture" ;        %CAMBIAR
        end
        
        %         disp('numIteration');disp(numIteration);
        %         disp('Numero_Ventanas_GT-1');disp(Numero_Ventanas_GT-1);
        
        %Acondicionar vectores - si el signo anterior no es igual al signo acual entocnes mido tiempo
        if numIteration>1 && numIteration~=Numero_Ventanas_GT-1 && ...   %numIteration~=maxWindowsAllowed
                etiquetas_labels_predichas_vector(numIteration,1) ~= etiquetas_labels_predichas_vector(numIteration-1,1)
            
            n1=n1+1;
            ProcessingTimes_vector(1,n1) = toc;  %mido tiempo transcurrido desde ultimo cambio de gesto
            tic;
            
            %obtengo solo etiqueta que se ha venido repetiendo hasta instante numIteration-1
            etiquetas_labels_predichas_vector_simplif(1,n1)=etiquetas_labels_predichas_vector(numIteration-1,1);
            
            %obtengo nuevo dato para vector de tiempos
            TimePoints_vector(1,n1)=Stride*numIteration+EMG_window_size/2;           %necesito dato de stride y tama?o de ventana de Victor
            
        elseif numIteration== Numero_Ventanas_GT-1 %==maxWindowsAllowed    % si proceso la ultima ventana de la muestra de se?al EMG
            
            %disp('final window')
            
            n1=n1+1;
            ProcessingTimes_vector(1,n1) = toc;  %mido tiempo transcurrido desde ultimo cambio de gesto
            tic;
            
            %obtengo solo etiqueta que no se ha repetido hasta instante numIteration-1
            etiquetas_labels_predichas_vector_simplif(1,n1)=etiquetas_labels_predichas_vector(numIteration,1);
            
            %obtengo dato final para vector de tiempos
            kj=size(groundTruth_GT);  %  se supone q son 1000 puntos
            TimePoints_vector(1,n1)=  kj(1,2);                 %AQUI CAMBIAR  %1000 puntos
            
        end
        
        %Saco la moda de los gestos diferentes a NoGesture
        temp1=(size(etiquetas_labels_predichas_vector));
        temp1=temp1(1,1);
        
        %disp('etiquetas_labels_predichas_vector')
        %disp(etiquetas_labels_predichas_vector)
        %saco no gesture de este vector para poder usar funcion moda
        %-------- REVISAR-ESTO HABILITAR SI REQUIERO QUITAR NO GESTURE -----
        for i=1:temp1
            if etiquetas_labels_predichas_vector(i,1)~="noGesture"
                etiquetas_labels_predichas_vector_without_NoGesture(i,1)=etiquetas_labels_predichas_vector(i,1);
            else
            end
        end
        %disp('etiquetas_labels_predichas_vector_without_NoGesture')
        %disp(etiquetas_labels_predichas_vector_without_NoGesture)
        class_result=mode(categorical(etiquetas_labels_predichas_vector_without_NoGesture));  %Saco la moda de las etiquetas dif a no gesture
        %-----------------------------------------------------------------
       

       %Si al sacar la moda todo es no gesto (<missing>), entonces la moda es no gesto
        if ismissing(class_result)
            class_result="noGesture";
        else
        end
        
%        if  gestureName_GT ~= class_result  %conteo de clasificaciones exitosas
%            countLoses2 = countLoses2 +1;
%        else
%            countWins2 = countWins2 + 1;
%        end
        
       %esto es para guardar resultados de clasificacion 
       class_result_vector(1,conta)=string(class_result); %
       %disp(class_result)
       assignin('base','class_result_vector',class_result_vector);
        

        disp("Numero_Ventanas_GT");disp(Numero_Ventanas_GT-1)
        assignin('base','Numero_Ventanas_GT',Numero_Ventanas_GT-1);
        if  numIteration == Numero_Ventanas_GT -1 %==maxWindowsAllowed % reward == -10  end the game - lose
            
            %-----------check de las variables predichas que entran a eval de reconocimiento
            %disp('etiquetas_labels_predichas_vector');
            %disp(etiquetas_labels_predichas_vector); %[N,1] %vector Full
            assignin('base','etiquetas_labels_predichas_vector',etiquetas_labels_predichas_vector);
            var1=size(etiquetas_labels_predichas_vector);
            var2=size(etiquetas_labels_predichas_matrix);
            %etiquetas_labels_predichas_matrix(:,conta)=etiquetas_labels_predichas_vector;

            %Este lazo completa el vector etiquetas_labels_predichas_vector de ser neceario
            %, ya que tiene q coincidir con la
            %dimension del vector etiquetas_labels_predichas_matrix para poder imprimirlo en cvs
            for t1=var1+1:var2
                etiquetas_labels_predichas_vector(t1,1)=("N/A");
            end
            etiquetas_labels_predichas_matrix(:,conta)=etiquetas_labels_predichas_vector;
            
            %             if var1(1,1) == 36
%                 etiquetas_labels_predichas_vector(37,1)=("N/A");
%                 etiquetas_labels_predichas_vector(38,1)=("N/A");
%                 etiquetas_labels_predichas_vector(39,1)=("N/A");
%                 etiquetas_labels_predichas_vector(40,1)=("N/A");
%                 etiquetas_labels_predichas_vector(41,1)=("N/A");
%                 etiquetas_labels_predichas_vector(42,1)=("N/A");
%                 etiquetas_labels_predichas_matrix(:,conta)=etiquetas_labels_predichas_vector;
%             elseif var1(1,1) == 37
%                 etiquetas_labels_predichas_vector(38,1)=("N/A");
%                 etiquetas_labels_predichas_vector(39,1)=("N/A");
%                 etiquetas_labels_predichas_vector(40,1)=("N/A");
%                 etiquetas_labels_predichas_vector(41,1)=("N/A");
%                 etiquetas_labels_predichas_vector(42,1)=("N/A");
%                 etiquetas_labels_predichas_matrix(:,conta)=etiquetas_labels_predichas_vector;
%             elseif var1(1,1) == 38
%                 etiquetas_labels_predichas_vector(39,1)=("N/A");
%                 etiquetas_labels_predichas_vector(40,1)=("N/A");
%                 etiquetas_labels_predichas_vector(41,1)=("N/A");
%                 etiquetas_labels_predichas_vector(42,1)=("N/A");
%                 etiquetas_labels_predichas_matrix(:,conta)=etiquetas_labels_predichas_vector;
%             elseif var1(1,1) == 39
%                 etiquetas_labels_predichas_vector(40,1)=("N/A");
%                 etiquetas_labels_predichas_vector(41,1)=("N/A");
%                 etiquetas_labels_predichas_vector(42,1)=("N/A");
%                 etiquetas_labels_predichas_matrix(:,conta)=etiquetas_labels_predichas_vector;
%             elseif var1(1,1) == 40
%                 etiquetas_labels_predichas_vector(41,1)=("N/A");
%                 etiquetas_labels_predichas_vector(42,1)=("N/A");
%                 etiquetas_labels_predichas_matrix(:,conta)=etiquetas_labels_predichas_vector;
%             elseif var1(1,1) == 41
%                 etiquetas_labels_predichas_vector(42,1)=("N/A");
%                 etiquetas_labels_predichas_matrix(:,conta)=etiquetas_labels_predichas_vector;
%             end
            assignin('base','etiquetas_labels_predichas_matrix',etiquetas_labels_predichas_matrix);
            %disp(etiquetas_labels_predichas_matrix)
            
            etiquetas_GT_vector(1,conta)=string(gestureName_GT); %
            %disp(gestureName_GT)
            assignin('base','etiquetas_GT_vector',etiquetas_GT_vector);
            disp(etiquetas_GT_vector)
            %disp(etiquetas_labels_predichas_matrix)
            
            conta=conta+1;
            %disp(conta)
            %disp('etiquetas_labels_predichas_vector_without_NoGesture');
            %disp(etiquetas_labels_predichas_vector_without_NoGesture); %[N,1] %vector Full
            assignin('base','etiquetas_labels_predichas_vector_without_NoGesture',etiquetas_labels_predichas_vector_without_NoGesture);
            %var2=size(etiquetas_labels_predichas_vector_without_NoGesture)
            %etiquetas_labels_predichas_matrix_without_NoGesture(:,conta)=etiquetas_labels_predichas_vector_without_NoGesture;
            
            
            
            %disp('etiquetas_labels_predichas_vector_simplif');
            %disp(etiquetas_labels_predichas_vector_simplif);    % [1,N]  ok listo
            assignin('base','etiquetas_labels_predichas_vector_simplif',etiquetas_labels_predichas_vector_simplif);
            %size(etiquetas_labels_predichas_vector_simplif)
            
            %disp('ProcessingTimes_vector');
            %disp(ProcessingTimes_vector);    %[1,N] ok listo
            assignin('base','ProcessingTimes_vector',ProcessingTimes_vector);
            %size(ProcessingTimes_vector)
            
            %disp('TimePoints_vector');
            %disp(TimePoints_vector);         %[1,N] ok listo
            assignin('base','TimePoints_vector',TimePoints_vector);
            %size(TimePoints_vector)
            
            %             disp('class_result');
            %             disp(class_result);              %[1,1] ok listo
            assignin('base','class_result',class_result);
            %size(class_result)
            %------------------------------------------------------------------
            
            %---  POST - Processing: elimino etiquetas espuria usando la
            %moda diferente de no gesto para crear vector de resultados que
            %va a la etaoa de reconocimiento
            post_processing_result_vector_lables=etiquetas_labels_predichas_vector_simplif;
            dim_vect=size(etiquetas_labels_predichas_vector_simplif);
            for i=1:dim_vect(1,2)
                if etiquetas_labels_predichas_vector_simplif(1,i) ~= class_result && etiquetas_labels_predichas_vector_simplif(1,i) ~= "noGesture"
                    post_processing_result_vector_lables(1,i)=class_result;
                else
                end  
            end
            assignin('base','post_processing_result_vector_lables',post_processing_result_vector_lables);
            %-------------------------------------------------------------
            
            
            disp('Eval Recognition');
            % GROUND TRUTH (no depende del modelo)------------
            repInfo.gestureName =  gestureName_GT; % OK -----  categorical({'waveIn'});   %CAMBIAR - poner etiqueta de muestra de se?al
            assignin('base','gestureName_GT',gestureName_GT);
            repInfo.groundTruth = groundTruth_GT; %   REV -----
            assignin('base','groundTruth_GT',groundTruth_GT);
            %repInfo.groundTruth = false(1, 1000);   %Each_complete_signal;           %false(1, 1000);            %CAMBIAR
            %repInfo.groundTruth(800:1600) = true;   %CAMBIAR (64datos*40ventanas)
            
            %plot(repInfo.groundTruth)
            
            % PREDICCION--------------------------------------
            
            if post_processing == true
                response.vectorOfLabels = categorical(post_processing_result_vector_lables); % OK ----- [1,N] % categorical(etiquetas_labels_predichas_vector_simplif); % %CAMBIAR
            else
                response.vectorOfLabels = categorical(etiquetas_labels_predichas_vector_simplif); % OK ----- [1,N] % categorical(etiquetas_labels_predichas_vector_simplif); % %CAMBIAR
            end
            
            %response.vectorOfLabels = categorical(etiquetas_labels_predichas_vector_simplif); % OK ----- [1,N] % categorical(etiquetas_labels_predichas_vector_simplif); % %CAMBIAR
            response.vectorOfTimePoints = TimePoints_vector; % OK -----  [40 200 400 600 800 999]; %1xw double  TimePoints_vector                %CAMBIAR
            % tiempo de procesamiento
            response.vectorOfProcessingTimes = ProcessingTimes_vector; % OK -----[0.1 0.1 0.1 0.1 0.1 0.1]; % ProcessingTimes_vector'; % [0.1 0.1 0.1 0.1 0.1 0.1]; % 1xw double                                    %CAMBIAR
            response.class =  categorical(class_result); % OK ----- categorical({'waveIn'});                %aqui tengo que usar la moda probablemente           %CAMBIAR
            
            %-----------------------------------------------
            %r1 = 1;
            try
                r1 = evalRecognition(repInfo, response);
            catch
                warning('EL vector de predicciones esta compuesto por una misma etiqueta -> Func Eval Recog no funciona');
                r1.recogResult=0; fin_del_juego=1; 
                if gestureName_GT==response.class
                    r1.classResult=1;
                else
                    r1.classResult=0;
                end
                    
            end
            
            %assignin('base','r1',r1);
            
            if isempty(r1.recogResult) && fin_del_juego==1
                %Asigno recompensa en base al resultado de reconocimiento
                %disp('lazo1')
                %esto comentar si se requiere, solo si es no gesture se tiene esto
                %                 if fin_del_juego==1 && gestureName_GT==categorical({'noGesture'}) && class_result~="noGesture" %numIteration == maxIterationsAllowed % reward == -10  end the game - lose
                %                     %disp('lazo1-lost')
                %                     resultGame = 'lost';
                %                     disp('lost')
                %                     gameOn = false;
                %                     reward = -10;
                %                     % Suma_aciertos >= 30 &&
                %                 elseif  fin_del_juego==1 && gestureName_GT==categorical({'noGesture'}) && class_result=="noGesture" % numIteration == maxIterationsAllowed % eward == +10   end the game - win
                %                     %disp('lazo1-won')
                %                     resultGame = 'won ';
                %                     disp('won')
                %                     countWins = countWins + 1;
                %                     gameOn = false;
                %                     reward = +10;
                %
                %                 end
                
            else
                %disp('lazo2')
                if  r1.recogResult~=1 && fin_del_juego==1 %numIteration == maxIterationsAllowed % reward == -10  end the game - lose
                    resultGame = 'lost';
                    disp(resultGame)
                    gameOn = false;
                    countLoses = countLoses +1;
                    reward = -10;
                    % Suma_aciertos >= 30 &&
                elseif  r1.recogResult==1 && fin_del_juego==1 % numIteration == maxIterationsAllowed % eward == +10   end the game - win
                    resultGame = 'won ';
                    disp(resultGame)
                    countWins = countWins + 1;
                    gameOn = false;
                    reward = +10;
                    
                    
                end
                
            end
            score = score + reward;
            disp(score)
            
        end
        
        % Cumulative reward 
        cumulativeGameReward = cumulativeGameReward + reward;
        
        % Cumulative reward so far for the current episode
%         cumulativeIterationReward = cumulativeIterationReward + cumulativeGameReward; 
%         %cumulativeIterationReward = cumulativeIterationReward + reward;
        
        % Updating the state
        state = new_state_full; %new_state;
        
        
        % state = new_state;
        
        
        
        
    end
    
%     score = score + reward;  %reward=result;  score = score + reward; 
    %pause(1);
end


n1=size(class_result_vector);

for nk=1:n1(1,2)
    if etiquetas_GT_vector(1,nk)==class_result_vector(1,nk) % etiquetas_labels_predichas_matrix(1,nk)
        number_classif_ok=number_classif_ok+1;
    else
        number_classif_failed=number_classif_failed+1;
    end
end
disp('TESTING RESULTS')
fprintf('Cumulative reward = %d/%d\n', score, numEpochs);
%fprintf('Count Wins = %d --- Count Loses = %d \n', countWins, countLoses);
fprintf('Count Wins Recog = %d --- Count Loses recog = %d --- Total Recog = %d  \n', countWins, countLoses,countWins+countLoses);
fprintf('Count Wins Classif = %d --- Count Loses classig = %d --- Total Classif = %d \n', number_classif_ok, number_classif_failed,number_classif_ok+number_classif_failed);
fprintf('Count Wins per window = %d --- Count Loses per window = %d --- Total Classif per window = %d \n', countWins2, countLoses2,countWins2+countLoses2 );

      assignin('base','etiquetas_labels_predichas_matrixTEST',etiquetas_labels_predichas_matrix);
      %cell2csv('new_cell2csvTEST.csv', etiquetas_labels_predichas_matrix)
      %cell2csv('gestureName_GT_TEST.csv', etiquetas_GT_vector)
      Full_test_data=[etiquetas_labels_predichas_matrix;etiquetas_GT_vector;class_result_vector];
      assignin('base','Full_test_data',Full_test_data);
      %cell2csv('Full_test_data.csv', Full_test_data)

%       s1 = 'Full_test_dataTRAINING_';
%       %s2   = '2';
%       s3 = '.csv';
%       s = strcat(s1,s2,s3);
      sa   = evalin('base', 's');
      cell2csv(sa, Full_test_data)
      
end

%end ok