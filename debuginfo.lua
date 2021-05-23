--Very useful

print = warn

for _,v in pairs(getgc(true)) do
    if type(v) == "table" and rawget(v, "Name") == "Arrest" then
        print("------------------------------")
        for i2,v2 in pairs(v) do
            print(i2,":",v2)
            if type(v2) == "function" then
                for i3,v3 in pairs(debug.getconstants(v2)) do
                    print("  -",i3,v3)
                end
            elseif type(v2) == "table" then
                for i3, v3 in pairs(v2) do
                    print("  -",i3,v3)
                end
            end
        end
    end
end
