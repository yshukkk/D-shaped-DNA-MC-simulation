%%lets start by gen dummy video
vobj = VideoWriter('dummyvid','Motion JPEG AVI');
vobj.FrameRate = 24;  %just to be cinematic 
vobj.Quality=100; %no compression
open(vobj); 
figure(1)
for ind = 1:100
    imagesc(mod(repmat(1:512,512,1),mod(ind,512))),colormap gray, axis off, axis equal;
    frame = getframe(1); %get image of whats displayed in the figure
    writeVideo(vobj, frame);
end
%close the object so its no longer tied up by matlab
 close(vobj);
 close(gcf) %close figure since we don't need it anymore
%%open the drone vid 
 inputVid = VideoReader('dummyvid.avi');
 %calculate total number of frames, mostly to show you what data is
 %available in the object.  
 TotnumFrames = round(inputVid.FrameRate*inputVid.Duration);
%%now add stats to it.
%initiate new composite video file
mergedobj = VideoWriter('compositevid','Motion JPEG AVI');
mergedobj.FrameRate = inputVid.FrameRate;  %match same framerate 
mergedobj.Quality=100;
open(mergedobj); 
%start the stitch
hfig = figure;
k = 1; %use for my dummy data
%while loop until there are no more frames
while hasFrame(inputVid)
    %read in frame
    singleFrame = readFrame(inputVid);   
    % display frame
    subplot(1,2,1),imagesc(singleFrame), axis off, axis equal;
    %my gen of dummy data or whatever you want to do
    subplot(1,2,2),plot(k,mean(singleFrame(:)),'.'),hold on;
    title('Average pixel data');
      %grab what the figure looks like
      frame = getframe(hfig);
      %write to file.
      writeVideo(mergedobj, frame);
      %increment k for my dummy data.
      k = k+1;
  end
  %close the object
  close(mergedobj)