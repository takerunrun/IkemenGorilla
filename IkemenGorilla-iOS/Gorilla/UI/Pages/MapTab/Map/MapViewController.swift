//
//  MapViewController.swift
//  Gorilla
//
//  Created by admin on 2020/06/16.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import MapKit
import FloatingPanel

final class MapViewController: UIViewController, View, ViewConstructor, TransitionPresentable {
    
    // MARK: - Variables
    var disposeBag = DisposeBag()
    
    // MARK: - Views
    let mapView = MKMapView()
    
    let zooListFloatingPanelController = FloatingPanelController().then {
        $0.surfaceView.cornerRadius = 24
        $0.surfaceView.shadowHidden = true
    }
    
    let zooListViewController = MapZooListViewController()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupViewConstraints()
        setupMap()
        setupFloatingController()
    }
    
    // MARK: - Setup Methods
    func setupViews() {
        view.addSubview(mapView)
    }
    
    func setupViewConstraints() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupMap() {
        mapView.delegate = self
    }
    
    func setupFloatingController() {
        zooListViewController.reactor = reactor
        zooListFloatingPanelController.delegate = self
        zooListFloatingPanelController.set(contentViewController: zooListViewController)
        zooListFloatingPanelController.addPanel(toParent: self)
        zooListFloatingPanelController.hide()
    }
    
    // MARK: - Bind Method
    func bind(reactor: MapReactor) {
        // Action
        reactor.action.onNext(.loadZoos)
        
        zooListViewController.closeButton.rx.tap
            .bind { [weak self] _ in
                self?.zooListFloatingPanelController.move(to: .hidden, animated: true)
                reactor.action.onNext(.closeList)
                if let clusterAnnotation = reactor.currentState.clusterAnnotation {
                    self?.mapView.deselectAnnotation(clusterAnnotation, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        zooListViewController.zoosCollectionView.rx.itemSelected
            .bind { [weak self] indexPath in
                logger.debug(indexPath)
                let zoo = reactor.currentState.selectedAnnotations[indexPath.row].zoo
                self?.showZooDetailPage(zooDetailReactor: reactor.createZooDetailReactor(zoo: zoo))
            }
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.zoos }
            .distinctUntilChanged()
            .bind { [weak self] zoos in
                for zoo in zoos {
                    let pointAnnotation = PointZooAnnotation(zoo: zoo)
                    let lat = zoo.latitude
                    let lon = zoo.longitude
                    pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    pointAnnotation.title = zoo.name
                    self?.mapView.addAnnotation(pointAnnotation)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedAnnotations }
            .distinctUntilChanged()
            .bind { [weak self] annotations in
                if annotations != [] {
                    logger.debug("annotations: \(annotations.count)")
                    self?.zooListFloatingPanelController.move(to: .half, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let markerAnnotation = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
            markerAnnotation.displayPriority = .required
            markerAnnotation.clusteringIdentifier = "id"
            markerAnnotation.canShowCallout = true
            
            return markerAnnotation
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let cluster = view.annotation as? MKClusterAnnotation {
            reactor?.action.onNext(.tapCluster(cluster))
        }
        if let annotation = view.annotation as? PointZooAnnotation {
            guard let zooDetailReactor = reactor?.createZooDetailReactor(zoo: annotation.zoo) else { return }
            showZooDetailPage(zooDetailReactor: zooDetailReactor)
        }
    }
}

extension MapViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return MapZooListPanelLayout()
    }
    
    func floatingPanelShouldBeginDragging(_ vc: FloatingPanelController) -> Bool {
        return true
    }
}

class MapZooListPanelLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition {
        return .half
    }

    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 32
        case .half: return MapZooListViewController.Const.height
        case .tip: return 80
        default: return nil
        }
    }
}
