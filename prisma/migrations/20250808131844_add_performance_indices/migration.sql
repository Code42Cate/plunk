-- CreateIndex
CREATE INDEX "contacts_projectId_createdAt_idx" ON "contacts"("projectId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "contacts_email_idx" ON "contacts"("email");

-- CreateIndex
CREATE INDEX "emails_createdAt_idx" ON "emails"("createdAt" DESC);

-- CreateIndex
CREATE INDEX "emails_status_idx" ON "emails"("status");

-- CreateIndex
CREATE INDEX "emails_contactId_createdAt_idx" ON "emails"("contactId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "events_createdAt_idx" ON "events"("createdAt" DESC);

-- CreateIndex
CREATE INDEX "triggers_createdAt_idx" ON "triggers"("createdAt" DESC);

-- CreateIndex
CREATE INDEX "triggers_eventId_createdAt_idx" ON "triggers"("eventId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "triggers_contactId_createdAt_idx" ON "triggers"("contactId", "createdAt" DESC);
