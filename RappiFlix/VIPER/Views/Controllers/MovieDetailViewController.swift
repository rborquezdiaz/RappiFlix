//
//  MovieDetailViewController.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 03/06/21.
//

import UIKit
import AVKit
import WebKit

class MovieDetailViewController: UIViewController, AnyView {
    
    var presenter: AnyPresenter?
    var movieDetail : Movie?
    var webView: WKWebView!
        
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var clasificationLabel: UILabel!
    @IBOutlet weak var posterImageView: NetworkImageView!
    @IBOutlet weak var trailerVideoView: UIView!
    @IBOutlet weak var storylineLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var webViewContainerView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        self.updateInterface()
        self.navigateToTrailer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setInterfaceMode()
    }
    
    func setInterfaceMode() {
        let darkMode = UserDefaults.standard.bool(forKey: UserDefaultsKeys.DarkMode)
        if darkMode {
            self.overrideUserInterfaceStyle = .dark
        } else {
            self.overrideUserInterfaceStyle = .light
        }
    }
    
    private func setupWebView() {
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.allowsAirPlayForMediaPlayback = true
        webView = WKWebView(frame: self.webViewContainerView.frame, configuration: webViewConfig)
    }
    
    private func navigateToTrailer() {
        // This didn't work either, I would probably need to set the html body & iFrame manually or use some pod.
        guard let url = URL(string: movieDetail?.trailerURL ?? "") else { return }
        webView.load(URLRequest(url: url))
    }

    func update(with entity: AnyEntity) {
        DispatchQueue.main.async {
            guard let movieDetailEntity = entity as? Movie else { return }
            self.movieDetail = movieDetailEntity
            self.navigateToTrailer()
            self.updateInterface()
        }
    }
    
    func update(with errorMessage: String) {
        //TODO: Alerts
        print(errorMessage)
    }
    
    private func updateInterface() {
        updateTextValues()
        setImage()
    }
    
    private func updateTextValues() {
        self.movieNameLabel.text = movieDetail?.title
        self.yearLabel.text = getYear()
        self.clasificationLabel.text = movieDetail?.adult == true ? "Family" : "Adult"
        self.durationLabel.text = formattedRuntime()
        self.ratingLabel.text = "\(movieDetail?.vote_average ?? 0)"
        self.storylineLabel.text = movieDetail?.overview
        self.taglineLabel.text = "Tagline: \(movieDetail?.tagline ?? "")"
        self.releaseLabel.text = "Release date: \(movieDetail?.release_date ?? "")"
        self.languageLabel.text = "Original language: \(movieDetail?.original_language ?? "")"
        self.revenueLabel.text = "Revenue: " + (movieDetail?.revenue ?? 0 > 0 ? formatAmount(amount: movieDetail?.revenue ?? 0) : "Not available")
        self.budgetLabel.text = "Budget: " + (movieDetail?.revenue ?? 0 > 0 ? formatAmount(amount: movieDetail?.revenue ?? 0) : "Not available")
    }
    
    private func formatAmount(amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US") //Avoid MX$ prefix
        
        if let formattedString = formatter.string(from: NSNumber(value: amount))
        {
            return formattedString
        } else {
            return ""
        }
    }
    
    private func setImage() {
        let posterPath = movieDetail?.poster_path
        let fullPath =  (NetworkManager.shared().urlRequest(for: .poster(posterPath ?? ""))?.url?.absoluteString ?? "") + ServerRequest.poster(posterPath ?? "").path
        if let url = URL(string: fullPath) {
            posterImageView.loadImageWithUrl(url)
        } else {
            posterImageView.image = #imageLiteral(resourceName: "rappi-placeholder")
        }
    }
    
    private func getYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        guard let releaseDateString = movieDetail?.release_date else { return ""}
        guard let date = dateFormatter.date(from: releaseDateString) else { return ""}

        dateFormatter.dateFormat = "YYYY"
        let yearDate = dateFormatter.string(from: date)
        
        return yearDate
    }
    
    private func formattedRuntime() -> String {
        guard let runtime = movieDetail?.runtime else { return ""}
        let hours = runtime / 60
        let minutes = runtime % 60
        
        let hourString = hours > 1 ? "\(hours)h" : ""
        let minutesString = "\(minutes)min"
        return hourString + minutesString
    }
    
    private func playVideo() {
        
        guard let fullUrl = URL(string: movieDetail?.trailerURL ?? "") else { return }
        let player = AVPlayer(url: fullUrl)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    @IBAction func didPressPlayVideo(_ sender: Any) {
        playVideo()
    }
    
}

extension MovieDetailViewController : WKNavigationDelegate {
    
}
