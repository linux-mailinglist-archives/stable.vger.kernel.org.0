Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5371EFDE4
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgFEQ27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbgFEQ0T (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:19 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEB8C08C5C4;
        Fri,  5 Jun 2020 09:26:19 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id g12so3820798pll.10;
        Fri, 05 Jun 2020 09:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P9QFzVDXmyF/4FAK3YhuPZVq3F8vZzWLPk9FHl2uNlY=;
        b=B7CLR+n7xCrM/7jGBaWosCExnekVU0GmOisXCHtPqSoYy+yNncf0PeQsqqCsYn7pmy
         qwelSsGwTrair18RdjQNiKk5vIiWOvq+gGaa+6jROE+qlFyLNlA6KZ84NbWNtxxD9OOK
         zlXfrtCnl+4/U/sYBRVQ4+kEMFgG9qnuBqy1xHAd7h3UZgXh45fEp246L7ukIDsc+pR4
         Hn3zfRXtHXUP9XJ15TXVxaIQWzhe9WAT814y0Cun9vZUVvDNENUjy114GCvatc3NN9bb
         z4uFq0Nu8fK+1uowop7CvZ66FwpW5Eb+UHzDZkA3xejPn1WZSambm9eXut2rAhlDKu90
         yEXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P9QFzVDXmyF/4FAK3YhuPZVq3F8vZzWLPk9FHl2uNlY=;
        b=f2eCGtPQrJwAtpG0pG5P/7PMrQxXPCAGQ4Y5IVbRuG01j3hdp7urrLMesPca8r2S+J
         +I3jqNAmGQwoyiTV2DCxwRqAB+ILk7K27pFWJUS/CG83YhAhdF2OE7041ItNbbBWq1Y0
         Og5gOH/ow1hpTiqmQY1dP6FENp/6SCoPdXl29Lkv5qfgWiqhZTsTeoUz1/XHXGWkkEtv
         9uF6oxMWy5JXcA1jK8pO0j8awEuJs8rGMg0NPn+5tG4nXP+KZhgkrEL+A4QEiF5GZS1o
         7apcnrkDs6qEUxSkninFLLj+CaTYltmtksZVUFuH5YWK6WqSqDxSvqFA3DDGBsJDfob6
         uOqA==
X-Gm-Message-State: AOAM533ERb4rrANqQ6lkd492CCRKTAtdHZjTZkOPCWTOROAzQr7JvvAw
        uk4sqUYsvmZmIxnB5+EfPV+zZKwI
X-Google-Smtp-Source: ABdhPJzLsTKKOuLCzSt+NPiC0yKqidFmbux2ObQg9JpxfsHKAa649lwl+xLQS+4u1vaRYtZhPh1hUQ==
X-Received: by 2002:a17:902:b716:: with SMTP id d22mr9269877pls.33.1591374378165;
        Fri, 05 Jun 2020 09:26:18 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:26:17 -0700 (PDT)
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
Subject: [PATCH stable 4.9 10/21] media: dvb_frontend: cleanup dvb_frontend_ioctl_properties()
Date:   Fri,  5 Jun 2020 09:25:07 -0700
Message-Id: <20200605162518.28099-11-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit 2b5df42b8dec69fb926a242007fd462343db4408 upstream

Use a switch() on this function, just like on other ioctl
handlers and handle parameters inside each part of the
switch.

That makes it easier to integrate with the already existing
ioctl handler function.

Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 83 ++++++++++++++++-----------
 1 file changed, 51 insertions(+), 32 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 2bf55a786e29..c446f51be21a 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1956,21 +1956,25 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int err = 0;
-
-	struct dtv_properties *tvps = parg;
-	struct dtv_property *tvp = NULL;
-	int i;
+	int err, i;
 
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
-	if (cmd == FE_SET_PROPERTY) {
-		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n", __func__, tvps->num);
-		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n", __func__, tvps->props);
+	switch(cmd) {
+	case FE_SET_PROPERTY: {
+		struct dtv_properties *tvps = parg;
+		struct dtv_property *tvp = NULL;
+
+		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
+			__func__, tvps->num);
+		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
+			__func__, tvps->props);
 
-		/* Put an arbitrary limit on the number of messages that can
-		 * be sent at once */
-		if ((tvps->num == 0) || (tvps->num > DTV_IOCTL_MAX_MSGS))
+		/*
+		 * Put an arbitrary limit on the number of messages that can
+		 * be sent at once
+		 */
+		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
 		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
@@ -1979,23 +1983,34 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 
 		for (i = 0; i < tvps->num; i++) {
 			err = dtv_property_process_set(fe, tvp + i, file);
-			if (err < 0)
-				goto out;
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
 			(tvp + i)->result = err;
 		}
 
 		if (c->state == DTV_TUNE)
 			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
 
-	} else if (cmd == FE_GET_PROPERTY) {
+		kfree(tvp);
+		break;
+	}
+	case FE_GET_PROPERTY: {
+		struct dtv_properties *tvps = parg;
+		struct dtv_property *tvp = NULL;
 		struct dtv_frontend_properties getp = fe->dtv_property_cache;
 
-		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n", __func__, tvps->num);
-		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n", __func__, tvps->props);
+		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
+			__func__, tvps->num);
+		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
+			__func__, tvps->props);
 
-		/* Put an arbitrary limit on the number of messages that can
-		 * be sent at once */
-		if ((tvps->num == 0) || (tvps->num > DTV_IOCTL_MAX_MSGS))
+		/*
+		 * Put an arbitrary limit on the number of messages that can
+		 * be sent at once
+		 */
+		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
 		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
@@ -2010,28 +2025,32 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 		 */
 		if (fepriv->state != FESTATE_IDLE) {
 			err = dtv_get_frontend(fe, &getp, NULL);
-			if (err < 0)
-				goto out;
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
 		}
 		for (i = 0; i < tvps->num; i++) {
 			err = dtv_property_process_get(fe, &getp, tvp + i, file);
-			if (err < 0)
-				goto out;
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
 			(tvp + i)->result = err;
 		}
 
 		if (copy_to_user((void __user *)tvps->props, tvp,
 				 tvps->num * sizeof(struct dtv_property))) {
-			err = -EFAULT;
-			goto out;
+			kfree(tvp);
+			return -EFAULT;
 		}
-
-	} else
-		err = -EOPNOTSUPP;
-
-out:
-	kfree(tvp);
-	return err;
+		kfree(tvp);
+		break;
+	}
+	default:
+		return -ENOTSUPP;
+	} /* switch */
+	return 0;
 }
 
 static int dtv_set_frontend(struct dvb_frontend *fe)
-- 
2.17.1

