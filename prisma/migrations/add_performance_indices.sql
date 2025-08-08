-- Add performance indices for slow queries

-- Index for sorting triggers by createdAt (used in feed and events)
CREATE INDEX IF NOT EXISTS idx_triggers_created_at ON triggers("createdAt" DESC);

-- Index for sorting emails by status and createdAt
CREATE INDEX IF NOT EXISTS idx_emails_status ON emails("status");

-- Composite index for project-based queries with sorting
CREATE INDEX IF NOT EXISTS idx_triggers_project_created ON triggers("contactId", "createdAt" DESC) 
WHERE "contactId" IN (SELECT id FROM contacts WHERE "projectId" IS NOT NULL);

-- Index for event triggers relationship
CREATE INDEX IF NOT EXISTS idx_triggers_event_created ON triggers("eventId", "createdAt" DESC) 
WHERE "eventId" IS NOT NULL;

-- Index for faster contact lookups with project
CREATE INDEX IF NOT EXISTS idx_contacts_project_created ON contacts("projectId", "createdAt" DESC);

-- Index for emails project-based queries
CREATE INDEX IF NOT EXISTS idx_emails_project_created ON emails("contactId", "createdAt" DESC)
WHERE "contactId" IN (SELECT id FROM contacts WHERE "projectId" IS NOT NULL);

-- Analyze tables to update statistics
ANALYZE triggers;
ANALYZE emails;
ANALYZE contacts;
ANALYZE events;