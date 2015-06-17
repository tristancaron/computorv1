library equation_analyser;

import 'package:computorV1/my_math/lib.dart' as my_math;

part 'token.dart';

List<Token> refine(List<Token> lexed) {
  final List<Token> refined = [];
  for (final token in lexed) {
    final t = refined.firstWhere(
            (el) => el.degree == token.degree && el.char == token.char,
            orElse: () => null);
    if (t == null) {
      if (token.position != 'left') {
        token.inverseOperator();
      }
      refined.add(token);
    } else {
      final index = refined.indexOf(t);
      refined[index] += token;
    }
  }
  return refined;
}

// TODO: Utiliser un vrai buffer.
String tokenListToString(List<Token> lexed) {
  String to_write = '';
  for (final token in lexed) {
    if (token.value == 0) {
      continue ;
    }
    if (token != lexed.first) {
      if (token.value > 0) {
        to_write += ' + ';
      } else {
        to_write += ' - ';
      }
    } else if (token == lexed.first && token.value < 0) {
      to_write += '-';
    }
    if (!(token.value.abs() == 1 && token.degree == 1)) {
      to_write += token.value.abs().toString();
    }
    if (token.degree != 0) {
      to_write += token.char;
      if (token.degree != 1) {
        to_write += '^${token.degree}';
      }
    }
  }
  if (to_write.isEmpty) {
    to_write += '0';
  }
  to_write += ' = 0';
  return to_write;
}

Map<String, num> solveFromTokenList(List<Token> lexed) {
  Map<String, num> result = {};
  Map<int, num> members = {};
  result['max_degree'] = 0;
  for (final token in lexed) {
    result['max_degree'] = result['max_degree'] < token.degree && token.value != 0 ? token.degree : result['max_degree'];
    members[token.degree] = token.value;
  }
  if (result['max_degree'] > 2) {
    return result;
  }
  if (lexed.length == 1 && lexed.first.value == 0) {
    result['all_number'] = 1;
    return result;
  } else if (lexed.length == 1) {
    result['no_solution'] = 1;
    return result;
  }
  result['all_number'] = 0;
  if (result['max_degree'] == 1) {
    result['solution_1'] = my_math.solveEquationFirstDegree(members[1], members[0]);
  } else if (result['max_degree'] == 2) {
    var tmp = my_math.solveEquationSecondDegree(members[2], members[1], members[0]);
    result['delta'] = tmp[0];
    result['solution_1'] = tmp[1];
    if (tmp[0] != 0) {
      result['solution_2'] = tmp[2];
    }
  }
  return result;
}

// TODO: Voir la pertinence pour les fractionels.
String solutionToString(Map<String, num> result) {
  var buffer = new StringBuffer();
  if (result['max_degree'] > 2) {
    buffer.write("Can't resolve eqautions with degrees highter than 2.");
  } else if (result['all_number'] == 1) {
    buffer.write("All real number are solution.");
  } else if (result['no_solution'] == 1) {
    buffer.write("No solution found.");
  } else if (result['max_degree'] == 1) {
    buffer.writeln('The solution is:');
    if (my_math.isDouble(result['solution_1'])) {
      buffer.write(my_math.decimalToFractional(result['solution_1']));
    } else {
      buffer.write(result['solution_1'].toInt().toString());
    }
  } else if (result['max_degree'] == 2) {
    if (result['delta'] > 0) {
      buffer.writeln('Discriminant is strictly positive, the two solutions are:');
      if (my_math.isDouble(result['solution_1'])) {
        buffer.write(my_math.decimalToFractional(result['solution_1']));
      } else {
        buffer.write(result['solution_1'].toInt().toString());
      }
      buffer.writeln();
      if (my_math.isDouble(result['solution_2'])) {
        buffer.write(my_math.decimalToFractional(result['solution_2']));
      } else {
        buffer.write(result['solution_2'].toInt().toString());
      }
    } else if (result['delta'] < 0) {
      String a;
      String b;

      buffer.writeln('Discriminant is strictly negative, the two solutions are:');
      if (my_math.isDouble(result['solution_1'])) {
        buffer.write((a = my_math.decimalToFractional(result['solution_1'])));
      } else {
        buffer.write((a = result['solution_1'].toInt().toString()));
      }
      buffer.write(" + i");
      if (my_math.isDouble(result['solution_2'])) {
        buffer.write((b = my_math.decimalToFractional(result['solution_2'])));
      } else {
        buffer.write((b = result['solution_2'].toInt().toString()));
      }
      buffer.writeln();
      buffer.write("$a - i$b");
    } else {
      buffer.writeln('Discriminant is strictly null, the solution is:');
      if (my_math.isDouble(result['solution_1'])) {
        buffer.write(my_math.decimalToFractional(result['solution_1']));
      } else {
        buffer.write(result['solution_1'].toInt().toString());
      }
    }
  }
  return buffer.toString();
}

// TODO: 0X^3 + 3X^2 + 4 est traite comme une equation de second degre. Optimisation?
List<Token> lexer(String expr) {
  final List<Token> lexed = [];
  final split_sides = expr.split("=");
  final matches_left = Token.regexp.allMatches(split_sides[0]);
  final matches_right = Token.regexp.allMatches(split_sides[1]);
  for (final match in matches_left) {
    lexed.add(new Token.fromMatch(match, 'left'));
    if (lexed.last.value == 0) {
      lexed.removeLast();
    }
  }
  for (final match in matches_right) {
    lexed.add(new Token.fromMatch(match, 'right'));
    if (lexed.last.value == 0) {
      lexed.removeLast();
    }
  }
  return lexed;
}