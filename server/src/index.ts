import { ApolloServer } from '@apollo/server';
import { startStandaloneServer } from '@apollo/server/standalone';
import { GraphQLScalarType, Kind } from 'graphql';

const typeDefs = `#graphql
  scalar Date

  type DueDate { 
    date: Date!
    isYearMonthDayOnly: Boolean!
  }

  type MyList {
    id: ID!
    name: String!
    icon: String!
    reminderConnection(first: Int, after: ID): ReminderConnection
  }

  type ReminderConnection { 
    edges: [ReminderEdge!]!
    pageInfo: PageInfo!
    totalCount: Int!
  }

  type ReminderEdge {
    cursor: ID!
    node: Reminder!
  }

  type Reminder {
    id: ID!
    myListId: ID!
    title: String!
    dueDate: DueDate
    isCompleted: Boolean!
  }

  type PageInfo {
    hasNextPage: Boolean!
    hasPreviousPage: Boolean!
    startCursor: String
    endCursor: String
  }

  input AddReminderInput {
    id: ID!
    myListId: ID!
    title: String!
    dueDate: DueDateInput
    isCompleted: Boolean!
  }

  input UpdateReminderInput {
    id: ID!
    myListId: ID
    title: String
    dueDate: DueDateInput
    isCompleted: Boolean
  }

  input DeleteReminderInput {
    id: ID!
  }

  input DueDateInput {
    date: Date!
    isYearMonthDayOnly: Boolean!
  }

  type Query {
    myLists: [MyList!]!
    myList(id: ID!): MyList
  }

  type Mutation {
    addReminder(input: AddReminderInput!): Reminder
    updateReminder(input: UpdateReminderInput!): Reminder
    deleteReminder(input: DeleteReminderInput!): ID
  }
`;

interface DueDate { date: Date; isYearMonthDayOnly: boolean; }
interface Reminder { id: string; myListId: string; title: string; dueDate?: DueDate; isCompleted: boolean; }
interface MyList { id: string; name: string; icon: string; }

const myLists = [
    {
      id: "1",
      name: "Work",
      icon: "tray.circle.fill",
    },
    {
      id: "2",
      name: "Personal",
      icon: "calendar.circle.fill",
    },
  ];

const reminders: Reminder[] = [
  {
    id: "101",
    myListId: "1",
    title: "Finish project report",
    dueDate: { date: new Date("2025-04-10T09:00:00Z"), isYearMonthDayOnly: false },
    isCompleted: false,
  },
  {
    id: "102",
    myListId: "1",
    title: "Prepare presentation",
    dueDate: { date: new Date("2025-04-12T10:30:00Z"), isYearMonthDayOnly: true },
    isCompleted: false,
  },
  {
    id: "201",
    myListId: "2",
    title: "Buy groceries",
    dueDate: { date: new Date("2025-04-08T17:00:00Z"), isYearMonthDayOnly: true },
    isCompleted: true,
  },
  {
    id: "202",
    myListId: "2",
    title: "Call mom",
    dueDate: { date: new Date("2025-04-09T19:00:00Z"), isYearMonthDayOnly: false },
    isCompleted: false,
  },
];

const dateScalar = new GraphQLScalarType({
    name: 'Date',
    description: 'Date custom scalar type',
    serialize(value) {
      if (value instanceof Date) {
        return value.getTime();
      }
      throw Error('GraphQL Date Scalar serializer expected a `Date` object');
    },
    parseValue(value) {
      if (typeof value === 'number') {
        return new Date(value);
      }
      throw new Error('GraphQL Date Scalar parser expected a `number`');
    },
    parseLiteral(ast) {
      if (ast.kind === Kind.INT) {
        return new Date(parseInt(ast.value, 10));
      }
      return null;
    },
});

const resolvers = {
    Date: dateScalar,
    Query: {
      myLists: () => myLists,
      myList: (_: any, { id }: { id: string }) =>
        myLists.find(list => list.id === id) || null,
    },
  
    MyList: {
      reminderConnection: (
        parent: MyList,
        { first, after }: { first?: number; after?: string }
      ) => {
        const all = reminders.filter(r => r.myListId === parent.id);
        const startIndex = after
          ? all.findIndex(r => r.id === after) + 1
          : 0;
        const limit = typeof first === 'number' ? first : all.length;
        const slice = all.slice(startIndex, startIndex + limit);
        const edges = slice.map(r => ({ cursor: r.id, node: r }));
        const endIndex = startIndex + slice.length;
        return {
          edges,
          totalCount: all.length,
          pageInfo: {
            hasNextPage:    endIndex < all.length,
            hasPreviousPage: startIndex > 0,
            startCursor:    edges[0]?.cursor || null,
            endCursor:      edges[edges.length - 1]?.cursor || null,
          },
        };
      },
    },
  
    Mutation: {
      addReminder: (_: any, { input }: { input: Reminder }) => {
        const newReminder: Reminder = { ...input };
        reminders.push(newReminder);
        return newReminder;
      },
  
      updateReminder: (
        _: any,
        { input }: { input: Partial<Reminder> & { id: string } }
      ) => {
        const idx = reminders.findIndex(r => r.id === input.id);
        if (idx === -1) {
          throw new Error(`Reminder with id ${input.id} not found`);
        }
        reminders[idx] = { ...reminders[idx], ...input } as Reminder;
        return reminders[idx];
      },
  
      deleteReminder: (_: any, { input }: { input: { id: string } }) => {
        const idx = reminders.findIndex(r => r.id === input.id);
        if (idx === -1) {
          throw new Error(`Reminder with id ${input.id} not found`);
        }
        reminders.splice(idx, 1);
        return input.id;
      },
    },
};

const server = new ApolloServer({
    typeDefs,
    resolvers,
});
  
const { url } = await startStandaloneServer(server, {
    listen: { port: 4000 },
});
  
console.log(`🚀  Server ready at: ${url}`);