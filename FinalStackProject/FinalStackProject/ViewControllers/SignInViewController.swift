import UIKit
class SignInViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var userNameTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var scrollView: UIScrollView!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SignInViewController가 등장했을 때 키보드를 무조건 올려놓고 싶어서!
        userNameTextField.becomeFirstResponder()
        
        // UITextField is a UIControl, so you can target action
        userNameTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControlEvents.editingDidEndOnExit)
        passwordTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControlEvents.editingDidEndOnExit)

        // UITextField Placeholder Attributed String
        userNameTextField.configureAttributedString(
            string: "아이디를 입력해주세요",
            range: NSRange(location: 0, length: 11),
            stringColor: .lightGray
        )
        
        let placeHolderStr = NSAttributedString(string: "비밀번호를 입력해주세요", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        passwordTextField.attributedPlaceholder = placeHolderStr
        
        
        // Notification Center (default: singleton)
        // Keyboard가 올라왔을 때 화면의 스크롤뷰 UIEdge도 올려주기
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    // Notification 인스턴스에 키보드의 정보를 모두 담고 있다.
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height, 0)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }

    
    // MARK: - UITextFieldDelegate delegate method
    // didEndOnExit: Find out when editing has ended, when TF resign being first respnder
    @objc func didEndOnExit(_ sender: UITextField) {
        if userNameTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        }else if passwordTextField.isFirstResponder {
            passwordTextField.resignFirstResponder()
        }
    }
    
    
    // MARK: - Login Button clicked method
    @IBAction func didTapLoginButton(_sender: RoundButton) {
        guard let username = userNameTextField.text, !username.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        if DataCenter.mainCenter.validateUserInfo(username: username, password: password) {
            // 로그인 성공, didEnterBackground 할 때 write 할 것.
            let newUserDic = ["userID":username,"userPWD":password]
            DataCenter.mainCenter.currentUser = UserModel(userDic: newUserDic)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }else {
            // 로그인 실패
            // Alert action
        }
    }
    
}
