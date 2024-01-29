import UIKit
class ProfileTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.8
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)

        // Начальное состояние: полностью прозрачный и уменьшенный
        toViewController.view.alpha = 0
        toViewController.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        // Анимация к конечному состоянию
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                toViewController.view.alpha = 1
                toViewController.view.transform = CGAffineTransform.identity
            },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
