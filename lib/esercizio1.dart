class Animal {
  final String name;
  final int age;

  const Animal({required this.name, required this.age});

  void showInfo() => print('${name} ${age}');
  void speak() => print('');
}

class Dog extends Animal {
  final String size;
  const Dog({required super.name, required super.age, required this.size});
  @override
  void showInfo() => print('name: ${name} age:${age} size: ${size}');
  @override
  void speak() => print('bau');
}

class Cat extends Animal {
  final String color;

  const Cat({required super.name, required super.age, required this.color});
  @override
  void showInfo() => print('name: ${name} age: ${age} color: ${color}');
  @override
  void speak() => print('miao');
}

void main() async {
  const micio = Cat(name: 'Macchia', age: 12, color: 'pink');
  const rex = Dog(name: 'Macchio', age: 11, size: 'M');

  for (int i = 1; i <= 3; i++) {
    await Future.delayed(Duration(seconds: 1));
    micio.speak();
    rex.speak();
  }

  await Future.delayed(Duration(seconds: 3));
  micio.showInfo();
  rex.showInfo();
}
