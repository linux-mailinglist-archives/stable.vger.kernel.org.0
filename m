Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5791752AA99
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352092AbiEQSW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352090AbiEQSWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:22:25 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F592DAA4;
        Tue, 17 May 2022 11:22:20 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id nk9-20020a17090b194900b001df2fcdc165so3338618pjb.0;
        Tue, 17 May 2022 11:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6Cx+Yg+pJSpSbpHi8GAC7T8VbsPpv6YKELwai1HS3Tc=;
        b=kcIkQJ9iOzl5AewwWhGtdCVQJA7efCkTIxnj4IVAmJqBDG8R86R8ka8rUQE2RbPMkW
         8uk44EU+zoZ8tMDyHjpOQuzmcyV01pRmRxF0iaEf6ZMEv7xjNR1UPS32ks95NLRKA9k2
         VPa0ShkUvQudrSVOB1YknMbQFp4rfeNVSSLsf38GHLgJwy8Wk23U01QEpQBkpq8WRPFB
         B23qixQs45BPOsl+4EQ/Bib0TjObFNll9K2qMGgPumyuIUJTmsLAAPkY30RB0u3Bznl9
         drFYL5uecjL9hrOMFMZMMLoBrD1l1aqmVFWHmDJ5rNYQOVXbVug4N50Drtb3shvdtSeO
         rAtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6Cx+Yg+pJSpSbpHi8GAC7T8VbsPpv6YKELwai1HS3Tc=;
        b=40HR/S+llcHtp7C9G39WBAFEJT6ciTUaXjO+eVPzmUReuN9v0uIwalOg1mkjXkhMvt
         3jTV1etah1SlhbaQBt5tPOVzPCWZFA8/dJmOCk4lwFNgkLObIkfmyQprcYwQscYcZ9CS
         A0d3xO/Wuq3bGu/2aRJtwIPHSXqzRjzK93ZjZVyGuzaBfZMU/zlVDfW1BUVxFSEZXZmD
         3S2SelDLZPGT1hVIfbJEAqqlpSYRv2ZtFSxNbGfzwqNkqExIcrnlb2ISZZcY1qqF1nl8
         eM/0E/Y619vNoYE0Lt7GKkHpHcPhy0NQEma9cU2R1lHZua936y//P60ackACJrYMt5ej
         CoMw==
X-Gm-Message-State: AOAM531zHEvut/8GtZQlwT3ItWZ4Yg3ED2/9BlSDS+H3RZ4ZVNoIJauP
        orMIXPvq9VJ32v+D98LIOCAY9MPx0so=
X-Google-Smtp-Source: ABdhPJypOz5QeLq1BCymxWb8BTSmhkuE4uf+8Kz/ml3fhTQOjEZJmCZk30sfg8NnNQoCjVGx7bhLuQ==
X-Received: by 2002:a17:902:ce8d:b0:161:761f:6999 with SMTP id f13-20020a170902ce8d00b00161761f6999mr11409649plg.125.1652811739977;
        Tue, 17 May 2022 11:22:19 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x4-20020a17090ad68400b001d7dd00c231sm1998141pju.22.2022.05.17.11.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:22:19 -0700 (PDT)
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
Subject: [PATCH stable 4.19 3/3] mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()
Date:   Tue, 17 May 2022 11:22:11 -0700
Message-Id: <20220517182211.249775-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517182211.249775-1-f.fainelli@gmail.com>
References: <20220517182211.249775-1-f.fainelli@gmail.com>
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
index 3e10023cf485..26783a39c547 100644
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

