class AppError extends Error {
    constructor(statusCode, message, status = 'error') {
        super(message);
        this.statusCode = statusCode;
        this.status = status;
        Error.captureStackTrace(this, this.constructor);
    }
}

class BadRequestError extends AppError {
    constructor(message = 'Bad Request') {
        super(400, message, 'fail');
    }
}

class NotFoundError extends AppError {
    constructor(message = 'Not Found') {
        super(404, message, 'fail');
    }
}

class InternalServerError extends AppError {
    constructor(message = 'Internal Server Error') {
        super(500, message, 'error');
    }
}

module.exports = {
    AppError,
    BadRequestError,
    NotFoundError,
    InternalServerError
};





//app.ts
const express = require('express');
const { AppError, BadRequestError, NotFoundError, InternalServerError } = require('./errors');
const app = express();
const port = 3000;

app.use(express.json());

// Example endpoint
app.get('/', (req, res) => {
    res.send('Hello World!');
});


app.get('/example', async (req, res, next) => {
    try {
        throw new BadRequestError('This is a bad request example.');
        res.send('This will not execute if an error is thrown.');
    } catch (err) {
        next(err); 
    }
});

// Global error handler
app.use((err, req, res, next) => {
    if (err instanceof AppError) {
        res.status(err.statusCode).json({
            status: err.status,
            message: err.message
        });
    } else {
        res.status(500).json({
            status: 'error',
            message: 'An unexpected error occurred.'
        });
    }
});

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});


//endpoints
app.post('/data', async (req, res, next) => {
    try {
        if (!req.body.name) {
            throw new BadRequestError('Name is required.');
        }
        res.status(201).send('Data processed.');
    } catch (err) {
        next(err); 
    }
});

app.get('/nonexistent', async (req, res, next) => {
    try {
        throw new NotFoundError('This resource was not found.');
        res.send('This will not execute if an error is thrown.');
    } catch (err) {
        next(err); 
    }
});




//automatic data handler process
class AppError extends Error {
    constructor(statusCode, message, status = 'error') {
        super(message);
        this.statusCode = statusCode;
        this.status = status;
        Error.captureStackTrace(this, this.constructor);
    }
}

class BadRequestError extends AppError {
    constructor(message = 'Bad Request') {
        super(400, message, 'fail');
    }
}

module.exports = {
    AppError,
    BadRequestError
};



//check parameters
const { BadRequestError } = require('./errors');

const checkRequiredFields = (fields) => {
    return (req, res, next) => {
        const missingFields = fields.filter(field => !req.body[field]);

        if (missingFields.length > 0) {
            const message = `Missing required fields: ${missingFields.join(', ')}`;
            return next(new BadRequestError(message));
        }

        next();
    };
};

module.exports = checkRequiredFields;


//app.ts
const express = require('express');
const checkRequiredFields = require('./checkRequiredFields');
const { AppError, BadRequestError, NotFoundError, InternalServerError } = require('./errors');
const app = express();
const port = 3000;

app.use(express.json());

// Example endpoint using custom errors
app.post('/register', checkRequiredFields(['name', 'email', 'password']), async (req, res, next) => {
    try {
        res.status(201).send('User registered successfully.');
    } catch (err) {
        next(err);
    }
});

// Global error handler
app.use((err, req, res, next) => {
    if (err instanceof AppError) {
        res.status(err.statusCode).json({
            status: err.status,
            message: err.message
        });
    } else {
        res.status(500).json({
            status: 'error',
            message: 'An unexpected error occurred.'
        });
    }
});

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
