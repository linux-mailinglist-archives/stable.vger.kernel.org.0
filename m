Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB8452DD4D
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 21:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244260AbiESTAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 15:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244222AbiESTAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 15:00:40 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EAFAE266;
        Thu, 19 May 2022 12:00:39 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id f10so6089365pjs.3;
        Thu, 19 May 2022 12:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LGuxibFTHVjCAz0ybPT2MKSv3/jhO/zHqmdvIfRwZ+A=;
        b=lniafC7bVeN6/UgxO0nnq08Wz/BPGPlg5usi1RrO8IR+JPMG+mw6S+qGo71SHFxj56
         K3pK3Zqpg1wQIpH0BWxKR+5oHAtr598PdSJD/uOY1thWbmQLGE3e+ed7p0GA24Cpm3PL
         7BXlMpCCJh+zbpC+X64G1zPiFuGFbkhQ7mHKMZ9afjr50XVpXwfTpMnWiXFnV17k4xD5
         0rY9SJqec/lyajAliJfTK+HZDc8k4EXvxd59VDSUTOOo0RimtMoo/gaIsrCejZ6IUQrq
         E3dY8GwwC/xx6T2w88lNN/p6whrpIf0M7TVHM7UM1s/ZzAAanhIpSYiKIjwCUaBRWRGL
         Zkfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LGuxibFTHVjCAz0ybPT2MKSv3/jhO/zHqmdvIfRwZ+A=;
        b=1lPOKzADMH8AXanDBtrIHoyx8uYQjyXp++e8yfi6eobO9p8oP9NVIQoP96t+X7wXB8
         UcUc7UK3gkl9CAJf65xAPxht+iUrp/JFY6yjk6bHxniukkNnp/61IX24CyZ582OKoMof
         ZiC1hwzJAPcUoUkp1V9kszFUUvdDDENJVmC6L8xu+skzdI7Sd6BpvMhtQPOT6O6Fyc0X
         TMIdvy4E2p27hM+NZp0uaxEu1Zjt5cuzAkGNEIW5Vey7rWZjuQD7AM+ApZxqyK4hJQM/
         +FKSRxkluVbY2KgPoBNHV4N29ivunNQMRml+gbXKYY3a6vzTjsA0m7lFMXDqdU/bvymC
         YHcA==
X-Gm-Message-State: AOAM5308RwwvLCwlt2qoiAn4rD+dccTeWxkq3EOoB7drnOmYqbr1+SHA
        /DD2K56CLdF4EbHiX6hyc/8yyg4jR0I=
X-Google-Smtp-Source: ABdhPJyKz270RDuAIgLiSE6TVi+HoN6ca9lTrLO8UY536fmG0YGMjcV2pYu7rZ6gjq9Mo6Vb02Lpiw==
X-Received: by 2002:a17:90b:1c02:b0:1df:d8b8:6eb1 with SMTP id oc2-20020a17090b1c0200b001dfd8b86eb1mr4543243pjb.90.1652986839021;
        Thu, 19 May 2022 12:00:39 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c11-20020a170902d48b00b001618b70dcc9sm4199358plg.101.2022.05.19.12.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 12:00:38 -0700 (PDT)
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
Subject: [PATCH stable 4.14 v2 2/3] mmc: block: Use generic_cmd6_time when modifying INAND_CMD38_ARG_EXT_CSD
Date:   Thu, 19 May 2022 12:00:29 -0700
Message-Id: <20220519190030.377695-3-f.fainelli@gmail.com>
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

