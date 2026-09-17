(function () {
  var form = document.getElementById("booking-form");
  var fallback = document.getElementById("fallback");
  var summaryEl = document.getElementById("summary");
  var copyBtn = document.getElementById("copy-btn");

  function buildSummary(data) {
    return [
      "BOOKING REQUEST",
      "Name: " + data.name,
      "Phone: " + data.phone,
      "Service: " + data.service,
      "Preferred time: " + data.preferred_time,
      "Notes: " + (data.notes || "(none)"),
      "Submitted: " + new Date().toLocaleString()
    ].join("\n");
  }

  form.addEventListener("submit", function (e) {
    var action = (form.getAttribute("action") || "").trim();
    var wired = action && action !== "#" && action.indexOf("YOUR_ID") === -1;

    var data = {
      name: form.name.value.trim(),
      phone: form.phone.value.trim(),
      service: form.service.value,
      preferred_time: form.preferred_time.value.trim(),
      notes: form.notes.value.trim()
    };

    if (!wired) {
      e.preventDefault();
      summaryEl.textContent = buildSummary(data);
      fallback.classList.remove("hidden");
      fallback.scrollIntoView({ behavior: "smooth", block: "nearest" });
      return;
    }
    // Wired: allow normal POST (Formspree / n8n / custom). Optional: could fetch() here.
  });

  copyBtn.addEventListener("click", function () {
    var text = summaryEl.textContent || "";
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(text).then(function () {
        copyBtn.textContent = "Copied!";
        setTimeout(function () { copyBtn.textContent = "Copy summary"; }, 2000);
      });
    } else {
      var range = document.createRange();
      range.selectNodeContents(summaryEl);
      var sel = window.getSelection();
      sel.removeAllRanges();
      sel.addRange(range);
      copyBtn.textContent = "Select all — press Ctrl/Cmd+C";
    }
  });
})();
