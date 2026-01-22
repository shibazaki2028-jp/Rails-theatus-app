// application.js の一番上にこれを追記
document.addEventListener('click', (e) => {
  // 管理者モードの座席、かつ予約済み（occupied）をクリックした時
  const seat = e.target.closest(".admin-mode .occupied");
  if (seat) {
    const name = seat.dataset.customerName;
    const code = seat.dataset.seatCode;
    alert(`座席：${code}\n予約者：${name} 様`);
  }
});

document.addEventListener('DOMContentLoaded', () => {
    const seatChecks = document.querySelectorAll('.seat-check');
    const selectedList = document.getElementById('selected-seats-list');
    if (priceOptionsData) {
      const priceOptionsHtml = priceOptionsData.innerHTML;
      const seatChecks = document.querySelectorAll('.seat-check');

    const updateSeatDisplay = (checkbox) => {
      const seatId = checkbox.dataset.seatId;
      const seatName = checkbox.dataset.seatName;
      const existingElement = document.getElementById(`selected-seat-${seatId}`);

      const seatLabel = checkbox.closest('.seat-label');
      if (checkbox.checked) {
        seatLabel.classList.add('selected');
      } else {
        seatLabel.classList.remove('selected');
      }
  
      if (checkbox.checked) {
        if (!existingElement) {
          const div = document.createElement('div');
          div.id = `selected-seat-${seatId}`;
          div.className = 'selected-seat-item';
          
          // 初期の price_id があればそれを選択状態にする
          const initialPriceId = checkbox.dataset.initialPriceId;
  
          div.innerHTML = `
            <strong>座席: ${seatName}</strong><br>
            料金種別: <select name="prices[${seatId}]" class="price-select">
              ${priceOptionsHtml}
            </select>
          `;
          selectedList.appendChild(div);
  
          if (initialPriceId) {
            div.querySelector('select').value = initialPriceId;
          }
        }
      } else {
        if (existingElement) existingElement.remove();
      }
      
      // 「座席を選択してください」の表示切り替え
      const noSelection = selectedList.querySelector('.no-selection');
      if (selectedList.querySelectorAll('.selected-seat-item').length > 0) {
        if (noSelection) noSelection.style.display = 'none';
      } else {
        if (noSelection) noSelection.style.display = 'block';
      }
    };
  
    seatChecks.forEach(check => {
      check.addEventListener('change', () => updateSeatDisplay(check));
    });
  
    seatChecks.forEach(check => {
      if (check.checked) {
        updateSeatDisplay(check);
      }
    });
  }
// 管理画面用の処理は独立して動くようにする
const adminMap = document.querySelector(".admin-mode");
if (adminMap) {
    adminMap.addEventListener("click", (e) => {
        const seat = e.target.closest(".occupied");
        if (seat) {
            alert(`座席：${seat.dataset.seatCode}\n予約者：${seat.dataset.customerName} 様`);
        }
    });
}
});