Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E976852DD52
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 21:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239723AbiESTAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 15:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244263AbiESTAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 15:00:44 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4C7AF1E2;
        Thu, 19 May 2022 12:00:41 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id m1so5579747plx.3;
        Thu, 19 May 2022 12:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=afOne9J+lVfZqbo7IugW/yv7pVLW37G0GWCaPV/BtjM=;
        b=CRQAOZdWKa10skPkYeoqOceAcov25PzE25aovkjd/QIyw4wyn7dsF6UpPoE5gz5Aq/
         wfWvz0k8BZRdHgFHTUMPzLY4eicq0trWM13QL09iVy3RrWvs/LS9uqen3ZodXf6LGQ6V
         kHFDxt8zoinwlXtLZWnOLlRXH5VTbU62MvD/Fl5wEVTu4BOOttf85i+xdiRhXoQil+7Z
         6cPIk/CabhEg2vjMIiMcCd5bO7mkUrM9VCYoHoQ7LIdvUgdhxZsPYbhub7pOkv0rDlEJ
         utZNY7VPz7FJQh/mdnxtmNgf6LcfGG7/8rP0M9yy3I8E+LAjg/P05Jh0Lb0Vjd95yqV/
         VE7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=afOne9J+lVfZqbo7IugW/yv7pVLW37G0GWCaPV/BtjM=;
        b=CPSbgcwMULJMJnD4CtHi+G0tqg2hLDAn+LbhVKYTyzIgzTpBzrnQ1A+D74XLj3JhqC
         i7nb9hfoZkYPdJFstPHWLGTTmWmRsP3k3UI519tso5I2T5oG13LY2B9R0ZfVCCxs30mY
         XJWStdIvLD66PuWSLJ+bJYPhTTEGPNP7PA9Hd9IrgHzB+FX9avij1rdGOz11o8IX6x/L
         3E8iuWzLYZlsbPqG3gkoe1XhiN+jZSe4p5Dg+WDIH77t2ls28NrzJ3ObbV4jQ05pgrCb
         TcYZhOtsLwog/1p5BMZMX6J6zW8V2RDnNunGEInM9TzJusfOqoFMppQanbNhG7G3JZpC
         /5LA==
X-Gm-Message-State: AOAM532aToFoLNY8KbcwWEPseuoMfiNR095FE+ykdSoXyOdgosht8Mc/
        iGORG7OslEkAe4SIOROO0uEbmMHii2o=
X-Google-Smtp-Source: ABdhPJwUn1ssIajamwwqUO/M3HBOX6tgsAFF+fl8jN2M2lYOrz96bBwVyQxa6lJYfu+y08eJ7QZ/Jg==
X-Received: by 2002:a17:90b:4b12:b0:1dc:dfdb:446 with SMTP id lx18-20020a17090b4b1200b001dcdfdb0446mr7107333pjb.150.1652986840558;
        Thu, 19 May 2022 12:00:40 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c11-20020a170902d48b00b001618b70dcc9sm4199358plg.101.2022.05.19.12.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 12:00:40 -0700 (PDT)
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
Subject: [PATCH stable 4.14 v2 3/3] mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()
Date:   Thu, 19 May 2022 12:00:30 -0700
Message-Id: <20220519190030.377695-4-f.fainelli@gmail.com>
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
index 5d806c2100ae..45cffccc7050 100644
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

