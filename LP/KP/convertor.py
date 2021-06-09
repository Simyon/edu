family_tree = open("family_tree.ged", "r", encoding="utf-8-sig")
rules = open("facts.pl", "w", encoding="utf-8-sig")
rules.write(":- encoding(utf8).\n\n")  # Поддержка кириллици
females = [] 
people = {}  # люди по id
children = {}  # дети

line = family_tree.readline().split()
while line:
    if int(line[0]) != 0 or len(line) < 3: # Пропуск не информативных строчек  
        line = family_tree.readline().split()
        continue

    if line[2] == "INDI":  # Найден человек
        person_id = line[1][2:-1]
        while line[1] != "NAME":  # Поиск по имени
            line = family_tree.readline().split()
        person_name = ' '.join(line[2:5])
        people[person_id] = "'" + person_name + "'"

        while line[1] != "SEX":  # Поиск пола
            line = family_tree.readline().split()
        if line[2] == "F":
            females.append(people[person_id])
        else:
            people[person_id] = people[person_id].translate(str.maketrans('','','/'))
            rules.write("male(" + people[person_id] + ").\n")

    if line[2] == "FAM":  # Найдена семейная ячейка
        father_id = 0
        mother_id = 0

        while line[1] != "HUSB" and line[1] != "WIFE":  # Поиск следующих детей
            line = family_tree.readline().split()

        if line[1] == "HUSB":
            father_id = line[2][2:-1]
            line = family_tree.readline().split()
        if line[1] == "WIFE":
            mother_id = line[2][2:-1]

        while line[1] != "_UID":  # Сканирование описание семьи до конца
            if line[1] == "CHIL":  # Найден ребёнок
                child_id = line[2][2:-1]
                children[people[child_id]] = set()
                if father_id != 0:  # если нет информации об отце пропускаем
                    children[people[child_id]].add(people[father_id])
                if mother_id != 0:  # аналогично для матери
                    children[people[child_id]].add(people[mother_id])
            line = family_tree.readline().split()

    line = family_tree.readline().split()

rules.write("\n")
for female in females:
    female = female.translate(str.maketrans('','','/'))
    rules.write("female(" + female + ").\n")
rules.write("\n")

rules.write("% child(child, parent)\n")
for child, parents in children.items():  # child(child, parent).
    for parent in parents:
        child = child.translate(str.maketrans('','','/'))
        parent = parent.translate(str.maketrans('','','/'))
        rules.write("child(" + child + ", " + parent + ").\n")
rules.write("\n")

family_tree.close()
rules.close()
