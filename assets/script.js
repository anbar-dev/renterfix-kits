const menuButton = document.querySelector("[data-menu-button]");
const navLinks = document.querySelector("[data-nav-links]");

if (menuButton && navLinks) {
  menuButton.addEventListener("click", () => {
    const isOpen = navLinks.classList.toggle("open");
    menuButton.setAttribute("aria-expanded", String(isOpen));
    menuButton.setAttribute("aria-label", isOpen ? "Close menu" : "Open menu");
  });
}

const problemSearch = document.querySelector("[data-problem-search]");
const problemLinks = [...document.querySelectorAll("[data-problem]")];
const problemMore = document.querySelector("[data-problem-more]");
const problemEmpty = document.querySelector("[data-problem-empty]");

if (problemSearch && problemLinks.length && problemMore && problemEmpty) {
  let showAll = false;

  const updateProblems = () => {
    const query = problemSearch.value.trim().toLocaleLowerCase();
    let visibleCount = 0;

    problemLinks.forEach((link) => {
      const words = `${link.textContent} ${link.dataset.search || ""}`.toLocaleLowerCase();
      const visible = query ? words.includes(query) : showAll || link.hasAttribute("data-featured");
      link.hidden = !visible;
      if (visible) visibleCount += 1;
    });

    problemEmpty.hidden = visibleCount !== 0;
    problemMore.hidden = Boolean(query);
    problemMore.textContent = showAll ? "Show fewer problems" : `See all ${problemLinks.length} problems`;
    problemMore.setAttribute("aria-expanded", String(showAll));
  };

  problemSearch.addEventListener("input", updateProblems);
  problemMore.addEventListener("click", () => {
    showAll = !showAll;
    updateProblems();
  });
  updateProblems();
}

document.querySelectorAll('a[href*="amazon.com"]').forEach((link) => {
  link.rel = "sponsored nofollow noopener";
  link.target = "_blank";
});

document.querySelectorAll(".product-media img").forEach((image) => {
  const showFallback = () => {
    if (image.naturalWidth > 2 && image.naturalHeight > 2) return;
    image.classList.add("is-missing");
    const media = image.closest(".product-media");
    if (!media || media.querySelector(".image-fallback")) return;
    const fallback = document.createElement("span");
    fallback.className = "image-fallback";
    fallback.textContent = "Image unavailable";
    media.appendChild(fallback);
  };

  if (image.complete) showFallback();
  image.addEventListener("load", showFallback);
  image.addEventListener("error", showFallback);
});

document.querySelectorAll("[data-mailto-form]").forEach((form) => {
  form.addEventListener("submit", (event) => {
    event.preventDefault();
    const recipient = form.dataset.contactEmail;
    if (!recipient) return;

    const name = form.querySelector("[name='name']")?.value.trim() || "Not provided";
    const email = form.querySelector("[name='email']")?.value.trim() || "Not provided";
    const topic = form.querySelector("[name='topic']")?.value.trim() || "Not provided";
    const requestMessage = form.querySelector("[name='message']")?.value.trim() || "Not provided";
    const subject = `Apartment kit request: ${topic}`;
    const body = [
      `Name: ${name}`,
      `Reply email: ${email}`,
      `Renter problem: ${topic}`,
      "",
      requestMessage
    ].join("\n");
    const message = form.querySelector("[data-form-message]");
    if (message) {
      message.hidden = false;
      message.textContent = "Your email app should open with the request ready to send. Nothing is stored on this site.";
    }
    window.location.href = `mailto:${recipient}?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`;
  });
});
