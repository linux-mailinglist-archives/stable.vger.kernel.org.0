Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795E852AA23
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351956AbiEQSJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351910AbiEQSJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:09:30 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC36F5FB8;
        Tue, 17 May 2022 11:09:19 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id c22so865046pgu.2;
        Tue, 17 May 2022 11:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zGBHNRVAReTR8yDYLvhJzA/B3avPsiigOsOP3ZNzQYw=;
        b=polGNZfBWi5g/eJVDnC60LyaRdJx9thJ5mqQE3iXHQMfcNAQImQ846+Lt7Wz6e6i0h
         wIftuHyM2SYU7q8X7x25s6UV3R1VgQkweIhF7l2lfzehTrQlaSsIboUkm/L4S1/MJoTm
         q/SOnSlZ/9KnGgv2gKYf0bd2rlnq0rVqAmhoiwDyuT+VWo5+2CpPdB0oPaXEFxJKYBKX
         oKJgeveiMEhFr5RRLC4sCQ4aEVW6YWrBAfJ3ZX6lYlGNxzMj/ILeuLyEhQ4McVIbCohK
         NNLauje8VSBuhCOMBojAI022Sv/jIuT0VhC2HtJcIUZOIpWPOeyoyoyl62qqOmbAX1Db
         kvtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zGBHNRVAReTR8yDYLvhJzA/B3avPsiigOsOP3ZNzQYw=;
        b=5EOqd6pMCXS7/J66tCFH4vtWfK4+SbRkzJuVD7xwiqlIMsrmfGp0RKMNZCo0uRWhzE
         jVyg17Q3fsji4fEuIsL9yGMioxXouGH4wdf2XMgiHMeIE/udCzVYKaoN9FJGb7hSe1zu
         O7u6W4kW55EqUyIAkWrfIh0eheKoYSI6UGnEDsXDV7NfggcA0TtE8oNrR/ei+xwuxpB7
         PesGHIDeK5Q5rt4y8cM2MLW3avqUi1lN3tuRjZjawWWfjjSlwtnht/ckAHGR3N8hYpsP
         VG4wnBOPF05w61YLXJk93oDjAhQRMPfzW1YGNfg2ko8J5jYHofGU9Lq5mmk2KJCGf6Ml
         1JIA==
X-Gm-Message-State: AOAM530sJUMtGs3G56IErjqF1YjIaXEbKGeI9TKV0CTns8bBhqm5jf6T
        NNaymvOHB28tkxK8do62iwD4y2b6ZO0=
X-Google-Smtp-Source: ABdhPJyI2gEUFdqQjQg0dM1F0fryaEE05aE2j0+UkSByd5iYL6bx26rgrjaDRqPhTyS/GRtMR1+D5w==
X-Received: by 2002:a63:125e:0:b0:3f2:5b13:5aac with SMTP id 30-20020a63125e000000b003f25b135aacmr11837658pgs.401.1652810958893;
        Tue, 17 May 2022 11:09:18 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i5-20020a056a00224500b0050dc7628160sm46854pfu.58.2022.05.17.11.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:09:18 -0700 (PDT)
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
Subject: [PATCH stable 5.4 3/3] mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()
Date:   Tue, 17 May 2022 11:09:11 -0700
Message-Id: <20220517180911.246016-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517180911.246016-1-f.fainelli@gmail.com>
References: <20220517180911.246016-1-f.fainelli@gmail.com>
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
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/mmc/core/mmc_ops.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index d8f419183144..d495ba2f368c 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -460,10 +460,6 @@ static int mmc_poll_for_busy(struct mmc_card *card, unsigned int timeout_ms,
 	bool expired = false;
 	bool busy = false;
 
-	/* We have an unspecified cmd timeout, use the fallback value. */
-	if (!timeout_ms)
-		timeout_ms = MMC_OPS_TIMEOUT_MS;
-
 	/*
 	 * In cases when not allowed to poll by using CMD13 or because we aren't
 	 * capable of polling by using ->card_busy(), then rely on waiting the
@@ -536,6 +532,12 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 
 	mmc_retune_hold(host);
 
+	if (!timeout_ms) {
+		pr_warn("%s: unspecified timeout for CMD6 - use generic\n",
+			mmc_hostname(host));
+		timeout_ms = card->ext_csd.generic_cmd6_time;
+	}
+
 	/*
 	 * If the cmd timeout and the max_busy_timeout of the host are both
 	 * specified, let's validate them. A failure means we need to prevent
@@ -544,7 +546,7 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 	 * which also means they are on their own when it comes to deal with the
 	 * busy timeout.
 	 */
-	if (!(host->caps & MMC_CAP_NEED_RSP_BUSY) && timeout_ms &&
+	if (!(host->caps & MMC_CAP_NEED_RSP_BUSY) &&
 	    host->max_busy_timeout && (timeout_ms > host->max_busy_timeout))
 		use_r1b_resp = false;
 
@@ -556,10 +558,6 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 	cmd.flags = MMC_CMD_AC;
 	if (use_r1b_resp) {
 		cmd.flags |= MMC_RSP_SPI_R1B | MMC_RSP_R1B;
-		/*
-		 * A busy_timeout of zero means the host can decide to use
-		 * whatever value it finds suitable.
-		 */
 		cmd.busy_timeout = timeout_ms;
 	} else {
 		cmd.flags |= MMC_RSP_SPI_R1 | MMC_RSP_R1;
-- 
2.25.1

