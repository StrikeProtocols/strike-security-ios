//
//  StrikeApp.swift
//  Strike
//
//  Created by Donald Ness on 12/23/20.
//

import SwiftUI
import Moya

@main
struct StrikeApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            #if STUBBED
            RootView()
                .withMessageSupport()
                .environmentObject(appDelegate.viewRouter)
                .lockedByBiometry {
                    Locked()
                }
            #else
            RootView(authProvider: appDelegate.authProvider)
                .withMessageSupport()
                .environmentObject(appDelegate.viewRouter)
                .lockedByBiometry {
                    Locked()
                }
            #endif
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var viewRouter = ViewRouter()
    var authProvider = OktaAuthProvider()

    private lazy var strikeApi = {
        StrikeApi(authProvider: authProvider)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let raygunClient = RaygunClient.sharedInstance(apiKey: Configuration.raygunApiKey)
        raygunClient.applicationVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        if Configuration.raygunEnabled {
            raygunClient.enableCrashReporting()
        }

        NotificationCenter.default.addObserver(forName: .userWillSignOut, object: nil, queue: .main) { [weak self] _ in
            guard let deviceIdentifier = UIDevice.current.identifierForVendor?.uuidString else {
                return
            }

            self?.strikeApi.provider.request(.unregisterPushToken(deviceIdentifier: deviceIdentifier)) { _ in }
            UIApplication.shared.unregisterForRemoteNotifications()
        }

        UNUserNotificationCenter.current().delegate = self

        setupAppearance()

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard let deviceIdentifier = UIDevice.current.identifierForVendor?.uuidString else {
            return
        }

        strikeApi.provider.request(.registerPushToken(deviceToken.hexEncodedString(), deviceIdentifier: deviceIdentifier)) { result in
            switch result {
            case .failure(let error):
                debugPrint("Error submitting push token: \(error.localizedDescription)")
            case .success(let response) where response.statusCode >= 400:
                debugPrint("Could not submit push token: \(String(data: response.data, encoding: .utf8) ?? "")")
            case .success:
                break
            }
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint("Failed to register for remote notifications: \(error.localizedDescription)")
    }

    func setupAppearance() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.Strike.purple)

        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.buttonAppearance = buttonAppearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor.white
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])

        NotificationCenter.default.post(name: .userDidReceiveRemoteNotification, object: notification)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        if let contactSupport = userInfo["contactSupport"] as? String, contactSupport.lowercased() == "true" {
            viewRouter.showSupport = true
        }

        completionHandler()
    }
}

extension Notification.Name {
    static let userWillSignOut = Notification.Name("userWillSignOut")
    static let userDidReceiveRemoteNotification = Notification.Name("userDidReceiveRemoteNotification")
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1 && viewControllers.last?.navigationItem.leftBarButtonItem != nil
    }
}
