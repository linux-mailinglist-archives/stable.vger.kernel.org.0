Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2399B52AAE6
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352211AbiEQScd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352159AbiEQSc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:32:29 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA603D1D4;
        Tue, 17 May 2022 11:32:24 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id i17so18077114pla.10;
        Tue, 17 May 2022 11:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oac74zs7UeOjKQRdpb+Td3T589EU3K7hbAq7QVHJ8PM=;
        b=mbYKyuopYnBMN0wBO01acMUKoUrcyNW3nt8q++Bf7DBwrpIhdw6LAqIHosfMBWQrkm
         ZBdQBdYvFAasCMQxvZAPcGh156vfQYcfmwrw5IAhjUcekYZLgYqeyZi/nGLeW+c9QV0P
         4EBKwkk3kfiXXhJIj5Fu16jIFkMUYMhlNw7oR8XHukXOWHERrcp3Ol64r3h2GEpTXxpT
         oqc28+YsjkftRCHWBb7XnpMrRT/Ab6AyFsBJwrgM6ELCFws4aBRBFbjGqqXANFL5l4Hj
         xYJBPp5/sQHo2ZN7LI2NE9D+vagfZztsHTdDowk3zNLhgyArKr/J+irLmYZUTXSl+Ksr
         t4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oac74zs7UeOjKQRdpb+Td3T589EU3K7hbAq7QVHJ8PM=;
        b=EZqNOAh/hVkFgdGnnod/gN5W0CfToT5M17LI0ji1kAZmF1Wr9rr/HNbCTiJQpg9Q6E
         SVAQcuUSvh8mep4S15MEq6dq4feAynUdE9+wRL6UQBfEgzzpKqTZD0L0zjXhyzjh4PGx
         gJnP9Q6GPMVuwDxwiNYqEpVLa+fZCAnwJG2Fbs3Vxv8lR3WtdSfNvzO6kuxTQpnf29gj
         AzAFy2oobzXUOf/+BYguWEQUWAuDGvDY7aMTl2lkvueRWuTQxD+f1yc9dszFq5TQPF74
         S7NRhaARv8OcFJ9MKPR7sN24JyKiH0sZJd1tqrQrEmoIfZg6bUIcjzquaAT5UCHV6VM+
         IUOw==
X-Gm-Message-State: AOAM531pAIFRogndYwdtsjZC5XF4z92hyUzZmwo9ZFoqoV4NoLCQ6/f1
        FMuqDqiFAzRWY/biWuLvF/zSHpJ/5Ds=
X-Google-Smtp-Source: ABdhPJx2Zze5zEix5qgl1h8ATK7J5FIyAyyumQCrYGBGA2GNLBWNpKicrUIWz5ZBVhB1TLGMhwYgiw==
X-Received: by 2002:a17:902:d48d:b0:15e:c236:4fd3 with SMTP id c13-20020a170902d48d00b0015ec2364fd3mr23479962plg.113.1652812343400;
        Tue, 17 May 2022 11:32:23 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d26-20020a634f1a000000b003c619f3d086sm8950355pgb.2.2022.05.17.11.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:32:22 -0700 (PDT)
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
Subject: [PATCH stable 4.9 2/3] mmc: block: Use generic_cmd6_time when modifying INAND_CMD38_ARG_EXT_CSD
Date:   Tue, 17 May 2022 11:32:06 -0700
Message-Id: <20220517183207.258065-3-f.fainelli@gmail.com>
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

commit ad91619aa9d78ab1c6d4a969c3db68bc331ae76c upstream

The INAND_CMD38_ARG_EXT_CSD is a vendor specific EXT_CSD register, which is
used to prepare an erase/trim operation. However, it doesn't make sense to
use a timeout of 10 minutes while updating the register, which becomes the
case when the timeout_ms argument for mmc_switch() is set to zero.

Instead, let's use the generic_cmd6_time, as that seems like a reasonable
timeout to use for these cases.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20200122142747.5690-3-ulf.hansson@linaro.org
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/mmc/card/block.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 709a872ed484..7b8c72a07900 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1192,7 +1192,7 @@ static int mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
 				 arg == MMC_TRIM_ARG ?
 				 INAND_CMD38_ARG_TRIM :
 				 INAND_CMD38_ARG_ERASE,
-				 0);
+				 card->ext_csd.generic_cmd6_time);
 		if (err)
 			goto out;
 	}
@@ -1235,7 +1235,7 @@ static int mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
 				 arg == MMC_SECURE_TRIM1_ARG ?
 				 INAND_CMD38_ARG_SECTRIM1 :
 				 INAND_CMD38_ARG_SECERASE,
-				 0);
+				 card->ext_csd.generic_cmd6_time);
 		if (err)
 			goto out_retry;
 	}
@@ -1251,7 +1251,7 @@ static int mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
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

