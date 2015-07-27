/*
 *  GC to PC Chao Converter v1.1
 *  by TheGag96, 2015-07-26
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
  swap(file[0x78], file[0x79]);
  swap(file[0x7A], file[0x7B]);
  swap(file[0x7C], file[0x7D]);
  swap(file[0x7E], file[0x7F]);
  swap(file[0x80], file[0x81]);
  swap(file[0x82], file[0x83]);
  swap(file[0x84], file[0x85]);

  //happiness, age, life1, life2, reincarnations
  swap(file[0xC2], file[0xC3]);
  swap(file[0xC6], file[0xC7]);
  swap(file[0xCA], file[0xCB]);
  swap(file[0xCC], file[0xCD]);
  swap(file[0xCE], file[0xCF]);
  
  //run/power (4-byte reversal)
  swap(file[0xE8], file[0xEB]);
  swap(file[0xE9], file[0xEA]);
  
  //swim/fly (4-byte reversal)
  swap(file[0xEC], file[0xEF]);
  swap(file[0xED], file[0xEE]);
  
  //dark/hero (4-byte reversal)
  swap(file[0xF0], file[0xF3]);
  swap(file[0xF1], file[0xF2]);
  
  //magnitude (4-byte reversal)
  swap(file[0x100], file[0x103]);
  swap(file[0x101], file[0x102]);
  
  //doctor medal
  swap(file[0x148], file[0x149]);
  
  //chao karate wins, losses, and draws
  swap(file[0x150], file[0x151]);
  swap(file[0x152], file[0x153]);
  swap(file[0x154], file[0x155]);
  
  //animal (3-byte reversal)
  swap(file[0x159], file[0x15B]);
  
  //sleepiness, tiredness, hunger, mate, boredom, energy, toys
  swap(file[0x174], file[0x175]);
  swap(file[0x176], file[0x177]);
  swap(file[0x178], file[0x179]);
  swap(file[0x17A], file[0x17B]);
  swap(file[0x17C], file[0x17D]);
  swap(file[0x188], file[0x189]);
  swap(file[0x1A4], file[0x1A5]);
}
