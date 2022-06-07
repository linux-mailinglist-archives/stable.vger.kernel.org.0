Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA224541C9D
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356764AbiFGWCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383363AbiFGWBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:01:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733F21BE86;
        Tue,  7 Jun 2022 12:14:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E9F4B823AE;
        Tue,  7 Jun 2022 19:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E102C385A5;
        Tue,  7 Jun 2022 19:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629258;
        bh=/ntqIvYDdF2s30nMF1oZWhYOlujzI0rSlTDP7s02PiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g17p92NAUX9LA5FxqNlFRgik/HsuRYyPc5mWjCqoiWuLlRzM/BkvTsvVN/PJIZcRl
         qdUHI7SwCeskBcbfM9OU0AyNUi3ceukOHwXKHcdBwEv2x1R3gpK5Cpqv8BkZQwQZ/D
         5bD6ciskTnvRGZG2KVMPflYaMj5U24OOwScdBcn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 625/879] ARM: dts: lan966x: swap dma channels for crypto node
Date:   Tue,  7 Jun 2022 19:02:23 +0200
Message-Id: <20220607165020.990852785@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 8b4092fd0c1a0aaa985413c43b027f87dd457207 ]

The YAML binding (crypto/atmel,at91sam9g46-aes.yaml) mandates the order
of the channels. Swap them to pass devicetree validation.

Fixes: 290deaa10c50 ("ARM: dts: add DT for lan966 SoC and 2-port board pcb8291")
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Tested-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220502224127.2604333-2-michael@walle.cc
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/lan966x.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/lan966x.dtsi b/arch/arm/boot/dts/lan966x.dtsi
index 7d2869648050..5e9cbc8cdcbc 100644
--- a/arch/arm/boot/dts/lan966x.dtsi
+++ b/arch/arm/boot/dts/lan966x.dtsi
@@ -114,9 +114,9 @@
 			compatible = "atmel,at91sam9g46-aes";
 			reg = <0xe004c000 0x100>;
 			interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
-			dmas = <&dma0 AT91_XDMAC_DT_PERID(13)>,
-			       <&dma0 AT91_XDMAC_DT_PERID(12)>;
-			dma-names = "rx", "tx";
+			dmas = <&dma0 AT91_XDMAC_DT_PERID(12)>,
+			       <&dma0 AT91_XDMAC_DT_PERID(13)>;
+			dma-names = "tx", "rx";
 			clocks = <&nic_clk>;
 			clock-names = "aes_clk";
 		};
-- 
2.35.1



