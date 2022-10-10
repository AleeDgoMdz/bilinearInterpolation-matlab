datos = ncread("mensuales/promedio_2005.nc","mean");
matrizoriginal = load("salidas1_/precipInterp_2005.mat","interYear").interYear;

%Obtencion xgrid y ygrid (arrays) para generar la malla a interpolar
 xgrid = -118.3651143520000062:0.018: -86.703114352000000;
 ygrid =  14.5386535700000010 :0.018:  32.7186535700000007;
%Generacion de los ejes de la malla (x,y matrices)
[x,y]= ndgrid(xgrid,ygrid);
%Lectura del raster para cortar
[A,R] = readgeoraster("mx_2000.tif");
A = flipud(A); %acomodo de la matriz
A = double(A');
A = change(A,'==',0,NaN);


%verificacion del promedio para el mes de agosto 2009

%obtencion manual
inicio = 0;
for i=1:8
    inicio= inicio+ max(calendar(2010,i),[],"all") ;
end
fin = inicio+max(calendar(2005,9),[],"all");
datosAgosto = matrizoriginal(:,:,inicio+1:fin); 
meanAgosto= mean(datosAgosto,3); %esta linea no se modifica
meanAgosto = meanAgosto.*A;

%obtencion promedio generado con script
meanAgostoS= datos(:,:,9);

%comparacion de las matrices
a = mean(meanAgostoS,"all",'omitnan');
b = mean(meanAgosto,"all",'omitnan');
c = a==b

%-------verificacion de la generacion correcta de netcdf mensuales
net = ncread("monthlyMean/promedio_5.nc","mean");
anioPrueba = ncread("mensuales/promedio_1970.nc","mean");

a = mean(net(:,:,10),"all","omitnan");
b = mean(anioPrueba(:,:,5),"all","omitnan");
c = a==b

%--verificacion de la existencia (o no) de valores negativos
listfiles = dir("meanMensual/*.mat");
inicio =85;
fin = 142;
for file=inicio:fin
    path = strcat("datos/",listfiles(file).name);
    precipData = ncread(path,"PRECIP");
    logical = precipData(:,:)>=0 | isnan(precipData);
    result = mean(logical,"all");
    if result ==1
        disp(strcat("no negativos----",listfiles(file).name));
    else
        disp(strcat("SI NEGATIVOS----",listfiles(file).name),"------");
    end
end



