//
//  API Paths.swift
//  PumpkinPal
//
//  Created by Munib Hamza on 10/04/2023.
//

import Foundation

internal struct APIConstants {
    // MARK: Live
    static let BasePath = "https://livelonglong.uk/api/"
}

internal struct APIPaths {

    static let register_student = APIConstants.BasePath + "user/studentregister"
    
    static let register_staff = APIConstants.BasePath + "user/staffregister"
    
    static let get_user = APIConstants.BasePath + "user/auth/user"
   
    static let login_user = APIConstants.BasePath + "user/login/"
    
    static let forgotPassword = APIConstants.BasePath + "user/forgotPassword"
    
    static let verifyEmail = APIConstants.BasePath + "user/verifyEmail"
    
    static let generateOTP = APIConstants.BasePath + "user/genrateOtp"
    
    static let bookSession = APIConstants.BasePath + "session/booking/class"
}


/*
 
 16 Aug - 2024
 
 - Ui Improvements (Home screen, Over all UI updates) in terms of theames
 - Validation based textfields border color goes red
 - Optional/mendatory fields email, password, username
 - SignUp process hadler (slider)
 - Back button on registration screens
 -
 
 
 -- Notification high level architecture
 
 
 
 */
