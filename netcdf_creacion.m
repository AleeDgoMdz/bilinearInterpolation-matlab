listdata = dir("salidas/*.mat");
[ndata,~] = size(listdata);

for file=1:ndata
    dataName = listdata(file).name;
    path = strcat("salidas/",dataName);
    matriz = load(path,"meanYear");
    finalMatrix(:,:,file) = matriz.meanYear;
end

%Obtencion xgrid y ygrid (arrays) para generar la malla a interpolar
 xgrid = -118.3651143520000062:0.018: -86.703114352000000;
 ygrid =  14.5386535700000010 :0.018:  32.7186535700000007;
%Generacion de los ejes de la malla (x,y matrices)
[x,y]= ndgrid(xgrid,ygrid);

%Creacion de netcdf
nccreate("meanYears.nc",'longitud', ...
    'Dimensions',{"r",1760,"c",1011});
ncwrite("meanYears.nc","longitud",x)
nccreate("meanYears.nc",'latitud', ...
    'Dimensions',{"r",1760,"c",1011})
ncwrite("meanYears.nc","latitud",y)

nccreate("meanYears.nc",'precipInterpol', ...
    'Dimensions',{"r",1760,"c",1011,"year",58})
ncwrite("meanYears.nc","precipInterpol",finalMatrix)

