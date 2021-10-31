Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070B9440D5F
	for <lists+stable@lfdr.de>; Sun, 31 Oct 2021 07:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhJaGnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Oct 2021 02:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhJaGnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Oct 2021 02:43:21 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93ACBC061570;
        Sat, 30 Oct 2021 23:40:50 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id b12so18869155wrh.4;
        Sat, 30 Oct 2021 23:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pmUXDi6WpQyaunmNh7NYUa9oCQq6gI2y8tK1XhMCEPA=;
        b=mygmfVOahWIv8UB+3pY9fZ6UNROyDETnlfRo41EhKDsRMz8D6tmPkoHutj+EVya2F2
         ZOKIsuHE4yjNcqPWIzDRqfVTDu3z8KaZkPPZZ/BNivViNqU7ToeVYDFajrVUgWSxb05H
         TnDAP8Eg4qMTyzP4erQ953AhVcQMvfY/Jdkf3Ub2huUyWJOl1WmOorJIjtl9e4ligp4x
         JFD96j1v7mcf0e3NIh97Vhfr67GZbDP+WIu2J5qvLqGV1jjFpgOS7vvOTpfBKcie6zz4
         oI983ms48y+GpCrawM26D7TVxTOQE76YSm/UdrGYZb74qz78Bj6Mj9JZ9WUR0Ks+PHs3
         +t1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pmUXDi6WpQyaunmNh7NYUa9oCQq6gI2y8tK1XhMCEPA=;
        b=Q7QnD1Gv8nMPS27aVK89hqXvMPuD51Qp3hgyj6qwjfcDijXWTDtzQQDeGBLAv5R0p2
         rZLCTHbgCZCfscfDeYUIwDHZg3l1lfjmJfoxMFZ2z0uhow60LT85zbGp2ApfAzte9mtx
         sudAI3YudOJbZiB43qpd/LJ2FLPy6XdZEmL8xG27ceOzJblD+xUdV+mudNwYOkSWOjnl
         PdyxE3BA/RDwkfRFJI9lJf9JCKP3zi1j219wqPsRdmGk0xPfTrzplCo5P26uzQmREHQ0
         iNQ8FZL2rbXwJiDQUfgqpNZxFDTHZfOaq3mXDjXKexIu6twNynHL81+VUI7vN/bA+aPj
         ZhMA==
X-Gm-Message-State: AOAM531C12O09K16DxVIwRJWxpN4nvnHKNOtoSGtjWAEbiBU5i0d1pQ8
        Db0STDhSQ8k/c7FcFt7e5MY3O84IZdVD4A==
X-Google-Smtp-Source: ABdhPJzqqHce4o0GFf3OewTJFvjnjxuMVieBNGCVBFj4ZNRUScPYN1R5L/si7JzfkX5EjH2qXLfBLA==
X-Received: by 2002:a5d:6c61:: with SMTP id r1mr28937167wrz.54.1635662448709;
        Sat, 30 Oct 2021 23:40:48 -0700 (PDT)
Received: from localhost.localdomain (252.red-83-54-181.dynamicip.rima-tde.net. [83.54.181.252])
        by smtp.gmail.com with ESMTPSA id q26sm7855071wrc.39.2021.10.30.23.40.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 30 Oct 2021 23:40:48 -0700 (PDT)
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
To:     linux-gpio@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linus.walleij@linaro.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH v2] pinctrl: ralink: include 'ralink_regs.h' in 'pinctrl-mt7620.c'
Date:   Sun, 31 Oct 2021 07:40:46 +0100
Message-Id: <20211031064046.13533-1-sergio.paracuellos@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

mt7620.h, included by pinctrl-mt7620.c, mentions MT762X_SOC_MT7628AN
declared in ralink_regs.h.

Fixes: 745ec436de72 ("pinctrl: ralink: move MT7620 SoC pinmux config into a new 'pinctrl-mt7620.c' file")
Cc: stable@vger.kernel.org
Cc: linus.walleij@linaro.org

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
---
Changes in v2:
 - Original patch from Luiz.
 - I have added Fixes tag and CC Linus Walleij and stable and sent v2.

 drivers/pinctrl/ralink/pinctrl-mt7620.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/ralink/pinctrl-mt7620.c b/drivers/pinctrl/ralink/pinctrl-mt7620.c
index 425d55a2ee19..6853b5b8b0fe 100644
--- a/drivers/pinctrl/ralink/pinctrl-mt7620.c
+++ b/drivers/pinctrl/ralink/pinctrl-mt7620.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <asm/mach-ralink/ralink_regs.h>
 #include <asm/mach-ralink/mt7620.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-- 
2.33.0

