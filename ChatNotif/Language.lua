function GetStringsFromLanguage(language)
    
    local STRINGS_EN = {
        options_lock_position_label = "Lock window position",
        options_channels_label = "Select channels",
        options_customize_colors_button = "Clic to customize colors",
        options_reset_colors_button = "Reset colors to default",
        options_reset_colors_button_confirm = "Clic again to confirm",
        options_timer_label_1 = "Notification duration: ",
        options_timer_label_2 = "s per character",
        options_account_wide_checkBox = "Save settings account wide (update on logout)",
        options_commands_label = "Type '/cn help' in the chat window to see all commands",
        options_font_size_label = "Select font size",
    }

    local STRINGS_ENGB = {
        options_lock_position_label = "Lock window position",
        options_channels_label = "Select channels",
        options_customize_colors_button = "Clic to customize colours",
        options_reset_colors_button = "Reset colours to default",
        options_reset_colors_button_confirm = "Clic again to confirm",
        options_timer_label_1 = "Notification duration: ",
        options_timer_label_2 = "s per character",
        options_account_wide_checkBox = "Save settings account wide (update on logout)",
        options_commands_label = "Type '/cn help' in the chat window to see all commands",
        options_font_size_label = " Select font size",
    }

    local STRINGS_FR = {
        options_lock_position_label = "Verrouiller la position de la fenêtre",
        options_channels_label = "Sélectioner les canaux",
        options_customize_colors_button = "Cliquez pour personaliser les couleurs",
        options_reset_colors_button = "Réinitialiser les couleurs",
        options_reset_colors_button_confirm = "Cliquez pour confirmer",
        options_timer_label_1 = "Durée de la notification : ",
        options_timer_label_2 = "s par caractère",
        options_account_wide_checkBox = "Sauvegarder les paramètres pour le compte",
        options_commands_label = "Entrez '/cn help' dans le chat pour voir la liste des commandes.",
        options_font_size_label = "Sélectionez la taille du texte",
    }

    local STRINGS_DE = { -- Translated using DeepL
        options_lock_position_label = "Fensterposition sperren",
        options_channels_label = "Kanäle auswählen",
        options_customize_colors_button = "Klicken Sie, um die Farben anzupassen",
        options_reset_colors_button = "Klicken Sie, um die Farben zurückzusetzen",
        options_reset_colors_button_confirm = "Sicher? Klicken Sie erneut, um die Farben zurückzusetzen",
        options_timer_label_1 = "Benachrichtigungsdauer : ",
        options_timer_label_2 = "s pro Zeichen",
        options_account_wide_checkBox = "Einstellungen kontoweit speichern",
        options_commands_label = "Tippe '/cn help' in das Chat-Fenster, um alle Befehle zu sehen",
        options_font_size_label = "Schriftgröße auswählen",
    }

    if language == Turbine.Language.French then
        return STRINGS_FR
    elseif language == Turbine.Language.German then
        return STRINGS_EN -- STRINGS_DE
    elseif language == Turbine.Language.EnglishGB then
        return STRINGS_ENGB
    else
        return STRINGS_EN
    end
end