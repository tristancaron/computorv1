part of equation_analyser;

class Token {
  static final RegExp _regexp = new RegExp(
      r'([\+\-\*\/]*\s*)*((\d+(\.\d+)?)?\s*\*?\s*([a-zA-Z])(\^(\d*))?|(\d+(\.\d+)?))');
  String _position;
  String _char;
  int _degree;
  num _value;

  Token(this._value, this._degree, this._position, this._char);

  Token.fromMatch(Match match, this._position) {
    if (match.pattern != regexp) {
      throw new Exception('Bad parameter');
    }
    var oprt = match.group(1);
    oprt = (oprt == null) ? '' : oprt.trim();
    if (match.group(3) != null || match.group(5) != null) {
      var degree = match.group(7);
      _degree = (degree != null) ? int.parse(degree) : 1;
      var value = match.group(3);
      _value = (value != null) ? num.parse('$oprt$value') : 1;
      _char = match.group(5);
    } else {
      _degree = 0;
      _value = num.parse('$oprt${match.group(8)}');
      _char = '';
    }
  }

  void  inverseOperator() {
    _value *= -1;
    _position = 'left';
  }

  Token operator +(Token t) {
    if (_position != t.position) {
      t.inverseOperator();
    }
    return new Token(_value + t.value, _degree, 'left', _char);
  }

  static RegExp get regexp => _regexp;
  String get position => _position;
  int get degree => _degree;
  String get char => _char;
  num get value => _value;

  @override
  String  toString() =>
    '{ value: $_value, char: $_char, degree: $_degree, position: $_position }';
}