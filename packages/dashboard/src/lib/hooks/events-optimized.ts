import useSWR from 'swr';
import { Event } from '@prisma/client';
import { useActiveProject } from './projects';
import { useMemo } from 'react';

// Memoized event data with optimized trigger processing
export function useEventsOptimized() {
  const activeProject = useActiveProject();

  const { data: rawEvents } = useSWR<
    (Event & {
      triggers: {
        id: string;
        createdAt: Date;
        contactId: string;
      }[];
    })[]
  >(activeProject ? `/projects/id/${activeProject.id}/events` : null);

  // Memoize processed events to avoid recalculation on every render
  const processedEvents = useMemo(() => {
    if (!rawEvents) return null;

    return rawEvents.map(event => {
      // Pre-calculate unique contact count
      const uniqueContactIds = new Set(event.triggers.map(t => t.contactId));
      const uniqueContactCount = uniqueContactIds.size;

      // Pre-sort triggers once
      const sortedTriggers = [...event.triggers].sort((a, b) => 
        new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
      );

      // Get last activity efficiently
      const lastActivity = sortedTriggers[0]?.createdAt || event.createdAt;

      // Group triggers by month for timeline (limit processing)
      const triggersByMonth = event.triggers.slice(0, 1000).reduce((acc, trigger) => {
        const month = new Date(trigger.createdAt).toISOString().slice(0, 7);
        acc[month] = (acc[month] || 0) + 1;
        return acc;
      }, {} as Record<string, number>);

      return {
        ...event,
        uniqueContactCount,
        lastActivity,
        triggersByMonth,
        totalTriggers: event.triggers.length,
      };
    });
  }, [rawEvents]);

  return {
    data: processedEvents,
    isLoading: !rawEvents && !processedEvents,
    mutate: () => {}, // Add mutate function if needed
  };
}

export function useEventsWithoutTriggers() {
  const activeProject = useActiveProject();

  return useSWR<Event[]>(activeProject ? `/projects/id/${activeProject.id}/events?triggers=false` : null);
}