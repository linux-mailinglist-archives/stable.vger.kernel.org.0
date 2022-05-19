Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A4752DD06
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 20:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244061AbiESSpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 14:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243300AbiESSpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 14:45:50 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200E2109E;
        Thu, 19 May 2022 11:45:47 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 137so5831613pgb.5;
        Thu, 19 May 2022 11:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5SU+w9hgi+POXdxltfAITobv8QuuLB+odkG94GhTEgs=;
        b=HCPGXLIowEc4TfgLek+X1SwnRfZRLrsaNkVMgzWo3/y686rkolUMxTgvCnVXNzWJqz
         pXCIpNKvu51NII8Py9T5e+JZPGhlHoZ2QM5xGzFgsML2ELFnPvQrhrMPHzpN5OKYkzhH
         jFnQmoIgbCo9hwUpTXeyU+PLfVR6VPKujV3sD9V25PVW5Lr1AlSdGJwhDgFGpdjUFJfR
         O/UEKSPjNkyjnK3mwuDHBlWQgYT+Aw/s2eu56nS3JoibZvQobz7VCOHQaxfNd0o5CWua
         2xzEx9Kym2ErT7tZcWyZdnHkNz6lFf07t8YTshfoRYJD8SY+6bOkJvMamPhiBwo52Szn
         Am4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5SU+w9hgi+POXdxltfAITobv8QuuLB+odkG94GhTEgs=;
        b=QZ3TiqXac96hGkPkX7mAL/Sg/tEmA13rUvgO4w5BHtOgv6tlBZ140uvdGRn3UXhl8p
         nI2RUm4Q+txagLQvuIb9mBrwF8GQvGobBKcFAUEE/6/dzdUwUfREGzKPs4CcgHhDCVkG
         QntpZAt5WexRUSse2l2DK/5GMFGPcLufp/9ZIuGtTIXylEKgdk9za11SAnikdlW7s2Iv
         ajFIMZf/iejdPeGUiFwhIY3hvZNKMSkPqW4OnehXcuPD0xp+QYmJExZwaknk4zBzQKko
         mbuaUJYgjZECfyymYm02gyrdr2uGfpzKkWvNs37xebTHBEmcre+E+vIGXrA3jChe5gBC
         P1/A==
X-Gm-Message-State: AOAM5302pDBqKuc6k0Y3mOQRGwqWBaHK9D/BtqWa6sFsgcfYaqS95Eyo
        UaXYK22gz0LwadHxaKOa7O3XYgxJVuk=
X-Google-Smtp-Source: ABdhPJzTj/U5wGU2C/aGMOITBrjbWQSEEa8cjr65o044OgIUCMFwmEH2e/Gxe0Q9tsZLtevJro52xA==
X-Received: by 2002:a05:6a00:1c76:b0:510:8b76:93b5 with SMTP id s54-20020a056a001c7600b005108b7693b5mr6171900pfw.44.1652985946249;
        Thu, 19 May 2022 11:45:46 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5-20020aa79245000000b0050dc76281c2sm2965pfp.156.2022.05.19.11.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 11:45:45 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        =?UTF-8?q?Christian=20L=C3=B6hle?= <CLoehle@hyperstone.com>,
        linux-mmc@vger.kernel.org (open list:MULTIMEDIA CARD (MMC), SECURE
        DIGITAL (SD) AND...), linux-kernel@vger.kernel.org (open list),
        alcooperx@gmail.com, kdasu.kdev@gmail.com
Subject: [PATCH stable 4.19 v2 2/4] mmc: core: Specify timeouts for BKOPS and CACHE_FLUSH for eMMC
Date:   Thu, 19 May 2022 11:45:34 -0700
Message-Id: <20220519184536.370540-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519184536.370540-1-f.fainelli@gmail.com>
References: <20220519184536.370540-1-f.fainelli@gmail.com>
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

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 24ed3bd01d6a844fd5e8a75f48d0a3d10ed71bf9 upstream

The timeout values used while waiting for a CMD6 for BKOPS or a CACHE_FLUSH
to complete, are not defined by the eMMC spec. However, a timeout of 10
minutes as is currently being used, is just silly for both of these cases.
Instead, let's specify more reasonable timeouts, 120s for BKOPS and 30s for
CACHE_FLUSH.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20200122142747.5690-2-ulf.hansson@linaro.org
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/mmc/core/mmc_ops.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 6d759fc6165d..2b0bfead730a 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -23,7 +23,9 @@
 #include "host.h"
 #include "mmc_ops.h"
 
-#define MMC_OPS_TIMEOUT_MS	(10 * 60 * 1000) /* 10 minute timeout */
+#define MMC_OPS_TIMEOUT_MS		(10 * 60 * 1000) /* 10min*/
+#define MMC_BKOPS_TIMEOUT_MS		(120 * 1000) /* 120s */
+#define MMC_CACHE_FLUSH_TIMEOUT_MS	(30 * 1000) /* 30s */
 
 static const u8 tuning_blk_pattern_4bit[] = {
 	0xff, 0x0f, 0xff, 0x00, 0xff, 0xcc, 0xc3, 0xcc,
@@ -947,7 +949,7 @@ void mmc_run_bkops(struct mmc_card *card)
 	 * urgent levels by using an asynchronous background task, when idle.
 	 */
 	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-			EXT_CSD_BKOPS_START, 1, MMC_OPS_TIMEOUT_MS);
+			 EXT_CSD_BKOPS_START, 1, MMC_BKOPS_TIMEOUT_MS);
 	if (err)
 		pr_warn("%s: Error %d starting bkops\n",
 			mmc_hostname(card->host), err);
@@ -965,7 +967,8 @@ int mmc_flush_cache(struct mmc_card *card)
 
 	if (mmc_cache_enabled(card->host)) {
 		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-				EXT_CSD_FLUSH_CACHE, 1, 0);
+				 EXT_CSD_FLUSH_CACHE, 1,
+				 MMC_CACHE_FLUSH_TIMEOUT_MS);
 		if (err)
 			pr_err("%s: cache flush error %d\n",
 					mmc_hostname(card->host), err);
-- 
2.25.1

