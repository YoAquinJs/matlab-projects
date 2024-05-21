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
polinomio = polyfit(y_regresion, x_regresion, 3);

figure(1), clf, hold on
axis equal

ds = 0.5;
grosorPista = 10;
limite_superior_y = max(y_regresion);
limite_inferior_y = min(y_regresion);
y_grafica = limite_inferior_y:ds:limite_superior_y;
x_grafica = zeros(length(y_grafica), 1);

syms y;
funcion = polinomio(1)*y^3 + polinomio(2)*y^2 + polinomio(3)*y + polinomio(4);
derivada_funcion = (3*polinomio(1))*y^2 + (2*polinomio(2))*y + polinomio(3);
tangentes_pendientes = [];
tangentes_y = [];
tangentes_x = [];

limiteCurvatura = 0.1;
for k = 1:1:length(y_grafica)
    x_grafica(k) = subs(funcion, y, y_grafica(k));
    derivada_y = subs(derivada_funcion, y, y_grafica(k));
    if(derivada_y <= limiteCurvatura && derivada_y>= -limiteCurvatura)
        tangentes_pendientes = [tangentes_pendientes; derivada_y];
        tangentes_y = [tangentes_y; y_grafica(k)];
        tangentes_x = [tangentes_x; x_grafica(k)];
    end
end

figure(1);
p = plot(y_grafica, x_grafica, "Color", "k", "LineWidth", grosorPista);
grid on
xlabel("y (m)", FontSize=12)
ylabel("x (m)", FontSize=12)
title(['Curva ' num2str(curva) ' Tangentes'])
disp(length(tangentes_pendientes))

ds1 = 4;
largoTangente = 100;
for k = 1:4:length(tangentes_pendientes)

    valores_recta_y_negativa = tangentes_y(k)-largoTangente:ds1:tangentes_y(k);
    valores_recta_x_negativa = zeros(length(valores_recta_y_negativa), 1);
    aux_x = tangentes_x(k);

    for j = length(valores_recta_y_negativa):-1:1
        aux_x = aux_x - tangentes_pendientes(k)*ds1;
        valores_recta_x_negativa(j) = aux_x;
    end


    valores_recta_y_positivo = tangentes_y(k):ds1:tangentes_y(k) + largoTangente;
    valores_recta_x_positivo = zeros(length(valores_recta_y_positivo), 1);
    aux_x = tangentes_x(k);
    
    for j = 1:1:length(valores_recta_y_positivo)
        aux_x = aux_x + tangentes_pendientes(k)*ds1;
        valores_recta_x_positivo(j) = aux_x;
    end
    
    plot(valores_recta_y_positivo, valores_recta_x_positivo, "y")
    plot(valores_recta_y_negativa, valores_recta_x_negativa, "y")
end

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
