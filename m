Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AD61EFDC1
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgFEQ0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727809AbgFEQ0Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:24 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD5CC08C5C5;
        Fri,  5 Jun 2020 09:26:23 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id d6so2952395pjs.3;
        Fri, 05 Jun 2020 09:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=v5IOrrmsw2Ix66TCmCMcm2Pl0TMPhGeFMZv/aXa4SS0=;
        b=M1JlK4tQHFdZH704MwVEdnAoKoFqWdJssJoX1Ame5iJ48b3/qvi/bmJIOjvW6WRAvg
         gLQhoUOVpNPne3tZod93kIU6Htcx2jatghV91n6J+P21CgSVpzzRFloTeRi/BxFdX+hX
         bXLfA5Nfe+031V2WkcsmHlY6p6qONfocyrBp7x4Fh7PRycz1M1pdL7LyJoMZCUuVlOID
         XZ2D8wWNFY+Lc95iLMrsGJ6sRWgfsowE2TR088ONxAMvhSHo6Su8SMBtBVoxO+IXFBLN
         drAwBTWSzlMKQLuqFhOXZpEi8mLY1Mr7F8IKQa2dcth5rgT4CNY6qP0goi80W95t9joB
         UrbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=v5IOrrmsw2Ix66TCmCMcm2Pl0TMPhGeFMZv/aXa4SS0=;
        b=fZrT+ANU5bczDt9araJ7NJ7Pc5/6B0nl+C0lKUkHyqYBklUo6k+UxY49T4SjiQCnwp
         TKUWDJYsKdD22sYysTx0KYA4LiHYFfvUYcr7LWsR/FmRIqFyx6o4R76eN1RoOJ2nBEIr
         bVETUB/LB+ND0josFOe4A63wtInDkNgE8jXbB3mTmMBCvlgDrX75F6C4ZP16bwBLE6kx
         /kSBmF8tR7dnX/qrIKYwcRyumKE/z/tuSGXutn6afnOnYNVwOnti6nyIKh4d1VEEIs/c
         LnZFQgdihQPq43nWZQ4azwIU9voIlEzX4Y7DsnA10nJeVjVbBjmP+QZQ84IBgNPNcsdA
         St7g==
X-Gm-Message-State: AOAM531ZgBFPhk7n8GJQ/VHrXfXUJHVeAEpLufLMxSmH+XR10K10V54Y
        yTZ8As55RAKd5aMAW9mk4ZokQ1cq
X-Google-Smtp-Source: ABdhPJyAj9y16c4QVaURhoARZXRcdAJJtG87fOtiOrpNgLjPKM36ZQoWAenVdogTmkYv/GWNXhfjcg==
X-Received: by 2002:a17:90a:fe83:: with SMTP id co3mr3871871pjb.204.1591374382469;
        Fri, 05 Jun 2020 09:26:22 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:26:21 -0700 (PDT)
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
Subject: [PATCH stable 4.9 12/21] media: dvb_frontend: get rid of property cache's state
Date:   Fri,  5 Jun 2020 09:25:09 -0700
Message-Id: <20200605162518.28099-13-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit ef2cc27cf860b79874e9fde1419dd67c3372e41c upstream

In the past, I guess the idea was to use state in order to
allow an autofush logic. However, in the current code, it is
used only for debug messages, on a poor man's solution, as
there's already a debug message to indicate when the properties
got flushed.

So, just get rid of it for good.

Reviewed-by: Shuah Khan <shuahkg@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 20 ++++++--------------
 drivers/media/dvb-core/dvb_frontend.h |  5 -----
 2 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 5b06ac91420f..a7ba8e200b67 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -932,8 +932,6 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 	memset(c, 0, offsetof(struct dtv_frontend_properties, strength));
 	c->delivery_system = delsys;
 
-	c->state = DTV_CLEAR;
-
 	dev_dbg(fe->dvb->device, "%s: Clearing cache for delivery system %d\n",
 			__func__, c->delivery_system);
 
@@ -1760,13 +1758,13 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		dvb_frontend_clear_cache(fe);
 		break;
 	case DTV_TUNE:
-		/* interpret the cache of data, build either a traditional frontend
-		 * tunerequest so we can pass validation in the FE_SET_FRONTEND
-		 * ioctl.
+		/*
+		 * Use the cached Digital TV properties to tune the
+		 * frontend
 		 */
-		c->state = tvp->cmd;
-		dev_dbg(fe->dvb->device, "%s: Finalised property cache\n",
-				__func__);
+		dev_dbg(fe->dvb->device,
+			"%s: Setting the frontend from property cache\n",
+			__func__);
 
 		r = dtv_set_frontend(fe);
 		break;
@@ -1915,7 +1913,6 @@ static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int err;
 
@@ -1935,7 +1932,6 @@ static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
 		return -EPERM;
 	}
 
-	c->state = DTV_UNDEFINED;
 	err = dvb_frontend_handle_ioctl(file, cmd, parg);
 
 	up(&fepriv->sem);
@@ -2119,10 +2115,6 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 			}
 			(tvp + i)->result = err;
 		}
-
-		if (c->state == DTV_TUNE)
-			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
-
 		kfree(tvp);
 		break;
 	}
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index f852f0a49f42..8a6267ad56d6 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -615,11 +615,6 @@ struct dtv_frontend_properties {
 	struct dtv_fe_stats	post_bit_count;
 	struct dtv_fe_stats	block_error;
 	struct dtv_fe_stats	block_count;
-
-	/* private: */
-	/* Cache State */
-	u32			state;
-
 };
 
 #define DVB_FE_NO_EXIT  0
-- 
2.17.1

