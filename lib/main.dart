import 'package:flutter/material.dart';
import 'package:local_data/db/database_form.dart';
import 'models/contact.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crud operations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Contact _contact = Contact(mobile: '', name: '', id: 0);
  List<Contact> _contacts = [];
  DatabaseForm? _dbForm;

  final _formKey = GlobalKey<FormState>();
  final _ctrlName = TextEditingController();
  final _ctrlMobile = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbForm = DatabaseForm.instace;
    });
    _refreshContactList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
            child: Text(
          "Crud operations",
          style: TextStyle(color: Colors.blue),
        )),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [_form(), _list()],
      )),
    );
  }

  _form() => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _ctrlName,
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (val) => setState(() => _contact.name = val!),
                // validator: (val) =>
                //     (val!.length == 0 ? 'This field is required' : null),
              ),
              TextFormField(
                controller: _ctrlMobile,
                decoration: InputDecoration(labelText: 'Mobile'),
                onSaved: (val) => setState(() => _contact.mobile = val!),
                // validator: (val) =>
                //     (val!.length <= 10 ? 'Atleast 10 digit required' : null),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () => _onSubmit(),
                ),
              )
            ],
          ),
        ),
      );

  _refreshContactList() async {
    List<Contact> x = await _dbForm!.fetchContacts();
    setState(() {
      _contacts = x;

      // print(x);
    });
  }

  _onSubmit() async {
    var form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      print(_contact);
      // print(_contact.name);
      // print(_contact.mobile);

      await _dbForm?.insertContact(_contact);
      if (_contact.id != null) {
        await _dbForm?.insertContact(_contact);
      } else {
        await _dbForm?.updateContact(_contact);
      }
      _refreshContactList();
      resetForm();
    }
  }

  resetForm() {
    setState(() {
      _formKey.currentState?.reset();
      _ctrlName.clear();
      _ctrlMobile.clear();
      _contact.id != null;
    });
  }

  _list() => Expanded(
        child: Card(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      color: Colors.blue,
                      size: 30,
                    ),
                    title: Text(
                      _contacts[index].name.toUpperCase(),
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_contacts[index].mobile),
                    trailing: IconButton(
                        onPressed: () async {
                          await _dbForm?.deleteContact(_contacts[index].id);
                          resetForm();
                          _refreshContactList();
                        },
                        icon: Icon(Icons.delete_sweep)),
                    onTap: () {
                      setState(() {
                        _contact = _contacts[index];
                        _ctrlName.text = _contacts[index].name;
                        _ctrlMobile.text = _contacts[index].mobile;
                      });
                    },
                  ),
                  Divider(
                    height: 2,
                  )
                ],
              );
            },
            itemCount: _contacts.length,
          ),
        ),
      );
}
