SELECT
  `user`.Id user_id,
  `user`.RealName user_name,
  content.`Name` game_name,
  content_score_detail.CreateTime game_time,
  content_score_detail.ApproximateScore raw_score
FROM
  content_score_detail
  INNER JOIN iquizoo_content_db.content
    ON content.Id = content_score_detail.ContentId
  INNER JOIN iquizoo_user_db.user_organization
    ON user_organization.Id = content_score_detail.UserId
  INNER JOIN iquizoo_user_db.`user`
    ON `user`.Id = user_organization.UserId
WHERE
  content_score_detail.OrganizationId = '13bfce3d-4bd0-45ac-ba68-e6021318ecdf';
