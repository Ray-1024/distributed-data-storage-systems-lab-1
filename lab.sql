\echo 'Введите название схемы: '
\prompt current_schema_name
\set lab_schema_name '\'' :current_schema_name '\''


\echo 'Введите текст для поиска: '
\prompt current_search_text
\set lab_search_text '\'' :current_search_text '\''


call search_code_in_schema(:lab_search_text::text, :lab_schema_name::text);