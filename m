Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F91B52AAA7
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352083AbiEQSW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352080AbiEQSWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:22:23 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F372C134;
        Tue, 17 May 2022 11:22:18 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id x12so17640380pgj.7;
        Tue, 17 May 2022 11:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iVU3h4f0WZUD4XgqWW0mRoZDtcwIOGH+1cszdDO/eKk=;
        b=VgJ7KHGa7GF8GJ1nWAGngQfXo0pUP0Ls5pZ+kEkVbByzzT3HXDz4Y3eAc1M+lNby5I
         AfMUIUw9cjFBo4dYK+gBynIzj4y6PL20CRPbM2fLAvM1MU+7tFut12Ok0Xwcu9eSDIy+
         QmPfFQa/SykOCqHuxmYQOZlsLGc1J6QgSzyoGNGW+jd3H+5ZhO5CtCkI75gEhkmXzlPC
         N7P7JhFjEqNTbmLFmNNTFX4ZJXweHjUOYIzx4OCZJGGc9OFvSHtaF+aGRFwFL04+Ew0M
         laljQGm28FpYqfPRsW2TGx6guKcsixJhsh9QpP4tF/KW8Pu2KPn7SpBCBaiXs3Hlw/K6
         DiGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iVU3h4f0WZUD4XgqWW0mRoZDtcwIOGH+1cszdDO/eKk=;
        b=eW6OZVc/J+su8o7oPoEPK7YotCFofGskxHMY6jO6lveU90PpBIFKeayJ8XXpj0lFZg
         4roZOPoa8jrtpKbLB0irtGeQGTMaCdqk8fjFurmmZnQS9CWDfUs1D9eWfd2q1gmzAGzR
         A5EQtoDCsxSg6SPWf1X56taoZc2P+xDZ9rmCdfLd2COAcwvFFTe7jM1kWN2QrnKfP577
         nek3ohXIv1ZJjpZblK14WdNiGAmgcgzyNgE0i2kfzA70iByFlCxxY29IvndjEuca5Q4u
         Vxf9i2THnJMDgOEwrO7dSHjrAvuRFVqEneEeQ2CX/flFGeUDB1fbLhyAj1Gy34NmQ7cW
         j3pw==
X-Gm-Message-State: AOAM532/5ExwXBcoqGzfREHxuKDTjy2W7apfg6ne8+wKY3XT07bLrEdx
        5Cba4Cc4ELH6jxqywVuZaMtvtGAH55k=
X-Google-Smtp-Source: ABdhPJwa3FDrdwTi3pbvAyMPp8xl9lnAKpXXkHdPSPjiZrKHcEq5Vl7UqJA8/5WyJYWSJ6Kji1Pw3w==
X-Received: by 2002:a63:8a4a:0:b0:3ab:25b9:5c2 with SMTP id y71-20020a638a4a000000b003ab25b905c2mr20797242pgd.213.1652811737213;
        Tue, 17 May 2022 11:22:17 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x4-20020a17090ad68400b001d7dd00c231sm1998141pju.22.2022.05.17.11.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:22:16 -0700 (PDT)
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
Subject: [PATCH stable 4.19 1/3] mmc: core: Specify timeouts for BKOPS and CACHE_FLUSH for eMMC
Date:   Tue, 17 May 2022 11:22:09 -0700
Message-Id: <20220517182211.249775-2-f.fainelli@gmail.com>
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

commit 24ed3bd01d6a844fd5e8a75f48d0a3d10ed71bf9 upstream

The timeout values used while waiting for a CMD6 for BKOPS or a CACHE_FLUSH
to complete, are not defined by the eMMC spec. However, a timeout of 10
minutes as is currently being used, is just silly for both of these cases.
Instead, let's specify more reasonable timeouts, 120s for BKOPS and 30s for
CACHE_FLUSH.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20200122142747.5690-2-ulf.hansson@linaro.org
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/mmc/core/mmc_ops.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 334678707deb..3e10023cf485 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -23,7 +23,9 @@
 #include "host.h"
 #include "mmc_ops.h"
 
-#define MMC_OPS_TIMEOUT_MS	(10 * 60 * 1000) /* 10 minute timeout */
+#define MMC_OPS_TIMEOUT_MS		(10 * 60 * 1000) /* 10min*/
+#define MMC_BKOPS_TIMEOUT_MS		(120 * 1000) /* 120s */
+#define MMC_CACHE_FLUSH_TIMEOUT_MS	(30 * 1000) /* 30s */
 
 static const u8 tuning_blk_pattern_4bit[] = {
 	0xff, 0x0f, 0xff, 0x00, 0xff, 0xcc, 0xc3, 0xcc,
@@ -986,7 +988,7 @@ void mmc_start_bkops(struct mmc_card *card, bool from_exception)
 	mmc_retune_hold(card->host);
 
 	err = __mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-			EXT_CSD_BKOPS_START, 1, timeout, 0,
+			EXT_CSD_BKOPS_START, 1, MMC_BKOPS_TIMEOUT_MS, 0,
 			use_busy_signal, true, false);
 	if (err) {
 		pr_warn("%s: Error %d starting bkops\n",
@@ -1016,7 +1018,8 @@ int mmc_flush_cache(struct mmc_card *card)
 
 	if (mmc_cache_enabled(card->host)) {
 		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-				EXT_CSD_FLUSH_CACHE, 1, 0);
+				 EXT_CSD_FLUSH_CACHE, 1,
+				 MMC_CACHE_FLUSH_TIMEOUT_MS);
 		if (err)
 			pr_err("%s: cache flush error %d\n",
 					mmc_hostname(card->host), err);
-- 
2.25.1

