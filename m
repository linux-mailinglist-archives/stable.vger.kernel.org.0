Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD48464F5A0
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 01:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiLQAKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 19:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbiLQAKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 19:10:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23AB7330F;
        Fri, 16 Dec 2022 16:10:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45558622CA;
        Sat, 17 Dec 2022 00:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F49C433D2;
        Sat, 17 Dec 2022 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671235809;
        bh=Q8LhydwN/2Cmac9zYzpeFES5p/hI/13oVgIuWXBb/wI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMUHsjMoJRkn3sY54QPyjzq9sesrTZJoiV0mXbTuJrr0y1AINOVr5VG5q1XMQc10S
         dd+uFNJZBPhKccZNbMv5ssSBHoPU9lkmiS+b71vz0vozrJ6CtAqKM4y3TKh7/ajyk1
         X24uow9WBhmwq5c3kiZGnXBUAizzWWy4sTCYKNFyEBV+0o+kUpt3unzuL/PXQzI8U9
         N5Bh44ayYNeEyvqbrd7K1M0TYV0GFeQYZz9uFWNvJHp5swv/DepYwEMtT+uiHPRUpY
         /+lqV4td8F3gPy9AGdKDdbcfy0VdfC1zTLekQc5yasIC31tx0qF+OTmL0709elVIM6
         XDtT9dIWnhChg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, wens@csie.org,
        samuel@sholland.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: [PATCH AUTOSEL 6.1 8/9] arm64: dts: allwinner: h616: Add USB nodes
Date:   Fri, 16 Dec 2022 19:09:35 -0500
Message-Id: <20221217000937.41115-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217000937.41115-1-sashal@kernel.org>
References: <20221217000937.41115-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit f40cf244c3feb4e1a442f8029b691add2c65b3ab ]

Add the nodes for the MUSB and the four USB host controllers to the SoC
.dtsi, along with the PHY node needed to bind all of them together.

EHCI/OHCI and MUSB are compatible to previous SoCs, but the PHY requires
some quirks (handled in the driver).

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20221031111358.3387297-6-andre.przywara@arm.com
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/allwinner/sun50i-h616.dtsi | 160 ++++++++++++++++++
 1 file changed, 160 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h616.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h616.dtsi
index 622a1f7d1641..74aed0d232a9 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h616.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h616.dtsi
@@ -504,6 +504,166 @@ mdio0: mdio {
 			};
 		};
 
+		usbotg: usb@5100000 {
+			compatible = "allwinner,sun50i-h616-musb",
+				     "allwinner,sun8i-h3-musb";
+			reg = <0x05100000 0x0400>;
+			clocks = <&ccu CLK_BUS_OTG>;
+			resets = <&ccu RST_BUS_OTG>;
+			interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "mc";
+			phys = <&usbphy 0>;
+			phy-names = "usb";
+			extcon = <&usbphy 0>;
+			status = "disabled";
+		};
+
+		usbphy: phy@5100400 {
+			compatible = "allwinner,sun50i-h616-usb-phy";
+			reg = <0x05100400 0x24>,
+			      <0x05101800 0x14>,
+			      <0x05200800 0x14>,
+			      <0x05310800 0x14>,
+			      <0x05311800 0x14>;
+			reg-names = "phy_ctrl",
+				    "pmu0",
+				    "pmu1",
+				    "pmu2",
+				    "pmu3";
+			clocks = <&ccu CLK_USB_PHY0>,
+				 <&ccu CLK_USB_PHY1>,
+				 <&ccu CLK_USB_PHY2>,
+				 <&ccu CLK_USB_PHY3>,
+				 <&ccu CLK_BUS_EHCI2>;
+			clock-names = "usb0_phy",
+				      "usb1_phy",
+				      "usb2_phy",
+				      "usb3_phy",
+				      "pmu2_clk";
+			resets = <&ccu RST_USB_PHY0>,
+				 <&ccu RST_USB_PHY1>,
+				 <&ccu RST_USB_PHY2>,
+				 <&ccu RST_USB_PHY3>;
+			reset-names = "usb0_reset",
+				      "usb1_reset",
+				      "usb2_reset",
+				      "usb3_reset";
+			status = "disabled";
+			#phy-cells = <1>;
+		};
+
+		ehci0: usb@5101000 {
+			compatible = "allwinner,sun50i-h616-ehci",
+				     "generic-ehci";
+			reg = <0x05101000 0x100>;
+			interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_OHCI0>,
+				 <&ccu CLK_BUS_EHCI0>,
+				 <&ccu CLK_USB_OHCI0>;
+			resets = <&ccu RST_BUS_OHCI0>,
+				 <&ccu RST_BUS_EHCI0>;
+			phys = <&usbphy 0>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
+		ohci0: usb@5101400 {
+			compatible = "allwinner,sun50i-h616-ohci",
+				     "generic-ohci";
+			reg = <0x05101400 0x100>;
+			interrupts = <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_OHCI0>,
+				 <&ccu CLK_USB_OHCI0>;
+			resets = <&ccu RST_BUS_OHCI0>;
+			phys = <&usbphy 0>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
+		ehci1: usb@5200000 {
+			compatible = "allwinner,sun50i-h616-ehci",
+				     "generic-ehci";
+			reg = <0x05200000 0x100>;
+			interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_OHCI1>,
+				 <&ccu CLK_BUS_EHCI1>,
+				 <&ccu CLK_USB_OHCI1>;
+			resets = <&ccu RST_BUS_OHCI1>,
+				 <&ccu RST_BUS_EHCI1>;
+			phys = <&usbphy 1>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
+		ohci1: usb@5200400 {
+			compatible = "allwinner,sun50i-h616-ohci",
+				     "generic-ohci";
+			reg = <0x05200400 0x100>;
+			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_OHCI1>,
+				 <&ccu CLK_USB_OHCI1>;
+			resets = <&ccu RST_BUS_OHCI1>;
+			phys = <&usbphy 1>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
+		ehci2: usb@5310000 {
+			compatible = "allwinner,sun50i-h616-ehci",
+				     "generic-ehci";
+			reg = <0x05310000 0x100>;
+			interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_OHCI2>,
+				 <&ccu CLK_BUS_EHCI2>,
+				 <&ccu CLK_USB_OHCI2>;
+			resets = <&ccu RST_BUS_OHCI2>,
+				 <&ccu RST_BUS_EHCI2>;
+			phys = <&usbphy 2>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
+		ohci2: usb@5310400 {
+			compatible = "allwinner,sun50i-h616-ohci",
+				     "generic-ohci";
+			reg = <0x05310400 0x100>;
+			interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_OHCI2>,
+				 <&ccu CLK_USB_OHCI2>;
+			resets = <&ccu RST_BUS_OHCI2>;
+			phys = <&usbphy 2>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
+		ehci3: usb@5311000 {
+			compatible = "allwinner,sun50i-h616-ehci",
+				     "generic-ehci";
+			reg = <0x05311000 0x100>;
+			interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_OHCI3>,
+				 <&ccu CLK_BUS_EHCI3>,
+				 <&ccu CLK_USB_OHCI3>;
+			resets = <&ccu RST_BUS_OHCI3>,
+				 <&ccu RST_BUS_EHCI3>;
+			phys = <&usbphy 3>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
+		ohci3: usb@5311400 {
+			compatible = "allwinner,sun50i-h616-ohci",
+				     "generic-ohci";
+			reg = <0x05311400 0x100>;
+			interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_OHCI3>,
+				 <&ccu CLK_USB_OHCI3>;
+			resets = <&ccu RST_BUS_OHCI3>;
+			phys = <&usbphy 3>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
 		rtc: rtc@7000000 {
 			compatible = "allwinner,sun50i-h616-rtc";
 			reg = <0x07000000 0x400>;
-- 
2.35.1

