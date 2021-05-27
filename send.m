clear all;
clc;
close all;
[filename, filepath] = uigetfile('.bmp', '������BMP��ʽˮӡ');
watermarkImgFile = strcat(filepath, filename);
mark=imread(watermarkImgFile);
[water_Img,K1,K2]=shuiyin2(mark);

%������Ƶ
[filename, filepath] = uigetfile('.avi', '������AVI��ʽ��������Ƶ');
videoFile = strcat(filepath, filename);
vd=VideoReader(videoFile);
vidFrames = read(vd);
NOF = get(vd, 'NumberOfFrames');  %��ȡ��Ƶ֡��
Impor=Important2Zhen(vd);
Impor_len=length(Impor);

%��ʾ������Ƶ
for u = 1 : NOF
    mov(u).cdata = vidFrames(:,:,:,u);
    mov(u).colormap = [];
end

% ������ʾ���
mp4 = figure;
% ��������Ӧ��Ƶ���
set(mp4, 'position', [150 150 vd.Width vd.Height])
%������Ƶ����
movie(mp4, mov, 1, vd.FrameRate);

%��Ƶ������ϢǶ��
directory=[cd,'/test_images/'];
K3=randn(1,4);  %����������ͬ���������
K4=randn(1,4);
mark_2=zeros(32,32);

h=waitbar(0,'DctǶ��');
for i=1:Impor_len
    e=Impor(1,i);
    currentFrame = read(vd, e);%��ȡ֡
    m(1,i)=mod(i,16);
    if m(1,i)==0
        m(1,i)=16;
    end
    mark_2=water_Img(:,:,m(1,i));
    arnoldImg = arnold(mark_2,K1);
    figure(1),imshow(mark_2,[]);
    figure(2),imshow(arnoldImg,[]);
    [waterimage] = qianru( currentFrame,arnoldImg,K3,K4 );
    imwrite(waterimage,[directory,[num2str(e),'.bmp'];]); 
    s=sprintf('������ϢǶ���У����Ժ�:%d',i);
    waitbar(i/Impor_len,h,[s '/' num2str(Impor_len)]);
end

%��������Ƶ
path = 'test_images\';                  
writerObj = VideoWriter('incept/result.avi');   %�����ɵ���Ƶ����
open(writerObj);
for f = 1:NOF
   frame = imread(strcat(path,num2str(f),'.bmp'));
   writeVideo(writerObj,frame);
end
close(writerObj);

key_data=[K3;K4];
Key3=fopen('incept/Key/key3.txt','w');                 
fprintf(Key3,'%.15f %.15f\n',key_data);             
fclose(Key3);                           

