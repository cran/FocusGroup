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

