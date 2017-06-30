//
//  FitCurveView.swift
//  testnihe
//
//  Created by 李保征 on 2017/6/30.
//  Copyright © 2017年 李保征. All rights reserved.
//

import UIKit

let minX : CGFloat = -1.5
let maxX : CGFloat = 1.5
let minY : CGFloat = -0.5
let maxY : CGFloat = 0.7
//散点间隙 X轴每个点间隙  X轴每隔0.02就有一个点
let splashMarginX : CGFloat = 0.02
//拟合点间隙
let fitMarginX : CGFloat = 0.01
//y = a0 + a1*pow(x,1) + a2*pow(x,2) + ... + ak*pow(x,k)
let order : Int = 20 //拟合阶数  即k值    阶数越高  拟合越准确

class FitCurveView: UIView {
    
     //散点
    var drawXS : [Double] = [Double]()
    var drawYS : [Double] = [Double]()
    //拟合点
    var fitDrawXS : [Double] = [Double]()
    var fitDrawYS : [Double] = [Double]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
//        self.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let bottomEdge : CGFloat = 10.0
        let leftEdge : CGFloat = 10.0
        let topEdge : CGFloat = 10.0
        let rightEdge : CGFloat = 10.0
        
        // MARK: - 画X Y轴
        let startPointX = CGPoint(x: leftEdge, y: self.bounds.size.height - bottomEdge)
        let endPointX = CGPoint(x: self.bounds.size.width - rightEdge, y: self.bounds.size.height - bottomEdge)
        self.drawBGGridSingleLine(startPoint: startPointX, endPoint: endPointX, color: UIColor.orange, lineWidth: 1.0)
        //画Y轴
        let startPointY = CGPoint(x: leftEdge, y: topEdge)
        let endPointY = CGPoint(x: leftEdge, y: self.bounds.size.height - bottomEdge)
        self.drawBGGridSingleLine(startPoint: startPointY, endPoint: endPointY, color: UIColor.green, lineWidth: 1.0)
        
        // MARK: - 绘制散点
        //每个单位的坐标对应iOS的像素的距离
        let iosPixelDistanceEachCoordinateX = (self.bounds.size.width - leftEdge - rightEdge) / (maxX - minX)
        let iosPixelDistanceEachCoordinateY = (self.bounds.size.height - topEdge - rightEdge) / (maxY - minY)
        
        for i in 0..<self.drawYS.count {
//            散点坐标  X轴（-1.5~1.5）Y轴（-0.5~0.7）
            //转换为iOS像素点
            //实际坐标点对应的iOS的像素的距离
            let realIOSDiatanceX = (CGFloat(self.drawXS[i]) - minX) * iosPixelDistanceEachCoordinateX
            let realIOSDiatanceY = (CGFloat(self.drawYS[i]) - minY) * iosPixelDistanceEachCoordinateY
            
            
            let point = CGPoint(x: realIOSDiatanceX + leftEdge, y: self.bounds.size.height - bottomEdge - realIOSDiatanceY)
            self.drawPoint(point: point,color: UIColor.purple)
        }
        
        // MARK: - 绘制拟合点
        for i in 0..<self.fitDrawYS.count {
            //            散点坐标  X轴（-1.5~1.5）Y轴（-0.5~0.7）
            //转换为iOS像素点
            //实际坐标点对应的iOS的像素的距离
            let realIOSDiatanceX = (CGFloat(self.fitDrawXS[i]) - minX) * iosPixelDistanceEachCoordinateX
            let realIOSDiatanceY = (CGFloat(self.fitDrawYS[i]) - minY) * iosPixelDistanceEachCoordinateY
            
            
            let point = CGPoint(x: realIOSDiatanceX + leftEdge, y: self.bounds.size.height - bottomEdge - realIOSDiatanceY)
            self.drawPoint(point: point,color: UIColor.orange)
        }
        
    }
    
    //绘制点
    func drawPoint(point : CGPoint, color : UIColor) -> Void {
        let ctx : CGContext = UIGraphicsGetCurrentContext()!
        
        let widthOrHeight : CGFloat = 1.0
        
        ctx.addRect(CGRect(x: point.x - widthOrHeight * 0.5, y: point.y - widthOrHeight * 0.5, width: widthOrHeight, height: widthOrHeight))
        ctx.setFillColor(color.cgColor)
        ctx.fillPath()
    }
    
    //画坐标线
    func drawBGGridSingleLine(startPoint:CGPoint, endPoint:CGPoint, color:UIColor, lineWidth:CGFloat) -> Void {
        //创建上下文
        let ctx : CGContext = UIGraphicsGetCurrentContext()!
//        CGContextRef ctx = UIGraphicsGetCurrentContext();
        // 起点
        ctx.move(to: startPoint)
//        CGContextMoveToPoint(ctx, startPoint.x, startPoint.y);
        // 终点
        ctx.addLine(to: endPoint)
//        CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y);
        // 线条颜色
        ctx.setStrokeColor(color.cgColor)
//        CGContextSetStrokeColorWithColor(ctx, color.CGColor);
        // 线条宽度
        ctx.setLineWidth(lineWidth)
//        CGContextSetLineWidth(ctx, lineWidth);
        // 线条的起点和终点的样式
        ctx.setLineCap(CGLineCap.round)
//        CGContextSetLineCap(ctx, kCGLineCapRound);
        // 线条的转角的样式
        ctx.setLineJoin(CGLineJoin.round)
//        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        
        ctx.strokePath()
//        CGContextStrokePath(ctx);
    }
}
