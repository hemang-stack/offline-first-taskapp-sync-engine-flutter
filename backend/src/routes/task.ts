import { Router } from "express";
import { auth, type AuthRequest } from "../middleware/auth.js";
import { tasks, type NewTask } from "../db/schema.js";
import { db } from "../db/index.js";
import { eq } from "drizzle-orm";

const taskRouter = Router();

taskRouter.post("/", auth, async (req: AuthRequest, res) => {
    try {
        req.body = { ...req.body, dueAt: new Date(req.body.dueAt), uid: req.user };
        const newTask: NewTask = req.body;
        const [task] = await db.insert(tasks).values(newTask).returning();

        res.status(201).json(task);
    } catch (e) {
        res.status(500).json({ error: e });
    }
});
taskRouter.get("/", auth, async (req: AuthRequest, res) => {
    try {
        const allTasks = await db.select().from(tasks).where(eq(tasks.uid, req.user!));

        res.status(201).json(allTasks);
    } catch (e) {
        res.status(500).json({ error: e });
    }
});

taskRouter.delete("/", auth, async (req: AuthRequest, res) => {
    try {
        const { taskId }: { taskId: string } = req.body;
        await db.delete(tasks).where(eq(tasks.id, taskId));

        res.json(true);
    } catch (e) {
        res.status(500).json({ error: e });
    }
});

taskRouter.put("/:taskId", auth, async (req: AuthRequest, res) => {
    try {
        const taskId = req.params.taskId as string;

        const updatedBody = {
            ...req.body,
            dueAt: new Date(req.body.dueAt),
        };

        const [updatedTask] = await db
            .update(tasks)
            .set(updatedBody)
            .where(eq(tasks.id, taskId))
            .returning();

        res.json(updatedTask);
    } catch (e) {
        console.error(e);

        res.status(500).json({
            error: String(e),
        });
    }
});

export default taskRouter;