image = imread('C:\Users\turhal\Desktop\Project1\shapes.png'); %resmin matlaba aktar?lmas?
diff_im = imsubtract(image(:,:,1),rgb2gray(image)); %renk filtresi uygulanmas?
diff_im = medfilt2(diff_im, [3 3]); %resimdeki g�r�lt�n�n azalt?lmas?
diff_im = im2bw(diff_im,0.18); %resimin siyah beyaza d�n�?t�r�lmesi
diff_im = bwareaopen(diff_im,300); %300 pixelden k���k k?s?mlar?n yok say?lmas?
bw = bwlabel(diff_im, 8); 
cc = bwconncomp(bw,4); %objelerin ayr??t?r?lmas?
stats = regionprops(bw, 'BoundingBox', 'Centroid','MajorAxisLength','MinorAxisLength','Area','Extent');
imshow('C:\Users\turhal\Desktop\Project1\shapes.png'); %objelerin �zelliklerinin stats de?i?kenine at?lmas?
trishape=0; % ba?lang?� ��gen say?s?
recshape=0; %ba?lang?� kare say?s?
circshape=0; %ba?lang?� daire say?s?
for o=1:cc.NumObjects %her bir objeyi ayr? analiz etmek i�in d�ng�
    grain = false(size(bw)); %objelerin yerle?tirilece?i binary image boyutunun belirlenmesi
    grain(cc.PixelIdxList{o}) = true; %numaraland?r?lm?? objenin �a??r?lmas?
    bb = stats(o).BoundingBox; %objenin bounding box �zellikleri
    bc = stats(o).Centroid; %objenin merkezi
    d=mean([stats(o).MajorAxisLength stats(o).MinorAxisLength],2); %objenin �ap?
    r=d/2; %objenin yar?�ap?
    area=stats(o).Area ;%objenin alan?;
    A=stats(o).Extent  ;%objenin alan?n?n bounding boxa oran?   
    circularity = ((2*pi*r) .^ 2) ./ (4 * pi * area); %objenin �embersellik de?eri
    bw1=edge(grain,'Roberts'); %kenar dedekt�r� uygulanmas?
    data=corner(bw1); %k�?e noktalar?n?n bulunmas?
    %k�?e nokta koordinatlar?n?n de?i?kenlere atanmas?
    ver1=zeros(1,2);
    ver1(1,1)=data(1,1);
    ver1(1,2)=data(1,2);
    ver2=zeros(1,2);
    ver2(1,1)=data(2,1);
    ver2(1,2)=data(2,2);
    ver3=zeros(1,2);
    ver3(1,1)=data(3,1);
    ver3(1,2)=data(3,2);
    ver4=zeros(1,2);
    ver4(1,1)=data(4,1);
    ver4(1,2)=data(4,2);
     if (0.99<=A)&&(A<=1.05) && (ver1(1)==ver2(1)) && (ver3(1)==ver4(1)) %kare olma ko?ulu, karelerin say?lmas? ve i?aretlenmesi
        rectangle('Position',bb,'EdgeColor','b','LineWidth',2);
        recshape=recshape+1;
         a=text(bc(1),bc(2), strcat('+ Rectangle   ',num2str(recshape)));
    set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
     else if (0.98<=circularity)&&(circularity<=1.05) && (0.75<A)&&(A<0.80) % �ember olma ko?ulu, �emberlerin i?aretlenmesi ve say?lmas?
                 Rmin=30;
    Rmax=600;
    [centersBright, radiiBright] = imfindcircles(diff_im,[Rmin Rmax],'ObjectPolarity','bright');
    [centersDark, radiiDark] = imfindcircles(diff_im,[Rmin Rmax],'ObjectPolarity','dark');
    viscircles(centersBright, radiiBright,'Color','b');
    circshape=circshape+1;
    a=text(bc(1),bc(2), strcat('+ Circle   ',num2str(circshape)));
    set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
         end
     end
    if ((ver3(2)==ver2(2)) && ((A>0.5)&&(A<0.99)||(A>1.05)) && (circularity>1.1) || (circularity<0.99)) || ((ver1(2)==ver2(2)) && ((A>0.5)&&(A<0.99)||(A>1.05)) && (circularity>1.1) || (circularity<0.99)) %��gen olma ko?ullar?, ��genlerin i?aretlenmesi ve say?lmas?
                rectangle('Position',bb,'EdgeColor','b','LineWidth',2);
                trishape=trishape+1;
             a=text(bc(1),bc(2), strcat('+ Triangle   ',num2str(trishape)));
             set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
            end
end
%end
