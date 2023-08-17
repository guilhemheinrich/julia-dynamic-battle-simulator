function damage_tick(populationA, damageA, surfaceAtoB, populationB, damageB, surfaceBtoA)
    damageAtoB = min(ceil(populationA), surfaceAtoB) * damageA
    damageBtoA = min(ceil(populationB), surfaceBtoA) * damageB
    return [("damageAtoB" => damageAtoB), ("damageBtoA" => damageBtoA)]
end

function battle(round, initial_population_A::Float64, damageA::Float64, surfaceAtoB, initial_population_B::Float64, damageB::Float64, surfaceBtoA)
    population = [initial_population_A, initial_population_B]
    for i in Base.OneTo(round)
        damage = damage_tick(population[1], damageA, surfaceAtoB, population[2], damageB, surfaceBtoA)
        population[1] = population[1] - damage[2][2]
        population[2] = population[2] - damage[1][2]
        print(population)
    end
    return population
end

function battle_to_death(initial_population_A::Float64, damageA::Float64, surfaceAtoB, initial_population_B::Float64, damageB::Float64, surfaceBtoA)
    population = [initial_population_A, initial_population_B]
    round = 0
    while ((population[1] > 0) && (population[2] > 0))
        damage = damage_tick(population[1], damageA, surfaceAtoB, population[2], damageB, surfaceBtoA)
        population[1] = population[1] - damage[2][2]
        population[2] = population[2] - damage[1][2]
        print(string("round: ", round, " population: ", population))
        print("\n")
        round += 1
    end
    return Dict("population" => population, "round" => round)
end

damage = damage_tick(10, 0.1, 10, 5, 0.3, 10)
# battle(10, 10.0, 0.1, 10, 5.0, 0.3, 10)
battle_result = battle_to_death(10.0, 0.1, 10, 5.0, 0.3, 10)

if battle_result["population"][1] > 0 && battle_result["population"][2] <= 0
    print(string("Population A win in ", battle_result["round"], " round(s) with ", battle_result["population"][1], " population left\n"))
end

if battle_result["population"][2] > 0 && battle_result["population"][1] <= 0
    print(string("Population B win in ", battle_result["round"], " round(s) with ", battle_result["population"][2], " population left\n"))
end