Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6260E467F55
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 22:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353981AbhLCVbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 16:31:42 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:43010
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354069AbhLCVbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 16:31:41 -0500
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 37D7C3F1F7
        for <stable@vger.kernel.org>; Fri,  3 Dec 2021 21:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1638566896;
        bh=aELhFy+TuMmllfjvVWTVSx286LtfBt9wC9Wu3gXO6nI=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=msgFoLKvDpedw7784GseJpRj8WlYoM6wksWdi//NYqrIQn4WXYWHXgH48rZHMWB77
         WIhvmNjLKbBsMdTVsFJSCW0RETZqUtgbTxm/UV05w7FysoAtHLmq7KeoaKysV8eD3Y
         DQWNHW3gWApDT80mrVTQuM9fefvLo/TKJJdPezhqaXOrXFSKwmioFfcVyQnuuzyb5M
         hNEke2UuOoMsJ6TRQ1AIfgBl/HC+eyXJ+O0s2nFq6cOaYnuLzoQGwbHKerRmOTZJRZ
         iGeINqWSQfUZyLn0I6U/AglxhqeFC3h1wGW+Jb7OYS9Gi3ww6FSWi0gmAQhge6rQI9
         AWnyIZ6p4NN1g==
Received: by mail-pj1-f69.google.com with SMTP id lt10-20020a17090b354a00b001a649326aedso4728846pjb.5
        for <stable@vger.kernel.org>; Fri, 03 Dec 2021 13:28:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aELhFy+TuMmllfjvVWTVSx286LtfBt9wC9Wu3gXO6nI=;
        b=cNCVYAb3Smj/CT+8d3IR5lMiZ7P4Y3KxyK8vCjHqoIwqyHZBjOk1rg3Sj8NsJMRmqI
         ex009TbPRUn59UptI0uJZArgWWOLBq/3V+AzlG0kys20pcnC0RAbK1xn0zP4RhYx6hf3
         uEH/BxgfSd1Ito4AY63/BRzS2wR2cOze5wlGn6+y/Pi5fey/16UGwJH5bt7cWhwbSu5p
         HRDAQ6jFYuB20VvXEzzD3EJLe9LA3a+VzmiI/xkuJZPjdYmjk9ifhx8FvqOi25MCEwDn
         e+qwPa0UQPC1JVxlG5nefAYodq1ZR8qy9PG9gScJ08zIFNF5DDq9ux7QD+mvxPOghpiY
         unWQ==
X-Gm-Message-State: AOAM5323AV88v/YBDNWeHwBIrnqJ7mpcKBfJcVGL8ygZYHpvK3yWeIPM
        I8KExgc1UjAypnpikAQayRVeA7a1aUdY31BgFuaPLu5vNTCqyTBY7Z50bM/amkxB7rzw9q1ZSJ/
        SpQF794BH6mAJxt5OgnEE44hbrQJ2jbk0VA==
X-Received: by 2002:a17:903:11c4:b0:141:da55:6158 with SMTP id q4-20020a17090311c400b00141da556158mr25889926plh.7.1638566894833;
        Fri, 03 Dec 2021 13:28:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxhWOWkIFlHTyIJF631Si4ZatnfvOhhJ25S1lchj0OJT43954ClTWLLJtDW/e2sHWw7PicEKA==
X-Received: by 2002:a17:903:11c4:b0:141:da55:6158 with SMTP id q4-20020a17090311c400b00141da556158mr25889898plh.7.1638566894616;
        Fri, 03 Dec 2021 13:28:14 -0800 (PST)
Received: from canonical.com (node-1w7jr9yebujeq5th4a1ypmeui.ipv6.telus.net. [2001:56a:78ed:fb00::5aa])
        by smtp.gmail.com with ESMTPSA id fw21sm6043587pjb.25.2021.12.03.13.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 13:28:14 -0800 (PST)
From:   Alex Hung <alex.hung@canonical.com>
To:     alex.hung@canonical.com, hdegoede@redhat.com, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] platform/x86/intel: hid: add quirk to support Surface Go 3
Date:   Fri,  3 Dec 2021 14:28:10 -0700
Message-Id: <20211203212810.2666508-1-alex.hung@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Similar to other systems Surface Go 3 requires a DMI quirk to enable
5 button array for power and volume buttons.

Buglink: https://github.com/linux-surface/linux-surface/issues/595

Cc: stable@vger.kernel.org
Signed-off-by: Alex Hung <alex.hung@canonical.com>
---
 drivers/platform/x86/intel/hid.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 08598942a6d7..13f8cf70b9ae 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -99,6 +99,13 @@ static const struct dmi_system_id button_array_table[] = {
 			DMI_MATCH(DMI_PRODUCT_FAMILY, "ThinkPad X1 Tablet Gen 2"),
 		},
 	},
+	{
+		.ident = "Microsoft Surface Go 3",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 3"),
+		},
+	},
 	{ }
 };
 
-- 
2.34.1

