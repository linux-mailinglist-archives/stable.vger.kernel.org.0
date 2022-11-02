Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B98615903
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiKBDDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiKBDCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:02:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895142315E
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:02:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26D8161729
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FB2C433C1;
        Wed,  2 Nov 2022 03:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358149;
        bh=lDIkfRgyBjqjJPmFXGxT3WN29RcDiAPSZod1ghkW/tI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zdHtXkDuKk6L8ktpP3NH//0oDKs1SU9tuUGJOs9fJMChu8IZ4Q84bFRdrpGU3YDe6
         EtGnEd7CD4irh9BVbE/ApTo6NGWhUHDuYVAhxRK8QkpKhmK+az5q/Z29d8RVzo1DTm
         F3+Gl++VtPPyV7JnBDHmAD7E7HESu5dLqkd7ORBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Siarhei Volkau <lis8215@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.15 042/132] pinctrl: Ingenic: JZ4755 bug fixes
Date:   Wed,  2 Nov 2022 03:32:28 +0100
Message-Id: <20221102022100.733293545@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Siarhei Volkau <lis8215@gmail.com>

commit 17747577bbcb496e1b1c4096d64c2fc1e7bc0fef upstream.

Fixes UART1 function bits and MMC groups typo.

For pins 0x97,0x99 function 0 is designated to PWM3/PWM5
respectively, function is 1 designated to the UART1.

Diff from v1:
 - sent separately
 - added tag Fixes

Cc: stable@vger.kernel.org
Fixes: b582b5a434d3 ("pinctrl: Ingenic: Add pinctrl driver for JZ4755.")
Tested-by: Siarhei Volkau <lis8215@gmail.com>
Signed-off-by: Siarhei Volkau <lis8215@gmail.com>
Link: https://lore.kernel.org/r/20221016153548.3024209-1-lis8215@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-ingenic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -643,7 +643,7 @@ static u8 jz4755_lcd_24bit_funcs[] = { 1
 static const struct group_desc jz4755_groups[] = {
 	INGENIC_PIN_GROUP("uart0-data", jz4755_uart0_data, 0),
 	INGENIC_PIN_GROUP("uart0-hwflow", jz4755_uart0_hwflow, 0),
-	INGENIC_PIN_GROUP("uart1-data", jz4755_uart1_data, 0),
+	INGENIC_PIN_GROUP("uart1-data", jz4755_uart1_data, 1),
 	INGENIC_PIN_GROUP("uart2-data", jz4755_uart2_data, 1),
 	INGENIC_PIN_GROUP("ssi-dt-b", jz4755_ssi_dt_b, 0),
 	INGENIC_PIN_GROUP("ssi-dt-f", jz4755_ssi_dt_f, 0),
@@ -697,7 +697,7 @@ static const char *jz4755_ssi_groups[] =
 	"ssi-ce1-b", "ssi-ce1-f",
 };
 static const char *jz4755_mmc0_groups[] = { "mmc0-1bit", "mmc0-4bit", };
-static const char *jz4755_mmc1_groups[] = { "mmc0-1bit", "mmc0-4bit", };
+static const char *jz4755_mmc1_groups[] = { "mmc1-1bit", "mmc1-4bit", };
 static const char *jz4755_i2c_groups[] = { "i2c-data", };
 static const char *jz4755_cim_groups[] = { "cim-data", };
 static const char *jz4755_lcd_groups[] = {


