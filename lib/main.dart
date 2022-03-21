import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart' as path;

class ErrorReadFile {
    String getErrorMessage() {
      return '\nSome problems with reading file...\n';
    }
}

class KeyNumberException implements Exception {
    String getErrorMessage() {
      return "\nIncorrect index\n";
    }
}

Future<int> readFromFileKeyNumber(File filePath) async {
    Stream<String> lines = filePath.openRead()
        .transform(utf8.decoder)         // Decode bytes to UTF-8.
        .transform(LineSplitter());      // Convert stream to individual lines.

    int numberKey = 0;

    try {
      await for (var line in lines) {
        numberKey = int.parse(line);
      }
    } catch (e) {
      stdout.write('Error: $e');
    }
    return numberKey;
}

Future<Map> readFromFileMap(File filePath) async {
  Stream<String> lines = filePath.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());

  Map mapFizzBizzFromFile = Map();

  try {
    await for (String line in lines) {
      mapFizzBizzFromFile.addAll({int.parse(line.substring(5, line.indexOf(','))): line.substring(line.indexOf('u') + 4, line.indexOf(';'))});
    }
  } catch (e) {
    stdout.write('Error: $e');
  }
  return mapFizzBizzFromFile;
}

Future <void> writeToFile(File? filePath, Map mapFizzBizz) async {
  var sink = filePath?.openWrite();
  sink?.write("\n");
  for (var item in mapFizzBizz.entries) {
      //stdout.write("${item.key} ${item.value} \n");
      sink?.write("Key: ${item.key}, Value: ${item.value} \n");
  }
  sink?.write("\n");
  sink?.close();
}

void printMap(Map mapFizzBizz) {
  stdout.write("\n");
  for (var item in mapFizzBizz.entries) {
    //stdout.write("Key: ${item.key}, Value: ${item.value} \n");
    stdout.write("${item.key} ${item.value} \n");
  }
  stdout.write("\n");
}

File normalizePath(String rootPath, String fileName) {
  String filePath = path.join(rootPath, fileName);
  filePath = path.normalize(filePath);
  File filePathToRead = new File(filePath);
  return filePathToRead;
}

Future <int> main() async {

  stdout.write('Program start!\n');
  stdout.write('-------------------------------------------------------------------------------\n');
  stdout.write('Reading map from a file "InputMap.txt"\n');

  final File filePathToRead = normalizePath(Directory.current.parent.path, "InputKeyNumber.txt");
  final File filePathToReadMap = normalizePath(Directory.current.parent.path, "InputMap.txt");

  final keyNumbers =  readFromFileKeyNumber(filePathToRead);

  Map mapFizzBizz = await readFromFileMap(filePathToReadMap);

  try {
    final int numberKey = await keyNumbers;
    stdout.write('\nKey number from file "InputKeyNumber.txt" : $numberKey\n');
    if (numberKey < 1 || numberKey > 100) {
      throw KeyNumberException();
    }
    stdout.write("\nKey: $numberKey, Value: ${mapFizzBizz[numberKey]}\n");
  } on KeyNumberException catch(e) {
    stdout.write('Error: ${e.getErrorMessage()}');
    return 0;
  }

  stdout.write('-------------------------------------------------------------------------------\n');
  
  stdout.write('Writing map to a file "Output.txt"\n');
  final File? filePathToWrite = normalizePath(Directory.current.parent.path, "Output.txt");
  writeToFile(filePathToWrite, mapFizzBizz);

  stdout.write('-------------------------------------------------------------------------------\n');

  stdout.write('End of program\n');
  return 0;
}