#Det första utkastet av koden som dels inte prioriterar kunderna och kan inte heller ta in mer än en typ av tidsspan. Har inte en "läsbar" output. Är helt enkelt långt ifrån optimerad och inte heller välfungerande, bestämde mig för att "kasta" denna koden och börja om med en ny. (Tog dock med mig många lärdommar av att skriva denna koden.)

def prio(tid_comp, tid)
    i = 0
    while i < tid.length
        j = 1 
        temp = 0
        while j < tid_comp.length
            k = 0
            while k < tid_comp[j].length
                if tid[i] == tid_comp[j][k]
                    temp +=1
                end
                k += 1
            end
            j += 1
        end
        if temp == 0
            return i
        end
        i += 1
    end
    return false
end

def rensa(tid, remove)
    i = 0
    while i < tid.length
        j = 0
        while j < tid[i].length
            if remove == tid[i][j]
            tid[i].delete_at(j)
            end
            j += 1
        end
        i += 1
    end
    tid.delete_at(0)
    return tid
end

def schedule(kund_tider, tider)
    i = 0
    tid = []
    while i < tider.length
        j = 0
        tid_temp = []
        while j < kund_tider.length
            if kund_tider[j][1][i] == tider[i]
                tid_temp << kund_tider[j][0]
            end
            j += 1
        end
        tid << tid_temp
        i += 1
    end
    
    schema = []
    while tid != []
        priority = prio(tid, tid[0])
        if priority == false
            schema << tid[0][0]
            tid = rensa(tid, tid[0][0])
        else
            schema << tid[0][priority]
            tid = rensa(tid, tid[0][priority])
        end
    end
    return schema
end


a = ["a",[0, 1, 2, nil, nil]]
b = ["b", [0, 1, 2, 3, nil]]
c = ["c", [nil, nil, 2, 3, nil]]
d = ["d", [0, 1, nil, nil, nil]]
e = ["e", [nil, nil, 2, 3, 4]]
x = [0, 1, 2, 3, 4]

puts schedule([a, b, c, d, e], x)