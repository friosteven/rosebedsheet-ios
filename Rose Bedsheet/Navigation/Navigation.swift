//
//  Navigation.swift
//  Rose Bedsheet
//
//  Created by John Steven Frio on 5/31/25.
//


import SwiftUI

// MARK: - ================================================
// MARK: Conceptual File: AppNavigationModels.swift
// MARK: - ================================================

enum AppScreen: Hashable, Identifiable {
    case splash
    // Authentication Flow
    case login
    case signup
    case forgotPassword
    case otpVerification(email: String)

    // Main App Flow - Home Tab
    case home
    case itemDetail(itemId: String)
    case createItemForm // Can be presented from Home or other places

    // Main App Flow - Profile Tab
    case profile
    case profileSettings
    case editProfile
    
    // Main App Flow - General/Shared
    case globalSettings

    var id: String {
        var baseId: String
        switch self {
        case .splash: baseId = "splash"
        case .login: baseId = "login"
        case .signup: baseId = "signup"
        case .forgotPassword: baseId = "forgotPassword"
        case .otpVerification(let email): baseId = "otpVerification-\(email)"
        case .home: baseId = "home"
        case .itemDetail(let itemId): baseId = "itemDetail-\(itemId)"
        case .createItemForm: baseId = "createItemForm"
        case .profile: baseId = "profile"
        case .profileSettings: baseId = "profileSettings"
        case .editProfile: baseId = "editProfile"
        case .globalSettings: baseId = "globalSettings"
        }
        return baseId
    }
}

enum RootView: Identifiable {
    case splash
    case authentication
    case mainApp
    
    var id: String {
        switch self {
        case .splash: return "rootSplash"
        case .authentication: return "rootAuth"
        case .mainApp: return "rootMainApp"
        }
    }
}

/// Enum to identify tabs, used for programmatic tab selection
enum AppTab: Hashable {
    case home
    case profile
    // Add other tabs here if needed
}

// MARK: - ================================================
// MARK: Conceptual File: AuthNavigator.swift
// MARK: - ================================================

class AuthNavigator: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ screen: AppScreen) {
        switch screen {
        case .signup, .forgotPassword, .otpVerification:
            path.append(screen)
        default:
            print("Warning: AuthNavigator attempting to push non-auth screen: \(screen.id)")
            // return // Be stricter by returning
        }
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func pop(count: Int) {
        let popCount = max(0, min(count, path.count))
        if popCount > 0 {
            path.removeLast(popCount)
        }
    }

    func popToRoot() {
        path = NavigationPath()
    }

    func reset() {
        path = NavigationPath()
    }
}

// MARK: - ================================================
// MARK: Conceptual File: MainAppCoordinator.swift
// MARK: - ================================================

class MainAppCoordinator: ObservableObject {

    @Published var currentRoot: RootView = .splash
    
    // Navigator for the Authentication Flow
    @Published var authNavigator = AuthNavigator()
    
    // NavigationPaths for Tabs within MainAppFlow
    @Published var homePath = NavigationPath()
    @Published var profilePath = NavigationPath()
    // Add more paths if you have more tabs: e.g., @Published var searchPath = NavigationPath()

    // Selected Tab State
    @Published var selectedTab: AppTab = .home
    
    // Modal Presentation State (Global)
    @Published var presentingSheet: AppScreen? = nil
    @Published var presentingFullscreenCover: AppScreen? = nil

    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            let isAuthenticated = false // Replace with actual auth service check
            if isAuthenticated {
                self?.showMainApp()
            } else {
                self?.showAuthenticationFlow()
            }
        }
    }
    
    // MARK: - Root View Management
    func showSplashScreen() {
        currentRoot = .splash
        resetAllNavigationPaths()
    }

    func showAuthenticationFlow() {
        currentRoot = .authentication
        resetAllNavigationPaths()
    }

    func showMainApp() {
        currentRoot = .mainApp
        resetAllNavigationPaths()
    }

    // MARK: - Tab Navigation Methods
    func selectTab(_ tab: AppTab) {
        selectedTab = tab
    }

    // Home Tab Navigation
    func pushToHome(_ screen: AppScreen) {
        homePath.append(screen)
    }

    func popFromHome() {
        if !homePath.isEmpty {
            homePath.removeLast()
        }
    }

    func popToHomeRoot() {
        homePath = NavigationPath()
    }

    // Profile Tab Navigation
    func pushToProfile(_ screen: AppScreen) {
        profilePath.append(screen)
    }

    func popFromProfile() {
        if !profilePath.isEmpty {
            profilePath.removeLast()
        }
    }

    func popToProfileRoot() {
        profilePath = NavigationPath()
    }
    
    // Add methods for other tabs if they exist

    // MARK: - Modal Presentation (Global)
    func presentSheet(_ screen: AppScreen) {
        // Add more specific checks if needed for which screens can be sheets
        presentingSheet = screen
    }

    func dismissSheet() {
        presentingSheet = nil
    }

    func presentFullscreenCover(_ screen: AppScreen) {
        // Add more specific checks if needed
        presentingFullscreenCover = screen
    }

    func dismissFullscreenCover() {
        presentingFullscreenCover = nil
    }
    
    // MARK: - Utility Methods
    func resetAllNavigationPaths() {
        authNavigator.reset()
        homePath = NavigationPath()
        profilePath = NavigationPath()
        // Reset other tab paths
    }
    
    func resetAllNavigationStates() {
        resetAllNavigationPaths()
        presentingSheet = nil
        presentingFullscreenCover = nil
    }
    
    func handleLogout() {
        showAuthenticationFlow()
    }
}

// MARK: - ================================================
// MARK: Conceptual File: ContentView.swift (or YourApp.swift)
// MARK: - ================================================

struct ContentView: View {
    @StateObject private var coordinator = MainAppCoordinator()

    var body: some View {
        Group {
            switch coordinator.currentRoot {
            case .splash:
                SplashScreenView()
            case .authentication:
                AuthenticationFlowRootView()
                    .environmentObject(coordinator.authNavigator)
            case .mainApp:
                MainAppTabView()
                    // Specific path bindings are handled within MainAppTabView's children
            }
        }
        .environmentObject(coordinator) // Provide the main coordinator globally
        .sheet(item: $coordinator.presentingSheet) { screen in
            GlobalDestinationBuilder.viewFor(screen: screen, coordinator: coordinator, isPresentedModally: true)
        }
        .fullScreenCover(item: $coordinator.presentingFullscreenCover) { screen in
            GlobalDestinationBuilder.viewFor(screen: screen, coordinator: coordinator, isPresentedModally: true)
        }
    }
}

// MARK: - ================================================
// MARK: Conceptual File: GlobalDestinationBuilder.swift
// MARK: - ================================================

enum GlobalDestinationBuilder {
    @ViewBuilder
    static func viewFor(screen: AppScreen, coordinator: MainAppCoordinator, isPresentedModally: Bool = false) -> some View {
        let viewToPresent: AnyView = {
            switch screen {
            // Auth Flow Screens (can be presented modally too, but usually part of auth stack)
            case .login: return AnyView(LoginView().environmentObject(coordinator.authNavigator))
            case .signup: return AnyView(SignupView().environmentObject(coordinator.authNavigator))
            case .forgotPassword: return AnyView(ForgotPasswordView().environmentObject(coordinator.authNavigator))
            case .otpVerification(let email): return AnyView(OTPView(email: email).environmentObject(coordinator.authNavigator))
            
            // Home Flow Screens (can be modal, but primary usage is in Home tab's stack)
            case .home: return AnyView(HomeView()) // Will get coordinator from env for tab navigation methods
            case .itemDetail(let itemId): return AnyView(ItemDetailView(itemId: itemId))
            
            // Profile Flow Screens
            case .profile: return AnyView(ProfileView()) // Will get coordinator from env
            case .profileSettings: return AnyView(ProfileSettingsView())
            case .editProfile: return AnyView(EditProfileView())

            // Shared/Modal Screens
            case .createItemForm: return AnyView(CreateItemFormView())
            case .globalSettings: return AnyView(GlobalSettingsView())
            
            case .splash: return AnyView(SplashScreenView())
            }
        }()

        if isPresentedModally {
            NavigationView {
                viewToPresent
                    .environmentObject(coordinator)
            }
        } else {
            viewToPresent
                .environmentObject(coordinator)
        }
    }
}

// MARK: - ================================================
// MARK: Placeholder Views & Flow Root Views
// MARK: - ================================================

struct SplashScreenView: View {
    var body: some View { Text("Splash Screen").font(.largeTitle).frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.gray.opacity(0.1)) }
}

// --- Authentication Flow ---
struct AuthenticationFlowRootView: View {
    @EnvironmentObject var authNavigator: AuthNavigator
    @EnvironmentObject var coordinator: MainAppCoordinator // For global destination builder context

    var body: some View {
        NavigationStack(path: $authNavigator.path) {
            LoginView()
                .navigationDestination(for: AppScreen.self) { screen in
                    authFlowDestinationView(for: screen)
                }
        }
    }
    
    @ViewBuilder
    private func authFlowDestinationView(for screen: AppScreen) -> some View {
        // These views will inherit authNavigator and coordinator from the environment
        switch screen {
        case .signup: SignupView()
        case .forgotPassword: ForgotPasswordView()
        case .otpVerification(let email): OTPView(email: email)
        default: Text("Error: Unexpected screen (\(screen.id)) in Auth Flow stack.")
        }
    }
}

struct LoginView: View {
    @EnvironmentObject var authNavigator: AuthNavigator
    @EnvironmentObject var coordinator: MainAppCoordinator

    var body: some View {
        VStack(spacing: 20) {
            Text("Login Screen").font(.title)
            Button("Go to Sign Up") { authNavigator.push(.signup) }
            Button("Forgot Password?") { authNavigator.push(.forgotPassword) }
            Button("Log In (Simulate)") { coordinator.showMainApp() }
            Button("Show Global Settings (Sheet)") { coordinator.presentSheet(.globalSettings) }
        }.navigationTitle("Login")
    }
}

struct SignupView: View {
    @EnvironmentObject var authNavigator: AuthNavigator
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up Screen").font(.title)
            Button("Go to OTP") { authNavigator.push(.otpVerification(email: "test@example.com")) }
            Button("Back to Login") { authNavigator.pop() }
        }.navigationTitle("Sign Up")
    }
}

struct ForgotPasswordView: View {
    var body: some View { Text("Forgot Password Screen").font(.title).navigationTitle("Reset Password") }
}

struct OTPView: View {
    @EnvironmentObject var coordinator: MainAppCoordinator
    let email: String
    var body: some View {
        VStack {
            Text("OTP for \(email)").font(.title)
            Button("Verify & Go Home (Simulate)") { coordinator.showMainApp() }
        }.navigationTitle("Verify OTP")
    }
}


// --- Main App Flow (TabView Example) ---
struct MainAppTabView: View {
    @EnvironmentObject var coordinator: MainAppCoordinator

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            HomeFlowRootView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(AppTab.home)
            
            ProfileFlowRootView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
                .tag(AppTab.profile)
        }
    }
}

// --- Home Flow ---
struct HomeFlowRootView: View {
    @EnvironmentObject var coordinator: MainAppCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.homePath) { // Bind to homePath from coordinator
            HomeView()
                .navigationDestination(for: AppScreen.self) { screen in
                    homeFlowDestinationView(for: screen)
                }
        }
    }

    @ViewBuilder
    private func homeFlowDestinationView(for screen: AppScreen) -> some View {
        // These views inherit coordinator from environment
        switch screen {
        case .itemDetail(let itemId): ItemDetailView(itemId: itemId)
        default: Text("Error: Unexpected screen (\(screen.id)) in Home Flow stack.")
        }
    }
}

struct HomeView: View {
    @EnvironmentObject var coordinator: MainAppCoordinator

    var body: some View {
        VStack(spacing: 20) {
            Text("Home Screen").font(.largeTitle)
            Button("View Item 123") { coordinator.pushToHome(.itemDetail(itemId: "123")) }
            Button("Create Item (Sheet)") { coordinator.presentSheet(.createItemForm) }
            Button("Show Global Settings (Fullscreen)") { coordinator.presentFullscreenCover(.globalSettings) }
            Button("Go to Profile Tab") { coordinator.selectTab(.profile) } // Programmatic tab change
            Button("Logout") { coordinator.handleLogout() }
        }
        .navigationTitle("Home")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Global Settings (Sheet)") { coordinator.presentSheet(.globalSettings) }
            }
        }
    }
}

struct ItemDetailView: View {
    let itemId: String
    var body: some View { Text("Details for Item: \(itemId)").font(.title).navigationTitle("Item \(itemId)") }
}

// --- Profile Flow ---
struct ProfileFlowRootView: View {
    @EnvironmentObject var coordinator: MainAppCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.profilePath) { // Bind to profilePath from coordinator
            ProfileView()
                .navigationDestination(for: AppScreen.self) { screen in
                    profileFlowDestinationView(for: screen)
                }
        }
    }
    
    @ViewBuilder
    private func profileFlowDestinationView(for screen: AppScreen) -> some View {
        // These views inherit coordinator from environment
        switch screen {
        case .profileSettings: ProfileSettingsView()
        case .editProfile: EditProfileView()
        default: Text("Error: Unexpected screen (\(screen.id)) in Profile Flow stack.")
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var coordinator: MainAppCoordinator

    var body: some View {
        VStack(spacing: 20) {
            Text("Profile Screen").font(.title)
            Button("Edit Profile") { coordinator.pushToProfile(.editProfile) }
            Button("Profile Settings") { coordinator.pushToProfile(.profileSettings) }
            Button("Show Global Settings (Sheet)") { coordinator.presentSheet(.globalSettings) }
            Button("Go to Home Tab & Push Item") { // More complex cross-tab action
                coordinator.selectTab(.home)
                // Give a slight delay for tab switch to complete before pushing
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    coordinator.pushToHome(.itemDetail(itemId: "fromProfileLink"))
                }
            }
            Button("Logout") { coordinator.handleLogout() }
        }
        .navigationTitle("My Profile")
    }
}

struct ProfileSettingsView: View {
    var body: some View { Text("Profile Settings Screen").font(.title).navigationTitle("Profile Settings") }
}

struct EditProfileView: View {
    var body: some View { Text("Edit Profile Screen").font(.title).navigationTitle("Edit Profile") }
}


// --- Shared/Modal Views ---
struct CreateItemFormView: View {
    @EnvironmentObject var coordinator: MainAppCoordinator
    var body: some View {
        VStack {
            Text("Create New Item Form").font(.title)
            Button("Save & Dismiss") { coordinator.dismissSheet() }
        }
        .navigationTitle("New Item")
        .toolbar { ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { coordinator.dismissSheet() } } }
    }
}

struct GlobalSettingsView: View {
    @EnvironmentObject var coordinator: MainAppCoordinator

    var body: some View {
        VStack(spacing: 20) {
            Text("Global Settings Screen").font(.title)
            Button("Dismiss") {
                if coordinator.presentingSheet == .globalSettings { coordinator.dismissSheet() }
                else if coordinator.presentingFullscreenCover == .globalSettings { coordinator.dismissFullscreenCover() }
            }
        }
        .navigationTitle("Global Settings")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                 Button("Done") {
                    if coordinator.presentingSheet == .globalSettings { coordinator.dismissSheet() }
                    else { coordinator.dismissFullscreenCover() }
                 }
            }
        }
    }
}
