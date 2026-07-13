import { courses } from "./data.js";

const courseGrid = document.querySelector(".course-grid");
const searchInput = document.getElementById("search-courses");
const sortButton = document.getElementById("sort-credits");
const totalCreditsEl = document.getElementById("total-credits");
const selectedCourseEl = document.getElementById("selected-course");

// Reusable render function
function renderCourses(filteredCourses) {
  courseGrid.innerHTML = "";
  const fragment = document.createDocumentFragment();

  filteredCourses.forEach(course => {
    const article = document.createElement("article");
    article.className = "course-card";
    article.dataset.name = course.name;   // store name in dataset
    article.dataset.grade = course.grade; // store grade in dataset
    article.innerHTML = `
      <h3>${course.name}</h3>
      <p><strong>Code:</strong> ${course.code}</p>
      <p><strong>Credits:</strong> ${course.credits}</p>
    `;
    fragment.appendChild(article);
  });

  courseGrid.appendChild(fragment);

  const totalCredits = filteredCourses.reduce(
    (total, course) => total + course.credits,
    0
  );
  totalCreditsEl.textContent = `Total Credits Enrolled: ${totalCredits}`;
}

// Initial render
renderCourses(courses);

// Search filter
searchInput.addEventListener("input", () => {
  const query = searchInput.value.toLowerCase();
  const filtered = courses.filter(course =>
    course.name.toLowerCase().includes(query) ||
    course.code.toLowerCase().includes(query)
  );
  renderCourses(filtered);
});

// Sort by credits (descending)
sortButton.addEventListener("click", () => {
  const sorted = [...courses].sort((a, b) => b.credits - a.credits);
  renderCourses(sorted);
});

// ✅ Event delegation: single listener on container
courseGrid.addEventListener("click", (event) => {
  const card = event.target.closest(".course-card");
  if (card) {
    const name = card.dataset.name;
    const grade = card.dataset.grade;

    // Option 1: Alert
    // alert(`Course: ${name}\nGrade: ${grade}`);

    // Option 2: Update div
    selectedCourseEl.textContent = `Selected Course: ${name} | Grade: ${grade}`;
  }
});
