import { courses } from "./data.js";

const courseGrid = document.getElementById("course-grid");
const searchInput = document.getElementById("search-courses");
const sortButton = document.getElementById("sort-credits");
const totalCreditsEl = document.getElementById("total-credits");
const selectedCourseEl = document.getElementById("selected-course");
const loading = document.getElementById("loading");


axios.interceptors.request.use(
    config => {
        console.log(`API call started: ${config.url}`);
        return config;
    },
    error => Promise.reject(error)
);

function renderCourses(courseList) {
    courseGrid.innerHTML = "";

    const fragment = document.createDocumentFragment();

    courseList.forEach(course => {
        const article = document.createElement("article");

        article.className = "course-card";

        article.dataset.name = course.name;
        article.dataset.grade = course.grade;

        article.innerHTML = `
            <h3>${course.name}</h3>
            <p><strong>Code:</strong> ${course.code}</p>
            <p><strong>Credits:</strong> ${course.credits}</p>
        `;

        fragment.appendChild(article);
    });

    courseGrid.appendChild(fragment);

    const totalCredits = courseList.reduce(
        (total, course) => total + course.credits,
        0
    );

    totalCreditsEl.textContent = `Total Credits Enrolled: ${totalCredits}`;
}

// -------------------------
// Search Courses
// -------------------------
searchInput.addEventListener("input", () => {

    const query = searchInput.value.toLowerCase();

    const filteredCourses = courses.filter(course =>
        course.name.toLowerCase().includes(query) ||
        course.code.toLowerCase().includes(query)
    );

    renderCourses(filteredCourses);

});

// -------------------------
// Sort Courses
// -------------------------
sortButton.addEventListener("click", () => {

    const sortedCourses = [...courses].sort(
        (a, b) => b.credits - a.credits
    );

    renderCourses(sortedCourses);

});

// -------------------------
// Event Delegation
// -------------------------
courseGrid.addEventListener("click", event => {

    const card = event.target.closest(".course-card");

    if (!card) return;

    selectedCourseEl.textContent =
        `Selected Course: ${card.dataset.name} | Grade: ${card.dataset.grade}`;

});

// -------------------------
// Fetch Single User (Async/Await)
// -------------------------
async function fetchUser(id) {

    const response = await fetch(
        `https://jsonplaceholder.typicode.com/users/${id}`
    );

    const data = await response.json();

    console.log(data.name);

    return data;
}

fetchUser(1);

function fetchAllCourses() {

    return new Promise(resolve => {

        setTimeout(() => {

            resolve(courses);

        }, 1000);

    });

}

async function loadCourses() {

    loading.textContent = "Loading courses...";

    const courseList = await fetchAllCourses();

    loading.textContent = "";

    renderCourses(courseList);

}

loadCourses();

const fetchUserData = async () => {
    const [posts, user] = await Promise.all([
        axios.get("https://jsonplaceholder.typicode.com/posts", {
            params: { userId: 1 }
        }),
        fetch("https://jsonplaceholder.typicode.com/users/2")
            .then(res => res.json())
    ]);

    console.log(posts.data); // Axios response data (array of posts)
    console.log(user.name);  // User name
};

async function notify() {

    const spinner = document.getElementById("spinner");
    const notificationSection =
        document.getElementById("notifications");

    spinner.style.display = "block";

    try {

        const posts = await apiFetch(
            "https://jsonplaceholder.typicode.com/posts"
        );

        notificationSection.innerHTML =
            "<h2>Notifications</h2>";

        posts.slice(0, 5).forEach(post => {

            const card = document.createElement("article");

            card.className = "notification-card";

            card.innerHTML = `
                <h3>${post.title}</h3>
                <p>${post.body}</p>
            `;

            notificationSection.appendChild(card);

        });

    } catch (error) {

        notificationSection.innerHTML =
            "<p>Error loading notifications.</p>";

    } finally {

        spinner.style.display = "none";

    }
}

notify();

async function apiFetch(url) {
    try {
        const response = await axios.get(url);
        return response.data;
    } catch (error) {
        console.error(error.message);
        throw error;
    }
}