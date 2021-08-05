#include <iostream>
#include <algorithm>
#include <queue>
#include <vector>

const int ZERO = 0;

struct TSegment {
    int left;
    int right;
    int index;
    TSegment()
    {
        left = 0;
        right = 0;
        index = -1;
    }
};

void SeekSegments(std::vector<TSegment> &segments, int M) {
    std::vector<TSegment> answer;
    TSegment plug;
    answer.push_back(plug);
    
    while(answer.back().right < M) {
        int rMax = 0;
        int segInd = -1;
        for(int i = 0; i < segments.size(); i++) {
            if(segments[i].left <= answer.back().right && 
               segments[i].right > answer.back().right ) {
                if(segments[i].right > rMax) {
                    rMax = segments[i].right;
                    segInd = i;
                }
            }
        }
        if(segInd == -1) {
            std::cout<<"0\n";
            return;
        }
        else {
            answer.push_back(segments[segInd]);
        }
    }
    
    std::sort(answer.begin(), answer.end(), [](const TSegment &lhs, const TSegment &rhs) {
        return lhs.index < rhs.index;
    });
    std::cout<<answer.size()-1<<"\n";
    for(int i = 1; i < answer.size(); i++) {
        std::cout<<answer[i].left<<" "<<answer[i].right<<"\n";
    }
}

int main() {
    int N, M, L, R;
    
    std::cin>>N;
    std::vector<TSegment> segments(N);
    for(int i = 0; i < N; i++) {
        std::cin>>L>>R;
        segments[i].left= L;
        segments[i].right = R;
        segments[i].index = i;
    }
    std::cin>>M;
    
    SeekSegments(segments, M);
    
    return 0;
}
 
