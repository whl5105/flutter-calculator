import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  CalculatorState createState() => CalculatorState();
}

class CalculatorState extends State<Calculator> {
  String display = '0';
  String num1 = '';
  String num2 = '';
  String _operator = '';
  Decimal _result = Decimal.zero;

  // 숫자 버튼을 눌렀을 때 호출되는 함수
  void _onNumberPressed(String number) {
    setState(() {
      if (_operator.isNotEmpty) {
        num2.isEmpty ? display = number : display += number;
        num2 = display;
      } else {
        num1.isEmpty ? display = number : display += number;
        num1 = display;
      }
    });
  }

// 사칙연산 버튼을 눌렀을 때 호출되는 함수
  void _onOperatorPressed(String operator) {
    setState(() {
      // 연산자가 선택되지 않은경우 , 연산자 반영
      if (_operator.isEmpty) {
        _operator = operator;
      } else {
        // 이미 연산자를 선택한 경우, 사칙연산 수행 및 새로운 연산자 갱신
        _calculate();
        _operator = operator;
      }
    });
  }

  void onPercentClick(String value) {
    setState(() {
      if (display == '0') return;

      // * 0.01 연산을 수행하고 결과를 특정 자릿수까지 표시
      _result = Decimal.parse(display) * Decimal.parse('0.01');
      display = _result.toString();
      _operator.isEmpty ? num1 = display : num2 = display;
    });
  }

// '=' 버튼을 눌렀을 때 호출되는 함수
  void _onEqualPressed() {
    _calculate();
    _operator = '';
  }

// 사칙연산 계산을 수행하는 함수
  void _calculate() {
    // num2의 값이 비어있을 경우 num1로 대체

    Decimal decimalNum1 = Decimal.parse(num1);
    Decimal decimalNum2 =
        num2.isEmpty ? Decimal.parse(num1) : Decimal.parse(num2);
    setState(() {
      switch (_operator) {
        case '+':
          _result = decimalNum1 + decimalNum2;
          break;
        case '-':
          _result = decimalNum1 - decimalNum2;
          break;
        case '*':
          _result = decimalNum1 * decimalNum2;
          break;
        case '/':
          // 0으로 나누게 될 경우 오류 처리
          _result = (num2 != '0' && num1 != '0')
              ? Decimal.parse(
                  (decimalNum1.toDouble() / decimalNum2.toDouble()).toString())
              : Decimal.zero;
          break;
        default:
          return;
      }
    });

    display = _result.toString();
    num1 = _result.toString(); // 연산 후 num1 값 반영
    num2 = '';
  }

// 'C' 버튼을 눌렀을 때 호출되는 함수
  void _onClearPressed() {
    setState(() {
      _operator = '';
      _result = Decimal.zero;
      display = '0';
      num1 = '';
      num2 = '';
    });
  }

// '+/-' 버튼을 눌렀을 때 호출되는 함수
  void _onToggleSignPressed() {
    setState(() {
      if (display == '0') return;
      //부호 변경 화면반영
      display = (display.startsWith('-')) ? display.substring(1) : '-$display';
      _operator.isNotEmpty ? num2 = display : num1 = display;
    });
  }

// '.' 버튼을 눌렀을 때 호출되는 함수
  void onDotPressed() {
    setState(() {
      // 현재 값이 이미 소숫점을 포함하거나 연산자를 선택한 경우 종료
      if (display.contains('.')) return;

      //소숫점 화면반영
      display += '.';
      _operator.isNotEmpty ? num2 = display : num1 = display;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Calculator'),
      ),
      body: Column(
        children: [
          // 표시 영역
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Text(
                display,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          // 숫자 및 연산자 버튼 영역
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton('+/-'),
                      buildButton('.'),
                      buildButton('%'),
                    ],
                  ),
                  // 숫자 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton('7'),
                      buildButton('8'),
                      buildButton('9'),
                      buildButton('/'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton('4'),
                      buildButton('5'),
                      buildButton('6'),
                      buildButton('*'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton('1'),
                      buildButton('2'),
                      buildButton('3'),
                      buildButton('-'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton(display == '0' ? 'AC' : 'C'),
                      buildButton('0'),
                      buildButton('='),
                      buildButton('+'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 각 버튼을 생성하는 함수
  Widget buildButton(String text) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: () {
            // 각 버튼에 따라 적절한 함수 호출
            if (text == 'C' || text == 'AC') {
              _onClearPressed();
            } else if (text == '+/-') {
              _onToggleSignPressed();
            } else if (text == '.') {
              onDotPressed();
            } else if (text == '=') {
              _onEqualPressed();
            } else if (text == '+' ||
                text == '-' ||
                text == '*' ||
                text == '/') {
              _onOperatorPressed(text);
            } else if (text == '%') {
              onPercentClick(text);
            } else {
              _onNumberPressed(text);
            }
          },
          style: getButtonStyle(text),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

// 연산자 버튼에 따라 스타일을 동적으로 변경하는 함수
  ButtonStyle getButtonStyle(String text) {
    // 선택한 연산자일 때 배경색을 변경
    bool isSelectedOperator = (_operator == '+' ||
            _operator == '-' ||
            _operator == '*' ||
            _operator == '/') &&
        text == _operator;

    return ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all(isSelectedOperator ? Colors.grey : null),
    );
  }
}
