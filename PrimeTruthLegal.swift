import SwiftUI
import SafariServices

/// Shared legal links for every PrimeTruth Team game.
///
/// The Privacy Policy and Terms of Service live on the web
/// (primetruthteam.github.io) and are written once for ALL games, so a game
/// never embeds legal text and never needs an app update when the wording
/// changes. Apple 5.1.1(i) only requires a link "within the app in an easily
/// accessible manner"; opening the page in an in-app Safari sheet satisfies it.
///
/// Usage from any Settings screen:
///
///     LegalLinksSection(privacyTitle: Loc.Legal.privacyTitle,
///                       termsTitle: Loc.Legal.termsTitle)
///
/// or, with your own row styling:
///
///     @State private var legal: PrimeTruthLegal.Page?
///     ...
///     MyRow(title: Loc.Legal.privacyTitle) { legal = .privacy }
///     .sheet(item: $legal) { LegalSafariSheet(page: $0) }
enum PrimeTruthLegal {
    enum Page: String, Identifiable, CaseIterable {
        case privacy, terms

        var id: String { rawValue }

        var url: URL {
            switch self {
            case .privacy: return URL(string: "https://primetruthteam.github.io/privacy/")!
            case .terms:   return URL(string: "https://primetruthteam.github.io/terms/")!
            }
        }
    }
}

/// In-app Safari sheet so the player never leaves the game.
struct LegalSafariSheet: UIViewControllerRepresentable {
    let page: PrimeTruthLegal.Page

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let vc = SFSafariViewController(url: page.url)
        vc.dismissButtonStyle = .close
        return vc
    }

    func updateUIViewController(_ vc: SFSafariViewController, context: Context) {}
}

/// Drop-in pair of rows for a Settings screen. Titles are injected so the
/// chrome can follow the game's language while the documents stay English.
struct LegalLinksSection: View {
    var privacyTitle: String = "Privacy Policy"
    var termsTitle: String = "Terms of Service"
    @State private var presented: PrimeTruthLegal.Page?

    var body: some View {
        Group {
            Button(privacyTitle) { presented = .privacy }
            Button(termsTitle) { presented = .terms }
        }
        .sheet(item: $presented) { page in
            LegalSafariSheet(page: page)
                .ignoresSafeArea()
        }
    }
}
