Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3B252AAE1
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352231AbiEQSci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352259AbiEQSc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:32:29 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFFC517D9;
        Tue, 17 May 2022 11:32:25 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id c2so369715plh.2;
        Tue, 17 May 2022 11:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MRi64/PwuNw25RzXmUxNDrjHI6TIqkB2bzuLr80n4x0=;
        b=YlKqY7mSqg1Y4uGarG6CW5TziiwkWrwLN4qJFbQwbCrJZZmvKpqPSM1E8Jqcr0NUnJ
         KMkmxPgIPD4S3BHOMnEYXLVc79NKZx6wHmSkWwgcDzOs1ON4xxwEirNBEOcm7z2+/Qld
         11Fn/4Uh5IzAkch0AZU5UOkQzKIyN1ALy5DZkpf7Oa4pLUEv6GPbRVsePHuDDEvN9q5b
         NRY63nhagddXTXX5QTnGINp/Cy38hFcvhVVA97gMlNMzy0S0285WQ4abbNASWkOWtxNo
         eVgwNyKQhWWas2ZJtjHszBPn++Jy+ZAcSShXU8o3hnqc9Mmb5fxsX0YL+dQGE3S7wkcR
         k82g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MRi64/PwuNw25RzXmUxNDrjHI6TIqkB2bzuLr80n4x0=;
        b=xZht1+iGkoKOQWyhuteMVEkrfxIQdxCx8U8W+4ldUDnpiurldNiPxuSGvStW5pSHlY
         tTMfDDjSK0X85/U5LIGVNR01Fak7uw+VaWSt9n53jmnv3VY8J/b8HSDffW+9UOxKg/Bq
         y2pSDZ4dC2RQim4lokah3oGwH0kbYXc1JK95L4OSgLnFPJl0LTC99vtl+md7AkTpeojW
         /9QxyQ6nXz4sogElBHAbrEUClB7ZO+yj6nqfv1c6aXLEKK+Nwau/mA09XPA0iuTySCut
         Woov7XFLN1ULzoZ6bHQ7lGEWMAeRFZVAyRfVF+9kLrAi+l8yOe/AObmitMGmeyDsRNwo
         uQgw==
X-Gm-Message-State: AOAM533TlPszUqUt7Z3zlqYpHjJBAIqYO1OQhgL4nR+T9wRgwTRsXuuW
        R4DKULP+7LdLqkD1CwCY28j5lVsoRXc=
X-Google-Smtp-Source: ABdhPJxZfECC+6xgBYrxA3YgS6Q2OHNJnbGxs8+1BRVQu/DPC4W/MT3yN+QdFoywWSEOEuHtcLZB9g==
X-Received: by 2002:a17:902:d2c6:b0:161:6e0e:c5e1 with SMTP id n6-20020a170902d2c600b001616e0ec5e1mr12520168plc.139.1652812344793;
        Tue, 17 May 2022 11:32:24 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d26-20020a634f1a000000b003c619f3d086sm8950355pgb.2.2022.05.17.11.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:32:24 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        =?UTF-8?q?Christian=20L=C3=B6hle?= <CLoehle@hyperstone.com>,
        linux-mmc@vger.kernel.org (open list:MULTIMEDIA CARD (MMC), SECURE
        DIGITAL (SD) AND...), linux-kernel@vger.kernel.org (open list),
        alcooperx@gmail.com
Subject: [PATCH stable 4.9 3/3] mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()
Date:   Tue, 17 May 2022 11:32:07 -0700
Message-Id: <20220517183207.258065-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517183207.258065-1-f.fainelli@gmail.com>
References: <20220517183207.258065-1-f.fainelli@gmail.com>
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

commit 533a6cfe08f96a7b5c65e06d20916d552c11b256 upstream

All callers of __mmc_switch() should now be specifying a valid timeout for
the CMD6 command. However, just to be sure, let's print a warning and
default to use the generic_cmd6_time in case the provided timeout_ms
argument is zero.

In this context, let's also simplify some of the corresponding code and
clarify some related comments.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20200122142747.5690-4-ulf.hansson@linaro.org
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
[kamal: Drop non-existent hunks in 4.9's __mmc_switch]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/mmc/core/mmc_ops.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index ad6e9798e949..3d8907fc2a52 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -22,8 +22,6 @@
 #include "host.h"
 #include "mmc_ops.h"
 
-#define MMC_OPS_TIMEOUT_MS	(10 * 60 * 1000) /* 10 minute timeout */
-
 static const u8 tuning_blk_pattern_4bit[] = {
 	0xff, 0x0f, 0xff, 0x00, 0xff, 0xcc, 0xc3, 0xcc,
 	0xc3, 0x3c, 0xcc, 0xff, 0xfe, 0xff, 0xfe, 0xef,
@@ -530,8 +528,11 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 		ignore_crc = false;
 
 	/* We have an unspecified cmd timeout, use the fallback value. */
-	if (!timeout_ms)
-		timeout_ms = MMC_OPS_TIMEOUT_MS;
+	if (!timeout_ms) {
+		pr_warn("%s: unspecified timeout for CMD6 - use generic\n",
+			mmc_hostname(host));
+		timeout_ms = card->ext_csd.generic_cmd6_time;
+	}
 
 	/* Must check status to be sure of no errors. */
 	timeout = jiffies + msecs_to_jiffies(timeout_ms) + 1;
-- 
2.25.1

