/* update.jsp */
CREATE OR REPLACE PROCEDURE show_prof_info(
id IN VARCHAR2,
pwd OUT VARCHAR2,
name OUT VARCHAR2,
major OUT VARCHAR2
)
IS

BEGIN

select p_pwd, p_name, p_major
into pwd, name, major
from professor
where p_id = id;

END;
/