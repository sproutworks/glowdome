class YoutopiaRender {
    TestObserver testObserver;

    PImage cloudtex;
    PImage sourceImage;

    float cycle = 0;
    int imageTrace = 0;

    YoutopiaRender() {
      
    }

    public void setup() {
        size(240, 240, P2D);
        frameRate(120);

        registry = new DeviceRegistry();
        testObserver = new TestObserver();
        registry.addObserver(testObserver);

        sourceImage = loadImage("pattern2.png");
        cloudtex = loadImage("crosshatch.jpg");

        colorMode(RGB, 255);

    }

    void render() {

        //cloudtex = createImage(512, 256);

        cloudtex.loadPixels();

        float xScale, yScale;
        float xPix, yPix;
        float xSrc, ySrc;

        int red;
        int green;

        float pi = 3.14159;

        boolean xSquare, ySquare;

        for (int y = 0; y < cloudtex.height; y++) {
            yScale = (float)y/cloudtex.height;
            yPix = sin(yScale * pi);
            //yPix = yScale;
            for (int x = 0; x < cloudtex.width; x++) {
                float xOffsetted = (x + cycle) % cloudtex.width;

                xScale = (float)xOffsetted/cloudtex.width;

                xPix = (xScale);

                xSrc = (int)map(xPix, 0, 1, 0, sourceImage.width-1);

                ySrc = (int)map(-yPix, -1, 1, 0, sourceImage.height-1);

                int offset = (int)(ySrc * sourceImage.width + xSrc);

                cloudtex.pixels[y * cloudtex.width + x] = sourceImage.pixels[offset];

            }
        }
        cloudtex.updatePixels();

        cycle += 5;
    }

    void renderTest() {
        cloudtex.loadPixels();

        for (int y = 0; y < cloudtex.height; y++) {


            for (int x = 0; x < cloudtex.width; x++) {
                float xOffsetted = (x + cycle) % cloudtex.width;


                int offset = 0;

                cloudtex.pixels[y * cloudtex.width + x] = sourceImage.pixels[offset];

            }
        }
        cloudtex.updatePixels();
    }

    void display() {

        //background(0);
        image(cloudtex, 0, 0);
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
                        if (stripY % 2 == 0) {  // even led
                            c = get(imageTrace, stripY*yscale);
                        } else {    // odd led
                            c = get(imageTrace, stripY*yscale + 1);
                        }

                        strip.setPixel(c, stripY);
                    }
                    stripNum++;
                }
            }
        }
        imageTrace++;

        if (imageTrace > width - 1) imageTrace = 0;
    }

}

