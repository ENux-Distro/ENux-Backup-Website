/* =============================================================
   ENux VERSION SWITCHER
============================================================= */

const versionButtons = document.querySelectorAll(".version-button");
const commandVersions = document.querySelectorAll(".command-version");

versionButtons.forEach((button) => {
    button.addEventListener("click", () => {

        const selectedVersion = button.dataset.version;

        versionButtons.forEach((item) => {
            item.classList.remove("active");
        });

        commandVersions.forEach((section) => {
            section.classList.remove("active");
        });

        button.classList.add("active");

        const target = document.querySelector(
            `[data-version-content="${selectedVersion}"]`
        );

        if (target) {
            target.classList.add("active");
        }
    });
});


/* =============================================================
   COMMAND EXPANDERS
============================================================= */

const commandButtons =
    document.querySelectorAll(".command-expand");

commandButtons.forEach((button) => {
    button.addEventListener("click", () => {

        const card = button.closest(".command-card");

        if (!card) {
            return;
        }

        card.classList.toggle("open");

        if (card.classList.contains("open")) {
            button.textContent = "HIDE COMMAND ←";
        } else {
            button.textContent = "VIEW COMMAND →";
        }
    });
});
