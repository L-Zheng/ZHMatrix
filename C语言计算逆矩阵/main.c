//
//  main.c
//  Temp
//
//  Created by 李保征 on 2017/6/30.
//  Copyright © 2017年 李保征. All rights reserved.
//

#include <stdio.h>
#include <math.h>
#include <stdlib.h>   //没有此库free报错
#include <malloc/malloc.h>

int main(int argc, const char * argv[]) {
    // insert code here...
    printf("Hello, World!\n");
    
    int inv(double *p,int n);
//    {{1,2,0,0},{2,5,0,0},{0,0,3,0},{0,0,0,1}}
//    {{1,2},{3,4}}
    
#define rowsCount 3
    double a[rowsCount][rowsCount]={{0,1,2},{1,1,4},{2,-1,0}},*ab;
    ab=a[0];
    int n=rowsCount,i=0,j;
    i=inv(ab,n);  //调用矩阵求逆
    if(i!=0)      //如果返回值不是0
    for(i=0;i<n;i++)   //输出结果
    {
        putchar('\n');
        for(j=0;j<n;j++)
        printf("%f  ",a[i][j]);
    }
    
    return 0;
}



void swap(double *a,double *b)
{
    double c;
    c=*a;
    *a=*b;
    *b=c;
}

int inv(double *p,int n)
{
    void swap(double *a,double *b);
    int *is,*js,i,j,k;
    for(i=0;i<n;i++)
    {
        putchar('\n');
        for(j=0;j<n;j++)
        printf("%f  ",*(p+i*n+j));
    }
    puts("\n\n\n\n");
    double temp,fmax;
    is=(int *)malloc(n*sizeof(int));
    js=(int *)malloc(n*sizeof(int));
    for(k=0;k<n;k++)
    {
        fmax=0.0;
        for(i=k;i<n;i++)
        {
            for(j=k;j<n;j++)
            {
                temp=fabs(*(p+i*n+j));//找最大值
                if(temp>fmax)
                {
                    fmax=temp;
                    is[k]=i;js[k]=j;
                }
            }
        }
        if((fmax+1.0)==1.0)
        {
            free(is);free(js);
            printf("no inv");
            puts("\n");
            return(0);
        }
        if((i=is[k])!=k){
            for(j=0;j<n;j++){
                swap(&p[k*n+j],&p[i*n+j]);//交换指针
            }
        }
        
        if((j=js[k])!=k){
            for(i=0;i<n;i++){
                swap(&p[i*n+k],&p[i*n+j]);  //交换指针
            }
        }
        
        
        p[k*n+k]=1.0/p[k*n+k];
        for(j=0;j<n;j++){
            if(j!=k){
                p[k*n+j]*=p[k*n+k];
            }
        }
        for(i=0;i<n;i++){
            if(i!=k){
                for(j=0;j<n;j++){
                    if(j!=k){
                        p[i*n+j]=p[i*n+j]-p[i*n+k]*p[k*n+j];
                    }
                }
            }
        }
        for(i=0;i<n;i++){
            if(i!=k){
                p[i*n+k]*=-p[k*n+k];
            }
        }
    }
    for(k=n-1;k>=0;k--)
    {
        if((j=js[k])!=k){
            for(i=0;i<n;i++){
                swap((p+j*n+i),(p+k*n+i));
            }
        }
        if((i=is[k])!=k){
            for(j=0;j<n;j++){
                swap((p+j*n+i),(p+j*n+k));
            }
        }
    }
    
    free(is);
    free(js);
    return 1;
}


