Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558C06EE9DE
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 23:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236185AbjDYV7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 17:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbjDYV7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 17:59:39 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F400CA7;
        Tue, 25 Apr 2023 14:59:37 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1a8097c1ccfso67357805ad.1;
        Tue, 25 Apr 2023 14:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682459977; x=1685051977;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=difEtPuCDEVNmMp3S1bKLId011LEY1AQ3x0QKrDmjBQ=;
        b=S3w+hxVSXUjf+CkB5IyKTXkNPx182kQt0bKRPexETKFUkN8pGQjz1YYaCBNrFBYpzr
         cgi4wmshcc49UKLYxPdlTPvHulSkuLEXFIQxZiNrH+GokivUC6o8+5D82mUqwg3gvDrS
         O95mwo//wvuVH5ZzO04oQsPyJKr0GYNAwK63URxj6fmM5x9ZwdRK6D6H1IMfHTz1FBRV
         PIK6bE6VGLjTpoFHFH6ZREy3i66Ja7naVM+8/4w0CQjcR16K9JDilSNHPEmPPpMrRxr7
         DC8ZkZqGmVeldX3G6n2+sR5A/n1ow4wFTp9DFKP4PbJ4amp+JbuywNG0iU/iar1fJOOf
         iZ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682459977; x=1685051977;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=difEtPuCDEVNmMp3S1bKLId011LEY1AQ3x0QKrDmjBQ=;
        b=WsSWYc3m20aH72MlDr4zZl+M3qJrmpGbAYuQiEG1GvLdcoxQOrzUrrtSR2yDc9p/HG
         Qw5sblAEF8RcyEA/BoJDn/QCV9EtwmTe+ZTpd9iWvcMC7QmcLr8YUXJ3THVXBGm5xH4v
         N0mVErQJLHjflNxt3j1EvHOM0OpkBvAzgqrbEshaUNoMEEHZ+TrHVmvmSN6PE/sl9nEI
         T8wdV1X7bk54NwNAz/AMNBNo9FYt54Qv0muyKkGYTKUEpSx2tqSEhRmryg86tB+bTA5M
         MRQudLzAohO8frmAzGVIUNYYmMObuYvPgX7kxbmSRp0QJHiagnOgi38sPH959EsQXdhO
         W8Kw==
X-Gm-Message-State: AAQBX9cJomQn5YbcZW2eDjmQjH8dURVBV4znGh6fQlDNriYMIi3Ytoog
        12eVr0RxGc1WGs75a04DjFsARNb6/Gkw8Q==
X-Google-Smtp-Source: AKy350bwWHi609pFymTUNkUnd3Frl4I/UsuTySFhImTSUYKfyFWlWHvltuFBRCbB+upAb9j6bMrEng==
X-Received: by 2002:a17:903:32cc:b0:1a1:f5dd:2dce with SMTP id i12-20020a17090332cc00b001a1f5dd2dcemr23876138plr.6.1682459976758;
        Tue, 25 Apr 2023 14:59:36 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902b70900b001a96d295f15sm4414634pls.284.2023.04.25.14.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 14:59:36 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, sashal@kernel.org,
        gregkh@linuxfoundation.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Al Cooper <alcooperx@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        linux-phy@lists.infradead.org (open list:GENERIC PHY FRAMEWORK)
Subject: [PATCH stable 6.1] phy: phy-brcm-usb: Utilize platform_get_irq_byname_optional()
Date:   Tue, 25 Apr 2023 14:59:32 -0700
Message-Id: <20230425215932.4063037-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 53bffe0055741440a6c91abb80bad1c62ea443e3 upstream

The wake-up interrupt lines are entirely optional, avoid printing
messages that interrupts were not found by switching to the _optional
variant.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Justin Chen <justinpopo6@gmail.com>
Link: https://lore.kernel.org/r/20221026224450.2958762-1-f.fainelli@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
---
This patch is only needed in Linux 6.1 and is already in Linux 6.2.

 drivers/phy/broadcom/phy-brcm-usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/broadcom/phy-brcm-usb.c b/drivers/phy/broadcom/phy-brcm-usb.c
index 2bfd78e2d8fd..7a4c328bac58 100644
--- a/drivers/phy/broadcom/phy-brcm-usb.c
+++ b/drivers/phy/broadcom/phy-brcm-usb.c
@@ -445,9 +445,9 @@ static int brcm_usb_phy_dvr_init(struct platform_device *pdev,
 		priv->suspend_clk = NULL;
 	}
 
-	priv->wake_irq = platform_get_irq_byname(pdev, "wake");
+	priv->wake_irq = platform_get_irq_byname_optional(pdev, "wake");
 	if (priv->wake_irq < 0)
-		priv->wake_irq = platform_get_irq_byname(pdev, "wakeup");
+		priv->wake_irq = platform_get_irq_byname_optional(pdev, "wakeup");
 	if (priv->wake_irq >= 0) {
 		err = devm_request_irq(dev, priv->wake_irq,
 				       brcm_usb_phy_wake_isr, 0,
-- 
2.34.1

