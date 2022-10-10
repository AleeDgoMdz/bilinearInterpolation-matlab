%graficacion de la preicipitacion de un anio

datosvc = load("meanMensual/meanMensual_2000.mat").finales;
datosl = load("meanMensual/meanMensualb_2000.mat").finales;

%Obtencion xgrid y ygrid (arrays) para generar la malla a interpolar
xgrid = -118.3651143520000062:0.018: -86.703114352000000;
ygrid =  14.5386535700000010 :0.018:  32.7186535700000007;
%Generacion de los ejes de la malla (x,y matrices)
[x,y]= ndgrid(xgrid,ygrid);

promediovc = mean(datosl,[1 2],"omitnan");
promediovc = permute(promediovc,[3 2 1]);
promediol = mean(datosl,[1 2],"omitnan");
promediol = permute(promediol,[3 2 1]);

%generacion de campos
meses =categorical({'Ene', 'Feb', 'Mar', 'Abr', 'May' ,'jun', 'Jul', 'Agos' ,'Sept', 'Oct', 'Nov', 'Dic'});
meses = reordercats(meses,{'Ene', 'Feb', 'Mar', 'Abr', 'May' ,'jun', 'Jul', 'Agos' ,'Sept', 'Oct', 'Nov', 'Dic'});


matcomparacion = [promediovc promediol];
b2= bar(meses,matcomparacion);
xtip1 = b2(1).XEndPoints;
ytip1 = b2(1).YEndPoints;
labels1 = string(b2(1).YData);
text(xtip1,ytip1,labels1,'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',6)
xtip2 = b2(2).XEndPoints;
ytip2 = b2(2).YEndPoints;
labels2 = string(b2(2).YData);
text(xtip2,ytip2,labels2,'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',6)





grafica = bar(meses,promedio);
xtip = grafica.XEndPoints;
ytip = grafica.YEndPoints;
labels = string(grafica.YData);
text(xtip,ytip,labels,'HorizontalAlignment','center','VerticalAlignment','bottom')


%generacion de los mapas promedio anual

anuall= load("interpDiarias/interpb_2000.mat").interYear;
anualvc= load("interpDiarias/interp_2000.mat").interYear;
meanAnuall = mean(anuall,3);
meanAnualvc = mean(anualvc,3);
figure 
pcolor(x,y,meanAnualvc)
shading flat, colorbar

figure 
pcolor(x,y,meanAnuall)
shading flat, colorbar

%Generacion de los mapas promedio de junio
figure 
pcolor(x,y,datosvc(:,:,6))
shading flat, colorbar

figure 
pcolor(x,y,datosl(:,:,6))
shading flat, colorbar



%verificacion de existencia de datos negativos
% completos = load("interpDiarias/interpb_2000.mat").interYear;
% for i=1:366
%     logical = completos(:,:,i)>=0 | isnan(completos(:,:,i));
%     result = mean(logical,"all");
%     if result ==1
%         disp(strcat("no negativos----",num2str(i)));
%     else
%         disp(strcat("SI NEGATIVOS----",num2str(i),"------"));
%     end
% end