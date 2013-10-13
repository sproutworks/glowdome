import processing.video.*;

class GlowdomeRender {
    TestObserver testObserver;

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

    GlowdomeRender() {
      
    }

    public void setup() {
        colorMode(RGB, 255);

        registry = new DeviceRegistry();
        testObserver = new TestObserver();
        registry.addObserver(testObserver);

        backgroundImage = loadImage("crosshatch.jpg");
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

    void display() {

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

