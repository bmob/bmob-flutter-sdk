void main() {
  helloWorld();
  printNumber(12);
  //字符串单引号
  var name = 'Bob';
  //字符串双引号
  var month = "June";
  //多行字符串单引号
  var paragraph = '''I 
  Love 
  China.''';
  //多行字符串双引号
  var section = """I
  Love
  Chinese.""";
  //整数值
  var age = 18;
  //64位双精度浮点数
  var rate = 1.234;
  //布尔值true
  var fake = true;
  //布尔值false
  var right = false;
  //列表
  var scores = [1, 2, 3];
  //键值对，字符串键
  var gifts = {
    'first': 'partridge',
    'second': 'turtledoves',
    'fifth': 'golden rings'
  };
  //键值对，数值键
  var nobleGases = {
    2: 'helium',
    10: 'neon',
    18: 'argon',
  };
}

//字面量
void helloWorld() {
  print("字面量：hello world");
}

//字符串插值：在字符串字面量中引用变量或者表达式。
void printNumber(num number) {
  print("字符串插值：$number");
}
