interface Station {
  id_arret: number;
  lat: number;
  lng: number;
  nom: string;
}

interface Graph {
  [key: string]: { [key: string]: number };
}

export function calculateDistance(station1: Station, station2: Station): number {
  const R = 6371000; // Rayon de la Terre en mètres
  const lat1 = (station1.lat * Math.PI) / 180;
  const lat2 = (station2.lat * Math.PI) / 180;
  const deltaLat = ((station2.lat - station1.lat) * Math.PI) / 180;
  const deltaLng = ((station2.lng - station1.lng) * Math.PI) / 180;

  const a =
    Math.sin(deltaLat / 2) * Math.sin(deltaLat / 2) +
    Math.cos(lat1) * Math.cos(lat2) * Math.sin(deltaLng / 2) * Math.sin(deltaLng / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  return R * c;
}

export function buildGraph(stations: Station[], maxDistance: number = 500): Graph {
  const graph: Graph = {};

  stations.forEach(station1 => {
    graph[station1.nom] = {};
    stations.forEach(station2 => {
      if (station1 !== station2) {
        const distance = calculateDistance(station1, station2);
        if (distance <= maxDistance) {
          graph[station1.nom][station2.nom] = distance;
        }
      }
    });
  });

  return graph;
}

export function dijkstra(graph: Graph, startNode: string, endNode: string): string[] {
  const distances: { [key: string]: number } = {};
  const previous: { [key: string]: string | null } = {};
  const unvisited = new Set<string>();

  // Initialisation
  Object.keys(graph).forEach(node => {
    distances[node] = Infinity;
    previous[node] = null;
    unvisited.add(node);
  });
  distances[startNode] = 0;

  while (unvisited.size > 0) {
    // Trouver le nœud non visité avec la plus petite distance
    const currentNode = Array.from(unvisited).reduce((minNode, node) =>
      distances[node] < distances[minNode] ? node : minNode
    );

    if (currentNode === endNode) break;

    unvisited.delete(currentNode);

    // Mettre à jour les distances des voisins
    Object.entries(graph[currentNode]).forEach(([neighbor, distance]) => {
      if (unvisited.has(neighbor)) {
        const newDistance = distances[currentNode] + distance;
        if (newDistance < distances[neighbor]) {
          distances[neighbor] = newDistance;
          previous[neighbor] = currentNode;
        }
      }
    });
  }

  // Reconstruire le chemin
  const path: string[] = [];
  let current = endNode;
  while (current) {
    path.unshift(current);
    current = previous[current] || null;
  }

  return path;
}

export function clusterStations(stations: Station[], maxDistance: number = 500): Station[][] {
  const clusters: Station[][] = [];
  const visited = new Set<Station>();

  stations.forEach(station => {
    if (!visited.has(station)) {
      const cluster: Station[] = [station];
      visited.add(station);

      stations.forEach(otherStation => {
        if (!visited.has(otherStation) && calculateDistance(station, otherStation) <= maxDistance) {
          cluster.push(otherStation);
          visited.add(otherStation);
        }
      });

      clusters.push(cluster);
    }
  });

  return clusters;
}

export function optimizeRoute(stations: Station[]): Station[] {
  if (stations.length <= 2) return stations;

  const maxDistance = 500; // Max distance between stops
  const clusters = clusterStations(stations, maxDistance);
  const optimizedPath: Station[] = [];

  clusters.forEach(cluster => {
    const graph = buildGraph(cluster, maxDistance);
    const start = cluster[0].nom;
    const end = cluster[cluster.length - 1].nom;

    // Calculate optimal path within the cluster
    const path = dijkstra(graph, start, end);

    // Convert back to Station objects
    const orderedStations = path.map(node => cluster.find(s => s.nom === node)!);
    optimizedPath.push(...orderedStations);
  });

  return optimizedPath;
}
