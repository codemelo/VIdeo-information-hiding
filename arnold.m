%img �Ҷ�ͼ�� a,bΪ���� nΪ�任����
function arnoldImg = arnold(img,n)
[h,w] = size(img);
N=h;
arnoldImg = zeros(h,w);
for i=1:n
    for y=1:h
        for x=1:w
            %��ֹȡ������г��ִ����Ȱ�����ϵ�任�ɴ�0 �� N-1
            xx=mod((x-1)+1*(y-1),N)+1;
            yy=mod(1*(x-1)+(1*1+1)*(y-1),N)+1;  
            arnoldImg(yy,xx)=img(y,x);              
        end
    end
    img=arnoldImg;
end
arnoldImg = uint8(arnoldImg);
end