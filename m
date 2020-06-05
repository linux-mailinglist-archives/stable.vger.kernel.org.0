Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059171EFDD8
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgFEQ0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbgFEQ0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:16 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFA6C08C5C2;
        Fri,  5 Jun 2020 09:26:16 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id jz3so2793353pjb.0;
        Fri, 05 Jun 2020 09:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4mgoDUsj8qd3U36+CA2uGlc/0AibJkfSi1z/E24vv4c=;
        b=Hg2u48S6166BZZDCriE16P7Z9nJJbj1RrQk8zDGkmVWGFXMY2v/NVjXhj3yjLkP1jN
         9wlcXFoGZdbvr0JJ95Ycn0nnWNFm6I34/nr+lmKWkfR9ICWz18Gah3O+IMab7sFkK06u
         yT/Clx4EOetR96GOvoSx85SXbV8xgPbV0JMVP3yq/+RGm4Lw5Kz3OI5T7uAFMU2twl+R
         D7nWzh89qXW6m1ExsXlzlHC4f1oDYEU/OFJ24cY49ddvqfjr5crSX4a1qR9OTlXJzbSv
         dwKLBtzcq/J9hMiN6t3moE9CAr1aLI6jxfdOIU4s9uqXFCKWLlyDP1PwQVGCirzQeTTi
         DdoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4mgoDUsj8qd3U36+CA2uGlc/0AibJkfSi1z/E24vv4c=;
        b=rwVztJ4gRRGxoZjI0GLZI4oSMQpAFs/DRgw8BYtZt4ibADLCrb0YHI49ddTuZiPvPA
         HJkyWXjRsFU0aryDAyh6vcysfnXpRrr5DS7gwhuJH8jOGwHZGNazNQhzC6X2ygSvKMUe
         VmOcCRQtz9Iu0xvhV1qi35Es3EmFwBAHGkpDek99wiXzKkq8ac35wb07xsA5YyB0JXas
         U9JwP4klGojkS4G7hFen3eMgpufGlSEirguqKn18W/lJg07FGysorM0gNo3sXo/Jkvsb
         S5QEycuESZpNBAHsHeXzG9fZT/0XA1zOGpG1m8HYt2MhSRLb7ljofl9tQyLzeAvmCGyP
         +xKA==
X-Gm-Message-State: AOAM532Zddh5NS5n9JbsGXspLK6UelgeD0U4t0U3mWg2LDdyCQuqCSsi
        4vFkzqtuPhw9rukCaTHDtLL/csov
X-Google-Smtp-Source: ABdhPJz4+nYoo5tYqI4UZ0dOGNJ5ZN+SiXUhFLRItWvmIkIJhs3id6BOoBtto+pgeKLOTpSrf+CiYw==
X-Received: by 2002:a17:90a:6344:: with SMTP id v4mr3642685pjs.27.1591374376017;
        Fri, 05 Jun 2020 09:26:16 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:26:15 -0700 (PDT)
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
Subject: [PATCH stable 4.9 09/21] media: dvb_frontend: get rid of set_property() callback
Date:   Fri,  5 Jun 2020 09:25:06 -0700
Message-Id: <20200605162518.28099-10-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit 6680e73b5226114992acfc11f9cf5730f706fb01 upstream

Now that all clients of set_property() were removed, get rid
of this callback.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 7 -------
 drivers/media/dvb-core/dvb_frontend.h | 5 -----
 2 files changed, 12 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 97c825f97b15..2bf55a786e29 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1751,13 +1751,6 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	int r = 0;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	/* Allow the frontend to validate incoming properties */
-	if (fe->ops.set_property) {
-		r = fe->ops.set_property(fe, tvp);
-		if (r < 0)
-			return r;
-	}
-
 	dtv_property_dump(fe, true, tvp);
 
 	switch(tvp->cmd) {
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 57cedbe5c2c7..f852f0a49f42 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -397,11 +397,8 @@ struct dtv_frontend_properties;
  * @search:		callback function used on some custom algo search algos.
  * @tuner_ops:		pointer to struct dvb_tuner_ops
  * @analog_ops:		pointer to struct analog_demod_ops
- * @set_property:	callback function to allow the frontend to validade
- *			incoming properties. Should not be used on new drivers.
  */
 struct dvb_frontend_ops {
-
 	struct dvb_frontend_info info;
 
 	u8 delsys[MAX_DELSYS];
@@ -459,8 +456,6 @@ struct dvb_frontend_ops {
 
 	struct dvb_tuner_ops tuner_ops;
 	struct analog_demod_ops analog_ops;
-
-	int (*set_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
 };
 
 #ifdef __DVB_CORE__
-- 
2.17.1

