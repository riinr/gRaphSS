{
  # enable .gitignore creation
  files.gitignore.enable = true;
  # copy contents from https://github.com/github/gitignore
  # to our .gitignore
  files.gitignore.template."Global/Archives" = true;
  files.gitignore.template."Global/Backup" = true;
  files.gitignore.template."Global/Diff" = true;
  files.gitignore.pattern."*.yaml" = true;
  files.gitignore.pattern."*.json" = true;
  files.gitignore.pattern."handler" = true;
  files.gitignore.pattern."nimbledeps" = true;
  files.gitignore.pattern."node_modules" = true;
  files.gitignore.pattern."*" = true;
  files.gitignore.pattern."!/**/" = true;
  files.gitignore.pattern."!/*.*/" = true;
}
