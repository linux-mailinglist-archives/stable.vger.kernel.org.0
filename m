Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A5752DD04
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 20:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243407AbiESSpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 14:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243296AbiESSpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 14:45:50 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6358A2192;
        Thu, 19 May 2022 11:45:48 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id z7-20020a17090abd8700b001df78c7c209so9539374pjr.1;
        Thu, 19 May 2022 11:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iVjd1/EvWaUwXfqtYGQYzVVFnQ1gXdjk50qNj+0oQ6A=;
        b=pqBrRfWnGfmlO7DN6JqKh6vWUqA1p8Xg14czQ4dwzHHNyGUrXQBcWIZCjzP6N2dgA5
         RsJoYKTa7oaXBxLIwRpOaIGx7ypL8rN7YKKsbfjtgcxUptUgoXFziGBRiejkn6F/ggPr
         C+w6UjHt7rizNRBYj6Mv1jcxtn3tOALNk1rBkXoC6DKIUROhIU2ieszoK60zgjjSDqlr
         45dQFSGSItVHODh+GdukwFeq6g7KoxVqaj8w1lqcPCTyDu0AoMZVL0PAc4EIcLE2tG+D
         Gsr/Kqg9UeERMn/lZJ2mn6JsdlF2Ok8UHvMnYT24+feCdcpJQQjnPOzbFPAMDqHNfMe/
         qDjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iVjd1/EvWaUwXfqtYGQYzVVFnQ1gXdjk50qNj+0oQ6A=;
        b=t97Jurx4UDzbuWZhHYreevfbXYEz9BUuLAfXXBnv7VjbYaXNLDY/uW7VlpT02Uu/lf
         hnp9jJbejgCb8o5jT5Hxa6WRer4lS6KupOxtd17VMvRdEjvLByyFchQJJLzX0n7fPpL3
         N5VYLh2t2XZ0fIFWvNQrROF1k1/LV8CJx5cKcVj8/qlcKK1sgAKHafrs7Xs9DY4oT49U
         skwDfAuVgxd+M4I0UwiUqTO37F4outsP2XxGuGVf9C2tjkTEdh2y0zFj2j9YOkdpmFCJ
         0yt2l+XCoqfrXsbP6DQMxjWgVTgLKVKxI0Z8lJdnWdVwujSWBwvRiMi9LGyjgmiMb7bv
         rYuw==
X-Gm-Message-State: AOAM5300ucLWrKh5/65TOH1FhEDkyWTUweYIi1d0fOIoGOZ7Z6Dtu2Nf
        X60hOeMTunDwZVi8YkL4HDftHusMHk8=
X-Google-Smtp-Source: ABdhPJwzk08FWAy+yUBTXj2QGpGnjLjx6Tc5fUvqRWFQZQUJnv2ncHp88mtToOd0+hdEuDm1PLAk4w==
X-Received: by 2002:a17:90a:9b0d:b0:1dc:e81d:6c18 with SMTP id f13-20020a17090a9b0d00b001dce81d6c18mr6629643pjp.72.1652985947575;
        Thu, 19 May 2022 11:45:47 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5-20020aa79245000000b0050dc76281c2sm2965pfp.156.2022.05.19.11.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 11:45:47 -0700 (PDT)
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
Subject: [PATCH stable 4.19 v2 3/4] mmc: block: Use generic_cmd6_time when modifying INAND_CMD38_ARG_EXT_CSD
Date:   Thu, 19 May 2022 11:45:35 -0700
Message-Id: <20220519184536.370540-4-f.fainelli@gmail.com>
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
index d8bcf1e0b337..c6e83f6021c1 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1133,7 +1133,7 @@ static void mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
 					 arg == MMC_TRIM_ARG ?
 					 INAND_CMD38_ARG_TRIM :
 					 INAND_CMD38_ARG_ERASE,
-					 0);
+					 card->ext_csd.generic_cmd6_time);
 		}
 		if (!err)
 			err = mmc_erase(card, from, nr, arg);
@@ -1175,7 +1175,7 @@ static void mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
 				 arg == MMC_SECURE_TRIM1_ARG ?
 				 INAND_CMD38_ARG_SECTRIM1 :
 				 INAND_CMD38_ARG_SECERASE,
-				 0);
+				 card->ext_csd.generic_cmd6_time);
 		if (err)
 			goto out_retry;
 	}
@@ -1193,7 +1193,7 @@ static void mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
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

