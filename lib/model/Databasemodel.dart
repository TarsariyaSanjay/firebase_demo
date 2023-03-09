class UsersData {
  String? name;
  String? age;

  UsersData({
    required this.name,
    required this.age,
});

  UsersData.fromMap(Map<String,dynamic> map){
      name = map['name'];
      age = map['map'];
  }


  Map<String,dynamic> toMap() => {
     'name' : name,
      'age' : age,

  };


}