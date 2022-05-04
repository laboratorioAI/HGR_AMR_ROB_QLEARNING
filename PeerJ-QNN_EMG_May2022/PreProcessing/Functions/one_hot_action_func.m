function [action_one_hot]=one_hot_action_func(action)

% el estado "state" de las EMG siempre tiene 40 features

% Si 'num_prev_actions=0', entonces el codigo usa solo las 40 features EMG

% Si 'num_prev_actions=N', el codigo usa 40 features EMG + N features de
% la/las N acciones anterior/es (cada accion entre 1 a 6 se guarda en un
% one-hot vector_

% La accion inicial se considera como vector de zeros, y luego se va
% actualizando

if action==1
    action_one_hot=[1 0 0 0 0 0];
elseif action==2
    action_one_hot=[0 1 0 0 0 0];
elseif action==3
    action_one_hot=[0 0 1 0 0 0];
elseif action==4
    action_one_hot=[0 0 0 1 0 0];
elseif action==5
    action_one_hot=[0 0 0 0 1 0];
elseif action==6
    action_one_hot=[0 0 0 0 0 1];
end

end

