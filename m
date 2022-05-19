Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2C752DD01
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 20:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244050AbiESSpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 14:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243348AbiESSpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 14:45:50 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6B72BCE;
        Thu, 19 May 2022 11:45:49 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id a38so2954124pgl.9;
        Thu, 19 May 2022 11:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZzqOqhSTkWyW6a60hc2pV5v/t4bQqt425oCJrlN7gc0=;
        b=qsypusjSlrTckBPP5ArDLAECrZ8fySUH4miXGfSSc1QlMcM/cxx5aubfqQGjVVmVkW
         4vK2X6kHRFe78UZntaE9zvoQG9NSwIpXrPyjnvTWvVaNBIMTGa4aSc4Aje7a16SW2ZBn
         U7bzRAV5yIgW8af417CkMh8BCqa793GsEBbgNTctMPuSGWNc8T6r4fuBlcfkav2ZRIWJ
         XBZ2xAvvFrMJguTA+7qYo1VyBQeVWWIy1j7oyyGr5Yy4UndiW42xykJw+eA4BtaQwhlo
         Xxf+Nl6XMXP9Mj+iVekEeRk9csU3HM3vSKVhbQFm6TXHMh5RYfLP7FPSLKppRA2qKYH8
         h1wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZzqOqhSTkWyW6a60hc2pV5v/t4bQqt425oCJrlN7gc0=;
        b=Zq89Otm4t8V+g85UXdcZwp5PRC84rfnH+bZQolBwV37Zxcqt8wVcqA4+VEl7LHbp2x
         DDEg47zCdRkLSsRXv1azSPs1GpLvs8Z7lVAg9MR5uBUvdfBcg/193lp+v1O8LkIbc3ci
         tLT7b3hMUTUzPueUzQxpULFwyRunzSYebwl0JcVdnEQiuvJA+1C3WvXmnFIqgCIuIpOf
         KqjwwnQXT1hDWwSe+s5sZYTjB/3Q9tM9JicojbJrwgFzLyWihS3QoU3+Ar1sEVfTfROa
         a27n7Cr7lCwGLgZyqC2tXBv5iNlA3CwSaqfKSYevLzHjV8KRErbKxvEJq/Cl3lLvJtG1
         /zSQ==
X-Gm-Message-State: AOAM5336D5kUHhLyc+FzpJ6eDFnHbjfg+CQN6ri0sQF7zN4yoK5rv2vw
        7NZjAIt07gNXrrj5y12d0/L6r/APUtM=
X-Google-Smtp-Source: ABdhPJxRdCTc0olvpIJOOzMkLS6FI1DrpkkBY8Bh9LqDwibV6e8SzxsEAVa/ebrSGs4MaYcULA91hQ==
X-Received: by 2002:a05:6a00:4086:b0:518:3207:f9df with SMTP id bw6-20020a056a00408600b005183207f9dfmr5999716pfb.9.1652985948802;
        Thu, 19 May 2022 11:45:48 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5-20020aa79245000000b0050dc76281c2sm2965pfp.156.2022.05.19.11.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 11:45:48 -0700 (PDT)
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
Subject: [PATCH stable 4.19 v2 4/4] mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()
Date:   Thu, 19 May 2022 11:45:36 -0700
Message-Id: <20220519184536.370540-5-f.fainelli@gmail.com>
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
index 2b0bfead730a..c2187fc6dcba 100644
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
@@ -534,6 +530,12 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 
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
@@ -542,7 +544,7 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 	 * which also means they are on their own when it comes to deal with the
 	 * busy timeout.
 	 */
-	if (!(host->caps & MMC_CAP_NEED_RSP_BUSY) && timeout_ms &&
+	if (!(host->caps & MMC_CAP_NEED_RSP_BUSY) &&
 	    host->max_busy_timeout && (timeout_ms > host->max_busy_timeout))
 		use_r1b_resp = false;
 
@@ -554,10 +556,6 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
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

