//
//  NativeTabBarEnvironment.swift
//  carbon
//
//  Created by Vedant Vijay on 06/03/26.
//

import SwiftUI

private struct UseNativeTabBarKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var useNativeTabBar: Bool {
        get { self[UseNativeTabBarKey.self] }
        set { self[UseNativeTabBarKey.self] = newValue }
    }
}
