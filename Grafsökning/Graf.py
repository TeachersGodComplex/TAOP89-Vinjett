import heapq

# -------------------------------------------------------
# Graf som adjacency list
# Lägg till dina egna kanter här: {nod: [(granne, vikt), ...]}
# -------------------------------------------------------
graph = {
    1:  [(3, 19), (2, 18), (7, 13)],
    2:  [(8, 13)],
    3:  [(2, 7), (4, 12)],
    4:  [(2, 10), (5, 13)],
    5:  [(6, 17), (9, 14)],
    6:  [(10, 17), (14, 12)],
    7:  [(8, 17)],
    8:  [(9, 18), (11, 14)],
    9:  [(6, 19), (12, 24)],
    10: [(9, 16), (13, 15)],
    11: [(9, 23)],
    12: [(10, 17), (11, 18)],
    13: [],
    14: [(13, 20)],
}

# -------------------------------------------------------
# Dijkstra – kortaste vägen från start till end
# -------------------------------------------------------
def dijkstra(graph, start, end):
    # Sätt alla avstånd till oändlighet från början
    all_nodes = set(graph.keys())
    dist = {node: float('inf') for node in all_nodes}
    prev = {node: None for node in all_nodes}
    dist[start] = 0

    # Prioritetskö: (kostnad, nod)
    pq = [(0, start)]

    while pq:
        cost, u = heapq.heappop(pq)

        # Hoppa över om vi redan hittat en bättre väg
        if cost > dist[u]:
            continue

        # Avsluta tidigt om vi nått målet
        if u == end:
            break

        # Relaxera grannar
        for v, weight in graph.get(u, []):
            new_cost = dist[u] + weight
            if new_cost < dist[v]:
                dist[v] = new_cost
                prev[v] = u
                heapq.heappush(pq, (new_cost, v))

    # Rekonstruera vägen bakifrån
    path = []
    node = end
    while node is not None:
        path.append(node)
        node = prev[node]
    path.reverse()

    # Kontrollera att en väg faktiskt hittades
    if not path or path[0] != start:
        return None, float('inf')

    return path, dist[end]

# -------------------------------------------------------
# Kör programmet
# -------------------------------------------------------
start = 1
end   = 14

path, cost = dijkstra(graph, start, end)

print("=" * 50)
print(f"Kortaste vägen: nod {start} → nod {end}")
print("=" * 50)

if path is None:
    print(f"Ingen väg hittades från {start} till {end}.")
else:
    print(f"Väg:     {' → '.join(map(str, path))}")
    print(f"Kostnad: {cost}")

print("=" * 50)