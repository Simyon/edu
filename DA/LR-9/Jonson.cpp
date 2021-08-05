#include <algorithm>
#include <iostream>
#include <limits>
#include <queue>
#include <vector>

const int64_t INF = std::numeric_limits<int64_t>::max();

uint64_t numberVertexes, numberEdges;

struct TEdge {
    uint64_t to;
    int64_t weight;
};

struct TGraph {
    std::vector<int64_t> ways;
    std::vector<std::vector<TEdge>> vertexes;
};

void ReadGraph(TGraph &graph) 
{
    std::cin>>numberVertexes>>numberEdges; 
    
    uint64_t from;
    uint64_t to;
    int64_t weight;
    TEdge pushedEdge;

    graph.vertexes.resize(numberVertexes + 1);
    for(int i = 0; i < numberEdges; ++i) {
        std::cin>>from>>to>>weight;
        pushedEdge.to = --to;
        pushedEdge.weight = weight;
        graph.vertexes[--from].push_back(pushedEdge);
    }
}

void PrintGraph(TGraph &graph) 
{
    for(int i = 0; i <= numberVertexes; i++) {
        for(int j = 0; j < graph.vertexes[i].size(); ++j) {
            std::cout<<(i+1)<<" "<<(graph.vertexes[i][j].to+1)<<" "<<graph.vertexes[i][j].weight<<"\n";
        }
    }
}

void Relax(TGraph &graph) 
{
    for(uint64_t i = 0; i < numberVertexes; ++i) {
        for(uint64_t j = 0; j < graph.vertexes[i].size(); ++j) {
            graph.vertexes[i][j].weight += 
            graph.ways[i] - graph.ways[graph.vertexes[i][j].to];
        }
    }
}

bool BellmanFord(TGraph& graph) {
	graph.ways.resize(++numberVertexes, INF);
	graph.ways[graph.ways.size() - 1] = 0;
	TEdge tmp{0,0};
	for (uint64_t i = 0; i < numberVertexes-1; ++i) {
		tmp.to = i;
		graph.vertexes[numberVertexes-1].push_back(tmp);
	}

	bool changed = false;
	for (uint64_t k = 0; k < numberVertexes; ++k) {
		changed = false;
		for (uint64_t i = 0; i < graph.vertexes.size(); ++i) {
			for (uint64_t j = 0; j < graph.vertexes[i].size(); ++j) {
				if (graph.ways[i] < INF) {
					if (graph.ways[graph.vertexes[i][j].to] >
						graph.ways[i] + graph.vertexes[i][j].weight) {
						graph.ways[graph.vertexes[i][j].to] = graph.ways[i] +
							graph.vertexes[i][j].weight;
						changed = true;
					}
				}
			}
		}
	}
	--numberVertexes;
	graph.vertexes.pop_back();

	return changed;
}

void Djkstra(TGraph &graph, uint64_t start, std::vector<int64_t> &ways) {
    auto cmp = [](const TEdge& lhs, const TEdge& rhs) { return lhs.weight > rhs.weight; };
	std::priority_queue<TEdge, std::vector<TEdge>, decltype(cmp)> priorityQueue(cmp);    
    
    ways.resize(numberVertexes);
    for(uint64_t i = 0; i < numberVertexes; ++i) {
        ways[i] = INF;
    }
    
    ways[start] = 0;
    TEdge nowE{start, 0};
    priorityQueue.push(nowE);
    
    while(not priorityQueue.empty()) {
        const uint64_t nowV = priorityQueue.top().to;
        priorityQueue.pop();
        
        uint64_t relaxV;
        int32_t weight;
        for(std::vector<TEdge>::iterator i = graph.vertexes[nowV].begin(); 
            i != graph.vertexes[nowV].end(); ++i) {
            relaxV = (*i).to;
            weight = (*i).weight;
            
            if(ways[relaxV] > ways[nowV] + weight) {
                ways[relaxV] = ways[nowV] + weight;
                nowE.to = relaxV;
                nowE.weight = ways[relaxV];
                priorityQueue.push(nowE);
            }
        }
    }
}

void WriteAnswer(TGraph &graph) 
{
    std::vector<int64_t> lineAnswerMatrix(numberVertexes);
    int64_t a;
    for(uint64_t i = 0; i < numberVertexes; ++i) {
        Djkstra(graph, i, lineAnswerMatrix);
        
        for(uint64_t j = 0; j <= numberVertexes - 1; j++) {
            if(lineAnswerMatrix[j] == INF) {
                std::cout<<"inf ";
            }
            else {
                a = lineAnswerMatrix[j] - (graph.ways[i] - graph.ways[j]);
                std::cout<<a<<" ";
            }
        }     
            
        std::cout<<"\n";
    }
}

int main() {
    TGraph graph;
    ReadGraph(graph);
    if(BellmanFord(graph)) {
        std::cout << "Negative cycle\n";
        return 0;
    }
    Relax(graph);
    WriteAnswer(graph);
    return 0;
}
