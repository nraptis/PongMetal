//
//  Graphics.swift
//  Pong
//
//  Created by Tiger Nixon on 5/4/23.
//

import Foundation
import Metal
import UIKit

protocol GraphicsDelegate: AnyObject {
    var graphics: Graphics! { set get }
    func initialize(graphics: Graphics)
    func update()
    func load()
    func draw(renderEncoder: MTLRenderCommandEncoder)
    
    func touchBegan(touch: UITouch, x: Float, y: Float)
    func touchMoved(touch: UITouch, x: Float, y: Float)
    func touchEnded(touch: UITouch, x: Float, y: Float)
}

extension GraphicsDelegate {
    func initialize(graphics: Graphics) {
        self.graphics = graphics
    }
}

class Graphics {
    
    enum PipelineState {
        case invalid
        case shape2DNoBlending
    }
    
    private(set) var pipelineState = PipelineState.invalid
    
    lazy var metalView: MetalView = {
        MetalView(delegate: delegate,
                  graphics: self,
                  width: CGFloat(width),
                  height: CGFloat(height))
    }()
    
    lazy var engine: MetalEngine = {
        metalView.engine
    }()
    
    lazy var pipeline: MetalPipeline = {
        metalView.pipeline
    }()
    
    lazy var device: MTLDevice = {
        engine.device
    }()
    
    lazy var metalViewController: MetalViewController = {
        MetalViewController(graphics: self,
                            metalView: metalView)
    }()
    
    let delegate: GraphicsDelegate
    private(set) var width: Float
    private(set) var height: Float
    init(delegate: GraphicsDelegate, width: Float, height: Float) {
        self.delegate = delegate
        self.width = width
        self.height = height
    }
    
    
    func buffer<Element>(array: Array<Element>) -> MTLBuffer! {
        let length = MemoryLayout<Element>.size * array.count
        return device.makeBuffer(bytes: array,
                                 length: length)
    }

    func write<Element>(buffer: MTLBuffer, array: Array<Element>) {
        let length = MemoryLayout<Element>.size * array.count
        buffer.contents().copyMemory(from: array,
                                     byteCount: length)
    }

    func buffer(uniform: Uniforms) -> MTLBuffer! {
        return device.makeBuffer(bytes: uniform.data,
                                 length: uniform.size)
    }

    func write(buffer: MTLBuffer, uniform: Uniforms) {
        buffer.contents().copyMemory(from: uniform.data, byteCount: uniform.size)
    }
    
    func set(pipelineState: PipelineState, renderEncoder: MTLRenderCommandEncoder) {
        self.pipelineState = pipelineState
        switch pipelineState {
        case .invalid:
            break
        case .shape2DNoBlending:
            renderEncoder.setRenderPipelineState(pipeline.pipelineStateShape2DNoBlending)
        }
    }
    
    lazy var window: UIWindow = {
        guard let scene = UIApplication.shared.connectedScenes.first else {
            return UIWindow()
        }
        guard let windowScene = scene as? UIWindowScene else {
            return UIWindow()
        }
        guard let window = windowScene.windows.first else {
            return UIWindow()
        }
        return window
    }()
    
    lazy var safeAreaTop: Float = {
        Float(window.safeAreaInsets.top)
    }()
    
    lazy var safeAreaBottom: Float = {
        Float(window.safeAreaInsets.bottom)
    }()
    
    lazy var safeAreaLeft: Float = {
        Float(window.safeAreaInsets.left)
    }()
    
    lazy var safeAreaRight: Float = {
        Float(window.safeAreaInsets.right)
    }()
    
    func setVertexUniformsBuffer(_ uniformsBuffer: MTLBuffer?, renderEncoder: MTLRenderCommandEncoder) {
        if let uniformsBuffer = uniformsBuffer {
            switch pipelineState {
            case .invalid:
                break
            case .shape2DNoBlending:
                renderEncoder.setVertexBuffer(uniformsBuffer, offset: 0, index: MetalPipeline.shapeVertexIndexUniforms)
            }
        }
    }
    
    func setFragmentUniformsBuffer(_ uniformsBuffer: MTLBuffer?, renderEncoder: MTLRenderCommandEncoder) {
        if let uniformsBuffer = uniformsBuffer {
            switch pipelineState {
            case .invalid:
                break
            case .shape2DNoBlending:
                renderEncoder.setFragmentBuffer(uniformsBuffer, offset: 0, index: MetalPipeline.shapeFragmentIndexUniforms)
            }
        }
    }
    
    func setVertexPositionsBuffer(_ positionsBuffer: MTLBuffer?, renderEncoder: MTLRenderCommandEncoder) {
        if let positionsBuffer = positionsBuffer {
            switch pipelineState {
            case .shape2DNoBlending:
                renderEncoder.setVertexBuffer(positionsBuffer, offset: 0, index: MetalPipeline.shapeVertexIndexPosition)
            default:
                break
            }
        }
    }
    
}
