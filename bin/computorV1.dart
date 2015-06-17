library computor_v1;

import "dart:io" as io;
import 'dart:async';

import "package:computorV1/equation_analyser/lib.dart" as eq_analyser;

// TODO: Analyse syntaxicale. Coefficient en float.
// TODO: Optimisation du type des nombres.
void main(List<String> args) {
  if (args.length != 1) {
    print("\u{274C} \x1B[0;31m ComputorV1 takes one and only one argument.\x1B[0m");
    io.exitCode = 1;
    return ;
  } else {
    runZoned(() {
      final refined = eq_analyser.refine(eq_analyser.lexer(args.first));
      final reduced_string = eq_analyser.tokenListToString(refined);
      final solution = eq_analyser.solveFromTokenList(refined);
      final string_solution = eq_analyser.solutionToString(solution);
      print('Reduced form: $reduced_string');
      print('Polynomial degree: ${solution['max_degree']}');
      print(string_solution);
      return ;
    }, onError: (_) => print("\u{274C} \x1B[0;31m ComputorV1 got a problem. It's probably your fault.\x1B[0m"));
  }
}