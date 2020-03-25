
function ImagePipeLine(name)

    fprintf("\n")
    
    figure(1)
    subplot(3,3,1)
    sgtitle("Image Pipe Line")
    
    %loading in the image
    img = imread(name);
    img = img(:,:,3);
    subplot(3,3,1)
    imshow(img)
    title("Initial Image")
    
    %%% Image Processing %%%
    disp("Enhancing Image...")
    out = Enhancement(img);
    subplot(3,3,2)
    imshow(out)
    title('Enhanced Image')
    
    disp("Getting Binary Mask...")
    out = GetBinaryMask(out);
    subplot(3,3,3)
    imshow(out)
    title('Binary Mask')
    
    
    %%% Image Analysis %%%      
    disp("Applying Morphology...")
    out = ApplyMorphology(out,2);
    subplot(3,3,4)
    imshow(out)
    title("Post Morphology")
    
    disp("Applying Watershed")
    out = WatershedSegment(out, 1);
    figure(1)
    subplot(3,3,5)
    imshow(out)
    title("Watershed Segmentation")
    
    x = (5);
    fprintf("There are %6.2f starfish. \n",x);
    
end


function out = Enhancement(img)

    disp("--Applying Blur...")
    out = MeanBlur(img);
    disp("--Applying equalization...")
    %out = histeq(out);
    out = adapthisteq(out);

end


function out = ExtractFeatures(img)

    disp("Features have been extracted.")
    
end


function out = MeanBlur(img)

    filter = ones(3)/9;
    
    [Height, Width, Chans] = size(img);
    if Chans == 3
        R=img(:, :, 1);
        G=img(:, :, 2);
        B=img(:, :, 3);

        out_r = uint8(conv2(double(R), filter, "valid"));
        out_g = uint8(conv2(double(G), filter, "valid"));
        out_b = uint8(conv2(double(B), filter, "valid"));

        out = cat(3, out_r, out_g, out_b);       
    end
    
    if Chans == 1
        out = uint8(conv2(double(img), filter, "valid"));
    end
    
end


function out = GetBinaryMask(img)

    disp("--Extracting the Initial Mask...")
    [Height, Width, Chans] = size(img);
    if Chans == 3
       img = rgb2gray(img);
    end

    bmask = ~imbinarize(img);

    %imfill
    disp("--Filling in the Holes...")
    CONN = [ 0 1 0; 1 1 1; 0 1 0 ];
    out = imfill(bmask, CONN, 'holes');
    
    disp("--Removing isolated Points")
    out = RemoveIsolated(out);
    
end


function out = RemoveIsolated(bmask)
    %hitmiss
    interval = [-1,0,-1; 0,1,0; -1,0,-1];
    morphed = bwhitmiss(bmask, interval);
    out = bmask - morphed;
end


function out = ApplyMorphology(bmask, loops)

    se = [0,1,0; 1,1,1; 0,1,0];
    out = bmask;
    
    for n = 1:loops
        disp("--Erroding the Image")
        out = imerode(out, se);
        disp("--Dilating the Image")
        out = imdilate(out, se);
    end
    
    disp("--Erroding the Image")
    out = imerode(out, se);
    
    out = RemoveIsolated(out);
    
    for n = 1:loops
        disp("--Erroding the Image")
        out = imerode(out, se);

        disp("--Dilating the Image")
        out = imdilate(out, se);
    end
    
    disp("--Erroding the Image")
    out = imerode(out, se);
    out = RemoveIsolated(out);
    
    
end

function out = WatershedSegment(mask, display)

    disp("Applying Distance Transform...")
    D = bwdist(~mask);
    D_comp = -D;
    
    disp("Applying minimum extend")
    ext_mask = imextendedmin(D_comp,1.5);%was 2
    D2 = imimposemin(D_comp,ext_mask);
    
    disp("Applying Watershed Transform")
    L = watershed(D2);
    seg_mask = mask;
    seg_mask(L == 0) = 0;

    L(~mask) = 0;
    out = label2rgb(L,'jet',[.5 .5 .5]);


    if display == 1
        figure (2)
        subplot(3,3,1)
        imshow(D,[])
        title('Distance Transform of Binary Image')
        subplot(3,3,2)
        imshow(D_comp,[])
        title('Complement of Distance Transform')
        subplot(3,3,3)
        imshowpair(mask,ext_mask,'blend')
        title("Minimum extended overlayed")
        subplot(3,3,4)
        imshow(seg_mask)
        title('Original Mask Segmented')        
        subplot(3,3,5)
        imshow(out)
        title("Watershed Transform")
    end

end

