means = zeros(60,32);
vars = zeros(60,32);

j = 1;
for i=1:60
    means(i,:) = mean(mean(in(Y(i):Y(i)+140, X(i):X(i)+60, :), 2),1);
    if mod(floor((i-1)/3),2) == 1
        continue
    end
    subImg = in([Y(i):Y(i)+140,Y(i+3):Y(i+3)+140], X(i):X(i)+60, :);
    lin = reshape(subImg, size(subImg,1)*size(subImg,2), 32);
    vars(j,:) = var(lin);
    j = j+1;
end

materials(1, :, 1) = (means(25, :) + means(28,:))/2 ; %olovnata beloba cista
materials(2, :, 1) = (means(26, :) + means(29,:))/2 ; %olovnato-cinicita zlut cista
materials(3, :, 1) = (means(27, :) + means(30,:))/2 ; %kostni cern cista
materials(4, :, 1) = (means(39, :) + means(42,:))/2 ; %umbra cista
materials(5, :, 1) = (means(38, :) + means(41,:))/2 ; %zemzelena cista
materials(6, :, 1) = (means(50, :) + means(53,:))/2 ; %medenka cista
materials(7, :, 1) = (means(49, :) + means(52,:))/2 ; %minium ciste
materials(8, :, 1) = (means(37, :) + means(40,:))/2 ; %rumelka cista
materials(9, :, 1) = (means(2, :) + means(5,:))/2 ; %kraplak cisty
materials(10, :, 1) = (means(14, :) + means(17,:))/2 ; %indigo ciste
materials(11, :, 1) = (means(3, :) + means(6,:))/2 ; %ultramarin cisty
materials(12, :, 1) = (means(15, :) + means(18,:))/2 ; %azurit cisty

materials(24, :, 1) = (means(21, :) + means(24,:))/2 ; %azurit + podkresba
materials(23, :, 1) = (means(9, :) + means(12,:))/2 ; %ultramarin + podkresba
materials(22, :, 1) = (means(20, :) + means(23,:))/2 ; %indigo + podkresba
materials(21, :, 1) = (means(8, :) + means(11,:))/2 ; %kraplak + podkresba
materials(20, :, 1) = (means(43, :) + means(46,:))/2 ; %rumelka + podkresba
materials(19, :, 1) = (means(55, :) + means(58,:))/2 ; %minium + podkresba
materials(18, :, 1) = (means(56, :) + means(59,:))/2 ; %medenka + podkresba
materials(17, :, 1) = (means(45, :) + means(48,:))/2 ; %umbra + podkresba
materials(16, :, 1) = (means(44, :) + means(47,:))/2 ; %zemzelena + podkresba
materials(17, :, 1) = (means(44, :) + means(47,:))/2 ; %zemzelena + podkresba
materials(16, :, 1) = (means(45, :) + means(48,:))/2 ; %umbra + podkresba
materials(15, :, 1) = (means(33, :) + means(36,:))/2 ; %kostni cern + podkresba
materials(14, :, 1) = (means(32, :) + means(35,:))/2 ; %olovnato-cinicita zlut + podkresba
materials(13, :, 1) = (means(31, :) + means(34,:))/2 ; %olovnata beloba + podkresba

% rozptyly

materials(1, :, 2) = vars(13, :); %olovnata beloba cista
materials(2, :, 2) = vars(14, :); %olovnato-cinicita zlut cista
materials(3, :, 2) = vars(15, :); %kostni cern cista
materials(4, :, 2) = vars(21, :); %umbra cista
materials(5, :, 2) = vars(20, :); %zemzelena cista
materials(6, :, 2) = vars(26, :); %medenka cista
materials(7, :, 2) = vars(25, :); %minium ciste
materials(8, :, 2) = vars(19, :); %rumelka cista
materials(9, :, 2) = vars(2, :); %kraplak cisty
materials(10, :, 2) = vars(8, :); %indigo ciste
materials(11, :, 2) = vars(3, :); %ultramarin cisty
materials(12, :, 2) = vars(9, :); %azurit cisty

materials(13, :, 2) = vars(16, :); %olovnata beloba + podkresba
materials(14, :, 2) = vars(17, :); %olovnato-cinicita zlut + podkresba
materials(15, :, 2) = vars(18, :); %kostni cern + podkresba
materials(16, :, 2) = vars(24, :); %umbra + podkresba
materials(17, :, 2) = vars(23, :); %zemzelena + podkresba
materials(18, :, 2) = vars(29, :); %medenka + podkresba
materials(19, :, 2) = vars(28, :); %minium + podkresba
materials(20, :, 2) = vars(22, :); %rumelka + podkresba
materials(21, :, 2) = vars(5, :); %kraplak + podkresba
materials(22, :, 2) = vars(11, :); %indigo + podkresba
materials(23, :, 2) = vars(6, :); %ultramarin + podkresba
materials(24, :, 2) = vars(12, :); %azurit + podkresba