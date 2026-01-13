//= require rails-ujs
//= require_tree . 
document.addEventListener('DOMContentLoaded', () => {
    const seatContainer = document.querySelector('.seat-selection');
    const summaryList = document.getElementById('selected-seats-list');
    const priceDataElement = document.getElementById('price-options-data');
    
    if (!seatContainer || !summaryList || !priceDataElement) return;
  
    const priceOptions = priceDataElement.innerHTML;
  
    seatContainer.addEventListener('change', (e) => {
        if (e.target.classList.contains('seat-check')) {
            const { seatId, seatName } = e.target.dataset;
  
            if (e.target.checked) {
                const itemHtml = `<div class="selected-seat-item" id="item_${seatId}" style="margin-bottom: 10px; border-top: 1px solid #eee; padding: 10px;">
                        <strong>座席: ${seatName}</strong>
                        <div style="margin-top: 5px;">
                            料金種別: 
                            <select name="prices[${seatId}]" class="price-select">
                                ${priceOptions}
                            </select>
                        </div>
                    </div>`;
                
                const noSelectionMsg = summaryList.querySelector('.no-selection');
                if (noSelectionMsg) noSelectionMsg.remove();
                
                summaryList.insertAdjacentHTML('beforeend', itemHtml);
            } else {
                const item = document.getElementById(`item_${seatId}`);
                if (item) item.remove();
                
                if (summaryList.children.length === 0) {
                    summaryList.innerHTML = '<p class="no-selection">座席を選択してください</p>';
                }
            }
        }
    });
});