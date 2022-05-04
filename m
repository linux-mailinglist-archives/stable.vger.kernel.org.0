Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E1651A93A
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355891AbiEDRMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356943AbiEDRJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFE9473A7;
        Wed,  4 May 2022 09:56:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A6E061794;
        Wed,  4 May 2022 16:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE42C385AA;
        Wed,  4 May 2022 16:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683398;
        bh=ND4TvuaQfIW/5AgPmtvCsaRACYMDAT08gszoo/ScmM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FNQeO3FfTIsJlZqbZfJSR1Lwl7NX2GqJLTBGmC8l4Ulut9xeAf13rIoT6D1zYwZi/
         gxnYEz8MT2U16YNtw9HuvtZbRazYGlWX8sYbxsCxrxHQy/v9lwtMYFKynKBXm7Psas
         1rl8bTLrUQUPNWJMkcMcVlMrWGBjxBOE5C7BjNEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 083/225] ARM: dts: at91: sama5d4_xplained: fix pinctrl phandle name
Date:   Wed,  4 May 2022 18:45:21 +0200
Message-Id: <20220504153118.509471836@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 5c8b49852910caffeebb1ce541fdd264ffc691b8 ]

Pinctrl phandle is for spi1 so rename it to reflect this.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20220331141323.194355-1-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sama5d4_xplained.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d4_xplained.dts b/arch/arm/boot/dts/at91-sama5d4_xplained.dts
index d241c24f0d83..accb92cfac44 100644
--- a/arch/arm/boot/dts/at91-sama5d4_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d4_xplained.dts
@@ -82,7 +82,7 @@ usart4: serial@fc010000 {
 
 			spi1: spi@fc018000 {
 				pinctrl-names = "default";
-				pinctrl-0 = <&pinctrl_spi0_cs>;
+				pinctrl-0 = <&pinctrl_spi1_cs>;
 				cs-gpios = <&pioB 21 0>;
 				status = "okay";
 			};
@@ -140,7 +140,7 @@ pinctrl_macb0_phy_irq: macb0_phy_irq_0 {
 						atmel,pins =
 							<AT91_PIOE 1 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;
 					};
-					pinctrl_spi0_cs: spi0_cs_default {
+					pinctrl_spi1_cs: spi1_cs_default {
 						atmel,pins =
 							<AT91_PIOB 21 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
 					};
-- 
2.35.1



