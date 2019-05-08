clc
clear all

A=zeros(5,5);
A(2:4,3)=[1;1;1];
A(4,2)=1;
Inicio=[3,1];
Fin=[3,5];
[ B,Ruta ] = RoboticaProject_Astar(A,Inicio,Fin);

NumNodos=length(Ruta);

NodosXY=zeros(NumNodos,2);

for i=1:NumNodos
    NodosXY(i,1)=Ruta(i).X;
    NodosXY(i,2)=-Ruta(i).Y;
end

NodosXY=flipud(NodosXY);

LadoCelda=100;%mm
NodosXY=100*NodosXY;
NodosXY(:,1)=NodosXY(:,1)-LadoCelda;
NodosXY(:,2)=NodosXY(:,2)+LadoCelda;


t_RotPositiva=zeros((NumNodos-1),1);
t_RotNegativa=zeros((NumNodos-1),1);
t_Avance=zeros((NumNodos-1),1);
th_a=0;
th=0;
th_act=0;
for i=1:(NumNodos-1)
    dx=NodosXY(i+1,1)-NodosXY(i,1);
    dy=NodosXY(i+1,2)-NodosXY(i,2);
    th_a=th_act;
    th_act=atan2d(dy,dx);
    th=th_act-th_a;
    dxy=sqrt((dx^2)+(dy^2));
    
    if th<0
        t_RotPositiva(i)=0;
        t_RotNegativa(i)=uint8(abs(1.5557*th)/2);
    else
        t_RotNegativa(i)=0;
        t_RotPositiva(i)=uint8(abs(1.5557*th)/2);
    end
    
    t_Avance(i)=uint8((2.0512*dxy)/4);
    
    
end

Puerto='COM6';
s=Robotica_ProjectSerialOpen(Puerto);
pause(5);
for i=1:length(t_RotNegativa)    
   pause(1); 
   Robotica_ProjectDataSend(s,t_RotNegativa(i),t_RotPositiva(i),t_Avance(i));
       
%     Robotica_ProjectDataSend(s,0,t_RotPositiva(i),0)
%     pause(1);   
%     Robotica_ProjectDataSend(s,0,0,t_Avance(i))
%     pause(1);   
end

fclose(s);