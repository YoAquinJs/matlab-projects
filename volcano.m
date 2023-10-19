clc
close all
clear all

%TODO para andrey:
%Arreglar el bug de la primera simulacion siendo una linea
%Bug the marco de referencia cuando hay un unico plot
%Poner el area de contacto porfis

global inputUsuario;
inputUsuario = strcmpi(input('Input de usuario (s/n) ', 's'),'s');

global numero_proyectiles;
numero_proyectiles = 10;

if inputUsuario
    numero_proyectiles = input("Numero de proyectiles ");
end

global simulando;
simulando = 0;
global rotacion;
rotacion = false;
%Variables de animacion de rotacion
numFrames = 360;
frame = 1;

%Creacion de una figura para contener todas las graficas
global figure;

global legendEntries;
legendEntries = cell(1, numero_proyectiles);
for k=1:numero_proyectiles
    legendEntries{k} = ['Tiro ' num2str(k)];
end

%Boton para regenerar las simulaciones
botonResimular = uicontrol('Style', 'pushbutton', 'String', 'Simular', ...
    'Position', [10, 10, 70, 30], 'Callback', @(src, event) resimular(src));

%Boton para pausar o ejecutar la animacion de rotacion en el plano
rotationButton = uicontrol('Style', 'pushbutton', 'String', 'Rotar', ...
    'Position', [80, 10, 70, 30], 'Callback', @(src, event) pausarRotacion(src));

%Llama a la simulacion
cla;
simulacion();

%Propiedades del plot
title('Tiros de proyectiles');
legend(legendEntries);
axis equal;
grid on;
xlabel('X-Axis metros');
ylabel('Y-Axis metros');
zlabel('Z-Axis metros');
view(0,30);
datacursormode on;

%Ejecutar mientras la ventana este abierta
while true
    pause(0.1);

    if rotacion
        %Genera una animacion de rotacion cambiando el View del plano
        azimuth = frame;
        elevation = 30;
        view(azimuth, elevation);

        frame = frame + 1;
        if frame > numFrames
            frame = 1;
        end
    end
end

%Funcion para regenerar las simulaciones
function resimular(~)
    global legendEntries;
    global simulando;
    global figure;

    if simulando == 0
        simulando = 1;
        cla;
        simulacion();
        legend(legendEntries);
        datacursormode on;
        simulando = 0;
    end
end

% Callback function to toggle pause/play
function pausarRotacion(src)
    global rotacion;
    rotacion = ~rotacion;
    if rotacion
        set(src, 'String', 'Pausar');
    else
        set(src, 'String', 'Rotar');
    end
end

%Funcion para generar las simulaciones
function simulacion()
    global numero_proyectiles;
    global inputUsuario;
    global figure;

    %Constantes de generacion aleatoria
    angulo_min = 30;
    angulo_max = 60;
    velocidad_min = 30;
    velocidad_max = 100;
    
    %Constantes de la simulacion
    g = 9.81;
    dt = .001;
    
    %Constantes del proyectil
    m = 150;
    area_contacto = 0.194;
    peso = m*g;
    posicionX0 = 0;
    posicionY0 = 0;
    posicionZ0 = 500;

    %Constantes de las condiciones ambientales
    densidad_aire = 1.2;%Kg/m^3

    %Simulacion de n numero de proyectiles
    for n = 1:numero_proyectiles
        disp(['Tiro ' num2str(n)]);
        if inputUsuario
            anguloElev = input("Ingresa el angulo de elevacion ");
            anguloDir = (input("Ingresa el angulo de direccion "));
            velocidad0 = input("Ingresa la velocidad inicial ");
            cd = input("Ingresa la resistencia con el aire ");
        else
            anguloElev = randi([angulo_min, angulo_max]);
            anguloDir = randi([0,359]);
            velocidad0 = randi([velocidad_min, velocidad_max]);
            cd = 1.5;
        end
        B = cd*densidad_aire*area_contacto/2;

        %Buffers
        x = zeros(1,20000);
        y = zeros(1,20000);
        z = ones(1,20000).*-1;
        velX = zeros(1,20000);
        velY = zeros(1,20000);
        velZ = zeros(1,20000);

        %Arreglos de los datos de la simulacion
        x(1) = posicionX0;
        y(1) = posicionY0;
        z(1) = posicionZ0;
        
        %Velocidad Iniciales
        velX(1) = cosd(anguloElev)*velocidad0*cosd(anguloDir);
        velY(1) = cosd(anguloElev)*velocidad0*sind(anguloDir);
        velZ(1) = sind(anguloElev)*velocidad0;
        
        for k=1:length(z)
            %Calculo de la velocidad y posicion usando el metodo de euler
            x(k+1) = x(k) + velX(k)*dt;
            y(k+1) = y(k) + velY(k)*dt;
            z(k+1) = z(k) + velZ(k)*dt;
            velX(k+1) = velX(k) + (-sign(velX(k))*B*(velX(k)^2)/m)*dt;
            velY(k+1) = velY(k) + (-sign(velY(k))*B*(velY(k)^2)/m)*dt;
            velZ(k+1) = velZ(k) + (((-sign(velZ(k))*B*(velZ(k)^2))-peso)/m)*dt;
            %disp([x(k),y(k),z(k)])
        end

        %Simular hasta que el proyectil toque el suelo
        z = z(z >= 0);
        x = x(1:length(z));
        y = y(1:length(z));
        velX = velX(1:length(z));
        velY = velY(1:length(z));
        velZ = velZ(1:length(z));

        %Plot de la grafica
        hold on;
        p = plot3(x,y,z, 'LineWidth', 2);
        %Añade las velocidades instantaneas al Datatip
        p.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Vel X ',velX, '%.2f');
        p.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Vel Y ',velY, '%.2f');
        p.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Vel Z ',velZ, '%.2f');
        %Añade las propiedades iniciales al DataTip
        p.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow(['Tiempo de vuelo ', num2str(length(z)*dt)],[]);
        p.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow(['Alcanze ', num2str(sqrt((x(length(z))^2)+(y(length(z))^2)))],[]);
        p.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow(['Vel Inicial ', num2str(velocidad0)],[]);
        p.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow(['Angulo Elevacion ', num2str(anguloElev)],[]);
        p.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow(['Cd ', num2str(cd)],[]);
        p.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow(['Tiro ', num2str(n)],[]);
        hold off;
    end
end