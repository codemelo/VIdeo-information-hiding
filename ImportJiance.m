function [Impor_len]=ImportJiance(video)
obj = video;%������Ƶλ��
NOF=obj.NumberOfFrames;% ֡������

for i=1:NOF-1
    img_i =  read(obj,i);  %��ȡ��ͼ��
    j=i+1;
    img_i_plus =  read(obj,j);  %��ȡ��һ��ͼ��
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
Impor_len=length(Impor);