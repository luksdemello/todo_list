import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/auth/auth_provider.dart';
import 'package:todo_list/app/core/ui/messages.dart';
import 'package:todo_list/app/core/ui/theme_extension.dart';
import 'package:todo_list/app/services/user/user_service.dart';

class HomeDrawer extends StatelessWidget {
  final nameVN = ValueNotifier<String>('');

  HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.primaryColor.withAlpha(70),
            ),
            child: Row(
              children: [
                Selector<AuthProvider, String>(
                  selector: (context, authProvider) {
                    return authProvider.user?.photoURL ??
                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png';
                  },
                  builder: (_, value, __) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(value),
                      radius: 30,
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Selector<AuthProvider, String>(
                      selector: (context, authProvider) {
                        return authProvider.user?.displayName ??
                            'Não informado';
                      },
                      builder: (_, value, __) {
                        return Text(
                          value,
                          style: context.textTheme.titleSmall,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('Alterar nome'),
                      content: TextField(
                        onChanged: (value) {
                          nameVN.value = value;
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final nameValue = nameVN.value;
                            if (nameValue.isEmpty) {
                              Messages.of(context)
                                  .showError('Preencha um nome');
                            } else {
                              Loader.show(context);
                              await context
                                  .read<UserService>()
                                  .updateDisplayName(nameValue);
                              Loader.hide();
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            }
                          },
                          child: const Text('Alterar'),
                        )
                      ],
                    );
                  });
            },
            title: const Text('Alterar nome'),
          ),
          ListTile(
            title: const Text('Sair'),
            onTap: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
    );
  }
}
