document.addEventListener('DOMContentLoaded', () => {
    const seatChecks = document.querySelectorAll('.seat-check');
    const selectedList = document.getElementById('selected-seats-list');
    const priceOptionsHtml = document.getElementById('price-options-data').innerHTML;
  

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
  });