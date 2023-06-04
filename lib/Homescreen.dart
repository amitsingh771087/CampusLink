import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'profile.dart';
import 'login.dart';
import 'Create_Post.dart'; // Import the CreatePostPage file

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeContent(),
    SearchContent(),
    CreatePostPage(),
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Do you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                // Perform logout actions and navigate to login.dart
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('CampusLink'),
          automaticallyImplyLeading: _currentIndex != 0,
          actions: [
            IconButton(
              onPressed: _logout,
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}


class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
  // HomeContent();
}
class _HomeContentState extends State<HomeContent> {
  List<Map<String, dynamic>> posts = []; // List to store posts

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data from API when the widget is initialized
  }

  Future<void> fetchData() async {
    var url = Uri.parse('https://campuslinkbackendpost.onrender.com/api/post');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        setState(() {
          posts = List<Map<String, dynamic>>.from(jsonResponse);
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

@override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> post = posts[index];

        String imageBase64 = post['Image'];
        String imageUrl = 'https://campuslinkbackendpost.onrender.com/api/post/:Image';

        // if (imageBase64 != null && imageBase64.isNotEmpty) {
        //   List<int> bytes = base64Decode(imageBase64);
        //   imageUrl = 'data:image/jpg;base64,' + base64Encode(bytes);
        // }


        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 20.0,
                ),
                title: Text(
                  'John Doe',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              imageUrl.isNotEmpty
                  ? Image.memory(
                base64Decode(imageBase64),
                fit: BoxFit.cover,
              )
                  : SizedBox(), // Empty placeholder if image URL is empty
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('Caption:',
                                style: TextStyle(
                                       fontWeight: FontWeight.bold,
                                     ),
                           ),
                           Text(post['Caption'] ?? 'caption'),
        ],
        ),
        ),
                //child: Text(post['Caption'] ?? 'caption'),

              Divider(),
            ],
          ),
        );
      },
    );
}
}

class SearchContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Search Content'),
    );
  }
}

class AddContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostPage()),
          );
        },
        child: Text('Add'),
      ),
    );
  }
}

class LikesContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Likes Content'),
    );
  }
}
