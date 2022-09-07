Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDEFA5B0FF9
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 00:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiIGWoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 18:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiIGWoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 18:44:19 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC85D71726;
        Wed,  7 Sep 2022 15:44:18 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id lz22so12867255ejb.3;
        Wed, 07 Sep 2022 15:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=xJNlqeNd/xrr04Dfw5ABivBa4Akc5EG+Lwtk/YFuHVc=;
        b=lYb1dK+7UqpkUWaY+4E2VuAdHXPTP7pVSZx8UVTuB34kgV8YQqPI/sUojy9bPydShz
         ITmZwacH05i14Cec5Dmpe3qdSP4sbZ8yUPQAq/Lpk7biy1rV0kfwyvoaVwCheGe+P/7F
         kcBWwn774jQX9l8q7XzDMq/MstWQiY4a0NZMo0QCjQ1ZLADJcMOSj1OHCmtkNZvGbnMi
         DDe+P3x2Jfj9yqB3L0Q5Fw936CmXeH2/4i/0ojrSUeng25GhDen8lZ8nkZmVtMR06Tg5
         1TtGhI/RefHuKq5MTBciDuWNBZfNT0qE8EWlRdbasdq/NKd/LoKqXeovcjsfgzJrnFEN
         2s8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=xJNlqeNd/xrr04Dfw5ABivBa4Akc5EG+Lwtk/YFuHVc=;
        b=05w+aVdjz93VFBH6H5eQxau66/lgcTUa57Xfax1O09wucOq/uVd896vzpy72sxDSbB
         1BgDzMDfUvMgNRmDvDBklvwBSSc4hRjIWWGknYu7G00s/V6hHmG/bPtLfds5xDrJQac7
         fBDzyziPj2bqdaQtK/2vH20i5/udxBgojRmpQ7GWMKPrbQvDVIW/Owk5dMaX13Ne6pNd
         +4c5LXT3B2dQk16hQXZJQRoajqIHeiNVXXEdNby2bL0YblV7/XlGCk0aYZP8yZeQCLcg
         E/fcj453xR4juQeJlwz1G0Jv2gFIFxqvmjU1EtS1b1YpyfqPAFTa5PBpIMScic/pVCVz
         gP1w==
X-Gm-Message-State: ACgBeo2lERGVIrzJjTh9SBzTeenLYCtZZgAR2tQ6a6//gp333wtCiJ9W
        eMyQyaMz6thjOnFHrmZFgD8=
X-Google-Smtp-Source: AA6agR4toEulMdoZCpOhHeaqawYckf6oKqbG0HnoiZHRq63ET2WrQq/jt6MxOwlevNSagZbT4yjD+w==
X-Received: by 2002:a17:907:a06b:b0:771:aa05:e108 with SMTP id ia11-20020a170907a06b00b00771aa05e108mr1743919ejc.167.1662590657195;
        Wed, 07 Sep 2022 15:44:17 -0700 (PDT)
Received: from xws.localdomain ([37.120.217.162])
        by smtp.gmail.com with ESMTPSA id x3-20020a170906148300b0073d83f80b05sm384829ejc.94.2022.09.07.15.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 15:44:16 -0700 (PDT)
From:   Maximilian Luz <luzmaximilian@gmail.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Bingbu Cao <bingbu.cao@intel.com>,
        Tianshu Qiu <tian.shu.qiu@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] ipu3-imgu: Fix NULL pointer dereference in imgu_subdev_set_selection()
Date:   Thu,  8 Sep 2022 00:44:09 +0200
Message-Id: <20220907224409.3187482-1-luzmaximilian@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Calling v4l2_subdev_get_try_crop() and v4l2_subdev_get_try_compose()
with a subdev state of NULL leads to a NULL pointer dereference. This
can currently happen in imgu_subdev_set_selection() when the state
passed in is NULL, as this method first gets pointers to both the "try"
and "active" states and only then decides which to use.

The same issue has been addressed for imgu_subdev_get_selection() with
commit 30d03a0de650 ("ipu3-imgu: Fix NULL pointer dereference in active
selection access"). However the issue still persists in
imgu_subdev_set_selection().

Therefore, apply a similar fix as done in the aforementioned commit to
imgu_subdev_set_selection(). To keep things a bit cleaner, introduce
helper functions for "crop" and "compose" access and use them in both
imgu_subdev_set_selection() and imgu_subdev_get_selection().

Fixes: 0d346d2a6f54 ("media: v4l2-subdev: add subdev-wide state struct")
Cc: stable@vger.kernel.org # for v5.14 and later
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
---
 drivers/staging/media/ipu3/ipu3-v4l2.c | 57 +++++++++++++++-----------
 1 file changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
index ce13e746c15f..e530767e80a5 100644
--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -188,6 +188,28 @@ static int imgu_subdev_set_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static struct v4l2_rect *
+imgu_subdev_get_crop(struct imgu_v4l2_subdev *sd,
+		     struct v4l2_subdev_state *sd_state, unsigned int pad,
+		     enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_crop(&sd->subdev, sd_state, pad);
+	else
+		return &sd->rect.eff;
+}
+
+static struct v4l2_rect *
+imgu_subdev_get_compose(struct imgu_v4l2_subdev *sd,
+			struct v4l2_subdev_state *sd_state, unsigned int pad,
+			enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_compose(&sd->subdev, sd_state, pad);
+	else
+		return &sd->rect.bds;
+}
+
 static int imgu_subdev_get_selection(struct v4l2_subdev *sd,
 				     struct v4l2_subdev_state *sd_state,
 				     struct v4l2_subdev_selection *sel)
@@ -200,18 +222,12 @@ static int imgu_subdev_get_selection(struct v4l2_subdev *sd,
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP:
-		if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
-			sel->r = *v4l2_subdev_get_try_crop(sd, sd_state,
-							   sel->pad);
-		else
-			sel->r = imgu_sd->rect.eff;
+		sel->r = *imgu_subdev_get_crop(imgu_sd, sd_state, sel->pad,
+					       sel->which);
 		return 0;
 	case V4L2_SEL_TGT_COMPOSE:
-		if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
-			sel->r = *v4l2_subdev_get_try_compose(sd, sd_state,
-							      sel->pad);
-		else
-			sel->r = imgu_sd->rect.bds;
+		sel->r = *imgu_subdev_get_compose(imgu_sd, sd_state, sel->pad,
+						  sel->which);
 		return 0;
 	default:
 		return -EINVAL;
@@ -223,10 +239,9 @@ static int imgu_subdev_set_selection(struct v4l2_subdev *sd,
 				     struct v4l2_subdev_selection *sel)
 {
 	struct imgu_device *imgu = v4l2_get_subdevdata(sd);
-	struct imgu_v4l2_subdev *imgu_sd = container_of(sd,
-							struct imgu_v4l2_subdev,
-							subdev);
-	struct v4l2_rect *rect, *try_sel;
+	struct imgu_v4l2_subdev *imgu_sd =
+		container_of(sd, struct imgu_v4l2_subdev, subdev);
+	struct v4l2_rect *rect;
 
 	dev_dbg(&imgu->pci_dev->dev,
 		 "set subdev %u sel which %u target 0x%4x rect [%ux%u]",
@@ -238,22 +253,18 @@ static int imgu_subdev_set_selection(struct v4l2_subdev *sd,
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP:
-		try_sel = v4l2_subdev_get_try_crop(sd, sd_state, sel->pad);
-		rect = &imgu_sd->rect.eff;
+		rect = imgu_subdev_get_crop(imgu_sd, sd_state, sel->pad,
+					    sel->which);
 		break;
 	case V4L2_SEL_TGT_COMPOSE:
-		try_sel = v4l2_subdev_get_try_compose(sd, sd_state, sel->pad);
-		rect = &imgu_sd->rect.bds;
+		rect = imgu_subdev_get_compose(imgu_sd, sd_state, sel->pad,
+					       sel->which);
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
-		*try_sel = sel->r;
-	else
-		*rect = sel->r;
-
+	*rect = sel->r;
 	return 0;
 }
 
-- 
2.37.3

