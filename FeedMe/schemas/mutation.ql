input CategoryCreation {
  eventId: ID!
  uid: ID!
  parent: ID!
  title: String!
}

input SourceCreation {
  eventId: ID!
  uid: ID!
  parent: ID!
  title: String!
  url: String!
}

input SourceMove {
  eventId: ID!
  parent: ID!
}

input NewsRead {
  eventId: ID!
  uid: ID!
  parent: ID
}

type CategoryCreated {
  eventId: ID!
  category: Category
}

type SourceCreated {
  eventId: ID!
  source: Source
}

type SourceMoved {
  eventId: ID!
  source: Source
}

type NewsReaded {
  eventId: ID!
  news: News!
}

type Error {
  code: ID!
  messages: [String]!
}

union CategoryCreationResult = CategoryCreated | Error
union SourceCreationResult = SourceCreated | Error
union SourceMovedResult = SourceMoved | Error
union NewsReadedResult = NewsReaded | Error

type Mutation {
  createCategory(input: CategoryCreation): CategoryCreationResult
  createSource(input: SourceCreation): SourceCreationResult
  moveSource(input: SourceMove): SourceMovedResult
  readNews(input: NewsRead!): NewsReadedResult
}

