

%Given hemispheric ROIs get average SSD

function [All_Normal_Resids,Large_Dstar_Resids] = Average_SSD(CollatNumber, Day, IVIMScanName,IVIMSlices,Physiostate)


    % example run
    %Average_SSD('13', 'Day1', 'SE02_IVIM_sorted',[21,19,17],'N') 
    
    
    % load IVIM data
    targetpath = ['/Users/neuroimaging/Desktop/DATA/IVIM_PD/IVIM_', CollatNumber];
    IVIMFileName = [targetpath,'/',Day,'/', IVIMScanName,'_2step.mat'];
    Image_Directory = [targetpath,'/',Day,'/', IVIMScanName];

    load(IVIMFileName,'f','Dstar', 'D')
    [~,nx,ny] = size(f);
    
    load([targetpath,'/',Day,'/', 'Hemisphere_ROIs_',IVIMScanName, '.mat'],'LeftHems','RightHems')
    

    % load raw IVIM Data
    dat_list = dir(fullfile(Image_Directory,'IM*'));
    datnames = {dat_list.name}; %read them in the correct order
    datnames = natsortfiles(datnames);
    fname  = fullfile(Image_Directory,dat_list(1).name); %get size of first dicom for reference.
    header = dicominfo(fname);
    Images_Per_Slice = 37;
    Start_Index = 28;
    Num_Bvalues = 10;

    
    Bvalues  = [0 111 222 333 444 556 667 778 889 1000];

    All_Normal_Resids =  [];
    Large_Dstar_Resids = [];
    %figure,
    for slicenum = 1:length(IVIMSlices)
        slice = IVIMSlices(slicenum);
        
        Stacked_Images = StackRawImages(slice,Start_Index, Num_Bvalues,Image_Directory,Images_Per_Slice,datnames,nx,ny);
        
        % sorry for ugly code.
        rows = [];
        cols = [];
        [row,col] = find(squeeze(LeftHems(slicenum,:,:))); %get row and column of the nonzero elements of the masks of slice N
        rows = [rows; row];
        cols = [cols; col];
        [row,col] = find(squeeze(RightHems(slicenum,:,:))); %get row and column of the nonzero elements of the masks of slice N
        rows = [rows; row];
        cols = [cols; col];

        for voxel_num = 1:length(rows) %now for every voxel
            voxel_row = rows(voxel_num);
            voxel_col = cols(voxel_num);

            Signal = double(Stacked_Images(1:Num_Bvalues, voxel_row, voxel_col));
            f_vox = f(slice,voxel_row,voxel_col);
            Dstar_vox = Dstar(slice,voxel_row,voxel_col);
            D_vox = D(slice,voxel_row,voxel_col);
            Residual = SSD_Calc(Signal,f_vox,Dstar_vox,D_vox,Bvalues);

            if f_vox + Dstar_vox + D_vox > 0 
                if Dstar_vox >= .09
                    Large_Dstar_Resids = [Large_Dstar_Resids; Residual];
                else
                    All_Normal_Resids = [All_Normal_Resids; Residual];
                end
            end
            

            %{
            % for visual:

            %plot entire curve
            CBFfit = f_vox*exp(-Bvalues*Dstar_vox)+(1-f_vox)*exp(-Bvalues*D_vox);
            plot(Bvalues,CBFfit,'color', [0.6350 0.0780 0.1840],'LineWidth',3.0)
            hold on

            %plot Diffusion regime
            Dfit = (1-f_vox)*exp(-Bvalues*D_vox); 
            plot(Bvalues,Dfit,'color',[0 0.4470 0.7410],'LineWidth',3.0)
            hold on
            scatter(Bvalues,Signal/Signal(1),70,markerfacecolor = 'black')

            hold off
            pause(1)
            %}

            % debugging trying to figure out the weird zeros
            %{
            if Residual > .5 %so when all are zero?
                disp([f_vox, Dstar_vox, D_vox])
            end
            %}

        end

    end

end



function ImageStack = StackRawImages(slice,Start_Index, Num_Bvalues,Image_Directory,Images_Per_Slice,datnames,nx,ny)
    i1 = Images_Per_Slice*(slice-1)+Start_Index; %37*(1-1)+28 = 28, get starting index
    i2 = i1 +Num_Bvalues-1; %get end index    
    ImageStack = zeros(Num_Bvalues,nx,ny); %because this is one slice, it's a stack [slice, nx,ny] matching the variable images (f, D, etc)
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

end

function Residual = SSD_Calc(Signal,f,Dstar,D,Bvalues)
    %display the residual 
    IVIM = Signal/Signal(1);
    CBFfit_ErrCalc = f*exp(-Bvalues*Dstar)+(1-f)*exp(-Bvalues*D); %to get error calculation of the full bi-exponential fit
    %Residual =  sum(sqrt(abs(IVIM'-CBFfit_ErrCalc)));
    Residual =  sum((abs(IVIM'-CBFfit_ErrCalc).^2));
end
