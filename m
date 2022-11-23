Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD28635694
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237823AbiKWJcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237794AbiKWJbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:31:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D350F98267
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:30:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7108F61B49
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6A4C433C1;
        Wed, 23 Nov 2022 09:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195824;
        bh=piWcSl0qjqaE+gCyLZKfMtR6AKFAfsFF7ZgBncUJQCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wm9fcoaIgjsayx2t7gcK2kL8iOcGc2C+N2FrmiapaFxhoKqa7gLaPck1KTxO/YfcO
         MVLetknfOXKzz7zs4R6XYPTOyQYRIx39u3tFM7X8mDiH/Nk32fBR0DG66wwkp4GVdh
         VPD8tMnATU5P5v6ntw5YVoLQMzpWYy0fTsWmZwH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mihai Sain <mihai.sain@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/181] ARM: dts: at91: sama7g5: fix signal name of pin PB2
Date:   Wed, 23 Nov 2022 09:50:06 +0100
Message-Id: <20221123084604.223102777@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mihai Sain <mihai.sain@microchip.com>

[ Upstream commit 2b4337c8409b4e9e5aed15c597e4031dd567bdd8 ]

The signal name of pin PB2 with function F is FLEXCOM11_IO1
as it is defined in the datasheet.

Fixes: 7540629e2fc7 ("ARM: dts: at91: add sama7g5 SoC DT and sama7g5-ek")
Signed-off-by: Mihai Sain <mihai.sain@microchip.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20221017083119.1643-1-mihai.sain@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sama7g5-pinfunc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sama7g5-pinfunc.h b/arch/arm/boot/dts/sama7g5-pinfunc.h
index 4eb30445d205..6e87f0d4b8fc 100644
--- a/arch/arm/boot/dts/sama7g5-pinfunc.h
+++ b/arch/arm/boot/dts/sama7g5-pinfunc.h
@@ -261,7 +261,7 @@
 #define PIN_PB2__FLEXCOM6_IO0		PINMUX_PIN(PIN_PB2, 2, 1)
 #define PIN_PB2__ADTRG			PINMUX_PIN(PIN_PB2, 3, 1)
 #define PIN_PB2__A20			PINMUX_PIN(PIN_PB2, 4, 1)
-#define PIN_PB2__FLEXCOM11_IO0		PINMUX_PIN(PIN_PB2, 6, 3)
+#define PIN_PB2__FLEXCOM11_IO1		PINMUX_PIN(PIN_PB2, 6, 3)
 #define PIN_PB3				35
 #define PIN_PB3__GPIO			PINMUX_PIN(PIN_PB3, 0, 0)
 #define PIN_PB3__RF1			PINMUX_PIN(PIN_PB3, 1, 1)
-- 
2.35.1



