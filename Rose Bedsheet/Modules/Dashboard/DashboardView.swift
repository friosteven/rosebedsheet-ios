//
//  DashboardView.swift
//  Rose Bedsheet
//
//  Created by John Steven Frio on 5/31/25.
//

import SwiftUI
import Common

struct DashboardView: View {
    
    @State private var tabConfig = TabViewConfig.tabViewNavConfig
    @State private var tabs = [
        AppTabItem(
            id: "tab1",
            title: "Home",
            icon: "house",
        ),
        AppTabItem(
            id: "tab2",
            title: "Search",
            icon: "magnifyingglass"
        ),
        AppTabItem(
            id: "tab3",
            title: "Profile",
            icon: "person.circle"
        )
    ]
    
    @State private var selectedTabId: String = ""
    
    var body: some View {
        VStack {
            AppTabContainerView(
                selectedTabId: $selectedTabId,
                tabs: tabs,
                config: tabConfig,
                content: { item in
                    if item.title == "Home" {
                        homeTab
                    } else if item.title == "Profile" {
                        profileTab
                    }
                })
        }
        .onAppear(perform: {
            selectedTabId = tabs.first?.id ?? ""
        })
    }
    
    
    private var homeTab: some View {
        HomeView()
    }
    
    private var profileTab: some View {
        ProfileView()
    }
}

#Preview {
    DashboardView()
}
 
