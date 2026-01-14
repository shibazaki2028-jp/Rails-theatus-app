document.addEventListener('DOMContentLoaded', () => {
    const seatChecks = document.querySelectorAll('.seat-check');
    const selectedList = document.getElementById('selected-seats-list');
    const priceOptionsHtml = document.getElementById('price-options-data').innerHTML;
  
    // 1. 座席の表示を更新するメイン関数
    const updateSeatDisplay = (checkbox) => {
      const seatId = checkbox.dataset.seatId;
      const seatName = checkbox.dataset.seatName; // dataset.seatName で取得
      const existingElement = document.getElementById(`selected-seat-${seatId}`);
  
      if (checkbox.checked) {
        if (!existingElement) {
          // 選択リストに追加
          const div = document.createElement('div');
          div.id = `selected-seat-${seatId}`;
          div.className = 'selected-seat-item';
          
          // 編集時：初期の price_id があればそれを選択状態にする
          const initialPriceId = checkbox.dataset.initialPriceId;
  
          div.innerHTML = `
            <strong>座席: ${seatName}</strong><br>
            料金種別: <select name="prices[${seatId}]" class="price-select">
              ${priceOptionsHtml}
            </select>
          `;
          selectedList.appendChild(div);
  
          // 初期値があればセット
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
  
    // 2. イベントリスナーの設定（クリック時）
    seatChecks.forEach(check => {
      check.addEventListener('change', () => updateSeatDisplay(check));
    });
  
    // 3. 【重要】初期化処理：ページ読み込み時に最初からチェックされている席を処理
    seatChecks.forEach(check => {
      if (check.checked) {
        updateSeatDisplay(check);
      }
    });
  });