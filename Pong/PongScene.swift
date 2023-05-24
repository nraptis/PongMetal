//
//  PongScene.swift
//  Pong
//
//  Created by Tiger Nixon on 5/4/23.
//

import Foundation
import Metal
import UIKit

class PongScene: GraphicsDelegate {
    var graphics: Graphics!
    
    lazy var paddleEnemy: Paddle = {
        Paddle(graphics: graphics)
    }()
    
    lazy var paddleSelf: Paddle = {
        Paddle(graphics: graphics)
    }()
    
    lazy var ball: Ball = {
       Ball(graphics: graphics)
    }()
    
    
    var ballX: Float = 0.0
    var ballY: Float = 0.0
    var ballWidth: Float = 32.0
    var ballHeight: Float = 32.0
    
    var ballSpeedX: Float = 0.0
    var ballSpeedY: Float = 0.0
    
    var selfPaddleTouch: UITouch?
    var selfPaddleStartTouchX: Float = 0.0
    var selfPaddleStartTouchY: Float = 0.0
    var selfPaddleStartX: Float = 0.0
    var selfPaddleStartY: Float = 0.0
    
    var selfPaddleX: Float = 0.0
    var selfPaddleY: Float = 0.0
    var enemyPaddleX: Float = 0.0
    var enemyPaddleY: Float = 0.0
    
    func generateSpeed() -> Float {
        
        let spanBig = graphics.width * 0.01
        let spanTiny = graphics.width * 0.002
        
        return spanBig + Float.random(in: 0.0...spanTiny)
    }
    
    func load() {
        
        hardRestart()
        
    }
    
    func hardRestart() {
        
        selfPaddleTouch = nil
        
        ballWidth = paddleSelf.height
        ballHeight = paddleSelf.height
        
        ballSpeedX = generateSpeed() * (Bool.random() ? -1.0 : 1.0)
        ballSpeedY = generateSpeed() * (Bool.random() ? -1.0 : 1.0)
        
        ballX = graphics.width * 0.5 - ballWidth * 0.5
        ballY = graphics.height * 0.5 - ballHeight * 0.5
        
        selfPaddleX = graphics.width * 0.5 - paddleSelf.width * 0.5
        selfPaddleY = graphics.height - graphics.safeAreaBottom - paddleSelf.height - 32.0
        
        enemyPaddleX = graphics.width * 0.5 - paddleEnemy.width * 0.5
        enemyPaddleY = graphics.safeAreaTop + 32.0
    }
    
    func update() {
        
        ballX += ballSpeedX
        if ballX <= 0 {
            ballX = 0.0
            ballSpeedX = generateSpeed()
        }
        if ballX >= (graphics.width - ball.width) {
            ballX = (graphics.width - ball.width)
            ballSpeedX = -generateSpeed()
        }

        ballY += ballSpeedY
        if ballY <= (enemyPaddleY + paddleEnemy.height) {
            ballY = (enemyPaddleY + paddleEnemy.height)
            ballSpeedY = generateSpeed()
        }
        
        if ballY >= (selfPaddleY - ballHeight) && ballSpeedY > 0.0 {
            
            if ballY <= (selfPaddleY - ballHeight * 0.5) {
                
                if (ballX + ball.width * 0.5 >= selfPaddleX) &&
                    (ballX <= selfPaddleX + paddleSelf.width - ballWidth * 0.5) {
                    
                    ballY = (selfPaddleY - ballHeight)
                    ballSpeedY = -generateSpeed()
                }
            }
        }
        
        if ballY >= graphics.height + graphics.height * 0.125 {
            // Hard Restart
            hardRestart()
        }
        
        
        
        enemyPaddleX = (ballX + ballWidth * 0.5) - paddleEnemy.width * 0.5
        if enemyPaddleX <= 0.0 {
            enemyPaddleX = 0.0
        }
        if enemyPaddleX >= (graphics.width - paddleEnemy.width) {
            enemyPaddleX = (graphics.width - paddleEnemy.width)
        }
        
        
        paddleEnemy.update(x: enemyPaddleX, y: enemyPaddleY)
        
        paddleSelf.update(x: selfPaddleX, y: selfPaddleY)
        
        ball.update(x: ballX, y: ballY, width: ballWidth, height: ballHeight)

    }
    
    
    func draw(renderEncoder: MTLRenderCommandEncoder) {
        
        /*
        let positions: [Float] = [20.0, 20.0,
                                  graphics.width - 20.0, 20.0,
                                  20.0, graphics.height - 20.0,
                                  graphics.width - 20.0, graphics.height - 20.0]
        
        let positionsBuffer = graphics.buffer(array: positions)
        
        var uniformsVertex = UniformsShapeVertex()
        uniformsVertex.projectionMatrix.ortho(width: graphics.width, height: graphics.height)
        let uniformsVertexBuffer = graphics.buffer(uniform: uniformsVertex)
        
        var uniformsFragment = UniformsShapeFragment()
        uniformsFragment.set(red: 1.0, green: 0.5, blue: 0.0)
        let uniformsFragmentBuffer = graphics.buffer(uniform: uniformsFragment)
        
        graphics.set(pipelineState: .shape2DNoBlending, renderEncoder: renderEncoder)
        
        graphics.setVertexPositionsBuffer(positionsBuffer, renderEncoder: renderEncoder)
        graphics.setVertexUniformsBuffer(uniformsVertexBuffer, renderEncoder: renderEncoder)
        graphics.setFragmentUniformsBuffer(uniformsFragmentBuffer, renderEncoder: renderEncoder)
        
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        */
        
        paddleEnemy.draw(renderEncoder: renderEncoder)
        paddleSelf.draw(renderEncoder: renderEncoder)
        ball.draw(renderEncoder: renderEncoder)
    }
    
    func touchBegan(touch: UITouch, x: Float, y: Float) {
        
        if selfPaddleTouch === nil {
            selfPaddleTouch = touch
            selfPaddleStartTouchX = x
            selfPaddleStartTouchY = y
            selfPaddleStartX = selfPaddleX
            selfPaddleStartY = selfPaddleY
        }
        
    }
    
    func touchMoved(touch: UITouch, x: Float, y: Float) {
        
        //paddleSelf.update(x: x, y: 300)
        if touch === selfPaddleTouch {
            
            selfPaddleX = selfPaddleStartX + (x - selfPaddleStartTouchX)
            if selfPaddleX <= 0.0 {
                selfPaddleX = 0.0
            }
            if selfPaddleX >= (graphics.width - paddleSelf.width) {
                selfPaddleX = (graphics.width - paddleSelf.width)
            }
            
        }
        
        
    }
    
    func touchEnded(touch: UITouch, x: Float, y: Float) {
        
        if touch === selfPaddleTouch {
            selfPaddleTouch = nil
        }
        
    }
}
