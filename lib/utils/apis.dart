class Apis {

  static const _baseUrl = 'http://calcsoft.saunamaterialkit.com/api/';

  static const loginApi = _baseUrl + 'login';

  static const merchantApi = _baseUrl + 'merchant';
  static const updateMerchantApi = _baseUrl + 'merchant/update'; //post
  static const resetPasswordApi = _baseUrl + 'reset/password'; //post
  static const otpVerifyPassword = _baseUrl + 'otp/varifily/password'; //post


  static const pakagesApi = _baseUrl + 'pakages';
  static const profileUpdateApi = _baseUrl + 'merchant/update'; //used
  static const saunaBooingApi = _baseUrl + 'sauna/rooms/booking';

}