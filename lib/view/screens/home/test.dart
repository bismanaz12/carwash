// // // int switchNumber(int num, int a, int b) {
// // //   return (a + b - num);
// // // }

// // // void main() {
// // //   print(switchNumber(5, 5, 7));

// // //   print(switchNumber(7, 5, 7));
// // // }

// // int switchNum(int num) {
// //   var num1 = 5;
// //   var num2 = 7;

// //   return (num1 + num2 - num);
// // }

// // void main() {
// //   print(switchNum(7));
// // }

// // String reverseString(String word) {
// //   return word.split('').reversed.join('');
// // }

// // void main() {
// //   String name = "Shahyk jahan";
// //   String reversed = reverseString(name);
// //   print(reversed);
// // }

// bool isPallindrome(String input) {
//   String cleanedInput = input.replaceAll(' ', '').toLowerCase();
//   String reversedInput = cleanedInput.split('').reversed.join('');
//   return cleanedInput == reversedInput;
// }

// void main() {
//   String str1 = "I am Muhammad Shahyk Jahan";
//   String str2 = "Hello world";
//   String str3 = "111";
//   print(isPallindrome(str1));
//   print(isPallindrome(str2));
//   print(isPallindrome(str3));
// }

import 'dart:ffi';

void longestSubstring(String word) {
  List<String> list = [];

  for (int i = 0; i < word.length; i++) {
    list.add(word[i]);
    int check = 0;
    for (int j = 0; i <= list.length; j++) {
      if (word[i] == list[j]) {
        check++;
      }
    }
    if (check > 0) {
      print("The longest substring was : ${list}");
    }
  }
}

void main() {
  String name = "Shahyk jahan";
  longestSubstring(name);
}
