import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_calculator/widgets/button_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CalculatorScreens extends StatelessWidget {
  const CalculatorScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black54,
      body: Calculator(), // Calculator 위젯을 호출.
    );
  }
}

//계산기
class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => CalculatorState();
}

class CalculatorState extends State<Calculator> {
  String display = '0';
  String num1 = '';
  String num2 = '';
  String _operator = '';
  Decimal _result = Decimal.zero;

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

  // 숫자 버튼을 눌렀을 때 호출되는 함수
  void _onNumberPressed(String number) {
    setState(() {
      if (_operator.isNotEmpty) {
        // num1이 비었다면
        if (num1.isEmpty) {
          display = number;
          num1 = display;
        } else {
          num2.isEmpty ? display = number : display += number;
          num2 = display;
        }
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
      if (operator != _operator) {
        _operator = operator;
      } else {
        //사칙연산 수행 및 새로운 연산자 갱신
        _calculate();
        _operator = operator;
        num1 = _result.toString(); // 연산 후 num1 값 반영
      }
    });
  }

// '%' 버튼을 눌렀을 때 호출되는 함수
  void _onPercentPressed(String value) {
    setState(() {
      if (display == '0') return;
      // * 0.01 연산을 수행하고 결과를 특정 자릿수까지 표시
      _result = Decimal.parse(display) * Decimal.parse('0.01');
      display = _result.toString();
      _operator.isEmpty ? num1 = display : num2 = display;
    });
  }

// '=' 버튼을 눌렀을 때 호출되는 함수
  void _onResultPressed() {
    _calculate();
    _operator = '';
    num1 = '';
  }

// 사칙연산 계산을 수행하는 함수
  void _calculate() {
    // num1의 값이 비어있을 경우 0으로 대체
    Decimal decimalNum1 = num1.isEmpty ? Decimal.zero : Decimal.parse(num1);
    // num2의 값이 비어있을 경우 num1로 대체
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

    num2 = '';
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
  void _onDotPressed() {
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 입력 숫자
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              alignment: Alignment.bottomRight,
              child: Text(
                display,
                style: const TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ),

        // 입력판
        Container(
          alignment: Alignment.center,
          child: StaggeredGrid.count(
            crossAxisCount: 4,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            children: [
              Button(
                name: num1.isEmpty && num2.isEmpty ? 'AC' : 'C',
                axisSet: const [1, 1],
                bgColor: Colors.grey.shade600,
                onButtonPressed: _onClearPressed,
              ),
              Button(
                name: '+/-',
                axisSet: const [1, 1],
                bgColor: Colors.grey.shade600,
                onButtonPressed: _onToggleSignPressed,
              ),
              Button(
                name: '%',
                axisSet: const [1, 1],
                bgColor: Colors.grey.shade600,
                onButtonPressed: () => _onPercentPressed('%'),
              ),
              Button(
                name: '/',
                axisSet: const [1, 1],
                bgColor: _operator == '/'
                    ? Colors.amber.shade700
                    : Colors.amber.shade600,
                onButtonPressed: () => _onOperatorPressed('/'),
              ),
              Button(
                name: '7',
                axisSet: const [1, 1],
                bgColor: Colors.grey.shade500,
                onButtonPressed: () => _onNumberPressed('7'),
              ),
              Button(
                name: '8',
                axisSet: const [1, 1],
                bgColor: Colors.grey.shade500,
                onButtonPressed: () => _onNumberPressed('8'),
              ),
              Button(
                name: '9',
                axisSet: const [1, 1],
                bgColor: Colors.grey.shade500,
                onButtonPressed: () => _onNumberPressed('9'),
              ),
              Button(
                name: 'X',
                axisSet: const [1, 1],
                bgColor: _operator == 'X'
                    ? Colors.amber.shade800
                    : Colors.amber.shade600,
                onButtonPressed: () => _onOperatorPressed('X'),
              ),
              Button(
                name: '4',
                axisSet: const [1, 1],
                bgColor: Colors.grey.shade500,
                onButtonPressed: () => _onNumberPressed('4'),
              ),
              Button(
                name: '5',
                axisSet: const [1, 1],
                bgColor: Colors.grey.shade500,
                onButtonPressed: () => _onNumberPressed('5'),
              ),
              Button(
                name: '6',
                axisSet: const [1, 1],
                bgColor: Colors.grey.shade500,
                onButtonPressed: () => _onNumberPressed('6'),
              ),
              Button(
                name: '-',
                axisSet: const [1, 1],
                bgColor: _operator == '-'
                    ? Colors.amber.shade700
                    : Colors.amber.shade600,
                onButtonPressed: () => _onOperatorPressed('-'),
              ),
              Button(
                name: '1',
                axisSet: const [1, 1],
                bgColor: Colors.grey.shade500,
                onButtonPressed: () => _onNumberPressed('1'),
              ),
              Button(
                name: '2',
                axisSet: const [1, 1],
                bgColor: Colors.grey.shade500,
                onButtonPressed: () => _onNumberPressed('2'),
              ),
              Button(
                name: '3',
                axisSet: const [1, 1],
                bgColor: Colors.grey.shade500,
                onButtonPressed: () => _onNumberPressed('3'),
              ),
              Button(
                name: '+',
                axisSet: const [1, 1],
                bgColor: _operator == '+'
                    ? Colors.amber.shade700
                    : Colors.amber.shade600,
                onButtonPressed: () => _onOperatorPressed('+'),
              ),
              Button(
                name: '0',
                axisSet: const [2, 1],
                bgColor: Colors.grey.shade500,
                onButtonPressed: () => _onNumberPressed('0'),
              ),
              Button(
                name: '.',
                axisSet: const [1, 1],
                bgColor: Colors.grey.shade500,
                onButtonPressed: _onDotPressed,
              ),
              Button(
                name: '=',
                axisSet: const [1, 1],
                bgColor: Colors.amber.shade600,
                onButtonPressed: _onResultPressed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
