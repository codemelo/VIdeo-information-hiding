%����ؼ�֡λ��
function Impor=Important2Zhen(video)
obj = video;%������Ƶλ��
NOF=obj.NumberOfFrames;% ֡������
mkdir([cd,'/test_images']);%����Ŀ¼
directory=[cd,'/test_images/'];

for i=1:NOF
    Img_I=read(obj,i); %��ȡ��Ƶ
    imwrite(Img_I,[directory,[num2str(i) '.bmp'];]);   %ÿһ֡���һ��jpg
end; 
              
file_path =  'test_images\';% ͼ���ļ���·��
img_path_list = dir(strcat(file_path,'*.bmp'));%��ȡ���ļ���������jpg��ʽ��ͼ��

for i=1:NOF-1
    image_name_i = strcat(num2str(i),'.bmp');  %ͼ����
    img_i =  imread(strcat(file_path,image_name_i));  %��ȡ��ͼ��
    image_name_i_plus = strcat(num2str(i+1),'.bmp');% ��һ��ͼ����
    img_i_plus =  imread(strcat(file_path,image_name_i_plus));  %��ȡ��һ��ͼ��
    img_sim(i)=corr2(img_i(:,:,1),img_i_plus(:,:,1))+corr2(img_i(:,:,2),img_i_plus(:,:,2))+corr2(img_i(:,:,3),img_i_plus(:,:,3));  %����ǰ������ͼ������ƶ�
    img_sim(i)=img_sim(i)/3;
end;
Y_val=mean(img_sim(1,:));
Threshold=Y_val;              %���ƶ���ֵ
Impor=[];
for i=1:length(img_sim)
    if(img_sim(i)<Threshold)    %������ƶ�С����ֵ����˵�����һ��ͼ�����ƣ����ж�Ϊ��ͷ�л�֡
        Impor=[Impor,i]; %���֡���
    end;
end;

x3=fopen('incept/Key/key4.txt','w');                 %���ļ� �����ļ�id��  
fprintf(x3,'%d\n',Impor);             %�����������data
fclose(x3);                           %�ر��ļ�