Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1566000BF
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 17:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiJPPgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 11:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiJPPgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 11:36:42 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5357D38A28;
        Sun, 16 Oct 2022 08:36:39 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id u21so12878577edi.9;
        Sun, 16 Oct 2022 08:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=F1OBWkds0Pt2bQp3eyvH72hH//WSRMxDqTTcvyzOiTY=;
        b=FShg92RLlNiJ5TafP86/L9RhuD/LgC6/Ji+XUPcUpnDAG1GL4zom52xl/dwfgyFcYY
         66tf/fV19lCdjnfc6PXE3RYENXKoEuYxEFo2K6z0aK8wAiyZqWPZU5EmAznoOACigRp2
         lbxWGkoMPo5M5EpjgFr3jjnblUKX4lIzZoHpUz18u5sUZAXKjadlPtN7/HaGzD98jmKv
         gtDwz+WBkGfUPm/qv1vUoJL13R46wq8X3TTHhBP3YTF1fDYOWfnznUi0nErrg5iRAVxY
         N2nKJys5wQuZlpNvA6KH/Jxr0IwaH6zdqVOxFp7E+f39t7SFwLvSa+T/rV9J48v5v0c/
         Zavw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F1OBWkds0Pt2bQp3eyvH72hH//WSRMxDqTTcvyzOiTY=;
        b=sh1IoDhbUg+y+LMiyHiZYmoE2qaPbpfR3zh1XSPCInSmumBbm1nV8rnB4ZWItYM790
         onD/iEJ6jQgVVERlVUZNmtRTVlMLcSf/4vlQ6hsbxb+UNbVnE3sq+mbKx/ZjOiSBogJB
         pnpu83X5Z2tz+OtpBfPUEm0opXG0euoH8r51Ydp6T9EGC4+A7tdSY8TEjdSwfqwWHvUd
         QwUxH2HMdH2yymNqsuxHpm/bSjHuuNg752c1SCU5YNl9IwDqLBqBww3WpW3dVsxGTCqp
         c8C25Q2Y4GUztNiOnc7XUjYXubkYVTftBoFlLK2h6lUpBZ1oA1Wrv9SKqL/pD8S+wJpx
         P5Jw==
X-Gm-Message-State: ACrzQf0y1D9Iuk/TgnQ0VlJeU62rsRFxsEdEYcZVdwvyCPQW9D8aWTAR
        5lPIqBYSadMTo7xZwR00AIU4rfaZ8USqxA==
X-Google-Smtp-Source: AMsMyM61U3+jI8MWEihfJMx26dttGUB6RmOg49g+TvtQpDSAzgmH6Wv6elQvQNHBSIh9Cn88UzN2HQ==
X-Received: by 2002:a05:6402:f96:b0:459:4180:6cf4 with SMTP id eh22-20020a0564020f9600b0045941806cf4mr6565731edb.64.1665934597066;
        Sun, 16 Oct 2022 08:36:37 -0700 (PDT)
Received: from hp-power-15.localdomain (mm-39-7-212-37.vitebsk.dynamic.pppoe.byfly.by. [37.212.7.39])
        by smtp.gmail.com with ESMTPSA id y16-20020a056402359000b004589da5e5cesm5758781edc.41.2022.10.16.08.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 08:36:36 -0700 (PDT)
From:   Siarhei Volkau <lis8215@gmail.com>
Cc:     stable@vger.kernel.org, Siarhei Volkau <lis8215@gmail.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-mips@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] pinctrl: Ingenic: JZ4755 bug fixes
Date:   Sun, 16 Oct 2022 18:35:48 +0300
Message-Id: <20221016153548.3024209-1-lis8215@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fixes UART1 function bits and MMC groups typo.

For pins 0x97,0x99 function 0 is designated to PWM3/PWM5
respectively, function is 1 designated to the UART1.

Diff from v1:
 - sent separately
 - added tag Fixes

Fixes: b582b5a434d3 ("pinctrl: Ingenic: Add pinctrl driver for JZ4755.")
Tested-by: Siarhei Volkau <lis8215@gmail.com>
Signed-off-by: Siarhei Volkau <lis8215@gmail.com>
---
 drivers/pinctrl/pinctrl-ingenic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index 3a9ee9c8a..2991fe0bb 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -667,7 +667,7 @@ static u8 jz4755_lcd_24bit_funcs[] = { 1, 1, 1, 1, 0, 0, };
 static const struct group_desc jz4755_groups[] = {
 	INGENIC_PIN_GROUP("uart0-data", jz4755_uart0_data, 0),
 	INGENIC_PIN_GROUP("uart0-hwflow", jz4755_uart0_hwflow, 0),
-	INGENIC_PIN_GROUP("uart1-data", jz4755_uart1_data, 0),
+	INGENIC_PIN_GROUP("uart1-data", jz4755_uart1_data, 1),
 	INGENIC_PIN_GROUP("uart2-data", jz4755_uart2_data, 1),
 	INGENIC_PIN_GROUP("ssi-dt-b", jz4755_ssi_dt_b, 0),
 	INGENIC_PIN_GROUP("ssi-dt-f", jz4755_ssi_dt_f, 0),
@@ -721,7 +721,7 @@ static const char *jz4755_ssi_groups[] = {
 	"ssi-ce1-b", "ssi-ce1-f",
 };
 static const char *jz4755_mmc0_groups[] = { "mmc0-1bit", "mmc0-4bit", };
-static const char *jz4755_mmc1_groups[] = { "mmc0-1bit", "mmc0-4bit", };
+static const char *jz4755_mmc1_groups[] = { "mmc1-1bit", "mmc1-4bit", };
 static const char *jz4755_i2c_groups[] = { "i2c-data", };
 static const char *jz4755_cim_groups[] = { "cim-data", };
 static const char *jz4755_lcd_groups[] = {
-- 
2.36.1

