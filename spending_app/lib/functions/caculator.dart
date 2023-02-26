int CheckSignPlus(String money) {
  int lengh = money.length - 1;
  if (money[lengh] == "+") {
    return 0;
  }
  if ((money[lengh] == "-") || (money[lengh] == "x") || (money[lengh] == "/")) {
    return 2;
  }
  return 1;
}

int CheckSignSubtract(String money) {
  int lengh = money.length - 1;
  if (money[lengh] == "-") {
    return 0;
  }
  if ((money[lengh] == "+") || (money[lengh] == "x") || (money[lengh] == "/")) {
    return 2;
  }
  return 1;
}

int CheckSignDevide(String money) {
  int lengh = money.length - 1;
  if (money[lengh] == "/") {
    return 0;
  }
  if ((money[lengh] == "+") || (money[lengh] == "x") || (money[lengh] == "-")) {
    return 2;
  }
  return 1;
}

int CheckSignMutiple(String money) {
  int lengh = money.length - 1;
  if (money[lengh] == "x") {
    return 0;
  }
  if ((money[lengh] == "+") || (money[lengh] == "/") || (money[lengh] == "-")) {
    return 2;
  }
  return 1;
}

String NewMoney(String money) {
  int lengh = money.length - 1;
  String newMoney=money.substring(1,lengh);
  return newMoney;
}
