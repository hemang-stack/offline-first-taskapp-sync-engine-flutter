import express from "express";
import type { Request, Response } from "express";
import { db } from "../db/index.js";
import { users, type NewUser } from "../db/schema.js";
import { eq } from "drizzle-orm";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { auth, type AuthRequest } from "../middleware/auth.js";

const authRouter = express.Router();

interface SignUpBody {
    name: string;
    email: string;
    password: string;
}

interface LoginBody {
    email: string;
    password: string;
}

authRouter.post(
    "/signup",
    async (req: Request<{}, {}, SignUpBody>, res: Response) => {
        try {
            const { name, email, password } = req.body;
            const existingUser = await db
                .select()
                .from(users)
                .where(eq(users.email, email));
            if (existingUser.length) {
                res
                    .status(400)
                    .json({ error: "User with the same email already exists!" });
                return;
            };
            // hash password
            const hashedPassword = await bcrypt.hash(password, 8);
            // store in db
            const newUser: NewUser = {
                name,
                email,
                password: hashedPassword
            };

            const [user] = await db.insert(users).values(newUser).returning();
            res.status(201).json(user);
        } catch (e) {
            res.status(500).json({ error: e });
        };
    }
);

authRouter.post(
    "/login",
    async (req: Request<{}, {}, LoginBody>, res: Response) => {
        try {
            // get req body
            const { email, password } = req.body;
            // check if user doesn't exists
            const [existingUser] = await db
                .select()
                .from(users)
                .where(eq(users.email, email));

            if (!existingUser) {
                res
                    .status(400)
                    .json({ error: "User with this email doesn't exist!" });
                return;
            };
            // comparing password with the existing one
            const isMatch = await bcrypt.compare(password, existingUser.password);
            if (!isMatch) {
                res.status(400).json({ error: "Incorrect Password" });
                return;
            }

            const token = jwt.sign({ id: existingUser.id }, "passwordKey");

            res.json({ token, ...existingUser });
        } catch (e) {
            res.status(500).json({ error: e });
        };
    }
);

authRouter.post(
    "/tokenIsValid",
    async (req, res) => {
        try {
            //get the header
            const token = req.header("x-auth-token");
            //check if the token is valid
            if (!token) {
                res.json(false)
                return;
            };
            const verified = jwt.verify(token, "passwordKey");
            if (!verified) {
                res.json(false);
                return;
            }
            //if yes, get the user data

            const verifiedToken = verified as { id: string };

            const user = await db
                .select()
                .from(users)
                .where(eq(users.id, verifiedToken.id));
            //if no, return false
            if (user.length == 0) {
                res.json(false)
                return;
            };

            if (user) {
                res.json(true)
                return;
            };

        } catch (e) {
            res.status(500).json(false);
        };
    }
);

authRouter.get("/", auth, async(req: AuthRequest, res) => {
    try {
        if(!req.user){
            res.status(401).json({ error: "User not found!" });
            return;
        }

        const [user] = await db.select().from(users).where(eq(users.id, req.user));

        res.json({...user, token: req.token});

    } catch (e) {
        res.status(500).json(false);
    };
});

export default authRouter;