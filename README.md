# BinaBola - ENTS-H113
## Table of Contents

1. [Team ENTS-H113 - CC](#Team-ENTS-H113---CC)
2. [What is BinaBola?](#BinaBola)
3. [Technology](#Technology)
4. [Installation](#Installation)
5. [Database Configuration](#Database-Configuration)
6. [Running the Project](#Running-the-Project)
7. [API Endpoints](#API-Endpoints)


## Team ENTS-H1137 - CC

| Bangkit ID | Name | Learning Path | University |LinkedIn |
| ---      | ---       | ---       | ---       | ---       |
| C117D4KY0805 | Farhan Al Farisi | Cloud Computing | 	Institut Teknologi Nasional Bandung | [![text](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/farhan-al-farisi-744499196/) |
| C117D4KY0310 | Qays Arkan Chairy |  Cloud Computing | Institut Teknologi Nasional Bandung | [![text](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/qaysarkan/) |

## BinaBola

this application has the potential to make a real difference in the lives of Indonesian football players. This application will be a valuable tool for young football talents. It can help them improve their health, physicality, prevent injuries, and reach their full potential. We are committed to making this application affordable and accessible to all young Indonesian football players.

## Technology
The Binabola project is built using the following technologies:

Node.js    : A JavaScript runtime built on Chrome's V8 JavaScript engine.

Hapi.js    : A rich framework for building applications and services.

MySQL      : A relational database management system.

JWT        : JSON Web Tokens for authentication.

Bcrypt     : A library to help hash passwords.

Nodemailer : A module for Node.js applications to send email.

Passport   : A library for authentication.

## Installation

To set up the project locally, follow these steps:

Clone the repository:

```bash
git clone https://github.com/yourusername/binabola.git
cd binabola
```

Install the dependencies:

```bash
npm install
```

Create a .env file in the root directory and add the following environment variables:

```bash
JWT_SECRET=your_jwt_secret
EMAIL_USER=your_email@gmail.com
EMAIL_PASS=your_email_password
DB_HOST=your_database_host
DB_USER=your_database_user
DB_PASSWORD=your_database_password
DB_NAME=your_database_name
CLOUD_RUN=your_cloud_run_url
```

## Database Configuration

The project uses MySQL as the database. Ensure that you have MySQL installed and running on your machine.

Import binabola.sql to your machine

## Running the Project

Start the server:

```bash
npm start
```
For development:

```bash
npm run start:dev
```
The server will run on http://0.0.0.0:8080.

## API Endpoints

Here are the available API endpoints for the Binabola project:

### User Management

Register a new user:

``` bash
POST /register
```

Login a user:

``` bash
POST /login
```

Request a password reset:

``` bash
POST /requestpass
```

Reset password:

``` bash
POST /resetpass
```

Get user details:

``` bash
GET /user/{id}
```

### Exercise Management

Get an exercise by ID:

``` bash
GET /exercise/{id}
```

Get all exercises (optionally filter by category):

``` bash
GET /exercises
```

Calorie Management
Add calories:

``` bash
POST /calories
```

Get daily calories for a user:

``` bash
GET /calories/{user_id}/{date}
```

### Submission and Daily Missions

Submit a video link:

``` bash
POST /submission
```

Start a daily mission:

``` bash
POST /startmission
```

Finish a daily mission:

``` bash
POST /finishmission
```
