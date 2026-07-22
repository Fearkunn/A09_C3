//
//  TranslationHostView.swift
//  A09_C3
//
//  Created by Muhammad Dzakki Abdullah on 22/07/26.
//

import SwiftUI
import Translation

struct TranslationHostView: View {
    @Bindable var bridge: TranslationBridge

    var body: some View {
        Color.clear
            .translationTask(bridge.configuration) { session in
                await bridge.handleSession(session)
            }
    }
}
