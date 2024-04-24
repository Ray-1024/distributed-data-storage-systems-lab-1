create or replace procedure search_code_in_schema(
    search_text text,
    schema_name text
)
    language plpgsql
as
$$
declare
    row_record  record;
    object_text text;
begin
    raise notice 'No.    Имя объекта    # строки    Текст';
    raise notice '-------------------------------------------------------------------------------';


    create temp table search_results
    (
        row_num     serial primary key,
        object_name text,
        line_number int,
        line_text   text
    );


    for row_record in
        select proname as object_name, prosrc as object_text
        from pg_proc
        where pronamespace = (select oid from pg_namespace where nspname = schema_name)
        union all
        select tgname as object_name, pg_get_triggerdef(t.oid) as object_text
        from pg_trigger t
                 join pg_class c ON t.tgrelid = c.oid
                 join pg_namespace n ON c.relnamespace = n.oid
        where n.nspname = schema_name
        loop
            for object_text in
                select line_number::text || '&' || line_text::text
                from regexp_split_to_table(row_record.object_text, E'\n') with ordinality as t(line_text, line_number)
                where lower(t.line_text) LIKE '%' || lower(search_text) || '%'
                loop
                    insert into search_results (object_name, line_number, line_text)
                    values (row_record.object_name,
                            split_part(object_text, '&', 1)::int,
                            split_part(object_text, '&', 2));
                end loop;
        end loop;


    for row_record in
        select * from search_results order by row_num
        loop
            raise notice '%    %    %    %', row_record.row_num, row_record.object_name, row_record.line_number, row_record.line_text;
        end loop;


    drop table search_results;
end;
$$;

call search_code_in_schema('select', 's334433');