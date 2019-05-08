clc
clear all

% A=zeros(5,5);
% A(2:4,3)=[1;1;1];
% A(4,2)=1;
A=zeros(10,10);
A(3:5,4)=1;
A(5:8,9:10)=1;
A(2:4,2:3)=1;
A(6:7,6:7)=1;

Start=[1,1];
End=[10,10];
% 
% Start=uint16(Start);
% End=uint16(End);
% 
% A=ImgObstaculos;
Tamano=size(A);

for i=1:Tamano(1)
    for j=1:Tamano(2)
        if A(i,j)==1
            Obstacles=[i,j];
        end
        H(i,j)=abs((End(1)-i))+ abs((End(2)-j));
    end
end

NumCelda=1;


O=[];

O(1).X=Start(2);
O(1).Y=Start(1);
G_Act=0;
H_Act=H(Start(1),Start(2));
O(1).G=G_Act;
O(1).H=H_Act;
O(1).F=G_Act+H_Act;
O(1).Xdad=[];
O(1).Ydad=[];


while isempty(O)~=1
    %Pick nbest from O
    TamanoO=size(O);
    i_Ok=1;
    Pos_Actual=O(1);
    for i=2:TamanoO(2)

        if O(i).F<Pos_Actual.F
            Pos_Actual=O(i);
            i_Ok=i;
        end
    end

    %Remove nbest from O and add to C
    C(NumCelda)=Pos_Actual;
    O(i_Ok)=[];
    NumCelda=NumCelda+1;
   %If nbest=qgoal, exit
    if Pos_Actual.X==End(2)
        if Pos_Actual.Y==End(1)
            break
        end
    end


    %Expand nbest:for all x E Star(nbest) that are not in C.
    TamanoO=size(O);
    i_Act=Pos_Actual.Y;
    j_Act=Pos_Actual.X;
    NumCandidatos=1;
    O_candidatos=struct([]);


    for i=1:3    
        i_New=i_Act+i-2;
        if i_New>0 && i_New<Tamano(1)
            for j=1:3
                j_New=j_Act+j-2;
                if j_New>0 && j_New<Tamano(2)
                   if isequal([i_New,j_New],[i_Act,j_Act])==0
                       O_candidatos(NumCandidatos).X=j_New;
                       O_candidatos(NumCandidatos).Y=i_New;               
                       if j_New==j_Act || i_New==i_Act
                        G_aux=1;
                       else
                        G_aux=1.4;
                       end
                       O_candidatos(NumCandidatos).G=G_aux;
                       O_candidatos(NumCandidatos).H=H(i_New,j_New);
                       O_candidatos(NumCandidatos).F=G_aux+H(i_New,j_New);
                       O_candidatos(NumCandidatos).Xdad=j_Act;
                       O_candidatos(NumCandidatos).Ydad=i_Act;
                       NumCandidatos=NumCandidatos+1;
                   end
                end
            end
        end
    end

    TamanoO_Aux=size(O_candidatos);

    %Descartamos Candidatos
    CandidatosAceptados=1;

    %Descartamos Celdas Ocupadas
    for i=1:TamanoO_Aux(2)
        x_act=O_candidatos(i).X;
        y_act=O_candidatos(i).Y;
        ocupado=A(y_act,x_act);
        if ocupado~=1
            O_Aceptados1(CandidatosAceptados)=O_candidatos(i);
            CandidatosAceptados=CandidatosAceptados+1;
        end  

    end
    
    %Descartamos los que estan en C  
    CandidatosAceptados=CandidatosAceptados-1;
    TamanoC=size(C);
    TamanoC=TamanoC(2);
    CandidatosAceptados1=1;
    for i=1:CandidatosAceptados
        xAcp=O_Aceptados1(i).X;
        yAcp=O_Aceptados1(i).Y;
        
        for j=1:TamanoC
            xC=C(j).X;
            yC=C(j).Y;
            descarte=isequal([xC,yC],[xAcp,yAcp]); 
            if descarte==1
            break;
            end
        end
        
        if descarte ~= 1
            O_Aceptados(CandidatosAceptados1)=O_Aceptados1(i);
            CandidatosAceptados1=CandidatosAceptados1+1;
        end
        
    end
    
    CandidatosAceptados=CandidatosAceptados1-1;
    TamanoO=size(O);
    Entrada=1;
    %if x E to O

    Presente=0;

    for i=1:CandidatosAceptados
        x_act=O_Aceptados.X;
        y_act=O_Aceptados.Y;
        gDad=Pos_Actual.G;
        xDad=Pos_Actual.X;
        yDad=Pos_Actual.Y; 
        for j=1:TamanoO(2)
            x_o=O.X;
            y_o=O.Y;        
            if isequal([x_o,y_o],[x_act,y_act])
                Presente=1;
                Pos_O=j;

            end
        end

        if Presente==0
            O(TamanoO(2)+Entrada)=O_Aceptados(i);
            O(TamanoO(2)+Entrada).G=O(TamanoO(2)+Entrada).G+gDad;
            O(TamanoO(2)+Entrada).F=O(TamanoO(2)+Entrada).F+gDad;
            Entrada=Entrada+1;
        else
            if x_act==xDad || y_act==yDad
                G_Aux=1;
            else
                G_Aux=1.4;
            end
            G_new=gDad+G_Aux;
            if G_new<O_Aceptados(i).G
               O(Pos_O).Xdad=xDad;
               O(Pos_O).Ydad=yDad;
               O(Pos_O).G=G_new;
               O(Pos_O).F=O(Pos_O).G+O(Pos_O).H;           
            end
        end

    end

    clear O_Aceptados;
    clear O_candidatos;
    
end

Nodos_Ruta=size(C);
Nodos_Ruta=Nodos_Ruta(2);

Nodo_Orden=1;

Flag=0;

xDad=End(2);
yDad=End(1);

while isempty(xDad)~=1
    
    for i=1:Nodos_Ruta
        xAct=C(i).X;
        yAct=C(i).Y;
        if isequal([xAct,yAct],[xDad,yDad])
            Ruta(Nodo_Orden)=C(i);
            xDad=C(i).Xdad;
            yDad=C(i).Ydad;
            Nodo_Orden=Nodo_Orden+1;  
            break;
        end          
    end
    
end

B=A;
B=sym(B);
TamanoRuta=size(Ruta);
TamanoRuta=TamanoRuta(2);

for i=1:TamanoRuta
    xRuta=Ruta(i).X;
    yRuta=Ruta(i).Y;
    disp([xRuta,yRuta])
    Explora=1:TamanoRuta;
    Explora=fliplr(Explora);
    B(yRuta,xRuta)=strcat('R',num2str(Explora(i)));
end
