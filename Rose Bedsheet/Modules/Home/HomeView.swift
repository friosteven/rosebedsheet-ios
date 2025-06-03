//
//  HomeView.swift
//  Rose Bedsheet
//
//  Created by John Steven Frio on 6/3/25.
//

import SwiftUI
import Common

struct HomeView: View {
    var body: some View {
        VStack(spacing: 32) {
            headerView
            buttonStackView
            
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 24) {
            BaseImage(image: UIImage(systemName: "bed.double.circle.fill") ?? UIImage())
                .foregroundStyle(AppColors.primary)
                .frame(width: 100, height: 100)
            VStack(spacing: 16) {
                Text("Welcome to \(Constants.app_name)")
                    .applyTypography(.largeTitleBoldCenter)
                
                Text("Choose how you'd like to use the app")
                    .applyTypography(.title3RegularCenter)
                    .foregroundStyle(AppColors.secondary)
            }
        }
    }
    
    private var buttonStackView: some View {
        VStack {
            
        }
    }
}

#Preview {
    HomeView()
}
