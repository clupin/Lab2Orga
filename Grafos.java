package grafos;

public class Grafos {

    public static int grafo[];
    public static int EA[], CH[], pos[], tamaño;
    public static int CPM, actual, target;
    public static int posCPM, CP, CA;
    public static void main(String[] args) {
        /*grafo = new int [100];
        for(int a=0; a<100; a++){
            grafo[a]=0;
        }
         * matrizGrafo: .word 0,9,5,0,0,0,0,0,0,0 ,0,0,0,1,3,0,0,0,0,0 ,0,0,0,0,4,9,0,0,0,0 ,0,0,0,0,0,0,1,3,0,0 ,0,0,0,0,0,0,8,1,6,0 ,0,0,0,0,0,0,0,3,7,0 ,0,0,0,0,0,0,0,0,0,4 ,0,0,0,0,0,0,0,0,0,4 ,0,0,0,0,0,0,0,0,0,1 ,0,0,0,0,0,0,0,0,0,0

        grafo[1]=9; grafo[2]=5;
        grafo[13]=1; grafo[14]=3;
        grafo[24]=4; grafo[25]=9;
        grafo[36]=1; grafo[37]=3;
        grafo[46]=8; grafo[47]=1; grafo[48]=6;
        grafo[57]=3; grafo[58]=7;
        grafo[69]=4; 
        grafo[79]=4; 
        grafo[89]=1;
        */
        tamaño = 6;
        grafo = new int [36];
        grafo[0]=0; grafo[1]=1; grafo[2]=15; grafo[3]=9999; grafo[4]=9999; grafo[5]=9999;
        grafo[6]=1; grafo[7]=0; grafo[8]=4; grafo[9]=9999; grafo[10]=5; grafo[11]=9999;
        grafo[12]=15; grafo[13]=4; grafo[14]=0; grafo[15]=2; grafo[16]=57; grafo[17]=9999;
        grafo[18]=9999; grafo[19]=9999; grafo[20]=2; grafo[21]=0; grafo[22]=1; grafo[23]=88;
        grafo[24]=9999; grafo[25]=5; grafo[26]=57; grafo[27]=1; grafo[28]=0; grafo[29]=3;
        grafo[30]=9999; grafo[31]=9999; grafo[32]=9999; grafo[33]=88; grafo[34]=3; grafo[35]=0;
        EA = new int[6];
        CH = new int[6];
        pos = new int[6];
        CA=0;
        for(int a=0; a<6; a++){
            EA[a]=1;
            CH[a]=9999;
        }
        System.out.println("");
        dijkstra(0,5);
        System.out.println("resp = "+CH[5]);
    }
    
    public static void dijkstra(int actual, int target){
        int m;
        int aux = tamaño;
        //System.out.println("target = "+target+" EA[target] = "+EA[target]);
        if(EA[target]==1){
            //System.out.println("actual = "+actual);
            EA[actual]=0;
            //System.out.println("EA[actual] = "+EA[actual]);
            CPM=9999;
            posCPM=0;
            for (int i=0; i<6; i++){
                //System.out.println("i = "+i+" EA[i] = "+EA[i]);
                if(EA[i]==1){
                    CH[actual]=9999;
                    //System.out.println("actual = "+actual);
                    m = (aux*actual)+i;
                    //System.out.println("m = "+m+"\nCH["+i+"] = "+CH[i]+"\ngrafo[m] = "+grafo[m]);
                    CP=CA+grafo[m];//costo posible
                    //System.out.println("CP = "+CP);
                    if(CH[i]>CP){
                        CH[i]=CP;
                        //System.out.println("nuevo CH["+i+"] = "+CH[i]);
                    }
                    if(CP<CPM){
                        CPM=CP;
                        posCPM=i;
                        //System.out.println("nuevo CPM = "+CPM+" con posCPM = "+posCPM);
                    }
                }
            }
            //CA=CPM;
            CA=buscarMinimo();
            //System.out.println("CA = "+CA+"\nposCPM = "+posCPM);
            dijkstra(posCPM,target);
        }
    }
    
    public static int buscarMinimo(){
        int min = 9999;
        for(int i=0; i<6; i++){
            if(CH[i]<min){
                min=CH[i];
            }
        }
        return min;
    }
    
}
