Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C75452AA22
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351954AbiEQSJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351889AbiEQSJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:09:29 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37222506E4;
        Tue, 17 May 2022 11:09:18 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y199so906334pfb.9;
        Tue, 17 May 2022 11:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vnguAOkbA//E+7XjgS8f0KtY2EXRL/p/+5JkRjLmM2s=;
        b=Q9H/qdYrEvvmVeIiE7g+0luXkL01xvb7EifyKIDQHPjDaLweRJj/0L8MOhOvyfF5GW
         60WIy2JFz4PUtCbxON5rdhPEhoX5HNUTcqgI8AZV+cqkCMGKeEwkQHvh1lIFKhDVvTwK
         HjyrxsCKho7mzkLdFTj5TPoPoRrh2x0zpE1Y8jtxej2TMWtrK2Twtd6rUi3VKI4sd9CP
         EAPKA4W25S7C4PR4csBq3bUvfgDWdMftibmF/fyQ3aNvgfs/qX/gER3BaxYzXCwM7/p0
         WY2NjPCV9nJwbXdZq7WiUsrDFmfPf0jCG56T0XJcjehF8KunZXImuu6Nib+YwHT98sCu
         6AcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vnguAOkbA//E+7XjgS8f0KtY2EXRL/p/+5JkRjLmM2s=;
        b=Ec3C+MFlRki0lgAISXIxrj/uBpE8z6L+28tU8PPALNCMpMe7um5pLAXujrqiOAxG3l
         wILmAPjkJX4y+ocU3pMhxDyS5ybrHWmPfqIwyNj8qk2/GoTThN1bQctpuyldc3hnkpEu
         sRkCvNuWyESA9xNtqfF8RbvgizpHRY8vWRBAS4ON7F5j816eGxJAgyyrNhk4wCGFca25
         bvS02v/WW85SExX71khK23jswQVkPfho33oeFmEAmsLMr/wYYbwGGU8OB3VnItwcW3IR
         GANef7PIVx5ao4uiyA4mieNRNI71dZuyVlJ/P1hwjUF5xlgJm7giynay1dTlbPSpJ1Fi
         YN+g==
X-Gm-Message-State: AOAM531+03aPGQ0LWDVkitX9VY/tzZAmTm/w/aluESPap8yAaxlfHqMm
        Y35HtSNWxeubO38v6dWfm1DJwv0AVIQ=
X-Google-Smtp-Source: ABdhPJxdU46P9h2b6klgo0rmcwK5Zb8vnEPfpro4fP3PguPGso+ErYlZdchF37ZNyabcmzi+7gU0rg==
X-Received: by 2002:a63:8543:0:b0:3ab:5afb:200c with SMTP id u64-20020a638543000000b003ab5afb200cmr20025432pgd.402.1652810957154;
        Tue, 17 May 2022 11:09:17 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i5-20020a056a00224500b0050dc7628160sm46854pfu.58.2022.05.17.11.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:09:16 -0700 (PDT)
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
Subject: [PATCH stable 5.4 2/3] mmc: block: Use generic_cmd6_time when modifying INAND_CMD38_ARG_EXT_CSD
Date:   Tue, 17 May 2022 11:09:10 -0700
Message-Id: <20220517180911.246016-3-f.fainelli@gmail.com>
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
index 362ad361d586..709f117fd577 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1126,7 +1126,7 @@ static void mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
 					 card->erase_arg == MMC_TRIM_ARG ?
 					 INAND_CMD38_ARG_TRIM :
 					 INAND_CMD38_ARG_ERASE,
-					 0);
+					 card->ext_csd.generic_cmd6_time);
 		}
 		if (!err)
 			err = mmc_erase(card, from, nr, card->erase_arg);
@@ -1168,7 +1168,7 @@ static void mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
 				 arg == MMC_SECURE_TRIM1_ARG ?
 				 INAND_CMD38_ARG_SECTRIM1 :
 				 INAND_CMD38_ARG_SECERASE,
-				 0);
+				 card->ext_csd.generic_cmd6_time);
 		if (err)
 			goto out_retry;
 	}
@@ -1186,7 +1186,7 @@ static void mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
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

