input CategoryFilter {
  eventId: ID!
  afterId: ID
  sortId: ID
}

input SourceFilter {
  eventId: ID!
  parentId: ID!
  afterId: ID
  sortId: ID
}

input NewsFilter {
  eventId: ID!
  parentId: ID!
  unread: Boolean!
  afterId: ID
  sortId: ID
}

type Category {
  uid: ID!
  parent: ID!
  title: String!
  imported_at: Int!
}

type CategoryResult {
  eventId: ID!
  items: [Category]
}

type Source {
  uid: ID!
  parent: ID!
  title: String!
  url: String!
}

type SourceResult {
  eventId: ID!
  items: [Source]
}

type News {
  uid: ID!
  parent: ID!
  url: String!
  title: String!
  author: String
  summary: String
  content: String
  published: Int!
  updated: Int
  readed: Int
}

type NewsResult {
  eventId: ID!
  items: [News]
}

type Query {
  categories(filter: CategoryFilter!): CategoryResult
  sources(filter: SourceFilter!): SourceResult
  categoryItems(filter: NewsFilter!): NewsResult
  sourceItems(filter: NewsFilter!): NewsResult
  item(filter: NewsFilter!): NewsResult
}









