
function ImagePipeLine(name)

    fprintf("\n")
    
    %loading in the image
    img = imread(name);
    img = img(:,:,3);
    subplot(2,2,1)
    imshow(img)
    title('Initial Image')
    
    %%% Image Processing %%%
    disp("Enhancing Image...")
    subplot(2,2,2)
    out = Enhancement(img);
    imshow(out)
    title('Enhanced Image')
    
    disp("Getting Binary Mask...")
    subplot(2,2,3)
    out = GetBinaryMask(out);
    imshow(out)
    title('Binary Mask')
    
    %%% Image Analysis %%%
    disp("Applying Morphology...")
    subplot(2,2,4)
    out = ApplyMorphology(out);
    imshow(out)
    title('Post Morphology')
    
    x = (5);
    fprintf('There are %6.2f starfish. \n',x);
    
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

function out = ApplyMorphology(img)
    disp("--Erroding the Image")
    disp("--Dilating the Image")
    out = img;
end