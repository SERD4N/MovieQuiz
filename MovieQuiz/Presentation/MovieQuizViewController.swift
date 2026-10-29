import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol{
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        presenter = MovieQuizPresenter(viewController:self)
        
        showLoadingIndicator()
        
    }
    
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonCLicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    @IBOutlet private weak var noButtonClicked: UIButton!
    @IBOutlet private weak var yesButtonCliked: UIButton!
    
    // MARK: - Outlets
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    // MARK: - Properties
    
    private var alertPresenter = ResultAlertPresenter()
    
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Show
    
    func showLoadingIndicator(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator(){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
            
            
            self.showLoadingIndicator()
            self.presenter.loadData()
        }
        alertPresenter.show(in: self, model: model)
    }
        
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = UIImage(data: step.image) ?? UIImage()
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        noButtonClicked.isEnabled = true
        yesButtonCliked.isEnabled = true
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
                    title: result.title,
                    message: result.text,
                    preferredStyle: .alert)
                    
                let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                        guard let self = self else { return }
                        self.presenter.restartGame()
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor(named: "YPGreen")?.cgColor : UIColor(named: "YPRed")?.cgColor
        
        noButtonClicked.isEnabled = false
        yesButtonCliked.isEnabled = false
    }
    
}
