Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540AC52AAC0
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352147AbiEQS2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352146AbiEQS1z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:27:55 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E84D3A5EC;
        Tue, 17 May 2022 11:27:53 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id nr2-20020a17090b240200b001df2b1bfc40so3288690pjb.5;
        Tue, 17 May 2022 11:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LGuxibFTHVjCAz0ybPT2MKSv3/jhO/zHqmdvIfRwZ+A=;
        b=F9TyYQ96A4YECxuy4UHHZKn0NrBhahBF+FJ7cZSNuGmwUmPyutnggxIxw0Rfr9pvCi
         ifaJEdEF8uERizrtaS0GTmRs71psef/tEg0qCjTrE2AQH31+Lz2UxRPNGj1PFrP9g3BL
         wvoXE9+h9mDklMcG58V0XQOfrUyk+mdRkLhlrSpHLQSKwmgPwaAtXlvlL7LnAasaJBn9
         I1Iw0IEdcYFKPXNAWV1UclYpnc9hfSDL/Vd7hYO1iKRQKLJ8zBgpZtPWwNuuOs5q6N9N
         cPRCRLC0aPm5fqnn+WY6XExj4GeQRvA85vthywhB901vJ1BtEH2/Tp2BZP04MTfLQYYn
         mqiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LGuxibFTHVjCAz0ybPT2MKSv3/jhO/zHqmdvIfRwZ+A=;
        b=vivhPsLK5LjcfKTUVdYHm/VkErXv68JOLgX+BZIoZokyOs0X92XvGeItDR0ML6RyLn
         8ynVrzzhRwnXaeqsr16OFX9Cf6B63J2TT6wQ8sYtksn93okKV4FO7+fcis8vpxhKrphl
         CDW+uhXBDHpe6c6flYHSwePgfZw7P5bMIUzWKM+hwlqPjx9vXCXed9zNnge8ylpJlIi1
         HD9DEZzdwa0E66lednCBfDzN/y7dQnUzq/kfguAUi1qIcqFw8Qdu8+WKzIatBneeyz1g
         nOxjkEp1iAv3gIUlz8XjKxND7nih1lj80y67wtg6wJ6ef24RM8udxyFyIgCYeyJi1lwM
         pQ/g==
X-Gm-Message-State: AOAM531wJeABxaW8KJfN1VB6/b4ndBqkPO14heqiv2qbuR+M7IQ1DrPe
        /rkqUTdSgB76PJg7PqdvorG1CdT+Nio=
X-Google-Smtp-Source: ABdhPJwOv1pNKGsNZp5G0JbD4LbpzkxMX/9AAGEu20GB2XBdDTQi0IyGBt24c407TZf+BzyiElfXtQ==
X-Received: by 2002:a17:902:700b:b0:15f:a51a:cdeb with SMTP id y11-20020a170902700b00b0015fa51acdebmr23178864plk.137.1652812072370;
        Tue, 17 May 2022 11:27:52 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902d88c00b0015e8d4eb1fasm9538656plz.68.2022.05.17.11.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:27:51 -0700 (PDT)
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
Subject: [PATCH stable 4.14 2/3] mmc: block: Use generic_cmd6_time when modifying INAND_CMD38_ARG_EXT_CSD
Date:   Tue, 17 May 2022 11:27:45 -0700
Message-Id: <20220517182746.252893-3-f.fainelli@gmail.com>
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

commit ad91619aa9d78ab1c6d4a969c3db68bc331ae76c upstream

The INAND_CMD38_ARG_EXT_CSD is a vendor specific EXT_CSD register, which is
used to prepare an erase/trim operation. However, it doesn't make sense to
use a timeout of 10 minutes while updating the register, which becomes the
case when the timeout_ms argument for mmc_switch() is set to zero.

Instead, let's use the generic_cmd6_time, as that seems like a reasonable
timeout to use for these cases.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20200122142747.5690-3-ulf.hansson@linaro.org
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/mmc/core/block.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 36ea671c912e..79e5acc6e964 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1345,7 +1345,7 @@ static void mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
 					 arg == MMC_TRIM_ARG ?
 					 INAND_CMD38_ARG_TRIM :
 					 INAND_CMD38_ARG_ERASE,
-					 0);
+					 card->ext_csd.generic_cmd6_time);
 		}
 		if (!err)
 			err = mmc_erase(card, from, nr, arg);
@@ -1387,7 +1387,7 @@ static void mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
 				 arg == MMC_SECURE_TRIM1_ARG ?
 				 INAND_CMD38_ARG_SECTRIM1 :
 				 INAND_CMD38_ARG_SECERASE,
-				 0);
+				 card->ext_csd.generic_cmd6_time);
 		if (err)
 			goto out_retry;
 	}
@@ -1405,7 +1405,7 @@ static void mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
 			err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
 					 INAND_CMD38_ARG_EXT_CSD,
 					 INAND_CMD38_ARG_SECTRIM2,
-					 0);
+					 card->ext_csd.generic_cmd6_time);
 			if (err)
 				goto out_retry;
 		}
-- 
2.25.1

