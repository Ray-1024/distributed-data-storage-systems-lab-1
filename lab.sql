\echo 'Введите название схемы: '
\prompt 'Введите название схемы: ' current_schema_name
\set lab_schema_name '\'' :current_schema_name '\''


\echo 'Введите текст для поиска: '
\prompt 'Введите текст для поиска: ' current_search_text
\set lab_serach_text '\'' :current_search_text '\''


call search_code_in_schema(:lab_schema_name::text, :lab_search_text::text);