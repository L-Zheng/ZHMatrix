//
//  ViewController.swift
//  ZHMatrix
//
//  Created by 李保征 on 2017/6/30.
//  Copyright © 2017年 李保征. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        
        
        //        拟合多项式
        //        y = a0 + a1*pow(x,1) + a2*pow(x,2) + ... + ak*pow(x,k)
        
        
        //1、在（-1.5,1.5）之间制造散点  间隔0.02
        
        // MARK: - 散点数组
        //        (repeating: 0, count: Int(2.0 / 0.02) + 1)
        
        var splashXS : [Double] = [Double]()
        var splashYS : [Double] = [Double]()
        
        let splashCount : Int = Int((maxX - minX) / splashMarginX) + 1
        
        for i in 0...splashCount {
            splashXS.append(Double(minX + splashMarginX * CGFloat(i)))
        }
        for eachX in splashXS {
            let a = eachX
            let eachY : Double = ((a*a-1)*(a*a-1)*(a*a-1)+0.5) * sin(a * 2)
            splashYS.append(eachY)
        }
        //绘制散点
        var drawXS : [Double] = [Double]()
        var drawYS : [Double] = [Double]()
        
        for i in 0..<splashYS.count{
            //            60~140
            let d : Double = ((60.0 + Double(arc4random_uniform(80))) / 100.0)//偏差
            drawXS.append(splashXS[i] * d)
            drawYS.append(splashYS[i] * d)
        }
        
        // MARK: - 根据散点数组开始拟合  矩阵乘法 A * B = C---->确定 A 和 C 求 B
        var fitCoefficientMatrix : [Double] = [Double]() //拟合系数项矩阵A
        var fitConstantMatrix : [Double] = [Double]() //拟合常数项矩阵C
        
        //计算拟合系数项矩阵A
        for i in 0...order {
            for j in 0...order {
                var tx : Double = 0.0
                
                for k in 0..<drawXS.count {
                    
                    var dx : Double = 1.0
                    
                    for l in 0..<j+i {
                        dx = dx * drawXS[k]
                    }
                    tx += dx
                }
                fitCoefficientMatrix.append(tx)
            }
        }
        
        //计算拟合常数项矩阵C
        for i in 0...order {
            var ty : Double = 0.0
            for k in 0..<drawXS.count {
                var dy : Double = 1.0
                for l in 0..<i {
                    dy = dy * drawXS[k]
                }
                ty += drawYS[k] * dy
            }
            fitConstantMatrix.append(ty)
        }
        
        //计算拟合参数项矩阵B（求A的逆矩阵   A的逆矩阵 * C = B）
        //方阵的行数或者列数   或者是 order阶数
        let m1 = fitCoefficientMatrix
        let rowOrColumnCount = Int(sqrt(Double(m1.count)))
        let inverseMatrix = MatrixManager.shareManager.matrixInverse(matrix: m1, n: rowOrColumnCount)
        if inverseMatrix.count == 0 {
            print("没有逆矩阵")
            return;
        }else{
            print("有逆矩阵")
        }
        print(inverseMatrix)
        
        
        let resMatrix = fitConstantMatrix
        let resColumnCount = 1 //列数 （C矩阵的列数为1）
        let mresult = MatrixManager.shareManager.matrixMultiplication(m1: inverseMatrix, m1RowCount: rowOrColumnCount, m2: resMatrix, m2ColumnCount: resColumnCount, m1ColumnCountOrM2RowCount: rowOrColumnCount, resultMatriElementCount: rowOrColumnCount * resColumnCount)
        print("拟合参数项矩阵B   可行解a(x的系数)的矩阵表示为")
        print(mresult)
        
        
        // MARK: - 根据多项式计算拟合后的连续点
        //        y = a0 + a1*pow(x,1) + a2*pow(x,2) + ... + ak*pow(x,k)
        var fitDrawXS : [Double] = [Double]()
        var fitDrawYS : [Double] = [Double]()
        
        let inverseCount : Int = Int((maxX - minX) / fitMarginX) + 1
        for i in 0...inverseCount {
            fitDrawXS.append(Double(minX + fitMarginX * CGFloat(i)))
        }
        
        for i in 0..<fitDrawXS.count {
            var yy : Double = 0.0
            for j in 0...order {
                var dy : Double = 1.0
                for k in 0..<j {
                    dy *= fitDrawXS[i]
                }
                dy *= mresult[j]
                yy += dy
            }
            fitDrawYS.append(yy)
        }
        
        
        let fitCureView = FitCurveView.init(frame: CGRect(x: 0, y: 100, width: self.view.bounds.size.width, height: 200))
        //散点
        fitCureView.drawXS = drawXS
        fitCureView.drawYS = drawYS
        
        //拟合点
        fitCureView.fitDrawXS = fitDrawXS
        fitCureView.fitDrawYS = fitDrawYS
        
        print(drawXS)
        print(drawYS)
        
        print(fitDrawXS)
        print(fitDrawYS)
        
        self.view.addSubview(fitCureView)
    }
}

