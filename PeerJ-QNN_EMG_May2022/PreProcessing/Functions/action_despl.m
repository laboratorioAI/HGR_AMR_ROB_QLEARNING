function [state]=action_despl(state,num_prev_actions,action)

% el estado "state" de las EMG siempre tiene 40 features

% Si 'num_prev_actions=0', entonces el codigo usa solo las 40 features EMG

% Si 'num_prev_actions=N', el codigo usa 40 features EMG + N features de
% la/las N acciones anterior/es (cada accion entre 1 a 6 se guarda en un
% one-hot vector_

% La accion inicial se considera como vector de zeros, y luego se va
% actualizando


num_desp_izq=num_prev_actions-1;
vector_a_desplazar_size=6*num_desp_izq;

A1=[1 0 0 0 0 0]; A2=[0 1 0 0 0 0]; A3=[0 0 1 0 0 0]; A4=[0 0 0 1 0 0]; A5=[0 0 0 0 1 0]; A6=[0 0 0 0 0 1];

if num_prev_actions>0 && action==1
    A=state(1:40);         %tomo solo features EMG (40 features)
    if num_prev_actions==1
        B=[];
    elseif num_prev_actions>1
        D=size(state);
        a2=D(1,2);
        a1=D(1,2)-vector_a_desplazar_size+1;
        B=state(a1:a2);   %acciones q voy a dezplazar a{t-1}=a{t}
    end
    state=horzcat(A,B,A1);  %state=[feature_vector,acciones_anteriores,accion_actual]
elseif num_prev_actions>0 && action==2
    A=state(1:40);
    if num_prev_actions==1
        B=[];
    elseif num_prev_actions>1
        D=size(state);
        a2=D(1,2);
        a1=D(1,2)-vector_a_desplazar_size+1;
        B=state(a1:a2);   %acciones q voy a dezplazar a{t-1}=a{t}
    end
    state=horzcat(A,B,A2);  %state=[feature_vector,acciones_anteriores,accion_actual]
elseif num_prev_actions>0 && action==3
    A=state(1:40);
    if num_prev_actions==1
        B=[];
    elseif num_prev_actions>1
        D=size(state);
        a2=D(1,2);
        a1=D(1,2)-vector_a_desplazar_size+1;
        B=state(a1:a2);   %acciones q voy a dezplazar a{t-1}=a{t}
    end
    state=horzcat(A,B,A3);  %state=[feature_vector,acciones_anteriores,accion_actual]
elseif num_prev_actions>0 && action==4
    A=state(1:40);
    if num_prev_actions==1
        B=[];
    elseif num_prev_actions>1
        D=size(state);
        a2=D(1,2);
        a1=D(1,2)-vector_a_desplazar_size+1;
        B=state(a1:a2);   %acciones q voy a dezplazar a{t-1}=a{t}
    end
    state=horzcat(A,B,A4);  %state=[feature_vector,acciones_anteriores,accion_actual]
elseif num_prev_actions>0 && action==5
    A=state(1:40);
    if num_prev_actions==1
        B=[];
    elseif num_prev_actions>1
        D=size(state);
        a2=D(1,2);
        a1=D(1,2)-vector_a_desplazar_size+1;
        B=state(a1:a2);   %acciones q voy a dezplazar a{t-1}=a{t}
    end
    state=horzcat(A,B,A5);  %state=[feature_vector,acciones_anteriores,accion_actual]
elseif num_prev_actions>0 && action==6
    A=state(1:40);
    if num_prev_actions==1
        B=[];
    elseif num_prev_actions>1
        D=size(state);
        a2=D(1,2);
        a1=D(1,2)-vector_a_desplazar_size+1;
        B=state(a1:a2);   %acciones q voy a dezplazar a{t-1}=a{t}
    end
    state=horzcat(A,B,A6);  %state=[feature_vector,acciones_anteriores,accion_actual]
end

end

