Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1E352AA9B
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352079AbiEQSW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352086AbiEQSWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:22:25 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FAB2C66B;
        Tue, 17 May 2022 11:22:19 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id ds11so6581059pjb.0;
        Tue, 17 May 2022 11:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B5z0WBrh/BYYCHvUIIawnVVkGhzF2/2dcuB+5FV8icU=;
        b=AbmiKr13LjgHA635CCvhqbpmwmKepo6wngtA1F550JNQxJC3Osg5bRdXGL1Vo2Tc62
         2pMzTwyxYU1XYVg1C7uebLES6pcrHRK2QxLTtQocI5ovbyD1qY6J2Mihj+vKZXcVbZ7V
         gRHae3em/E3V7nEQO9M+Nz+p0CpCEaTyxAqkzPjXHK1ya0KdxUhhGg8S4j8iyS3Lgq0O
         2D9RNoI2E/dqrxK0kl0vIVRIPo8FIl2HWYAKorCso6+5P7A6qOejYQXrMi3SnyhhsgdN
         O+P38Ygoube0r5jgLDrdBSf4JK003qLs1rac/B7MBOmDy7S1muUWBg7aIGe3G05mv45s
         UibA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B5z0WBrh/BYYCHvUIIawnVVkGhzF2/2dcuB+5FV8icU=;
        b=ueYU1p0Vxk+OfjOJy4VW54/DL4YmLQbXUL1vW6aM1wQ9im1+zVRqXbKLYULPxnO0Th
         OFSNFGrTPjy5Hr+NT4XkbInU6J+bvSsV7nDUGNv4di8TM7NVupjzUDB1sapJej88dsxB
         ETT0L6w3YABBytv6knLANvyZ3NHARXnW1MJpELQLFp10QDpl2bBfNzcDTX5C4aAvuYXm
         nucXQLTSsjERAzu5Gy/aqDPodrkC7B8bCWDBoypSvZc8f3DibwvdowDttjDGpKg3Oee+
         IO4d0DMNoatdzK+4UXqcmU3rore+vsYqKnl+WHe6W7uKlvMn8rpIjKfEITwsYKuX6CRN
         /BAg==
X-Gm-Message-State: AOAM5318Xn9nZqNcSS70f0mTLnvDqQN0TGjSb809FTYwuDC1ocY7hAh2
        Tqd1oXHRjwJRZecyIs9pzfkoZe4Zpbo=
X-Google-Smtp-Source: ABdhPJzke1BkFrhoZLv3sDgDH8hPpHFfyyxhP4PJLb+EMGslHLQiFUrYb3dRzNamgAsCzZrgIwfIuw==
X-Received: by 2002:a17:902:d896:b0:15e:fb07:ba92 with SMTP id b22-20020a170902d89600b0015efb07ba92mr23648389plz.148.1652811738511;
        Tue, 17 May 2022 11:22:18 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x4-20020a17090ad68400b001d7dd00c231sm1998141pju.22.2022.05.17.11.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:22:18 -0700 (PDT)
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
Subject: [PATCH stable 4.19 2/3] mmc: block: Use generic_cmd6_time when modifying INAND_CMD38_ARG_EXT_CSD
Date:   Tue, 17 May 2022 11:22:10 -0700
Message-Id: <20220517182211.249775-3-f.fainelli@gmail.com>
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
index 630f3bcba56d..f7379c3473e1 100644
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

