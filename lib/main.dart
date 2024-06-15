import 'package:flutter/material.dart';

void main() {
  runApp(RoomBookingApp());
}

class RoomBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Room Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(username: _usernameController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String username;

  HomeScreen({required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _searchQuery = "";

  static List<String> availablerooms = [
    'Room A',
    'Room B',
    'Room C',
    'Room 1',
    'Room 2',
    'Room 3',
    'Room 4',
    'Room 5',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      RoomsAvailable(
        availablerooms: availablerooms
            .where((room) => room.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList(),
      ),
      BookedRooms(),
      ProfileScreen(username: widget.username),
    ];

    return Scaffold(
      body: Column(
        children: [
          if (_selectedIndex == 0)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  labelText: 'Search Rooms',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          Expanded(child: _widgetOptions.elementAt(_selectedIndex)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.door_back_door_rounded),
            label: 'Booked Rooms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_sharp),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 73, 235, 232),
        onTap: _onItemTapped,
      ),
    );
  }
}

class RoomsAvailable extends StatefulWidget {
  final List<String> availablerooms;

  RoomsAvailable({Key? key, required this.availablerooms}) : super(key: key);

  @override
  _RoomsAvailableState createState() => _RoomsAvailableState();
}

class _RoomsAvailableState extends State<RoomsAvailable> {
  void _bookRoom(String room) {
    setState(() {
      widget.availablerooms.remove(room);
      BookedRooms.bookedrooms.add(room);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.availablerooms.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(widget.availablerooms[index]),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingScreen(
                  room: widget.availablerooms[index],
                  onBookRoom: _bookRoom,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class BookingScreen extends StatefulWidget {
  final String room;
  final Function(String) onBookRoom;

  BookingScreen({required this.room, required this.onBookRoom});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  void _bookRoom() {
    if (_formKey.currentState!.validate()) {
      widget.onBookRoom(widget.room);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationScreen(
            room: widget.room,
            name: _nameController.text,
            date: _dateController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _bookRoom,
                child: Text('Book Room'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmationScreen extends StatelessWidget {
  final String room;
  final String name;
  final String date;

  ConfirmationScreen({required this.room, required this.name, required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Room: $room'),
              Text('Name: $name'),
              Text('Date: $date'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookedRooms extends StatelessWidget {
  static List<String> bookedrooms = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: bookedrooms.length,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.blue[100],
            child: Center(
              child: Text(
                bookedrooms[index],
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String username;

  ProfileScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Username: $username', style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
