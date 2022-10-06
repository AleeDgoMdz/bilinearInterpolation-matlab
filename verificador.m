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