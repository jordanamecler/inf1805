 
const int c = 261;
const int d = 294;
const int e = 329;
const int f = 349;
const int g = 391;
const int gS = 415;
const int a = 440;
const int aS = 455;
const int b = 466;
const int cH = 523;
const int cSH = 554;
const int dH = 587;
const int dSH = 622;
const int eH = 659;
const int fH = 698;
const int fSH = 740;
const int gH = 784;
const int gSH = 830;
const int aH = 880;

int sw_melody[] = {
  a, a, a, f, cH, a, f, cH, a, 0, eH, eH, eH, fH, cH, gS, f, cH, a, 0,
  aH, a, a, aH, gSH, gH, fSH, fH, fSH, 0, aS, dSH, dH, cSH, cH, b, cH, 0,
  f, gS, f, a, cH, a, cH, eH, 0,
  aH, a, a, aH, gSH, gH, fSH, fH, fSH, 0, aS, dSH, dH, cSH, cH, b, cH, 0,
  f, gS, f, cH, a, f, cH, a, 0
};

int sw_tempo[] = {
  500, 500, 500, 350, 150, 500, 350, 150, 650, 500, 500, 500, 500, 350, 150, 500, 350, 150, 650, 500,
  500, 300, 150, 500, 325, 175, 125, 125, 250, 325, 250, 500, 325, 175, 125, 125, 250, 250,
  250, 500, 350, 125, 500, 375, 125, 650, 500,
  500, 300, 150, 500, 325, 175, 125, 125, 250, 325, 250, 500, 325, 175, 125, 125, 250, 250,
  250, 500, 375, 125, 500, 375, 125, 650, 650
};
