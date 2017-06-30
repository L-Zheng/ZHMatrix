//
//  MatrixManager.swift
//  ZHMatrix
//
//  Created by 李保征 on 2017/6/30.
//  Copyright © 2017年 李保征. All rights reserved.
//

import UIKit
import Accelerate

class MatrixManager: NSObject {
    // MARK: - share单例
    // Swift中的let是线程安全的
    // 用到时才会创建
    
    //单例
    static let shareManager = MatrixManager()
    
    
//    fileprivate static let instance: MatrixManager = MatrixManager()
//    class func shareManager() -> MatrixManager {
//        return instance
//    }
    
    
    
    override init() {
        super.init()
    }
    
    // MARK: - Matrix Calulate
    
    /// 矩阵乘积
    ///
    /// - Parameters:
    ///   - m1: 矩阵1
    ///   - m1RowCount: 矩阵1的行数
    ///   - m2: 矩阵2
    ///   - m2ColumnCount: 矩阵2的列数
    ///   - m1ColumnCountOrM2RowCount: 矩阵1的列数or矩阵2的行数
    ///   - resultMatriElementCount: 计算结果矩阵元素个数
    /// - Returns: 结果矩阵
    func matrixMultiplication(m1:[Double], m1RowCount:Int, m2:[Double], m2ColumnCount:Int, m1ColumnCountOrM2RowCount:Int, resultMatriElementCount:Int) -> [Double] {
        
        //count：结果矩阵元素个数 = 乘号前边的矩阵行数 * 乘号后边的矩阵列数
        var mresult = [Double](repeating: 0.0, count: resultMatriElementCount)
        //矩阵1的行数   矩阵2的列数  矩阵1的列数or矩阵2的行数
        vDSP_mmulD(m1, 1, m2, 1, &mresult, 1, vDSP_Length(m1RowCount), vDSP_Length(m2ColumnCount), vDSP_Length(m1ColumnCountOrM2RowCount))
        
        return mresult
    }
    
    
    /// 求逆矩阵 方式二
    ///
    /// - Parameters:
    ///   - matrix: 矩阵
    ///   - n: 方阵的行数或者列数   或者是 order阶数
    /// - Returns: 逆矩阵
    func matrixInverse( matrix : [Double] , n : Int) -> [Double] {
        
        var matrix = matrix
        
        var iis = [Int](repeating: 0, count: n)
        var js = [Int](repeating: 0, count: n)
        var i : Int = 0
        var j : Int = 0
        var k : Int = 0
        
        for i in 0...n-1 {
            for j in 0...n-1 {
                print(matrix[i*n+j])
            }
            j = n - 1
            print("\n")
        }
        i = n - 1
        print("\n\n\n\n")
        
        var temp : Double
        var fmax : Double
        
        for k in 0...n-1 {
            fmax = 0.0;
            for i in k...n-1{
                for j in k...n-1 {
                    temp = fabs(matrix[i*n+j])//找最大值
                    if temp > fmax {
                        fmax = temp
                        iis[k] = i; js[k] = j;
                        
                    }
                }
                j = n - 1
            }
            i = n - 1
            
            if((fmax + 1.0) == 1.0) {
                print("no inv");
                print("\n")
                return [Double]()
            }
            i = iis[k]
            if(i != k){
                for j in 0...n-1 {
                    var between : Double = 0.0
                    between = matrix[k*n+j]
                    matrix[k*n+j] = matrix[i*n+j]
                    matrix[i*n+j] = between
                }
                j = n - 1
            }
            
            j = js[k]
            if(j != k){
                for i in 0...n-1 {
                    var between : Double = 0.0//交换指针
                    between = matrix[i*n+k]
                    matrix[i*n+k] = matrix[i*n+j]
                    matrix[i*n+j] = between
                }
                i = n - 1
            }
            
            matrix[k*n+k]=1.0/matrix[k*n+k];
            
            for j in 0...n-1 {
                if (j != k) {
                    matrix[k*n+j] *= matrix[k*n+k];
                }
            }
            j = n - 1
            
            
            for i in 0...n-1 {
                if (i != k) {
                    for j in 0...n-1 {
                        if (j != k) {
                            matrix[i*n+j] = matrix[i*n+j] - matrix[i*n+k] * matrix[k*n+j]
                        }
                    }
                    j = n - 1
                }
            }
            i = n - 1
            
            for i in 0...n-1 {
                if (i != k) {
                    matrix[i*n+k] *= -matrix[k*n+k]
                }
            }
            i = n - 1
        }
        k = n - 1
        
        for k in (0...n-1).reversed() {
            j = js[k];
            if (j != k) {
                for i in 0...n-1 {
                    var between : Double = 0.0//交换指针
                    between = matrix[j*n+i]
                    matrix[j*n+i] = matrix[k*n+i]
                    matrix[k*n+i] = between
                }
                i = n - 1
            }
            i = iis[k];
            if (i != k) {
                for j in 0...n-1 {
                    var between : Double = 0.0//交换指针
                    between = matrix[j*n+i]
                    matrix[j*n+i] = matrix[j*n+k]
                    matrix[j*n+k] = between
                }
                j = n - 1
            }
        }
        k = 0;
        
        return matrix;
    }
    
    /** 求逆矩阵 方式一 经过测试，当传入的数组元素个数大于8个的时候程序会崩溃，崩溃的原因也找了很长时间，可惜能力有限swift函数集合太深 */
    func matrixInverseTest(matrix : [Double]) -> [Double] {
        
        var inMatrix = matrix
        
        var pivot : __CLPK_integer = 0
        var workspace = 0.0
        var error : __CLPK_integer = 0
        
        var N = __CLPK_integer(sqrt(Double(matrix.count)))
        dgetrf_(&N, &N, &inMatrix, &N, &pivot, &error)
        
        if error != 0 {
            return inMatrix
        }
        
        dgetri_(&N, &inMatrix, &N, &pivot, &workspace, &N, &error)
        return inMatrix
    }
}
