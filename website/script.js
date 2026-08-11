const API_URL = "";

const subscribeForm = document.getElementById("subscribe-form");

subscribeForm.addEventListener("submit", async (event) => {
    event.preventDefault();

    const email = document.getElementById("email").value;
    const message = document.getElementById("subscribe-message");

    if (!email) {
        message.textContent = "Please enter your email.";
        return;
    }

    message.textContent = "Subscription API will be connected soon.";

    console.log("Email:", email);
});