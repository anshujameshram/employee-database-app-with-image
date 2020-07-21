class Employee {
  int id;
  String name;
  String post;
  int salary;
  String image;

  Employee({this.id, this.name, this.post, this.salary, this.image});

  Employee.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.post = map['post'];
    this.salary = map['salary'];
    this.image = map['image'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map['id'] = this.id;
    map['name'] = this.name;
    map['post'] = this.post;
    map['salary'] = this.salary;
    map['image'] = this.image;

    return map;
  }
}
