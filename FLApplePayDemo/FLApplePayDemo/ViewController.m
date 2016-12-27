//
//  ViewController.m
//  FLApplePayDemo
//
//  Created by clarence on 16/12/26.
//  Copyright © 2016年 gitKong. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>
@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (IBAction)payButtonClick:(id)sender {
    [self fl_pay];
}

- (void)fl_pay{
    // 付款请求是 PKPaymentRequest 类的实例。付款请求包括所购买的商品，用户信息等等。
    PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
    // 在创建付款请求之前，确定用户是否可以使用网络
    BOOL flag = [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:[PKPaymentRequest availableNetworks]];
    if (flag) {
        // 确定用户设备是否允许使用Apple Pay
        flag = [PKPaymentAuthorizationViewController canMakePayments];
        if (flag) {
            PKPaymentSummaryItem *good1 = [PKPaymentSummaryItem summaryItemWithLabel:@"iOS 开发" amount:[NSDecimalNumber decimalNumberWithString:@"10000"]];
            PKPaymentSummaryItem *good2 = [PKPaymentSummaryItem summaryItemWithLabel:@"小程序开发" amount:[NSDecimalNumber decimalNumberWithString:@"10000"]];
            PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"gitkong" amount:[NSDecimalNumber decimalNumberWithString:@"20000"]];
            
            request.paymentSummaryItems = @[ good1, good2, total ];
            // RMB
            request.currencyCode = @"CNY";
            request.countryCode = @"CN";
            request.supportedNetworks = @[ PKPaymentNetworkMasterCard, PKPaymentNetworkVisa, PKPaymentNetworkChinaUnionPay ];
            
            request.merchantIdentifier = @"merchant.FLApplePayDemo";
            
            
            // 通过指定merchantCapabilities属性来指定你支持的支付处理标准，3DS支付方式是必须支持的，EMV方式是可选的。
            request.merchantCapabilities = PKMerchantCapability3DS;
            // 设置后，如果用户之前没有填写过，那么会要求用户必须填写才能够使用Apple Pay。
            
            request.requiredShippingAddressFields = PKAddressFieldPostalAddress | PKAddressFieldPhone | PKAddressFieldEmail | PKAddressFieldName;
            
            // 这个专门用来显示支付’息的控制器是 PKPaymentAuthorizationViewController 类的实例。可以在初始化方法中传入一个付款请求。然后使用modal的方式显示出来即可。
            
            PKPaymentAuthorizationViewController *payVc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
            payVc.delegate = self;
            
            [self presentViewController:payVc animated:YES completion:nil];
        }
        else{
            NSLog(@"用户设备不允许使用Apple Pay");
        }
    }
    else{
        NSLog(@"不支持当前网络");
    }

}


- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion{
    
}


// Sent to the delegate when payment authorization is finished.  This may occur when
// the user cancels the request, or after the PKPaymentAuthorizationStatus parameter of the
// paymentAuthorizationViewController:didAuthorizePayment:completion: has been shown to the user.
//
// The delegate is responsible for dismissing the view controller in this method.
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
