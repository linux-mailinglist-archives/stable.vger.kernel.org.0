Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18B252AAE0
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352200AbiEQScf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236152AbiEQSc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:32:29 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0772517C9;
        Tue, 17 May 2022 11:32:22 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d17so18133785plg.0;
        Tue, 17 May 2022 11:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gl/4AJ7Cg2JSrI1J5T3voQUF9eM/BVXgo43onu7DnJA=;
        b=LXZPescd/0efMq7QxYUQswhy7KmAm7WXHyyuFnoBI0lupbX0iESYI7IQbrtEzw32iS
         vIZcfrafU49YDPEHFszrtKdQcgEGHTdzGBEkB8th3jHrhWMi6R670PvKvvePCxMa+/dW
         r0Q2I/WCRj2dhzRsyztJ3LgatscRVbJ4WNzZehs/CpCleaLoBdCiTJH3G42MLZKSlWkk
         JST9Ook+jMIFDR2wkjH/u5bYjiyAI2AKxs7k2HLbEwDUaCEQW692COjXBysd2Yq3lxgP
         HWCBZV+7vVOpkTqjp4Vmp+iwFRwrKHtDFW/Qtxcd5bhO31bz0Koz2W2BRx5cbrOj4kOj
         +qOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gl/4AJ7Cg2JSrI1J5T3voQUF9eM/BVXgo43onu7DnJA=;
        b=GsdUwLwd+EGeCf+GSSRGL3Y4MjqGuvmdASErbnwX1fcT5rk79hmeBW7rQnhTHQMCty
         tykDFIiFCOAdgy6uFdGmcst5iySJgiMKNIz9PL00Q6TuujLOls7FsAPd5N9Ng/bBldyE
         3wIyT0EiOYRaa+C1uTa9OjKQEHlc0YBXfv9unKTFhowIwEZRlmx66ulwEuXOcT6tksBg
         NnJ98A/IIBWrVtTMu+7of0VMXKPLhu1LdqPoeQdYBuD6I1qvYfD8w4ihvGQgJrRx1Roq
         UliSXb5rItfJeACTRDOmk5cAznV2x8N1TCUqwTRXH2iLl3Aj1XQhMS+Zook7F7+6Hml9
         +aAA==
X-Gm-Message-State: AOAM532EncCKjT/pMo71GQBpd9fSle2B5Nkz+UbC/YAc5rSVQSi3gJU6
        pBqW66tsmUXF7+7ODFgzaFtJWBBxYKI=
X-Google-Smtp-Source: ABdhPJytTFfVTyULaEC/jxTxxlyYjnNEqcirSiBZWV1z2SxVYBLNltoBCeSBkMtYYK1plvS5tHkaTg==
X-Received: by 2002:a17:903:244f:b0:15e:bb9a:3aa9 with SMTP id l15-20020a170903244f00b0015ebb9a3aa9mr23432797pls.78.1652812342038;
        Tue, 17 May 2022 11:32:22 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d26-20020a634f1a000000b003c619f3d086sm8950355pgb.2.2022.05.17.11.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:32:21 -0700 (PDT)
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
Subject: [PATCH stable 4.9 1/3] mmc: core: Specify timeouts for BKOPS and CACHE_FLUSH for eMMC
Date:   Tue, 17 May 2022 11:32:05 -0700
Message-Id: <20220517183207.258065-2-f.fainelli@gmail.com>
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

commit 24ed3bd01d6a844fd5e8a75f48d0a3d10ed71bf9 upstream

The timeout values used while waiting for a CMD6 for BKOPS or a CACHE_FLUSH
to complete, are not defined by the eMMC spec. However, a timeout of 10
minutes as is currently being used, is just silly for both of these cases.
Instead, let's specify more reasonable timeouts, 120s for BKOPS and 30s for
CACHE_FLUSH.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20200122142747.5690-2-ulf.hansson@linaro.org
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
[kamal: Drop mmc_run_bkops hunk, non-existent]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/mmc/core/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index f0fa6a799f7c..dfe55e9d729f 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -61,6 +61,8 @@
 /* The max erase timeout, used when host->max_busy_timeout isn't specified */
 #define MMC_ERASE_TIMEOUT_MS	(60 * 1000) /* 60 s */
 
+#define MMC_CACHE_FLUSH_TIMEOUT_MS     (30 * 1000) /* 30s */
+
 static const unsigned freqs[] = { 400000, 300000, 200000, 100000 };
 
 /*
@@ -2936,7 +2938,8 @@ int mmc_flush_cache(struct mmc_card *card)
 			(card->ext_csd.cache_size > 0) &&
 			(card->ext_csd.cache_ctrl & 1)) {
 		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-				EXT_CSD_FLUSH_CACHE, 1, 0);
+				EXT_CSD_FLUSH_CACHE, 1,
+				 MMC_CACHE_FLUSH_TIMEOUT_MS);
 		if (err)
 			pr_err("%s: cache flush error %d\n",
 					mmc_hostname(card->host), err);
-- 
2.25.1

