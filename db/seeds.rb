# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
privileges = Privilege.create([
    {name: 'edit_user'}, {name: 'view_user'}, {name: 'edit_patient'}, {name: 'view_patient'}
])

edit_user_privilege = Privilege.create(name: 'edit_user')
view_user_privilege = Privilege.create(name: 'view_user')

edit_patient_privilege = Privilege.create(name: 'edit_patient')
view_patient_privilege = Privilege.create(name: 'view_patient')

roles = Role.create([
    {
        rolename: 'Admin',
        privileges: privileges
    },
    {
        rolename: 'Clerk',
        privileges: privileges.slice(3, 2)
    }
])

admin = User.create(
    username: 'admin',
    person: Person.create(
        person_name: PersonName.create(
            firstname: 'Admin',
            lastname: 'Admin'
        ),
        birthdate: Time.now.to_date,
        gender: 'Unknown',
    ),
    role: roles.first
)
admin.set_password 'admin'
admin.save
