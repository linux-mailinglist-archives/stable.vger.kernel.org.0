Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD051EFDB8
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgFEQ1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728151AbgFEQ0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:40 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E1CC08C5C2;
        Fri,  5 Jun 2020 09:26:39 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id n2so3809348pld.13;
        Fri, 05 Jun 2020 09:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iDQgGfOy6ldHVs5uNpQriET3jeGe/mkeG7jR7Di4Pt0=;
        b=VzDo2HDeTObGijOzuxOPMg2bjqmZZHU21My3x8RUKhb8LRKOqa4cYT5z4vQMmOqVgs
         CQWtDQVlQMuzSW8M7UmwIRlvWlaGtNEOrZ5dFqs8zJoOWJlwE8D1t1+ZgvfYgAGL1TZ5
         FzUpfPXioDq7Dp14jk8z/2VXfla6v0gidfuo2Y6PfQb16qqhaRqiQQIH0Zoa5lZSNs1P
         9teXl722s/9Szt31jLk2yyk6AYLcCtr4MZF7gSejeQxacqpgIdMrswNfGx9Mzpis80Be
         IEb+5A+vKCIB6I9i6D6mrEh/2+011oiYHN8gcczWWjUXznf3Hw5ip3bPQkff2rJWjCpP
         3jfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iDQgGfOy6ldHVs5uNpQriET3jeGe/mkeG7jR7Di4Pt0=;
        b=ju/VmNbR+V9LQ4tIqCyT1fWpem22PFnpZU5x1GgxTFCnSZ4OZChsFATJ+ETCYVwPg2
         Lg/b+477I2LNxo8yLNXhm0OvYv67OUhKUvm3fVf3EdlO1Y7l0KHCQVSVmvtPRd+1mkBd
         EYItghHuu+638fAr9mJAO8afGnWP/DJcONEmeE3Ae21NJRPj9M3ucyFuh2I1Q/e3TzHJ
         kKMEmE5EosY9G6vD0hbOurprlJUl/MMiix1fk/+Cd4t3XEjswaFQXFSxt0dBWaoD+rh6
         7IPvfLNwPibqFfq3t0kgtQc9KdpQ/iCL/qRx7mcfzfiztziWNWhimeU+jH9GKV8rR6gm
         bjZA==
X-Gm-Message-State: AOAM533L/a5k6Hk7d3qAUvI6S4YJmblCtzX4iixNyTDxAK5UeNZ8mzAK
        JKIJ0LYM3XafTaoqOQOprnrMmTIG
X-Google-Smtp-Source: ABdhPJx8cO6H0Ki2knLseZ0hHVik4GtM+/9YXQPB1y8TmFAEVVYQUtjegXU7n+eUPZKDKs3c/NTsRw==
X-Received: by 2002:a17:90a:fe83:: with SMTP id co3mr3873149pjb.204.1591374398219;
        Fri, 05 Jun 2020 09:26:38 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:26:37 -0700 (PDT)
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
Subject: [PATCH stable 4.9 19/21] media: dvb_frontend: Add commands implementation for compat ioct
Date:   Fri,  5 Jun 2020 09:25:16 -0700
Message-Id: <20200605162518.28099-20-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaedon Shin <jaedon.shin@gmail.com>

commit 18192a77f0810933ab71a46c1b260d230d7352ee upstream

The dtv_properties structure and the dtv_property structure are
different sizes in 32-bit and 64-bit system. This patch provides
FE_SET_PROPERTY and FE_GET_PROPERTY ioctl commands implementation for
32-bit user space applications.

Signed-off-by: Jaedon Shin <jaedon.shin@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 131 ++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c0a25cd6ccb8..34f55a2ba071 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1983,9 +1983,140 @@ static long dvb_frontend_ioctl(struct file *file, unsigned int cmd,
 }
 
 #ifdef CONFIG_COMPAT
+struct compat_dtv_property {
+	__u32 cmd;
+	__u32 reserved[3];
+	union {
+		__u32 data;
+		struct dtv_fe_stats st;
+		struct {
+			__u8 data[32];
+			__u32 len;
+			__u32 reserved1[3];
+			compat_uptr_t reserved2;
+		} buffer;
+	} u;
+	int result;
+} __attribute__ ((packed));
+
+struct compat_dtv_properties {
+	__u32 num;
+	compat_uptr_t props;
+};
+
+#define COMPAT_FE_SET_PROPERTY	   _IOW('o', 82, struct compat_dtv_properties)
+#define COMPAT_FE_GET_PROPERTY	   _IOR('o', 83, struct compat_dtv_properties)
+
+static int dvb_frontend_handle_compat_ioctl(struct file *file, unsigned int cmd,
+					    unsigned long arg)
+{
+	struct dvb_device *dvbdev = file->private_data;
+	struct dvb_frontend *fe = dvbdev->priv;
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+	int i, err = 0;
+
+	if (cmd == COMPAT_FE_SET_PROPERTY) {
+		struct compat_dtv_properties prop, *tvps = NULL;
+		struct compat_dtv_property *tvp = NULL;
+
+		if (copy_from_user(&prop, compat_ptr(arg), sizeof(prop)))
+			return -EFAULT;
+
+		tvps = &prop;
+
+		/*
+		 * Put an arbitrary limit on the number of messages that can
+		 * be sent at once
+		 */
+		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
+			return -EINVAL;
+
+		tvp = memdup_user(compat_ptr(tvps->props), tvps->num * sizeof(*tvp));
+		if (IS_ERR(tvp))
+			return PTR_ERR(tvp);
+
+		for (i = 0; i < tvps->num; i++) {
+			err = dtv_property_process_set(fe, file,
+							(tvp + i)->cmd,
+							(tvp + i)->u.data);
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
+		}
+		kfree(tvp);
+	} else if (cmd == COMPAT_FE_GET_PROPERTY) {
+		struct compat_dtv_properties prop, *tvps = NULL;
+		struct compat_dtv_property *tvp = NULL;
+		struct dtv_frontend_properties getp = fe->dtv_property_cache;
+
+		if (copy_from_user(&prop, compat_ptr(arg), sizeof(prop)))
+			return -EFAULT;
+
+		tvps = &prop;
+
+		/*
+		 * Put an arbitrary limit on the number of messages that can
+		 * be sent at once
+		 */
+		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
+			return -EINVAL;
+
+		tvp = memdup_user(compat_ptr(tvps->props), tvps->num * sizeof(*tvp));
+		if (IS_ERR(tvp))
+			return PTR_ERR(tvp);
+
+		/*
+		 * Let's use our own copy of property cache, in order to
+		 * avoid mangling with DTV zigzag logic, as drivers might
+		 * return crap, if they don't check if the data is available
+		 * before updating the properties cache.
+		 */
+		if (fepriv->state != FESTATE_IDLE) {
+			err = dtv_get_frontend(fe, &getp, NULL);
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
+		}
+		for (i = 0; i < tvps->num; i++) {
+			err = dtv_property_process_get(
+			    fe, &getp, (struct dtv_property *)tvp + i, file);
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
+		}
+
+		if (copy_to_user((void __user *)compat_ptr(tvps->props), tvp,
+				 tvps->num * sizeof(struct compat_dtv_property))) {
+			kfree(tvp);
+			return -EFAULT;
+		}
+		kfree(tvp);
+	}
+
+	return err;
+}
+
 static long dvb_frontend_compat_ioctl(struct file *file, unsigned int cmd,
 				      unsigned long arg)
 {
+	struct dvb_device *dvbdev = file->private_data;
+	struct dvb_frontend *fe = dvbdev->priv;
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+	int err;
+
+	if (cmd == COMPAT_FE_SET_PROPERTY || cmd == COMPAT_FE_GET_PROPERTY) {
+		if (down_interruptible(&fepriv->sem))
+			return -ERESTARTSYS;
+
+		err = dvb_frontend_handle_compat_ioctl(file, cmd, arg);
+
+		up(&fepriv->sem);
+		return err;
+	}
+
 	return dvb_frontend_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
 }
 #endif
-- 
2.17.1

