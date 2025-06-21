# T300 - Functional Programming: Final Assessment

This assessment instrument contains the final activity for the curricular component **T300 - Functional Programming**.

## Objective

Develop a **personal financial management REST API** using **Elixir** and the **Phoenix Framework**. The goal is to create an application capable of registering a person's income and expenses.

## Features

The application provides the following features:

- **Income registration**
- **Expense registration**
- **Listing of financial transactions**
- **Association of tags to transactions**
- **User registration and authentication**

## Architecture

- **Frontend:** Developed using **Next.js**.
- **Backend:** Developed using **Elixir** with the **Phoenix framework**.
- The frontend communicates with the backend REST API to perform all operations such as registration, listing, and authentication.

## Project Structure

The project is divided into two main folders:

- `back`: contains the backend code in Elixir/Phoenix
- `front`: contains the frontend code in Next.js

The **backend** is responsible for all business logic, data persistence, and user authentication.  
The **frontend** provides a user-friendly interface for interacting with the system, allowing users to manage their personal finances.

---

## Running the Project with Docker

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/) installed.

### Steps

1. **Clone the repository:**

   ```sh
   git clone <repo-url>
   cd financeManagerApp
   ```

2. **Build and start all services:**

   ```sh
   docker compose up --build
   ```

   This will:

   - Start the PostgreSQL database
   - Start the Elixir/Phoenix backend
   - Start the Next.js frontend
   - Start Adminer for database management (optional)

3. **Access the services:**
   - **Frontend:** [http://localhost:3000](http://localhost:3000)
   - **Backend API:** [http://localhost:4000](http://localhost:4000)
   - **Adminer (DB Admin):** [http://localhost:18080](http://localhost:18080)

### Notes

- The backend automatically runs migrations on startup.
- The frontend is configured to consume the local backend API.
- To stop all services:
  ```sh
  docker compose down
  ```

---

## Default Database Credentials

- **User:** postgres
- **Password:** password
- **Database:** trabalhoav3_dev

---

## Contact

Questions or suggestions? Please contact the project maintainer.

