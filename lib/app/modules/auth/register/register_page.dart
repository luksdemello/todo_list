import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/notifier/todo_list_listener_notifier.dart';
import 'package:todo_list/app/core/ui/theme_extension.dart';
import 'package:todo_list/app/core/validators/validators.dart';
import 'package:todo_list/app/core/widgets/todo_list_field.dart';
import 'package:todo_list/app/core/widgets/todo_list_logo.dart';
import 'package:todo_list/app/modules/auth/register/register_controller.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _confirmPasswordEC = TextEditingController();

  @override
  void initState() {
    final listener = TodoListListenerNotifier(
      changeNotifier: context.read<RegisterController>(),
    );

    listener.listener(
      context: context,
      succesCallback: (notifier, listenerNotifier) {
        listenerNotifier.dispose();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    _confirmPasswordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Todo List',
              style: TextStyle(
                  fontSize: 10, color: context.primaryColor, height: 2),
            ),
            Text(
              'Cadastro',
              style: TextStyle(
                  fontSize: 15, color: context.primaryColor, height: 1),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: ClipOval(
            child: Container(
              color: context.primaryColor.withAlpha(20),
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back_ios_outlined,
                size: 20,
                color: context.primaryColor,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * .5,
            child: const FittedBox(
              fit: BoxFit.fitHeight,
              child: TodoListLogo(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TodoListField(
                    label: 'Email',
                    controller: _emailEC,
                    validator: Validatorless.multiple([
                      Validatorless.required('Email é obrigatório'),
                      Validatorless.email('Email inválido'),
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TodoListField(
                    label: 'Senha',
                    obscureText: true,
                    controller: _passwordEC,
                    validator: Validatorless.multiple([
                      Validatorless.required('Senha é obrigatório'),
                      Validatorless.min(
                        6,
                        'Senha deve ter pelo menos 6 caracteres',
                      ),
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TodoListField(
                    label: 'Confirma Senha',
                    obscureText: true,
                    controller: _confirmPasswordEC,
                    validator: Validatorless.multiple([
                      Validatorless.required('Confirma Senha é obrigatório'),
                      Validators.compare(
                          _passwordEC, 'Senha diferente de Confirma Senha')
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        final formValid =
                            _formKey.currentState?.validate() ?? false;

                        if (formValid) {
                          context.read<RegisterController>().registerUser(
                                email: _emailEC.text,
                                password: _passwordEC.text,
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Salvar'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
