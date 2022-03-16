import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ErrorReadFile {
  String getErrorMessage() {
    return '\nSome problems with reading file...\n';
  }
}

Future<int> readFromFile(File filePath) async {
    Stream <String> lines = filePath.openRead()
        .transform(utf8.decoder)       // Decode bytes to UTF-8.
        .transform(LineSplitter());

    int numberKey = 0;

    try {
      await for (var line in lines) {
        numberKey = int.parse(line);
      }
      print('File is now closed.');
    } catch (e) {
      print('Error: $e');
    }
    return numberKey;
}

Future <void> writeToFile(File filePath) async {
  var sink = filePath.openWrite();
  sink.write('Hello');

  sink.close();
}

Future <int> main() async {
  final filePath = File('/Users/nikita/Developer/Hometask/Programming/Dart/Stage 2.1/Task1(Stage2.1)/Input.txt');

  final int numberKey = await readFromFile(filePath);

  stdout.write(numberKey);

  
  return 0;

}