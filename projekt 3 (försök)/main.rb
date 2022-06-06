#Typ helt samma kod som i schedule_maker.rb men returnerar en array tex ["16:00-17:15 (ingen tillgänglig)", "17:15-17:30 Anders", "17:30-17:45 Ellen", "17:45-18:30 Helena", "18:30-18:45 Gustav", ["Anna", "Martin"]] med kundernas tider och en array i slutet med de som inte passade (om det blev kunder över)
#Hade fått inputen från hemsidan så hade behövt att koden skriver om klockslag till träningstidsintervall själv och är även osäker på att retunrnen är optimal för att skriva till hemsidan

def fits(customer, trainer)     #kollar ifall kunden är tillgänglig vid träningstiden (kollar så att alla "kvartar" passar så inte kunden bara får en kvart av sina 45 min inbokad)
    for i in trainer.length - customer[1]...trainer.length
        if customer[2][i] != trainer[i]
            return false
        end
    end
    return true
end

def om_0(h, m)      #Ser till att den första nollan på minuterna i tex 16:05 eller 17:00 kommer med då nollor framför inte finns med i integer
    if m <= 10
        temp = h.to_s + ":0" + m.to_s
    else
        temp = h.to_s + ":" + m.to_s
    end
    return temp
end

def schedule_maker(customers, trainer, start_tid)       #Gör schemat lol
    schedule_temp = []
    while trainer != []
        i = 0
        while i < customers.length
            if fits(customers[i], trainer)      #kollar ifall kunden på index i passar med träningstiden
                for j in 1..customers[i][1]     #lägger in den passande kunden i schemat på så många kvartar som den vill ha och tar bort motsvariga träningstider så det inte blir dubbebokning
                    schedule_temp.insert(0, customers[i][0])
                    trainer.pop
                end
                customers.delete_at(i)      #tar bort kunden då den fått en tid och då inte behöver jämföras med mer
                break
            else
                if customers.length != 1        #Kollar att det finns mer än 1 kund kvar
                    if i == customers.length - 1        #om det är sista kunden i listan tar den bort tiden då ingen kund passar, annars hoppar den bara till nästa kund i listan
                        schedule_temp.insert(0, nil)
                        trainer.pop
                    end
                    i += 1
                else
                    while trainer != []     #Tar bort träningstider om ingen kund kan
                        schedule_temp.insert(0, nil)
                        trainer.pop
                    end
                    break
                end
            end
        end
        if customers.length == 0 && trainer != []       #Tar bort alla kvarblivna tider när alla kunder är slut
            while trainer != []
                schedule_temp.insert(0, nil)
                trainer.pop
            end
        end
    end
    
    if customers.length != 0        #Kollar ifall några kunder finns kvar när träningstillfällena är slut
        did_not_fit = []
        while customers.length != 0     #skriver in alla kvarblivna kunder på en lista
            did_not_fit << customers[0][0]
            customers.delete_at(0)
        end
    end
    
    tid = []
    tid << start_tid[0..1].to_i     #Skriver om "16:15" till [16, 15] för att kunna räknas med
    tid << start_tid[3..4].to_i
    
    schedule = []
    i = 0
    while i < schedule_temp.length      #Skriver starttiden för kunden (börjar när förra slutade)
        temp = om_0(tid[0], tid[1]) + "-"
    
        j = i.dup
        antal = 1
        while j < schedule_temp.length      #Kollar hur många "kvartar" kunden bokat
            if schedule_temp[j] == schedule_temp[j+1]
                antal += 1
            else 
                break
            end
            j += 1
        end
    
        tid[1] += antal * 15
        if tid[1] >= 60     #Förhindrar tider som tex "16:74"
            tid[0] += 1
            tid[1] -= 60
        end

        if schedule_temp[i] == nil      #Olika för när det finns en kund och inte :)
            temp += om_0(tid[0], tid[1]) + " " + "(ingen tillgänglig)"
        else
            temp += om_0(tid[0], tid[1]) + " " + schedule_temp[i]
        end

        schedule << temp
        i += antal
    end
    if did_not_fit != nil
        schedule << did_not_fit
    end
    return schedule
end



#Exempel 1
a = ["Anna", 2, [0, nil, 2, nil, nil, nil, nil, nil, nil, nil, nil]]
b = ["Martin", 4, [0, 1, 2, nil, 4, 5, nil, nil, nil, nil, nil]]
c = ["Helena", 3, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, nil]]
d = ["Gustav", 1, [nil, nil, nil, nil, nil, nil, nil, nil, 8, 9, 10]]
e = ["Ellen", 1, [0, 1, 2, 3, 4, 5, 6, nil, nil, nil, nil]]
f = ["Anders", 1, [0, 1, 2, 3, 4, 5, 6, nil, nil, nil, nil]]
x = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
x_tid = ["16:00", "18:30"] #sluttiden används inte i denna koden men om jag hunnit fixa input från användaren (antingen med gets eller en hemsida) så skulle programmet behöva omvandla intervallet från 16:00 till 18:30 till arrayen [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], dock kod jag inte skrivit ännu. 

schedule_maker([a, b, c, d, e, f], x, x_tid[0])

#Exempel 1 return:
#["16:00-17:15 (ingen tillgänglig)", "17:15-17:30 Anders", "17:30-17:45 Ellen", "17:45-18:30 Helena", "18:30-18:45 Gustav", ["Anna", "Martin"]]


#Exempel 2
a = ["Anna", 2, [0, 1, 2, 3, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]]
b = ["Martin", 3, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, nil, nil, nil, nil, nil, nil, nil, nil]]
c = ["Helena", 3, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, nil, nil, nil, nil, nil]]
d = ["Gustav", 4, [nil, nil, nil, nil, nil, nil, nil, nil, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]]
e = ["Ellen", 1, [0, 1, 2, 3, 4, 5, 6, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]]
f = ["Anders", 3, [0, 1, 2, 3, 4, 5, 6, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]]
g = ["Kai", 2, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, nil, nil, nil, nil, nil, nil, nil]]
h = ["Doris", 2, [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 11, 12, 13, 14, 15, 16, 17]]
i = ["Kexchoklad", 2, [0, 1, 2, 3, 4, 5, 6, nil, nil, nil, nil, nil, 12, 13, 14, 15, 16, 17]]
j = ["Peter", 1, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]]
x = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]
x_tid = ["16:15", "20:45"]

schedule_maker([a, b, c, d, e, f, g, h, i, j], x, x_tid[0])

#Exempel 2 return: 
#["16:15-16:45 Anna", "16:45-17:30 Anders", "17:30-17:45 Ellen", "17:45-18:30 Martin", "18:30-19:15 Helena", "19:15-19:45 Doris", "19:45-20:45 Gustav", ["Kai", "Kexchoklad", "Peter"]]




