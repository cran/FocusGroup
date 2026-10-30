## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(FocusGroup)

## ----create_fg, eval = FALSE--------------------------------------------------
# config <- LLMR::llm_config(
#   provider = "openai",
#   model = "gpt-4o-mini",
#   temperature = 0.7
# )
# 
# result <- run_focus_group(
#   topic = "Impact of Social Media on Mental Health",
#   n_participants = 5,
#   guide = c(
#     Opening = 1,
#     Icebreaker = 1,
#     Engagement = 2,
#     Exploration = 3,
#     Closing = 1
#   ),
#   flow = "desire_based",
#   config = config,
#   seed = 110,
#   message_mode = "roleflip"
# )
# 
# print(result)
# print(result$focus_group)

## ----view_transcript, eval = FALSE--------------------------------------------
# head(result$transcript)
# result$participants
# result$usage

## ----offline_analysis, eval = FALSE-------------------------------------------
# analysis <- analyze_focus_group(
#   result,
#   num_topics = 4,
#   include_plots = TRUE
# )
# 
# print(analysis)
# analysis$basic_stats
# analysis$tfidf
# analysis$readability
# analysis$issues

## ----individual_analysis, eval = FALSE----------------------------------------
# readability <- result$focus_group$analyze_readability()
# participation <- result$focus_group$analyze_participation_balance()
# questions <- result$focus_group$analyze_question_patterns()
# 
# readability
# participation$participation_stats
# questions$question_patterns

## ----model_analysis, eval = FALSE---------------------------------------------
# model_analysis <- analyze_focus_group(
#   result,
#   num_topics = 4,
#   config = config
# )
# 
# cat(model_analysis$themes)
# cat(model_analysis$model_summary)

## ----import, eval = FALSE-----------------------------------------------------
# transcript <- data.frame(
#   speaker = c("Facilitator", "Ana", "Ben", "Ana"),
#   text = c(
#     "What should change about the library hours?",
#     "Evening hours help working parents.",
#     "Morning crowding has become difficult.",
#     "Both schedules need enough staff."
#   )
# )
# 
# imported <- focus_group_from_transcript(
#   transcript,
#   topic = "Library hours",
#   moderator_id = "Facilitator"
# )
# 
# imported_analysis <- analyze_focus_group(imported, include_plots = FALSE)
# print(imported_analysis)

## ----summarize----------------------------------------------------------------
transcript <- data.frame(
  speaker = c("Facilitator", "Ana", "Ben", "Ana", "Facilitator", "Ben"),
  text = c(
    "What should change about the library hours?",
    "Evening hours help working parents like me.",
    "I see it differently. Mornings are too crowded now.",
    "Crowded mornings still beat being locked out after work.",
    "What would you give up to pay for longer hours?",
    "I would give up the Sunday story hour before anything else."
  )
)
imported <- focus_group_from_transcript(
  transcript,
  topic = "Library hours",
  moderator_id = "Facilitator"
)

scripted <- function(experiments, ...) {
  prompt <- experiments$messages[[1]][[1]]$content
  unit <- sub(".*one participant, (P[0-9]+)\\..*", "\\1", prompt)
  lines <- regmatches(prompt, gregexpr("\\[#[0-9]+\\] P[0-9]+: [^\n]*", prompt))[[1]]
  own <- lines[grepl(paste0("^\\[#[0-9]+\\] ", unit, ": "), lines)][1]
  id <- as.integer(sub("^\\[#([0-9]+)\\].*", "\\1", own))
  words <- strsplit(sub("^[^:]*: ", "", own), " ")[[1]]
  claim <- list(
    id = 1, unit = unit, kind = "position", status = "stated",
    text = paste(unit, "gave a view on the hours."),
    speakers = list(unit), evidence = list(id), context = list(),
    quotes = list(list(message_id = id, speaker = unit,
                       text = paste(words[1:5], collapse = " ")))
  )
  reply <- list(claims = list(claim),
                levels = list(headline = list(1), brief = list(1)))
  experiments$response_text <- as.character(jsonlite::toJSON(reply, auto_unbox = TRUE))
  experiments
}

summary_config <- LLMR::llm_config("openai", "gpt-4o-mini")
by_person <- summarize_focus_group(
  imported, summary_config,
  compression = c("headline", "brief"),
  .runner = scripted
)
by_person

## ----summarize_records--------------------------------------------------------
by_person$metadata$handles
by_person$claims[, c("unit", "status", "text")]
by_person$quotes[, c("unit", "message_id", "speaker_id", "verbatim", "start", "end")]

## ----summarize_reask----------------------------------------------------------
calls <- 0L
misquote_once <- function(experiments, ...) {
  calls <<- calls + 1L
  out <- scripted(experiments, ...)
  if (calls == 2L) {
    out$response_text <- sub("I see it differently.", "I see it quite differently.",
                             out$response_text, fixed = TRUE)
  }
  out
}
reasked <- summarize_focus_group(
  imported, summary_config,
  compression = "headline",
  .runner = misquote_once
)
reasked$calls[, c("call_id", "unit", "attempt")]
cat(reasked$calls$messages[[3]][[3]]$content)

## ----summarize_live, eval = FALSE---------------------------------------------
# by_item <- summarize_focus_group(
#   result, config,
#   by = "item",
#   compression = c("headline", "detailed")
# )
# by_item$summaries

## ----turns--------------------------------------------------------------------
fg_turns(imported)[, c("message_id", "item", "speaker_id", "handle", "words", "link")]

## ----player-------------------------------------------------------------------
session <- readRDS(system.file("extdata", "player-session.rds",
                               package = "FocusGroup"))
page <- fg_player(session, file = tempfile(fileext = ".html"), open = FALSE)
file.exists(page)
table(session$routing$rule)

## ----direct, eval = FALSE-----------------------------------------------------
# agents <- create_agents(
#   n_participants = 3,
#   demographics = data.frame(
#     age = c(25, 35, 45),
#     gender = c("male", "female", "non-binary"),
#     education = c("high school", "bachelor's", "master's"),
#     stringsAsFactors = FALSE
#   ),
#   config = config
# )
# 
# flow <- create_conversation_flow(
#   mode = "desire_based",
#   agents = agents,
#   moderator_id = "MOD"
# )
# 
# fg <- FocusGroup$new(
#   topic = "Impact of Social Media on Mental Health",
#   purpose = "Explore perspectives and experiences related to social media.",
#   agents = agents,
#   moderator_id = "MOD",
#   turn_taking_flow = flow,
#   admin_config = config
# )

