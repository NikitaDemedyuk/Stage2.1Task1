import 'dart:io';

int main() {
  Future myFuture = Future(() {
    print("Hello Future");
  });

  var myFile = File('/Users/nikita/Developer/Hometask/Programming/Dart/Stage 2.1/Task1(Stage2.1)/FizzBizzText.docx');


  print("Main ends");
  return 0;
}