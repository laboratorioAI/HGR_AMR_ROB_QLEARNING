
%----------------------------------------------------------------------------------------------------------
%------- ESCUELA POLITECNICA NACIONAL - LABORATORIO DE INTELIGENCIA Y VISION ARTIFICIAL ALAN TURING -------
%----------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------
%
% SISTEMA HGR de 5 gestos de la mano - EMG - Myo - modelo usuario específico - sin toolbox de matlab
%
% 1. En carpeta C:\Users\juanp\Desktop\Respaldos Códigos\1.QNN_EMG_RandomData_7ok_var_wind_size-NoToolbox-Ene2021\Data\Specific
% poner usuario que se desea procesar.
%
% 2. Correr archivo QNN_train_emg_Exp_Replay_SxWx_1.m para entrenar
%
% 3. Correr archivo QNN_test_Exp_Replay_SxWx_1.m para obtener archivo 

% Nota: Dataset de entrenamiento y de testeo contienen 306 usuarios c/u. Cada usuario tiene 5
% gestos y el gesto de relajación (no gessto). Para cada gesto se tienen
% 25 repeticiones. Durante el entrenamiento, los datos de cada gesto se
% envian al agente de manera alternada, un gesto de cada clase, hasta
% terminar con los datos de entrenamiento.
% Se puede cambiar el tamaño de la ventana, stride, y del numero de epocas que todos los datos 
% de un usuario se pasan por el algoritmo.
%----------------------------------------------------------------------

function QNN_train_emg_Exp_Replay()
clc;
close all;
warning off all;

% Type of the world of the game: deterministic, randAgent, and randWord
typeWorld = 'randWorld';

% Creating an artificial neural network for Q-learning
addpath('Multivariate Regression Neural Network Toolbox');
addpath('Visualization Toolbox');
addpath('QNN Toolbox');
addpath('Gridworld Toolbox');
addpath(genpath('FeatureExtraction'));
addpath(genpath('Data'));
addpath(genpath('PreProcessing'));
addpath(genpath('testingJSON'));
addpath(genpath('trainingJSON'));

%Opcion = 1 (40 features)
%Opcion = 2 (46 features) - 1 vector one hot encoding whith previous action
%Opcion = 3 (52 features) - 2 vectors one hot encoding whith previous actions

num_prev_actions=3;    %  CAMBIAR - 0 si no quiero acciones previas en vector de caracteristicas ; 1 hasta N CAMBIAR NUMERO DE ACCIONES PREVIAS a considerar
assignin('base','num_prev_actions',num_prev_actions); 

numNeuronsLayers = [40+num_prev_actions*6, 50, 50, 6];              %CAMBIAR [40, 75, 50, 6]; - #clases  [64, 75, 50, 6]
transferFunctions{1} = 'none';
transferFunctions{2} = 'relu';
transferFunctions{3} = 'relu';
transferFunctions{4} = 'purelin';
options.reluThresh = 0;
options.lambda = 0; 

    
% SGD and online learning settings
%Code_0;
%dataPacketSize1   = evalin('base', 'dataPacketSize'); %numero de epocas ahora depende de numero de datos de usuarios en la carpeta
%options.numEpochs = dataPacketSize1; %dataPacketSize; %100000  %REVISAR

%Conversion de JSON a .mat (si es necesario)
root_        = pwd;
data_gtr_dir = horzcat(root_,'\Data\General\training');
data_gts_dir = horzcat(root_,'\Data\General\testing');
data_sts_dir = horzcat(root_,'\Data\Specific');

if length(dir(data_gtr_dir))>2 || length(dir(data_gts_dir))>2 || length(dir(data_sts_dir))>2
    % No Data conversion
    disp('Data conversion already done');
else
    % Data conversion needed
    jsontomat;
end


%if noGestureDetection==on tengo que considerar que el valore de
%RepTraining debe ser rangeValues-25 si rangeValues<150 o tambien
%rangeValues-50 si rangeValues<300. Esto es xq los nogestos ahora no se
%cuentan, y no puedo poner 150 reps si no se tomaran en cuenta las 25 del
%no gesto.
%# determinado de cada clase x muestra, cambiar

assignin('base','Stride',  40);        %CAMBIAR - 20
assignin('base','WindowsSize',  300);   %CAMBIAR - 200
assignin('base','num_replays',     10); %CAMBIAR - minimo 1 -> recommended 10.  Numero de veces que se repite el dataset
RepTraining        = 100;    %100   % uo to 125 numero de muestras que voy a usar en el entrenamiento x cada usuario en la carpeta C:\Users\juanp\Desktop\QNN - EMG - RandomData - Copy\Data\Specific
on  = true;
off = false;

assignin('base','Reward_type',     on);   %on si quiero recompensa -1 x ventana (clasif) y -10 x recog
assignin('base','post_processing',     on);   %on si quiero post procesamiento en vector de etiquetas resultadnte                                          %off si quiero solo recomp -10 x recog 
assignin('base','RepTraining',  RepTraining); 
assignin('base','randomGestures',     off);   %on si quiero leer datos randomicamente
assignin('base','noGestureDetection', off);  %off si no quiero considerar muestras con nogesture - OJO> actualmente el gesto predicho es la moda sin incluir no gesto
%limite superior de rango de muestras a leer
assignin('base','rangeValues', 150);  %up to 300 - rango de muestras PERMITIDO que uso dentro del dataset, del cual tomo "RepTraining" muestras
assignin('base','packetEMG',     on);

rangeDown=26;  %limite inferior de rango de muestras a leer
assignin('base','rangeDown', rangeDown); 
Code_0(rangeDown);
dataPacketSize1     = evalin('base', 'dataPacketSize');

% Esto es nuevo 
%Code_0;
%dataPacketSize1   = evalin('base', 'dataPacketSize');


%RepTraining      = 100;  % CAMBIAR numero de repeticiones por cada usuario (CAMBIAR SEGUN SE REQUIERA - up to 300)  CAMBIAR CAMBIAR CAMBIAR
%assignin('base','RepTraining',RepTraining);
options.numEpochs  = RepTraining*(dataPacketSize1-2);  %numero total de muestras de todos los usuarios

% Momentum update
options.learningRate = 0.033;             % 9e-3  CAMBIAR
options.typeUpdate = 'momentum';
options.momentum = 0.9;
options.initialMomentum = 0.29;
options.numEpochsToIncreaseMomentum = 50; %1000
s2 = '1';                   %CAMBIAR # de EXPERIMENTO
options.miniBatchSize = 30; %CAMBIAR % Size of the minibatch from experience replay

% Window length for data smoothing
options. W = 25;                   

% Q-learning settings
options.gamma = 0.99; % Q-learning parameter
options.epsilon = 0.22; %Initial value of epsilon for the epsilon-greedy exploration
% Fitting the ANN
flagDisplayWorld = false;
tStart = tic;

s1 = 'QNN_Trained_Model_';
assignin('base','s2', s2);    
s3 = '.mat';
s = strcat(s1,s2,s3);

weights = trainQNN_Exp_Replay(numNeuronsLayers, transferFunctions, options, typeWorld, flagDisplayWorld);
elapsedTimeHours = toc(tStart)/3600;
fprintf('\n Elapsed time for training: %3.3f h \n', elapsedTimeHours);
save('QNN_Trained_Model.mat','weights', 'numNeuronsLayers',...
    'transferFunctions', 'options', 'typeWorld', 'flagDisplayWorld');

save(s,'weights', 'numNeuronsLayers',...
    'transferFunctions', 'options', 'typeWorld', 'flagDisplayWorld');

end

