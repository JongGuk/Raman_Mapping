function varargout = Raman_mapping(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Raman_mapping_OpeningFcn, ...
                   'gui_OutputFcn',  @Raman_mapping_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


function Raman_mapping_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

set(handles.mapping,'Visible','off'); % off
set(handles.spectra,'Visible','off');
set(handles.mapping2,'Visible','off');
set(handles.spectra2,'Visible','off');



guidata(hObject, handles);



function varargout = Raman_mapping_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;



function x_Callback(hObject, eventdata, handles)



function x_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 스펙트럼 플롯 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_Callback(hObject, eventdata, handles)
x = get(handles.x,'string');
x=str2double(x);
y = get(handles.y,'string');
y=str2double(y);
ss = get(handles.step_size, 'string');
ss = str2double(ss);

L  = (x-1)*ss + y-1;

data = handles.data; %데이터 받아옴
data2 = handles.data2;
data2 = data2(1,4:end-1);



if (get(handles.b1x1,'Value'))
    T = data(L,:); %데이터 앞뒤 짜름 (필요없는 부분) 1x1
else
    T = data(L-ss-1,:) + data(L-ss,:) + data(L-ss+1,:) + data(L-1,:) + data(L,:) + data(L+1,:) + data(L+ss-1,:) + data(L+ss,:) + data(L+ss+1,:) ; % 3x3
end

T(:,[1:3]) = [];
T(:,[1025]) = [];

usermin=get(handles.usermin,'string');
usermax=get(handles.usermax,'string');

%axes(handles.spectra);
%hold off

%plot(data2,T,'ko','MarkerSize',2.5,'MarkerFaceColor','black');
%axis([str2num(usermin) str2num(usermax) 150 200]);
%axis 'auto y'
%hold on
%plot(data2,fy)

MIN = min(find(data2 > str2double(usermin))); % min 값, max 값 불러와서 데이터 상의 min값,max값의 순서 (몇번째인지) 구함
MAX = max(find(data2 < str2double(usermax)));

DATA  = data2(MIN:MAX); % min값,max값 까지 데이터 자름 (위치, x값)
DATAT = T(MIN:MAX); % 세기 (y값)

axes(handles.spectra);
hold off

fx = DATA.';
fy = DATAT.';    
f  = fit(fx,fy,'gauss4'); %피팅

plot(DATA,DATAT,'ko','MarkerSize',2.5,'MarkerFaceColor','black'); 

drawnow
hold on

if (get(handles.fitting,'Value'))
    plot(f,DATA,DATAT)
end

xlabel ''
ylabel ''

%SMIN=get(handles.smin,'string')
%if SMIN == ''
%set(handles.smin,'string',data2(SMIN))
%set(handles.smax,'string',data2(SMAX))
%end A  

%% 면적계산
Smin = get(handles.smin,'string');
Smin = str2double(Smin);
Smax = get(handles.smax,'string');
Smax = str2double(Smax);

SMIN = min(find(data2 > Smin));
SMAX = max(find(data2 < Smax));


baseline_mean=(  T(SMIN-2) + T(SMIN-1) + T(SMIN) + T(SMAX) + T(SMAX+1) + T(SMAX+2)  )/6;


SDATA = data2(SMIN:SMAX); % min값,max값 까지 데이터 자름 (위치, x값)
SDATAT = T(SMIN:SMAX);

fill(SDATA,SDATAT,'b')
alpha(.1);
after_T=T(SMIN:SMAX)-baseline_mean;
area1=sum(after_T);
set(handles.area1,'string',area1);
axis([str2double(usermin) str2double(usermax) min(DATAT)*0.99 max(DATAT)*1.01]);

%% 스펙트럼 save -> handles
handles.DATA  = DATA;
handles.DATAT = DATAT;

guidata(hObject,handles)





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 로딩 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Load_Callback(hObject, eventdata, handles)
[file,path] = uigetfile('*','Raman data csv file');
h           = waitbar(0.1,'Loading...');
data        = csvread(sprintf(file,path),1,0);
waitbar(0.4);
[sx,sy]     = size(data);
data2       = csvread(sprintf(file,path),0,3,[0,3,0,sy-2]);
data2       = [0 0 0 data2 0];
waitbar(0.8);
handles.data  = data;
handles.data2 = data2;
guidata(hObject,handles) % <- 현재까지 handles에 넣은거 뿌려줌
set(handles.step_size,'string',sqrt(sx))
set(handles.min,'string',data2(1,4))
set(handles.max,'string',data2(1,sy-1))
waitbar(0.99);

clear sx sy
close(h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function y_Callback(hObject, eventdata, handles)


function y_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function step_size_Callback(hObject, eventdata, handles)


function step_size_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function min_Callback(hObject, eventdata, handles)

function min_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function usermin_Callback(hObject, eventdata, handles)

function usermin_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function usermax_Callback(hObject, eventdata, handles)


function usermax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 맵핑 %% (현재창)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function startmapping_Callback(hObject, eventdata, handles)
ss = get(handles.step_size, 'string');
ss = str2double(ss);
rangemin = get(handles.usermin, 'string');
rangemin = str2double(rangemin);
rangemax = get(handles.usermax, 'string');
rangemax = str2double(rangemax);

data  = handles.data;
data2 = handles.data2;

min=round( (rangemin-data2(1,4)) / ((data2(1,1027)-data2(1,4)) / 1023) )+1; % resolution에 따라 조정 되야함 (변수값으로 바꿀 것)
max=round( (rangemax-data2(1,4)) / ((data2(1,1027)-data2(1,4)) / 1023) )+1;

% +3개씩 더해줘야함 (data 자체가 그렇게 구성됨, 4번째가 1번째꺼, 1027번째가 1024번째(마지막) )
if min>3
    min=min+3;
else
    min=7;
end

if max<1021
   max=max+3;
else
    max=1024; 
end

if (get(handles.sumcheck,'Value'))
    k1  = mean(data(:,min-3:min),2); % data min 범위값 ~ 앞에 3개점을 평균, 세로방향으로(2)
    k2  = mean(data(:,max:max+3),2); % data max 범위값 ~ 뒤에 3개점을 평균, 세로방향으로(2)
    k3  = mean([k1,k2],2); % 평균값(baseline)
    datak = data(:,min:max); %min~max까지의 data만 추출
    T   = sum(datak,2); % datak의 가로방향으로 더하기
else
    k  = mean(data(:,min:max),2);
    k1 = mean(data(:,min-3:min),2);
    k2 = mean(data(:,max:max+3),2);
    k3 = mean([k1,k2],2);
    T = k-k3;
end
    T = reshape(T,[ss,ss]);

datarange = data2(4:end-1);
comdata = data(:,4:1027);

for i=1:ss^2
    M = sum(comdata(i,:));
    mixi = comdata(i,:).*datarange(1,:);
    xcm = sum(mixi)/M;
    xcmdata(1,i) = xcm; 
end

xcmT = reshape(xcmdata,[ss,ss]);

X = 1:ss;
Y = 1:ss;

axes(handles.mapping); % 현재창
contourf(X,Y,T,30,'LineStyle','none')
colorbar
colormap(copper);
smin=num2str(rangemin);
smax=num2str(rangemax);
tt=sprintf('%s ~ %s',smin,smax);
axis equal
title(tt)
[xi,yi,button]=ginput(1);
set(handles.x,'string',round(xi));
set(handles.y,'string',round(yi));

handles.X=X;
handles.Y=Y;
handles.T=T;

guidata(hObject,handles)
figure
contourf(X,Y,xcmT,30,'LineStyle','none')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 새 창으로 맵핑
function startmapping_new_Callback(hObject, eventdata, handles)
ss = get(handles.step_size, 'string');
ss = str2double(ss);
rangemin = get(handles.usermin, 'string');
rangemin = str2double(rangemin);
rangemax = get(handles.usermax, 'string');
rangemax = str2double(rangemax);


data  = handles.data;
data2 = handles.data2;

min=round( (rangemin-data2(1,4))/ ( (data2(1,1027)-data2(1,4)) / 1023) )+1; % resolution에 따라 조정 되야함 (변수값으로 바꿀 것)
max=round( (rangemax-data2(1,4))/ ( (data2(1,1027)-data2(1,4)) / 1023) )+1;

if min>3
    min=min+3;
else
    min=7;
end

if max<1021
    max=max+3;
else
    max=1024; 
end

if (get(handles.sumcheck,'Value'))
    k1  = mean(data(:,min-3:min),2); % data min 범위값 ~ 앞에 3개점을 평균, 세로방향으로(2)
    k2  = mean(data(:,max:max+3),2); % data max 범위값 ~ 뒤에 3개점을 평균, 세로방향으로(2)
    k3  = mean([k1,k2],2); % 평균값(baseline)
    datak = data(:,min:max); %min~max까지의 data만 추출
    T   = sum(datak,2); % datak의 가로방향으로 더하기
else
    k  = mean(data(:,min:max),2);
    k1 = mean(data(:,min-3:min),2);
    k2 = mean(data(:,max:max+3),2);
    k3 = mean([k1,k2],2);
    T = k-k3;
end
    T = reshape(T,[ss,ss]);



X = 1:ss;
Y = 1:ss;


smin=num2str(rangemin);
smax=num2str(rangemax);
tt=sprintf('%s ~ %s',smin,smax);

figure('NumberTitle','off','Name',tt); % 새창
contourf(X,Y,T,100,'LineStyle','none')
colorbar
axis equal
[xi,yi,button]=ginput(1);
set(handles.x,'string',round(xi));
set(handles.y,'string',round(yi));

handles.X=X;
handles.Y=Y;
handles.T=T;
guidata(hObject,handles)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





function min2_Callback(hObject, eventdata, handles)



function min2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max_Callback(hObject, eventdata, handles)

function max_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function mapping_CreateFcn(hObject, eventdata, handles)


function x2_Callback(hObject, eventdata, handles)


function x2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% 스펙트럼 플롯 2
function plot2_Callback(hObject, eventdata, handles)
x2  = get(handles.x2,'string');
x2  = str2double(x2);
y2  = get(handles.y2,'string');
y2  = str2double(y2);
ss2 = get(handles.step_size2, 'string');
ss2 = str2double(ss2);

L2  = (x2-1)*ss2 + y2-1;

data3 = handles.data3;
data4 = handles.data4;
data4 = data4(1,4:end-1);


if (get(handles.b1x12,'Value'))
    T2 = data3(L2,:);
else    
    T2 = data3(L2-ss2-1,:) + data3(L2-ss2,:) + data3(L2-ss2+1,:) + data3(L2-1,:) + data3(L2,:) + data3(L2+1,:) + data3(L2+ss2-1,:) + data3(L2+ss2,:) + data3(L2+ss2+1,:) ;
end

T2(:,[1:3]) = [];
T2(:,[1025]) = [];

usermin2=get(handles.usermin2,'string');
usermax2=get(handles.usermax2,'string');

%axes(handles.spectra);
%hold off

%plot(data2,T,'ko','MarkerSize',2.5,'MarkerFaceColor','black');
%axis([str2num(usermin) str2num(usermax) 150 200]);
%axis 'auto y'
%hold on
%plot(data2,fy)

MIN2 = min(find(data4 > str2double(usermin2)));
MAX2 = max(find(data4 < str2double(usermax2)));

DATA2 = data4(MIN2:MAX2);
DATAT2 = T2(MIN2:MAX2);

axes(handles.spectra2);
hold off
fx2=DATA2.';
fy2=DATAT2.';

f2 = fit(fx2,fy2,'gauss4');
plot(DATA2,DATAT2,'ko','MarkerSize',2.5,'MarkerFaceColor','black');

drawnow
hold on

if (get(handles.fitting2,'Value'))
    plot(f2,DATA2,DATAT2)
end

xlabel ''
ylabel ''
%% 면적 2
Smin2 = get(handles.smin2,'string');
Smin2 = str2double(Smin2);
Smax2 = get(handles.smax2,'string');
Smax2 = str2double(Smax2);

SMIN2 = min(find(data4 > Smin2));
SMAX2 = max(find(data4 < Smax2));


baseline_mean2=(  T2(SMIN2-2) + T2(SMIN2-1) + T2(SMIN2) + T2(SMAX2) + T2(SMAX2+1) + T2(SMAX2+2)  )/6;


SDATA2 = data4(SMIN2:SMAX2); % min값,max값 까지 데이터 자름 (위치, x값)
SDATAT2 = T2(SMIN2:SMAX2);

fill(SDATA2,SDATAT2,'r')
alpha(.1);
after_T2=T2(SMIN2:SMAX2)-baseline_mean2;
area2=sum(after_T2);
set(handles.area2,'string',area2);
axis([str2double(usermin2) str2double(usermax2) min(DATAT2)*0.99 max(DATAT2)*1.01]);

handles.DATA2  = DATA2;
handles.DATAT2 = DATAT2;

guidata(hObject,handles)






%% 파일 로드 2
function Load2_Callback(hObject, eventdata, handles)
[file2,path2] = uigetfile('*','Raman data csv file');
h           = waitbar(0.1,'Loading...');
data3       = csvread(sprintf(file2,path2),1,0);
[sx2,sy2]     = size(data3);
waitbar(0.4);
data4       = csvread(sprintf(file2,path2),0,3,[0,3,0,sy2-2]);
data4       = [0 0 0 data4 0];
handles.data3 = data3;
handles.data4 = data4;
guidata(hObject,handles)
waitbar(0.8);
set(handles.step_size2,'string',sqrt(sx2))
set(handles.min2,'string',data4(1,4))
set(handles.max2,'string',data4(1,sy2-1))
waitbar(0.99);
clear sx2 sy2
close(h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function y2_Callback(hObject, eventdata, handles)


function y2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function step_size2_Callback(hObject, eventdata, handles)


function step_size2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function usermin2_Callback(hObject, eventdata, handles)


function usermin2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function usermax2_Callback(hObject, eventdata, handles)


function usermax2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%% 맵핑 2
function startmapping2_Callback(hObject, eventdata, handles)
ss2 = get(handles.step_size2, 'string');
ss2 = str2double(ss2);
rangemin2 = get(handles.usermin2, 'string');
rangemin2 = str2double(rangemin2);
rangemax2 = get(handles.usermax2, 'string');
rangemax2 = str2double(rangemax2);

data3 = handles.data3;
data4 = handles.data4;

min2=round( (rangemin2-data4(1,4))/ ( (data4(1,1027)-data4(1,4)) / 1023) )+1; % resolution에 따라 조정 되야함 (변수값으로 바꿀 것)
max2=round( (rangemax2-data4(1,4))/ ( (data4(1,1027)-data4(1,4)) / 1023) )+1;

if min2>3
    min2=min2+3;
else
    min2=7;
end

if max2<1021
    max2=max2+3;
else
    max2=1024; 
end

if (get(handles.sumcheck2,'Value'))
    k1 = mean(data3(:,min2-3:min2),2);
    k2 = mean(data3(:,max2:max2+3),2);
    k3 = mean([k1,k2],2);
    datak2 = data3(:,min2:max2);
    T2  = sum(datak2,2);
else
    k  = mean(data3(:,min2:max2),2);
    k1 = mean(data3(:,min2-3:min2),2);
    k2 = mean(data3(:,max2:max2+3),2);
    k3 = mean([k1,k2],2);
    T2 = k-k3;
end
T2 = reshape(T2,[ss2,ss2]);


X2 = 1:ss2;
Y2 = 1:ss2;

axes(handles.mapping2);
contourf(X2,Y2,T2,30,'LineStyle','none')
colorbar
colormap(copper);
smin2=num2str(rangemin2);
smax2=num2str(rangemax2);
tt2=sprintf('%s ~ %s',smin2,smax2);
axis equal
title(tt2)
[xi2,yi2,button]=ginput(1);
set(handles.x2,'string',round(xi2));
set(handles.y2,'string',round(yi2));

handles.X2=X2;
handles.Y2=Y2;
handles.T2=T2;
guidata(hObject,handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 새창으로 맵핑 2
function startmapping_new2_Callback(hObject, eventdata, handles)
ss2 = get(handles.step_size2, 'string');
ss2 = str2double(ss2);
rangemin2 = get(handles.usermin2, 'string');
rangemin2 = str2double(rangemin2);
rangemax2 = get(handles.usermax2, 'string');
rangemax2 = str2double(rangemax2);

data3  = handles.data3;
data4 = handles.data4;

min2=round( (rangemin2-data4(1,4))/ ( (data4(1,1027)-data4(1,4)) / 1023) )+1; % resolution에 따라 조정 되야함 (실제값으로 보정해야함)
max2=round( (rangemax2-data4(1,4))/ ( (data4(1,1027)-data4(1,4)) / 1023) )+1;

if min2>3
    min2=min2+3;
else
    min2=7;
end

if max2<1021
    max2=max2+3;
else
    max2=1024; 
end

if (get(handles.sumcheck2,'Value'))
    k1 = mean(data3(:,min2-3:min2),2);
    k2 = mean(data3(:,max2:max2+3),2);
    k3 = mean([k1,k2],2);
    datak2 = data3(:,min2:max2);
    T2  = sum(datak2,2);
else
    k  = mean(data3(:,min2:max2),2);
    k1 = mean(data3(:,min2-3:min2),2);
    k2 = mean(data3(:,max2:max2+3),2);
    k3 = mean([k1,k2],2);
    T2 = k-k3;
end
T2 = reshape(T2,[ss2,ss2]);

X2 = 1:ss2;
Y2 = 1:ss2;

smin2=num2str(rangemin2);
smax2=num2str(rangemax2);
tt2=sprintf('%s ~ %s',smin2,smax2);

figure('NumberTitle','off','Name',tt2); % 새창
contourf(X2,Y2,T2,500,'LineStyle','none')
colorbar
axis equal
[xi2,yi2,button]=ginput(1);
set(handles.x2,'string',round(xi2));
set(handles.y2,'string',round(yi2));

handles.X2=X2;
handles.Y2=Y2;
handles.T2=T2;
guidata(hObject,handles)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






function edit29_Callback(hObject, eventdata, handles)


function edit29_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function max2_Callback(hObject, eventdata, handles)


function max2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%% save 저장
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mappingsave_Callback(hObject, eventdata, handles)
[file,path] = uiputfile('*.csv','Save data As');
data = handles.data;
X = handles.X;
Y = handles.Y;
T = handles.T;
YY=[0;Y'];
findata=[X;T];
findata=[YY,findata];

fname=sprintf('%s%s',path,file);

csvwrite(fname,findata)



function mappingsave2_Callback(hObject, eventdata, handles)
[file,path] = uiputfile('*.csv','Save data As');
data3 = handles.data3;
X2 = handles.X2;
Y2 = handles.Y2;
T2 = handles.T2;
YY2=[0;Y2'];
findata2=[X2;T2];
findata2=[YY2,findata2];

fname2=sprintf('%s%s',path,file);

csvwrite(fname2,findata2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 면적계산

function area1_Callback(hObject, eventdata, handles)


function area1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function area2_Callback(hObject, eventdata, handles)


function area2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function smin_Callback(hObject, eventdata, handles)


function smin_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function smax_Callback(hObject, eventdata, handles)


function smax_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function smin2_Callback(hObject, eventdata, handles)


function smin2_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function smax2_Callback(hObject, eventdata, handles)


function smax2_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkbox1_Callback(hObject, eventdata, handles)



function b1x1_Callback(hObject, eventdata, handles)
if (get(handles.b1x1,'Value'))
        set(handles.b3x3,'Value',0)
end



function b3x3_Callback(hObject, eventdata, handles)
if (get(handles.b3x3,'Value'))
        set(handles.b1x1,'Value',0)
end


function b1x12_Callback(hObject, eventdata, handles)
if (get(handles.b1x12,'Value'))
        set(handles.b3x32,'Value',0)
end

function b3x32_Callback(hObject, eventdata, handles)
if (get(handles.b3x32,'Value'))
        set(handles.b1x12,'Value',0)
end


function fitting2_Callback(hObject, eventdata, handles)


function fitting_Callback(hObject, eventdata, handles)


function spectrumsave_Callback(hObject, eventdata, handles)
[file,path] = uiputfile('*.csv','Save data As');
DATA  = handles.DATA
DATAT = handles.DATAT
spectrumdata = [DATA' DATAT']
fname=sprintf('%s%s',path,file);

csvwrite(fname,spectrumdata)


function spectrumsave2_Callback(hObject, eventdata, handles)
[file,path] = uiputfile('*.csv','Save data As');
DATA2  = handles.DATA2
DATAT2 = handles.DATAT2
spectrumdata2 = [DATA2' DATAT2']
fname=sprintf('%s%s',path,file);

csvwrite(fname,spectrumdata2)


function figure1_SizeChangedFcn(hObject, eventdata, handles)


function sumcheck_Callback(hObject, eventdata, handles)


function sumcheck2_Callback(hObject, eventdata, handles)


function CoM2_Callback(hObject, eventdata, handles)


function CoM_Callback(hObject, eventdata, handles)
