insert into users (username , password , enabled) values ( 'test' , '{bcrypt}$2a$10$ISgcO.B/1z9yCnN/XIMcg.cQ3p49dBx3aHhJH1VAMBDCTlzuCaxEe' , true)

insert into users (username , password , enabled) values ( 'admin' , '{bcrypt}$2a$10$Hp62wffNp/dleWm/hBMb6OMbTv0Yu0esRYnV4qb8gpc843nVNf0Gy' , true)

-- each user needs to have at least one role

insert into authorities ( username , authority) values ( 'test' , 'USER')

insert into authorities ( username , authority) values ( 'admin' , 'USER')
insert into authorities ( username , authority) values ( 'admin' , 'ADMIN')