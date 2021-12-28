#include "for.h"
#define playerNumbers 5
#define shuffle 4
byte turn=0;
bool isShuffle=false;
bool EndShuffle=false;
typedef PlayerCards { 
    byte Cards[4]={4,4,4,4}
};
PlayerCards _playerCards[playerNumbers];

active proctype Dealer(){

    byte _shuffle=shuffle;

    printf("________________________________________________\n");
    printf("Dealer started giving the cards to the players.\n");

    byte p=playerNumbers-1;
    byte q=0;
    for(k,0,p)
        for(j,0,3)
            Select0: select ( q : 0 .. 3);
            if
                ::(j==0) -> {_playerCards[k].Cards[j]=q; }
                ::(j!=0)-> {
                        for(l,0,j)
                            if
                                ::(_playerCards[k].Cards[l]==q) -> {goto Select0;}
                                ::(_playerCards[k].Cards[l]!=q) -> skip;
                            fi;
                        rof(l)
                        _playerCards[k].Cards[j]=q;
                    }
            fi;
        rof(j)
    rof(k)

    for(n,0,p)
        printf("Player %d Cards:",n);
        for(m,0,3)
            printf(" %d",_playerCards[n].Cards[m]);
        rof(m)
        printf("\n");
    rof(n)

    printf("*******************Game Start*******************\n");

    atomic{
        for(i,1,playerNumbers)
            run Player();
        rof(i)
    }

    Select1: select ( q : 0 .. 1);
    if
        ::(q==0) -> { goto Select1;}
        ::(q==1 && _shuffle!=0) -> { _shuffle=_shuffle-1; goto Shuffle; }
        ::(q==1 && _shuffle==0) -> {goto EndDealer;}
    fi;

    Shuffle: atomic{
            isShuffle=true;
            byte index;
            for(z,0,p)
                select ( index : 1 .. 3);
                byte _temp;
                _temp= _playerCards[z].Cards[0];
                _playerCards[z].Cards[0]=_playerCards[z].Cards[index];
                _playerCards[z].Cards[index]=_temp;
            rof(z)
            printf("*-*-*-*-Dealer Shuffled Players Cards.*-*-*-*-\n");
            isShuffle=false;
            goto Select1;
    }
    EndDealer: printf("////////////////////End Dealer/////////////////\n");
    EndShuffle=true;
}

proctype Player(){

    byte id=_pid-1;
    byte replacements=0;
    byte noreplacements=0;
    byte next,previous;
    byte p=playerNumbers-1;

    if
        ::(id==0) -> { previous=p;next=id+1; }
        ::(id==p) -> {  previous=id-1;next=0; }
        ::else ->{ previous=id-1;next=id+1; };
    fi
    Start: printf("Player %d Wants to Decide. %d\n" ,id,_playerCards[id].Cards[0]);
    bool CheckedFinish=false;

    atomic{
        do
            ::(EndShuffle==true && isShuffle==false && CheckedFinish==true)-> { 
                goto EndPlayer;
            }
            ::(EndShuffle==true && isShuffle==false && CheckedFinish==false)-> { 
                for(i,1,3)
                    if
                        ::(_playerCards[id].Cards[i] >= _playerCards[previous].Cards[0] 
                           && _playerCards[id].Cards[i] >= _playerCards[next].Cards[0]) -> {

                            byte temp =_playerCards[id].Cards[i];
                            _playerCards[id].Cards[i]=_playerCards[id].Cards[0];
                            _playerCards[id].Cards[0]=temp;
                            printf("Player %d Changed Top Card to %d\n" ,id,_playerCards[id].Cards[0]);
                            goto Start;
                        }
                        ::else skip;
                    fi;
                rof(i);
                CheckedFinish=true;
            }
            ::(EndShuffle==false && isShuffle==false) -> {
                byte t= _playerCards[id].Cards[1];
                _playerCards[id].Cards[1]=_playerCards[id].Cards[0];
                _playerCards[id].Cards[0]=t;
                goto Start;
            }
            ::(EndShuffle==false && isShuffle==true) -> {
                goto Start;
            }
            ::else -> {
                goto Start;
            }
        od;
    }

    EndPlayer: printf("Player %d Finished And Top Card Is : %d.\n" ,id,_playerCards[id].Cards[0]);
}

#define P0Terminated (Player[0]@EndPlayer)
#define P1Terminated (Player[1]@EndPlayer)
#define P2Terminated (Player[2]@EndPlayer)
#define P3Terminated (Player[3]@EndPlayer)
#define P4Terminated (Player[4]@EndPlayer)

//ltl TeminateAllPalyers {<>(P0Terminated && P1Terminated && P2Terminated && P3Terminated && P4Terminated)}

ltl Win { [] ((_nr_pr==0) -> ( _playerCards[0].Cards[0]==_playerCards[1].Cards[0]==_playerCards[2].Cards[0]==_playerCards[3].Cards[0] ==_playerCards[4].Cards[0]))}

