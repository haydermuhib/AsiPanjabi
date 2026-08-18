/* ==========================================================================
   AsiPanjabi Frontend Interactive Engine
   ========================================================================== */

// 1. Single Script Selector Persistence (Gurmukhi, Shahmukhi, or Romanized)
let currentScriptFilter = localStorage.getItem('asipanjabi_script_filter') || 'gurmukhi';
if (currentScriptFilter === 'all') {
  currentScriptFilter = 'gurmukhi';
}

function setGlobalScript(mode) {
  currentScriptFilter = mode;
  localStorage.setItem('asipanjabi_script_filter', mode);
  
  // Update navbar pill UI state
  const buttons = document.querySelectorAll('#scriptSelectorGroup .pill-item');
  buttons.forEach(btn => {
    if (btn.getAttribute('onclick') && btn.getAttribute('onclick').includes(`'${mode}'`)) {
      btn.classList.add('active');
    } else {
      btn.classList.remove('active');
    }
  });

  // Re-render guided lesson studio or legacy card engines
  if (typeof renderCurrentStudioStep === 'function') {
    renderCurrentStudioStep();
  } else if (typeof renderCurrentCard === 'function') {
    renderCurrentCard();
  }
}

// 2. Auth State Sync (Strictly No Emojis)
function checkAuthStatus() {
  const token = localStorage.getItem('asipanjabi_token');
  const userJson = localStorage.getItem('asipanjabi_user');
  const container = document.getElementById('authNavContainer');

  if (token && userJson && container) {
    try {
      const user = JSON.parse(userJson);
      container.innerHTML = `
        <span style="font-size: 0.9rem; font-weight: 700; color: var(--color-ink);">Welcome, ${user.full_name || 'Learner'}</span>
        <button onclick="logoutUser()" class="btn-secondary" style="padding: 6px 14px; font-size: 0.85rem;">Sign out</button>
      `;
    } catch (e) {
      console.error("Error parsing user state:", e);
    }
  }
}

function logoutUser() {
  localStorage.removeItem('asipanjabi_token');
  localStorage.removeItem('asipanjabi_user');
  window.location.href = '/';
}

document.addEventListener('DOMContentLoaded', () => {
  setGlobalScript(currentScriptFilter);
  checkAuthStatus();
});
