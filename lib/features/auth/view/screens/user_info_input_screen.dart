import 'package:connect/core/widgets/buttons/submit_button.dart';
import 'package:flutter/material.dart';


import '../../../../core/widgets/buttons/back_button.dart';
import '../../widgets/headline.dart';


class UserInfoInputScreen extends StatefulWidget {
  const UserInfoInputScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoInputScreen> createState() => _UserInfoInputScreenState();
}

class _UserInfoInputScreenState extends State<UserInfoInputScreen> {
  // Form Key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _userHandleController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const CustomBackButton(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Headline(
                headline: 'Start Your Profile',
                sub_headline: 'This is how you’re displayed in the community',
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xffF1F1F1),
                    radius: 50,
                    child: Icon(Icons.person, size: 70, color: Color(0xffB3B3B3)),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _userNameController,
                          decoration: InputDecoration(
                            labelText: 'User Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),

                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name is required.';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _userHandleController,
                          decoration: InputDecoration(
                            labelText: 'Handle',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefixIcon: const Icon(Icons.lock),
                          ),

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Handle is required';
                            }


                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: SubmitButton(
                  isEnabled: true,
                  onSubmit: (){

                  },
                )
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
