function [s]=Robotica_ProjectSerialOpen(Puerto)
%Robotica_ProjectSerialOpen: Funcion Para Abrir el Puerto Serie en el puerto requerido. [Serial]=Robotica_ProjectSerialOpen(Puerto)  
    delete(instrfind({'Port'},{Puerto}));
    s = serial(Puerto,'BaudRate',9600,'Terminator','CR/LF');
    warning('off','MATLAB:serial:fscanf:unsuccessfulRead');
    fopen(s);
end