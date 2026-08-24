const menuButton = document.querySelector("[data-menu-button]");
const navLinks = document.querySelector("[data-nav-links]");

if (menuButton && navLinks) {
  menuButton.addEventListener("click", () => {
    const isOpen = navLinks.classList.toggle("open");
    menuButton.setAttribute("aria-expanded", String(isOpen));
    menuButton.setAttribute("aria-label", isOpen ? "Close menu" : "Open menu");
  });
}

const choices = document.querySelectorAll("[data-choice]");
const resultTitle = document.querySelector("[data-result-title]");
const resultCopy = document.querySelector("[data-result-copy]");
const resultLink = document.querySelector("[data-result-link]");

const finderResults = {
  storage: {
    title: "Start with the small-space category.",
    copy: "The strongest pages here will cover no-closet entryways, tiny bathrooms, under-bed storage, and small kitchens.",
    href: "kits/small-space/",
    link: "Open small-space kits"
  },
  lighting: {
    title: "Start with the dark apartment lighting kit.",
    copy: "Use a bright ambient lamp first, then add task lighting and controlled cords without drilling or hardwiring.",
    href: "kits/daily-fixes/dark-apartment-lighting/",
    link: "Open lighting kit"
  },
  privacy: {
    title: "Use the no-drill category.",
    copy: "This is where curtain, wall decor, cable management, shelves, and entry hook pages will live.",
    href: "kits/no-drill/",
    link: "Open no-drill kits"
  },
  moveout: {
    title: "Start with the move-out category.",
    copy: "Future pages will cover cleaning, adhesive residue, carpet stains, wall repair, and final walkthrough prep.",
    href: "kits/move-out/",
    link: "Open move-out kits"
  }
};

choices.forEach((choice) => {
  choice.addEventListener("click", () => {
    choices.forEach((item) => item.classList.remove("active"));
    choice.classList.add("active");
    const result = finderResults[choice.dataset.choice];
    if (!result) return;
    resultTitle.textContent = result.title;
    resultCopy.textContent = result.copy;
    resultLink.href = result.href;
    resultLink.textContent = result.link;
  });
});

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
