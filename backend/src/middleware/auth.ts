import type { UUID } from "crypto";
import type { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";
import { db } from "../db/index.js";
import { users } from "../db/schema.js";
import { eq } from "drizzle-orm";

export interface AuthRequest extends Request {
    user?: UUID;
    token?: string;
}

export const auth = async (
    req: AuthRequest,
    res: Response,
    next: NextFunction
) => {
    try {
        const token = req.header("x-auth-token");

        if (!token) {
            res.status(401).json({ error: "No auth Token. Access denied" });
            return;
        };
        const verified = jwt.verify(token, "passwordKey");
        if (!verified) {
            res.status(401).json({ error: "Token Verification failed" });
            return;
        }

        const verifiedToken = verified as { id: UUID };

        const user = await db
            .select()
            .from(users)
            .where(eq(users.id, verifiedToken.id));

        if (user.length === 0) {
            res.status(401).json({
                error: "User not Found",
            });
            return;
        }

        req.user = verifiedToken.id;
        req.token = token;

        next();
    } catch (e) {
    console.error("AUTH ERROR:", e);

    res.status(500).json({
        error: String(e),
    });
}
};