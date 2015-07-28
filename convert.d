/*
 *  GC to PC Chao Converter v1.1
 *  by TheGag96, 2015-07-27
 *  
 *  License: Do whatever you want with it.
 */
 
import std.stdio, std.file, std.algorithm, std.string, std.array;

void main(string[] args) {
  //welcome
  std.stdio.write("=== GC to PC Chao Converter v1.1 by TheGag96 ===\n\n");
  
  //convert each .chao file in the current directory
  foreach (string filename; dirEntries(".", "*.chao", SpanMode.shallow)) {
    //skip if this is a fixed chao
    if (filename.endsWith("_fixed.chao")) continue;
    
    //read in file
    auto chaoFile = cast(ubyte[]) read(filename); 
    string newFilename = filename.replace(".chao", "_fixed.chao");
    
    //convert file (moved to a separate function for clarity)
    writeln("Converting ", filename, " to new file ", newFilename); 
    chaoFile.convert;
    
    //write out converted file
    std.file.write(newFilename, chaoFile);
    if (!newFilename.isFile) writeln("Something went wrong writing the file...");
  }
  
  writeln("\nDone.\n",
          "Now re-import each Chao into Fusion's Chao Editor with their fixed .chao file.\n",
          "Have fun with your migrated Chao!");
  
}

void convert(ref ubyte[] file) {
  //swap swim, fly, run, power, stamina, intelligence, and luck
  file.flip(0x78);
  file.flip(0x7A);
  file.flip(0x7C);
  file.flip(0x7E);
  file.flip(0x80);
  file.flip(0x82);
  file.flip(0x84);

  //happiness, age, life1, life2, reincarnations
  file.flip(0xC2);
  file.flip(0xC6);
  file.flip(0xCA);
  file.flip(0xCC);
  file.flip(0xCE);
  
  //run/power (4-byte reversal)
  file.reverse4(0xE8);
  
  //swim/fly (4-byte reversal)
  file.reverse4(0xEC);
  
  //dark/hero (4-byte reversal)
  file.reverse4(0xF0);
  
  //magnitude (4-byte reversal)
  file.reverse4(0x100);
  
  //doctor medal
  file.flip(0x148);
  
  //chao karate wins, losses, and draws
  file.flip(0x150);
  file.flip(0x152);
  file.flip(0x154);
  
  //animal behaviors (3-byte reversal)
  file.reverse3(0x158);
  
  //sleepiness, tiredness, hunger, mate, boredom, energy, toys
  file.flip(0x174);
  file.flip(0x176);
  file.flip(0x178);
  file.flip(0x17A);
  file.flip(0x17C);
  file.flip(0x188);
  file.flip(0x1A4);
}

void flip(ref ubyte[] file, ulong address) {
  swap(file[address], file[address+1]);
}

void reverse4(ref ubyte[] file, ulong address) {
  swap(file[address], file[address+3]);
  swap(file[address+1], file[address+2]);
}

void reverse3(ref ubyte[] file, ulong address) {
  swap(file[address], file[address+2]);
}
