Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D70B63DF52
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbiK3SqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbiK3Spu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:45:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DDF9897B
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:45:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B768661D70
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B73C433D6;
        Wed, 30 Nov 2022 18:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833941;
        bh=RsM9U6/xKbAefQV8+JmiwP1hFtWAvtolMARxW0onWKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VoJ3LYnfa+T+dFfJ++HXu+42Ewy8BEw97BML5EQwi5t8GO1DkuigaKsK+9se+jLXi
         UqiIs3eGX4qFS4UW8qv/dhfwTHJstoNL1p6UzHzHjIAAPMWRT4dl+nDZRy9fFnUES4
         sVGgHqNInNgxvrbVcfIUmAK0T/2PwfnYqyPB1mP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, nicolas.ferre@microchip.com,
        ludovic.desroches@microchip.com, alexandre.belloni@bootlin.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 070/289] ARM: dts: at91: sam9g20ek: enable udc vbus gpio pinctrl
Date:   Wed, 30 Nov 2022 19:20:55 +0100
Message-Id: <20221130180545.720282575@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit 40a2226e8bfacb79dd154dea68febeead9d847e9 ]

We set the PIOC to GPIO mode. This way the pin becomes an
input signal will be usable by the controller. Without
this change the udc on the 9g20ek does not work.

Cc: nicolas.ferre@microchip.com
Cc: ludovic.desroches@microchip.com
Cc: alexandre.belloni@bootlin.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: kernel@pengutronix.de
Fixes: 5cb4e73575e3 ("ARM: at91: add at91sam9g20ek boards dt support")
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20221114185923.1023249-3-m.grzeschik@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
index 60d61291f344..024af2db638e 100644
--- a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
@@ -39,6 +39,13 @@ pinctrl_pck0_as_mck: pck0_as_mck {
 
 				};
 
+				usb1 {
+					pinctrl_usb1_vbus_gpio: usb1_vbus_gpio {
+						atmel,pins =
+							<AT91_PIOC 5 AT91_PERIPH_GPIO AT91_PINCTRL_DEGLITCH>;	/* PC5 GPIO */
+					};
+				};
+
 				mmc0_slot1 {
 					pinctrl_board_mmc0_slot1: mmc0_slot1-board {
 						atmel,pins =
@@ -84,6 +91,8 @@ macb0: ethernet@fffc4000 {
 			};
 
 			usb1: gadget@fffa4000 {
+				pinctrl-0 = <&pinctrl_usb1_vbus_gpio>;
+				pinctrl-names = "default";
 				atmel,vbus-gpio = <&pioC 5 GPIO_ACTIVE_HIGH>;
 				status = "okay";
 			};
-- 
2.35.1



