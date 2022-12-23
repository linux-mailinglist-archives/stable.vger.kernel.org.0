Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A83654BF8
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 05:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiLWEY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 23:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiLWEY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 23:24:28 -0500
Received: from gw.atmark-techno.com (gw.atmark-techno.com [13.115.124.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1648124BCE
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 20:24:26 -0800 (PST)
Received: from gw.atmark-techno.com (localhost [127.0.0.1])
        by gw.atmark-techno.com (Postfix) with ESMTP id 9071F6010E
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 13:24:25 +0900 (JST)
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
        by gw.atmark-techno.com (Postfix) with ESMTPS id 7C1D46010D
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 13:24:24 +0900 (JST)
Received: by mail-pj1-f70.google.com with SMTP id r17-20020a17090aa09100b0021903e75f14so2005127pjp.9
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 20:24:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mExlhL7podYny/5Su2GhXq0PviBDirh1lFZQGtUWeyw=;
        b=h69tiEnYBPR7aAApGgqNnKM9Es/rOg0zrBpDHBsrtm5FhYnRHzQJxarBOnpsMCIFyo
         8diGHUj7J36djgHkJ+ytqLJynRFFhnfGBUnrwei2ycbR9iIj3WDEcngzAEUfi9GABjo0
         RNcfXJa3VjeTSguluLOplesLUc4Aaw8YGKB6YoKpdNZTcAqcEHcozZ8N4KIWdwabViRd
         9sXSbLRbWcdclcLlDh166RL19XSXU/OkwqINKxwyTQJGheB97xl7ef3J6yfPFzQfeozh
         zb0Y2UTWC0z2Yuzg3866JDAnP4PkFWshyH0fOc0KEiteHerZOlXTTJtlfa2VsUZymykS
         wsvw==
X-Gm-Message-State: AFqh2kogzVae4Jfm2cyQXYQ1l8TKUpS9LDDrd9dS8RKY1NZehQ31DLT5
        w8tgjb7trmlUPJN0XUN/5TQlCFuO3ua4To6NBSAERiKM8+Ay7OZ1ig460dLcfsLr7PGGuWjG5BD
        7aNL1hMwGnM12rdd1O14n
X-Received: by 2002:a05:6a21:3a81:b0:af:767a:a7e1 with SMTP id zv1-20020a056a213a8100b000af767aa7e1mr29379256pzb.23.1671769463576;
        Thu, 22 Dec 2022 20:24:23 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt1FlZ3C2VhMVo3r2Yd9v3knmgxG7GjVVoybR1hniJopWb0sU07FLDVGTOADDndnQLYyBIFEg==
X-Received: by 2002:a05:6a21:3a81:b0:af:767a:a7e1 with SMTP id zv1-20020a056a213a8100b000af767aa7e1mr29379229pzb.23.1671769463288;
        Thu, 22 Dec 2022 20:24:23 -0800 (PST)
Received: from pc-zest.atmarktech (103.131.189.35.bc.googleusercontent.com. [35.189.131.103])
        by smtp.gmail.com with ESMTPSA id c7-20020a63da07000000b004827ef5f0cdsm1459999pgh.50.2022.12.22.20.24.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Dec 2022 20:24:22 -0800 (PST)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.96)
        (envelope-from <martinet@pc-zest>)
        id 1p8ZbZ-00H7dA-2Q;
        Fri, 23 Dec 2022 13:24:21 +0900
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Daisuke Mizobuchi <mizo@atmark-techno.com>, stable@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Indan Zupancic <Indan.Zupancic@mep-info.com>,
        Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH 5.10 1/2] fsl_lpuart: Don't enable interrupts too early
Date:   Fri, 23 Dec 2022 13:23:53 +0900
Message-Id: <20221223042354.4080724-1-dominique.martinet@atmark-techno.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Indan Zupancic <Indan.Zupancic@mep-info.com>

[ Upstream commit 401fb66a355eb0f22096cf26864324f8e63c7d78 ]

If an irq is pending when devm_request_irq() is called, the irq
handler will cause a NULL pointer access because initialisation
is not done yet.

Fixes: 9d7ee0e28da59 ("tty: serial: lpuart: avoid report NULL interrupt")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Indan Zupancic <Indan.Zupancic@mep-info.com>
Link: https://lore.kernel.org/r/20220505114750.45423-1-Indan.Zupancic@mep-info.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[5.10 did not have lpuart_global_reset or anything after
uart_add_one_port(), so add the remove call in cleanup manually]
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
---
This was originally intended as a prerequirement to backport the patch
submitted in [1] for 5.10, but even with that part of the patch gone it
makes sense as a fix on its own.

[1] https://lkml.kernel.org/r/20221222114414.1886632-1-linux@rasmusvillemoes.dk

 drivers/tty/serial/fsl_lpuart.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 43aca5a2ef0f..223695947b65 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2586,6 +2586,7 @@ static int lpuart_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct lpuart_port *sport;
 	struct resource *res;
+	irq_handler_t handler;
 	int ret;
 
 	sport = devm_kzalloc(&pdev->dev, sizeof(*sport), GFP_KERNEL);
@@ -2658,17 +2659,12 @@ static int lpuart_probe(struct platform_device *pdev)
 
 	if (lpuart_is_32(sport)) {
 		lpuart_reg.cons = LPUART32_CONSOLE;
-		ret = devm_request_irq(&pdev->dev, sport->port.irq, lpuart32_int, 0,
-					DRIVER_NAME, sport);
+		handler = lpuart32_int;
 	} else {
 		lpuart_reg.cons = LPUART_CONSOLE;
-		ret = devm_request_irq(&pdev->dev, sport->port.irq, lpuart_int, 0,
-					DRIVER_NAME, sport);
+		handler = lpuart_int;
 	}
 
-	if (ret)
-		goto failed_irq_request;
-
 	ret = uart_get_rs485_mode(&sport->port);
 	if (ret)
 		goto failed_get_rs485;
@@ -2684,11 +2680,17 @@ static int lpuart_probe(struct platform_device *pdev)
 	if (ret)
 		goto failed_attach_port;
 
+	ret = devm_request_irq(&pdev->dev, sport->port.irq, handler, 0,
+				DRIVER_NAME, sport);
+	if (ret)
+		goto failed_irq_request;
+
 	return 0;
 
+failed_irq_request:
+	uart_remove_one_port(&lpuart_reg, &sport->port);
 failed_get_rs485:
 failed_attach_port:
-failed_irq_request:
 	lpuart_disable_clks(sport);
 	return ret;
 }
-- 
2.35.1


