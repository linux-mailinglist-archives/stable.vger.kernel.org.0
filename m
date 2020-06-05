Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F161EFDDB
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgFEQ0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbgFEQ0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:15 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC13C08C5C4;
        Fri,  5 Jun 2020 09:26:14 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ne5so322202pjb.5;
        Fri, 05 Jun 2020 09:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yl2c3lr1cROZ0PCJowYf2rTBlLEbdPel5A+cfI8kcRw=;
        b=OILMBMu3f4uUqmw7nraOQ+HIRXbapVevszh8tlqmfiI+uK/PqtzYe9i85L+n4VuTyY
         i8cNjmnoatRFwHVAH/OK++jMmG+J4CTJlk6fpW+PMwRz1if1C9OjWBh8G/H0Mps33wIM
         8VMsbNb4SvAUNrQ8hwh8eiea3Wi3Vfz0j/rzI5Okgu3g8JmmP+SumcV67tMecck8YUV4
         mHKkAsime/KB2o+3xxr7goDFmp+qUl0NLIMgfMRdBhvE6PZmCQridRRK5Rfe6ZAb/uEQ
         ZixzouBisij0CqukR4JA5cMW1J3qkiQtSx7HTlDHSUl3AF10Bcok8BuHR0XnKyoAE2/u
         g1xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yl2c3lr1cROZ0PCJowYf2rTBlLEbdPel5A+cfI8kcRw=;
        b=NtYivj93/JAxIRAVmXxa7HbqQoyvr2cd9J3qQGNPHJFXo165A89m8vtP15VsjTyM+G
         w+ijlFJP4X/ZxvdOQa6+01pN75weFd2vCDPxIahbADmj0UIxtNVv82khz9Hssbk3zUHl
         xUVP8iuFtshj1Geiufo6Wfn6BB/kQ7vqSgAxqgrFE6SOQFmB63PEbW4R5Q9bv+mzJI/W
         Y/n67jmv0ubTeLwtHvASkcJGjYXQkGfSmn/Zq51tvfkBXvHjRf9dkaYwLIbhKAxT3EJZ
         CVzoMpmQ7eKHDtLpFuQ8l5OTq6yLQ/hSJZNoqV+ORLeSEPcCbiLgIt9YnlSvvADYejCU
         DLZQ==
X-Gm-Message-State: AOAM532AtDgar4H5GskV+fIye0wu9MO6A9bY1ODUncqjvJe5nuus4tnY
        fslQtj2orVrSUSvZyX0s1mqaoNf6
X-Google-Smtp-Source: ABdhPJzjGSSaf8Gl1ZdNII6917kbMvgnzC/3jYmA+FNfnh4K1xXdh6ldPtySdckZrVMw2T//+N5EwQ==
X-Received: by 2002:a17:90a:17ed:: with SMTP id q100mr3638937pja.80.1591374373641;
        Fri, 05 Jun 2020 09:26:13 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:26:12 -0700 (PDT)
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
Subject: [PATCH stable 4.9 08/21] media: friio-fe: get rid of set_property()
Date:   Fri,  5 Jun 2020 09:25:05 -0700
Message-Id: <20200605162518.28099-9-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit b2c41ca9632e686e79f6c9db9c5f75666d37926e upstream

This callback is not actually doing anything but making it to
return an error depending on the DTV frontend command. Well,
that could break userspace for no good reason, and, if needed,
should be implemented, instead, at set_frontend() callback.

So, get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/media/usb/dvb-usb/friio-fe.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/friio-fe.c b/drivers/media/usb/dvb-usb/friio-fe.c
index 979f05b4b87c..237f12f9a7f2 100644
--- a/drivers/media/usb/dvb-usb/friio-fe.c
+++ b/drivers/media/usb/dvb-usb/friio-fe.c
@@ -261,28 +261,6 @@ static int jdvbt90502_read_signal_strength(struct dvb_frontend *fe,
 	return 0;
 }
 
-
-/* filter out un-supported properties to notify users */
-static int jdvbt90502_set_property(struct dvb_frontend *fe,
-				   struct dtv_property *tvp)
-{
-	int r = 0;
-
-	switch (tvp->cmd) {
-	case DTV_DELIVERY_SYSTEM:
-		if (tvp->u.data != SYS_ISDBT)
-			r = -EINVAL;
-		break;
-	case DTV_CLEAR:
-	case DTV_TUNE:
-	case DTV_FREQUENCY:
-		break;
-	default:
-		r = -EINVAL;
-	}
-	return r;
-}
-
 static int jdvbt90502_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
@@ -457,8 +435,6 @@ static struct dvb_frontend_ops jdvbt90502_ops = {
 	.init = jdvbt90502_init,
 	.write = _jdvbt90502_write,
 
-	.set_property = jdvbt90502_set_property,
-
 	.set_frontend = jdvbt90502_set_frontend,
 
 	.read_status = jdvbt90502_read_status,
-- 
2.17.1

