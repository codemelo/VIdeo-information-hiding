clear all;
clc;
close all;

%��Կ��ȡ
x1=fopen('incept\Key\key1.txt','r');
K1=abs(fread(x1,inf,'*char'));
fclose(x1);
x2=fopen('incept\Key\key2.txt','r');
K2=abs(fread(x2,inf,'*char'));
K2=reshape(K2,1,16);
fclose(x2);
filename1='incept\Key/key3.txt';
[data1,data2]=textread(filename1,'%f%f');
K3=reshape(data1,1,4);
K4=reshape(data2,1,4);
filename2='incept\Key/key4.txt';
data3=textread(filename2,'%d');
[Mq,Nq]=size(data3);
K5=reshape(data3,Nq,Mq);

Impor=K5;

%��ȡ��ˮӡ����Ƶ
[filename, filepath] = uigetfile('.avi', '���뺬ˮӡ����Ƶ');
videoFile = strcat(filepath, filename);
vd=VideoReader(videoFile);
vidFrames = read(vd);
NOF = get(vd, 'NumberOfFrames');  %��ȡ��Ƶ֡��

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


%��Ƶ���
[Impor_len]=ImportJiance(vd);
if  Impor_len<length(K5)-25
    disp('����Ƶȱʧ������Ϣ�������Ƿ������ȡ')
    n=input('������ȡ������1�������ϴ��ļ�������0:');
elseif Impor_len<16
    disp('����Ƶ����')
    n=0;
elseif Impor_len>length(K5)
    disp('����Ƶ�ܵ����������������Ƿ������ȡ')
    n=input('������ȡ������2�������ϴ��ļ�������0:');
else
    n=1;
end

switch n
    
    case 2
        %������Ϣ��ȡ
        h=waitbar(0,'Dct��ȡ');
        for j=1:length(K5)
            p=Impor(1,j);
            watermarkedImg= read(vd, p);
            [ water ] = tiqu(watermarkedImg,K3,K4);
            figure(1),imshow(water,[]);
            waterimg = rearnold(water,K1);
            figure(2),imshow(waterimg,[]);
            message(:,:,j)=waterimg;
            l=sprintf('������Ϣ��ȡ�У����Ժ�:%d',j);
            waitbar(j/length(K5),h,[l '/' num2str(length(K5))]);
            m(1,j)=mod(j,16);
            if m(1,j)==0
                m(1,j)=16;
            end
        end
        
        for xu=1:length(K5)
            message(33,1:8,xu)=reshape(str2num(reshape(dec2bin(K2(1,m(1,xu)),8),8,1)),1,8);
        end
        
        mkdir([cd,'/incept/result_attack_noise']);%����Ŀ¼
        directory=[cd,'/incept/result_attack_noise/'];
        g=sum(m(:)==16);
        h1=waitbar(0,'��ȡˮӡͼ��');
        for r = 1:g
            message_2=message(:,:,16*(r-1)+1:16*r);
            [reimg]=Dct_Tiqu(message_2);
            reimg = mat2gray(reimg);%ͼ�����Ĺ�һ������
            imwrite(reimg,[directory,[num2str(r),'.bmp'];]);
            [ Reimg ] = middle2filter(reimg);
            Reimg = mat2gray(Reimg);%ͼ�����Ĺ�һ������
            imwrite(Reimg,[directory,[num2str(r+11),'.bmp'];]);
            l1=sprintf('ˮӡͼ����ȡ�У����Ժ�:%d',r);
            waitbar(r/g,h1,[l1 '/' num2str(g)]);
        end
    
    case 1
        %������Ϣ��ȡ
        h=waitbar(0,'Dct��ȡ');
        for j=1:Impor_len
            p=Impor(1,j);
            watermarkedImg= read(vd, p);
            [ water ] = tiqu(watermarkedImg,K3,K4);
            figure(1),imshow(water,[]);
            waterimg = rearnold(water,K1);
            figure(2),imshow(waterimg,[]);
            message(:,:,j)=waterimg;
            l=sprintf('������Ϣ��ȡ�У����Ժ�:%d',j);
            waitbar(j/Impor_len,h,[l '/' num2str(Impor_len)]);
            m(1,j)=mod(j,16);
            if m(1,j)==0
                m(1,j)=16;
            end
        end
        
        for xu=1:Impor_len
            message(33,1:8,xu)=reshape(str2num(reshape(dec2bin(K2(1,m(1,xu)),8),8,1)),1,8);
        end
        
        mkdir([cd,'/incept/result']);%����Ŀ¼
        directory=[cd,'/incept/result/'];
        g=sum(m(:)==16);
        h1=waitbar(0,'��ȡˮӡͼ��');
        for r = 1:g
            message_2=message(:,:,16*(r-1)+1:16*r);
            [reimg]=Dct_Tiqu(message_2);
            reimg = mat2gray(reimg);%ͼ�����Ĺ�һ������
            imwrite(reimg,[directory,[num2str(r),'.bmp'];]);
            l1=sprintf('ˮӡͼ����ȡ�У����Ժ�:%d',r);
            waitbar(r/g,h1,[l1 '/' num2str(g)]);
        end
    case 0
        disp('������ѡ���ļ�����л����ʹ��')
end
