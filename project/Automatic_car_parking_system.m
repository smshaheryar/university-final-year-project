function varargout = Automatic_car_parking_system(varargin)
% AUTOMATIC_CAR_PARKING_SYSTEM MATLAB code for Automatic_car_parking_system.fig
%      AUTOMATIC_CAR_PARKING_SYSTEM, by itself, creates a new AUTOMATIC_CAR_PARKING_SYSTEM or raises the existing
%      singleton*.
%
%      H = AUTOMATIC_CAR_PARKING_SYSTEM returns the handle to a new AUTOMATIC_CAR_PARKING_SYSTEM or the handle to
%      the existing singleton*.
%
%      AUTOMATIC_CAR_PARKING_SYSTEM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUTOMATIC_CAR_PARKING_SYSTEM.M with the given input arguments.
%
%      AUTOMATIC_CAR_PARKING_SYSTEM('Property','Value',...) creates a new AUTOMATIC_CAR_PARKING_SYSTEM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Automatic_car_parking_system_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Automatic_car_parking_system_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Automatic_car_parking_system

% Last Modified by GUIDE v2.5 04-Jun-2017 17:31:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Automatic_car_parking_system_OpeningFcn, ...
                   'gui_OutputFcn',  @Automatic_car_parking_system_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before Automatic_car_parking_system is made visible.
function Automatic_car_parking_system_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Automatic_car_parking_system (see VARARGIN)

% Choose default command line output for Automatic_car_parking_system
handles.output = hObject;

%handles.test1.String = 'Please wait...Loading data...';
%drawnow;

%Display unilogo on gui startup
myimage = imread('apcom.jpg');
imshow(myimage, 'Parent', handles.axes1);

Nrows = numel(textread('Automatic_Car_Parking.txt','%1c%*[^\n]'));
Nrows = 10 - Nrows;
set(handles.text9,'String',num2str(Nrows));
%drawnow;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Automatic_car_parking_system wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Automatic_car_parking_system_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

%cam = webcam();
%cam = webcam(1);
%camsize = str2double( strsplit(cam.Resolution, 'x'));
%im = image(zeros(camsize), 'Parent', handles.axes2);
%cam.Resolution = '1280x1024';
%hImage=image(cam,'Parent',handles.axes2);
%preview(cam,im);

% adding qrcode library  path. Download files from internet and place it in
% current directory
javaaddpath('zxing-1.7-core.jar');
javaaddpath('zxing-1.7-javase.jar');

%intialize com port connection.Change the port name with respect to arduino
%connection.
try
s = serial('COM4','BaudRate',9600);
fopen(s);
catch
   set(handles.text10,'String','Restart System ');
        drawnow;
end
    
filename_qr = 'E:\Softwares\Matlab2016\archive\QR_Images';
filename_carimg = 'E:\Softwares\Matlab2016\archive\CAR_IMAGES';

%open file 
fileid = fopen('Automatic_Car_Parking.txt','wt');
%cam = webcam();
%preview(cam)
%loop terminating parameter.
choice = '1';

while(choice ~= '0')
    
    %input signal from arduino
    try
    choice = fscanf(s,'%d');
    catch
           set(handles.text10,'String','Restart System');
        drawnow;
    %pause(2)
   end
         Nrows = numel(textread('Automatic_Car_Parking.txt','%1c%*[^\n]'));
         Nrow= 10 - Nrows;
set(handles.text9,'String',num2str(Nrow));
    if(choice == 1)
        set(handles.text10,'String','CAR Detected');
        drawnow;
    
    if(Nrows >= 10)
        set(handles.text10,'String','Sorry for inconvience.No slot is Available');
        drawnow;
       % disp('Sorry for inconvience.No slot is Available')
    else
        set(handles.text10,'String','Slot Available.Proceed Ahead.');
        drawnow;
       % disp('Slot Available.Proceed Ahead.');
       % tic
        %initialize cam
   try
        cam = webcam();
        
        %get snapshot
        img = snapshot(cam);
        
        %display image
         %figure,imshow(img)
         imshow(img, 'Parent', handles.axes7);
         
        %RGB to gray conversion then data type conversion from uint to
        %double and %normalizing image using im2double  command.
         gray_img = im2double( rgb2gray(img) );

         %convert image from gray scale to binary with proper threshold 
         BW = im2bw(gray_img,0.5);
         
         %Take complement of image to convert white pixels to black and 
         %black to white.
         BW2 = imcomplement(BW);
         
         %Applying optical character recognition to extract text from image.
         %txt = ocr(BW, 'TextLayout', 'Block');
         txt = ocr(BW2);
         txt = txt.Text;
         %reshape(txt .', 1, [])
         txt = textscan(txt,'%c');
         txt = txt{1};
         txt = txt(txt~=':');txt = txt(txt~=';');txt = txt(txt~=',');
         txt = txt(txt~='&');txt = txt(txt~='`');txt = txt(txt~='!');
         txt = txt(txt~='@');txt = txt(txt~='%');txt = txt(txt~='#');
         txt = txt(txt~='$');txt = txt(txt~=' ');

         %Display exracted text
         %disp(txt)
         
         %QR code generation.get zxing library from github or Matlab site.
         % encode a new QR code
         test_encode =imcomplement(encode_qr(txt, [320 320]));
         %figure,imshow(test_encode),title('QR Code')
         
         
         imshow(test_encode, 'Parent', handles.axes8);
       
         
         print
         pause(10)
           %open gate
         fprintf(s,'y');
         %save text to file
         fprintf(fileid,'%s\r\n',txt);
         
         %save generated qrcode to current directory
         baseFileName = sprintf('%s.jpg', txt);
         fullFileName = fullfile(filename_qr, baseFileName);
         imwrite(test_encode,fullFileName);
         
         %save car image to folder
         fullFileName = fullfile(filename_carimg, baseFileName);
         imwrite(img,fullFileName); 
        
         
         %recipt printing
         %test_encode = imread('qrcode.jpg');
         %myimage = imread('apcom.jpg');
         %receipt = cat(2,rgb2gray(myimage),imresize(test_encode,[251 251]));
         %date_txt = datetime('now');
         %date_txt = datestr(date_txt);
         %RGB = insertText(receipt,[20 20],date_txt);
         %text = 'Parking Receipt ';
         %tt = num2str(Nrow+1);
         %tt = cat(2,text,tt);
         %RGB = insertText(RGB,[288 225],tt);
         %figure,imshow(RGB)
         %imshow(RGB, 'Parent', handles.axes8);

         %print()
         pause(5)
         %signal to arduino
         %fprintf(s,'y');
         
         %fclose(fileid);
         clear cam
         toc
        catch
            clear cam
            %disp('No record save. Try again.');
            
        set(handles.text10,'String','No record save.Try again ');
        drawnow;
            %fclose(fileid);
           % fclose(s);
        end
    end 
         
    else
        
        set(handles.text10,'String','No car detected');
        drawnow;
    
    end
    
       %clear s;
end


varargout{1} = handles.output;



%function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
%function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
 %   set(hObject,'BackgroundColor','white');
%end




% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%clear all
%s = serial('COM4','BaudRate',9600);
%fopen(s);
%fprintf(s,'y');
set(handles.text10,'String','gate opened');
        drawnow;
      %  fclose(s);
pause(2)

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%close all
%clear all
Automatic_car_parking_system
