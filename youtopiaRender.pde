class YoutopiaRender {
    TestObserver testObserver;

    PImage cloudtex;
    PImage sourceImage;

    float cycle = 0;
    float speed = 1;
    int imageTrace = 0;
    int traceSpeed = 1;
    
    int stripeWidth = 4;

    YoutopiaRender() {
      
    }

    public void setup() {
        size(240, 240, P2D);
        frameRate(60);
        colorMode(RGB, 255);


        registry = new DeviceRegistry();
        testObserver = new TestObserver();
        registry.addObserver(testObserver);

        
        cloudtex = loadImage("crosshatch.jpg");
        sourceImage = loadImage("mountain2.jpg");
        
    }

    void render() {

        //cloudtex = createImage(512, 256);

        //cloudtex.loadPixels();

        float xScale, yScale;
        float xPix, yPix;
        float xSrc, ySrc;

        int red;
        int green;

        float pi = 3.14159;

        boolean xSquare, ySquare;
    
        for (int y = 0; y < cloudtex.height; y++) {
            yScale = (float)y/cloudtex.height;
            //yPix = sin(yScale * pi + pi/2);
            yPix = yScale;
            for (int x = 0; x < cloudtex.width; x++) {
                float xOffsetted = (x + cycle) % cloudtex.width;

                xScale = (float)xOffsetted/cloudtex.width;

                xPix = (xScale);                

                xSrc = (int)map(xPix, 0, 1, 0, sourceImage.width-1);

               // print (xSrc + " ");

                ySrc = (int)map(yPix, 0, 1, 0, sourceImage.height-1);

                //ySrc = y;

                int offset = (int)(ySrc * sourceImage.width + xSrc);

                cloudtex.pixels[y * cloudtex.width + x] = sourceImage.pixels[offset];

            }
        }
        cloudtex.updatePixels();
          
        image(cloudtex, 0, 0, 240, 240);
        
        cycle += speed;
    }
    
    void renderImage() {
      image(sourceImage, cycle % cloudtex.width - cloudtex.width, 0, 240, 240);
      image(sourceImage, cycle % cloudtex.width, 0, 240, 240);
      
      cycle += speed;
    }

    void renderTest() {
        cloudtex.loadPixels();

        for (int y = 0; y <cloudtex.height; y++) {

            for (int x = 0; x < cloudtex.width; x++) {
                float xOffsetted = (x + cycle) % cloudtex.width;

                int offset = 0;

                int stripe = (int)(y + cycle/2);

                int green = stripe % stripeWidth < stripeWidth/2 ? 255 : 0;
                int blue = (int)(x * 2) % 255;

                cloudtex.pixels[y * cloudtex.width + x] = color(0, green, blue);

            }
        }
        cloudtex.updatePixels();
        cycle += speed;
        
        image(cloudtex, 0, 0);
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

