%% Creating curves from Infarct from DTI, CSF thresholding via mono-exp, grey matter and white matter
% 10/06/2022 Mira Liu


%% THIS IS MORE JUST STEP-BY-STEP NOTATION/SAVED CODE USED. 
% DON'T ACTUALLY RUN THIS CODE PLEASE. 


% Done initially on Case 17, Day 2, SLICE 25  (Experimental group) 
% Slice 23 for ventricle-only
function Creating_AverageIVIMCurves ()

%{
% First getting the data to get ROIs
load('/Users/neuroimaging/Desktop/DATA/IVIM_PD/IVIM_17/Day2/Scan 68 IVIM_sorted_monoexp.mat', 'Dcsf')
load('/Users/neuroimaging/Desktop/DATA/IVIM_PD/IVIM_17/Day2/Scan 68 IVIM_sorted_2step.mat','f','Dstar','D')
load('/Users/neuroimaging/Desktop/DATA/Penumbras/Case17/DiffusionVolumeAnalysis/DiffusionVolumes_Collat_17.mat', 'infarctData')

% get mono-exp thresholded mask
Dcsf_thresholded = makeThresholdedMask(Dcsf,.001222346916317);

% get fDstar
fDstar = squeeze(f(:,:,:).*Dstar(:,:,:)).*102270;
fDstar_permute = permute(fDstar,[2,3,1]);

% get infarct from DTI thresholding
Infarct = infarctData.masks{1};
Infarct = imresize3(Infarct,[96 96 50]);
Infarct = Infarct>0;

% get DTI image
DTI_Brain = infarctData.pfa{1};
DTI_Brain = imresize3(DTI_Brain,[96 96 50]);

% view coregistration overlay of DTI image and of infarct
View_Coregistration(fDstar_permute,Infarct,'matmat')
View_Coregistration(fDstar_permute,DTI_Brain,'matmat')

%then use Coregister_Infarct in MR_Code DDCorr_Penumbra
Coregister_Infarct(infarctData,fDstar_permute,28,{0,-1},'/Users/neuroimaging/Desktop/')
load('/Users/neuroimaging/Desktop/MD_coregistered.mat')


% now get WM and GM ROIs
imshow(squeeze(D(25,:,:).*Dcsf_thresholded(25,:,:)),[]),truesize([300 300])

% draw WM and GM on Diffusion image
GM = roipoly;
WM = roipoly;


% now save all masks
Dcsfmask = squeeze(Dcsf_thresholded(25,:,:));
Infarctmask = squeeze(Infarct(:,:,25));

save('ROIs_For_Average_IVIM_Curves.mat','Dcsfmask','Infarctmask','WM','GM')

%% Now applying those masks 
%}
load('/Users/neuroimaging/Desktop/MR-Code/Dissertation_Code/ROIs_For_Average_IVIM_Curves.mat','Dcsfmask','GM','Infarctmask','WM','ventricle','brainMask');
Image_Directory = '/Users/neuroimaging/Desktop/DATA/IVIM_PD/IVIM_17/Day2/Scan 68 IVIM_sorted';
dat_list = dir(fullfile(Image_Directory,'IM*'));
datnames = {dat_list.name}; %read them in the correct order
datnames = natsortfiles(datnames);
fname  = fullfile(Image_Directory,dat_list(1).name); %get size of first dicom for reference.
header = dicominfo(fname);
nx = header.Height;
ny = header.Width;
Images_Per_Slice = 37;
Start_Index = 28;

Num_Bvalues = 10;
Bvalues = [0, 111, 222, 333, 444, 556, 667, 778, 889, 1000];
slice = 25;
%then get masks (where the masks are both the masks minus the Dcsfmask.
% so for example GM mask is the GM mask minus the DSC mask that's > 0 . 
Dcsf_mask = Dcsfmask.*brainMask; %need to make sure it's only in the brain!
Infarct_mask = (Infarctmask-Dcsfmask)>0;
GM_mask = (GM - Dcsfmask) > 0;
WM_mask = (WM - Dcsfmask) > 0;
ventricle_mask = ventricle;


CSF_sig = getAvergeROI(Image_Directory,Images_Per_Slice,Start_Index,nx,ny,Num_Bvalues,datnames,slice,Dcsf_mask);
Infarct_sig = getAvergeROI(Image_Directory,Images_Per_Slice,Start_Index,nx,ny,Num_Bvalues,datnames,slice,Infarct_mask);
GM_sig = getAvergeROI(Image_Directory,Images_Per_Slice,Start_Index,nx,ny,Num_Bvalues,datnames,slice,GM_mask);
WM_sig = getAvergeROI(Image_Directory,Images_Per_Slice,Start_Index,nx,ny,Num_Bvalues,datnames,slice,WM_mask);
% note ventricle was on slice 23, not 25
Ventricle_sig = getAvergeROI(Image_Directory,Images_Per_Slice,Start_Index,nx,ny,Num_Bvalues,datnames,23,ventricle_mask);


% no norm
%{
figure,
plot(Bvalues,CSF_sig,LineWidth=3.0,Color=[0.9290 0.6940 0.1250]) %CSF is yelow
hold on
scatter(Bvalues,CSF_sig,70,markerfacecolor = "black")
hold on
plot(Bvalues,Infarct_sig,LineWidth=3.0,Color=[0.6350 0.0780 0.1840]) %Infarct is red
hold on
scatter(Bvalues,Infarct_sig,70,markerfacecolor = "black")
hold on
plot(Bvalues,GM_sig,LineWidth=3.0,Color=[0.4660 0.6740 0.1880]) %GM is green
hold on
scatter(Bvalues,GM_sig,70,markerfacecolor = "black")
hold on
plot(Bvalues,WM_sig,LineWidth=3.0,Color=[0 0.4470 0.7410]) %WM is blue
hold on
scatter(Bvalues,WM_sig,70,markerfacecolor = "black")
hold off
legend('CSF','','Infarct','','WM','','GM',''),set(legend,'fontsize',15)
xlabel('b-value (s/mm^2)',FontSize=25)
%}

% normed to b = 1000
norm_to = 10;
figure,
plot(Bvalues,CSF_sig/CSF_sig(norm_to),LineWidth=3.0,Color=[0.9290 0.6940 0.1250]) %CSF is yelow
hold on
scatter(Bvalues,CSF_sig/CSF_sig(norm_to),70,markerfacecolor = "black")
hold on
plot(Bvalues,GM_sig/GM_sig(norm_to),LineWidth=3.0,Color=[0.4660 0.6740 0.1880]) %GM is green
hold on
scatter(Bvalues,GM_sig/GM_sig(norm_to),70,markerfacecolor = "black")
hold on
plot(Bvalues,WM_sig/WM_sig(norm_to),LineWidth=3.0,Color=[0 0.4470 0.7410]) %WM is blue
hold on
scatter(Bvalues,WM_sig/WM_sig(norm_to),70,markerfacecolor = "black")
hold on
plot(Bvalues,Infarct_sig/Infarct_sig(norm_to),LineWidth=3.0,Color=[0.6350 0.0780 0.1840]) %Infarct is red
hold on
scatter(Bvalues,Infarct_sig/Infarct_sig(norm_to),70,markerfacecolor = "black")
hold on
plot(Bvalues,Ventricle_sig/Ventricle_sig(norm_to),LineWidth=3.0,Color=[0.3010 0.7450 0.9330]) %ventricle is cyan
hold on
scatter(Bvalues,Ventricle_sig/Ventricle_sig(norm_to),70,markerfacecolor = "black")
hold off
legend('CSF','','GM','','WM','','Infarct','','Ventricle',''),set(legend,'fontsize',15)
xlabel('b-value (s/mm^2)',FontSize=25)


%% Now save all the values in an excel sheet


listed = [CSF_sig,Infarct_sig,GM_sig,WM_sig,Ventricle_sig];

savefilename = '/Users/neuroimaging/Desktop/MR-Code/Dissertation_Code/AverageIVIMCUrves.xlsx';
writematrix(listed,savefilename,'Sheet',1)
end



%nested function below
function Signal = getAvergeROI(Image_Directory,Images_Per_Slice,Start_Index,nx,ny,Num_Bvalues,datnames,slice,ROI)
    %now having loaded (or drawn) an ROI, get average IVIM curve of that ROI
    i1 = Images_Per_Slice*(slice-1)+Start_Index; %37*(1-1)+28 = 28, get starting index
    i2 = i1 + Num_Bvalues-1; %get end index
    ImageStack = zeros(Num_Bvalues,nx,ny);
    %now create the entire stack of images (one one slice) stacked across all b values
    jj = 1; %which b value
    %assuming Zfilter = 1
    w2 = 0.20; 
    w1 = 0.20; 
    w0 = 0.20; 
    for i= i1:i2
        fname_im2 = fullfile(Image_Directory,char(datnames(i-2*(Images_Per_Slice))));
        fname_im1 = fullfile(Image_Directory,char(datnames(i-1*(Images_Per_Slice))));
        fname_im0 = fullfile(Image_Directory,char(datnames(i-0*(Images_Per_Slice)))); % center slice
        fname_ip1 = fullfile(Image_Directory,char(datnames(i+1*(Images_Per_Slice))));
        fname_ip2 = fullfile(Image_Directory,char(datnames(i+2*(Images_Per_Slice))));
        ImageStack(jj,:,:)= w2*double(dicomread(fname_im2)) +           ...   
                        w1*double(dicomread(fname_im1)) +           ... 
                        w0*double(dicomread(fname_im0)) +           ... 
                        w1*double(dicomread(fname_ip1)) +           ... 
                        w2*double(dicomread(fname_ip2));
        jj= jj+1;
    end
    
    %get average of ROI for each b-value
    Signal = zeros(Num_Bvalues,1);
    for i = 1:Num_Bvalues
        BvalImage = squeeze(ImageStack(i,:,:));
        ROId_average = mean(BvalImage(logical(ROI)));
        Signal(i) = ROId_average;
    end
end