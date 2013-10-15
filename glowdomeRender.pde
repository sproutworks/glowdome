import processing.video.*;

class GlowdomeRender {
    TestObserver testObserver;

    PImage kinectImage;
    PImage backgroundImage;
    PImage sourceImage;

    float cycle = 0;
    float speed = 1;
    int imageTrace = 0;
    int traceSpeed = 1;
    
    int stripeWidth = 4;
    
    int saturationAdjust = 0;
    
    boolean loadedMovie = false;
    Movie mov;
    
    // kinect variables
    int kw = 640;
    int kh = 480;
    int threshold = 1150;
    
    // point cloud
    int[] depth;
    
    float[] depthLookUp = new float[2048];
    
    float a = 0;

    GlowdomeRender() {
      
    }

    public void setup() {
        colorMode(RGB, 255);

        registry = new DeviceRegistry();
        testObserver = new TestObserver();
        registry.addObserver(testObserver);


        backgroundImage = createImage(width, height, RGB);
        kinectImage = createImage(kw, kh, RGB);
        //backgroundImage = loadImage("crosshatch.jpg");
        sourceImage = loadImage("mountain2.jpg");
        
       
        kinect.enableDepth(true);
        // We don't need the grayscale image in this example
        // so this makes it more efficient
        kinect.processDepthImage(false);
        
        // Lookup table for all possible depth values (0 - 2047)
        for (int i = 0; i < depthLookUp.length; i++) {
          depthLookUp[i] = rawDepthToMeters(i);
        }
    }
    
    public void loadMovie(PApplet sketch) {
        mov = new Movie(sketch, "transit.mov");
        mov.loop();
    }
    
    void render() {

        //cloudtex = createImage(512, 256);

        //cloudtex.loadPixels();

        float xScale, yScale;
        float xPix, yPix;
        float xSrc, ySrc;

        int red;
        int green;
        
        color pixel;

        float pi = 3.14159;
        
        int srcRowOffset;    // offset in pixels to the current row of the source image
        int destRowOffset;  

        boolean xSquare, ySquare;
    
        colorMode(HSB, 255);
    
        for (int y = 0; y < backgroundImage.height; y++) {
            yScale = (float)y / backgroundImage.height;
            //yPix = sin(yScale * pi + pi/2);
            yPix = yScale;
            ySrc = (int)map(yPix, 0, 1, 0, sourceImage.height - 1);
            srcRowOffset = (int)ySrc * sourceImage.width;
            destRowOffset = y * backgroundImage.width;
            for (int x = 0; x < backgroundImage.width; x++) {
                float xOffsetted = (x + cycle) % backgroundImage.width;

                xScale = (float)xOffsetted / backgroundImage.width;

                xPix = (xScale);                

                xSrc = (int)map(xPix, 0, 1, 0, sourceImage.width - 1);

                //ySrc = y;

                int offset = (int)(srcRowOffset + xSrc);

                pixel = sourceImage.pixels[offset];
                
                if (saturationAdjust != 0) {
                  float saturation = saturation(pixel);
                  saturation += saturationAdjust;
                  if (saturation > 255) saturation = 255;
                  
                  pixel = color(hue(pixel), saturation, brightness(pixel));
                }

                backgroundImage.pixels[destRowOffset + x] = pixel;

            }
        }
        
        backgroundImage.updatePixels();
          
        image(backgroundImage, 0, 0, width, height);
        
        cycle += speed;
        
        colorMode(RGB, 255);
    }
    
    void renderImage() {
      image(sourceImage, cycle % backgroundImage.width - backgroundImage.width, 0, 240, 240);
      image(sourceImage, cycle % backgroundImage.width, 0, 240, 240);
      
      cycle += speed;
    }
    


    /**
     * Render a test pattern
     */
    void renderTest(PVector v1) {
        backgroundImage.loadPixels();

        for (int y = 0; y < backgroundImage.height; y++) {

            for (int x = 0; x < backgroundImage.width; x++) {
                float xOffsetted = (x + cycle) % backgroundImage.width;

                int offset = 0;

                int stripe = (int)(y + cycle/2);

                int green = stripe % stripeWidth < stripeWidth/2 ? 255 : 0;
                int blue = (int)(x * 2) % 255;

                backgroundImage.pixels[y * backgroundImage.width + x] = color(0, green, blue);
            }
        }
        backgroundImage.updatePixels();
        cycle += speed;
        cycle = v1.x;
        
        image(backgroundImage, 0, 0);
    }

    void renderMovie() {

        image(mov, 0, 0); 
      
    }
    
    void renderRects() {
      randomSeed(0);
      fill(0, 255, 0);
      int rectHeight;
      for (int i=0; i < width; i++) {
        rectHeight = (int)random(0, height);
        rect(i, 0, 1, rectHeight);
      
      }  
      
    }
    
    void renderText() {
      fill(255, 0, 0);
      textSize(80); 
      text("GlowDome", 0, height/2); 
    }
    
    void renderConsole() {
      textSize(25);
      fill(255, 0, 0);
      text(traceSpeed, 20, height - 30); 
    }
    
    void renderKinect() {
      PImage img = kinect.getVideoImage();
     
      
      kinectImage.loadPixels();
      
      float avgDepth = 0;
    
      for(int x = 0; x < kw; x++) {
        for(int y = 0; y < kh; y++) {
          // mirroring image
          int offset = kw-x-1+y*kw;
          // Raw depth
          int rawDepth = tracker.depth[offset];
  
          avgDepth += rawDepth;
  
          int pix = x+y*kinectImage.width;
          if (rawDepth < threshold) {
            //colourful twin
            colorMode (HSB);
            //kinectImage.pixels[pix] = color(200, 250, 0);
            kinectImage.pixels[pix] = color(rawDepth%360,250,150);
            //println (rawDepth);
          } 
          else {
            //creating the mirrored world
            colorMode (RGB);
            float r = red (img.pixels[pix]);
            float g = green (img.pixels[pix]);
            float b = blue (img.pixels[pix]);
  
            color c = color (r, g, b);
            kinectImage.pixels[pix] = c;
          }
        }
      }
      kinectImage.updatePixels();
  
      avgDepth /= kw * kh;
      
      int depthPixel = (int)map(avgDepth, 0, 2000, 0, 255);
      
      //print(depthPixel +  " ");
      
      fill(depthPixel);
      //rect(0, 0, width, height);
  
      // Draw the image
      //image(kinectImage,0,0, width, height);
      blend(kinectImage, 0, 0, 640, 480, 0, 0, width, height, ADD);   
      
    }
    
    void renderPointCloud() {

      background(0);
      fill(255);
      colorMode(HSB);
      //textMode(SCREEN);
      //text("Kinect FR: " + (int)kinect.getDepthFPS() + "\nProcessing FR: " + (int)frameRate,10,16);
    
      // Get the raw depth as array of integers
      int[] depth = kinect.getRawDepth();
    
      // We're just going to calculate and draw every 4th pixel (equivalent of 160x120)
      int skip = 5;
    
      // Translate and rotate
      translate(width/2,height/2,-50);
      rotateY(a);
    
      for(int x=0; x< kw; x+=skip) {
        for(int y=0; y< kh; y+=skip) {
          int offset = x+y * kw;
    
          // Convert kinect data to world xyz coordinate
          int rawDepth = depth[offset];
          PVector v = depthToWorld(x,y,rawDepth);
    
          //print(rawDepth + " ");
    
          int hue = (int)map(rawDepth, 500, 2100, 0, 255);
    
          stroke(hue, 200, 220);
          pushMatrix();
          // Scale up by 200
          float factor = 200;
          translate(v.x*factor,v.y*factor,factor-v.z*factor);
          // Draw a point
          point(0,0);
          popMatrix();
        }
      }
    
      // Rotate
      a += 0.015f;
    }

    void display() {

        renderConsole();
      
        color c;
        
        if (testObserver.hasStrips) {
            registry.startPushing();
            registry.setAutoThrottle(true);
            int stripNum = 0;
            List<Strip> strips = registry.getStrips();

            if (strips.size() > 0) {
                int yscale = height / strips.size();
                for(Strip strip : strips) {
                    int stripLength = strip.getLength();
                    int xscale = width / stripLength;
                    yscale = height / stripLength;
                    for (int stripY = 0; stripY < stripLength; stripY++) {

                        // interlace the pixel between the strips
                        if (stripY % 2 == stripNum) {  // even led
                            c = get(imageTrace, stripY*yscale);
                            //c = color(255,0,0);
                        } else {    // odd led
                            c = get(imageTrace, stripY*yscale + 1);
                        }
                        //print(stripY);

                        strip.setPixel(c, stripLength - stripY);
                    }
                    stripNum++;
                }
            }
        }
        imageTrace += traceSpeed;

        if (imageTrace > width - 1) imageTrace = 0;
    }


  // These functions come from: http://graphics.stanford.edu/~mdfisher/Kinect.html
float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}

  PVector depthToWorld(int x, int y, int depthValue) {
  
    final double fx_d = 1.0 / 5.9421434211923247e+02;
    final double fy_d = 1.0 / 5.9104053696870778e+02;
    final double cx_d = 3.3930780975300314e+02;
    final double cy_d = 2.4273913761751615e+02;
  
    PVector result = new PVector();
    double depth =  depthLookUp[depthValue];//rawDepthToMeters(depthValue);
    result.x = (float)((x - cx_d) * depth * fx_d);
    result.y = (float)((y - cy_d) * depth * fy_d);
    result.z = (float)(depth);
    return result;
  }
}

