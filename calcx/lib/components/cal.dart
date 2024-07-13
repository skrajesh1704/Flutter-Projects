import 'package:flutter/material.dart';

class CalculatorHome extends StatefulWidget {
  CalculatorHome({Key? key}) : super(key: key);

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  final List<List<String>> buttonLabels = [
    ['AC', 'X', '%', '/'],
    ['7', '8', '9', '*'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['0', '00', '.', '=']
  ];

  List<String> operands = [];
  List<String> operators = [];
  bool performOperation = false;

  void onPressed(String label) {
    if (label == 'AC') {
      clear();
    } else if (label == 'X') {
      if (operators.isNotEmpty) {
        // Remove the last operator
        operators.removeLast();
      } else if (operands.isNotEmpty) {
        // Remove the last operand
        operands.removeLast();
      }
    } else if (label == '+' || label == '-' || label == '*' || label == '/') {
      if (operands.isNotEmpty && !performOperation) {
        operators.add(label);
        performOperation = true;
      }
    } else if (label == '=') {
      if (operands.isNotEmpty && operators.isNotEmpty) {
        calculateResult();
      }
    } else {
      if (label == '.' && operands.last.contains('.')) {
        return; // Prevent multiple decimal points in the same number
      }
      if (performOperation) {
        operands.add(label);
        performOperation = false;
      } else {
        if (operands.isEmpty || operands.last == '0' && label == '00') {
          operands.add(label);
        } else {
          operands[operands.length - 1] += label;
        }
      }
    }
    setState(() {});
  }

  void clear() {
    operands = [];
    operators = [];
    performOperation = false;
    setState(() {});
  }

  void calculateResult() {
    double result = double.parse(operands[0]);

    for (int i = 0; i < operators.length; i++) {
      double nextValue = double.parse(operands[i + 1]);
      switch (operators[i]) {
        case '+':
          result += nextValue;
          break;
        case '-':
          result -= nextValue;
          break;
        case '*':
          result *= nextValue;
          break;
        case '/':
          result /= nextValue;
          break;
      }
    }

    // Display the result
    operands = [result.toString()];
    operators = [];
    performOperation = false;
    setState(() {});
  }

  Widget buildRow(List<String> labels) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: labels.map((label) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: buildCustomFAB(label, onPressed: () => onPressed(label)),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(51, 51, 51, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // For the Screen Output
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        operands.isEmpty
                            ? '0'
                            : operands.asMap().entries.map((entry) {
                                int index = entry.key;
                                String value = entry.value;
                                return index < operators.length
                                    ? '$value ${operators[index]}'
                                    : value;
                              }).join(' '),
                        style: TextStyle(color: Colors.white, fontSize: 36),
                        textAlign: TextAlign
                            .right, // Ensure text is aligned to the right
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Horizontal line for separation
            const Divider(
              color: Colors.white60,
              thickness: 2,
            ),
            // For the Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: buttonLabels.map((labels) {
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        buildRow(labels),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomFAB(String label, {required VoidCallback onPressed}) {
    return SizedBox(
      width: 80,
      height: 80,
      child: FloatingActionButton(
        onPressed: onPressed,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Color.fromRGBO(51, 51, 51, 1),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
