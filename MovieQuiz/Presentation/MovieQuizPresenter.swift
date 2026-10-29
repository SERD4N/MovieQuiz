//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Даниил Сериков on 29.10.2026.
//

import Foundation

struct QuizStepViewModel{
    let image: Data;
    let question: String;
    let questionNumber: String;
}

final class MovieQuizPresenter: QuestionFactoryDelegate{
    private let statisticService: StatisticServiceProtocol!
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    
      
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
          
        statisticService = StatisticService()
          
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func makeResultsMessage() -> String {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let bestGame = statisticService.bestGame
            
            let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gameCount)"
            let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
            let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
            + " (\(bestGame.date.dateTimeString))"
            let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccurancy))%"
            
            let resultMessage = [
                currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
            ].joined(separator: "\n")
            
            return resultMessage
        }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.proceedToNextQuestionOrResults()
            }
        }
    
    
    // MARK: - QuestionFactoryDelegate
    func didLoadDataFromServer() {
            viewController?.hideLoadingIndicator()
            questionFactory?.requestNextQuestion()
        }
        
        func didFailToLoadData(with error: Error) {
            let message = error.localizedDescription
            viewController?.showNetworkError(message: message)
        }
        
        func didReceiveNextQuestion(question: QuizQuestion?) {
            guard let question = question else {
                return
            }
            
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.show(quiz: viewModel)
            }
        }
    
    func restartGame() {
           currentQuestionIndex = 0
           correctAnswers = 0
           questionFactory?.requestNextQuestion()
       }
    
    func loadData() {
        questionFactory?.loadData()
    }
    
    
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    private var currentQuestion: QuizQuestion?
    
    private var correctAnswers: Int = 0
    
    
    func isLastQuestion() ->Bool{
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex(){
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion(){
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: model.image,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func yesButtonClicked() {
            didAnswer(isYes: true)
        }
        
        func noButtonClicked() {
            didAnswer(isYes: false)
        }
        
        private func didAnswer(isYes: Bool) {
            guard let currentQuestion = currentQuestion else {return}
            let isCorrect = (isYes == currentQuestion.correctAnswer)
            if isCorrect { correctAnswers += 1 }
            proceedWithAnswer(isCorrect: isCorrect)
        }
    
    private func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд закончен!",
                text: makeResultsMessage(),
                buttonText: "Сыграть еще раз")
                viewController?.show(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
}
