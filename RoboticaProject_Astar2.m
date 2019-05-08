clear all
clc


A=zeros(10,10);
A(3:5,4)=1;
A(5:8,9:10)=1;
A(2:4,2:3)=1;
A(6:7,6:7)=1;
A(2,2)=1;

Start=[10,10];
End=[1,1];

Tamano=size(A);

for i=1:Tamano(1)
    for j=1:Tamano(2)
        if A(i,j)==1
            Obstacles=[i,j];
        end
        H(i,j)=abs((End(1)-i))+ abs((End(2)-j));
    end
end

NodoC=0;

O=struct;

O(1).X=Start(2);
O(1).Y=Start(1);
G_Act=0;
H_Act=H(Start(1),Start(2));
O(1).G=G_Act;
O(1).H=H_Act;
O(1).F=G_Act+H_Act;
O(1).Xdad=0;
O(1).Ydad=0;

C=struct('X',[],'Y',[],'G',[],'H',[],'F',[],'Xdad',[],'Ydad',[]);

while isempty(O)~=1
%Selecciona el Mejor O con F minima

sizeO=length(O);
F_Aux=zeros(1,sizeO);

for i=1:sizeO
    F_Aux(i)=O(i).F;
end
Fmin=min(F_Aux);
Pos_Min=find(F_Aux==Fmin);
Pos_Min=Pos_Min(1);

%Remover Nbest de O y Pasarlo a C
NodoC=NodoC+1;
C(NodoC)=O(Pos_Min);
Pos_Actual=O(Pos_Min);
O(Pos_Min)=[];

%If nbest=qgoal, exit
if Pos_Actual.X==End(2)
   if Pos_Actual.Y==End(1)
       break;
   end
end

%Ingresar a O todos los nodos aledaños que no esten presentes en C.

xy_mtrx=zeros(9,2);
x_vector=(Pos_Actual.X-1):1:(Pos_Actual.X+1);
y_vector=(Pos_Actual.Y-1):1:(Pos_Actual.Y+1);
xy_mtrx(:,1)=[x_vector';x_vector';x_vector'];
xy_mtrx(1:3,2)=y_vector(1);
xy_mtrx(4:6,2)=y_vector(2);
xy_mtrx(7:9,2)=y_vector(3);

Descartar=[find(xy_mtrx(:,1)<1);find(xy_mtrx(:,2)<1)];
Descartar=[Descartar;find(xy_mtrx(:,1)>Tamano(2));find(xy_mtrx(:,2)>Tamano(1))];

%Descartar Nodos Presentes en C;
sizeC=size(C);
sizeC=sizeC(2);

for i=1:length(C)
    logical_aux=xy_mtrx(:,1)==C(i).X & xy_mtrx(:,2)==C(i).Y;
    Descartar=[Descartar;find(logical_aux==1)];
end

%Descartar Nodos Ocupados;
[y_aux,x_aux]=find(A==1);
xy_aux=[x_aux,y_aux];
sizeXYbar=size(xy_aux);

for i=1:sizeXYbar(1)
    logical_aux=xy_mtrx(:,1)==xy_aux(i,1) & xy_mtrx(:,2)==xy_aux(i,2);
    Descartar=[Descartar;find(logical_aux==1)];
end
Descartar=unique(Descartar,'stable');
Descartar=Descartar';
xy_mtrx(Descartar,:)=[];

Oactualizar=[];
O_act=[];

%Actualizar O
for i=1:length(O)
    logical_aux=xy_mtrx(:,1)==O(i).X & xy_mtrx(:,2)==O(i).Y;
    Oactualizar=find(logical_aux==1);
    
    if isempty(Oactualizar)~=1
        
       if xy_mtrx(Oactualizar,1)==Pos_Actual.X || xy_mtrx(Oactualizar,2)==Pos_Actual.Y
          G_Aux=1;
       else
           G_Aux=1.4;
       end
       G_new=Pos_Actual.G+G_Aux;
       if G_new<O(i).G
          O(i).Xdad=Pos_Actual.X;
          O(i).Ydad=Pos_Actual.Y;
          O(i).G=G_new;
          O(i).F=O(i).G+O(i).H;           
       end               
    end
    
    O_act=[O_act,Oactualizar];    
end

%Añadir A O
xy_mtrx(O_act,:)=[];

sizeXYmtrx=size(xy_mtrx);

for i=1:sizeXYmtrx(1)
    sizeO=length(O);
    if xy_mtrx(i,1)==Pos_Actual.X || xy_mtrx(i,2)==Pos_Actual.Y
        G_Aux=1;
    else
        G_Aux=1.4;
    end
    O(sizeO+1)=struct('X',xy_mtrx(i,1),'Y',xy_mtrx(i,2),'G',G_Aux,'H',H(xy_mtrx(i,2),xy_mtrx(i,1)),'F',(H(xy_mtrx(i,2),xy_mtrx(i,1))+G_Aux),'Xdad',Pos_Actual.X,'Ydad',Pos_Actual.Y);
end

end

CloseList=zeros(length(C),2);
CloseListDad=zeros(length(C),2);
for i=1:length(C)
    CloseList(i,:)=[C(i).X,C(i).Y];
    CloseListDad(i,:)=[C(i).Xdad,C(i).Ydad];
end




















