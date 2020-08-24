SELECT
  user_profile.Id user_id,
  user_profile.RealName user_name,
  content.`Name` game_name,
  content_orginal_data.CreateTime game_time,
  content_orginal_data_detail.OrginalData game_data
FROM
  content_orginal_data
  INNER JOIN content_orginal_data_detail
    ON content_orginal_data_detail.OrginalDataId = content_orginal_data.Id
  INNER JOIN iquizoo_content_db.content
    ON content.Id = content_orginal_data.ContentId
  INNER JOIN iquizoo_user_db.user_profile
    ON user_profile.Id = content_orginal_data.UserId
WHERE
  content_orginal_data.OrganizationId = '13bfce3d-4bd0-45ac-ba68-e6021318ecdf';
