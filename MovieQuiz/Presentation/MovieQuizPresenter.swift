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

final class MovieQuizPresenter{
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    var correctAnswers: Int = 0
    
    var questionFactory: QuestionFactoryProtocol?
    
    
    
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
            let givenAnswer = isYes
            viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд закончен!",
                text: "",
                buttonText: "Сыграть еще раз")
                viewController?.show(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
}
