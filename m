Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8A31EFD83
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgFEQZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgFEQZ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:25:59 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06634C08C5C2;
        Fri,  5 Jun 2020 09:25:59 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id s88so2949204pjb.5;
        Fri, 05 Jun 2020 09:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xiTMuwQ2X7Lvg1AXoObZHg8t385K8uvAl/6Z6GSCNRE=;
        b=PDO192MXtCEDH4yvw6uZfm77X6P4U22M7lARMan18YXz3iENPg4XxWelg81QrEsJpn
         kHAc5uecbkfIa/ZC5+sblLfe20Rfi5qKPaQWV9DvtjnAjFUgUA7lYWbj2QbLDeaiQk1I
         M2VCJgzSuHqbOb6ZJ3usaDMS04+Qi5vCcDWTtW1U/ksln2oZBSMMLnduaI5kOvnFf9z/
         Dx/tcXUsEEPppj/9dwA5mhCnWukXJJv4NeYxxz5F3DpBHpayldKcn8202m0uhnKepd1h
         t2fWOo6Rbnjextv6pqkAslqz+AKHf9BFn5P2ac4EAq3x+feY/qQoc9leEjYyFeYi+SO1
         2X6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xiTMuwQ2X7Lvg1AXoObZHg8t385K8uvAl/6Z6GSCNRE=;
        b=uWgUYJzAMRnd9tRWz+Zilk731umoPhHwzk8Y5IXLtfGmeMPvyz069xdCCQYkxCoHoN
         3TXWBCLqdh4C7aLtTnWrN1nee7C977Azi4Py8r459arP7ORnhGF3MrTndRBmOYKXuIVb
         o+m2EddMmPJ410CoTsBrWvYJNxCLDKrQoywJzfLON9BsV//EdTHWea1rvcPczUNmDHRG
         1Pv1LO1J/5UlWQMxI1MxW+Q+6iLwiisTpy3Vf8zTcwTsceu6FJeb6Br3WFMz4xeIlSbS
         3H/GJHh6F8OBY/8qo5N48R/BKKITShz1J/z+s7GduxuR0Lo9TuW9VNFmeanuQG/8tLAV
         y8XQ==
X-Gm-Message-State: AOAM533cwmhDuolHO1UMFkkZ6n0syAVdC4L93qr7Q1Y0USO+zD2rqD8Q
        S7c4Eb5UpVcoCKpo8DMArM+LHE6P
X-Google-Smtp-Source: ABdhPJzHxb4CKJjj1XbqGo+0bkVBi1f+HfoixTcES5XCnrpj/TQdExSyuo2+qImM8vYbsgYhRgeGVA==
X-Received: by 2002:a17:90a:898a:: with SMTP id v10mr2269707pjn.95.1591374358118;
        Fri, 05 Jun 2020 09:25:58 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:25:57 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
X-Google-Original-From: Florian Fainelli <florian.fainelli@broadcom.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE
        (V4L/DVB)),
        linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and
        infrastructure))
Subject: [PATCH stable 4.9 01/21] media: dvb_frontend: ensure that inital front end status initialized
Date:   Fri,  5 Jun 2020 09:24:58 -0700
Message-Id: <20200605162518.28099-2-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit a9e4998073d49a762a154a6b48a332ec6cb8e6b1 upstream

The fe_status variable s is not initialized meaning it can have any
random garbage status.  This could be problematic if fe->ops.tune is
false as s is not updated by the call to fe->ops.tune() and a
subsequent check on the change status will using a garbage value.
Fix this by adding FE_NONE to the enum fe_status and initializing
s to this.

Detected by CoverityScan, CID#112887 ("Uninitialized scalar variable")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 2 +-
 include/uapi/linux/dvb/frontend.h     | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 2f054db8807b..372057cabea4 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -629,7 +629,7 @@ static int dvb_frontend_thread(void *data)
 	struct dvb_frontend *fe = data;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	enum fe_status s;
+	enum fe_status s = FE_NONE;
 	enum dvbfe_algo algo;
 	bool re_tune = false;
 	bool semheld = false;
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 00a20cd21ee2..afc3972b0879 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -127,6 +127,7 @@ enum fe_sec_mini_cmd {
  *			to reset DiSEqC, tone and parameters
  */
 enum fe_status {
+	FE_NONE			= 0x00,
 	FE_HAS_SIGNAL		= 0x01,
 	FE_HAS_CARRIER		= 0x02,
 	FE_HAS_VITERBI		= 0x04,
-- 
2.17.1

