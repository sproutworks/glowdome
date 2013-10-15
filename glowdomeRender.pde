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
    int threshold = 950;
    
    int[] depth;

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
          
        image(backgroundImage, 0, 0, 240, 240);
        
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
      textSize(45); 
      text("GlowDome", 0, 60); 
    }
    
    void renderConsole() {
      textSize(15);
      fill(255, 0, 0);
      text(traceSpeed, 0, 200); 
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
                    for (int stripY = 0; stripY < stripLength; stripY++) {

                        // interlace the pixel between the strips
                        if (stripY % 2 == stripNum) {  // even led
                            c = get(imageTrace, stripY * 2);
                            //c = color(255,0,0);
                        } else {    // odd led
                            c = get(imageTrace, stripY * 2 + 1);
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

}

