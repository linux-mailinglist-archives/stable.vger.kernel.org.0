Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE1A52DD4B
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 21:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244229AbiESTAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 15:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244231AbiESTAi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 15:00:38 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A50DAE257;
        Thu, 19 May 2022 12:00:38 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id f10so6089365pjs.3;
        Thu, 19 May 2022 12:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f5nwmGy5oMoJJhvXOwEiGtsbFzyrE3Fk3djskSbIhto=;
        b=N9KZebV5dsfxBGioaMjIWm9Sk1m5ccsJlNpLSvkjmI0Bns3ps2gfNxkRrchUDmsxwl
         hTaQnGZJNeaihzfsAnO2Lh62x670O8w1Hb8GGn0xQzvntYpgHDH0v/oFyXI/vQjVarjL
         Wckq9mRFP4fQXtCUp79VaImX/mGABm0KQxn35QU+adJNOnavLWFDIEBIs9zE9XakCn0l
         cIHNbNn8T1DAuH8MDyyxEtGDxQufIMBh+wpcxLG5nAvtuYcpWQBKPwy22+roQIw5zwAo
         3jvKHxELcw7aJrA6PahMonF341ri1BSuCc7pZHNl1UZDis9WH085klMJlfH+YiVZKprN
         l16w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f5nwmGy5oMoJJhvXOwEiGtsbFzyrE3Fk3djskSbIhto=;
        b=nOW0PAT1JgM1xm3bGBazsp7+ncYVNsNqJ/lR/rJeHIuOWTDyQLkGO6EZUwtPjlNM5p
         /bTYmPKCKO31SUOFVnZZ0AYkA268zsnKJRDZhX4B6YeM64iI9HIB2tnfd6LcnhUUI62V
         kEUAiyUkk9vlD9KU1Ec22RAg2Z4lFZPzN9qRreCdTIalclYzRZSPuzTT4WqJWdPWPR7d
         lAsTNxG6kJcvXvFkjP8nRLjl/9uU2Krw770TAEPGmj5dLQOEFolIWPG5mYPCvjok3uH9
         A3H4m8fKM84K6fIoJlwmBQ+YS/OcuAe6kI5gK2sTtgPmsd+RDmT/94Bgy02euDMsnWpa
         j/2w==
X-Gm-Message-State: AOAM531hKIgSPHt89zq3CcpRLpgvNU1+Wf1GC+63PRv9F8lq6Oiy2WCA
        YPpx7EEaElO+/+2aG6YGvf68ccbpwow=
X-Google-Smtp-Source: ABdhPJzQ5pyRYp+hxUmzoYMumH5ZPFv90N3rFqNtDWO/HZa1UsA93/r/WE0+PRU9J1NErwzfjfKrhQ==
X-Received: by 2002:a17:90b:4a4d:b0:1df:53dc:c094 with SMTP id lb13-20020a17090b4a4d00b001df53dcc094mr7216580pjb.69.1652986837436;
        Thu, 19 May 2022 12:00:37 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c11-20020a170902d48b00b001618b70dcc9sm4199358plg.101.2022.05.19.12.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 12:00:36 -0700 (PDT)
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
Subject: [PATCH stable 4.14 v2 1/3] mmc: core: Specify timeouts for BKOPS and CACHE_FLUSH for eMMC
Date:   Thu, 19 May 2022 12:00:28 -0700
Message-Id: <20220519190030.377695-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519190030.377695-1-f.fainelli@gmail.com>
References: <20220519190030.377695-1-f.fainelli@gmail.com>
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
index 54686ca4bfb7..5d806c2100ae 100644
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
@@ -979,7 +981,7 @@ void mmc_start_bkops(struct mmc_card *card, bool from_exception)
 
 	mmc_claim_host(card->host);
 	if (card->ext_csd.raw_bkops_status >= EXT_CSD_BKOPS_LEVEL_2) {
-		timeout = MMC_OPS_TIMEOUT_MS;
+		timeout = MMC_BKOPS_TIMEOUT_MS;
 		use_busy_signal = true;
 	} else {
 		timeout = 0;
@@ -1022,7 +1024,8 @@ int mmc_flush_cache(struct mmc_card *card)
 			(card->ext_csd.cache_size > 0) &&
 			(card->ext_csd.cache_ctrl & 1)) {
 		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-				EXT_CSD_FLUSH_CACHE, 1, 0);
+				 EXT_CSD_FLUSH_CACHE, 1,
+				 MMC_CACHE_FLUSH_TIMEOUT_MS);
 		if (err)
 			pr_err("%s: cache flush error %d\n",
 					mmc_hostname(card->host), err);
-- 
2.25.1

