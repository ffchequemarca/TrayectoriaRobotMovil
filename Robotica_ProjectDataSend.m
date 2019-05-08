function [ ] = Robotica_ProjectDataSend(Serial,g1,g2,g3)
%Robotica_ProjectDataSend(Serial,Grado1,Grado2,Grado3,Pinza) Envio de datos con
%los angulos que debe tomar el manipulador en un momento dado.
    
    SendData=[g1,g2,g3,0];
    %SendData=char(SendData);
    fwrite(Serial,SendData);
    
end

