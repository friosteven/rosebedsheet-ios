//
//  AccountSettingsView.swift
//  Rose Bedsheet
//
//  Created by John Steven Frio on 6/12/25.
//

import SwiftUI

struct AccountSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Text("Account Settings View")
        
        Button {
            dismiss()
        } label: {
            Text("Tap to dismiss")
        }
    }
}

#Preview {
    AccountSettingsView()
} 
