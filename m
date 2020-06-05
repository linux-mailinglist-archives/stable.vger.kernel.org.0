Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D76D1EFDA9
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgFEQ0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728072AbgFEQ0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:34 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C06C08C5C5;
        Fri,  5 Jun 2020 09:26:34 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r10so5335895pgv.8;
        Fri, 05 Jun 2020 09:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fueseL5wyjqHmp/EINkLjCle5ZJWz4SZll2cBBMMoIo=;
        b=nUIJaYZYkrn+NijNw3IyxCjOJU7xMm84eMHKy5wvWH2Pr2v5seb962AJ3NwN9SWUSk
         3pbjkA7z7X5fda0JvTeq08VTwcdnLkJ9WOn67TT2dGvh4ZYiV1OhKuTOzAy5tm8yZqno
         hDabC4RfeKq3Wsj+qWUrFfl7k0pXzSJTK0ry+bECrK/nqHoOF4nM8vGlLbbIkfZrwYkO
         EIGLIamOTOIVerTnozi2L5k9f7308f2j2sJbHJ0kMnF4ZhnTAtJgFvL78dk3rWpvGWHD
         eWUuu0qWvDCYS08dZ/Up3OygMkLZITyIDr06L4NWlJrgurA/oYFtq8qMZXvktBnyK1oh
         fbbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fueseL5wyjqHmp/EINkLjCle5ZJWz4SZll2cBBMMoIo=;
        b=KfDR5TW7I3g1M8PGV4ii75RS6jCq9rxZBA8Eq9djwoWGRnC0rqumNCaqBtRBNoTMii
         9ncy98gE9jmP4BaN2p/1aV6SZO1YvVRoVmyRdzEscFzCqiwNulis+nEqNsdEm3NFmbJL
         wtdGt93ATMkuVfiLoRNWWhJI0pFpQA2CVkiKQJdcCIwMjdOMaQ7aU4Xaf2fm5gUrKETx
         OavjVsr22u9jf3yZJfIpOKzCOYZNLedudqetlL3SjqUpxdReA7SgvA4svhfoTPrrHXLJ
         hN/JicyPBlyKkjRenjjch19nd4pEQboBbmWWJTFIl7jpN4wVWdwfopAUu3/ZGpjJiquD
         EQLg==
X-Gm-Message-State: AOAM531swIbXvToPjIRCJlYYQaIGool41TeFD2Z3ZR4RfQb7w8gWMiPO
        7Ofs0wKboYMEDPBGvn4lj4Rhf+NS
X-Google-Smtp-Source: ABdhPJzDKmT6IpB88utVE+CnCj6Mz/rXrSRYIZWebzvHb8KFaCquBtHj9sUHxWPIoy8dlgHvpiU+iQ==
X-Received: by 2002:a62:5346:: with SMTP id h67mr9899045pfb.284.1591374393527;
        Fri, 05 Jun 2020 09:26:33 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:26:32 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
X-Google-Original-From: Florian Fainelli <florian.fainelli@broadcom.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Jaedon Shin <jaedon.shin@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <shuah@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE
        (V4L/DVB)),
        linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and
        infrastructure))
Subject: [PATCH stable 4.9 17/21] media: dvb_frontend: Add unlocked_ioctl in dvb_frontend.c
Date:   Fri,  5 Jun 2020 09:25:14 -0700
Message-Id: <20200605162518.28099-18-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaedon Shin <jaedon.shin@gmail.com>

commit a2282fd1fe2ebcda480426dbfaaa7c4e87e27399 upstream

Adds unlocked ioctl function directly in dvb_frontend.c instead of using
dvb_generic_ioctl().

Signed-off-by: Jaedon Shin <jaedon.shin@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 6f9ee78a1870..dacc467e24af 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1926,7 +1926,8 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	return r;
 }
 
-static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
+static int dvb_frontend_do_ioctl(struct file *file, unsigned int cmd,
+				 void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
@@ -1969,6 +1970,17 @@ static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
 	return err;
 }
 
+static long dvb_frontend_ioctl(struct file *file, unsigned int cmd,
+			       unsigned long arg)
+{
+	struct dvb_device *dvbdev = file->private_data;
+
+	if (!dvbdev)
+		return -ENODEV;
+
+	return dvb_usercopy(file, cmd, arg, dvb_frontend_do_ioctl);
+}
+
 static int dtv_set_frontend(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
@@ -2638,7 +2650,7 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 
 static const struct file_operations dvb_frontend_fops = {
 	.owner		= THIS_MODULE,
-	.unlocked_ioctl	= dvb_generic_ioctl,
+	.unlocked_ioctl	= dvb_frontend_ioctl,
 	.poll		= dvb_frontend_poll,
 	.open		= dvb_frontend_open,
 	.release	= dvb_frontend_release,
@@ -2706,7 +2718,6 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
 		.name = fe->ops.info.name,
 #endif
-		.kernel_ioctl = dvb_frontend_ioctl
 	};
 
 	dev_dbg(dvb->device, "%s:\n", __func__);
-- 
2.17.1

