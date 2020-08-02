#if os(macOS) || os(iOS)

import Foundation
import GLKit
import MetalKit

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

private struct SceneMatrices {
    var projectionMatrix: GLKMatrix4 = GLKMatrix4Identity
    var modelviewMatrix: GLKMatrix4 = GLKMatrix4Identity
}

private let textureShader: String = """
#include <metal_stdlib>
using namespace metal;

struct SceneMatrices {
    float4x4 projectionMatrix;
    float4x4 viewModelMatrix;
};

struct VertexIn {
    packed_float3 position;
    packed_float2 texCoords;
};

struct VertexOut {
    float4 computedPosition [[position]];
    float2 texCoords;
};

vertex VertexOut textured_vertex(
  const device VertexIn* vertex_array [[ buffer(0) ]],
  const device SceneMatrices& scene_matrices [[ buffer(1) ]],

  unsigned int vid [[ vertex_id ]]) {
    float4x4 viewModelMatrix = scene_matrices.viewModelMatrix;
    float4x4 projectionMatrix = scene_matrices.projectionMatrix;

    VertexIn v = vertex_array[vid];

    VertexOut outVertex = VertexOut();
    outVertex.computedPosition = projectionMatrix * viewModelMatrix * float4(v.position, 1.0);
    outVertex.texCoords = v.texCoords;
    return outVertex;
}

fragment float4 textured_fragment(VertexOut vert [[stage_in]],
                                 texture2d<float> colorTexture [[texture(0)]],
                                 sampler samplr [[sampler(0)]]) {
    return colorTexture.sample(samplr, vert.texCoords).argb;
}
"""

@available(iOS 13.0, *)
class SwoopMetalLayer: CAMetalLayer {

    var root = YogaNode()
    lazy var renderer = BitmapRenderer(root)

    private var metalDevice: MTLDevice!
    private var commandQueue: MTLCommandQueue!

    private var texturePipelineState: MTLRenderPipelineState!
    private var normalSamplerState: MTLSamplerState!

    private var sceneMatrices = SceneMatrices()

    private let floatSize: Int = MemoryLayout<Float>.size

    init(rootView: View) {
        super.init()
        initMetal()
        setRootView(rootView: rootView)
    }

    override init() {
        super.init()
        initMetal()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initMetal()
    }
    
    func initMetal() {
        device = MTLCreateSystemDefaultDevice()
        pixelFormat = .bgra8Unorm

        metalDevice = device
        commandQueue = metalDevice.makeCommandQueue()

        let sourceLibrary = try? metalDevice.makeLibrary(source: textureShader, options: nil)
        if sourceLibrary == nil {
            print("Unable to make metal library")
            return
        }

        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = sourceLibrary?.makeFunction(name: "textured_vertex")
        pipelineStateDescriptor.fragmentFunction = sourceLibrary?.makeFunction(name: "textured_fragment")

        pipelineStateDescriptor.colorAttachments[0].pixelFormat = pixelFormat
        pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = false

        texturePipelineState = try? metalDevice.makeRenderPipelineState(descriptor: pipelineStateDescriptor)

        let normalSamplerDesc = MTLSamplerDescriptor()
        normalSamplerDesc.sAddressMode = .clampToEdge
        normalSamplerDesc.tAddressMode = .clampToEdge
        normalSamplerDesc.minFilter = .linear
        normalSamplerDesc.magFilter = .linear
        normalSamplerDesc.mipFilter = .notMipmapped
        normalSamplerState = metalDevice.makeSamplerState(descriptor: normalSamplerDesc)
    }
    
    func setRootView(rootView: View) {
        root.size(100, 100).leftToRight()
        
        Swoop.loadView(into: root, rootView.body)
        root.layout()
    }

    override func layoutSublayers() {
        renderer.layout(Int(bounds.width) / 2, Int(bounds.height) / 2)
        setNeedsDisplay()
    }

    override func display() {
        root.render(renderer.renderBuffer)
        renderer.swap()

        let bitmap = renderer.viewBuffer.info

        if let drawable = self.nextDrawable() {

            let renderPassDescriptor = MTLRenderPassDescriptor()
            renderPassDescriptor.colorAttachments[0].texture = drawable.texture
            renderPassDescriptor.colorAttachments[0].loadAction = .dontCare

            guard let commandBuffer = commandQueue.makeCommandBuffer() else {
                return
            }

            guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
                return
            }

            sceneMatrices.projectionMatrix = GLKMatrix4MakeOrtho(-1, 1, -1, 1, -1, 1)
            sceneMatrices.modelviewMatrix = GLKMatrix4Identity
            renderEncoder.setVertexBytes(&sceneMatrices, length: MemoryLayout<SceneMatrices>.stride, index: 1)

            renderEncoder.setRenderPipelineState(texturePipelineState)
            renderEncoder.setFragmentSamplerState(normalSamplerState, index: 0)

            let region = MTLRegionMake2D(0, 0, bitmap.width, bitmap.height)

            var textureDescriptor = MTLTextureDescriptor()
            textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: pixelFormat,
                                                                         width: bitmap.width,
                                                                         height: bitmap.height,
                                                                         mipmapped: false)

            if let texture = metalDevice.makeTexture(descriptor: textureDescriptor) {
                texture.replace(region: region,
                                mipmapLevel: 0,
                                withBytes: bitmap.bytes32,
                                bytesPerRow: bitmap.bytesPerRow)

                renderEncoder.setFragmentTexture(texture, index: 0)

                let arrayVT: [Float] = [
                    -1.0, -1.0, 0.0, 0.0, 1.0,
                    1.0, -1.0, 0.0, 1.0, 1.0,
                    -1.0, 1.0, 0.0, 0.0, 0.0,

                    1.0, -1.0, 0.0, 1.0, 1.0,
                    1.0, 1.0, 0.0, 1.0, 0.0,
                    -1.0, 1.0, 0.0, 0.0, 0.0
                ]
                renderEncoder.setVertexBytes(arrayVT, length: arrayVT.count * floatSize, index: 0)
                renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
            }

            renderEncoder.endEncoding()

            commandBuffer.present(drawable)
            commandBuffer.commit()

        }

    }
}

#endif
