clc
clear
close all

curva = input('Curva 1 o 2: ');
if curva == 1    
    y_regresion = [379.0871757, 463.3287703, 547.5703649, 631.8119595];
    x_regresion = [842.415946, 787.6589095, 808.7193082, 758.1743514];
    porcentajeCurva=1/2;

    gradas1 = GenerarGradas(430,765,360);
    grada1x = gradas1.xVals;
    grada1y = gradas1.yVals;

    gradas2 = GenerarGradas(380,820,300);
    grada2x = gradas2.xVals;
    grada2y = gradas2.yVals;

    gradas3 = GenerarGradas(590,790,300);
    grada3x = gradas3.xVals;
    grada3y = gradas3.yVals;

    gradas4 = GenerarGradas(520,850,360);
    grada4x = gradas4.xVals;
    grada4y = gradas4.yVals;
elseif curva == 2  
    y_regresion = [463.3287703, 505.4495676, 758.1743514 926.6575406];
    x_regresion = [926.6575406, 926.6575406, 1053.019933 884.5367433];
    porcentajeCurva=1/3;

    gradas1 = GenerarGradas(445,900,360);
    grada1x = gradas1.xVals;
    grada1y = gradas1.yVals;

    gradas2 = GenerarGradas(630,1020,-160);
    grada2x = gradas2.xVals;
    grada2y = gradas2.yVals;
    
    gradas3 = GenerarGradas(710,975,-160);
    grada3x = gradas3.xVals;
    grada3y = gradas3.yVals;

    gradas4 = GenerarGradas(725,1090,360);
    grada4x = gradas4.xVals;
    grada4y = gradas4.yVals;
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

g = 9.81; %m/s^2
masa = 1200; %Kg
grosorPista = 15;
coeficienteFric=1.08;
velocidad_propuesta = 120; %Km/h
velocidad_propuesta = velocidad_propuesta/3.6; %m/s
angulo = 5; %Grads
angulo = angulo*pi/180; %Rads
polinomio = polyfit(y_regresion, x_regresion, 3);

ds = 5;
limite_superior_y = max(y_regresion);
limite_inferior_y = min(y_regresion);
y_grafica = limite_inferior_y:ds:limite_superior_y;
x_grafica = zeros(length(y_grafica), 1);

syms y;
funcion = polinomio(1)*y^3 + polinomio(2)*y^2 + polinomio(3)*y + polinomio(4);
derivada_funcion = (3*polinomio(1))*y^2 + (2*polinomio(2))*y + polinomio(3);
derivada_segunda = (6*polinomio(1))*y + 2*polinomio(2);
velocidades = zeros(length(y_grafica));

for k = 1:1:length(y_grafica)
    x_grafica(k) = subs(funcion, y, y_grafica(k));
    derivada_y = subs(derivada_funcion, y, y_grafica(k));
    derivada_2_y = subs(derivada_segunda, y, y_grafica(k));
    radio = (((derivada_y^2)+1)^(3/2))/(abs(derivada_2_y));
    
    if conInclinacion
        velocidades(k) = (radio*g*((sin(angulo) + coeficienteFric*cos(angulo))/(cos(angulo) - coeficienteFric*sin(angulo))))^(1/2);
    else
        velocidades(k) = (radio*g*coeficienteFric)^(1/2);
    end
end

distanciaTotal = 0;
if conInclinacion
    fuerzaFric = masa*g*coeficienteFric/((cos(angulo)-sin(angulo)*coeficienteFric));
else
    fuerzaFric = masa*g*coeficienteFric;
end

figure(1);
plot(y_grafica, x_grafica, "Color", "k", "LineWidth", grosorPista);
grid on
xlabel("y (m)", FontSize=12)
ylabel("x (m)", FontSize=12)
title(['Curva ' num2str(curva) ' Velocidades ' inclinacionStr])

linea_verde = animatedline("Color", "g", "LineStyle","-", "LineWidth", 2);
linea_amarilla = animatedline("Color","r", "LineStyle","-", "LineWidth", 2);
linea_verde1 = animatedline("Color", "g", "LineStyle","-", "LineWidth", 2);
linea_amarilla1 = animatedline("Color","r", "LineStyle","-", "LineWidth", 2);

linea_amarilla11 = animatedline("Color","y", "LineStyle","-", "LineWidth", 2);
linea_amarilla12 = animatedline("Color","y", "LineStyle","-", "LineWidth", 2);



for k = 1:1:floor((length(y_grafica))*porcentajeCurva)-1
    addpoints(linea_verde, y_grafica(k), x_grafica(k))
    drawnow
    if(velocidades(k)<velocidad_propuesta) && conInclinacion == false
        addpoints(linea_amarilla, y_grafica(k), x_grafica(k))
        drawnow
    elseif(velocidades(k)<velocidad_propuesta) && conInclinacion == true
        addpoints(linea_amarilla11, y_grafica(k), x_grafica(k))
        drawnow
    end

    distanciaTotal = distanciaTotal + sqrt(((x_grafica(k+1)-x_grafica(k))^2) + ((y_grafica(k+1)-y_grafica(k))^2));
end

for k = floor(length(y_grafica)*porcentajeCurva):1:length(y_grafica)-1
    addpoints(linea_verde1, y_grafica(k), x_grafica(k))
    drawnow
    if(velocidades(k)<velocidad_propuesta) && conInclinacion == false
        addpoints(linea_amarilla1, y_grafica(k), x_grafica(k))
        drawnow
    elseif(velocidades(k)<velocidad_propuesta) && conInclinacion == true
        addpoints(linea_amarilla12, y_grafica(k), x_grafica(k))
        drawnow
    end

    distanciaTotal = distanciaTotal + sqrt(((x_grafica(k+1)-x_grafica(k))^2) + ((y_grafica(k+1)-y_grafica(k))^2));
end

disp(['Distancia Total ' num2str(distanciaTotal) ' m'])
disp(['Fuerza Friccion ' num2str(fuerzaFric) ' m'])
disp(['Calor Total ' num2str(distanciaTotal*fuerzaFric) ' J'])

lineaGradas1 = animatedline("Color","g", "LineStyle","-", "LineWidth", 2);
addpoints(lineaGradas1,grada1x,grada1y);
lineaGradas2 = animatedline("Color","g", "LineStyle","-", "LineWidth", 2);
addpoints(lineaGradas2,grada2x,grada2y);
lineaGradas3 = animatedline("Color","g", "LineStyle","-", "LineWidth", 2);
addpoints(lineaGradas3,grada3x,grada3y);
lineaGradas4 = animatedline("Color","g", "LineStyle","-", "LineWidth", 2);
addpoints(lineaGradas4,grada4x,grada4y);

function gradas = GenerarGradas(x1,y1,angle)
    anchoGradas = 80;
    profundidadGradas = 20;

    x2=x1+(anchoGradas*cosd(angle));
    y2=y1+(anchoGradas*sind(angle));
    
    theta = 270+angle;
    gradas.xVals = [x1,x2,x2+(profundidadGradas*cosd(theta)),x1+(profundidadGradas*cosd(theta)),x1];
    gradas.yVals = [y1,y2,y2+(profundidadGradas*sind(theta)),y1+(profundidadGradas*sind(theta)),y1];
end
