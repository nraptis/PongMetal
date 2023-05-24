//
//  Matrix.swift
//  RebuildEarth
//
//  Created by Nicky Taylor on 2/10/23.
//

import Foundation
import simd
import SceneKit

extension matrix_float4x4 {
    
    mutating func make(m00: Float, m01: Float, m02: Float, m03: Float,
                       m10: Float, m11: Float, m12: Float, m13: Float,
                       m20: Float, m21: Float, m22: Float, m23: Float,
                       m30: Float, m31: Float, m32: Float, m33: Float) {
        
        columns.0.x = m00 // 0
        columns.1.x = m10 // 1
        columns.2.x = m20 // 2
        columns.3.x = m30 // 3
        
        columns.0.y = m01 // 4
        columns.1.y = m11 // 5
        columns.2.y = m21 // 6
        columns.3.y = m31 // 7
        
        columns.0.z = m02 // 8
        columns.1.z = m12 // 9
        columns.2.z = m22 // 10
        columns.3.z = m32 // 11
        
        columns.0.w = m03 // 12
        columns.1.w = m13 // 13
        columns.2.w = m23 // 14
        columns.3.w = m33 // 15
    }
    
    mutating func make(matrix4: SCNMatrix4) {
        make(m00: matrix4.m11, m01: matrix4.m12, m02: matrix4.m13, m03: matrix4.m14,
             m10: matrix4.m21, m11: matrix4.m22, m12: matrix4.m23, m13: matrix4.m24,
             m20: matrix4.m31, m21: matrix4.m32, m22: matrix4.m33, m23: matrix4.m34,
             m30: matrix4.m41, m31: matrix4.m42, m32: matrix4.m43, m33: matrix4.m44)
    }
    
    func array() -> [Float] {
        return [columns.0.x, columns.0.y, columns.0.z, columns.0.w,
                columns.1.x, columns.1.y, columns.1.z, columns.1.w,
                columns.2.x, columns.2.y, columns.2.z, columns.2.w,
                columns.3.x, columns.3.y, columns.3.z, columns.3.w]
    }
    
    mutating func ortho(left: Float, right: Float, bottom: Float, top: Float,
                        nearZ: Float, farZ: Float) {
        
        let ral = right + left
        let rsl = right - left
        let tab = top + bottom
        let tsb = top - bottom
        let fan = farZ + nearZ
        let fsn = farZ - nearZ
        make(m00: 2.0 / rsl, m01: 0.0, m02: 0.0, m03: 0.0,
             m10: 0.0, m11: 2.0 / tsb, m12: 0.0, m13: 0.0,
             m20: 0.0, m21: 0.0, m22: -2.0 / fsn, m23: 0.0,
             m30: -ral / rsl, m31: -tab / tsb, m32: -fan / fsn, m33: 1.0)
    }
    
    mutating func ortho(width: Float, height: Float) {
        ortho(left: 0.0, right: width,
              bottom: height, top: 0.0,
              nearZ: -2048.0, farZ: 2048.0)
    }
}
