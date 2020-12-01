Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31252CF355
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 18:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388389AbgLDRpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 12:45:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:40554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388388AbgLDRpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Dec 2020 12:45:30 -0500
X-Google-Smtp-Source: ABdhPJzLo/um57d5SBKoDjkJ8Aq6RFZxjg3AtdiXvFU4dXJhpV3kPdIIEqkS+p4ivDYD6SCFbiEe
X-Received: by 2002:a63:ed0b:: with SMTP id d11mr20176710pgi.261.1606781411628;
        Mon, 30 Nov 2020 16:10:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1606781411; cv=none;
        d=google.com; s=arc-20160816;
        b=zrj3Mc+e3RVIaQyvu13A0A995cuNWeEXPL3P6IElgyfsieX+y4IHb5GMLlV7sn7RXC
         ZTEFoUxU3yC5SehLlGS0jY1Qvv/X+rP9GBUsYDs7icotT3mF6LYGHZOWLhKjFcJa4QZ0
         GmD8Xvh1krsNtjcjUWDJcoOZDWYy5r3UyzQ+DaupOEYp5gMIW4lSjBs0enJBQudiBDL/
         EIoMcUb8FmbO45IzLJUnAXjuZLQ66ClecY9GtACfnpDaGAMhknv/1zMIOjOCzxuoBb6u
         yR/5OZdioa9gF5n+my/G97E7PpX3nHP1c1LioLDTR/2Z6PkSLn9yfQlfqMRpzIMp9pU4
         1WhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from;
        bh=6MLTGHalydcTQTGUwzRwTZrDmmmY8YI8mHLG05wiU7Q=;
        b=aCXkylq87ycXwTlTWAQQAjpSrbmF6mPCfxvsfTwZ86FX3Qf55ATtVczL18C7ZxY0qm
         b2lnd6iySVKRTjHSe+7DQyQfb9Dz3h3ljpKyj5j4FfyPDI6Sb4Rho0f6LvveSK1r83Zh
         V/bGWOAhX9Dc0qcqhy826XIcF+kwFLSkJt4AIf/H71DmtBOTk/k5NOKhXzOoNm1kW5+I
         P+2SbW3zflH1uncmam2ICRNJ/TTuPdYAGI2gKcgb2BRe20v7hSty25bgKb6SQ1Bp4fek
         KdS8aYf5wvhdyc6FHNc3WOwcDSQttjlF1OeqlbgD1AgAxuBhHRXTJ4JBAmnBxRlMc5fN
         PBQQ==
ARC-Authentication-Results: i=1; mx.google.com;
       spf=pass (google.com: best guess record for domain of postmaster@muse.csie.ntu.edu.tw designates 140.112.30.240 as permitted sender) smtp.helo=muse.csie.ntu.edu.tw;
       dmarc=fail (p=NONE sp=QUARANTINE dis=NONE) header.from=gmail.com
Received-SPF: pass (google.com: best guess record for domain of postmaster@muse.csie.ntu.edu.tw designates 140.112.30.240 as permitted sender) client-ip=140.112.30.240;
Authentication-Results: mx.google.com;
       spf=pass (google.com: best guess record for domain of postmaster@muse.csie.ntu.edu.tw designates 140.112.30.240 as permitted sender) smtp.helo=muse.csie.ntu.edu.tw;
       dmarc=fail (p=NONE sp=QUARANTINE dis=NONE) header.from=gmail.com
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6MLTGHalydcTQTGUwzRwTZrDmmmY8YI8mHLG05wiU7Q=;
        b=h1mXEqoy8Er9fq32d6NbvDBJxffq56bhQizLP5efI5A1TYA5laEwXXmfLVlmxcFSxB
         +dTpdn9NuvwrGGV7KJxc80WGBOgZxkuxzTkgnn8Jd2uXxjoNgx5/WIKD3wMuBO/Mj5em
         +EygY6KeC9307Ozm96iUskgjS5VSaE++0ywYqPr1rXcr2Qgx6eARNImPTKRw/oxkVob0
         X2/4jL10PllYNL2zTL3aSX80jY5IK3fayLx9m5fB/QDpx+BXPv7C65zG/TtlL/7koixe
         lkuHAXyzINOBg4yproSljXmjF8J4meHIg+KGp8YLWEm4tJjdRJ3ahmNnG9J5ocwMOF/2
         s9Nw==
X-Gm-Message-State: AOAM531zbR3S5toDQmbLg8OLRdg7NBoCZz/m6njqBMnQ4J1xIX3K9TWi
        SJ4BpfZ0nyUGBkbz8YzVq4UcZx9JeOcagw==
X-Received: by 2002:a17:90a:7c44:: with SMTP id e4mr368179pjl.138.1606781409114;
        Mon, 30 Nov 2020 16:10:09 -0800 (PST)
From:   dinghua.ma@wens.csie.org, dinghua.ma.sz@gmail.com
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org,
        "DingHua Ma" <dinghua.ma.sz@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v3] regulator: axp20x: Fix DLDO2 voltage control register mask for AXP22x
Date:   Tue,  1 Dec 2020 08:10:00 +0800
Message-Id: <20201201001000.22302-1-dinghua.ma.sz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "DingHua Ma" <dinghua.ma.sz@gmail.com>

When I use the axp20x chip to power my SDIO device on the 5.4 kernel, 
the output voltage of DLDO2 is wrong. After comparing the register 
manual and source code of the chip, I found that the mask bit of the 
driver register of the port was wrong. I fixed this error by modifying 
the mask register of the source code. This error seems to be a copy 
error of the macro when writing the code. Now the voltage output of 
the DLDO2 port of axp20x is correct. My development environment is 
Allwinner A40I of arm architecture, and the kernel version is 5.4.

Signed-off-by: DingHua Ma <dinghua.ma.sz@gmail.com>
Reviewed-by: Chen-Yu Tsai <wens@csie.org> 
Cc: <stable@vger.kernel.org>
Fixes: db4a555f7c4c ("regulator: axp20x: use defines for masks")
---
Changes since v2:
- Modify topic description
---
Changes since v1:
- More accurate description for this patch
---
 drivers/regulator/axp20x-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/axp20x-regulator.c
index cd1224182ad7..90cb8445f721 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -594,7 +594,7 @@ static const struct regulator_desc axp22x_regulators[] = {
 		 AXP22X_DLDO1_V_OUT, AXP22X_DLDO1_V_OUT_MASK,
 		 AXP22X_PWR_OUT_CTRL2, AXP22X_PWR_OUT_DLDO1_MASK),
 	AXP_DESC(AXP22X, DLDO2, "dldo2", "dldoin", 700, 3300, 100,
-		 AXP22X_DLDO2_V_OUT, AXP22X_PWR_OUT_DLDO2_MASK,
+		 AXP22X_DLDO2_V_OUT, AXP22X_DLDO2_V_OUT_MASK,
 		 AXP22X_PWR_OUT_CTRL2, AXP22X_PWR_OUT_DLDO2_MASK),
 	AXP_DESC(AXP22X, DLDO3, "dldo3", "dldoin", 700, 3300, 100,
 		 AXP22X_DLDO3_V_OUT, AXP22X_DLDO3_V_OUT_MASK,
-- 
2.25.1

