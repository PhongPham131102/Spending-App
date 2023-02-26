String ConvertToVND(int number) {
  if (number < 1000) {
    return number.toString() + 'đ';
  } else if (number >= 1000 && number <= 999999) {
    return (number / 1000).toStringAsFixed(0) + 'k';
  } else if (number >= 1000000 && number <= 999999999) {
    return (number / 1000000).toStringAsFixed(0) + 'tr';
  } else {
    return (number / 1000000000).toStringAsFixed(0) + 'tỷ';
  }
}
