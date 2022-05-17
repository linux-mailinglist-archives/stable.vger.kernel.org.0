Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40AD052AAC3
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352154AbiEQS2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352151AbiEQS16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:27:58 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECEB49F24;
        Tue, 17 May 2022 11:27:55 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id i1so18095418plg.7;
        Tue, 17 May 2022 11:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+6e4auPbEK9DxXd0V9+qfi6AbLb+sAnTsXinMSGP6W8=;
        b=qsmvBNN7PZ9IFU9rnCNf1FCSMJHglYnLVgRElSGox08wSOT/SH/RyPVYdl7OM5V88a
         SBBMGb3X5h8kDyeAgKInfHzTRUXDyu/5Sq7EFQlKuTo+kpzBg3Xzl65NrTxqXMGTYwzL
         xJh6FTOz9inkZ6D0VJvaamjy+UELqDzoBwhb1mlfv5hRgARQmGlFgDRKsmb97+YnQyp0
         f5+rFB3by/pRi5LZ2uyto+PK+aYJFsE9SViruLmnviuD2x8N1OtX1QMf4ntaBDEKhPes
         C8/5ytJrjzonfGCFSQFY1yyuzXAel+fTTv56nJZJC78CzWi75coalEGVY2mv5KV5irph
         xXfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+6e4auPbEK9DxXd0V9+qfi6AbLb+sAnTsXinMSGP6W8=;
        b=piLrjRh92uaVRZZGJ2/tfS7XIbCxWHu0NZQDFstmVeyPJT0wG705noJ7OX+3XKDAyh
         8m6C7/65vaa9vmT16O39xiehzaY1amYUcDk3Nv11r6x0a6JsYI4E+J3cWNo4v6mxuftk
         VprdxyB+LzMWp/74Wr5qiwJE9GYi8ZYGhJZWcLNruKCozPEZURIj+YZd8ITIHXt0yTyG
         RcwGTgoMZYLwuKDvDs9AbhD34k9yMcY8bBRAuh4gX/DNsapln3h+P29lgD9l+R1y8ra7
         qx7y9dMRXmCN22AdGEbLV+VjQiMRqTuYWVs0ZoBGwCWdlkpK/+macNwzXSJ/xAfrRQt/
         tdxA==
X-Gm-Message-State: AOAM533vWIaSWfIxrHMdWTV1+4dMhlugPJOrbjPpgB/LtDWhoFiNuiNO
        TCVE0XqJ1rbB/LyCYWtwG0f9cAaocRU=
X-Google-Smtp-Source: ABdhPJynwktvzrf7Li/Ht1Wg/Cm+kIzKWWSb0cMIb0X1ql9KH1ykyjANUr9vuT9+7GSUy20IK9JYDw==
X-Received: by 2002:a17:90b:314e:b0:1dc:d143:a15d with SMTP id ip14-20020a17090b314e00b001dcd143a15dmr37234806pjb.111.1652812073739;
        Tue, 17 May 2022 11:27:53 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902d88c00b0015e8d4eb1fasm9538656plz.68.2022.05.17.11.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:27:53 -0700 (PDT)
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
Subject: [PATCH stable 4.14 3/3] mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()
Date:   Tue, 17 May 2022 11:27:46 -0700
Message-Id: <20220517182746.252893-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517182746.252893-1-f.fainelli@gmail.com>
References: <20220517182746.252893-1-f.fainelli@gmail.com>
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
 drivers/mmc/core/mmc_ops.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 44e90062c95a..0767ed1b820f 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -458,10 +458,6 @@ static int mmc_poll_for_busy(struct mmc_card *card, unsigned int timeout_ms,
 	bool expired = false;
 	bool busy = false;
 
-	/* We have an unspecified cmd timeout, use the fallback value. */
-	if (!timeout_ms)
-		timeout_ms = MMC_OPS_TIMEOUT_MS;
-
 	/*
 	 * In cases when not allowed to poll by using CMD13 or because we aren't
 	 * capable of polling by using ->card_busy(), then rely on waiting the
@@ -534,14 +530,20 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 
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
 	 * the host from doing hw busy detection, which is done by converting
 	 * to a R1 response instead of a R1B.
 	 */
-	if (timeout_ms && host->max_busy_timeout &&
-		(timeout_ms > host->max_busy_timeout))
+	if (host->max_busy_timeout &&
+	    (timeout_ms > host->max_busy_timeout))
 		use_r1b_resp = false;
 
 	cmd.opcode = MMC_SWITCH;
@@ -552,10 +554,6 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
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

