#include <iostream>
#include <algorithm>

using namespace std;

const int MAX_INT = 1e7+3;
long long dp[MAX_INT];

int Init(int n) {
    for(int i = 0; i <= n; i++) {
        dp[i] = 0;
    }
    
    return 0;
}

int main() {
    long long sum = 0;
    string answer = "";
    int n;
    cin>>n;
    Init(n);
    for(int i = n; i > 1; i--) {
        sum = dp[i] + i; 
        if(i % 3 == 0) {
            dp[i / 3] = sum;
        }
        if(i % 2 == 0) {
            (dp[i / 2] == 0) ? dp[i / 2] = sum : dp[i / 2] = min(dp[i / 2], sum);
        }
        (dp[i - 1] == 0) ? dp[i - 1] = sum : dp[i - 1] = min(dp[i - 1], sum);
    }
    
    cout<<dp[1]<<"\n";
    
    int i = 1;
    while(i != n) {
        sum = dp[i];
        if( 3 * i <= n && (sum - i * 1ll * 3 ) == dp[3*i] ) {
            answer += " 3/";
            i *= 3;
        }
        else if( 2 * i <= n && (sum - i * 1ll * 2 ) == dp[2*i] ) {
            answer += " 2/";
            i *= 2;
        }
        else if( (sum - i - 1) == dp[i+1]) {
            answer += " 1-";
            i++;
        }    
    }
    
    reverse(answer.begin(), answer.end());
    cout<<answer<<"\n";    
    
    return 0;
}
