%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           AUTOMATIC CAR PARKING                         %
%                           Leaving Side Program                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all
close all
clc



% adding qrcode library  path. Download files from internet and place it in
% current directory
javaaddpath('zxing-1.7-core.jar');
javaaddpath('zxing-1.7-javase.jar');

filename_carimg = 'E:\Softwares\Matlab2016\archive\CAR_IMAGES';

%intialize com port connection.Change the port name with respect to arduino
%connection.
%s = serial('COM4','BaudRate',9600);
%fopen(s);

choice = 0;
    cam = webcam();
    preview(cam)
while(choice~=5)
    %menu selection for/GUI dialog box. 
choice = menu('Automatic Car Parking','Get QRCode','Decode QRCode','Cross verification','Open Gate','Exit');


if (choice==1)
    img = snapshot(cam);
    
    figure,imshow(img)
   %save image to current directory
   imwrite(img,'qrimage.jpg');

elseif(choice==2)
    
    %decoding qr code
    message = decode_qr(img);
     
    disp(message)
    
    
elseif(choice==3)
 try
   %get the record image from database 
   baseFileName = sprintf('%s.jpg', message);
   fullfilename = fullfile(filename_carimg, baseFileName);
   img2  = imread(fullfilename);
   figure,imshow(img2)
  
    fileid= fopen('Automatic_Car_Parking.txt');
    %tline = fgets(fid);
%while ischar(tline)
 %   disp(tline) 
 %   if(strcmp(tline,message)==1)
  %      break;
   % else
   %     tline = fgets(fid);  %% gets new text line from file 
    %end
%end
fprintf(s,'l');
disp('Cross verification is done')
%fprintf(s,'l');
%disp(tline)

fclose(fileid);

 catch
     clear cam
   % warning('No record in database. Scan again');
    disp('No record in database. Scan again.')

 end
elseif(choice==4)
    disp('gate opened.')
    %signal to arduino
    % fprintf(s,'l');
else
    
    clear cam
    choice = 5;
end

end