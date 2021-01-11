CREATE TABLE public.squirrel_list_profile_cloud
(
    user_id bigint,
    uid text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE public.squirrel_list_profile_cloud
    OWNER to stat;

GRANT ALL ON TABLE public.squirrel_list_profile_cloud TO stat;


CREATE OR REPLACE FUNCTION public.load_squirrel_list_profile()
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    
AS $BODY$
begin
truncate table public.squirrel_list_profile_cloud;
insert into public.squirrel_list_profile_cloud(user_id,uid)
SELECT user_id,uid FROM dblink('host=10.10.119.5 user=phonenumbers password=4KxrBxjNi1sk5Ti dbname=stats', 'select au.id,sa.uid from ext.squirrel_auth_user au left join ext.squirrel_social_socialaccount sa on au.id = sa.user_id left join ext.squirrel_list_profile_country slc on au.id = slc.user_id where sa.net_id = 4 and sa.uid ilike''+%'' and slc.user_id is null') AS t1(user_id bigint,uid text);
END
$BODY$;

ALTER FUNCTION public.load_squirrel_list_profile()
    OWNER TO stat;

GRANT EXECUTE ON FUNCTION public.load_squirrel_list_profile() TO stat;

GRANT EXECUTE ON FUNCTION public.load_squirrel_list_profile() TO PUBLIC;


CREATE OR REPLACE FUNCTION public.phonenumbers(tel text)
    RETURNS text
    LANGUAGE 'plpython3u'

    COST 100
    VOLATILE 
    
AS $BODY$
import phonenumbers
from phonenumbers import timezone
from phonenumbers import geocoder

x = phonenumbers.parse(tel, "ru")
site = geocoder.description_for_number(x, "ru")

return site
$BODY$;

ALTER FUNCTION public.phonenumbers(text)
    OWNER TO stat;

GRANT EXECUTE ON FUNCTION public.phonenumbers(text) TO stat;

GRANT EXECUTE ON FUNCTION public.phonenumbers(text) TO PUBLIC;
