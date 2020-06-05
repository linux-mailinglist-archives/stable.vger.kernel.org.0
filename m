Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28CC81EFDA7
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgFEQ0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728138AbgFEQ0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:37 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8B7C08C5C3;
        Fri,  5 Jun 2020 09:26:36 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z64so5144257pfb.1;
        Fri, 05 Jun 2020 09:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/M5A1guudu8CJXvZtpOIJo9xlxZZgKSUXm5P8/pYAgw=;
        b=ktvPYPKo3lZjaa3dRu9oHGaxP9fF/hUHb3ButlgFIiamBO6VJkMuN++ASu1azTunoX
         96CLz7jT8Kqe8Sp6J0aZWzodqkgpjHTq0Qh2joGS37Z0BmBlfgpk4PPqlLSzaBIASSJF
         M9xYNx2c2PHJU0nCp9bQ6mEoODz8S1doLSON2Y+oIqvdy8EbP03jr0C1+/3NS0mRAOym
         QIJSQyBWr60tvvnUtO57ihuycjxQR6L5WhS3cUl61MxpY3F0SForJK4LuELvxXUlltYm
         JRH21Kz7Gmy0Ke1EV/aysGW8ii+KFPbz5VetBeyVJSggT3zE6ucx52JAv3a2lB1Pp5nP
         a3Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/M5A1guudu8CJXvZtpOIJo9xlxZZgKSUXm5P8/pYAgw=;
        b=VIbV6BmD8qwoeESR48HZpzxA4K6d3QL0MdoG20PHcZSkaJu0noQW7nZxikw4Vg6UXW
         QyYbGRizVj0Je4TTqymtq4qXxxBpwWUVqdZ6v+2GRaiTI2bojtAiNDCN9QAOaPKlNP4z
         8eIkb1Ie68Wq+8d9YgnaVbWb5G3l7a165jCcouOCezkSCZ1nYArX2oGUuIlPUyagjHg6
         WWn/P+8Y266ndfc+nzbf3MDFM267ZGFCx/COTw/DfRYCtbJ9LwTuKn+9KDGlVg+SOtTR
         oE4wfq4wJzQtH6y1wACz4G2j5S49V/YnyP6kdJ78xuEcHIPc62rTbIrW2T72ObUZyxBF
         tlpA==
X-Gm-Message-State: AOAM5327wlTxTaIRjzs+JtGZTyoS07Ro0Vs9UoCAo0IN3nYv8mTD2aEv
        CpYjQ9C+tzRoKIIYZY2+qjd0WVy0
X-Google-Smtp-Source: ABdhPJxfnzKdAvBSAn2DGkGIAXsIn/7shQxn4bh6bG94ttICeG0q1VJlLp3bAV9SKpv105SrRyf2UQ==
X-Received: by 2002:aa7:95bd:: with SMTP id a29mr10342882pfk.57.1591374395681;
        Fri, 05 Jun 2020 09:26:35 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:26:34 -0700 (PDT)
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
Subject: [PATCH stable 4.9 18/21] media: dvb_frontend: Add compat_ioctl callback
Date:   Fri,  5 Jun 2020 09:25:15 -0700
Message-Id: <20200605162518.28099-19-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaedon Shin <jaedon.shin@gmail.com>

commit c2dfd2276cec63a0c6f6ce18ed83800d96fde542 upstream

Adds compat_ioctl for 32-bit user space applications on a 64-bit system.

[m.chehab@osg.samsung.com: add missing include compat.h]
Signed-off-by: Jaedon Shin <jaedon.shin@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 12 ++++++++++++
 fs/compat_ioctl.c                     | 17 -----------------
 2 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index dacc467e24af..c0a25cd6ccb8 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -41,6 +41,7 @@
 #include <linux/jiffies.h>
 #include <linux/kthread.h>
 #include <linux/ktime.h>
+#include <linux/compat.h>
 #include <asm/processor.h>
 
 #include "dvb_frontend.h"
@@ -1981,6 +1982,14 @@ static long dvb_frontend_ioctl(struct file *file, unsigned int cmd,
 	return dvb_usercopy(file, cmd, arg, dvb_frontend_do_ioctl);
 }
 
+#ifdef CONFIG_COMPAT
+static long dvb_frontend_compat_ioctl(struct file *file, unsigned int cmd,
+				      unsigned long arg)
+{
+	return dvb_frontend_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif
+
 static int dtv_set_frontend(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
@@ -2651,6 +2660,9 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 static const struct file_operations dvb_frontend_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= dvb_frontend_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= dvb_frontend_compat_ioctl,
+#endif
 	.poll		= dvb_frontend_poll,
 	.open		= dvb_frontend_open,
 	.release	= dvb_frontend_release,
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 02ac9067a354..9fa3285425fe 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1340,23 +1340,6 @@ COMPATIBLE_IOCTL(DMX_GET_PES_PIDS)
 COMPATIBLE_IOCTL(DMX_GET_CAPS)
 COMPATIBLE_IOCTL(DMX_SET_SOURCE)
 COMPATIBLE_IOCTL(DMX_GET_STC)
-COMPATIBLE_IOCTL(FE_GET_INFO)
-COMPATIBLE_IOCTL(FE_DISEQC_RESET_OVERLOAD)
-COMPATIBLE_IOCTL(FE_DISEQC_SEND_MASTER_CMD)
-COMPATIBLE_IOCTL(FE_DISEQC_RECV_SLAVE_REPLY)
-COMPATIBLE_IOCTL(FE_DISEQC_SEND_BURST)
-COMPATIBLE_IOCTL(FE_SET_TONE)
-COMPATIBLE_IOCTL(FE_SET_VOLTAGE)
-COMPATIBLE_IOCTL(FE_ENABLE_HIGH_LNB_VOLTAGE)
-COMPATIBLE_IOCTL(FE_READ_STATUS)
-COMPATIBLE_IOCTL(FE_READ_BER)
-COMPATIBLE_IOCTL(FE_READ_SIGNAL_STRENGTH)
-COMPATIBLE_IOCTL(FE_READ_SNR)
-COMPATIBLE_IOCTL(FE_READ_UNCORRECTED_BLOCKS)
-COMPATIBLE_IOCTL(FE_SET_FRONTEND)
-COMPATIBLE_IOCTL(FE_GET_FRONTEND)
-COMPATIBLE_IOCTL(FE_GET_EVENT)
-COMPATIBLE_IOCTL(FE_DISHNETWORK_SEND_LEGACY_CMD)
 COMPATIBLE_IOCTL(VIDEO_STOP)
 COMPATIBLE_IOCTL(VIDEO_PLAY)
 COMPATIBLE_IOCTL(VIDEO_FREEZE)
-- 
2.17.1

