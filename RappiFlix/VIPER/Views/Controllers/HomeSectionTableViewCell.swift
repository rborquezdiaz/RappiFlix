//
//  HomeSectionTableViewCell.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 02/06/21.
//

import UIKit

protocol MovieSelectionDelegate : class {
    func selectedMovieAt(index : Int, movieListType : MovieListType)
}

class HomeSectionTableViewCell: UITableViewCell {
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var bodyCollectionView: UICollectionView!
    
    var movieList : MovieList?
    weak var delegate : MovieSelectionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        movieList = nil
    }
    
    func setupCell(with movieList: MovieList, title: String) {
        self.sectionTitleLabel.text = title
        self.movieList = movieList
        self.bodyCollectionView.reloadData()
    }
    
    private func setupCollectionView() {
        bodyCollectionView.delegate = self
        bodyCollectionView.dataSource = self
        bodyCollectionView.register(UINib(nibName: Identifiers.CollectionViewCells.MovieCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CollectionViewCells.MovieCollectionViewCell)
    }
}

extension HomeSectionTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CollectionViewCells.MovieCollectionViewCell, for: indexPath) as? MovieCollectionViewCell, let movie = movieList?.results?[indexPath.row] else { return UICollectionViewCell()}
        cell.setupCell(with: movie.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 196)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedMovieAt(index: indexPath.row, movieListType: movieList?.type ?? .generic)
    }
}
