require "base64"

class Gitjira::Setup
  def self.init(force = false)
    if self.setup? and not force
      STDERR.puts "Repository is configured. Overwrite with:"
      STDERR.puts "\t$ git-jira init -f # or git-jira init --force."
      return 1
    end
    host = username = password = projectkey= nil

    host = ask("JIRA host (e.g. https://jira.example.org): ")
    host = "#{host}/" if not host.empty? and not host.end_with?("/")

    username = ask("Your JIRA username                       : ")
    password = ask("Your JIRA password                       : "){ |q| q.echo = "*" }
    base64 = Base64.strict_encode64("#{username}:#{password}")
    username = password = nil

    projectkey = ask("Related JIRA project key (e.g. PROJ)     : ")

    if not host.empty? and not projectkey.empty?
      `git config --local gitjira.host #{host}`
      `git config --local gitjira.credentials #{base64.to_s}`
      `git config --local gitjira.projectkey #{projectkey}`
      return 0
    else
      STDERR.puts "[ERROR] Please fill out all needed fields."
      return 1
    end

  end

  def self.setup?
    `git config --local --get gitjira.host`.empty? ? false : true
  end
end
