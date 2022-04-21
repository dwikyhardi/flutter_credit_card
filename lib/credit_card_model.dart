class CreditCardModel {
  CreditCardModel(
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
  );

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
}
