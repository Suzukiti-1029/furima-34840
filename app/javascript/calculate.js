function calculate_tax () {
  const inputFee = document.getElementById('item-price')
  inputFee.addEventListener("keyup", () => {
    const fee = inputFee.value
    const addTaxPrice = document.getElementById('add-tax-price')
    const profit = document.getElementById('profit')
    addTaxPrice.innerHTML = Math.ceil(fee * 0.1)
    profit.innerHTML = Math.floor(fee * 0.9)
  });
}

window.addEventListener('load', calculate_tax);