Patient.create!([
  {person_id: 1, deleted_at: nil},
  {person_id: 0, deleted_at: nil},
  {person_id: 2, deleted_at: nil}
])
Person.create!([
  {birthdate: "2000-01-01", gender: "male", deleted_at: nil},
  {birthdate: "2000-01-01", gender: "male", deleted_at: nil},
  {birthdate: "1990-01-01", gender: "female", deleted_at: nil},
  {birthdate: "1990-01-01", gender: "male", deleted_at: nil},
  {birthdate: nil, gender: "female", deleted_at: nil}
])
PersonName.create!([
  {firstname: "Foobar", lastname: "Foo2", person_id: 0, deleted_at: nil},
  {firstname: "Foobar", lastname: "Fooson", person_id: 1, deleted_at: nil},
  {firstname: "Random", lastname: "Hacker", person_id: 2, deleted_at: nil},
  {firstname: "Random", lastname: "Geek", person_id: 3, deleted_at: nil},
  {firstname: "lonely", lastname: "hacker", person_id: 4, deleted_at: nil}
])
PersonalAttribute.create!([
  {value: "121321414132", person_id: 0, personal_attribute_type_id: 0, deleted_at: nil},
  {value: "foobar@foobar.com", person_id: 1, personal_attribute_type_id: 1, deleted_at: nil},
  {value: "lonelyhacker@cathedral.com", person_id: 4, personal_attribute_type_id: 1, deleted_at: nil}
])
PersonalAttributeType.create!([
  {name: "address", deleted_at: nil},
  {name: "email", deleted_at: nil}
])
Privilege.create!([
  {name: "delete", deleted_at: nil},
  {name: "add", deleted_at: nil}
])
Role.create!([
  {rolename: "clerk", deleted_at: nil},
  {rolename: "manager", deleted_at: nil}
])
User.create!([
  {username: "foobar", password: "6ae18bc2dc187e21a57ab212e3742694c346207d", active: true, person_id: 0, deleted_at: nil, salt: "qM2P//BLNi77Z5VSQZ0BndWfS7QeZuXYcscgNVUJ5/bN3vVQOmlk24nGd858Pu0g85SGOTVoOY1Y05WmNchQabLJemF5jjSz6zaOxk4OgCtlDlPlzVBk9PENM30/1utYtOByGOF5xdE6q8WfSyMZMsIWv7+Yzjo95Bmhexk7f3E=", uuid: nil, role_id: 1},
  {username: "barfoo", password: "foobar", active: true, person_id: 1, deleted_at: nil, salt: nil, uuid: nil, role_id: 0},
  {username: "jrhacker", password: "jrhacker", active: true, person_id: 3, deleted_at: nil, salt: nil, uuid: nil, role_id: 0}
])
UserAuth.create!([
  {user_id: nil, token: nil, deleted_at: nil},
  {user_id: nil, token: nil, deleted_at: nil}
])
