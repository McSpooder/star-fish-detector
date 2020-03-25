
function ImagePipeLine(name)

    fprintf("\n")
    
    %loading in the image
    img = imread(name);
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
    subplot(2,2,4)
    imshow(out)
    title('Bounding Boxes')
    
    x = (5);
    fprintf('There are %6.2f starfish. \n',x);
    
end

function out = Enhancement(img)

    disp("--Applying Blur...")
    out = MeanBlur(img);
    disp("--Applying something else...")

end

function out = ExtractFeatures(img)

    disp("Features have been extracted.")
    
end

function out = MeanBlur(img)

    filter = ones(3)/9;
    R=img(:, :, 1);
    G=img(:, :, 2);
    B=img(:, :, 3);
    
    out_r = uint8(conv2(double(R), filter, "valid"));
    out_g = uint8(conv2(double(G), filter, "valid"));
    out_b = uint8(conv2(double(B), filter, "valid"));
    
    out = cat(3, out_r, out_g, out_b);
    
end

function out = GetBinaryMask(img)

    disp("--Extracting the Initial Mask...")
    img = rgb2gray(img);
    bmask = ~imbinarize(img);

    %imfill
    disp("--Filling in the Holes...")
    CONN = [ 0 1 0; 1 1 1; 0 1 0 ];
    closed = imfill(bmask, CONN, 'holes');

    %hitmiss
    disp("--Getting Isolated Points...")
    interval = [-1,0,-1; 0,1,0; -1,0,-1];
    morphed = bwhitmiss(closed, interval);

    %subtract
    disp("--Subtracting Isolated Points...")
    out = bmask - morphed;
    
end

function out = ApplyMorphology(img)
    

end