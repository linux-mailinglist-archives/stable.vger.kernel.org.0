Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85011EFDFC
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgFEQ0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbgFEQ0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:08 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086A0C08C5C2;
        Fri,  5 Jun 2020 09:26:08 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id m1so5392230pgk.1;
        Fri, 05 Jun 2020 09:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fWpx6f+4wgL8xMRTLX05j8UVK4Mv/r1SKdVKvG+UIsw=;
        b=uo6n7HqfcM6VUZR43CM1H8xUQpdJkgfQfPZVGILieyWTkZLA+DJmBnr6xQOqpAgi4P
         MHtEBdaDPjd5LKi32C/K2zWm96qiLzPd8wnoJ8isRVBib/tC3ueP3UtX5ZjOy9nH8s6L
         H8vD61zb6C+AxPk0ENjz1cNNgrvhCYxkKfcqu/sa/ai7zNouyIVFCVfhE8ZTxXz8kaQ6
         Gq1OlQ5u4C42v0czLu5+56VgfOsgRUfZg0VcgOmuT4oWk9HImP+yKzExQnV9p2m1fiFp
         qZ6V4PVzpHPYMGGIYvRZusComaG1IUenQDO1kHLAd/x83Fy+OvkuNc4sGPKV1rJKpOG7
         72uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fWpx6f+4wgL8xMRTLX05j8UVK4Mv/r1SKdVKvG+UIsw=;
        b=UOesNUHdvRdylRN0M/H4GGDmnLehLxQSl23ELpJXGduPPc3EPKIC9NniU+JcxehIYZ
         mvkPPS/iKe6ZdJhH0ZCpa1JthWWslFr0Vw88nNDJd0Qz2r7iXQ+unXAjQWA4cukS3i2a
         K4+uNe1LXr/tllIGUYYDuk3pb3JQsofVZ57v2VuVm4969hS3YgxxauWUxPzwYWs95mp+
         xvj5yjThQR0jWelZLqQjOjK9T8mmQMylI428j5O5DKmngdkg0ZpOO+dOVDyZYujd1P/X
         mHdCIeUXUOtWvBwFYDHiGIkUWYIpIL7NtPyFm0oBLe3bnYhyiC+M59mcKKArd3ZsGAo3
         ua+g==
X-Gm-Message-State: AOAM531+jjI07cmsSZgtBeS8hARXjXnEIMIAJ0zpdG+izwKGtvT8aR+n
        TVLmB+vhHcQ8kKXS9WxmCQSTRAWB
X-Google-Smtp-Source: ABdhPJzzHgGmsx0Aif2ScHBiwMep4HjZ3Ui2LhF+D+YePIxEYb/HPAN8UGfB02GPqOhvQkQksQH6bQ==
X-Received: by 2002:a62:6846:: with SMTP id d67mr10705706pfc.167.1591374367137;
        Fri, 05 Jun 2020 09:26:07 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:26:06 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
X-Google-Original-From: Florian Fainelli <florian.fainelli@broadcom.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE
        (V4L/DVB)),
        linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and
        infrastructure))
Subject: [PATCH stable 4.9 05/21] media: dvb_frontend: get rid of get_property() callback
Date:   Fri,  5 Jun 2020 09:25:02 -0700
Message-Id: <20200605162518.28099-6-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit 8f8a19fcc1a89b83d0ab6d7cf2bcdd272dbd4334 upstream

Only lg2160 implement gets_property, but there's no need for that,
as no other driver calls this callback, as get_frontend() does the
same, and set_frontend() also calls lg2160 get_frontend().

So, get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c |  9 +--------
 drivers/media/dvb-core/dvb_frontend.h |  3 ---
 drivers/media/dvb-frontends/lg2160.c  | 14 --------------
 3 files changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 7eeb5d302c9c..97c825f97b15 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1306,7 +1306,7 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 				    struct dtv_property *tvp,
 				    struct file *file)
 {
-	int r, ncaps;
+	int ncaps;
 
 	switch(tvp->cmd) {
 	case DTV_ENUM_DELSYS:
@@ -1517,13 +1517,6 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
-	/* Allow the frontend to override outgoing properties */
-	if (fe->ops.get_property) {
-		r = fe->ops.get_property(fe, tvp);
-		if (r < 0)
-			return r;
-	}
-
 	dtv_property_dump(fe, false, tvp);
 
 	return 0;
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index fb6e84811504..57cedbe5c2c7 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -399,8 +399,6 @@ struct dtv_frontend_properties;
  * @analog_ops:		pointer to struct analog_demod_ops
  * @set_property:	callback function to allow the frontend to validade
  *			incoming properties. Should not be used on new drivers.
- * @get_property:	callback function to allow the frontend to override
- *			outcoming properties. Should not be used on new drivers.
  */
 struct dvb_frontend_ops {
 
@@ -463,7 +461,6 @@ struct dvb_frontend_ops {
 	struct analog_demod_ops analog_ops;
 
 	int (*set_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
-	int (*get_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
 };
 
 #ifdef __DVB_CORE__
diff --git a/drivers/media/dvb-frontends/lg2160.c b/drivers/media/dvb-frontends/lg2160.c
index f51a3a0b3949..1b640651531d 100644
--- a/drivers/media/dvb-frontends/lg2160.c
+++ b/drivers/media/dvb-frontends/lg2160.c
@@ -1052,16 +1052,6 @@ static int lg216x_get_frontend(struct dvb_frontend *fe,
 	return ret;
 }
 
-static int lg216x_get_property(struct dvb_frontend *fe,
-			       struct dtv_property *tvp)
-{
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-
-	return (DTV_ATSCMH_FIC_VER == tvp->cmd) ?
-		lg216x_get_frontend(fe, c) : 0;
-}
-
-
 static int lg2160_set_frontend(struct dvb_frontend *fe)
 {
 	struct lg216x_state *state = fe->demodulator_priv;
@@ -1372,8 +1362,6 @@ static struct dvb_frontend_ops lg2160_ops = {
 	.init                 = lg216x_init,
 	.sleep                = lg216x_sleep,
 #endif
-	.get_property         = lg216x_get_property,
-
 	.set_frontend         = lg2160_set_frontend,
 	.get_frontend         = lg216x_get_frontend,
 	.get_tune_settings    = lg216x_get_tune_settings,
@@ -1400,8 +1388,6 @@ static struct dvb_frontend_ops lg2161_ops = {
 	.init                 = lg216x_init,
 	.sleep                = lg216x_sleep,
 #endif
-	.get_property         = lg216x_get_property,
-
 	.set_frontend         = lg2160_set_frontend,
 	.get_frontend         = lg216x_get_frontend,
 	.get_tune_settings    = lg216x_get_tune_settings,
-- 
2.17.1

