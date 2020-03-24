
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
    
    disp("Extracting Features...")
    subplot(2,2,3)
    ExtractFeatures(img);
    imshow(out)
    title('Extracted Features')
    
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
    
    out_r = uint8(conv2(double(R), filter, "same"));
    out_g = uint8(conv2(double(G), filter, "same"));
    out_b = uint8(conv2(double(B), filter, "same"));
    
    out = cat(3, out_r, out_g, out_b);
    
end