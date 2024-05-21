clc
clear
close all

% Ask the user for input
curva = input('Curva 1 o 2: ');

% Check the user input
if curva == 1
    y_regresion = [631.8119595, 379.0871757, 547.5703649, 463.3287703];
    x_regresion = [758.1743514, 842.415946, 808.7193082, 787.6589095];
    porcentajeCurva=1/2;
elseif curva == 2  
    y_regresion = [505.4495676, 926.6575406, 463.3287703, 758.1743514];
    x_regresion = [926.6575406, 884.5367433, 926.6575406, 1053.019933];
    porcentajeCurva=1/3;
else
    error('Ingresar curva 1 o 2.');
end

inclinacion = input('Inclinacion s o n: ', 's');
if strcmp(inclinacion,'s')
    inclinacionStr = '';
    conInclinacion = true;
elseif strcmp(inclinacion,'n')
    inclinacionStr = 'Con Inclinacion';
    conInclinacion = false;
else
    error('Ingresar s o n');
end

figure(1), clf, hold on
axis equal

g = 9.81;
grosorPista = 15;
coeficienteMax1 = 0.85;
coeficienteMax2 = 1.09;
velocidadPropuesta = 110; %Km/h
velocidadPropuesta = velocidadPropuesta/3.6; %m/s
angulo = 8; %Grads
angulo = angulo*pi/180; %Rads
%FCalculo Coeficientes del polinomio
polinomio = polyfit(y_regresion, x_regresion, 3);

ds = 0.5;
limite_superior_y = max(y_regresion);
limite_inferior_y = min(y_regresion);
y_grafica = limite_inferior_y:ds:limite_superior_y;
x_grafica = zeros(length(y_grafica), 1);

syms y;
funcionPista = polinomio(1)*y^3 + polinomio(2)*y^2 + polinomio(3)*y + polinomio(4);
derivada_funcion = (3*polinomio(1))*y^2 + (2*polinomio(2))*y + polinomio(3);
derivada_segunda = (6*polinomio(1))*y + 2*polinomio(2);
coeficientes_friccion = zeros(length(y_grafica));

for k = 1:1:length(y_grafica)
    x_grafica(k) = subs(funcionPista, y, y_grafica(k));
    derivada_y = subs(derivada_funcion, y, y_grafica(k));
    derivada_2_y = subs(derivada_segunda, y, y_grafica(k));
    r = (((derivada_y^2)+1)^(3/2))/(abs(derivada_2_y));
    if conInclinacion
        coeficientes_friccion(k) = ((velocidadPropuesta^2)*cos(angulo) - r*g*sin(angulo))/(r*g*cos(angulo) + (velocidadPropuesta^2)*sin(angulo));
    else
        coeficientes_friccion(k) = (velocidadPropuesta^2)/(r*g);
    end
end

figure(1);
plot(y_grafica, x_grafica, "Color", "k", "LineWidth", grosorPista)
grid on
xlabel("y (m)", FontSize=12)
ylabel("x (m)", FontSize=12)
title(['Curva ' num2str(curva) ' Coeficientes de Friccion'])

linea_verde = animatedline("Color", "g", "LineStyle","-", "LineWidth", 2);
linea_amarilla = animatedline("Color","y", "LineStyle","-", "LineWidth", 2);
linea_roja = animatedline("Color","r", "LineStyle","-", "LineWidth", 2);
for k = 1:1:floor((length(y_grafica))*porcentajeCurva)
    addpoints(linea_verde, y_grafica(k), x_grafica(k))
    drawnow
    if(coeficientes_friccion(k)>coeficienteMax1)
        addpoints(linea_amarilla, y_grafica(k), x_grafica(k))
        drawnow
    end
    if(coeficientes_friccion(k)>=coeficienteMax2)
        addpoints(linea_roja, y_grafica(k), x_grafica(k))
        drawnow
    end
    disp(coeficientes_friccion(k))
end

linea_verde1 = animatedline("Color", "g", "LineStyle","-", "LineWidth", 2);
linea_amarilla1 = animatedline("Color","y", "LineStyle","-", "LineWidth", 2);
linea_roja1 = animatedline("Color","r", "LineStyle","-", "LineWidth", 2);

for k = floor(length(y_grafica)*porcentajeCurva):1:(length(y_grafica))
    addpoints(linea_verde1, y_grafica(k), x_grafica(k))
    drawnow
    if(coeficientes_friccion(k)>coeficienteMax1)
    addpoints(linea_amarilla1, y_grafica(k), x_grafica(k))
    drawnow
    end
    if(coeficientes_friccion(k)>=coeficienteMax2)
    addpoints(linea_roja1, y_grafica(k), x_grafica(k))
    drawnow
    end
end
