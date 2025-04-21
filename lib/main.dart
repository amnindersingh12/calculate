import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Don't forget to import the intl package
import 'package:change_app_package_name/change_app_package_name.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DateCalculatorScreen(),
    );
  }
}

class DateCalculatorScreen extends StatefulWidget {
  @override
  _DateCalculatorScreenState createState() => _DateCalculatorScreenState();
}

class _DateCalculatorScreenState extends State<DateCalculatorScreen> {
  TextEditingController _controller = TextEditingController();
  DateTime _selectedDate = DateTime.now(); // Default to the current date
  String _selectedUnit = 'Days'; // Default unit is 'Days'
  String _result = '';

  // Function to calculate the new date based on the selected input
  void _calculateDate() {
    int number = int.tryParse(_controller.text) ?? 0; // Parse the input number
    DateTime calculatedDate;

    switch (_selectedUnit) {
      case 'Weeks':
        calculatedDate =
            _selectedDate.add(Duration(days: number * 7)); // Add weeks
        break;
      case 'Months':
        calculatedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month + number,
          _selectedDate.day,
        ); // Add months
        break;
      case 'Years':
        calculatedDate = DateTime(
          _selectedDate.year + number,
          _selectedDate.month,
          _selectedDate.day,
        ); // Add years
        break;
      default: // 'Days'
        calculatedDate = _selectedDate.add(Duration(days: number)); // Add days
        break;
    }

    setState(() {
      _result =
          'New Date: ${DateFormat('yyyy-MM-dd, EEEE').format(calculatedDate)}'; // Format the new date
      int daysBetween = calculatedDate.difference(DateTime.now()).inDays;
      _result +=
          '\nDays from today: $daysBetween days'; // Show the difference in days
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Date Calculator",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Header for the user input
              Text(
                'Enter the number of Days/Weeks/Months:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Input field for entering the number of days/weeks/months/years
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered

                decoration: InputDecoration(
                  labelText: "Enter number",
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                ),
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),

              // Date picker to select a date
              Text(
                'Select a date:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Selected Date: ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd')
                        .format(_selectedDate), // Display formatted date
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today, color: Colors.blueAccent),
                    onPressed: () async {
                      // Open the date picker
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != _selectedDate) {
                        setState(() {
                          _selectedDate =
                              pickedDate; // Update the selected date
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Dropdown menu for selecting unit (Days, Weeks, Months, Years)
              Text(
                'Select unit(day/week/month) of time:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Center(
                child: DropdownButton<String>(
                  value: _selectedUnit,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedUnit = newValue!; // Update selected unit
                    });
                  },
                  items: <String>['Days', 'Weeks', 'Months', 'Years']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),

              // Button to trigger date calculation
              ElevatedButton(
                onPressed: _calculateDate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Calculate Date',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),

              // Display the result after calculation
              if (_result.isNotEmpty) ...[
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 8)
                    ],
                  ),
                  child: Text(
                    _result,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
