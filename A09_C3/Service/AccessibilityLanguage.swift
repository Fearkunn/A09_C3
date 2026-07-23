//
//  AccessibilityLanguage.swift
//  A09_C3
//
//  Created by Dina on 22/07/26.
//

import SwiftUI

func indonesianText(_ text: String) -> AttributedString {
    var label = AttributedString(text)
    label.setAttributes(AttributeContainer([.accessibilitySpeechLanguage: "id_ID"]))
    return label
}
