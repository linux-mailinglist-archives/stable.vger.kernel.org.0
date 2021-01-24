Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDE5301B42
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 11:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbhAXKhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 05:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbhAXKhP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 05:37:15 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03856C061573
        for <stable@vger.kernel.org>; Sun, 24 Jan 2021 02:36:35 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id p18so6953133pgm.11
        for <stable@vger.kernel.org>; Sun, 24 Jan 2021 02:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=54lY55eOZMtPOR0bO3d6rSHFV+eQzb2kUH738zWhXbI=;
        b=UclAsupzxDS+d+IIWvXJb0hd1OdzVYNl6aeGnElIZWqSPKBWdyWp9WCxnAHbVU+WYs
         56nUz4Y1F97JW0XWR8V27b7e7DhtKe3cUH+yfn+RniCPCg4STn4ovJeV38rAEoMD6E9K
         L0vwB7jvR2RmeyOJVs0hIknX6eIpjK214rW+q1LfyXrgfJiAurK76yXeDVb1165Nrgb1
         3+9AJW5+H/jaKY7I5lrYdKL0873yyBgEDXOIdRVqApmm486M/CZ1jcZ4watidydJ40HF
         mtBKb3akH3bqAT5+jHTFPzStoP0FQUuEDdvuWgC1qUTNjE5c587MBwSDW8oYruZjNfVd
         RDSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=54lY55eOZMtPOR0bO3d6rSHFV+eQzb2kUH738zWhXbI=;
        b=hO1nf6zE3IuLjoE8liKx54deVldLGeWpdBqBZqhVk6OBVoKiGxu2Gy+gxIMvt3Vjl2
         0zXZ9zMYH8SRXJfW/h34qmC8fTrtbpvu/VXLXvT1QXSXRGks9Fb4IJleQ9JqDp6sU12g
         fnw1hudwaBfjUlMBzIgiZCco537BYVGf+kZ4rbv5u1VAska6smNum/8LTn2KjxNW5uwk
         u5PWXn7baX/8eF4c3o18P7oi3qsBuvUtvygDHpIGHRVcc6zgvibUdDIaJOhlmypqYljF
         4/bf0iLKHkeVgcggSj5W1Y8ejeDmMAe0U5Lozmxbkg9pv7Yfzypoc8vSuDXP00ocE/5p
         tCEg==
X-Gm-Message-State: AOAM530p7oaNCCGaCSxVORD07fhATHKW9VGq3WtN3rzUapBDwKcM6H3F
        V8D97LpozgMoOxzsDfwgHYs=
X-Google-Smtp-Source: ABdhPJxXjeDUTPemsjKNZtD18K6RYRGvOptrvFNeS3aTvUPfNFg4E5mgqQEbP77MGhhHCrPmwbjI2w==
X-Received: by 2002:a05:6a00:80e:b029:1b6:39dd:8b2a with SMTP id m14-20020a056a00080eb02901b639dd8b2amr13139151pfk.23.1611484594536;
        Sun, 24 Jan 2021 02:36:34 -0800 (PST)
Received: from localhost (42-3-19-066.static.netvigator.com. [42.3.19.66])
        by smtp.gmail.com with ESMTPSA id s21sm12938048pga.12.2021.01.24.02.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jan 2021 02:36:34 -0800 (PST)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     paul@crapouillou.net, vkoul@kernel.org, kishon@ti.com,
        zhouyanjie@wanyeetech.com, aric.pzqi@ingenic.com
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH v3] PHY: Ingenic: Compile phy-ingenic-usb only if it was enabled
Date:   Sun, 24 Jan 2021 18:36:27 +0800
Message-Id: <20210124103627.51801-1-hqjagain@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We should compile this driver only if we enable PHY_INGENIC_USB.

Fixes: 31de313dfdcf ("PHY: Ingenic: Add USB PHY driver using generic PHY
framework.")
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
v3:
There is no need to submit this patch to -stable tree, as the driver was
not merged to 5.10.
v2:
Add a Fixes:tag and Cc linux-stable
---
 drivers/phy/ingenic/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/ingenic/Makefile b/drivers/phy/ingenic/Makefile
index 65d5ea00fc9d..a00306651423 100644
--- a/drivers/phy/ingenic/Makefile
+++ b/drivers/phy/ingenic/Makefile
@@ -1,2 +1,2 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-y		+= phy-ingenic-usb.o
+obj-$(PHY_INGENIC_USB)		+= phy-ingenic-usb.o
-- 
2.25.1

