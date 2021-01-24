Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4D230193A
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 03:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbhAXCrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 21:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbhAXCrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 21:47:08 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96959C0613D6;
        Sat, 23 Jan 2021 18:46:28 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id q131so6324060pfq.10;
        Sat, 23 Jan 2021 18:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qs2mQcU2COK335MLG5RGIc7dYMuUjvOD828GI3A2dtg=;
        b=IZwZ5EWRvdvJR+GaMSUdD8Xt+tfqumzbrthV1A+eO8EGcRQkgHwFe+O5/dJB7u8vDB
         oqLh2YFGpB8e+LZJP+Jp9bIKN/W4nEnBAZXOINVVY6pztXGaErJ0e2AvWmA0oQNSMIrB
         0ZLtrkH/9tvN59k4NcVnWdmzZgSjKTs2UGnbVVwgbSGFP/jauTBy+rYHpOen+ZKoNxvM
         r/khnxECKQvGxCKQBQUGlzbyXIBVJ7NfGireL/G9rxuC0VKT1Vb0/FdsnYNVg+nTDx1R
         eQ7qeHiVsqXlI8SAQxXVTnKAVKM77Y79hRT0Hqvca+o7pyWMwRcGutrgo6h+DFq53cJ3
         +g2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qs2mQcU2COK335MLG5RGIc7dYMuUjvOD828GI3A2dtg=;
        b=eL7AplptJW8F8nwkqscYHQLKEqjyj2MtZU4oAF3Do9QGqWumJwRqOznAqxUw3+1rV/
         h5vv2Uan6g1A919zL4X1spPLL0ZhtY3zkYMcUeSyztOM90QJ5Rckd6nvb3Kqxxp6t3TH
         g9neGGcOC/ZgN+mZuqFt0Bg1EjXImxaifu6ZRONps4ZsgiTK6sNJM1Y1vWAwBzCNzrkU
         ehHKX9bMSs3H6P8jHwz/sVMEMTYf7ty5uX+jUqp13/LXYPnw4ao53iLWoGw58UOBvJQE
         sTh7ZOdGRTUNjALAxjMs9EpcczHHorUmA38TaGxRnectNui7lqxObtgtw1Lys68Z/862
         jo5A==
X-Gm-Message-State: AOAM530vIZAR3kAVVv5Eehjp66bjImVHBTI4YYaKcypHzn82mieJcA1+
        PVyNXkZs6RslWCRguSFAdWId3+wBrCIxcqE/
X-Google-Smtp-Source: ABdhPJy9FlB8UlsgUfh2jQTQ7Nw+hL2QUpn+eHHxgP3CzttG6WkTZS7XcAUlEcr1UM/UYD6pDcH6GQ==
X-Received: by 2002:a63:db05:: with SMTP id e5mr3151742pgg.104.1611456387859;
        Sat, 23 Jan 2021 18:46:27 -0800 (PST)
Received: from glados.. ([2601:647:6000:3e5b::a27])
        by smtp.gmail.com with ESMTPSA id k64sm12650333pfd.75.2021.01.23.18.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 18:46:27 -0800 (PST)
From:   Thomas Hebb <tommyhebb@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Thomas Hebb <tommyhebb@gmail.com>, stable@vger.kernel.org,
        Bob Hepple <bob.hepple@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <jdelvare@suse.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        linux-hwmon@vger.kernel.org
Subject: [PATCH] hwmon: (dell-smm) Add XPS 15 L502X to fan control blacklist
Date:   Sat, 23 Jan 2021 18:46:08 -0800
Message-Id: <a09eea7616881d40d2db2fb5fa2770dc6166bdae.1611456351.git.tommyhebb@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It has been reported[0] that the Dell XPS 15 L502X exhibits similar
freezing behavior to the other systems[1] on this blacklist. The issue
was exposed by a prior change of mine to automatically load
dell_smm_hwmon on a wider set of XPS models. To fix the regression, add
this model to the blacklist.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=211081
[1] https://bugzilla.kernel.org/show_bug.cgi?id=195751

Fixes: b8a13e5e8f37 ("hwmon: (dell-smm) Use one DMI match for all XPS models")
Cc: stable@vger.kernel.org
Reported-by: Bob Hepple <bob.hepple@gmail.com>
Tested-by: Bob Hepple <bob.hepple@gmail.com>
Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
---

 drivers/hwmon/dell-smm-hwmon.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index ec448f5f2dc3..73b9db9e3aab 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1159,6 +1159,13 @@ static struct dmi_system_id i8k_blacklist_fan_support_dmi_table[] __initdata = {
 			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS13 9333"),
 		},
 	},
+	{
+		.ident = "Dell XPS 15 L502X",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Dell System XPS L502X"),
+		},
+	},
 	{ }
 };
 
-- 
2.30.0

