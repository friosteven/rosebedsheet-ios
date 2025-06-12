//
//  ProfileView.swift
//  Rose Bedsheet
//
//  Created by John Steven Frio on 6/12/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var profileRouter = ProfileRouter()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack(path: $profileRouter.path) {
            content
            .withProfileDestinations(router: profileRouter)
            .withProfileFullscreenCover(router: profileRouter, destination: $profileRouter.currentFullscreenDestination)
            .withProfileSheetCover(router: profileRouter, destination: $profileRouter.currentSheetDestination)
        }
    }
    
    var content: some View {
        VStack {
            Text("Profile View")
            
            Button {
                profileRouter.navigate(to: .accountSettings)
            } label: {
                Text("Navigate to account settings")
            }
            
            Button {
                dismiss()
            } label: {
                Text("Go back to previous screen")
            }
            
            Button {
                withAnimation(.easeInOut) {
                    profileRouter.reset()
                }
            } label: {
                Text("Go back to home")
            }
        }
    }
}

#Preview {
    ProfileView()
}
