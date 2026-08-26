import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// =============================================================================
// MODELO DE DADOS
// =============================================================================
class Task {
  final String id;
  String title;
  String description;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}

// Repositório simples em memória
class TaskRepository {
  static final List<Task> tasks = [
    Task(
      id: '1',
      title: 'Estudar Flutter Web',
      description: 'Revisar GoRouter, Navigator e Diálogos.',
    ),
    Task(
      id: '2',
      title: 'Praticar Dart',
      description: 'Testar manipular listas dinâmicas com setState.',
    ),
  ];
}

// =============================================================================
// AULA 05 - NAVEGAÇÃO COM GOROUTER (Rotas para Web)
// =============================================================================
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        final task = TaskRepository.tasks.firstWhere(
          (t) => t.id == id,
          orElse: () => Task(id: '0', title: 'Não Encontrada', description: ''),
        );
        return TaskDetailGoRouterScreen(task: task);
      },
    ),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Gerenciador de Tarefas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: _router, // AULA 05: Integração do GoRouter no App
    );
  }
}

// =============================================================================
// TELA PRINCIPAL (HOME)
// =============================================================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // AULA 02: Controladores de Entrada
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  // AULA 01: Diálogo para Criar Tarefa
  void _showAddTaskDialog() {
    _titleController.clear();
    _descController.clear();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nova Tarefa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // AULA 02: Entrada de dados (TextField)
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), // AULA 04: Fechando modal via Navigator
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.trim().isNotEmpty) {
                // AULA 02: Processamento dos Dados
                setState(() {
                  TaskRepository.tasks.add(
                    Task(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: _titleController.text,
                      description: _descController.text,
                    ),
                  );
                });

                Navigator.pop(ctx);

                // AULA 01: Feedback Visual (SnackBar)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tarefa adicionada com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  // AULA 01 & 03: EXCLUIR TAREFA COM DIÁLOGO E FEEDBACK (NOVO)
  void _deleteTask(int index) {
    final deletedTask = TaskRepository.tasks[index];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Tarefa'),
        content: Text('Tem certeza que deseja remover "${deletedTask.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                TaskRepository.tasks.removeAt(index);
              });

              // AULA 01: Feedback com opção de "Desfazer"
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tarefa "${deletedTask.title}" removida.'),
                  action: SnackBarAction(
                    label: 'Desfazer',
                    onPressed: () {
                      setState(() {
                        TaskRepository.tasks.insert(index, deletedTask);
                      });
                    },
                  ),
                ),
              );
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  // AULA 04: Navegação entre Telas com NAVIGATOR NATIVO
  void _openEditWithNavigator(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuickEditNavigatorScreen(task: task),
      ),
    ).then((_) => setState(() {})); // Atualiza a tela ao retornar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Tarefas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // AULA 01: Menus na AppBar
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Menu de Opções',
            onSelected: (value) {
              if (value == 'limpar') {
                setState(() {
                  TaskRepository.tasks.clear();
                });
                // AULA 01: Feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Todas as tarefas foram removidas.')),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'limpar',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Limpar Tudo'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      // AULA 03: Exibição de Listas Dinâmicas
      body: TaskRepository.tasks.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma tarefa por aqui!\nClique no botão + para criar uma.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: TaskRepository.tasks.length,
              itemBuilder: (context, index) {
                final task = TaskRepository.tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    // AULA 02: Processamento e Saída de estado
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (val) {
                        setState(() {
                          task.isCompleted = val ?? false;
                        });
                      },
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(
                      task.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // AULA 04: Botão de Editar (Navigator)
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          tooltip: 'Editar (Navigator)',
                          onPressed: () => _openEditWithNavigator(task),
                        ),
                        // AULA 01 & 03: Botão de Deletar (NOVO)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          tooltip: 'Excluir Tarefa',
                          onPressed: () => _deleteTask(index),
                        ),
                        // AULA 05: Botão de Detalhes (GoRouter)
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, size: 18),
                          tooltip: 'Detalhes (GoRouter)',
                          onPressed: () {
                            context.push('/details/${task.id}');
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        tooltip: 'Nova Tarefa',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// =============================================================================
// AULA 04 - TELA DE EDIÇÃO (Abrindo via Navigator)
// =============================================================================
class QuickEditNavigatorScreen extends StatefulWidget {
  final Task task;

  const QuickEditNavigatorScreen({super.key, required this.task});

  @override
  State<QuickEditNavigatorScreen> createState() =>
      _QuickEditNavigatorScreenState();
}

class _QuickEditNavigatorScreenState extends State<QuickEditNavigatorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar (Navigator - Aula 04)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // AULA 02: Entrada -> Processamento
                widget.task.title = _titleController.text;
                widget.task.description = _descController.text;

                // AULA 04: Retornando da tela via Navigator.pop
                Navigator.pop(context);

                // AULA 01: Feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tarefa alterada com sucesso!')),
                );
              },
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// AULA 05 - TELA DE DETALHES (Abrindo via GoRouter)
// =============================================================================
class TaskDetailGoRouterScreen extends StatelessWidget {
  final Task task;

  const TaskDetailGoRouterScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes (GoRouter - Aula 05)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AULA 02: Saída
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    Chip(
                      label: Text(
                        task.isCompleted ? 'Concluída' : 'Pendente',
                        style: TextStyle(
                          color: task.isCompleted ? Colors.green : Colors.orange,
                        ),
                      ),
                    ),
                    const Divider(height: 30),
                    Text(
                      'Descrição:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      task.description.isEmpty
                          ? 'Nenhuma descrição detalhada.'
                          : task.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      // AULA 05: Voltando à home usando context.go() do GoRouter
                      onPressed: () => context.go('/'),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Voltar para Início'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}