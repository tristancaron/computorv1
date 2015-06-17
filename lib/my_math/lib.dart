library math_lib;

num mySqrt(num input) {
  num a;
  num b = 1;
  num p = 0.00000000000009;
  do {
    a = b;
    b = (1 / 2.0) * (a + input / a);
  } while ((b - a) > p || (a - b) > p);
  return b;
}

num delta(num a, num b, num c) => b * b - 4 * a * c;

List<num>   solveEquationSecondDegree(num a, num b, num c) {
  num d = delta(a, b, c);
  if (d > 0) {
    return [d, ((-b + mySqrt(d)) / (2 * a)), ((-b - mySqrt(d)) / (2 * a))];
  } else if (d < 0) {
    return [d, (-b / (2 * a)), (mySqrt(-d) / (2 * a))];
  } else {
    return [d, (-b / (2 * a))];
  }
}

num solveEquationFirstDegree(num a, num b) => b * -1 / a;

String decimalToFractional(double d) {
  double df = 1.0;
  int top = 1;
  int bot = 1;
  var sw = new Stopwatch()..start();

  while (df != d) {
    if (df < d) {
      top += 1;
    } else {
      bot += 1;
      top = (d * bot).toInt();
    }
    df = top / bot;
    if (sw.elapsedMilliseconds > 100) {
      sw.stop();
      break ;
    }
  }
  if (sw.isRunning) {
    sw.stop();
    return '$top/$bot';
  } else {
    return d.toStringAsPrecision(6);
  }
}

bool  isDouble(num number) => number.toInt().compareTo(number) != 0;