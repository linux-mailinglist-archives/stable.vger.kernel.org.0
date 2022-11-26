Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7080639571
	for <lists+stable@lfdr.de>; Sat, 26 Nov 2022 11:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiKZKmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Nov 2022 05:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiKZKmk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Nov 2022 05:42:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D522614;
        Sat, 26 Nov 2022 02:42:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CCC4B818C4;
        Sat, 26 Nov 2022 10:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27233C433D6;
        Sat, 26 Nov 2022 10:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669459352;
        bh=fWMxD58JADFyYLyysuOQ18clIZDcMLrElGT5sCUeUIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zmecmdl0PODejR6zn7LBbzfNeV3vw0UXIyolvfDUTNd6jsRm5LptjmEbHpwBso16S
         hhWweZ9vr2WmpOU9TOQ8NfTrEZywzkkp+pjLqalGAGcs2+niZy6F1cmiA0ixxm8MXS
         yFypY9vYJt7WcXzycp1E60pYDq3vvLdYDy16ZmVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.0.10
Date:   Sat, 26 Nov 2022 11:20:51 +0100
Message-Id: <166945805112179@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <166945805116240@kroah.com>
References: <166945805116240@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/driver-api/miscellaneous.rst b/Documentation/driver-api/miscellaneous.rst
index 304ffb146cf9..4a5104a368ac 100644
--- a/Documentation/driver-api/miscellaneous.rst
+++ b/Documentation/driver-api/miscellaneous.rst
@@ -16,12 +16,11 @@ Parallel Port Devices
 16x50 UART Driver
 =================
 
-.. kernel-doc:: drivers/tty/serial/serial_core.c
-   :export:
-
 .. kernel-doc:: drivers/tty/serial/8250/8250_core.c
    :export:
 
+See serial/driver.rst for related APIs.
+
 Pulse-Width Modulation (PWM)
 ============================
 
diff --git a/Documentation/process/code-of-conduct-interpretation.rst b/Documentation/process/code-of-conduct-interpretation.rst
index 4f8a06b00f60..43da2cc2e3b9 100644
--- a/Documentation/process/code-of-conduct-interpretation.rst
+++ b/Documentation/process/code-of-conduct-interpretation.rst
@@ -51,7 +51,7 @@ the Technical Advisory Board (TAB) or other maintainers if you're
 uncertain how to handle situations that come up.  It will not be
 considered a violation report unless you want it to be.  If you are
 uncertain about approaching the TAB or any other maintainers, please
-reach out to our conflict mediator, Joanna Lee <joanna.lee@gesmer.com>.
+reach out to our conflict mediator, Joanna Lee <jlee@linuxfoundation.org>.
 
 In the end, "be kind to each other" is really what the end goal is for
 everybody.  We know everyone is human and we all fail at times, but the
diff --git a/Makefile b/Makefile
index a234f16783ed..4f7da26fef78 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 0
-SUBLEVEL = 9
+SUBLEVEL = 10
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 29148285f9fc..1dc3bfac30b6 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1270,10 +1270,10 @@ dma_apbh: dma-apbh@33000000 {
 			clocks = <&clks IMX7D_NAND_USDHC_BUS_RAWNAND_CLK>;
 		};
 
-		gpmi: nand-controller@33002000{
+		gpmi: nand-controller@33002000 {
 			compatible = "fsl,imx7d-gpmi-nand";
 			#address-cells = <1>;
-			#size-cells = <1>;
+			#size-cells = <0>;
 			reg = <0x33002000 0x2000>, <0x33004000 0x4000>;
 			reg-names = "gpmi-nand", "bch";
 			interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
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
diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
index ffed4d949042..e4904faf1753 100644
--- a/arch/arm/mach-at91/pm_suspend.S
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -169,10 +169,15 @@ sr_ena_2:
 	cmp	tmp1, #UDDRC_STAT_SELFREF_TYPE_SW
 	bne	sr_ena_2
 
-	/* Put DDR PHY's DLL in bypass mode for non-backup modes. */
+	/* Disable DX DLLs for non-backup modes. */
 	cmp	r7, #AT91_PM_BACKUP
 	beq	sr_ena_3
 
+	/* Do not soft reset the AC DLL. */
+	ldr	tmp1, [r3, DDR3PHY_ACDLLCR]
+	bic	tmp1, tmp1, DDR3PHY_ACDLLCR_DLLSRST
+	str	tmp1, [r3, DDR3PHY_ACDLLCR]
+
 	/* Disable DX DLLs. */
 	ldr	tmp1, [r3, #DDR3PHY_DX0DLLCR]
 	orr	tmp1, tmp1, #DDR3PHY_DXDLLCR_DLLDIS
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml-mba8mx.dts b/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml-mba8mx.dts
index 7e0aeb2db305..a0aeac619929 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml-mba8mx.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml-mba8mx.dts
@@ -34,11 +34,25 @@ reg_usdhc2_vmmc: regulator-vmmc {
 		off-on-delay-us = <12000>;
 	};
 
-	extcon_usbotg1: extcon-usbotg1 {
-		compatible = "linux,extcon-usb-gpio";
+	connector {
+		compatible = "gpio-usb-b-connector", "usb-b-connector";
+		type = "micro";
+		label = "X19";
 		pinctrl-names = "default";
-		pinctrl-0 = <&pinctrl_usb1_extcon>;
-		id-gpio = <&gpio1 10 GPIO_ACTIVE_HIGH>;
+		pinctrl-0 = <&pinctrl_usb1_connector>;
+		id-gpios = <&gpio1 10 GPIO_ACTIVE_HIGH>;
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				reg = <0>;
+				usb_dr_connector: endpoint {
+					remote-endpoint = <&usb1_drd_sw>;
+				};
+			};
+		};
 	};
 };
 
@@ -105,13 +119,19 @@ &usbotg1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_usbotg1>;
 	dr_mode = "otg";
-	extcon = <&extcon_usbotg1>;
 	srp-disable;
 	hnp-disable;
 	adp-disable;
 	power-active-high;
 	over-current-active-low;
+	usb-role-switch;
 	status = "okay";
+
+	port {
+		usb1_drd_sw: endpoint {
+			remote-endpoint = <&usb_dr_connector>;
+		};
+	};
 };
 
 &usbotg2 {
@@ -231,7 +251,7 @@ pinctrl_usbotg1: usbotg1grp {
 			   <MX8MM_IOMUXC_GPIO1_IO13_USB1_OTG_OC		0x84>;
 	};
 
-	pinctrl_usb1_extcon: usb1-extcongrp {
+	pinctrl_usb1_connector: usb1-connectorgrp {
 		fsl,pins = <MX8MM_IOMUXC_GPIO1_IO10_GPIO1_IO10		0x1c0>;
 	};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index dabd94dc30c4..50ef92915c67 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -1244,10 +1244,10 @@ dma_apbh: dma-controller@33000000 {
 			clocks = <&clk IMX8MM_CLK_NAND_USDHC_BUS_RAWNAND_CLK>;
 		};
 
-		gpmi: nand-controller@33002000{
+		gpmi: nand-controller@33002000 {
 			compatible = "fsl,imx8mm-gpmi-nand", "fsl,imx7d-gpmi-nand";
 			#address-cells = <1>;
-			#size-cells = <1>;
+			#size-cells = <0>;
 			reg = <0x33002000 0x2000>, <0x33004000 0x4000>;
 			reg-names = "gpmi-nand", "bch";
 			interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mn.dtsi b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
index ad0b99adf691..67b554ba690c 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -1102,7 +1102,7 @@ dma_apbh: dma-controller@33000000 {
 		gpmi: nand-controller@33002000 {
 			compatible = "fsl,imx8mn-gpmi-nand", "fsl,imx7d-gpmi-nand";
 			#address-cells = <1>;
-			#size-cells = <1>;
+			#size-cells = <0>;
 			reg = <0x33002000 0x2000>, <0x33004000 0x4000>;
 			reg-names = "gpmi-nand", "bch";
 			interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm64/boot/dts/freescale/imx93-pinfunc.h b/arch/arm64/boot/dts/freescale/imx93-pinfunc.h
old mode 100755
new mode 100644
diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index b9bf43215ada..79351c6157ea 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -668,7 +668,7 @@ watchdog: watchdog@b017000 {
 
 		apcs_glb: mailbox@b111000 {
 			compatible = "qcom,ipq8074-apcs-apps-global";
-			reg = <0x0b111000 0x6000>;
+			reg = <0x0b111000 0x1000>;
 
 			#clock-cells = <1>;
 			#mbox-cells = <1>;
diff --git a/arch/arm64/boot/dts/qcom/sa8155p-adp.dts b/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
index ba547ca9fc6b..ddb9cb182152 100644
--- a/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
+++ b/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
@@ -43,7 +43,6 @@ vreg_s4a_1p8: smps4 {
 
 		regulator-always-on;
 		regulator-boot-on;
-		regulator-allow-set-load;
 
 		vin-supply = <&vreg_3p3>;
 	};
@@ -137,6 +136,9 @@ vreg_l5a_0p88: ldo5 {
 			regulator-max-microvolt = <880000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l7a_1p8: ldo7 {
@@ -152,6 +154,9 @@ vreg_l10a_2p96: ldo10 {
 			regulator-max-microvolt = <2960000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l11a_0p8: ldo11 {
@@ -258,6 +263,9 @@ vreg_l5c_1p2: ldo5 {
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l7c_1p8: ldo7 {
@@ -273,6 +281,9 @@ vreg_l8c_1p2: ldo8 {
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l10c_3p3: ldo10 {
diff --git a/arch/arm64/boot/dts/qcom/sa8295p-adp.dts b/arch/arm64/boot/dts/qcom/sa8295p-adp.dts
index ca5f5ad32ce5..5b16ac76fefb 100644
--- a/arch/arm64/boot/dts/qcom/sa8295p-adp.dts
+++ b/arch/arm64/boot/dts/qcom/sa8295p-adp.dts
@@ -83,6 +83,9 @@ vreg_l3c: ldo3 {
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l4c: ldo4 {
@@ -98,6 +101,9 @@ vreg_l6c: ldo6 {
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l7c: ldo7 {
@@ -113,6 +119,9 @@ vreg_l10c: ldo10 {
 			regulator-max-microvolt = <2504000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l17c: ldo17 {
@@ -121,6 +130,9 @@ vreg_l17c: ldo17 {
 			regulator-max-microvolt = <2504000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 	};
 
diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 51ed691075ad..b3c3844f97a0 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2177,7 +2177,8 @@ lpasscc: lpasscc@3000000 {
 
 		lpass_audiocc: clock-controller@3300000 {
 			compatible = "qcom,sc7280-lpassaudiocc";
-			reg = <0 0x03300000 0 0x30000>;
+			reg = <0 0x03300000 0 0x30000>,
+			      <0 0x032a9000 0 0x1000>;
 			clocks = <&rpmhcc RPMH_CXO_CLK>,
 			       <&lpass_aon LPASS_AON_CC_MAIN_RCG_CLK_SRC>;
 			clock-names = "bi_tcxo", "lpass_aon_cc_main_rcg_clk_src";
diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
index 6792e88b2c6c..a3796502d425 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
@@ -124,6 +124,9 @@ vreg_l7c: ldo7 {
 			regulator-max-microvolt = <2504000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l13c: ldo13 {
@@ -146,6 +149,9 @@ vreg_l3d: ldo3 {
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l4d: ldo4 {
diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 49ea8b5612fc..6d82dea3675b 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -885,13 +885,13 @@ ufs_mem_hc: ufs@1d84000 {
 
 		ufs_mem_phy: phy@1d87000 {
 			compatible = "qcom,sc8280xp-qmp-ufs-phy";
-			reg = <0 0x01d87000 0 0xe10>;
+			reg = <0 0x01d87000 0 0x1c8>;
 			#address-cells = <2>;
 			#size-cells = <2>;
 			ranges;
 			clock-names = "ref",
 				      "ref_aux";
-			clocks = <&rpmhcc RPMH_CXO_CLK>,
+			clocks = <&gcc GCC_UFS_REF_CLKREF_CLK>,
 				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
 
 			resets = <&ufs_mem_hc 0>;
@@ -953,13 +953,13 @@ ufs_card_hc: ufs@1da4000 {
 
 		ufs_card_phy: phy@1da7000 {
 			compatible = "qcom,sc8280xp-qmp-ufs-phy";
-			reg = <0 0x01da7000 0 0xe10>;
+			reg = <0 0x01da7000 0 0x1c8>;
 			#address-cells = <2>;
 			#size-cells = <2>;
 			ranges;
 			clock-names = "ref",
 				      "ref_aux";
-			clocks = <&gcc GCC_UFS_1_CARD_CLKREF_CLK>,
+			clocks = <&gcc GCC_UFS_REF_CLKREF_CLK>,
 				 <&gcc GCC_UFS_CARD_PHY_AUX_CLK>;
 
 			resets = <&ufs_card_hc 0>;
@@ -1181,26 +1181,16 @@ usb_0_qmpphy: phy-wrapper@88ec000 {
 			usb_0_ssphy: usb3-phy@88eb400 {
 				reg = <0 0x088eb400 0 0x100>,
 				      <0 0x088eb600 0 0x3ec>,
-				      <0 0x088ec400 0 0x1f0>,
+				      <0 0x088ec400 0 0x364>,
 				      <0 0x088eba00 0 0x100>,
 				      <0 0x088ebc00 0 0x3ec>,
-				      <0 0x088ec700 0 0x64>;
+				      <0 0x088ec200 0 0x18>;
 				#phy-cells = <0>;
 				#clock-cells = <0>;
 				clocks = <&gcc GCC_USB3_PRIM_PHY_PIPE_CLK>;
 				clock-names = "pipe0";
 				clock-output-names = "usb0_phy_pipe_clk_src";
 			};
-
-			usb_0_dpphy: dp-phy@88ed200 {
-				reg = <0 0x088ed200 0 0x200>,
-				      <0 0x088ed400 0 0x200>,
-				      <0 0x088eda00 0 0x200>,
-				      <0 0x088ea600 0 0x200>,
-				      <0 0x088ea800 0 0x200>;
-				#clock-cells = <1>;
-				#phy-cells = <0>;
-			};
 		};
 
 		usb_1_hsphy: phy@8902000 {
@@ -1242,8 +1232,8 @@ usb_1_qmpphy: phy-wrapper@8904000 {
 
 			usb_1_ssphy: usb3-phy@8903400 {
 				reg = <0 0x08903400 0 0x100>,
-				      <0 0x08903c00 0 0x3ec>,
-				      <0 0x08904400 0 0x1f0>,
+				      <0 0x08903600 0 0x3ec>,
+				      <0 0x08904400 0 0x364>,
 				      <0 0x08903a00 0 0x100>,
 				      <0 0x08903c00 0 0x3ec>,
 				      <0 0x08904200 0 0x18>;
@@ -1253,16 +1243,6 @@ usb_1_ssphy: usb3-phy@8903400 {
 				clock-names = "pipe0";
 				clock-output-names = "usb1_phy_pipe_clk_src";
 			};
-
-			usb_1_dpphy: dp-phy@8904200 {
-				reg = <0 0x08904200 0 0x200>,
-				      <0 0x08904400 0 0x200>,
-				      <0 0x08904a00 0 0x200>,
-				      <0 0x08904600 0 0x200>,
-				      <0 0x08904800 0 0x200>;
-				#clock-cells = <1>;
-				#phy-cells = <0>;
-			};
 		};
 
 		system-cache-controller@9200000 {
diff --git a/arch/arm64/boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi b/arch/arm64/boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi
index 014fe3a31548..fb6e5a140c9f 100644
--- a/arch/arm64/boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi
@@ -348,6 +348,9 @@ vreg_l6c_2p9: ldo6 {
 			regulator-max-microvolt = <2960000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l7c_3p0: ldo7 {
@@ -367,6 +370,9 @@ vreg_l9c_2p9: ldo9 {
 			regulator-max-microvolt = <2960000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l10c_3p3: ldo10 {
diff --git a/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi b/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
index 549e0a2aa9fe..5428aab3058d 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
@@ -317,6 +317,9 @@ vreg_l6c_2p9: ldo6 {
 			regulator-max-microvolt = <2960000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l7c_2p85: ldo7 {
@@ -339,6 +342,9 @@ vreg_l9c_2p9: ldo9 {
 			regulator-max-microvolt = <2960000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l10c_3p3: ldo10 {
diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index bc773e210023..052b4dbc1ee4 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -334,6 +334,7 @@ CLUSTER_SLEEP_0: cluster-sleep-0 {
 				exit-latency-us = <6562>;
 				min-residency-us = <9987>;
 				local-timer-stop;
+				status = "disabled";
 			};
 		};
 	};
diff --git a/arch/arm64/boot/dts/qcom/sm8350-hdk.dts b/arch/arm64/boot/dts/qcom/sm8350-hdk.dts
index 0fcf5bd88fc7..69ae6503c2f6 100644
--- a/arch/arm64/boot/dts/qcom/sm8350-hdk.dts
+++ b/arch/arm64/boot/dts/qcom/sm8350-hdk.dts
@@ -107,6 +107,9 @@ vreg_l5b_0p88: ldo5 {
 			regulator-max-microvolt = <888000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l6b_1p2: ldo6 {
@@ -115,6 +118,9 @@ vreg_l6b_1p2: ldo6 {
 			regulator-max-microvolt = <1208000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l7b_2p96: ldo7 {
@@ -123,6 +129,9 @@ vreg_l7b_2p96: ldo7 {
 			regulator-max-microvolt = <2504000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l9b_1p2: ldo9 {
@@ -131,6 +140,9 @@ vreg_l9b_1p2: ldo9 {
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 	};
 
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index abc418650fec..65e53ef5a396 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -41,7 +41,7 @@
 	(((midr) & MIDR_IMPLEMENTOR_MASK) >> MIDR_IMPLEMENTOR_SHIFT)
 
 #define MIDR_CPU_MODEL(imp, partnum) \
-	(((imp)			<< MIDR_IMPLEMENTOR_SHIFT) | \
+	((_AT(u32, imp)		<< MIDR_IMPLEMENTOR_SHIFT) | \
 	(0xf			<< MIDR_ARCHITECTURE_SHIFT) | \
 	((partnum)		<< MIDR_PARTNUM_SHIFT))
 
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index b5df82aa99e6..d78e69293d12 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -863,12 +863,12 @@ static inline bool pte_user_accessible_page(pte_t pte)
 
 static inline bool pmd_user_accessible_page(pmd_t pmd)
 {
-	return pmd_present(pmd) && (pmd_user(pmd) || pmd_user_exec(pmd));
+	return pmd_leaf(pmd) && (pmd_user(pmd) || pmd_user_exec(pmd));
 }
 
 static inline bool pud_user_accessible_page(pud_t pud)
 {
-	return pud_present(pud) && pud_user(pud);
+	return pud_leaf(pud) && pud_user(pud);
 }
 #endif
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index eb489302c28a..e8de94dd5a60 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -539,7 +539,7 @@ static void __init map_mem(pgd_t *pgdp)
 	 */
 	BUILD_BUG_ON(pgd_index(direct_map_end - 1) == pgd_index(direct_map_end));
 
-	if (can_set_direct_map() || IS_ENABLED(CONFIG_KFENCE))
+	if (can_set_direct_map())
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	/*
@@ -1551,11 +1551,7 @@ int arch_add_memory(int nid, u64 start, u64 size,
 
 	VM_BUG_ON(!mhp_range_allowed(start, size, true));
 
-	/*
-	 * KFENCE requires linear map to be mapped at page granularity, so that
-	 * it is possible to protect/unprotect single pages in the KFENCE pool.
-	 */
-	if (can_set_direct_map() || IS_ENABLED(CONFIG_KFENCE))
+	if (can_set_direct_map())
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	__create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 64e985eaa52d..5922178d7a06 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -21,7 +21,13 @@ bool rodata_full __ro_after_init = IS_ENABLED(CONFIG_RODATA_FULL_DEFAULT_ENABLED
 
 bool can_set_direct_map(void)
 {
-	return rodata_full || debug_pagealloc_enabled();
+	/*
+	 * rodata_full, DEBUG_PAGEALLOC and KFENCE require linear map to be
+	 * mapped at page granularity, so that it is possible to
+	 * protect/unprotect single pages.
+	 */
+	return (rodata_enabled && rodata_full) || debug_pagealloc_enabled() ||
+		IS_ENABLED(CONFIG_KFENCE);
 }
 
 static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
@@ -96,7 +102,8 @@ static int change_memory_common(unsigned long addr, int numpages,
 	 * If we are manipulating read-only permissions, apply the same
 	 * change to the linear mapping of the pages that back this VM area.
 	 */
-	if (rodata_full && (pgprot_val(set_mask) == PTE_RDONLY ||
+	if (rodata_enabled &&
+	    rodata_full && (pgprot_val(set_mask) == PTE_RDONLY ||
 			    pgprot_val(clear_mask) == PTE_RDONLY)) {
 		for (i = 0; i < area->nr_pages; i++) {
 			__change_memory_common((u64)page_address(area->pages[i]),
diff --git a/arch/mips/kernel/relocate_kernel.S b/arch/mips/kernel/relocate_kernel.S
index cfde14b48fd8..f5b2ef979b43 100644
--- a/arch/mips/kernel/relocate_kernel.S
+++ b/arch/mips/kernel/relocate_kernel.S
@@ -145,8 +145,7 @@ LEAF(kexec_smp_wait)
  * kexec_args[0..3] are used to prepare register values.
  */
 
-kexec_args:
-	EXPORT(kexec_args)
+EXPORT(kexec_args)
 arg0:	PTR_WD		0x0
 arg1:	PTR_WD		0x0
 arg2:	PTR_WD		0x0
@@ -159,8 +158,7 @@ arg3:	PTR_WD		0x0
  * their registers a0-a3. secondary_kexec_args[0..3] are used
  * to prepare register values.
  */
-secondary_kexec_args:
-	EXPORT(secondary_kexec_args)
+EXPORT(secondary_kexec_args)
 s_arg0: PTR_WD		0x0
 s_arg1: PTR_WD		0x0
 s_arg2: PTR_WD		0x0
@@ -171,19 +169,16 @@ kexec_flag:
 
 #endif
 
-kexec_start_address:
-	EXPORT(kexec_start_address)
+EXPORT(kexec_start_address)
 	PTR_WD		0x0
 	.size		kexec_start_address, PTRSIZE
 
-kexec_indirection_page:
-	EXPORT(kexec_indirection_page)
+EXPORT(kexec_indirection_page)
 	PTR_WD		0
 	.size		kexec_indirection_page, PTRSIZE
 
 relocate_new_kernel_end:
 
-relocate_new_kernel_size:
-	EXPORT(relocate_new_kernel_size)
+EXPORT(relocate_new_kernel_size)
 	PTR_WD		relocate_new_kernel_end - relocate_new_kernel
 	.size		relocate_new_kernel_size, PTRSIZE
diff --git a/arch/mips/loongson64/reset.c b/arch/mips/loongson64/reset.c
index 758d5d26aaaa..e420800043b0 100644
--- a/arch/mips/loongson64/reset.c
+++ b/arch/mips/loongson64/reset.c
@@ -16,6 +16,7 @@
 #include <asm/bootinfo.h>
 #include <asm/idle.h>
 #include <asm/reboot.h>
+#include <asm/bug.h>
 
 #include <loongson.h>
 #include <boot_param.h>
@@ -159,8 +160,17 @@ static int __init mips_reboot_setup(void)
 
 #ifdef CONFIG_KEXEC
 	kexec_argv = kmalloc(KEXEC_ARGV_SIZE, GFP_KERNEL);
+	if (WARN_ON(!kexec_argv))
+		return -ENOMEM;
+
 	kdump_argv = kmalloc(KEXEC_ARGV_SIZE, GFP_KERNEL);
+	if (WARN_ON(!kdump_argv))
+		return -ENOMEM;
+
 	kexec_envp = kmalloc(KEXEC_ENVP_SIZE, GFP_KERNEL);
+	if (WARN_ON(!kexec_envp))
+		return -ENOMEM;
+
 	fw_arg1 = KEXEC_ARGV_ADDR;
 	memcpy(kexec_envp, (void *)fw_arg2, KEXEC_ENVP_SIZE);
 
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index cbe7bb029aec..c1d36a22de30 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -284,7 +284,7 @@ config PPC
 	#
 
 config PPC_LONG_DOUBLE_128
-	depends on PPC64
+	depends on PPC64 && ALTIVEC
 	def_bool $(success,test "$(shell,echo __LONG_DOUBLE_128__ | $(CC) -E -P -)" = 1)
 
 config PPC_BARRIER_NOSPEC
diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index bd66f8e34949..00f45d8f1efa 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -202,7 +202,16 @@ unsigned long __get_wchan(struct task_struct *p);
 /* Has task runtime instrumentation enabled ? */
 #define is_ri_task(tsk) (!!(tsk)->thread.ri_cb)
 
-register unsigned long current_stack_pointer asm("r15");
+/* avoid using global register due to gcc bug in versions < 8.4 */
+#define current_stack_pointer (__current_stack_pointer())
+
+static __always_inline unsigned long __current_stack_pointer(void)
+{
+	unsigned long sp;
+
+	asm volatile("lgr %0,15" : "=d" (sp));
+	return sp;
+}
 
 static __always_inline unsigned short stap(void)
 {
diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 9ac3718410ce..7e39c47d7759 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -896,8 +896,7 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 	pmu_enabled = cpuc->enabled;
 	cpuc->enabled = 0;
 
-	/* stop everything (includes BRS) */
-	amd_pmu_disable_all();
+	amd_brs_disable_all();
 
 	/* Drain BRS is in use (could be inactive) */
 	if (cpuc->lbr_users)
@@ -908,7 +907,7 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 
 	cpuc->enabled = pmu_enabled;
 	if (pmu_enabled)
-		amd_pmu_enable_all(0);
+		amd_brs_enable_all();
 
 	return amd_pmu_adjust_nmi_window(handled);
 }
diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index d568afc705d2..83f15fe411b3 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -553,6 +553,7 @@ static void uncore_clean_online(void)
 
 	hlist_for_each_entry_safe(uncore, n, &uncore_unused_list, node) {
 		hlist_del(&uncore->node);
+		kfree(uncore->events);
 		kfree(uncore);
 	}
 }
diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 82ef87e9a897..42a55794004a 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1263,6 +1263,15 @@ static int pt_buffer_try_single(struct pt_buffer *buf, int nr_pages)
 	if (1 << order != nr_pages)
 		goto out;
 
+	/*
+	 * Some processors cannot always support single range for more than
+	 * 4KB - refer errata TGL052, ADL037 and RPL017. Future processors might
+	 * also be affected, so for now rather than trying to keep track of
+	 * which ones, just disable it for all.
+	 */
+	if (nr_pages > 1)
+		goto out;
+
 	buf->single = true;
 	buf->nr_pages = nr_pages;
 	ret = 0;
diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 5d75fe229342..347707d459c6 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -107,6 +107,11 @@
 
 #define INTEL_FAM6_SAPPHIRERAPIDS_X	0x8F	/* Golden Cove */
 
+#define INTEL_FAM6_EMERALDRAPIDS_X	0xCF
+
+#define INTEL_FAM6_GRANITERAPIDS_X	0xAD
+#define INTEL_FAM6_GRANITERAPIDS_D	0xAE
+
 #define INTEL_FAM6_ALDERLAKE		0x97	/* Golden Cove / Gracemont */
 #define INTEL_FAM6_ALDERLAKE_L		0x9A	/* Golden Cove / Gracemont */
 #define INTEL_FAM6_ALDERLAKE_N		0xBE
@@ -118,7 +123,7 @@
 #define INTEL_FAM6_METEORLAKE		0xAC
 #define INTEL_FAM6_METEORLAKE_L		0xAA
 
-/* "Small Core" Processors (Atom) */
+/* "Small Core" Processors (Atom/E-Core) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */
 #define INTEL_FAM6_ATOM_BONNELL_MID	0x26 /* Silverthorne, Lincroft */
@@ -145,6 +150,10 @@
 #define INTEL_FAM6_ATOM_TREMONT		0x96 /* Elkhart Lake */
 #define INTEL_FAM6_ATOM_TREMONT_L	0x9C /* Jasper Lake */
 
+#define INTEL_FAM6_SIERRAFOREST_X	0xAF
+
+#define INTEL_FAM6_GRANDRIDGE		0xB6
+
 /* Xeon Phi */
 
 #define INTEL_FAM6_XEON_PHI_KNL		0x57 /* Knights Landing */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index da7c361f47e0..6ec0b7ce7453 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -196,22 +196,15 @@ void __init check_bugs(void)
 }
 
 /*
- * NOTE: This function is *only* called for SVM.  VMX spec_ctrl handling is
- * done in vmenter.S.
+ * NOTE: This function is *only* called for SVM, since Intel uses
+ * MSR_IA32_SPEC_CTRL for SSBD.
  */
 void
 x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool setguest)
 {
-	u64 msrval, guestval = guest_spec_ctrl, hostval = spec_ctrl_current();
+	u64 guestval, hostval;
 	struct thread_info *ti = current_thread_info();
 
-	if (static_cpu_has(X86_FEATURE_MSR_SPEC_CTRL)) {
-		if (hostval != guestval) {
-			msrval = setguest ? guestval : hostval;
-			wrmsrl(MSR_IA32_SPEC_CTRL, msrval);
-		}
-	}
-
 	/*
 	 * If SSBD is not handled in MSR_SPEC_CTRL on AMD, update
 	 * MSR_AMD64_L2_CFG or MSR_VIRT_SPEC_CTRL if supported.
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index ebe79d60619f..da8b8ea6b063 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -356,6 +356,9 @@ static int sgx_validate_offset_length(struct sgx_encl *encl,
 	if (!length || !IS_ALIGNED(length, PAGE_SIZE))
 		return -EINVAL;
 
+	if (offset + length < offset)
+		return -EINVAL;
+
 	if (offset + length - PAGE_SIZE >= encl->size)
 		return -EINVAL;
 
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 3b28c5b25e12..d00db56a8868 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -605,9 +605,9 @@ int fpu_clone(struct task_struct *dst, unsigned long clone_flags, bool minimal)
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
 		fpregs_restore_userregs();
 	save_fpregs_to_fpstate(dst_fpu);
+	fpregs_unlock();
 	if (!(clone_flags & CLONE_THREAD))
 		fpu_inherit_perms(dst_fpu);
-	fpregs_unlock();
 
 	/*
 	 * Children never inherit PASID state.
diff --git a/arch/x86/kvm/kvm-asm-offsets.c b/arch/x86/kvm/kvm-asm-offsets.c
index f83e88b85bf2..24a710d37323 100644
--- a/arch/x86/kvm/kvm-asm-offsets.c
+++ b/arch/x86/kvm/kvm-asm-offsets.c
@@ -16,8 +16,10 @@ static void __used common(void)
 		BLANK();
 		OFFSET(SVM_vcpu_arch_regs, vcpu_svm, vcpu.arch.regs);
 		OFFSET(SVM_current_vmcb, vcpu_svm, current_vmcb);
+		OFFSET(SVM_spec_ctrl, vcpu_svm, spec_ctrl);
 		OFFSET(SVM_vmcb01, vcpu_svm, vmcb01);
 		OFFSET(KVM_VMCB_pa, kvm_vmcb_info, pa);
+		OFFSET(SD_save_area_pa, svm_cpu_data, save_area_pa);
 	}
 
 	if (IS_ENABLED(CONFIG_KVM_INTEL)) {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c9c9bd453a97..efaaef2b7ae1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -196,7 +196,7 @@ static void sev_asid_free(struct kvm_sev_info *sev)
 	__set_bit(sev->asid, sev_reclaim_asid_bitmap);
 
 	for_each_possible_cpu(cpu) {
-		sd = per_cpu(svm_data, cpu);
+		sd = per_cpu_ptr(&svm_data, cpu);
 		sd->sev_vmcbs[sev->asid] = NULL;
 	}
 
@@ -2600,7 +2600,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 
 void pre_sev_run(struct vcpu_svm *svm, int cpu)
 {
-	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
 	int asid = sev_get_asid(svm->vcpu.kvm);
 
 	/* Assign the asid allocated with this SEV guest */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 454746641a48..e80756ab141b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -245,7 +245,7 @@ struct kvm_ldttss_desc {
 	u32 zero1;
 } __attribute__((packed));
 
-DEFINE_PER_CPU(struct svm_cpu_data *, svm_data);
+DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
 
 /*
  * Only MSR_TSC_AUX is switched via the user return hook.  EFER is switched via
@@ -583,12 +583,7 @@ static int svm_hardware_enable(void)
 		pr_err("%s: err EOPNOTSUPP on %d\n", __func__, me);
 		return -EINVAL;
 	}
-	sd = per_cpu(svm_data, me);
-	if (!sd) {
-		pr_err("%s: svm_data is NULL on %d\n", __func__, me);
-		return -EINVAL;
-	}
-
+	sd = per_cpu_ptr(&svm_data, me);
 	sd->asid_generation = 1;
 	sd->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
 	sd->next_asid = sd->max_asid + 1;
@@ -599,7 +594,7 @@ static int svm_hardware_enable(void)
 
 	wrmsrl(MSR_EFER, efer | EFER_SVME);
 
-	wrmsrl(MSR_VM_HSAVE_PA, __sme_page_pa(sd->save_area));
+	wrmsrl(MSR_VM_HSAVE_PA, sd->save_area_pa);
 
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
 		/*
@@ -648,42 +643,37 @@ static int svm_hardware_enable(void)
 
 static void svm_cpu_uninit(int cpu)
 {
-	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
 
-	if (!sd)
+	if (!sd->save_area)
 		return;
 
-	per_cpu(svm_data, cpu) = NULL;
 	kfree(sd->sev_vmcbs);
 	__free_page(sd->save_area);
-	kfree(sd);
+	sd->save_area_pa = 0;
+	sd->save_area = NULL;
 }
 
 static int svm_cpu_init(int cpu)
 {
-	struct svm_cpu_data *sd;
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
 	int ret = -ENOMEM;
 
-	sd = kzalloc(sizeof(struct svm_cpu_data), GFP_KERNEL);
-	if (!sd)
-		return ret;
-	sd->cpu = cpu;
+	memset(sd, 0, sizeof(struct svm_cpu_data));
 	sd->save_area = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!sd->save_area)
-		goto free_cpu_data;
+		return ret;
 
 	ret = sev_cpu_init(sd);
 	if (ret)
 		goto free_save_area;
 
-	per_cpu(svm_data, cpu) = sd;
-
+	sd->save_area_pa = __sme_page_pa(sd->save_area);
 	return 0;
 
 free_save_area:
 	__free_page(sd->save_area);
-free_cpu_data:
-	kfree(sd);
+	sd->save_area = NULL;
 	return ret;
 
 }
@@ -732,6 +722,15 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 	u32 offset;
 	u32 *msrpm;
 
+	/*
+	 * For non-nested case:
+	 * If the L01 MSR bitmap does not intercept the MSR, then we need to
+	 * save it.
+	 *
+	 * For nested case:
+	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
+	 * save it.
+	 */
 	msrpm = is_guest_mode(vcpu) ? to_svm(vcpu)->nested.msrpm:
 				      to_svm(vcpu)->msrpm;
 
@@ -1427,7 +1426,7 @@ static void svm_clear_current_vmcb(struct vmcb *vmcb)
 	int i;
 
 	for_each_online_cpu(i)
-		cmpxchg(&per_cpu(svm_data, i)->current_vmcb, vmcb, NULL);
+		cmpxchg(per_cpu_ptr(&svm_data.current_vmcb, i), vmcb, NULL);
 }
 
 static void svm_vcpu_free(struct kvm_vcpu *vcpu)
@@ -1452,7 +1451,7 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
 
 	if (sev_es_guest(vcpu->kvm))
 		sev_es_unmap_ghcb(svm);
@@ -1464,7 +1463,7 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	 * Save additional host state that will be restored on VMEXIT (sev-es)
 	 * or subsequent vmload of host save area.
 	 */
-	vmsave(__sme_page_pa(sd->save_area));
+	vmsave(sd->save_area_pa);
 	if (sev_es_guest(vcpu->kvm)) {
 		struct sev_es_save_area *hostsa;
 		hostsa = (struct sev_es_save_area *)(page_address(sd->save_area) + 0x400);
@@ -1489,7 +1488,7 @@ static void svm_prepare_host_switch(struct kvm_vcpu *vcpu)
 static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
 
 	if (sd->current_vmcb != svm->vmcb) {
 		sd->current_vmcb = svm->vmcb;
@@ -3444,7 +3443,7 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 static void reload_tss(struct kvm_vcpu *vcpu)
 {
-	struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
 
 	sd->tss_desc->type = 9; /* available 32/64-bit TSS */
 	load_TR_desc();
@@ -3452,7 +3451,7 @@ static void reload_tss(struct kvm_vcpu *vcpu)
 
 static void pre_svm_run(struct kvm_vcpu *vcpu)
 {
-	struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	/*
@@ -3912,20 +3911,16 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 	return EXIT_FASTPATH_NONE;
 }
 
-static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
+static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_intercepted)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	guest_state_enter_irqoff();
 
-	if (sev_es_guest(vcpu->kvm)) {
-		__svm_sev_es_vcpu_run(svm);
-	} else {
-		struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
-
-		__svm_vcpu_run(svm);
-		vmload(__sme_page_pa(sd->save_area));
-	}
+	if (sev_es_guest(vcpu->kvm))
+		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
+	else
+		__svm_vcpu_run(svm, spec_ctrl_intercepted);
 
 	guest_state_exit_irqoff();
 }
@@ -3933,6 +3928,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	bool spec_ctrl_intercepted = msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL);
 
 	trace_kvm_entry(vcpu);
 
@@ -3991,26 +3987,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
 		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
-	svm_vcpu_enter_exit(vcpu);
-
-	/*
-	 * We do not use IBRS in the kernel. If this vCPU has used the
-	 * SPEC_CTRL MSR it may have left it on; save the value and
-	 * turn it off. This is much more efficient than blindly adding
-	 * it to the atomic save/restore list. Especially as the former
-	 * (Saving guest MSRs on vmexit) doesn't even exist in KVM.
-	 *
-	 * For non-nested case:
-	 * If the L01 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 *
-	 * For nested case:
-	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 */
-	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL) &&
-	    unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
-		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
+	svm_vcpu_enter_exit(vcpu, spec_ctrl_intercepted);
 
 	if (!sev_es_guest(vcpu->kvm))
 		reload_tss(vcpu);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7ff1879e73c5..ea3049b978ea 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -281,8 +281,6 @@ struct vcpu_svm {
 };
 
 struct svm_cpu_data {
-	int cpu;
-
 	u64 asid_generation;
 	u32 max_asid;
 	u32 next_asid;
@@ -290,13 +288,15 @@ struct svm_cpu_data {
 	struct kvm_ldttss_desc *tss_desc;
 
 	struct page *save_area;
+	unsigned long save_area_pa;
+
 	struct vmcb *current_vmcb;
 
 	/* index = sev_asid, value = vmcb pointer */
 	struct vmcb **sev_vmcbs;
 };
 
-DECLARE_PER_CPU(struct svm_cpu_data *, svm_data);
+DECLARE_PER_CPU(struct svm_cpu_data, svm_data);
 
 void recalc_intercepts(struct vcpu_svm *svm);
 
@@ -683,7 +683,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
 /* vmenter.S */
 
-void __svm_sev_es_vcpu_run(struct vcpu_svm *svm);
-void __svm_vcpu_run(struct vcpu_svm *svm);
+void __svm_sev_es_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted);
+void __svm_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted);
 
 #endif
diff --git a/arch/x86/kvm/svm/svm_ops.h b/arch/x86/kvm/svm/svm_ops.h
index 9430d6437c9f..36c8af87a707 100644
--- a/arch/x86/kvm/svm/svm_ops.h
+++ b/arch/x86/kvm/svm/svm_ops.h
@@ -61,9 +61,4 @@ static __always_inline void vmsave(unsigned long pa)
 	svm_asm1(vmsave, "a" (pa), "memory");
 }
 
-static __always_inline void vmload(unsigned long pa)
-{
-	svm_asm1(vmload, "a" (pa), "memory");
-}
-
 #endif /* __KVM_X86_SVM_OPS_H */
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 5bc2ed7d79c0..34367dc203f2 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -32,9 +32,69 @@
 
 .section .noinstr.text, "ax"
 
+.macro RESTORE_GUEST_SPEC_CTRL
+	/* No need to do anything if SPEC_CTRL is unset or V_SPEC_CTRL is set */
+	ALTERNATIVE_2 "", \
+		"jmp 800f", X86_FEATURE_MSR_SPEC_CTRL, \
+		"", X86_FEATURE_V_SPEC_CTRL
+801:
+.endm
+.macro RESTORE_GUEST_SPEC_CTRL_BODY
+800:
+	/*
+	 * SPEC_CTRL handling: if the guest's SPEC_CTRL value differs from the
+	 * host's, write the MSR.  This is kept out-of-line so that the common
+	 * case does not have to jump.
+	 *
+	 * IMPORTANT: To avoid RSB underflow attacks and any other nastiness,
+	 * there must not be any returns or indirect branches between this code
+	 * and vmentry.
+	 */
+	movl SVM_spec_ctrl(%_ASM_DI), %eax
+	cmp PER_CPU_VAR(x86_spec_ctrl_current), %eax
+	je 801b
+	mov $MSR_IA32_SPEC_CTRL, %ecx
+	xor %edx, %edx
+	wrmsr
+	jmp 801b
+.endm
+
+.macro RESTORE_HOST_SPEC_CTRL
+	/* No need to do anything if SPEC_CTRL is unset or V_SPEC_CTRL is set */
+	ALTERNATIVE_2 "", \
+		"jmp 900f", X86_FEATURE_MSR_SPEC_CTRL, \
+		"", X86_FEATURE_V_SPEC_CTRL
+901:
+.endm
+.macro RESTORE_HOST_SPEC_CTRL_BODY
+900:
+	/* Same for after vmexit.  */
+	mov $MSR_IA32_SPEC_CTRL, %ecx
+
+	/*
+	 * Load the value that the guest had written into MSR_IA32_SPEC_CTRL,
+	 * if it was not intercepted during guest execution.
+	 */
+	cmpb $0, (%_ASM_SP)
+	jnz 998f
+	rdmsr
+	movl %eax, SVM_spec_ctrl(%_ASM_DI)
+998:
+
+	/* Now restore the host value of the MSR if different from the guest's.  */
+	movl PER_CPU_VAR(x86_spec_ctrl_current), %eax
+	cmp SVM_spec_ctrl(%_ASM_DI), %eax
+	je 901b
+	xor %edx, %edx
+	wrmsr
+	jmp 901b
+.endm
+
+
 /**
  * __svm_vcpu_run - Run a vCPU via a transition to SVM guest mode
  * @svm:	struct vcpu_svm *
+ * @spec_ctrl_intercepted: bool
  */
 SYM_FUNC_START(__svm_vcpu_run)
 	push %_ASM_BP
@@ -49,14 +109,31 @@ SYM_FUNC_START(__svm_vcpu_run)
 #endif
 	push %_ASM_BX
 
-	/* Save @svm. */
+	/*
+	 * Save variables needed after vmexit on the stack, in inverse
+	 * order compared to when they are needed.
+	 */
+
+	/* Accessed directly from the stack in RESTORE_HOST_SPEC_CTRL.  */
+	push %_ASM_ARG2
+
+	/* Needed to restore access to percpu variables.  */
+	__ASM_SIZE(push) PER_CPU_VAR(svm_data + SD_save_area_pa)
+
+	/* Finally save @svm. */
 	push %_ASM_ARG1
 
 .ifnc _ASM_ARG1, _ASM_DI
-	/* Move @svm to RDI. */
+	/*
+	 * Stash @svm in RDI early. On 32-bit, arguments are in RAX, RCX
+	 * and RDX which are clobbered by RESTORE_GUEST_SPEC_CTRL.
+	 */
 	mov %_ASM_ARG1, %_ASM_DI
 .endif
 
+	/* Clobbers RAX, RCX, RDX.  */
+	RESTORE_GUEST_SPEC_CTRL
+
 	/*
 	 * Use a single vmcb (vmcb01 because it's always valid) for
 	 * context switching guest state via VMLOAD/VMSAVE, that way
@@ -124,11 +201,19 @@ SYM_FUNC_START(__svm_vcpu_run)
 5:	vmsave %_ASM_AX
 6:
 
+	/* Restores GSBASE among other things, allowing access to percpu data.  */
+	pop %_ASM_AX
+7:	vmload %_ASM_AX
+8:
+
 #ifdef CONFIG_RETPOLINE
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
 	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
 #endif
 
+	/* Clobbers RAX, RCX, RDX.  */
+	RESTORE_HOST_SPEC_CTRL
+
 	/*
 	 * Mitigate RETBleed for AMD/Hygon Zen uarch. RET should be
 	 * untrained as soon as we exit the VM and are back to the
@@ -164,6 +249,9 @@ SYM_FUNC_START(__svm_vcpu_run)
 	xor %r15d, %r15d
 #endif
 
+	/* "Pop" @spec_ctrl_intercepted.  */
+	pop %_ASM_BX
+
 	pop %_ASM_BX
 
 #ifdef CONFIG_X86_64
@@ -178,6 +266,9 @@ SYM_FUNC_START(__svm_vcpu_run)
 	pop %_ASM_BP
 	RET
 
+	RESTORE_GUEST_SPEC_CTRL_BODY
+	RESTORE_HOST_SPEC_CTRL_BODY
+
 10:	cmpb $0, kvm_rebooting
 	jne 2b
 	ud2
@@ -187,16 +278,21 @@ SYM_FUNC_START(__svm_vcpu_run)
 50:	cmpb $0, kvm_rebooting
 	jne 6b
 	ud2
+70:	cmpb $0, kvm_rebooting
+	jne 8b
+	ud2
 
 	_ASM_EXTABLE(1b, 10b)
 	_ASM_EXTABLE(3b, 30b)
 	_ASM_EXTABLE(5b, 50b)
+	_ASM_EXTABLE(7b, 70b)
 
 SYM_FUNC_END(__svm_vcpu_run)
 
 /**
  * __svm_sev_es_vcpu_run - Run a SEV-ES vCPU via a transition to SVM guest mode
  * @svm:	struct vcpu_svm *
+ * @spec_ctrl_intercepted: bool
  */
 SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	push %_ASM_BP
@@ -211,8 +307,30 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 #endif
 	push %_ASM_BX
 
+	/*
+	 * Save variables needed after vmexit on the stack, in inverse
+	 * order compared to when they are needed.
+	 */
+
+	/* Accessed directly from the stack in RESTORE_HOST_SPEC_CTRL.  */
+	push %_ASM_ARG2
+
+	/* Save @svm. */
+	push %_ASM_ARG1
+
+.ifnc _ASM_ARG1, _ASM_DI
+	/*
+	 * Stash @svm in RDI early. On 32-bit, arguments are in RAX, RCX
+	 * and RDX which are clobbered by RESTORE_GUEST_SPEC_CTRL.
+	 */
+	mov %_ASM_ARG1, %_ASM_DI
+.endif
+
+	/* Clobbers RAX, RCX, RDX.  */
+	RESTORE_GUEST_SPEC_CTRL
+
 	/* Get svm->current_vmcb->pa into RAX. */
-	mov SVM_current_vmcb(%_ASM_ARG1), %_ASM_AX
+	mov SVM_current_vmcb(%_ASM_DI), %_ASM_AX
 	mov KVM_VMCB_pa(%_ASM_AX), %_ASM_AX
 
 	/* Enter guest mode */
@@ -222,11 +340,17 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 
 2:	cli
 
+	/* Pop @svm to RDI, guest registers have been saved already. */
+	pop %_ASM_DI
+
 #ifdef CONFIG_RETPOLINE
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
 	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
 #endif
 
+	/* Clobbers RAX, RCX, RDX.  */
+	RESTORE_HOST_SPEC_CTRL
+
 	/*
 	 * Mitigate RETBleed for AMD/Hygon Zen uarch. RET should be
 	 * untrained as soon as we exit the VM and are back to the
@@ -236,6 +360,9 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	 */
 	UNTRAIN_RET
 
+	/* "Pop" @spec_ctrl_intercepted.  */
+	pop %_ASM_BX
+
 	pop %_ASM_BX
 
 #ifdef CONFIG_X86_64
@@ -250,6 +377,9 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	pop %_ASM_BP
 	RET
 
+	RESTORE_GUEST_SPEC_CTRL_BODY
+	RESTORE_HOST_SPEC_CTRL_BODY
+
 3:	cmpb $0, kvm_rebooting
 	jne 2b
 	ud2
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index cecf8299b187..9a1950879fc4 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1667,18 +1667,18 @@ static int kvm_xen_eventfd_assign(struct kvm *kvm,
 	case EVTCHNSTAT_ipi:
 		/* IPI  must map back to the same port# */
 		if (data->u.evtchn.deliver.port.port != data->u.evtchn.send_port)
-			goto out; /* -EINVAL */
+			goto out_noeventfd; /* -EINVAL */
 		break;
 
 	case EVTCHNSTAT_interdomain:
 		if (data->u.evtchn.deliver.port.port) {
 			if (data->u.evtchn.deliver.port.port >= max_evtchn_port(kvm))
-				goto out; /* -EINVAL */
+				goto out_noeventfd; /* -EINVAL */
 		} else {
 			eventfd = eventfd_ctx_fdget(data->u.evtchn.deliver.eventfd.fd);
 			if (IS_ERR(eventfd)) {
 				ret = PTR_ERR(eventfd);
-				goto out;
+				goto out_noeventfd;
 			}
 		}
 		break;
@@ -1718,6 +1718,7 @@ static int kvm_xen_eventfd_assign(struct kvm *kvm,
 out:
 	if (eventfd)
 		eventfd_ctx_put(eventfd);
+out_noeventfd:
 	kfree(evtchnfd);
 	return ret;
 }
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 869af9d72bcf..c8f0c865bf4e 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1251,7 +1251,7 @@ static int blkcg_css_online(struct cgroup_subsys_state *css)
 	 * parent so that offline always happens towards the root.
 	 */
 	if (parent)
-		blkcg_pin_online(css);
+		blkcg_pin_online(&parent->css);
 	return 0;
 }
 
diff --git a/block/blk-core.c b/block/blk-core.c
index 651057c4146b..2fbdf17f2206 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -426,7 +426,6 @@ struct request_queue *blk_alloc_queue(int node_id, bool alloc_srcu)
 				PERCPU_REF_INIT_ATOMIC, GFP_KERNEL))
 		goto fail_stats;
 
-	blk_queue_dma_alignment(q, 511);
 	blk_set_default_limits(&q->limits);
 	q->nr_requests = BLKDEV_DEFAULT_RQ;
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index edf41959a705..4402e4ecb8b1 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1183,6 +1183,7 @@ static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
 		   (!blk_queue_nomerges(rq->q) &&
 		    blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
 		blk_mq_flush_plug_list(plug, false);
+		last = NULL;
 		trace_block_plug(rq->q);
 	}
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 8bb9eef5310e..4949ed3ce7c9 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -57,6 +57,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->misaligned = 0;
 	lim->zoned = BLK_ZONED_NONE;
 	lim->zone_write_granularity = 0;
+	lim->dma_alignment = 511;
 }
 EXPORT_SYMBOL(blk_set_default_limits);
 
@@ -600,6 +601,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 
 	t->io_min = max(t->io_min, b->io_min);
 	t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
+	t->dma_alignment = max(t->dma_alignment, b->dma_alignment);
 
 	/* Set non-power-of-2 compatible chunk_sectors boundary */
 	if (b->chunk_sectors)
@@ -773,7 +775,7 @@ EXPORT_SYMBOL(blk_queue_virt_boundary);
  **/
 void blk_queue_dma_alignment(struct request_queue *q, int mask)
 {
-	q->dma_alignment = mask;
+	q->limits.dma_alignment = mask;
 }
 EXPORT_SYMBOL(blk_queue_dma_alignment);
 
@@ -795,8 +797,8 @@ void blk_queue_update_dma_alignment(struct request_queue *q, int mask)
 {
 	BUG_ON(mask > PAGE_SIZE);
 
-	if (mask > q->dma_alignment)
-		q->dma_alignment = mask;
+	if (mask > q->limits.dma_alignment)
+		q->limits.dma_alignment = mask;
 }
 EXPORT_SYMBOL(blk_queue_update_dma_alignment);
 
diff --git a/block/sed-opal.c b/block/sed-opal.c
index 9700197000f2..55cd37e868c0 100644
--- a/block/sed-opal.c
+++ b/block/sed-opal.c
@@ -88,8 +88,8 @@ struct opal_dev {
 	u64 lowest_lba;
 
 	size_t pos;
-	u8 cmd[IO_BUFFER_LENGTH];
-	u8 resp[IO_BUFFER_LENGTH];
+	u8 *cmd;
+	u8 *resp;
 
 	struct parsed_resp parsed;
 	size_t prev_d_len;
@@ -2134,6 +2134,8 @@ void free_opal_dev(struct opal_dev *dev)
 		return;
 
 	clean_opal_dev(dev);
+	kfree(dev->resp);
+	kfree(dev->cmd);
 	kfree(dev);
 }
 EXPORT_SYMBOL(free_opal_dev);
@@ -2146,17 +2148,39 @@ struct opal_dev *init_opal_dev(void *data, sec_send_recv *send_recv)
 	if (!dev)
 		return NULL;
 
+	/*
+	 * Presumably DMA-able buffers must be cache-aligned. Kmalloc makes
+	 * sure the allocated buffer is DMA-safe in that regard.
+	 */
+	dev->cmd = kmalloc(IO_BUFFER_LENGTH, GFP_KERNEL);
+	if (!dev->cmd)
+		goto err_free_dev;
+
+	dev->resp = kmalloc(IO_BUFFER_LENGTH, GFP_KERNEL);
+	if (!dev->resp)
+		goto err_free_cmd;
+
 	INIT_LIST_HEAD(&dev->unlk_lst);
 	mutex_init(&dev->dev_lock);
 	dev->data = data;
 	dev->send_recv = send_recv;
 	if (check_opal_support(dev) != 0) {
 		pr_debug("Opal is not supported on this device\n");
-		kfree(dev);
-		return NULL;
+		goto err_free_resp;
 	}
 
 	return dev;
+
+err_free_resp:
+	kfree(dev->resp);
+
+err_free_cmd:
+	kfree(dev->cmd);
+
+err_free_dev:
+	kfree(dev);
+
+	return NULL;
 }
 EXPORT_SYMBOL(init_opal_dev);
 
diff --git a/drivers/accessibility/speakup/main.c b/drivers/accessibility/speakup/main.c
index f52265293482..73db0cb44fc7 100644
--- a/drivers/accessibility/speakup/main.c
+++ b/drivers/accessibility/speakup/main.c
@@ -1778,7 +1778,7 @@ static void speakup_con_update(struct vc_data *vc)
 {
 	unsigned long flags;
 
-	if (!speakup_console[vc->vc_num] || spk_parked)
+	if (!speakup_console[vc->vc_num] || spk_parked || !synth)
 		return;
 	if (!spin_trylock_irqsave(&speakup_info.spinlock, flags))
 		/* Speakup output, discard */
diff --git a/drivers/accessibility/speakup/utils.h b/drivers/accessibility/speakup/utils.h
index 4bf2ee8ac246..4ce9a12f7664 100644
--- a/drivers/accessibility/speakup/utils.h
+++ b/drivers/accessibility/speakup/utils.h
@@ -54,7 +54,7 @@ static inline int oops(const char *msg, const char *info)
 
 static inline struct st_key *hash_name(char *name)
 {
-	u_char *pn = (u_char *)name;
+	unsigned char *pn = (unsigned char *)name;
 	int hash = 0;
 
 	while (*pn) {
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 42cec8120f18..adfeb5770efd 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -796,6 +796,7 @@ static bool acpi_info_matches_ids(struct acpi_device_info *info,
 static const char * const acpi_ignore_dep_ids[] = {
 	"PNP0D80", /* Windows-compatible System Power Management Controller */
 	"INT33BD", /* Intel Baytrail Mailbox Device */
+	"LATT2021", /* Lattice FW Update Client Driver */
 	NULL
 };
 
diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index d7cdd8406c84..950a93922ca8 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -219,6 +219,12 @@ static const struct dmi_system_id force_storage_d3_dmi[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 14 7425 2-in-1"),
 		}
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 16 5625"),
+		}
+	},
 	{}
 };
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b0e442a75690..d86e32b71efa 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3966,9 +3966,19 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 
 int __ata_scsi_queuecmd(struct scsi_cmnd *scmd, struct ata_device *dev)
 {
+	struct ata_port *ap = dev->link->ap;
 	u8 scsi_op = scmd->cmnd[0];
 	ata_xlat_func_t xlat_func;
 
+	/*
+	 * scsi_queue_rq() will defer commands if scsi_host_in_recovery().
+	 * However, this check is done without holding the ap->lock (a libata
+	 * specific lock), so we can have received an error irq since then,
+	 * therefore we must check if EH is pending, while holding ap->lock.
+	 */
+	if (ap->pflags & (ATA_PFLAG_EH_PENDING | ATA_PFLAG_EH_IN_PROGRESS))
+		return SCSI_MLQUEUE_DEVICE_BUSY;
+
 	if (unlikely(!scmd->cmd_len))
 		goto bad_cdb_len;
 
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index a7e9a75410a3..e4fb9d1b9b39 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -301,7 +301,9 @@ int ata_tport_add(struct device *parent,
 	pm_runtime_enable(dev);
 	pm_runtime_forbid(dev);
 
-	transport_add_device(dev);
+	error = transport_add_device(dev);
+	if (error)
+		goto tport_transport_add_err;
 	transport_configure_device(dev);
 
 	error = ata_tlink_add(&ap->link);
@@ -312,12 +314,12 @@ int ata_tport_add(struct device *parent,
 
  tport_link_err:
 	transport_remove_device(dev);
+ tport_transport_add_err:
 	device_del(dev);
 
  tport_err:
 	transport_destroy_device(dev);
 	put_device(dev);
-	ata_host_put(ap->host);
 	return error;
 }
 
@@ -456,7 +458,9 @@ int ata_tlink_add(struct ata_link *link)
 		goto tlink_err;
 	}
 
-	transport_add_device(dev);
+	error = transport_add_device(dev);
+	if (error)
+		goto tlink_transport_err;
 	transport_configure_device(dev);
 
 	ata_for_each_dev(ata_dev, link, ALL) {
@@ -471,6 +475,7 @@ int ata_tlink_add(struct ata_link *link)
 		ata_tdev_delete(ata_dev);
 	}
 	transport_remove_device(dev);
+  tlink_transport_err:
 	device_del(dev);
   tlink_err:
 	transport_destroy_device(dev);
@@ -708,7 +713,13 @@ static int ata_tdev_add(struct ata_device *ata_dev)
 		return error;
 	}
 
-	transport_add_device(dev);
+	error = transport_add_device(dev);
+	if (error) {
+		device_del(dev);
+		ata_tdev_free(ata_dev);
+		return error;
+	}
+
 	transport_configure_device(dev);
 	return 0;
 }
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index f3e4db16fd07..8532b839a343 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2672,7 +2672,7 @@ static int init_submitter(struct drbd_device *device)
 enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsigned int minor)
 {
 	struct drbd_resource *resource = adm_ctx->resource;
-	struct drbd_connection *connection;
+	struct drbd_connection *connection, *n;
 	struct drbd_device *device;
 	struct drbd_peer_device *peer_device, *tmp_peer_device;
 	struct gendisk *disk;
@@ -2789,7 +2789,7 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 	return NO_ERROR;
 
 out_idr_remove_from_resource:
-	for_each_connection(connection, resource) {
+	for_each_connection_safe(connection, n, resource) {
 		peer_device = idr_remove(&connection->peer_devices, vnr);
 		if (peer_device)
 			kref_put(&connection->kref, drbd_destroy_connection);
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 16176b9278b4..0c90f13870a4 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -174,7 +174,7 @@ int cxl_mbox_send_cmd(struct cxl_dev_state *cxlds, u16 opcode, void *in,
 	};
 	int rc;
 
-	if (out_size > cxlds->payload_size)
+	if (in_size > cxlds->payload_size || out_size > cxlds->payload_size)
 		return -E2BIG;
 
 	rc = cxlds->mbox_send(cxlds, &mbox_cmd);
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index faade12279f0..e0646097a3d4 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -151,7 +151,7 @@ static int cxl_pmem_set_config_data(struct cxl_dev_state *cxlds,
 		return -EINVAL;
 
 	/* 4-byte status follows the input data in the payload */
-	if (struct_size(cmd, in_buf, cmd->in_length) + 4 > buf_len)
+	if (size_add(struct_size(cmd, in_buf, cmd->in_length), 4) > buf_len)
 		return -EINVAL;
 
 	set_lsa =
diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index d4e23101448a..35bb70724d44 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -216,9 +216,20 @@ void scmi_device_destroy(struct scmi_device *scmi_dev)
 	device_unregister(&scmi_dev->dev);
 }
 
+void scmi_device_link_add(struct device *consumer, struct device *supplier)
+{
+	struct device_link *link;
+
+	link = device_link_add(consumer, supplier, DL_FLAG_AUTOREMOVE_CONSUMER);
+
+	WARN_ON(!link);
+}
+
 void scmi_set_handle(struct scmi_device *scmi_dev)
 {
 	scmi_dev->handle = scmi_handle_get(&scmi_dev->dev);
+	if (scmi_dev->handle)
+		scmi_device_link_add(&scmi_dev->dev, scmi_dev->handle->dev);
 }
 
 int scmi_protocol_register(const struct scmi_protocol *proto)
diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 61aba7447c32..a1c0154c31c6 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -97,6 +97,7 @@ static inline void unpack_scmi_header(u32 msg_hdr, struct scmi_msg_hdr *hdr)
 struct scmi_revision_info *
 scmi_revision_area_get(const struct scmi_protocol_handle *ph);
 int scmi_handle_put(const struct scmi_handle *handle);
+void scmi_device_link_add(struct device *consumer, struct device *supplier);
 struct scmi_handle *scmi_handle_get(struct device *dev);
 void scmi_set_handle(struct scmi_device *scmi_dev);
 void scmi_setup_protocol_implemented(const struct scmi_protocol_handle *ph,
@@ -117,6 +118,7 @@ void scmi_protocol_release(const struct scmi_handle *handle, u8 protocol_id);
  *
  * @dev: Reference to device in the SCMI hierarchy corresponding to this
  *	 channel
+ * @rx_timeout_ms: The configured RX timeout in milliseconds.
  * @handle: Pointer to SCMI entity handle
  * @no_completion_irq: Flag to indicate that this channel has no completion
  *		       interrupt mechanism for synchronous commands.
@@ -126,6 +128,7 @@ void scmi_protocol_release(const struct scmi_handle *handle, u8 protocol_id);
  */
 struct scmi_chan_info {
 	struct device *dev;
+	unsigned int rx_timeout_ms;
 	struct scmi_handle *handle;
 	bool no_completion_irq;
 	void *transport_info;
@@ -232,7 +235,7 @@ void scmi_free_channel(struct scmi_chan_info *cinfo, struct idr *idr, int id);
 struct scmi_shared_mem;
 
 void shmem_tx_prepare(struct scmi_shared_mem __iomem *shmem,
-		      struct scmi_xfer *xfer);
+		      struct scmi_xfer *xfer, struct scmi_chan_info *cinfo);
 u32 shmem_read_header(struct scmi_shared_mem __iomem *shmem);
 void shmem_fetch_response(struct scmi_shared_mem __iomem *shmem,
 			  struct scmi_xfer *xfer);
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 9022f5ee29aa..f818d00bb2c6 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2013,6 +2013,7 @@ static int scmi_chan_setup(struct scmi_info *info, struct device *dev,
 		return -ENOMEM;
 
 	cinfo->dev = dev;
+	cinfo->rx_timeout_ms = info->desc->max_rx_timeout_ms;
 
 	ret = info->desc->ops->chan_setup(cinfo, info->dev, tx);
 	if (ret)
@@ -2277,10 +2278,16 @@ int scmi_protocol_device_request(const struct scmi_device_id *id_table)
 			sdev = scmi_get_protocol_device(child, info,
 							id_table->protocol_id,
 							id_table->name);
-			/* Set handle if not already set: device existed */
-			if (sdev && !sdev->handle)
-				sdev->handle =
-					scmi_handle_get_from_info_unlocked(info);
+			if (sdev) {
+				/* Set handle if not already set: device existed */
+				if (!sdev->handle)
+					sdev->handle =
+						scmi_handle_get_from_info_unlocked(info);
+				/* Relink consumer and suppliers */
+				if (sdev->handle)
+					scmi_device_link_add(&sdev->dev,
+							     sdev->handle->dev);
+			}
 		} else {
 			dev_err(info->dev,
 				"Failed. SCMI protocol %d not active.\n",
@@ -2479,20 +2486,17 @@ void scmi_free_channel(struct scmi_chan_info *cinfo, struct idr *idr, int id)
 
 static int scmi_remove(struct platform_device *pdev)
 {
-	int ret = 0, id;
+	int ret, id;
 	struct scmi_info *info = platform_get_drvdata(pdev);
 	struct device_node *child;
 
 	mutex_lock(&scmi_list_mutex);
 	if (info->users)
-		ret = -EBUSY;
-	else
-		list_del(&info->node);
+		dev_warn(&pdev->dev,
+			 "Still active SCMI users will be forcibly unbound.\n");
+	list_del(&info->node);
 	mutex_unlock(&scmi_list_mutex);
 
-	if (ret)
-		return ret;
-
 	scmi_notification_exit(&info->handle);
 
 	mutex_lock(&info->protocols_mtx);
@@ -2504,7 +2508,11 @@ static int scmi_remove(struct platform_device *pdev)
 	idr_destroy(&info->active_protocols);
 
 	/* Safe to free channels since no more users */
-	return scmi_cleanup_txrx_channels(info);
+	ret = scmi_cleanup_txrx_channels(info);
+	if (ret)
+		dev_warn(&pdev->dev, "Failed to cleanup SCMI channels.\n");
+
+	return 0;
 }
 
 static ssize_t protocol_version_show(struct device *dev,
diff --git a/drivers/firmware/arm_scmi/mailbox.c b/drivers/firmware/arm_scmi/mailbox.c
index 08ff4d110beb..1e40cb035044 100644
--- a/drivers/firmware/arm_scmi/mailbox.c
+++ b/drivers/firmware/arm_scmi/mailbox.c
@@ -36,7 +36,7 @@ static void tx_prepare(struct mbox_client *cl, void *m)
 {
 	struct scmi_mailbox *smbox = client_to_scmi_mailbox(cl);
 
-	shmem_tx_prepare(smbox->shmem, m);
+	shmem_tx_prepare(smbox->shmem, m, smbox->cinfo);
 }
 
 static void rx_callback(struct mbox_client *cl, void *m)
diff --git a/drivers/firmware/arm_scmi/optee.c b/drivers/firmware/arm_scmi/optee.c
index f42dad997ac9..2a7aeab40e54 100644
--- a/drivers/firmware/arm_scmi/optee.c
+++ b/drivers/firmware/arm_scmi/optee.c
@@ -498,7 +498,7 @@ static int scmi_optee_send_message(struct scmi_chan_info *cinfo,
 		msg_tx_prepare(channel->req.msg, xfer);
 		ret = invoke_process_msg_channel(channel, msg_command_size(xfer));
 	} else {
-		shmem_tx_prepare(channel->req.shmem, xfer);
+		shmem_tx_prepare(channel->req.shmem, xfer, cinfo);
 		ret = invoke_process_smt_channel(channel);
 	}
 
diff --git a/drivers/firmware/arm_scmi/shmem.c b/drivers/firmware/arm_scmi/shmem.c
index 0e3eaea5d852..1dfe534b8518 100644
--- a/drivers/firmware/arm_scmi/shmem.c
+++ b/drivers/firmware/arm_scmi/shmem.c
@@ -5,10 +5,13 @@
  * Copyright (C) 2019 ARM Ltd.
  */
 
+#include <linux/ktime.h>
 #include <linux/io.h>
 #include <linux/processor.h>
 #include <linux/types.h>
 
+#include <asm-generic/bug.h>
+
 #include "common.h"
 
 /*
@@ -30,16 +33,36 @@ struct scmi_shared_mem {
 };
 
 void shmem_tx_prepare(struct scmi_shared_mem __iomem *shmem,
-		      struct scmi_xfer *xfer)
+		      struct scmi_xfer *xfer, struct scmi_chan_info *cinfo)
 {
+	ktime_t stop;
+
 	/*
 	 * Ideally channel must be free by now unless OS timeout last
 	 * request and platform continued to process the same, wait
 	 * until it releases the shared memory, otherwise we may endup
-	 * overwriting its response with new message payload or vice-versa
+	 * overwriting its response with new message payload or vice-versa.
+	 * Giving up anyway after twice the expected channel timeout so as
+	 * not to bail-out on intermittent issues where the platform is
+	 * occasionally a bit slower to answer.
+	 *
+	 * Note that after a timeout is detected we bail-out and carry on but
+	 * the transport functionality is probably permanently compromised:
+	 * this is just to ease debugging and avoid complete hangs on boot
+	 * due to a misbehaving SCMI firmware.
 	 */
-	spin_until_cond(ioread32(&shmem->channel_status) &
-			SCMI_SHMEM_CHAN_STAT_CHANNEL_FREE);
+	stop = ktime_add_ms(ktime_get(), 2 * cinfo->rx_timeout_ms);
+	spin_until_cond((ioread32(&shmem->channel_status) &
+			 SCMI_SHMEM_CHAN_STAT_CHANNEL_FREE) ||
+			 ktime_after(ktime_get(), stop));
+	if (!(ioread32(&shmem->channel_status) &
+	      SCMI_SHMEM_CHAN_STAT_CHANNEL_FREE)) {
+		WARN_ON_ONCE(1);
+		dev_err(cinfo->dev,
+			"Timeout waiting for a free TX channel !\n");
+		return;
+	}
+
 	/* Mark channel busy + clear error */
 	iowrite32(0x0, &shmem->channel_status);
 	iowrite32(xfer->hdr.poll_completion ? 0 : SCMI_SHMEM_FLAG_INTR_ENABLED,
diff --git a/drivers/firmware/arm_scmi/smc.c b/drivers/firmware/arm_scmi/smc.c
index 745acfdd0b3d..87a7b13cf868 100644
--- a/drivers/firmware/arm_scmi/smc.c
+++ b/drivers/firmware/arm_scmi/smc.c
@@ -188,7 +188,7 @@ static int smc_send_message(struct scmi_chan_info *cinfo,
 	 */
 	smc_channel_lock_acquire(scmi_info, xfer);
 
-	shmem_tx_prepare(scmi_info->shmem, xfer);
+	shmem_tx_prepare(scmi_info->shmem, xfer, cinfo);
 
 	arm_smccc_1_1_invoke(scmi_info->func_id, 0, 0, 0, 0, 0, 0, 0, &res);
 
diff --git a/drivers/firmware/google/coreboot_table.c b/drivers/firmware/google/coreboot_table.c
index c52bcaa9def6..9ca21feb9d45 100644
--- a/drivers/firmware/google/coreboot_table.c
+++ b/drivers/firmware/google/coreboot_table.c
@@ -149,12 +149,8 @@ static int coreboot_table_probe(struct platform_device *pdev)
 	if (!ptr)
 		return -ENOMEM;
 
-	ret = bus_register(&coreboot_bus_type);
-	if (!ret) {
-		ret = coreboot_table_populate(dev, ptr);
-		if (ret)
-			bus_unregister(&coreboot_bus_type);
-	}
+	ret = coreboot_table_populate(dev, ptr);
+
 	memunmap(ptr);
 
 	return ret;
@@ -169,7 +165,6 @@ static int __cb_dev_unregister(struct device *dev, void *dummy)
 static int coreboot_table_remove(struct platform_device *pdev)
 {
 	bus_for_each_dev(&coreboot_bus_type, NULL, NULL, __cb_dev_unregister);
-	bus_unregister(&coreboot_bus_type);
 	return 0;
 }
 
@@ -199,6 +194,32 @@ static struct platform_driver coreboot_table_driver = {
 		.of_match_table = of_match_ptr(coreboot_of_match),
 	},
 };
-module_platform_driver(coreboot_table_driver);
+
+static int __init coreboot_table_driver_init(void)
+{
+	int ret;
+
+	ret = bus_register(&coreboot_bus_type);
+	if (ret)
+		return ret;
+
+	ret = platform_driver_register(&coreboot_table_driver);
+	if (ret) {
+		bus_unregister(&coreboot_bus_type);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit coreboot_table_driver_exit(void)
+{
+	platform_driver_unregister(&coreboot_table_driver);
+	bus_unregister(&coreboot_bus_type);
+}
+
+module_init(coreboot_table_driver_init);
+module_exit(coreboot_table_driver_exit);
+
 MODULE_AUTHOR("Google, Inc.");
 MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 9170aeaad93e..e0c960cc1d2e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4055,15 +4055,18 @@ void amdgpu_device_fini_sw(struct amdgpu_device *adev)
  * at suspend time.
  *
  */
-static void amdgpu_device_evict_resources(struct amdgpu_device *adev)
+static int amdgpu_device_evict_resources(struct amdgpu_device *adev)
 {
+	int ret;
+
 	/* No need to evict vram on APUs for suspend to ram or s2idle */
 	if ((adev->in_s3 || adev->in_s0ix) && (adev->flags & AMD_IS_APU))
-		return;
+		return 0;
 
-	if (amdgpu_ttm_evict_resources(adev, TTM_PL_VRAM))
+	ret = amdgpu_ttm_evict_resources(adev, TTM_PL_VRAM);
+	if (ret)
 		DRM_WARN("evicting device resources failed\n");
-
+	return ret;
 }
 
 /*
@@ -4113,7 +4116,9 @@ int amdgpu_device_suspend(struct drm_device *dev, bool fbcon)
 	if (!adev->in_s0ix)
 		amdgpu_amdkfd_suspend(adev, adev->in_runpm);
 
-	amdgpu_device_evict_resources(adev);
+	r = amdgpu_device_evict_resources(adev);
+	if (r)
+		return r;
 
 	amdgpu_fence_driver_hw_fini(adev);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
index 576849e95296..f69827aefb57 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
@@ -500,6 +500,8 @@ static int amdgpu_vkms_sw_init(void *handle)
 
 	adev_to_drm(adev)->mode_config.fb_base = adev->gmc.aper_base;
 
+	adev_to_drm(adev)->mode_config.fb_modifiers_not_supported = true;
+
 	r = amdgpu_display_modeset_create_props(adev);
 	if (r)
 		return r;
diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
index 2dd827472d6e..3bff0ae15e64 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -96,7 +96,14 @@ static int mes_v11_0_submit_pkt_and_poll_completion(struct amdgpu_mes *mes,
 	struct amdgpu_device *adev = mes->adev;
 	struct amdgpu_ring *ring = &mes->ring;
 	unsigned long flags;
+	signed long timeout = adev->usec_timeout;
 
+	if (amdgpu_emu_mode) {
+		timeout *= 100;
+	} else if (amdgpu_sriov_vf(adev)) {
+		/* Worst case in sriov where all other 15 VF timeout, each VF needs about 600ms */
+		timeout = 15 * 600 * 1000;
+	}
 	BUG_ON(size % 4 != 0);
 
 	spin_lock_irqsave(&mes->ring_lock, flags);
@@ -116,7 +123,7 @@ static int mes_v11_0_submit_pkt_and_poll_completion(struct amdgpu_mes *mes,
 	DRM_DEBUG("MES msg=%d was emitted\n", x_pkt->header.opcode);
 
 	r = amdgpu_fence_wait_polling(ring, ring->fence_drv.sync_seq,
-		      adev->usec_timeout * (amdgpu_emu_mode ? 100 : 1));
+		      timeout);
 	if (r < 1) {
 		DRM_ERROR("MES failed to response msg=%d\n",
 			  x_pkt->header.opcode);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 3be70848b202..7f8eb09b0b7c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -146,6 +146,14 @@ MODULE_FIRMWARE(FIRMWARE_NAVI12_DMCU);
 /* Number of bytes in PSP footer for firmware. */
 #define PSP_FOOTER_BYTES 0x100
 
+/*
+ * DMUB Async to Sync Mechanism Status
+ */
+#define DMUB_ASYNC_TO_SYNC_ACCESS_FAIL 1
+#define DMUB_ASYNC_TO_SYNC_ACCESS_TIMEOUT 2
+#define DMUB_ASYNC_TO_SYNC_ACCESS_SUCCESS 3
+#define DMUB_ASYNC_TO_SYNC_ACCESS_INVALID 4
+
 /**
  * DOC: overview
  *
@@ -1549,6 +1557,9 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 
 	adev->dm.dc->debug.visual_confirm = amdgpu_dc_visual_confirm;
 
+	/* TODO: Remove after DP2 receiver gets proper support of Cable ID feature */
+	adev->dm.dc->debug.ignore_cable_id = true;
+
 	r = dm_dmub_hw_init(adev);
 	if (r) {
 		DRM_ERROR("DMUB interface failed to initialize: status=%d\n", r);
@@ -1634,12 +1645,6 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 		}
 	}
 
-	if (amdgpu_dm_initialize_drm_device(adev)) {
-		DRM_ERROR(
-		"amdgpu: failed to initialize sw for display support.\n");
-		goto error;
-	}
-
 	/* Enable outbox notification only after IRQ handlers are registered and DMUB is alive.
 	 * It is expected that DMUB will resend any pending notifications at this point, for
 	 * example HPD from DPIA.
@@ -1647,6 +1652,12 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	if (dc_is_dmub_outbox_supported(adev->dm.dc))
 		dc_enable_dmub_outbox(adev->dm.dc);
 
+	if (amdgpu_dm_initialize_drm_device(adev)) {
+		DRM_ERROR(
+		"amdgpu: failed to initialize sw for display support.\n");
+		goto error;
+	}
+
 	/* create fake encoders for MST */
 	dm_dp_create_fake_mst_encoders(adev);
 
@@ -10146,6 +10157,8 @@ static int amdgpu_dm_set_dmub_async_sync_status(bool is_cmd_aux,
 			*operation_result = AUX_RET_ERROR_TIMEOUT;
 		} else if (status_type == DMUB_ASYNC_TO_SYNC_ACCESS_FAIL) {
 			*operation_result = AUX_RET_ERROR_ENGINE_ACQUIRE;
+		} else if (status_type == DMUB_ASYNC_TO_SYNC_ACCESS_INVALID) {
+			*operation_result = AUX_RET_ERROR_INVALID_REPLY;
 		} else {
 			*operation_result = AUX_RET_ERROR_UNKNOWN;
 		}
@@ -10193,6 +10206,16 @@ int amdgpu_dm_process_dmub_aux_transfer_sync(bool is_cmd_aux, struct dc_context
 			payload->reply[0] = adev->dm.dmub_notify->aux_reply.command;
 			if (!payload->write && adev->dm.dmub_notify->aux_reply.length &&
 			    payload->reply[0] == AUX_TRANSACTION_REPLY_AUX_ACK) {
+
+				if (payload->length != adev->dm.dmub_notify->aux_reply.length) {
+					DRM_WARN("invalid read from DPIA AUX %x(%d) got length %d!\n",
+							payload->address, payload->length,
+							adev->dm.dmub_notify->aux_reply.length);
+					return amdgpu_dm_set_dmub_async_sync_status(is_cmd_aux, ctx,
+							DMUB_ASYNC_TO_SYNC_ACCESS_INVALID,
+							(uint32_t *)operation_result);
+				}
+
 				memcpy(payload->data, adev->dm.dmub_notify->aux_reply.data,
 				       adev->dm.dmub_notify->aux_reply.length);
 			}
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index 90b306a1dd68..4f2228d742f4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -50,12 +50,6 @@
 
 #define AMDGPU_DMUB_NOTIFICATION_MAX 5
 
-/*
- * DMUB Async to Sync Mechanism Status
- */
-#define DMUB_ASYNC_TO_SYNC_ACCESS_FAIL 1
-#define DMUB_ASYNC_TO_SYNC_ACCESS_TIMEOUT 2
-#define DMUB_ASYNC_TO_SYNC_ACCESS_SUCCESS 3
 /*
 #include "include/amdgpu_dal_power_if.h"
 #include "amdgpu_dm_irq.h"
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
index 594fe8a4d02b..64dd02970292 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -412,7 +412,7 @@ int amdgpu_dm_crtc_init(struct amdgpu_display_manager *dm,
 {
 	struct amdgpu_crtc *acrtc = NULL;
 	struct drm_plane *cursor_plane;
-
+	bool is_dcn;
 	int res = -ENOMEM;
 
 	cursor_plane = kzalloc(sizeof(*cursor_plane), GFP_KERNEL);
@@ -450,8 +450,14 @@ int amdgpu_dm_crtc_init(struct amdgpu_display_manager *dm,
 	acrtc->otg_inst = -1;
 
 	dm->adev->mode_info.crtcs[crtc_index] = acrtc;
-	drm_crtc_enable_color_mgmt(&acrtc->base, MAX_COLOR_LUT_ENTRIES,
+
+	/* Don't enable DRM CRTC degamma property for DCE since it doesn't
+	 * support programmable degamma anywhere.
+	 */
+	is_dcn = dm->adev->dm.dc->caps.color.dpp.dcn_arch;
+	drm_crtc_enable_color_mgmt(&acrtc->base, is_dcn ? MAX_COLOR_LUT_ENTRIES : 0,
 				   true, MAX_COLOR_LUT_ENTRIES);
+
 	drm_mode_crtc_set_gamma_size(&acrtc->base, MAX_COLOR_LEGACY_LUT_ENTRIES);
 
 	return 0;
diff --git a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
index 09fbb7ad5362..de3a1f3fd4f1 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -2392,6 +2392,26 @@ static enum bp_result get_vram_info_v25(
 	return result;
 }
 
+static enum bp_result get_vram_info_v30(
+	struct bios_parser *bp,
+	struct dc_vram_info *info)
+{
+	struct atom_vram_info_header_v3_0 *info_v30;
+	enum bp_result result = BP_RESULT_OK;
+
+	info_v30 = GET_IMAGE(struct atom_vram_info_header_v3_0,
+						DATA_TABLES(vram_info));
+
+	if (info_v30 == NULL)
+		return BP_RESULT_BADBIOSTABLE;
+
+	info->num_chans = info_v30->channel_num;
+	info->dram_channel_width_bytes = (1 << info_v30->channel_width) / 8;
+
+	return result;
+}
+
+
 /*
  * get_integrated_info_v11
  *
@@ -3025,6 +3045,16 @@ static enum bp_result bios_parser_get_vram_info(
 			}
 			break;
 
+		case 3:
+			switch (revision.minor) {
+			case 0:
+				result = get_vram_info_v30(bp, info);
+				break;
+			default:
+				break;
+			}
+			break;
+
 		default:
 			return result;
 		}
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 598ce872a8d7..0f30df523fdf 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1262,16 +1262,6 @@ void dcn20_pipe_control_lock(
 					lock,
 					&hw_locks,
 					&inst_flags);
-	} else if (pipe->stream && pipe->stream->mall_stream_config.type == SUBVP_MAIN) {
-		union dmub_inbox0_cmd_lock_hw hw_lock_cmd = { 0 };
-		hw_lock_cmd.bits.command_code = DMUB_INBOX0_CMD__HW_LOCK;
-		hw_lock_cmd.bits.hw_lock_client = HW_LOCK_CLIENT_DRIVER;
-		hw_lock_cmd.bits.lock_pipe = 1;
-		hw_lock_cmd.bits.otg_inst = pipe->stream_res.tg->inst;
-		hw_lock_cmd.bits.lock = lock;
-		if (!lock)
-			hw_lock_cmd.bits.should_release = 1;
-		dmub_hw_lock_mgr_inbox0_cmd(dc->ctx->dmub_srv, hw_lock_cmd);
 	} else if (pipe->plane_state != NULL && pipe->plane_state->triplebuffer_flips) {
 		if (lock)
 			pipe->stream_res.tg->funcs->triplebuffer_lock(pipe->stream_res.tg);
@@ -1848,7 +1838,7 @@ void dcn20_post_unlock_program_front_end(
 
 			for (j = 0; j < TIMEOUT_FOR_PIPE_ENABLE_MS*1000
 					&& hubp->funcs->hubp_is_flip_pending(hubp); j++)
-				mdelay(1);
+				udelay(1);
 		}
 	}
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c
index 84e1486f3d51..39a57bcd7866 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c
@@ -87,6 +87,7 @@ static struct hubp_funcs dcn31_hubp_funcs = {
 	.hubp_init = hubp3_init,
 	.set_unbounded_requesting = hubp31_set_unbounded_requesting,
 	.hubp_soft_reset = hubp31_soft_reset,
+	.hubp_set_flip_int = hubp1_set_flip_int,
 	.hubp_in_blank = hubp1_in_blank,
 	.program_extended_blank = hubp31_program_extended_blank,
 };
diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_optc.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_optc.c
index 38aa28ec6b13..9c95ad145420 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_optc.c
@@ -237,7 +237,7 @@ static struct timing_generator_funcs dcn314_tg_funcs = {
 		.clear_optc_underflow = optc1_clear_optc_underflow,
 		.setup_global_swap_lock = NULL,
 		.get_crc = optc1_get_crc,
-		.configure_crc = optc2_configure_crc,
+		.configure_crc = optc1_configure_crc,
 		.set_dsc_config = optc3_set_dsc_config,
 		.get_dsc_status = optc2_get_dsc_status,
 		.set_dwb_source = NULL,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
index 1f195c5b3377..13cd1f2e50ca 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
@@ -187,7 +187,7 @@ bool dcn32_all_pipes_have_stream_and_plane(struct dc *dc,
 		struct pipe_ctx *pipe = &context->res_ctx.pipe_ctx[i];
 
 		if (!pipe->stream)
-			return false;
+			continue;
 
 		if (!pipe->plane_state)
 			return false;
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
index d34e0f1314d9..bc4f48ea8d4c 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
@@ -1228,6 +1228,7 @@ int dcn20_populate_dml_pipes_from_context(
 		pipes[pipe_cnt].pipe.src.dcc = false;
 		pipes[pipe_cnt].pipe.src.dcc_rate = 1;
 		pipes[pipe_cnt].pipe.dest.synchronized_vblank_all_planes = synchronized_vblank;
+		pipes[pipe_cnt].pipe.dest.synchronize_timings = synchronized_vblank;
 		pipes[pipe_cnt].pipe.dest.hblank_start = timing->h_total - timing->h_front_porch;
 		pipes[pipe_cnt].pipe.dest.hblank_end = pipes[pipe_cnt].pipe.dest.hblank_start
 				- timing->h_addressable
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
index 52525833a99b..bea380407151 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
@@ -364,7 +364,8 @@ static void DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerforman
 	for (k = 0; k < mode_lib->vba.NumberOfActiveSurfaces; ++k) {
 		v->DSCDelay[k] = dml32_DSCDelayRequirement(mode_lib->vba.DSCEnabled[k],
 				mode_lib->vba.ODMCombineEnabled[k], mode_lib->vba.DSCInputBitPerComponent[k],
-				mode_lib->vba.OutputBpp[k], mode_lib->vba.HActive[k], mode_lib->vba.HTotal[k],
+				mode_lib->vba.OutputBppPerState[mode_lib->vba.VoltageLevel][k],
+				mode_lib->vba.HActive[k], mode_lib->vba.HTotal[k],
 				mode_lib->vba.NumberOfDSCSlices[k], mode_lib->vba.OutputFormat[k],
 				mode_lib->vba.Output[k], mode_lib->vba.PixelClock[k],
 				mode_lib->vba.PixelClockBackEnd[k]);
@@ -717,6 +718,8 @@ static void DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerforman
 
 	do {
 		MaxTotalRDBandwidth = 0;
+		DestinationLineTimesForPrefetchLessThan2 = false;
+		VRatioPrefetchMoreThanMax = false;
 #ifdef __DML_VBA_DEBUG__
 		dml_print("DML::%s: Start loop: VStartup = %d\n", __func__, mode_lib->vba.VStartupLines);
 #endif
@@ -1627,7 +1630,7 @@ static void mode_support_configuration(struct vba_vars_st *v,
 				&& !mode_lib->vba.MSOOrODMSplitWithNonDPLink
 				&& !mode_lib->vba.NotEnoughLanesForMSO
 				&& mode_lib->vba.LinkCapacitySupport[i] == true && !mode_lib->vba.P2IWith420
-				&& !mode_lib->vba.DSCOnlyIfNecessaryWithBPP
+				//&& !mode_lib->vba.DSCOnlyIfNecessaryWithBPP
 				&& !mode_lib->vba.DSC422NativeNotSupported
 				&& !mode_lib->vba.MPCCombineMethodIncompatible
 				&& mode_lib->vba.ODMCombine2To1SupportCheckOK[i] == true
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
index 365d290bba99..67af8f4df8b8 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
@@ -1746,7 +1746,7 @@ unsigned int dml32_DSCDelayRequirement(bool DSCEnabled,
 		}
 
 		DSCDelayRequirement_val = DSCDelayRequirement_val + (HTotal - HActive) *
-				dml_ceil(DSCDelayRequirement_val / HActive, 1);
+				dml_ceil((double)DSCDelayRequirement_val / HActive, 1);
 
 		DSCDelayRequirement_val = DSCDelayRequirement_val * PixelClock / PixelClockBackEnd;
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
index a1276f6b9581..395ae8761980 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
@@ -291,8 +291,8 @@ void dml32_rq_dlg_get_dlg_reg(struct display_mode_lib *mode_lib,
 
 	dml_print("DML_DLG: %s: vready_after_vcount0 = %d\n", __func__, dlg_regs->vready_after_vcount0);
 
-	dst_x_after_scaler = get_dst_x_after_scaler(mode_lib, e2e_pipe_param, num_pipes, pipe_idx);
-	dst_y_after_scaler = get_dst_y_after_scaler(mode_lib, e2e_pipe_param, num_pipes, pipe_idx);
+	dst_x_after_scaler = dml_ceil(get_dst_x_after_scaler(mode_lib, e2e_pipe_param, num_pipes, pipe_idx), 1);
+	dst_y_after_scaler = dml_ceil(get_dst_y_after_scaler(mode_lib, e2e_pipe_param, num_pipes, pipe_idx), 1);
 
 	// do some adjustment on the dst_after scaler to account for odm combine mode
 	dml_print("DML_DLG: %s: input dst_x_after_scaler   = %d\n", __func__, dst_x_after_scaler);
diff --git a/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c b/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c
index 503e7d984ff0..cb34ac0af349 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c
@@ -624,7 +624,7 @@ static void fetch_pipe_params(struct display_mode_lib *mode_lib)
 		mode_lib->vba.skip_dio_check[mode_lib->vba.NumberOfActivePlanes] =
 				dout->is_virtual;
 
-		if (!dout->dsc_enable)
+		if (dout->dsc_enable)
 			mode_lib->vba.ForcedOutputLinkBPP[mode_lib->vba.NumberOfActivePlanes] = dout->output_bpp;
 		else
 			mode_lib->vba.ForcedOutputLinkBPP[mode_lib->vba.NumberOfActivePlanes] = 0.0;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
index 7510d470b864..2347f7bb73d7 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1131,22 +1131,21 @@ static int smu_smc_hw_setup(struct smu_context *smu)
 	uint64_t features_supported;
 	int ret = 0;
 
-	if (adev->in_suspend && smu_is_dpm_running(smu)) {
-		dev_info(adev->dev, "dpm has been enabled\n");
-		/* this is needed specifically */
-		switch (adev->ip_versions[MP1_HWIP][0]) {
-		case IP_VERSION(11, 0, 7):
-		case IP_VERSION(11, 0, 11):
-		case IP_VERSION(11, 5, 0):
-		case IP_VERSION(11, 0, 12):
+	switch (adev->ip_versions[MP1_HWIP][0]) {
+	case IP_VERSION(11, 0, 7):
+	case IP_VERSION(11, 0, 11):
+	case IP_VERSION(11, 5, 0):
+	case IP_VERSION(11, 0, 12):
+		if (adev->in_suspend && smu_is_dpm_running(smu)) {
+			dev_info(adev->dev, "dpm has been enabled\n");
 			ret = smu_system_features_control(smu, true);
 			if (ret)
 				dev_err(adev->dev, "Failed system features control!\n");
-			break;
-		default:
-			break;
+			return ret;
 		}
-		return ret;
+		break;
+	default:
+		break;
 	}
 
 	ret = smu_init_display_count(smu, 0);
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
index b81c657c7386..d63cf9e3676d 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
@@ -1372,6 +1372,14 @@ enum smu_cmn2asic_mapping_type {
 	CMN2ASIC_MAPPING_WORKLOAD,
 };
 
+enum smu_baco_seq {
+	BACO_SEQ_BACO = 0,
+	BACO_SEQ_MSR,
+	BACO_SEQ_BAMACO,
+	BACO_SEQ_ULPS,
+	BACO_SEQ_COUNT,
+};
+
 #define MSG_MAP(msg, index, valid_in_vf) \
 	[SMU_MSG_##msg] = {1, (index), (valid_in_vf)}
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v11_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v11_0.h
index a9215494dcdd..d466db6f0ad4 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v11_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v11_0.h
@@ -147,14 +147,6 @@ struct smu_11_5_power_context {
 	uint32_t	max_fast_ppt_limit;
 };
 
-enum smu_v11_0_baco_seq {
-	BACO_SEQ_BACO = 0,
-	BACO_SEQ_MSR,
-	BACO_SEQ_BAMACO,
-	BACO_SEQ_ULPS,
-	BACO_SEQ_COUNT,
-};
-
 #if defined(SWSMU_CODE_LAYER_L2) || defined(SWSMU_CODE_LAYER_L3)
 
 int smu_v11_0_init_microcode(struct smu_context *smu);
@@ -257,7 +249,7 @@ int smu_v11_0_baco_enter(struct smu_context *smu);
 int smu_v11_0_baco_exit(struct smu_context *smu);
 
 int smu_v11_0_baco_set_armd3_sequence(struct smu_context *smu,
-				      enum smu_v11_0_baco_seq baco_seq);
+				      enum smu_baco_seq baco_seq);
 
 int smu_v11_0_mode1_reset(struct smu_context *smu);
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
index f75b9688f512..3e29fe4cc4ae 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -123,14 +123,6 @@ struct smu_13_0_power_context {
 	enum smu_13_0_power_state power_state;
 };
 
-enum smu_v13_0_baco_seq {
-	BACO_SEQ_BACO = 0,
-	BACO_SEQ_MSR,
-	BACO_SEQ_BAMACO,
-	BACO_SEQ_ULPS,
-	BACO_SEQ_COUNT,
-};
-
 #if defined(SWSMU_CODE_LAYER_L2) || defined(SWSMU_CODE_LAYER_L3)
 
 int smu_v13_0_init_microcode(struct smu_context *smu);
@@ -217,6 +209,9 @@ int smu_v13_0_set_azalia_d3_pme(struct smu_context *smu);
 int smu_v13_0_get_max_sustainable_clocks_by_dc(struct smu_context *smu,
 					       struct pp_smu_nv_clock_table *max_clocks);
 
+int smu_v13_0_baco_set_armd3_sequence(struct smu_context *smu,
+				      enum smu_baco_seq baco_seq);
+
 bool smu_v13_0_baco_is_support(struct smu_context *smu);
 
 enum smu_baco_state smu_v13_0_baco_get_state(struct smu_context *smu);
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
index dccbd9f70723..70b560737687 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -1576,7 +1576,7 @@ int smu_v11_0_set_azalia_d3_pme(struct smu_context *smu)
 }
 
 int smu_v11_0_baco_set_armd3_sequence(struct smu_context *smu,
-				      enum smu_v11_0_baco_seq baco_seq)
+				      enum smu_baco_seq baco_seq)
 {
 	return smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_ArmD3, baco_seq, NULL);
 }
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index 750d8da84fac..33710dcf1eb1 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -2219,6 +2219,15 @@ int smu_v13_0_gfx_ulv_control(struct smu_context *smu,
 	return ret;
 }
 
+int smu_v13_0_baco_set_armd3_sequence(struct smu_context *smu,
+				      enum smu_baco_seq baco_seq)
+{
+	return smu_cmn_send_smc_msg_with_param(smu,
+					       SMU_MSG_ArmD3,
+					       baco_seq,
+					       NULL);
+}
+
 bool smu_v13_0_baco_is_support(struct smu_context *smu)
 {
 	struct smu_baco_context *smu_baco = &smu->smu_baco;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index 29529328152d..f0121d171630 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -120,6 +120,7 @@ static struct cmn2asic_msg_mapping smu_v13_0_0_message_map[SMU_MSG_MAX_COUNT] =
 	MSG_MAP(Mode1Reset,			PPSMC_MSG_Mode1Reset,                  0),
 	MSG_MAP(PrepareMp1ForUnload,		PPSMC_MSG_PrepareMp1ForUnload,         0),
 	MSG_MAP(DFCstateControl,		PPSMC_MSG_SetExternalClientDfCstateAllow, 0),
+	MSG_MAP(ArmD3,				PPSMC_MSG_ArmD3,                       0),
 };
 
 static struct cmn2asic_mapping smu_v13_0_0_clk_map[SMU_CLK_COUNT] = {
@@ -1566,6 +1567,31 @@ static int smu_v13_0_0_set_power_profile_mode(struct smu_context *smu,
 					       NULL);
 }
 
+static int smu_v13_0_0_baco_enter(struct smu_context *smu)
+{
+	struct smu_baco_context *smu_baco = &smu->smu_baco;
+	struct amdgpu_device *adev = smu->adev;
+
+	if (adev->in_runpm && smu_cmn_is_audio_func_enabled(adev))
+		return smu_v13_0_baco_set_armd3_sequence(smu,
+				smu_baco->maco_support ? BACO_SEQ_BAMACO : BACO_SEQ_BACO);
+	else
+		return smu_v13_0_baco_enter(smu);
+}
+
+static int smu_v13_0_0_baco_exit(struct smu_context *smu)
+{
+	struct amdgpu_device *adev = smu->adev;
+
+	if (adev->in_runpm && smu_cmn_is_audio_func_enabled(adev)) {
+		/* Wait for PMFW handling for the Dstate change */
+		usleep_range(10000, 11000);
+		return smu_v13_0_baco_set_armd3_sequence(smu, BACO_SEQ_ULPS);
+	} else {
+		return smu_v13_0_baco_exit(smu);
+	}
+}
+
 static bool smu_v13_0_0_is_mode1_reset_supported(struct smu_context *smu)
 {
 	struct amdgpu_device *adev = smu->adev;
@@ -1827,8 +1853,8 @@ static const struct pptable_funcs smu_v13_0_0_ppt_funcs = {
 	.baco_is_support = smu_v13_0_baco_is_support,
 	.baco_get_state = smu_v13_0_baco_get_state,
 	.baco_set_state = smu_v13_0_baco_set_state,
-	.baco_enter = smu_v13_0_baco_enter,
-	.baco_exit = smu_v13_0_baco_exit,
+	.baco_enter = smu_v13_0_0_baco_enter,
+	.baco_exit = smu_v13_0_0_baco_exit,
 	.mode1_reset_is_support = smu_v13_0_0_is_mode1_reset_supported,
 	.mode1_reset = smu_v13_0_mode1_reset,
 	.set_mp1_state = smu_v13_0_0_set_mp1_state,
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index c4102cfb734c..d74debc584f8 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -122,6 +122,7 @@ static struct cmn2asic_msg_mapping smu_v13_0_7_message_map[SMU_MSG_MAX_COUNT] =
 	MSG_MAP(PrepareMp1ForUnload,		PPSMC_MSG_PrepareMp1ForUnload,         0),
 	MSG_MAP(SetMGpuFanBoostLimitRpm,	PPSMC_MSG_SetMGpuFanBoostLimitRpm,     0),
 	MSG_MAP(DFCstateControl,		PPSMC_MSG_SetExternalClientDfCstateAllow, 0),
+	MSG_MAP(ArmD3,				PPSMC_MSG_ArmD3,                       0),
 };
 
 static struct cmn2asic_mapping smu_v13_0_7_clk_map[SMU_CLK_COUNT] = {
@@ -1578,6 +1579,31 @@ static int smu_v13_0_7_set_mp1_state(struct smu_context *smu,
 	return ret;
 }
 
+static int smu_v13_0_7_baco_enter(struct smu_context *smu)
+{
+	struct smu_baco_context *smu_baco = &smu->smu_baco;
+	struct amdgpu_device *adev = smu->adev;
+
+	if (adev->in_runpm && smu_cmn_is_audio_func_enabled(adev))
+		return smu_v13_0_baco_set_armd3_sequence(smu,
+				smu_baco->maco_support ? BACO_SEQ_BAMACO : BACO_SEQ_BACO);
+	else
+		return smu_v13_0_baco_enter(smu);
+}
+
+static int smu_v13_0_7_baco_exit(struct smu_context *smu)
+{
+	struct amdgpu_device *adev = smu->adev;
+
+	if (adev->in_runpm && smu_cmn_is_audio_func_enabled(adev)) {
+		/* Wait for PMFW handling for the Dstate change */
+		usleep_range(10000, 11000);
+		return smu_v13_0_baco_set_armd3_sequence(smu, BACO_SEQ_ULPS);
+	} else {
+		return smu_v13_0_baco_exit(smu);
+	}
+}
+
 static bool smu_v13_0_7_is_mode1_reset_supported(struct smu_context *smu)
 {
 	struct amdgpu_device *adev = smu->adev;
@@ -1655,8 +1681,8 @@ static const struct pptable_funcs smu_v13_0_7_ppt_funcs = {
 	.baco_is_support = smu_v13_0_baco_is_support,
 	.baco_get_state = smu_v13_0_baco_get_state,
 	.baco_set_state = smu_v13_0_baco_set_state,
-	.baco_enter = smu_v13_0_baco_enter,
-	.baco_exit = smu_v13_0_baco_exit,
+	.baco_enter = smu_v13_0_7_baco_enter,
+	.baco_exit = smu_v13_0_7_baco_exit,
 	.mode1_reset_is_support = smu_v13_0_7_is_mode1_reset_supported,
 	.mode1_reset = smu_v13_0_mode1_reset,
 	.set_mp1_state = smu_v13_0_7_set_mp1_state,
diff --git a/drivers/gpu/drm/display/drm_dp_dual_mode_helper.c b/drivers/gpu/drm/display/drm_dp_dual_mode_helper.c
index 3ea53bb67d3b..bd61e20770a5 100644
--- a/drivers/gpu/drm/display/drm_dp_dual_mode_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_dual_mode_helper.c
@@ -63,23 +63,45 @@
 ssize_t drm_dp_dual_mode_read(struct i2c_adapter *adapter,
 			      u8 offset, void *buffer, size_t size)
 {
+	u8 zero = 0;
+	char *tmpbuf = NULL;
+	/*
+	 * As sub-addressing is not supported by all adaptors,
+	 * always explicitly read from the start and discard
+	 * any bytes that come before the requested offset.
+	 * This way, no matter whether the adaptor supports it
+	 * or not, we'll end up reading the proper data.
+	 */
 	struct i2c_msg msgs[] = {
 		{
 			.addr = DP_DUAL_MODE_SLAVE_ADDRESS,
 			.flags = 0,
 			.len = 1,
-			.buf = &offset,
+			.buf = &zero,
 		},
 		{
 			.addr = DP_DUAL_MODE_SLAVE_ADDRESS,
 			.flags = I2C_M_RD,
-			.len = size,
+			.len = size + offset,
 			.buf = buffer,
 		},
 	};
 	int ret;
 
+	if (offset) {
+		tmpbuf = kmalloc(size + offset, GFP_KERNEL);
+		if (!tmpbuf)
+			return -ENOMEM;
+
+		msgs[1].buf = tmpbuf;
+	}
+
 	ret = i2c_transfer(adapter, msgs, ARRAY_SIZE(msgs));
+	if (tmpbuf)
+		memcpy(buffer, tmpbuf + offset, size);
+
+	kfree(tmpbuf);
+
 	if (ret < 0)
 		return ret;
 	if (ret != ARRAY_SIZE(msgs))
@@ -208,18 +230,6 @@ enum drm_dp_dual_mode_type drm_dp_dual_mode_detect(const struct drm_device *dev,
 	if (ret)
 		return DRM_DP_DUAL_MODE_UNKNOWN;
 
-	/*
-	 * Sigh. Some (maybe all?) type 1 adaptors are broken and ack
-	 * the offset but ignore it, and instead they just always return
-	 * data from the start of the HDMI ID buffer. So for a broken
-	 * type 1 HDMI adaptor a single byte read will always give us
-	 * 0x44, and for a type 1 DVI adaptor it should give 0x00
-	 * (assuming it implements any registers). Fortunately neither
-	 * of those values will match the type 2 signature of the
-	 * DP_DUAL_MODE_ADAPTOR_ID register so we can proceed with
-	 * the type 2 adaptor detection safely even in the presence
-	 * of broken type 1 adaptors.
-	 */
 	ret = drm_dp_dual_mode_read(adapter, DP_DUAL_MODE_ADAPTOR_ID,
 				    &adaptor_id, sizeof(adaptor_id));
 	drm_dbg_kms(dev, "DP dual mode adaptor ID: %02x (err %zd)\n", adaptor_id, ret);
@@ -233,11 +243,10 @@ enum drm_dp_dual_mode_type drm_dp_dual_mode_detect(const struct drm_device *dev,
 				return DRM_DP_DUAL_MODE_TYPE2_DVI;
 		}
 		/*
-		 * If neither a proper type 1 ID nor a broken type 1 adaptor
-		 * as described above, assume type 1, but let the user know
-		 * that we may have misdetected the type.
+		 * If not a proper type 1 ID, still assume type 1, but let
+		 * the user know that we may have misdetected the type.
 		 */
-		if (!is_type1_adaptor(adaptor_id) && adaptor_id != hdmi_id[0])
+		if (!is_type1_adaptor(adaptor_id))
 			drm_err(dev, "Unexpected DP dual mode adaptor ID %02x\n", adaptor_id);
 
 	}
@@ -343,10 +352,8 @@ EXPORT_SYMBOL(drm_dp_dual_mode_get_tmds_output);
  * @enable: enable (as opposed to disable) the TMDS output buffers
  *
  * Set the state of the TMDS output buffers in the adaptor. For
- * type2 this is set via the DP_DUAL_MODE_TMDS_OEN register. As
- * some type 1 adaptors have problems with registers (see comments
- * in drm_dp_dual_mode_detect()) we avoid touching the register,
- * making this function a no-op on type 1 adaptors.
+ * type2 this is set via the DP_DUAL_MODE_TMDS_OEN register.
+ * Type1 adaptors do not support any register writes.
  *
  * Returns:
  * 0 on success, negative error code on failure
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 8214a0b1ab7f..203bf8d6c34c 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -615,7 +615,7 @@ static int drm_dev_init(struct drm_device *dev,
 	mutex_init(&dev->clientlist_mutex);
 	mutex_init(&dev->master_mutex);
 
-	ret = drmm_add_action(dev, drm_dev_init_release, NULL);
+	ret = drmm_add_action_or_reset(dev, drm_dev_init_release, NULL);
 	if (ret)
 		return ret;
 
diff --git a/drivers/gpu/drm/drm_internal.h b/drivers/gpu/drm/drm_internal.h
index 7bb98e6a446d..5ea5e260118c 100644
--- a/drivers/gpu/drm/drm_internal.h
+++ b/drivers/gpu/drm/drm_internal.h
@@ -104,7 +104,8 @@ static inline void drm_vblank_flush_worker(struct drm_vblank_crtc *vblank)
 
 static inline void drm_vblank_destroy_worker(struct drm_vblank_crtc *vblank)
 {
-	kthread_destroy_worker(vblank->worker);
+	if (vblank->worker)
+		kthread_destroy_worker(vblank->worker);
 }
 
 int drm_vblank_worker_init(struct drm_vblank_crtc *vblank);
diff --git a/drivers/gpu/drm/imx/imx-tve.c b/drivers/gpu/drm/imx/imx-tve.c
index 6b34fac3f73a..ab4d1c878fda 100644
--- a/drivers/gpu/drm/imx/imx-tve.c
+++ b/drivers/gpu/drm/imx/imx-tve.c
@@ -218,8 +218,9 @@ static int imx_tve_connector_get_modes(struct drm_connector *connector)
 	return ret;
 }
 
-static int imx_tve_connector_mode_valid(struct drm_connector *connector,
-					struct drm_display_mode *mode)
+static enum drm_mode_status
+imx_tve_connector_mode_valid(struct drm_connector *connector,
+			     struct drm_display_mode *mode)
 {
 	struct imx_tve *tve = con_to_tve(connector);
 	unsigned long rate;
diff --git a/drivers/gpu/drm/lima/lima_devfreq.c b/drivers/gpu/drm/lima/lima_devfreq.c
index 011be7ff51e1..bc8fb4e38d0a 100644
--- a/drivers/gpu/drm/lima/lima_devfreq.c
+++ b/drivers/gpu/drm/lima/lima_devfreq.c
@@ -112,11 +112,6 @@ int lima_devfreq_init(struct lima_device *ldev)
 	unsigned long cur_freq;
 	int ret;
 	const char *regulator_names[] = { "mali", NULL };
-	const char *clk_names[] = { "core", NULL };
-	struct dev_pm_opp_config config = {
-		.regulator_names = regulator_names,
-		.clk_names = clk_names,
-	};
 
 	if (!device_property_present(dev, "operating-points-v2"))
 		/* Optional, continue without devfreq */
@@ -124,7 +119,15 @@ int lima_devfreq_init(struct lima_device *ldev)
 
 	spin_lock_init(&ldevfreq->lock);
 
-	ret = devm_pm_opp_set_config(dev, &config);
+	/*
+	 * clkname is set separately so it is not affected by the optional
+	 * regulator setting which may return error.
+	 */
+	ret = devm_pm_opp_set_clkname(dev, "core");
+	if (ret)
+		return ret;
+
+	ret = devm_pm_opp_set_regulators(dev, regulator_names);
 	if (ret) {
 		/* Continue if the optional regulator is missing */
 		if (ret != -ENODEV)
diff --git a/drivers/gpu/drm/msm/adreno/adreno_device.c b/drivers/gpu/drm/msm/adreno/adreno_device.c
index 24b489b6129a..628806423f7d 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -679,6 +679,9 @@ static int adreno_system_suspend(struct device *dev)
 	struct msm_gpu *gpu = dev_to_gpu(dev);
 	int remaining, ret;
 
+	if (!gpu)
+		return 0;
+
 	suspend_scheduler(gpu);
 
 	remaining = wait_event_timeout(gpu->retire_event,
@@ -700,7 +703,12 @@ static int adreno_system_suspend(struct device *dev)
 
 static int adreno_system_resume(struct device *dev)
 {
-	resume_scheduler(dev_to_gpu(dev));
+	struct msm_gpu *gpu = dev_to_gpu(dev);
+
+	if (!gpu)
+		return 0;
+
+	resume_scheduler(gpu);
 	return pm_runtime_force_resume(dev);
 }
 
diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index c2bfcf3f1f40..01aae792ffa9 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -993,4 +993,6 @@ void msm_gpu_cleanup(struct msm_gpu *gpu)
 	}
 
 	msm_devfreq_cleanup(gpu);
+
+	platform_set_drvdata(gpu->pdev, NULL);
 }
diff --git a/drivers/gpu/drm/msm/msm_gpu.h b/drivers/gpu/drm/msm/msm_gpu.h
index 4d935fedd2ac..fd22cf4041af 100644
--- a/drivers/gpu/drm/msm/msm_gpu.h
+++ b/drivers/gpu/drm/msm/msm_gpu.h
@@ -282,6 +282,10 @@ struct msm_gpu {
 static inline struct msm_gpu *dev_to_gpu(struct device *dev)
 {
 	struct adreno_smmu_priv *adreno_smmu = dev_get_drvdata(dev);
+
+	if (!adreno_smmu)
+		return NULL;
+
 	return container_of(adreno_smmu, struct msm_gpu, adreno_smmu);
 }
 
diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 1e716c23019a..eb938bfb0573 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2505,6 +2505,7 @@ static const struct display_timing logictechno_lt161010_2nh_timing = {
 static const struct panel_desc logictechno_lt161010_2nh = {
 	.timings = &logictechno_lt161010_2nh_timing,
 	.num_timings = 1,
+	.bpc = 6,
 	.size = {
 		.width = 154,
 		.height = 86,
@@ -2534,6 +2535,7 @@ static const struct display_timing logictechno_lt170410_2whc_timing = {
 static const struct panel_desc logictechno_lt170410_2whc = {
 	.timings = &logictechno_lt170410_2whc_timing,
 	.num_timings = 1,
+	.bpc = 8,
 	.size = {
 		.width = 217,
 		.height = 136,
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index f9aa8b96c695..1fc04019dfd8 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -878,10 +878,14 @@ static void vop2_crtc_atomic_disable(struct drm_crtc *crtc,
 {
 	struct vop2_video_port *vp = to_vop2_video_port(crtc);
 	struct vop2 *vop2 = vp->vop2;
+	struct drm_crtc_state *old_crtc_state;
 	int ret;
 
 	vop2_lock(vop2);
 
+	old_crtc_state = drm_atomic_get_old_crtc_state(state, crtc);
+	drm_atomic_helper_disable_planes_on_crtc(old_crtc_state, false);
+
 	drm_crtc_vblank_off(crtc);
 
 	/*
@@ -997,13 +1001,15 @@ static int vop2_plane_atomic_check(struct drm_plane *plane,
 static void vop2_plane_atomic_disable(struct drm_plane *plane,
 				      struct drm_atomic_state *state)
 {
-	struct drm_plane_state *old_pstate = drm_atomic_get_old_plane_state(state, plane);
+	struct drm_plane_state *old_pstate = NULL;
 	struct vop2_win *win = to_vop2_win(plane);
 	struct vop2 *vop2 = win->vop2;
 
 	drm_dbg(vop2->drm, "%s disable\n", win->data->name);
 
-	if (!old_pstate->crtc)
+	if (state)
+		old_pstate = drm_atomic_get_old_plane_state(state, plane);
+	if (old_pstate && !old_pstate->crtc)
 		return;
 
 	vop2_win_disable(win);
diff --git a/drivers/gpu/drm/scheduler/sched_entity.c b/drivers/gpu/drm/scheduler/sched_entity.c
index 6b25b2f4f5a3..7ef1a086a6fb 100644
--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -207,6 +207,7 @@ static void drm_sched_entity_kill_jobs_cb(struct dma_fence *f,
 	struct drm_sched_job *job = container_of(cb, struct drm_sched_job,
 						 finish_cb);
 
+	dma_fence_put(f);
 	INIT_WORK(&job->work, drm_sched_entity_kill_jobs_work);
 	schedule_work(&job->work);
 }
@@ -234,8 +235,10 @@ static void drm_sched_entity_kill_jobs(struct drm_sched_entity *entity)
 		struct drm_sched_fence *s_fence = job->s_fence;
 
 		/* Wait for all dependencies to avoid data corruptions */
-		while ((f = drm_sched_job_dependency(job, entity)))
+		while ((f = drm_sched_job_dependency(job, entity))) {
 			dma_fence_wait(f, false);
+			dma_fence_put(f);
+		}
 
 		drm_sched_fence_scheduled(s_fence);
 		dma_fence_set_error(&s_fence->finished, -ESRCH);
@@ -250,6 +253,7 @@ static void drm_sched_entity_kill_jobs(struct drm_sched_entity *entity)
 			continue;
 		}
 
+		dma_fence_get(entity->last_scheduled);
 		r = dma_fence_add_callback(entity->last_scheduled,
 					   &job->finish_cb,
 					   drm_sched_entity_kill_jobs_cb);
diff --git a/drivers/gpu/drm/vc4/vc4_kms.c b/drivers/gpu/drm/vc4/vc4_kms.c
index b45dcdfd7306..a3678178b022 100644
--- a/drivers/gpu/drm/vc4/vc4_kms.c
+++ b/drivers/gpu/drm/vc4/vc4_kms.c
@@ -198,8 +198,8 @@ vc4_hvs_get_new_global_state(struct drm_atomic_state *state)
 	struct drm_private_state *priv_state;
 
 	priv_state = drm_atomic_get_new_private_obj_state(state, &vc4->hvs_channels);
-	if (IS_ERR(priv_state))
-		return ERR_CAST(priv_state);
+	if (!priv_state)
+		return ERR_PTR(-EINVAL);
 
 	return to_vc4_hvs_state(priv_state);
 }
@@ -211,8 +211,8 @@ vc4_hvs_get_old_global_state(struct drm_atomic_state *state)
 	struct drm_private_state *priv_state;
 
 	priv_state = drm_atomic_get_old_private_obj_state(state, &vc4->hvs_channels);
-	if (IS_ERR(priv_state))
-		return ERR_CAST(priv_state);
+	if (!priv_state)
+		return ERR_PTR(-EINVAL);
 
 	return to_vc4_hvs_state(priv_state);
 }
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index a176296f4fff..e46561e095c6 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1243,6 +1243,7 @@ static const struct {
 	 */
 	{ "Latitude 5480",      0x29 },
 	{ "Vostro V131",        0x1d },
+	{ "Vostro 5568",        0x29 },
 };
 
 static void register_dell_lis3lv02d_i2c_device(struct i801_priv *priv)
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 031c78ac42e6..a24cc413c89b 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -284,6 +284,7 @@ struct tegra_i2c_dev {
 	struct dma_chan *tx_dma_chan;
 	struct dma_chan *rx_dma_chan;
 	unsigned int dma_buf_size;
+	struct device *dma_dev;
 	dma_addr_t dma_phys;
 	void *dma_buf;
 
@@ -420,7 +421,7 @@ static int tegra_i2c_dma_submit(struct tegra_i2c_dev *i2c_dev, size_t len)
 static void tegra_i2c_release_dma(struct tegra_i2c_dev *i2c_dev)
 {
 	if (i2c_dev->dma_buf) {
-		dma_free_coherent(i2c_dev->dev, i2c_dev->dma_buf_size,
+		dma_free_coherent(i2c_dev->dma_dev, i2c_dev->dma_buf_size,
 				  i2c_dev->dma_buf, i2c_dev->dma_phys);
 		i2c_dev->dma_buf = NULL;
 	}
@@ -467,10 +468,13 @@ static int tegra_i2c_init_dma(struct tegra_i2c_dev *i2c_dev)
 
 	i2c_dev->tx_dma_chan = chan;
 
+	WARN_ON(i2c_dev->tx_dma_chan->device != i2c_dev->rx_dma_chan->device);
+	i2c_dev->dma_dev = chan->device->dev;
+
 	i2c_dev->dma_buf_size = i2c_dev->hw->quirks->max_write_len +
 				I2C_PACKET_HEADER_SIZE;
 
-	dma_buf = dma_alloc_coherent(i2c_dev->dev, i2c_dev->dma_buf_size,
+	dma_buf = dma_alloc_coherent(i2c_dev->dma_dev, i2c_dev->dma_buf_size,
 				     &dma_phys, GFP_KERNEL | __GFP_NOWARN);
 	if (!dma_buf) {
 		dev_err(i2c_dev->dev, "failed to allocate DMA buffer\n");
@@ -1267,7 +1271,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 
 	if (i2c_dev->dma_mode) {
 		if (i2c_dev->msg_read) {
-			dma_sync_single_for_device(i2c_dev->dev,
+			dma_sync_single_for_device(i2c_dev->dma_dev,
 						   i2c_dev->dma_phys,
 						   xfer_size, DMA_FROM_DEVICE);
 
@@ -1275,7 +1279,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 			if (err)
 				return err;
 		} else {
-			dma_sync_single_for_cpu(i2c_dev->dev,
+			dma_sync_single_for_cpu(i2c_dev->dma_dev,
 						i2c_dev->dma_phys,
 						xfer_size, DMA_TO_DEVICE);
 		}
@@ -1288,7 +1292,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 			memcpy(i2c_dev->dma_buf + I2C_PACKET_HEADER_SIZE,
 			       msg->buf, msg->len);
 
-			dma_sync_single_for_device(i2c_dev->dev,
+			dma_sync_single_for_device(i2c_dev->dma_dev,
 						   i2c_dev->dma_phys,
 						   xfer_size, DMA_TO_DEVICE);
 
@@ -1339,7 +1343,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 		}
 
 		if (i2c_dev->msg_read && i2c_dev->msg_err == I2C_ERR_NONE) {
-			dma_sync_single_for_cpu(i2c_dev->dev,
+			dma_sync_single_for_cpu(i2c_dev->dma_dev,
 						i2c_dev->dma_phys,
 						xfer_size, DMA_FROM_DEVICE);
 
diff --git a/drivers/iio/accel/bma400_core.c b/drivers/iio/accel/bma400_core.c
index c31bdd9b168e..29c9fa99c2bd 100644
--- a/drivers/iio/accel/bma400_core.c
+++ b/drivers/iio/accel/bma400_core.c
@@ -737,18 +737,6 @@ static int bma400_init(struct bma400_data *data)
 	unsigned int val;
 	int ret;
 
-	/* Try to read chip_id register. It must return 0x90. */
-	ret = regmap_read(data->regmap, BMA400_CHIP_ID_REG, &val);
-	if (ret) {
-		dev_err(data->dev, "Failed to read chip id register\n");
-		return ret;
-	}
-
-	if (val != BMA400_ID_REG_VAL) {
-		dev_err(data->dev, "Chip ID mismatch\n");
-		return -ENODEV;
-	}
-
 	data->regulators[BMA400_VDD_REGULATOR].supply = "vdd";
 	data->regulators[BMA400_VDDIO_REGULATOR].supply = "vddio";
 	ret = devm_regulator_bulk_get(data->dev,
@@ -774,6 +762,18 @@ static int bma400_init(struct bma400_data *data)
 	if (ret)
 		return ret;
 
+	/* Try to read chip_id register. It must return 0x90. */
+	ret = regmap_read(data->regmap, BMA400_CHIP_ID_REG, &val);
+	if (ret) {
+		dev_err(data->dev, "Failed to read chip id register\n");
+		return ret;
+	}
+
+	if (val != BMA400_ID_REG_VAL) {
+		dev_err(data->dev, "Chip ID mismatch\n");
+		return -ENODEV;
+	}
+
 	ret = bma400_get_power_mode(data);
 	if (ret) {
 		dev_err(data->dev, "Failed to get the initial power-mode\n");
diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
index 532daaa6f943..366e252ebeb0 100644
--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -634,8 +634,10 @@ static struct iio_trigger *at91_adc_allocate_trigger(struct iio_dev *idev,
 	trig->ops = &at91_adc_trigger_ops;
 
 	ret = iio_trigger_register(trig);
-	if (ret)
+	if (ret) {
+		iio_trigger_free(trig);
 		return NULL;
+	}
 
 	return trig;
 }
diff --git a/drivers/iio/adc/mp2629_adc.c b/drivers/iio/adc/mp2629_adc.c
index 30a31f185d08..88e947f300cf 100644
--- a/drivers/iio/adc/mp2629_adc.c
+++ b/drivers/iio/adc/mp2629_adc.c
@@ -57,7 +57,8 @@ static struct iio_map mp2629_adc_maps[] = {
 	MP2629_MAP(SYSTEM_VOLT, "system-volt"),
 	MP2629_MAP(INPUT_VOLT, "input-volt"),
 	MP2629_MAP(BATT_CURRENT, "batt-current"),
-	MP2629_MAP(INPUT_CURRENT, "input-current")
+	MP2629_MAP(INPUT_CURRENT, "input-current"),
+	{ }
 };
 
 static int mp2629_read_raw(struct iio_dev *indio_dev,
@@ -74,7 +75,7 @@ static int mp2629_read_raw(struct iio_dev *indio_dev,
 		if (ret)
 			return ret;
 
-		if (chan->address == MP2629_INPUT_VOLT)
+		if (chan->channel == MP2629_INPUT_VOLT)
 			rval &= GENMASK(6, 0);
 		*val = rval;
 		return IIO_VAL_INT;
diff --git a/drivers/iio/pressure/ms5611.h b/drivers/iio/pressure/ms5611.h
index cbc9349c342a..550b75b7186f 100644
--- a/drivers/iio/pressure/ms5611.h
+++ b/drivers/iio/pressure/ms5611.h
@@ -25,13 +25,6 @@ enum {
 	MS5607,
 };
 
-struct ms5611_chip_info {
-	u16 prom[MS5611_PROM_WORDS_NB];
-
-	int (*temp_and_pressure_compensate)(struct ms5611_chip_info *chip_info,
-					    s32 *temp, s32 *pressure);
-};
-
 /*
  * OverSampling Rate descriptor.
  * Warning: cmd MUST be kept aligned on a word boundary (see
@@ -50,12 +43,15 @@ struct ms5611_state {
 	const struct ms5611_osr *pressure_osr;
 	const struct ms5611_osr *temp_osr;
 
+	u16 prom[MS5611_PROM_WORDS_NB];
+
 	int (*reset)(struct ms5611_state *st);
 	int (*read_prom_word)(struct ms5611_state *st, int index, u16 *word);
 	int (*read_adc_temp_and_pressure)(struct ms5611_state *st,
 					  s32 *temp, s32 *pressure);
 
-	struct ms5611_chip_info *chip_info;
+	int (*compensate_temp_and_pressure)(struct ms5611_state *st, s32 *temp,
+					  s32 *pressure);
 	struct regulator *vdd;
 };
 
diff --git a/drivers/iio/pressure/ms5611_core.c b/drivers/iio/pressure/ms5611_core.c
index 717521de66c4..c564a1d6cafe 100644
--- a/drivers/iio/pressure/ms5611_core.c
+++ b/drivers/iio/pressure/ms5611_core.c
@@ -85,7 +85,7 @@ static int ms5611_read_prom(struct iio_dev *indio_dev)
 	struct ms5611_state *st = iio_priv(indio_dev);
 
 	for (i = 0; i < MS5611_PROM_WORDS_NB; i++) {
-		ret = st->read_prom_word(st, i, &st->chip_info->prom[i]);
+		ret = st->read_prom_word(st, i, &st->prom[i]);
 		if (ret < 0) {
 			dev_err(&indio_dev->dev,
 				"failed to read prom at %d\n", i);
@@ -93,7 +93,7 @@ static int ms5611_read_prom(struct iio_dev *indio_dev)
 		}
 	}
 
-	if (!ms5611_prom_is_valid(st->chip_info->prom, MS5611_PROM_WORDS_NB)) {
+	if (!ms5611_prom_is_valid(st->prom, MS5611_PROM_WORDS_NB)) {
 		dev_err(&indio_dev->dev, "PROM integrity check failed\n");
 		return -ENODEV;
 	}
@@ -114,21 +114,20 @@ static int ms5611_read_temp_and_pressure(struct iio_dev *indio_dev,
 		return ret;
 	}
 
-	return st->chip_info->temp_and_pressure_compensate(st->chip_info,
-							   temp, pressure);
+	return st->compensate_temp_and_pressure(st, temp, pressure);
 }
 
-static int ms5611_temp_and_pressure_compensate(struct ms5611_chip_info *chip_info,
+static int ms5611_temp_and_pressure_compensate(struct ms5611_state *st,
 					       s32 *temp, s32 *pressure)
 {
 	s32 t = *temp, p = *pressure;
 	s64 off, sens, dt;
 
-	dt = t - (chip_info->prom[5] << 8);
-	off = ((s64)chip_info->prom[2] << 16) + ((chip_info->prom[4] * dt) >> 7);
-	sens = ((s64)chip_info->prom[1] << 15) + ((chip_info->prom[3] * dt) >> 8);
+	dt = t - (st->prom[5] << 8);
+	off = ((s64)st->prom[2] << 16) + ((st->prom[4] * dt) >> 7);
+	sens = ((s64)st->prom[1] << 15) + ((st->prom[3] * dt) >> 8);
 
-	t = 2000 + ((chip_info->prom[6] * dt) >> 23);
+	t = 2000 + ((st->prom[6] * dt) >> 23);
 	if (t < 2000) {
 		s64 off2, sens2, t2;
 
@@ -154,17 +153,17 @@ static int ms5611_temp_and_pressure_compensate(struct ms5611_chip_info *chip_inf
 	return 0;
 }
 
-static int ms5607_temp_and_pressure_compensate(struct ms5611_chip_info *chip_info,
+static int ms5607_temp_and_pressure_compensate(struct ms5611_state *st,
 					       s32 *temp, s32 *pressure)
 {
 	s32 t = *temp, p = *pressure;
 	s64 off, sens, dt;
 
-	dt = t - (chip_info->prom[5] << 8);
-	off = ((s64)chip_info->prom[2] << 17) + ((chip_info->prom[4] * dt) >> 6);
-	sens = ((s64)chip_info->prom[1] << 16) + ((chip_info->prom[3] * dt) >> 7);
+	dt = t - (st->prom[5] << 8);
+	off = ((s64)st->prom[2] << 17) + ((st->prom[4] * dt) >> 6);
+	sens = ((s64)st->prom[1] << 16) + ((st->prom[3] * dt) >> 7);
 
-	t = 2000 + ((chip_info->prom[6] * dt) >> 23);
+	t = 2000 + ((st->prom[6] * dt) >> 23);
 	if (t < 2000) {
 		s64 off2, sens2, t2, tmp;
 
@@ -342,15 +341,6 @@ static int ms5611_write_raw(struct iio_dev *indio_dev,
 
 static const unsigned long ms5611_scan_masks[] = {0x3, 0};
 
-static struct ms5611_chip_info chip_info_tbl[] = {
-	[MS5611] = {
-		.temp_and_pressure_compensate = ms5611_temp_and_pressure_compensate,
-	},
-	[MS5607] = {
-		.temp_and_pressure_compensate = ms5607_temp_and_pressure_compensate,
-	}
-};
-
 static const struct iio_chan_spec ms5611_channels[] = {
 	{
 		.type = IIO_PRESSURE,
@@ -433,7 +423,20 @@ int ms5611_probe(struct iio_dev *indio_dev, struct device *dev,
 	struct ms5611_state *st = iio_priv(indio_dev);
 
 	mutex_init(&st->lock);
-	st->chip_info = &chip_info_tbl[type];
+
+	switch (type) {
+	case MS5611:
+		st->compensate_temp_and_pressure =
+			ms5611_temp_and_pressure_compensate;
+		break;
+	case MS5607:
+		st->compensate_temp_and_pressure =
+			ms5607_temp_and_pressure_compensate;
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	st->temp_osr =
 		&ms5611_avail_temp_osr[ARRAY_SIZE(ms5611_avail_temp_osr) - 1];
 	st->pressure_osr =
diff --git a/drivers/iio/pressure/ms5611_spi.c b/drivers/iio/pressure/ms5611_spi.c
index 432e912096f4..a0a7205c9c3a 100644
--- a/drivers/iio/pressure/ms5611_spi.c
+++ b/drivers/iio/pressure/ms5611_spi.c
@@ -91,7 +91,7 @@ static int ms5611_spi_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, indio_dev);
 
 	spi->mode = SPI_MODE_0;
-	spi->max_speed_hz = 20000000;
+	spi->max_speed_hz = min(spi->max_speed_hz, 20000000U);
 	spi->bits_per_word = 8;
 	ret = spi_setup(spi);
 	if (ret < 0)
diff --git a/drivers/iio/trigger/iio-trig-sysfs.c b/drivers/iio/trigger/iio-trig-sysfs.c
index d6c5e9644738..6b05eed41612 100644
--- a/drivers/iio/trigger/iio-trig-sysfs.c
+++ b/drivers/iio/trigger/iio-trig-sysfs.c
@@ -203,9 +203,13 @@ static int iio_sysfs_trigger_remove(int id)
 
 static int __init iio_sysfs_trig_init(void)
 {
+	int ret;
 	device_initialize(&iio_sysfs_trig_dev);
 	dev_set_name(&iio_sysfs_trig_dev, "iio_sysfs_trigger");
-	return device_add(&iio_sysfs_trig_dev);
+	ret = device_add(&iio_sysfs_trig_dev);
+	if (ret)
+		put_device(&iio_sysfs_trig_dev);
+	return ret;
 }
 module_init(iio_sysfs_trig_init);
 
diff --git a/drivers/infiniband/hw/efa/efa_main.c b/drivers/infiniband/hw/efa/efa_main.c
index 94b94cca4870..15ee92081118 100644
--- a/drivers/infiniband/hw/efa/efa_main.c
+++ b/drivers/infiniband/hw/efa/efa_main.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
 /*
- * Copyright 2018-2021 Amazon.com, Inc. or its affiliates. All rights reserved.
+ * Copyright 2018-2022 Amazon.com, Inc. or its affiliates. All rights reserved.
  */
 
 #include <linux/module.h>
@@ -14,10 +14,12 @@
 
 #define PCI_DEV_ID_EFA0_VF 0xefa0
 #define PCI_DEV_ID_EFA1_VF 0xefa1
+#define PCI_DEV_ID_EFA2_VF 0xefa2
 
 static const struct pci_device_id efa_pci_tbl[] = {
 	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA0_VF) },
 	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA1_VF) },
+	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA2_VF) },
 	{ }
 };
 
diff --git a/drivers/input/joystick/iforce/iforce-main.c b/drivers/input/joystick/iforce/iforce-main.c
index b86de1312512..84b87526b7ba 100644
--- a/drivers/input/joystick/iforce/iforce-main.c
+++ b/drivers/input/joystick/iforce/iforce-main.c
@@ -273,22 +273,22 @@ int iforce_init_device(struct device *parent, u16 bustype,
  * Get device info.
  */
 
-	if (!iforce_get_id_packet(iforce, 'M', buf, &len) || len < 3)
+	if (!iforce_get_id_packet(iforce, 'M', buf, &len) && len >= 3)
 		input_dev->id.vendor = get_unaligned_le16(buf + 1);
 	else
 		dev_warn(&iforce->dev->dev, "Device does not respond to id packet M\n");
 
-	if (!iforce_get_id_packet(iforce, 'P', buf, &len) || len < 3)
+	if (!iforce_get_id_packet(iforce, 'P', buf, &len) && len >= 3)
 		input_dev->id.product = get_unaligned_le16(buf + 1);
 	else
 		dev_warn(&iforce->dev->dev, "Device does not respond to id packet P\n");
 
-	if (!iforce_get_id_packet(iforce, 'B', buf, &len) || len < 3)
+	if (!iforce_get_id_packet(iforce, 'B', buf, &len) && len >= 3)
 		iforce->device_memory.end = get_unaligned_le16(buf + 1);
 	else
 		dev_warn(&iforce->dev->dev, "Device does not respond to id packet B\n");
 
-	if (!iforce_get_id_packet(iforce, 'N', buf, &len) || len < 2)
+	if (!iforce_get_id_packet(iforce, 'N', buf, &len) && len >= 2)
 		ff_effects = buf[1];
 	else
 		dev_warn(&iforce->dev->dev, "Device does not respond to id packet N\n");
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 3fc0a89cc785..f132d6dfc25e 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1543,8 +1543,6 @@ static int i8042_probe(struct platform_device *dev)
 {
 	int error;
 
-	i8042_platform_device = dev;
-
 	if (i8042_reset == I8042_RESET_ALWAYS) {
 		error = i8042_controller_selftest();
 		if (error)
@@ -1582,7 +1580,6 @@ static int i8042_probe(struct platform_device *dev)
 	i8042_free_aux_ports();	/* in case KBD failed but AUX not */
 	i8042_free_irqs();
 	i8042_controller_reset(false);
-	i8042_platform_device = NULL;
 
 	return error;
 }
@@ -1592,7 +1589,6 @@ static int i8042_remove(struct platform_device *dev)
 	i8042_unregister_ports();
 	i8042_free_irqs();
 	i8042_controller_reset(false);
-	i8042_platform_device = NULL;
 
 	return 0;
 }
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index ecc0b05b2796..e47700674978 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -954,11 +954,9 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 
 			domain_flush_cache(domain, tmp_page, VTD_PAGE_SIZE);
 			pteval = ((uint64_t)virt_to_dma_pfn(tmp_page) << VTD_PAGE_SHIFT) | DMA_PTE_READ | DMA_PTE_WRITE;
-			if (domain_use_first_level(domain)) {
-				pteval |= DMA_FL_PTE_XD | DMA_FL_PTE_US;
-				if (iommu_is_dma_domain(&domain->domain))
-					pteval |= DMA_FL_PTE_ACCESS;
-			}
+			if (domain_use_first_level(domain))
+				pteval |= DMA_FL_PTE_XD | DMA_FL_PTE_US | DMA_FL_PTE_ACCESS;
+
 			if (cmpxchg64(&pte->val, 0ULL, pteval))
 				/* Someone else set it while we were thinking; use theirs. */
 				free_pgtable_page(tmp_page);
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index c5e7e8b020a5..12584c7981ac 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -652,7 +652,7 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 	 * Since it is a second level only translation setup, we should
 	 * set SRE bit as well (addresses are expected to be GPAs).
 	 */
-	if (pasid != PASID_RID2PASID)
+	if (pasid != PASID_RID2PASID && ecap_srs(iommu->ecap))
 		pasid_set_sre(pte);
 	pasid_set_present(pte);
 	spin_unlock(&iommu->lock);
@@ -695,7 +695,8 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
 	 * We should set SRE bit as well since the addresses are expected
 	 * to be GPAs.
 	 */
-	pasid_set_sre(pte);
+	if (ecap_srs(iommu->ecap))
+		pasid_set_sre(pte);
 	pasid_set_present(pte);
 	spin_unlock(&iommu->lock);
 
diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
index 7ea0100f218a..90ee56d07a6e 100644
--- a/drivers/isdn/mISDN/core.c
+++ b/drivers/isdn/mISDN/core.c
@@ -222,7 +222,7 @@ mISDN_register_device(struct mISDNdevice *dev,
 
 	err = get_free_devid();
 	if (err < 0)
-		goto error1;
+		return err;
 	dev->id = err;
 
 	device_initialize(&dev->dev);
diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index c3b2c99b5cd5..cfbcd9e973c2 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -77,6 +77,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 	if (!entry)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&entry->list);
 	entry->elem = elem;
 
 	entry->dev.class = elements_class;
@@ -107,7 +108,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 	device_unregister(&entry->dev);
 	return ret;
 err1:
-	kfree(entry);
+	put_device(&entry->dev);
 	return ret;
 }
 EXPORT_SYMBOL(mISDN_dsp_element_register);
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 9c5ef818ca36..bb786c39545e 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1858,6 +1858,8 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	dm_io_client_destroy(c->dm_io);
 bad_dm_io:
 	mutex_destroy(&c->lock);
+	if (c->no_sleep)
+		static_branch_dec(&no_sleep_enabled);
 	kfree(c);
 bad_client:
 	return ERR_PTR(r);
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 159c6806c19b..2653516bcdef 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3630,6 +3630,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	limits->physical_block_size =
 		max_t(unsigned, limits->physical_block_size, cc->sector_size);
 	limits->io_min = max_t(unsigned, limits->io_min, cc->sector_size);
+	limits->dma_alignment = limits->logical_block_size - 1;
 }
 
 static struct target_type crypt_target = {
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 98976aaa9db9..9cd410d8fbeb 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -655,7 +655,7 @@ static void list_version_get_needed(struct target_type *tt, void *needed_param)
     size_t *needed = needed_param;
 
     *needed += sizeof(struct dm_target_versions);
-    *needed += strlen(tt->name);
+    *needed += strlen(tt->name) + 1;
     *needed += ALIGN_MASK;
 }
 
@@ -720,7 +720,7 @@ static int __list_versions(struct dm_ioctl *param, size_t param_size, const char
 	iter_info.old_vers = NULL;
 	iter_info.vers = vers;
 	iter_info.flags = 0;
-	iter_info.end = (char *)vers+len;
+	iter_info.end = (char *)vers + needed;
 
 	/*
 	 * Now loop through filling out the names & versions.
diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
index 8f2de1893245..8f970fe9bb6e 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -854,6 +854,7 @@ static int qp_notify_peer_local(bool attach, struct vmci_handle handle)
 	u32 context_id = vmci_get_context_id();
 	struct vmci_event_qp ev;
 
+	memset(&ev, 0, sizeof(ev));
 	ev.msg.hdr.dst = vmci_make_handle(context_id, VMCI_EVENT_HANDLER);
 	ev.msg.hdr.src = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
 					  VMCI_CONTEXT_RESOURCE_ID);
@@ -1467,6 +1468,7 @@ static int qp_notify_peer(bool attach,
 	 * kernel.
 	 */
 
+	memset(&ev, 0, sizeof(ev));
 	ev.msg.hdr.dst = vmci_make_handle(peer_id, VMCI_EVENT_HANDLER);
 	ev.msg.hdr.src = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
 					  VMCI_CONTEXT_RESOURCE_ID);
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index ef53a2578824..3d9649325725 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1134,7 +1134,13 @@ u32 mmc_select_voltage(struct mmc_host *host, u32 ocr)
 		mmc_power_cycle(host, ocr);
 	} else {
 		bit = fls(ocr) - 1;
-		ocr &= 3 << bit;
+		/*
+		 * The bit variable represents the highest voltage bit set in
+		 * the OCR register.
+		 * To keep a range of 2 values (e.g. 3.2V/3.3V and 3.3V/3.4V),
+		 * we must shift the mask '3' with (bit - 1).
+		 */
+		ocr &= 3 << (bit - 1);
 		if (bit != host->ios.vdd)
 			dev_warn(mmc_dev(host), "exceeding card's volts\n");
 	}
diff --git a/drivers/mmc/host/sdhci-pci-core.c b/drivers/mmc/host/sdhci-pci-core.c
index b6f4bd3d93cd..c55a77a10c63 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -1728,6 +1728,8 @@ static int amd_probe(struct sdhci_pci_chip *chip)
 		}
 	}
 
+	pci_dev_put(smbus_dev);
+
 	if (gen == AMD_CHIPSET_BEFORE_ML || gen == AMD_CHIPSET_CZ)
 		chip->quirks2 |= SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD;
 
diff --git a/drivers/mmc/host/sdhci-pci-o2micro.c b/drivers/mmc/host/sdhci-pci-o2micro.c
index 0d4d343dbb77..7a7cce6bc44d 100644
--- a/drivers/mmc/host/sdhci-pci-o2micro.c
+++ b/drivers/mmc/host/sdhci-pci-o2micro.c
@@ -32,6 +32,7 @@
 #define O2_SD_CAPS		0xE0
 #define O2_SD_ADMA1		0xE2
 #define O2_SD_ADMA2		0xE7
+#define O2_SD_MISC_CTRL2	0xF0
 #define O2_SD_INF_MOD		0xF1
 #define O2_SD_MISC_CTRL4	0xFC
 #define O2_SD_MISC_CTRL		0x1C0
@@ -874,6 +875,12 @@ static int sdhci_pci_o2_probe(struct sdhci_pci_chip *chip)
 		/* Set Tuning Windows to 5 */
 		pci_write_config_byte(chip->pdev,
 				O2_SD_TUNING_CTRL, 0x55);
+		//Adjust 1st and 2nd CD debounce time
+		pci_read_config_dword(chip->pdev, O2_SD_MISC_CTRL2, &scratch_32);
+		scratch_32 &= 0xFFE7FFFF;
+		scratch_32 |= 0x00180000;
+		pci_write_config_dword(chip->pdev, O2_SD_MISC_CTRL2, scratch_32);
+		pci_write_config_dword(chip->pdev, O2_SD_DETECT_SETTING, 1);
 		/* Lock WP */
 		ret = pci_read_config_byte(chip->pdev,
 					   O2_SD_LOCK_WP, &scratch);
diff --git a/drivers/mtd/nand/onenand/Kconfig b/drivers/mtd/nand/onenand/Kconfig
index 34d9a7a82ad4..c94bf483541e 100644
--- a/drivers/mtd/nand/onenand/Kconfig
+++ b/drivers/mtd/nand/onenand/Kconfig
@@ -26,6 +26,7 @@ config MTD_ONENAND_OMAP2
 	tristate "OneNAND on OMAP2/OMAP3 support"
 	depends on ARCH_OMAP2 || ARCH_OMAP3 || (COMPILE_TEST && ARM)
 	depends on OF || COMPILE_TEST
+	depends on OMAP_GPMC
 	help
 	  Support for a OneNAND flash device connected to an OMAP2/OMAP3 SoC
 	  via the GPMC memory controller.
diff --git a/drivers/mtd/nand/raw/qcom_nandc.c b/drivers/mtd/nand/raw/qcom_nandc.c
index 8f80019a9f01..198a44794d2d 100644
--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -3167,16 +3167,18 @@ static int qcom_nand_host_init_and_register(struct qcom_nand_controller *nandc,
 
 	ret = mtd_device_parse_register(mtd, probes, NULL, NULL, 0);
 	if (ret)
-		nand_cleanup(chip);
+		goto err;
 
 	if (nandc->props->use_codeword_fixup) {
 		ret = qcom_nand_host_parse_boot_partitions(nandc, host, dn);
-		if (ret) {
-			nand_cleanup(chip);
-			return ret;
-		}
+		if (ret)
+			goto err;
 	}
 
+	return 0;
+
+err:
+	nand_cleanup(chip);
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 6a356a6cee15..41c821348476 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4545,13 +4545,19 @@ static struct pci_driver ena_pci_driver = {
 
 static int __init ena_init(void)
 {
+	int ret;
+
 	ena_wq = create_singlethread_workqueue(DRV_MODULE_NAME);
 	if (!ena_wq) {
 		pr_err("Failed to create workqueue\n");
 		return -ENOMEM;
 	}
 
-	return pci_register_driver(&ena_pci_driver);
+	ret = pci_register_driver(&ena_pci_driver);
+	if (ret)
+		destroy_workqueue(ena_wq);
+
+	return ret;
 }
 
 static void __exit ena_cleanup(void)
diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index e461f4764066..e23d8734d4e4 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1427,7 +1427,7 @@ static int ag71xx_open(struct net_device *ndev)
 	if (ret) {
 		netif_err(ag, link, ndev, "phylink_of_phy_connect filed with err: %i\n",
 			  ret);
-		goto err;
+		return ret;
 	}
 
 	max_frame_len = ag71xx_max_frame_len(ndev->mtu);
@@ -1448,6 +1448,7 @@ static int ag71xx_open(struct net_device *ndev)
 
 err:
 	ag71xx_rings_cleanup(ag);
+	phylink_disconnect_phy(ag->phylink);
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 93580484a3f4..91c054eef701 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1568,7 +1568,6 @@ void bgmac_enet_remove(struct bgmac *bgmac)
 	phy_disconnect(bgmac->net_dev->phydev);
 	netif_napi_del(&bgmac->napi);
 	bgmac_dma_free(bgmac);
-	free_netdev(bgmac->net_dev);
 }
 EXPORT_SYMBOL_GPL(bgmac_enet_remove);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index be5df8fca264..57cabe20aa12 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9983,17 +9983,12 @@ static int bnxt_try_recover_fw(struct bnxt *bp)
 	return -ENODEV;
 }
 
-int bnxt_cancel_reservations(struct bnxt *bp, bool fw_reset)
+static void bnxt_clear_reservations(struct bnxt *bp, bool fw_reset)
 {
 	struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
-	int rc;
 
 	if (!BNXT_NEW_RM(bp))
-		return 0; /* no resource reservations required */
-
-	rc = bnxt_hwrm_func_resc_qcaps(bp, true);
-	if (rc)
-		netdev_err(bp->dev, "resc_qcaps failed\n");
+		return; /* no resource reservations required */
 
 	hw_resc->resv_cp_rings = 0;
 	hw_resc->resv_stat_ctxs = 0;
@@ -10006,6 +10001,20 @@ int bnxt_cancel_reservations(struct bnxt *bp, bool fw_reset)
 		bp->tx_nr_rings = 0;
 		bp->rx_nr_rings = 0;
 	}
+}
+
+int bnxt_cancel_reservations(struct bnxt *bp, bool fw_reset)
+{
+	int rc;
+
+	if (!BNXT_NEW_RM(bp))
+		return 0; /* no resource reservations required */
+
+	rc = bnxt_hwrm_func_resc_qcaps(bp, true);
+	if (rc)
+		netdev_err(bp->dev, "resc_qcaps failed\n");
+
+	bnxt_clear_reservations(bp, fw_reset);
 
 	return rc;
 }
@@ -13913,7 +13922,9 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 	pci_ers_result_t result = PCI_ERS_RESULT_DISCONNECT;
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct bnxt *bp = netdev_priv(netdev);
-	int err = 0, off;
+	int retry = 0;
+	int err = 0;
+	int off;
 
 	netdev_info(bp->dev, "PCI Slot Reset\n");
 
@@ -13941,11 +13952,36 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 		pci_restore_state(pdev);
 		pci_save_state(pdev);
 
+		bnxt_inv_fw_health_reg(bp);
+		bnxt_try_map_fw_health_reg(bp);
+
+		/* In some PCIe AER scenarios, firmware may take up to
+		 * 10 seconds to become ready in the worst case.
+		 */
+		do {
+			err = bnxt_try_recover_fw(bp);
+			if (!err)
+				break;
+			retry++;
+		} while (retry < BNXT_FW_SLOT_RESET_RETRY);
+
+		if (err) {
+			dev_err(&pdev->dev, "Firmware not ready\n");
+			goto reset_exit;
+		}
+
 		err = bnxt_hwrm_func_reset(bp);
 		if (!err)
 			result = PCI_ERS_RESULT_RECOVERED;
+
+		bnxt_ulp_irq_stop(bp);
+		bnxt_clear_int_mode(bp);
+		err = bnxt_init_int_mode(bp);
+		bnxt_ulp_irq_restart(bp, err);
 	}
 
+reset_exit:
+	bnxt_clear_reservations(bp, true);
 	rtnl_unlock();
 
 	return result;
@@ -14001,8 +14037,16 @@ static struct pci_driver bnxt_pci_driver = {
 
 static int __init bnxt_init(void)
 {
+	int err;
+
 	bnxt_debug_init();
-	return pci_register_driver(&bnxt_pci_driver);
+	err = pci_register_driver(&bnxt_pci_driver);
+	if (err) {
+		bnxt_debug_exit();
+		return err;
+	}
+
+	return 0;
 }
 
 static void __exit bnxt_exit(void)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index b1b17f911300..d5fa43cfe524 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1621,6 +1621,7 @@ struct bnxt_fw_health {
 
 #define BNXT_FW_RETRY			5
 #define BNXT_FW_IF_RETRY		10
+#define BNXT_FW_SLOT_RESET_RETRY	4
 
 enum board_idx {
 	BCM57301,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index b01d42928a53..132442f16fe6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -476,7 +476,8 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 		memset(ctx->resp, 0, PAGE_SIZE);
 
 	req_type = le16_to_cpu(ctx->req->req_type);
-	if (BNXT_NO_FW_ACCESS(bp) && req_type != HWRM_FUNC_RESET) {
+	if (BNXT_NO_FW_ACCESS(bp) &&
+	    (req_type != HWRM_FUNC_RESET && req_type != HWRM_VER_GET)) {
 		netdev_dbg(bp->dev, "hwrm req_type 0x%x skipped, FW channel down\n",
 			   req_type);
 		goto exit;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index bee35ce60171..bf6a72143040 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1799,13 +1799,10 @@ static int liquidio_open(struct net_device *netdev)
 
 	ifstate_set(lio, LIO_IFSTATE_RUNNING);
 
-	if (OCTEON_CN23XX_PF(oct)) {
-		if (!oct->msix_on)
-			if (setup_tx_poll_fn(netdev))
-				return -1;
-	} else {
-		if (setup_tx_poll_fn(netdev))
-			return -1;
+	if (!OCTEON_CN23XX_PF(oct) || (OCTEON_CN23XX_PF(oct) && !oct->msix_on)) {
+		ret = setup_tx_poll_fn(netdev);
+		if (ret)
+			goto err_poll;
 	}
 
 	netif_tx_start_all_queues(netdev);
@@ -1818,7 +1815,7 @@ static int liquidio_open(struct net_device *netdev)
 	/* tell Octeon to start forwarding packets to host */
 	ret = send_rx_ctrl_cmd(lio, 1);
 	if (ret)
-		return ret;
+		goto err_rx_ctrl;
 
 	/* start periodical statistics fetch */
 	INIT_DELAYED_WORK(&lio->stats_wk.work, lio_fetch_stats);
@@ -1829,6 +1826,27 @@ static int liquidio_open(struct net_device *netdev)
 	dev_info(&oct->pci_dev->dev, "%s interface is opened\n",
 		 netdev->name);
 
+	return 0;
+
+err_rx_ctrl:
+	if (!OCTEON_CN23XX_PF(oct) || (OCTEON_CN23XX_PF(oct) && !oct->msix_on))
+		cleanup_tx_poll_fn(netdev);
+err_poll:
+	if (lio->ptp_clock) {
+		ptp_clock_unregister(lio->ptp_clock);
+		lio->ptp_clock = NULL;
+	}
+
+	if (oct->props[lio->ifidx].napi_enabled == 1) {
+		list_for_each_entry_safe(napi, n, &netdev->napi_list, dev_list)
+			napi_disable(napi);
+
+		oct->props[lio->ifidx].napi_enabled = 0;
+
+		if (OCTEON_CN23XX_PF(oct))
+			oct->droq[0]->ops.poll_mode = 0;
+	}
+
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 94f80e1c4020..bf7daab88689 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -790,7 +790,6 @@ struct hnae3_knic_private_info {
 	const struct hnae3_dcb_ops *dcb_ops;
 
 	u16 int_rl_setting;
-	enum pkt_hash_types rss_type;
 	void __iomem *io_base;
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
index e23729ac3bb8..ae2736549526 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
@@ -191,23 +191,6 @@ u32 hclge_comm_get_rss_key_size(struct hnae3_handle *handle)
 	return HCLGE_COMM_RSS_KEY_SIZE;
 }
 
-void hclge_comm_get_rss_type(struct hnae3_handle *nic,
-			     struct hclge_comm_rss_tuple_cfg *rss_tuple_sets)
-{
-	if (rss_tuple_sets->ipv4_tcp_en ||
-	    rss_tuple_sets->ipv4_udp_en ||
-	    rss_tuple_sets->ipv4_sctp_en ||
-	    rss_tuple_sets->ipv6_tcp_en ||
-	    rss_tuple_sets->ipv6_udp_en ||
-	    rss_tuple_sets->ipv6_sctp_en)
-		nic->kinfo.rss_type = PKT_HASH_TYPE_L4;
-	else if (rss_tuple_sets->ipv4_fragment_en ||
-		 rss_tuple_sets->ipv6_fragment_en)
-		nic->kinfo.rss_type = PKT_HASH_TYPE_L3;
-	else
-		nic->kinfo.rss_type = PKT_HASH_TYPE_NONE;
-}
-
 int hclge_comm_parse_rss_hfunc(struct hclge_comm_rss_cfg *rss_cfg,
 			       const u8 hfunc, u8 *hash_algo)
 {
@@ -344,9 +327,6 @@ int hclge_comm_set_rss_input_tuple(struct hnae3_handle *nic,
 	req->ipv6_sctp_en = rss_cfg->rss_tuple_sets.ipv6_sctp_en;
 	req->ipv6_fragment_en = rss_cfg->rss_tuple_sets.ipv6_fragment_en;
 
-	if (is_pf)
-		hclge_comm_get_rss_type(nic, &rss_cfg->rss_tuple_sets);
-
 	ret = hclge_comm_cmd_send(hw, &desc, 1);
 	if (ret)
 		dev_err(&hw->cmq.csq.pdev->dev,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
index 946d166a452d..92af3d2980d3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
@@ -95,8 +95,6 @@ struct hclge_comm_rss_tc_mode_cmd {
 };
 
 u32 hclge_comm_get_rss_key_size(struct hnae3_handle *handle);
-void hclge_comm_get_rss_type(struct hnae3_handle *nic,
-			     struct hclge_comm_rss_tuple_cfg *rss_tuple_sets);
 void hclge_comm_rss_indir_init_cfg(struct hnae3_ae_dev *ae_dev,
 				   struct hclge_comm_rss_cfg *rss_cfg);
 int hclge_comm_get_rss_tuple(struct hclge_comm_rss_cfg *rss_cfg, int flow_type,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 35d70041b9e8..44d4265f109a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -105,26 +105,28 @@ static const struct pci_device_id hns3_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, hns3_pci_tbl);
 
-#define HNS3_RX_PTYPE_ENTRY(ptype, l, s, t) \
+#define HNS3_RX_PTYPE_ENTRY(ptype, l, s, t, h) \
 	{	ptype, \
 		l, \
 		CHECKSUM_##s, \
 		HNS3_L3_TYPE_##t, \
-		1 }
+		1, \
+		h}
 
 #define HNS3_RX_PTYPE_UNUSED_ENTRY(ptype) \
-		{ ptype, 0, CHECKSUM_NONE, HNS3_L3_TYPE_PARSE_FAIL, 0 }
+		{ ptype, 0, CHECKSUM_NONE, HNS3_L3_TYPE_PARSE_FAIL, 0, \
+		  PKT_HASH_TYPE_NONE }
 
 static const struct hns3_rx_ptype hns3_rx_ptype_tbl[] = {
 	HNS3_RX_PTYPE_UNUSED_ENTRY(0),
-	HNS3_RX_PTYPE_ENTRY(1, 0, COMPLETE, ARP),
-	HNS3_RX_PTYPE_ENTRY(2, 0, COMPLETE, RARP),
-	HNS3_RX_PTYPE_ENTRY(3, 0, COMPLETE, LLDP),
-	HNS3_RX_PTYPE_ENTRY(4, 0, COMPLETE, PARSE_FAIL),
-	HNS3_RX_PTYPE_ENTRY(5, 0, COMPLETE, PARSE_FAIL),
-	HNS3_RX_PTYPE_ENTRY(6, 0, COMPLETE, PARSE_FAIL),
-	HNS3_RX_PTYPE_ENTRY(7, 0, COMPLETE, CNM),
-	HNS3_RX_PTYPE_ENTRY(8, 0, NONE, PARSE_FAIL),
+	HNS3_RX_PTYPE_ENTRY(1, 0, COMPLETE, ARP, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(2, 0, COMPLETE, RARP, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(3, 0, COMPLETE, LLDP, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(4, 0, COMPLETE, PARSE_FAIL, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(5, 0, COMPLETE, PARSE_FAIL, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(6, 0, COMPLETE, PARSE_FAIL, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(7, 0, COMPLETE, CNM, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(8, 0, NONE, PARSE_FAIL, PKT_HASH_TYPE_NONE),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(9),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(10),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(11),
@@ -132,36 +134,36 @@ static const struct hns3_rx_ptype hns3_rx_ptype_tbl[] = {
 	HNS3_RX_PTYPE_UNUSED_ENTRY(13),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(14),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(15),
-	HNS3_RX_PTYPE_ENTRY(16, 0, COMPLETE, PARSE_FAIL),
-	HNS3_RX_PTYPE_ENTRY(17, 0, COMPLETE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(18, 0, COMPLETE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(19, 0, UNNECESSARY, IPV4),
-	HNS3_RX_PTYPE_ENTRY(20, 0, UNNECESSARY, IPV4),
-	HNS3_RX_PTYPE_ENTRY(21, 0, NONE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(22, 0, UNNECESSARY, IPV4),
-	HNS3_RX_PTYPE_ENTRY(23, 0, NONE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(24, 0, NONE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(25, 0, UNNECESSARY, IPV4),
+	HNS3_RX_PTYPE_ENTRY(16, 0, COMPLETE, PARSE_FAIL, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(17, 0, COMPLETE, IPV4, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(18, 0, COMPLETE, IPV4, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(19, 0, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(20, 0, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(21, 0, NONE, IPV4, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(22, 0, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(23, 0, NONE, IPV4, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(24, 0, NONE, IPV4, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(25, 0, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(26),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(27),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(28),
-	HNS3_RX_PTYPE_ENTRY(29, 0, COMPLETE, PARSE_FAIL),
-	HNS3_RX_PTYPE_ENTRY(30, 0, COMPLETE, PARSE_FAIL),
-	HNS3_RX_PTYPE_ENTRY(31, 0, COMPLETE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(32, 0, COMPLETE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(33, 1, UNNECESSARY, IPV4),
-	HNS3_RX_PTYPE_ENTRY(34, 1, UNNECESSARY, IPV4),
-	HNS3_RX_PTYPE_ENTRY(35, 1, UNNECESSARY, IPV4),
-	HNS3_RX_PTYPE_ENTRY(36, 0, COMPLETE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(37, 0, COMPLETE, IPV4),
+	HNS3_RX_PTYPE_ENTRY(29, 0, COMPLETE, PARSE_FAIL, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(30, 0, COMPLETE, PARSE_FAIL, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(31, 0, COMPLETE, IPV4, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(32, 0, COMPLETE, IPV4, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(33, 1, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(34, 1, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(35, 1, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(36, 0, COMPLETE, IPV4, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(37, 0, COMPLETE, IPV4, PKT_HASH_TYPE_L3),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(38),
-	HNS3_RX_PTYPE_ENTRY(39, 0, COMPLETE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(40, 0, COMPLETE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(41, 1, UNNECESSARY, IPV6),
-	HNS3_RX_PTYPE_ENTRY(42, 1, UNNECESSARY, IPV6),
-	HNS3_RX_PTYPE_ENTRY(43, 1, UNNECESSARY, IPV6),
-	HNS3_RX_PTYPE_ENTRY(44, 0, COMPLETE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(45, 0, COMPLETE, IPV6),
+	HNS3_RX_PTYPE_ENTRY(39, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(40, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(41, 1, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(42, 1, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(43, 1, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(44, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(45, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(46),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(47),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(48),
@@ -227,35 +229,35 @@ static const struct hns3_rx_ptype hns3_rx_ptype_tbl[] = {
 	HNS3_RX_PTYPE_UNUSED_ENTRY(108),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(109),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(110),
-	HNS3_RX_PTYPE_ENTRY(111, 0, COMPLETE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(112, 0, COMPLETE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(113, 0, UNNECESSARY, IPV6),
-	HNS3_RX_PTYPE_ENTRY(114, 0, UNNECESSARY, IPV6),
-	HNS3_RX_PTYPE_ENTRY(115, 0, NONE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(116, 0, UNNECESSARY, IPV6),
-	HNS3_RX_PTYPE_ENTRY(117, 0, NONE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(118, 0, NONE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(119, 0, UNNECESSARY, IPV6),
+	HNS3_RX_PTYPE_ENTRY(111, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(112, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(113, 0, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(114, 0, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(115, 0, NONE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(116, 0, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(117, 0, NONE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(118, 0, NONE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(119, 0, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(120),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(121),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(122),
-	HNS3_RX_PTYPE_ENTRY(123, 0, COMPLETE, PARSE_FAIL),
-	HNS3_RX_PTYPE_ENTRY(124, 0, COMPLETE, PARSE_FAIL),
-	HNS3_RX_PTYPE_ENTRY(125, 0, COMPLETE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(126, 0, COMPLETE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(127, 1, UNNECESSARY, IPV4),
-	HNS3_RX_PTYPE_ENTRY(128, 1, UNNECESSARY, IPV4),
-	HNS3_RX_PTYPE_ENTRY(129, 1, UNNECESSARY, IPV4),
-	HNS3_RX_PTYPE_ENTRY(130, 0, COMPLETE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(131, 0, COMPLETE, IPV4),
+	HNS3_RX_PTYPE_ENTRY(123, 0, COMPLETE, PARSE_FAIL, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(124, 0, COMPLETE, PARSE_FAIL, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(125, 0, COMPLETE, IPV4, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(126, 0, COMPLETE, IPV4, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(127, 1, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(128, 1, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(129, 1, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(130, 0, COMPLETE, IPV4, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(131, 0, COMPLETE, IPV4, PKT_HASH_TYPE_L3),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(132),
-	HNS3_RX_PTYPE_ENTRY(133, 0, COMPLETE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(134, 0, COMPLETE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(135, 1, UNNECESSARY, IPV6),
-	HNS3_RX_PTYPE_ENTRY(136, 1, UNNECESSARY, IPV6),
-	HNS3_RX_PTYPE_ENTRY(137, 1, UNNECESSARY, IPV6),
-	HNS3_RX_PTYPE_ENTRY(138, 0, COMPLETE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(139, 0, COMPLETE, IPV6),
+	HNS3_RX_PTYPE_ENTRY(133, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(134, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(135, 1, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(136, 1, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(137, 1, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(138, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(139, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(140),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(141),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(142),
@@ -3734,8 +3736,8 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 		desc_cb->reuse_flag = 1;
 	} else if (frag_size <= ring->rx_copybreak) {
 		ret = hns3_handle_rx_copybreak(skb, i, ring, pull_len, desc_cb);
-		if (ret)
-			goto out;
+		if (!ret)
+			return;
 	}
 
 out:
@@ -4129,15 +4131,35 @@ static int hns3_set_gro_and_checksum(struct hns3_enet_ring *ring,
 }
 
 static void hns3_set_rx_skb_rss_type(struct hns3_enet_ring *ring,
-				     struct sk_buff *skb, u32 rss_hash)
+				     struct sk_buff *skb, u32 rss_hash,
+				     u32 l234info, u32 ol_info)
 {
-	struct hnae3_handle *handle = ring->tqp->handle;
-	enum pkt_hash_types rss_type;
+	enum pkt_hash_types rss_type = PKT_HASH_TYPE_NONE;
+	struct net_device *netdev = ring_to_netdev(ring);
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
 
-	if (rss_hash)
-		rss_type = handle->kinfo.rss_type;
-	else
-		rss_type = PKT_HASH_TYPE_NONE;
+	if (test_bit(HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE, &priv->state)) {
+		u32 ptype = hnae3_get_field(ol_info, HNS3_RXD_PTYPE_M,
+					    HNS3_RXD_PTYPE_S);
+
+		rss_type = hns3_rx_ptype_tbl[ptype].hash_type;
+	} else {
+		int l3_type = hnae3_get_field(l234info, HNS3_RXD_L3ID_M,
+					      HNS3_RXD_L3ID_S);
+		int l4_type = hnae3_get_field(l234info, HNS3_RXD_L4ID_M,
+					      HNS3_RXD_L4ID_S);
+
+		if (l3_type == HNS3_L3_TYPE_IPV4 ||
+		    l3_type == HNS3_L3_TYPE_IPV6) {
+			if (l4_type == HNS3_L4_TYPE_UDP ||
+			    l4_type == HNS3_L4_TYPE_TCP ||
+			    l4_type == HNS3_L4_TYPE_SCTP)
+				rss_type = PKT_HASH_TYPE_L4;
+			else if (l4_type == HNS3_L4_TYPE_IGMP ||
+				 l4_type == HNS3_L4_TYPE_ICMP)
+				rss_type = PKT_HASH_TYPE_L3;
+		}
+	}
 
 	skb_set_hash(skb, rss_hash, rss_type);
 }
@@ -4240,7 +4262,8 @@ static int hns3_handle_bdinfo(struct hns3_enet_ring *ring, struct sk_buff *skb)
 
 	ring->tqp_vector->rx_group.total_bytes += len;
 
-	hns3_set_rx_skb_rss_type(ring, skb, le32_to_cpu(desc->rx.rss_hash));
+	hns3_set_rx_skb_rss_type(ring, skb, le32_to_cpu(desc->rx.rss_hash),
+				 l234info, ol_info);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 4a3253692dcc..408635d11a24 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -404,6 +404,7 @@ struct hns3_rx_ptype {
 	u32 ip_summed : 2;
 	u32 l3_type : 4;
 	u32 valid : 1;
+	u32 hash_type: 3;
 };
 
 struct ring_stats {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index fae79764dc44..7e8a60f2401c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3246,6 +3246,7 @@ static int hclge_update_tp_port_info(struct hclge_dev *hdev)
 	hdev->hw.mac.autoneg = cmd.base.autoneg;
 	hdev->hw.mac.speed = cmd.base.speed;
 	hdev->hw.mac.duplex = cmd.base.duplex;
+	linkmode_copy(hdev->hw.mac.advertising, cmd.link_modes.advertising);
 
 	return 0;
 }
@@ -4662,7 +4663,6 @@ static int hclge_set_rss_tuple(struct hnae3_handle *handle,
 		return ret;
 	}
 
-	hclge_comm_get_rss_type(&vport->nic, &hdev->rss_cfg.rss_tuple_sets);
 	return 0;
 }
 
@@ -11374,9 +11374,12 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (ret)
 		goto err_msi_irq_uninit;
 
-	if (hdev->hw.mac.media_type == HNAE3_MEDIA_TYPE_COPPER &&
-	    !hnae3_dev_phy_imp_supported(hdev)) {
-		ret = hclge_mac_mdio_config(hdev);
+	if (hdev->hw.mac.media_type == HNAE3_MEDIA_TYPE_COPPER) {
+		if (hnae3_dev_phy_imp_supported(hdev))
+			ret = hclge_update_tp_port_info(hdev);
+		else
+			ret = hclge_mac_mdio_config(hdev);
+
 		if (ret)
 			goto err_msi_irq_uninit;
 	}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index c23ee2ddbce3..1a6534c35ef3 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -1478,8 +1478,15 @@ static struct pci_driver hinic_driver = {
 
 static int __init hinic_module_init(void)
 {
+	int ret;
+
 	hinic_dbg_register_debugfs(HINIC_DRV_NAME);
-	return pci_register_driver(&hinic_driver);
+
+	ret = pci_register_driver(&hinic_driver);
+	if (ret)
+		hinic_dbg_unregister_debugfs();
+
+	return ret;
 }
 
 static void __exit hinic_module_exit(void)
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 97f080c66dd4..8a6a81bcec5c 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -521,14 +521,12 @@ static int octep_open(struct net_device *netdev)
 	octep_oq_dbell_init(oct);
 
 	ret = octep_get_link_status(oct);
-	if (ret)
+	if (ret > 0)
 		octep_link_up(netdev);
 
 	return 0;
 
 set_queues_err:
-	octep_napi_disable(oct);
-	octep_napi_delete(oct);
 	octep_clean_irqs(oct);
 setup_irq_err:
 	octep_free_oqs(oct);
@@ -958,7 +956,7 @@ int octep_device_setup(struct octep_device *oct)
 	ret = octep_ctrl_mbox_init(ctrl_mbox);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to initialize control mbox\n");
-		return -1;
+		goto unsupported_dev;
 	}
 	oct->ctrl_mbox_ifstats_offset = OCTEP_CTRL_MBOX_SZ(ctrl_mbox->h2fq.elem_sz,
 							   ctrl_mbox->h2fq.elem_cnt,
@@ -968,6 +966,10 @@ int octep_device_setup(struct octep_device *oct)
 	return 0;
 
 unsupported_dev:
+	for (i = 0; i < OCTEP_MMIO_REGIONS; i++)
+		iounmap(oct->mmio[i].hw_addr);
+
+	kfree(oct->conf);
 	return -1;
 }
 
@@ -1070,7 +1072,11 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->max_mtu = OCTEP_MAX_MTU;
 	netdev->mtu = OCTEP_DEFAULT_MTU;
 
-	octep_get_mac_addr(octep_dev, octep_dev->mac_addr);
+	err = octep_get_mac_addr(octep_dev, octep_dev->mac_addr);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to get mac address\n");
+		goto register_dev_err;
+	}
 	eth_hw_addr_set(netdev, octep_dev->mac_addr);
 
 	err = register_netdev(netdev);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 4efccd942fb8..1290b2d3eae6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -3470,6 +3470,8 @@ mlxsw_sp_switchdev_vxlan_fdb_del(struct mlxsw_sp *mlxsw_sp,
 	u16 vid;
 
 	vxlan_fdb_info = &switchdev_work->vxlan_fdb_info;
+	if (!vxlan_fdb_info->offloaded)
+		return;
 
 	bridge_device = mlxsw_sp_bridge_device_find(mlxsw_sp->bridge, br_dev);
 	if (!bridge_device)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
index fea42542be28..06811c60d598 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
@@ -716,6 +716,9 @@ int lan966x_stats_init(struct lan966x *lan966x)
 	snprintf(queue_name, sizeof(queue_name), "%s-stats",
 		 dev_name(lan966x->dev));
 	lan966x->stats_queue = create_singlethread_workqueue(queue_name);
+	if (!lan966x->stats_queue)
+		return -ENOMEM;
+
 	INIT_DELAYED_WORK(&lan966x->stats_work, lan966x_check_stats_work);
 	queue_delayed_work(lan966x->stats_queue, &lan966x->stats_work,
 			   LAN966X_STATS_CHECK_DELAY);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
index 6b0febcb7fa9..01f3a3a41cdb 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
@@ -1253,6 +1253,9 @@ int sparx_stats_init(struct sparx5 *sparx5)
 	snprintf(queue_name, sizeof(queue_name), "%s-stats",
 		 dev_name(sparx5->dev));
 	sparx5->stats_queue = create_singlethread_workqueue(queue_name);
+	if (!sparx5->stats_queue)
+		return -ENOMEM;
+
 	INIT_DELAYED_WORK(&sparx5->stats_work, sparx5_check_stats_work);
 	queue_delayed_work(sparx5->stats_queue, &sparx5->stats_work,
 			   SPX5_STATS_CHECK_DELAY);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 01be7bd84181..30815c0e3f76 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -657,6 +657,9 @@ static int sparx5_start(struct sparx5 *sparx5)
 	snprintf(queue_name, sizeof(queue_name), "%s-mact",
 		 dev_name(sparx5->dev));
 	sparx5->mact_queue = create_singlethread_workqueue(queue_name);
+	if (!sparx5->mact_queue)
+		return -ENOMEM;
+
 	INIT_DELAYED_WORK(&sparx5->mact_work, sparx5_mact_pull_work);
 	queue_delayed_work(sparx5->mact_queue, &sparx5->mact_work,
 			   SPX5_MACT_PULL_DELAY);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index b1b1b648e40c..b19bff0db1fd 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1440,15 +1440,15 @@ nfp_port_get_module_info(struct net_device *netdev,
 
 		if (data < 0x3) {
 			modinfo->type = ETH_MODULE_SFF_8436;
-			modinfo->eeprom_len = ETH_MODULE_SFF_8436_LEN;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8436_MAX_LEN;
 		} else {
 			modinfo->type = ETH_MODULE_SFF_8636;
-			modinfo->eeprom_len = ETH_MODULE_SFF_8636_LEN;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8636_MAX_LEN;
 		}
 		break;
 	case NFP_INTERFACE_QSFP28:
 		modinfo->type = ETH_MODULE_SFF_8636;
-		modinfo->eeprom_len = ETH_MODULE_SFF_8636_LEN;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8636_MAX_LEN;
 		break;
 	default:
 		netdev_err(netdev, "Unsupported module 0x%x detected\n",
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 56f93b030551..5456c2b15d9b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -687,8 +687,14 @@ int ionic_port_reset(struct ionic *ionic)
 
 static int __init ionic_init_module(void)
 {
+	int ret;
+
 	ionic_debugfs_create();
-	return ionic_bus_register_driver();
+	ret = ionic_bus_register_driver();
+	if (ret)
+		ionic_debugfs_destroy();
+
+	return ret;
 }
 
 static void __exit ionic_cleanup_module(void)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index bc060ef558d3..02827829463f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6564,6 +6564,9 @@ void stmmac_xdp_release(struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
 
+	/* Ensure tx function is not running */
+	netif_tx_disable(dev);
+
 	/* Disable NAPI process */
 	stmmac_disable_all_queues(priv);
 
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 9983d37ee87d..0a0c4d0ffc19 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -141,7 +141,7 @@ static struct macvlan_source_entry *macvlan_hash_lookup_source(
 	u32 idx = macvlan_eth_hash(addr);
 	struct hlist_head *h = &vlan->port->vlan_source_hash[idx];
 
-	hlist_for_each_entry_rcu(entry, h, hlist) {
+	hlist_for_each_entry_rcu(entry, h, hlist, lockdep_rtnl_is_held()) {
 		if (ether_addr_equal_64bits(entry->addr, addr) &&
 		    entry->vlan == vlan)
 			return entry;
@@ -1192,7 +1192,7 @@ void macvlan_common_setup(struct net_device *dev)
 {
 	ether_setup(dev);
 
-	dev->min_mtu		= 0;
+	/* ether_setup() has set dev->min_mtu to ETH_MIN_MTU. */
 	dev->max_mtu		= ETH_MAX_MTU;
 	dev->priv_flags	       &= ~IFF_TX_SKB_SHARING;
 	netif_keep_dst(dev);
@@ -1647,7 +1647,7 @@ static int macvlan_fill_info_macaddr(struct sk_buff *skb,
 	struct hlist_head *h = &vlan->port->vlan_source_hash[i];
 	struct macvlan_source_entry *entry;
 
-	hlist_for_each_entry_rcu(entry, h, hlist) {
+	hlist_for_each_entry_rcu(entry, h, hlist, lockdep_rtnl_is_held()) {
 		if (entry->vlan != vlan)
 			continue;
 		if (nla_put(skb, IFLA_MACVLAN_MACADDR, ETH_ALEN, entry->addr))
diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index 53846c6b56ca..aca3697b0962 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -43,6 +43,7 @@
 enum {
 	MCTP_I2C_FLOW_STATE_NEW = 0,
 	MCTP_I2C_FLOW_STATE_ACTIVE,
+	MCTP_I2C_FLOW_STATE_INVALID,
 };
 
 /* List of all struct mctp_i2c_client
@@ -374,12 +375,18 @@ mctp_i2c_get_tx_flow_state(struct mctp_i2c_dev *midev, struct sk_buff *skb)
 	 */
 	if (!key->valid) {
 		state = MCTP_I2C_TX_FLOW_INVALID;
-
-	} else if (key->dev_flow_state == MCTP_I2C_FLOW_STATE_NEW) {
-		key->dev_flow_state = MCTP_I2C_FLOW_STATE_ACTIVE;
-		state = MCTP_I2C_TX_FLOW_NEW;
 	} else {
-		state = MCTP_I2C_TX_FLOW_EXISTING;
+		switch (key->dev_flow_state) {
+		case MCTP_I2C_FLOW_STATE_NEW:
+			key->dev_flow_state = MCTP_I2C_FLOW_STATE_ACTIVE;
+			state = MCTP_I2C_TX_FLOW_NEW;
+			break;
+		case MCTP_I2C_FLOW_STATE_ACTIVE:
+			state = MCTP_I2C_TX_FLOW_EXISTING;
+			break;
+		default:
+			state = MCTP_I2C_TX_FLOW_INVALID;
+		}
 	}
 
 	spin_unlock_irqrestore(&key->lock, flags);
@@ -617,21 +624,31 @@ static void mctp_i2c_release_flow(struct mctp_dev *mdev,
 
 {
 	struct mctp_i2c_dev *midev = netdev_priv(mdev->dev);
+	bool queue_release = false;
 	unsigned long flags;
 
 	spin_lock_irqsave(&midev->lock, flags);
-	midev->release_count++;
-	spin_unlock_irqrestore(&midev->lock, flags);
-
-	/* Ensure we have a release operation queued, through the fake
-	 * marker skb
+	/* if we have seen the flow/key previously, we need to pair the
+	 * original lock with a release
 	 */
-	spin_lock(&midev->tx_queue.lock);
-	if (!midev->unlock_marker.next)
-		__skb_queue_tail(&midev->tx_queue, &midev->unlock_marker);
-	spin_unlock(&midev->tx_queue.lock);
+	if (key->dev_flow_state == MCTP_I2C_FLOW_STATE_ACTIVE) {
+		midev->release_count++;
+		queue_release = true;
+	}
+	key->dev_flow_state = MCTP_I2C_FLOW_STATE_INVALID;
+	spin_unlock_irqrestore(&midev->lock, flags);
 
-	wake_up(&midev->tx_wq);
+	if (queue_release) {
+		/* Ensure we have a release operation queued, through the fake
+		 * marker skb
+		 */
+		spin_lock(&midev->tx_queue.lock);
+		if (!midev->unlock_marker.next)
+			__skb_queue_tail(&midev->tx_queue,
+					 &midev->unlock_marker);
+		spin_unlock(&midev->tx_queue.lock);
+		wake_up(&midev->tx_wq);
+	}
 }
 
 static const struct net_device_ops mctp_i2c_ops = {
diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index 0b1b6f650104..0b9d37979133 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -343,6 +343,8 @@ static void mhi_net_dellink(struct mhi_device *mhi_dev, struct net_device *ndev)
 
 	kfree_skb(mhi_netdev->skbagg_head);
 
+	free_netdev(ndev);
+
 	dev_set_drvdata(&mhi_dev->dev, NULL);
 }
 
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index b17e4e94a060..38562ed833da 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1675,6 +1675,7 @@ void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
 				  ARRAY_SIZE(nsim_devlink_params));
 	devl_resources_unregister(devlink);
 	kfree(nsim_dev->vfconfigs);
+	kfree(nsim_dev->fa_cookie);
 	devl_unlock(devlink);
 	devlink_free(devlink);
 	dev_set_drvdata(&nsim_bus_dev->dev, NULL);
diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 417527f8bbf5..7446d5c6c714 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -682,6 +682,13 @@ static int dp83867_of_init(struct phy_device *phydev)
 	 */
 	dp83867->io_impedance = DP83867_IO_MUX_CFG_IO_IMPEDANCE_MIN / 2;
 
+	/* For non-OF device, the RX and TX FIFO depths are taken from
+	 * default value. So, we init RX & TX FIFO depths here
+	 * so that it is configured correctly later in dp83867_config_init();
+	 */
+	dp83867->tx_fifo_depth = DP83867_PHYCR_FIFO_DEPTH_4_B_NIB;
+	dp83867->rx_fifo_depth = DP83867_PHYCR_FIFO_DEPTH_4_B_NIB;
+
 	return 0;
 }
 #endif /* CONFIG_OF_MDIO */
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index a714150f5e8c..7c292a3d83d4 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2015,14 +2015,16 @@ static int m88e1510_loopback(struct phy_device *phydev, bool enable)
 		if (err < 0)
 			return err;
 
-		/* FIXME: Based on trial and error test, it seem 1G need to have
-		 * delay between soft reset and loopback enablement.
-		 */
-		if (phydev->speed == SPEED_1000)
-			msleep(1000);
+		err = phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
+				 BMCR_LOOPBACK);
 
-		return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
-				  BMCR_LOOPBACK);
+		if (!err) {
+			/* It takes some time for PHY device to switch
+			 * into/out-of loopback mode.
+			 */
+			msleep(1000);
+		}
+		return err;
 	} else {
 		err = phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, 0);
 		if (err < 0)
diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index ab3f04562980..8391f8303499 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1379,12 +1379,21 @@ static int __init tbnet_init(void)
 				  TBNET_MATCH_FRAGS_ID | TBNET_64K_FRAMES);
 
 	ret = tb_register_property_dir("network", tbnet_dir);
-	if (ret) {
-		tb_property_free_dir(tbnet_dir);
-		return ret;
-	}
+	if (ret)
+		goto err_free_dir;
+
+	ret = tb_register_service_driver(&tbnet_driver);
+	if (ret)
+		goto err_unregister;
 
-	return tb_register_service_driver(&tbnet_driver);
+	return 0;
+
+err_unregister:
+	tb_unregister_property_dir("network", tbnet_dir);
+err_free_dir:
+	tb_property_free_dir(tbnet_dir);
+
+	return ret;
 }
 module_init(tbnet_init);
 
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index bfb58c91db04..32d2c60d334d 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -66,6 +66,7 @@ struct smsc95xx_priv {
 	spinlock_t mac_cr_lock;
 	u8 features;
 	u8 suspend_flags;
+	bool is_internal_phy;
 	struct irq_chip irqchip;
 	struct irq_domain *irqdomain;
 	struct fwnode_handle *irqfwnode;
@@ -252,6 +253,43 @@ static void smsc95xx_mdio_write(struct usbnet *dev, int phy_id, int idx,
 	mutex_unlock(&dev->phy_mutex);
 }
 
+static int smsc95xx_mdiobus_reset(struct mii_bus *bus)
+{
+	struct smsc95xx_priv *pdata;
+	struct usbnet *dev;
+	u32 val;
+	int ret;
+
+	dev = bus->priv;
+	pdata = dev->driver_priv;
+
+	if (pdata->is_internal_phy)
+		return 0;
+
+	mutex_lock(&dev->phy_mutex);
+
+	ret = smsc95xx_read_reg(dev, PM_CTRL, &val);
+	if (ret < 0)
+		goto reset_out;
+
+	val |= PM_CTL_PHY_RST_;
+
+	ret = smsc95xx_write_reg(dev, PM_CTRL, val);
+	if (ret < 0)
+		goto reset_out;
+
+	/* Driver has no knowledge at this point about the external PHY.
+	 * The 802.3 specifies that the reset process shall
+	 * be completed within 0.5 s.
+	 */
+	fsleep(500000);
+
+reset_out:
+	mutex_unlock(&dev->phy_mutex);
+
+	return 0;
+}
+
 static int smsc95xx_mdiobus_read(struct mii_bus *bus, int phy_id, int idx)
 {
 	struct usbnet *dev = bus->priv;
@@ -1052,7 +1090,6 @@ static void smsc95xx_handle_link_change(struct net_device *net)
 static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	struct smsc95xx_priv *pdata;
-	bool is_internal_phy;
 	char usb_path[64];
 	int ret, phy_irq;
 	u32 val;
@@ -1133,13 +1170,14 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (ret < 0)
 		goto free_mdio;
 
-	is_internal_phy = !(val & HW_CFG_PSEL_);
-	if (is_internal_phy)
+	pdata->is_internal_phy = !(val & HW_CFG_PSEL_);
+	if (pdata->is_internal_phy)
 		pdata->mdiobus->phy_mask = ~(1u << SMSC95XX_INTERNAL_PHY_ID);
 
 	pdata->mdiobus->priv = dev;
 	pdata->mdiobus->read = smsc95xx_mdiobus_read;
 	pdata->mdiobus->write = smsc95xx_mdiobus_write;
+	pdata->mdiobus->reset = smsc95xx_mdiobus_reset;
 	pdata->mdiobus->name = "smsc95xx-mdiobus";
 	pdata->mdiobus->parent = &dev->udev->dev;
 
@@ -1160,7 +1198,7 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	}
 
 	pdata->phydev->irq = phy_irq;
-	pdata->phydev->is_internal = is_internal_phy;
+	pdata->phydev->is_internal = pdata->is_internal_phy;
 
 	/* detect device revision as different features may be available */
 	ret = smsc95xx_read_reg(dev, ID_REV, &val);
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index d3281f87cd6e..a48a79ed5c4c 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -764,11 +764,17 @@ long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 	case NVME_IOCTL_IO_CMD:
 		return nvme_dev_user_cmd(ctrl, argp);
 	case NVME_IOCTL_RESET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		dev_warn(ctrl->device, "resetting controller\n");
 		return nvme_reset_ctrl_sync(ctrl);
 	case NVME_IOCTL_SUBSYS_RESET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		return nvme_reset_subsystem(ctrl);
 	case NVME_IOCTL_RESCAN:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		nvme_queue_scan(ctrl);
 		return 0;
 	default:
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index a0bf9560cf67..70555022cb44 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -602,11 +602,23 @@ static inline void nvme_fault_inject_fini(struct nvme_fault_inject *fault_inj)
 static inline void nvme_should_fail(struct request *req) {}
 #endif
 
+bool nvme_wait_reset(struct nvme_ctrl *ctrl);
+int nvme_try_sched_reset(struct nvme_ctrl *ctrl);
+
 static inline int nvme_reset_subsystem(struct nvme_ctrl *ctrl)
 {
+	int ret;
+
 	if (!ctrl->subsystem)
 		return -ENOTTY;
-	return ctrl->ops->reg_write32(ctrl, NVME_REG_NSSR, 0x4E564D65);
+	if (!nvme_wait_reset(ctrl))
+		return -EBUSY;
+
+	ret = ctrl->ops->reg_write32(ctrl, NVME_REG_NSSR, 0x4E564D65);
+	if (ret)
+		return ret;
+
+	return nvme_try_sched_reset(ctrl);
 }
 
 /*
@@ -712,7 +724,6 @@ void nvme_cancel_tagset(struct nvme_ctrl *ctrl);
 void nvme_cancel_admin_tagset(struct nvme_ctrl *ctrl);
 bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		enum nvme_ctrl_state new_state);
-bool nvme_wait_reset(struct nvme_ctrl *ctrl);
 int nvme_disable_ctrl(struct nvme_ctrl *ctrl);
 int nvme_enable_ctrl(struct nvme_ctrl *ctrl);
 int nvme_shutdown_ctrl(struct nvme_ctrl *ctrl);
@@ -802,7 +813,6 @@ int nvme_set_queue_count(struct nvme_ctrl *ctrl, int *count);
 void nvme_stop_keep_alive(struct nvme_ctrl *ctrl);
 int nvme_reset_ctrl(struct nvme_ctrl *ctrl);
 int nvme_reset_ctrl_sync(struct nvme_ctrl *ctrl);
-int nvme_try_sched_reset(struct nvme_ctrl *ctrl);
 int nvme_delete_ctrl(struct nvme_ctrl *ctrl);
 void nvme_queue_scan(struct nvme_ctrl *ctrl);
 int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp, u8 csi,
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 554468ea5a2a..1a6423e94eb3 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3488,6 +3488,8 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	 { PCI_DEVICE(0x1344, 0x5407), /* Micron Technology Inc NVMe SSD */
 		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN },
+	 { PCI_DEVICE(0x1344, 0x6001),   /* Micron Nitro NVMe */
+		 .driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1c5c, 0x1504),   /* SK Hynix PC400 */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x1c5c, 0x174a),   /* SK Hynix P31 SSD */
@@ -3518,6 +3520,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x2646, 0x501E),   /* KINGSTON OM3PGP4xxxxQ OS21011 NVMe SSD */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x1f40, 0x5236),   /* Netac Technologies Co. NV7000 NVMe SSD */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1001),   /* MAXIO MAP1001 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1002),   /* MAXIO MAP1002 */
diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index c4113b43dbfe..4dcddcf95279 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -45,9 +45,11 @@ int nvmet_auth_set_key(struct nvmet_host *host, const char *secret,
 	if (!dhchap_secret)
 		return -ENOMEM;
 	if (set_ctrl) {
+		kfree(host->dhchap_ctrl_secret);
 		host->dhchap_ctrl_secret = strim(dhchap_secret);
 		host->dhchap_ctrl_key_hash = key_hash;
 	} else {
+		kfree(host->dhchap_secret);
 		host->dhchap_secret = strim(dhchap_secret);
 		host->dhchap_key_hash = key_hash;
 	}
diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 2bcd60758919..7f52d9dac443 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1811,6 +1811,7 @@ static void nvmet_host_release(struct config_item *item)
 
 #ifdef CONFIG_NVME_TARGET_AUTH
 	kfree(host->dhchap_secret);
+	kfree(host->dhchap_ctrl_secret);
 #endif
 	kfree(host);
 }
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index eda4ded4d5e5..925be41eeebe 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -468,7 +468,7 @@ static size_t parport_pc_fifo_write_block_pio(struct parport *port,
 	const unsigned char *bufp = buf;
 	size_t left = length;
 	unsigned long expire = jiffies + port->physport->cad->timeout;
-	const int fifo = FIFO(port);
+	const unsigned long fifo = FIFO(port);
 	int poll_for = 8; /* 80 usecs */
 	const struct parport_pc_private *priv = port->physport->private_data;
 	const int fifo_depth = priv->fifo_depth;
diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index ef898ee8ca6b..6e0a40962f38 100644
--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -220,6 +220,8 @@ int pinctrl_dt_to_map(struct pinctrl *p, struct pinctrl_dev *pctldev)
 	for (state = 0; ; state++) {
 		/* Retrieve the pinctrl-* property */
 		propname = kasprintf(GFP_KERNEL, "pinctrl-%d", state);
+		if (!propname)
+			return -ENOMEM;
 		prop = of_find_property(np, propname, &size);
 		kfree(propname);
 		if (!prop) {
diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
index e1ae3beb9f72..b7921b59eb7b 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
@@ -709,6 +709,9 @@ static int mtk_pinconf_bias_set_rsel(struct mtk_pinctrl *hw,
 {
 	int err, rsel_val;
 
+	if (!pullup && arg == MTK_DISABLE)
+		return 0;
+
 	if (hw->rsel_si_unit) {
 		/* find pin rsel_index from pin_rsel array*/
 		err = mtk_hw_pin_rsel_lookup(hw, desc, pullup, arg, &rsel_val);
diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index c84bd0e1ce5a..f4d2b64c0670 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -632,14 +632,54 @@ static void rockchip_get_recalced_mux(struct rockchip_pin_bank *bank, int pin,
 }
 
 static struct rockchip_mux_route_data px30_mux_route_data[] = {
+	RK_MUXROUTE_SAME(2, RK_PB4, 1, 0x184, BIT(16 + 7)), /* cif-d0m0 */
+	RK_MUXROUTE_SAME(3, RK_PA1, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d0m1 */
+	RK_MUXROUTE_SAME(2, RK_PB6, 1, 0x184, BIT(16 + 7)), /* cif-d1m0 */
+	RK_MUXROUTE_SAME(3, RK_PA2, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d1m1 */
 	RK_MUXROUTE_SAME(2, RK_PA0, 1, 0x184, BIT(16 + 7)), /* cif-d2m0 */
 	RK_MUXROUTE_SAME(3, RK_PA3, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d2m1 */
+	RK_MUXROUTE_SAME(2, RK_PA1, 1, 0x184, BIT(16 + 7)), /* cif-d3m0 */
+	RK_MUXROUTE_SAME(3, RK_PA5, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d3m1 */
+	RK_MUXROUTE_SAME(2, RK_PA2, 1, 0x184, BIT(16 + 7)), /* cif-d4m0 */
+	RK_MUXROUTE_SAME(3, RK_PA7, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d4m1 */
+	RK_MUXROUTE_SAME(2, RK_PA3, 1, 0x184, BIT(16 + 7)), /* cif-d5m0 */
+	RK_MUXROUTE_SAME(3, RK_PB0, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d5m1 */
+	RK_MUXROUTE_SAME(2, RK_PA4, 1, 0x184, BIT(16 + 7)), /* cif-d6m0 */
+	RK_MUXROUTE_SAME(3, RK_PB1, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d6m1 */
+	RK_MUXROUTE_SAME(2, RK_PA5, 1, 0x184, BIT(16 + 7)), /* cif-d7m0 */
+	RK_MUXROUTE_SAME(3, RK_PB4, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d7m1 */
+	RK_MUXROUTE_SAME(2, RK_PA6, 1, 0x184, BIT(16 + 7)), /* cif-d8m0 */
+	RK_MUXROUTE_SAME(3, RK_PB6, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d8m1 */
+	RK_MUXROUTE_SAME(2, RK_PA7, 1, 0x184, BIT(16 + 7)), /* cif-d9m0 */
+	RK_MUXROUTE_SAME(3, RK_PB7, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d9m1 */
+	RK_MUXROUTE_SAME(2, RK_PB7, 1, 0x184, BIT(16 + 7)), /* cif-d10m0 */
+	RK_MUXROUTE_SAME(3, RK_PC6, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d10m1 */
+	RK_MUXROUTE_SAME(2, RK_PC0, 1, 0x184, BIT(16 + 7)), /* cif-d11m0 */
+	RK_MUXROUTE_SAME(3, RK_PC7, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d11m1 */
+	RK_MUXROUTE_SAME(2, RK_PB0, 1, 0x184, BIT(16 + 7)), /* cif-vsyncm0 */
+	RK_MUXROUTE_SAME(3, RK_PD1, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-vsyncm1 */
+	RK_MUXROUTE_SAME(2, RK_PB1, 1, 0x184, BIT(16 + 7)), /* cif-hrefm0 */
+	RK_MUXROUTE_SAME(3, RK_PD2, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-hrefm1 */
+	RK_MUXROUTE_SAME(2, RK_PB2, 1, 0x184, BIT(16 + 7)), /* cif-clkinm0 */
+	RK_MUXROUTE_SAME(3, RK_PD3, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-clkinm1 */
+	RK_MUXROUTE_SAME(2, RK_PB3, 1, 0x184, BIT(16 + 7)), /* cif-clkoutm0 */
+	RK_MUXROUTE_SAME(3, RK_PD0, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-clkoutm1 */
 	RK_MUXROUTE_SAME(3, RK_PC6, 2, 0x184, BIT(16 + 8)), /* pdm-m0 */
 	RK_MUXROUTE_SAME(2, RK_PC6, 1, 0x184, BIT(16 + 8) | BIT(8)), /* pdm-m1 */
+	RK_MUXROUTE_SAME(3, RK_PD3, 2, 0x184, BIT(16 + 8)), /* pdm-sdi0m0 */
+	RK_MUXROUTE_SAME(2, RK_PC5, 2, 0x184, BIT(16 + 8) | BIT(8)), /* pdm-sdi0m1 */
 	RK_MUXROUTE_SAME(1, RK_PD3, 2, 0x184, BIT(16 + 10)), /* uart2-rxm0 */
 	RK_MUXROUTE_SAME(2, RK_PB6, 2, 0x184, BIT(16 + 10) | BIT(10)), /* uart2-rxm1 */
+	RK_MUXROUTE_SAME(1, RK_PD2, 2, 0x184, BIT(16 + 10)), /* uart2-txm0 */
+	RK_MUXROUTE_SAME(2, RK_PB4, 2, 0x184, BIT(16 + 10) | BIT(10)), /* uart2-txm1 */
 	RK_MUXROUTE_SAME(0, RK_PC1, 2, 0x184, BIT(16 + 9)), /* uart3-rxm0 */
 	RK_MUXROUTE_SAME(1, RK_PB7, 2, 0x184, BIT(16 + 9) | BIT(9)), /* uart3-rxm1 */
+	RK_MUXROUTE_SAME(0, RK_PC0, 2, 0x184, BIT(16 + 9)), /* uart3-txm0 */
+	RK_MUXROUTE_SAME(1, RK_PB6, 2, 0x184, BIT(16 + 9) | BIT(9)), /* uart3-txm1 */
+	RK_MUXROUTE_SAME(0, RK_PC2, 2, 0x184, BIT(16 + 9)), /* uart3-ctsm0 */
+	RK_MUXROUTE_SAME(1, RK_PB4, 2, 0x184, BIT(16 + 9) | BIT(9)), /* uart3-ctsm1 */
+	RK_MUXROUTE_SAME(0, RK_PC3, 2, 0x184, BIT(16 + 9)), /* uart3-rtsm0 */
+	RK_MUXROUTE_SAME(1, RK_PB5, 2, 0x184, BIT(16 + 9) | BIT(9)), /* uart3-rtsm1 */
 };
 
 static struct rockchip_mux_route_data rk3128_mux_route_data[] = {
diff --git a/drivers/platform/surface/aggregator/ssh_packet_layer.c b/drivers/platform/surface/aggregator/ssh_packet_layer.c
index 6748fe4ac5d5..def8d7ac541f 100644
--- a/drivers/platform/surface/aggregator/ssh_packet_layer.c
+++ b/drivers/platform/surface/aggregator/ssh_packet_layer.c
@@ -1596,16 +1596,32 @@ static void ssh_ptl_timeout_reap(struct work_struct *work)
 		ssh_ptl_tx_wakeup_packet(ptl);
 }
 
-static bool ssh_ptl_rx_retransmit_check(struct ssh_ptl *ptl, u8 seq)
+static bool ssh_ptl_rx_retransmit_check(struct ssh_ptl *ptl, const struct ssh_frame *frame)
 {
 	int i;
 
+	/*
+	 * Ignore unsequenced packets. On some devices (notably Surface Pro 9),
+	 * unsequenced events will always be sent with SEQ=0x00. Attempting to
+	 * detect retransmission would thus just block all events.
+	 *
+	 * While sequence numbers would also allow detection of retransmitted
+	 * packets in unsequenced communication, they have only ever been used
+	 * to cover edge-cases in sequenced transmission. In particular, the
+	 * only instance of packets being retransmitted (that we are aware of)
+	 * is due to an ACK timeout. As this does not happen in unsequenced
+	 * communication, skip the retransmission check for those packets
+	 * entirely.
+	 */
+	if (frame->type == SSH_FRAME_TYPE_DATA_NSQ)
+		return false;
+
 	/*
 	 * Check if SEQ has been seen recently (i.e. packet was
 	 * re-transmitted and we should ignore it).
 	 */
 	for (i = 0; i < ARRAY_SIZE(ptl->rx.blocked.seqs); i++) {
-		if (likely(ptl->rx.blocked.seqs[i] != seq))
+		if (likely(ptl->rx.blocked.seqs[i] != frame->seq))
 			continue;
 
 		ptl_dbg(ptl, "ptl: ignoring repeated data packet\n");
@@ -1613,7 +1629,7 @@ static bool ssh_ptl_rx_retransmit_check(struct ssh_ptl *ptl, u8 seq)
 	}
 
 	/* Update list of blocked sequence IDs. */
-	ptl->rx.blocked.seqs[ptl->rx.blocked.offset] = seq;
+	ptl->rx.blocked.seqs[ptl->rx.blocked.offset] = frame->seq;
 	ptl->rx.blocked.offset = (ptl->rx.blocked.offset + 1)
 				  % ARRAY_SIZE(ptl->rx.blocked.seqs);
 
@@ -1624,7 +1640,7 @@ static void ssh_ptl_rx_dataframe(struct ssh_ptl *ptl,
 				 const struct ssh_frame *frame,
 				 const struct ssam_span *payload)
 {
-	if (ssh_ptl_rx_retransmit_check(ptl, frame->seq))
+	if (ssh_ptl_rx_retransmit_check(ptl, frame))
 		return;
 
 	ptl->ops.data_received(ptl, payload);
diff --git a/drivers/platform/x86/amd/pmc.c b/drivers/platform/x86/amd/pmc.c
index 6ccb9b38483c..a838197f8896 100644
--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -274,7 +274,6 @@ static const struct file_operations amd_pmc_stb_debugfs_fops_v2 = {
 	.release = amd_pmc_stb_debugfs_release_v2,
 };
 
-#if defined(CONFIG_SUSPEND) || defined(CONFIG_DEBUG_FS)
 static int amd_pmc_setup_smu_logging(struct amd_pmc_dev *dev)
 {
 	if (dev->cpu_id == AMD_CPU_ID_PCO) {
@@ -349,7 +348,6 @@ static int get_metrics_table(struct amd_pmc_dev *pdev, struct smu_metrics *table
 	memcpy_fromio(table, pdev->smu_virt_addr, sizeof(struct smu_metrics));
 	return 0;
 }
-#endif /* CONFIG_SUSPEND || CONFIG_DEBUG_FS */
 
 #ifdef CONFIG_SUSPEND
 static void amd_pmc_validate_deepest(struct amd_pmc_dev *pdev)
@@ -920,6 +918,7 @@ static const struct acpi_device_id amd_pmc_acpi_ids[] = {
 	{"AMDI0006", 0},
 	{"AMDI0007", 0},
 	{"AMDI0008", 0},
+	{"AMDI0009", 0},
 	{"AMD0004", 0},
 	{"AMD0005", 0},
 	{ }
diff --git a/drivers/platform/x86/intel/pmc/core.c b/drivers/platform/x86/intel/pmc/core.c
index a1fe1e0dcf4a..17ec5825d13d 100644
--- a/drivers/platform/x86/intel/pmc/core.c
+++ b/drivers/platform/x86/intel/pmc/core.c
@@ -1914,6 +1914,8 @@ static const struct x86_cpu_id intel_pmc_core_ids[] = {
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_N,		&tgl_reg_map),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		&adl_reg_map),
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,        &tgl_reg_map),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE,		&adl_reg_map),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S,	&adl_reg_map),
 	{}
 };
 
diff --git a/drivers/platform/x86/intel/pmc/pltdrv.c b/drivers/platform/x86/intel/pmc/pltdrv.c
index 15ca8afdd973..ddfba38c2104 100644
--- a/drivers/platform/x86/intel/pmc/pltdrv.c
+++ b/drivers/platform/x86/intel/pmc/pltdrv.c
@@ -18,6 +18,8 @@
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 
+#include <xen/xen.h>
+
 static void intel_pmc_core_release(struct device *dev)
 {
 	kfree(dev);
@@ -53,6 +55,13 @@ static int __init pmc_core_platform_init(void)
 	if (acpi_dev_present("INT33A1", NULL, -1))
 		return -ENODEV;
 
+	/*
+	 * Skip forcefully attaching the device for VMs. Make an exception for
+	 * Xen dom0, which does have full hardware access.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_HYPERVISOR) && !xen_initial_domain())
+		return -ENODEV;
+
 	if (!x86_match_cpu(intel_pmc_core_platform_ids))
 		return -ENODEV;
 
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 2dbb9fc011a7..353507d18e11 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -263,6 +263,8 @@ enum tpacpi_hkey_event_t {
 #define TPACPI_DBG_BRGHT	0x0020
 #define TPACPI_DBG_MIXER	0x0040
 
+#define FAN_NOT_PRESENT		65535
+
 #define strlencmp(a, b) (strncmp((a), (b), strlen(b)))
 
 
@@ -8876,7 +8878,7 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 			/* Try and probe the 2nd fan */
 			tp_features.second_fan = 1; /* needed for get_speed to work */
 			res = fan2_get_speed(&speed);
-			if (res >= 0) {
+			if (res >= 0 && speed != FAN_NOT_PRESENT) {
 				/* It responded - so let's assume it's there */
 				tp_features.second_fan = 1;
 				tp_features.second_fan_ctl = 1;
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 5187705bd0f3..d961f80c0e36 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -636,6 +636,7 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	dev_info->gd->minors = DCSSBLK_MINORS_PER_DISK;
 	dev_info->gd->fops = &dcssblk_devops;
 	dev_info->gd->private_data = dev_info;
+	dev_info->gd->flags |= GENHD_FL_NO_PART;
 	blk_queue_logical_block_size(dev_info->gd->queue, 4096);
 	blk_queue_flag_set(QUEUE_FLAG_DAX, dev_info->gd->queue);
 
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 19223b075568..ab3ea529cca7 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -884,7 +884,7 @@ static int zfcp_fsf_req_send(struct zfcp_fsf_req *req)
 	const bool is_srb = zfcp_fsf_req_is_status_read_buffer(req);
 	struct zfcp_adapter *adapter = req->adapter;
 	struct zfcp_qdio *qdio = adapter->qdio;
-	int req_id = req->req_id;
+	unsigned long req_id = req->req_id;
 
 	zfcp_reqlist_add(adapter->req_list, req);
 
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b8a76b89f85a..95f940f5c996 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7316,8 +7316,12 @@ static int sdebug_add_host_helper(int per_host_idx)
 	dev_set_name(&sdbg_host->dev, "adapter%d", sdebug_num_hosts);
 
 	error = device_register(&sdbg_host->dev);
-	if (error)
+	if (error) {
+		spin_lock(&sdebug_host_list_lock);
+		list_del(&sdbg_host->host_list);
+		spin_unlock(&sdebug_host_list_lock);
 		goto clean;
+	}
 
 	++sdebug_num_hosts;
 	return 0;
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 2f88c61216ee..74b99f2b0b74 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -722,12 +722,17 @@ int sas_phy_add(struct sas_phy *phy)
 	int error;
 
 	error = device_add(&phy->dev);
-	if (!error) {
-		transport_add_device(&phy->dev);
-		transport_configure_device(&phy->dev);
+	if (error)
+		return error;
+
+	error = transport_add_device(&phy->dev);
+	if (error) {
+		device_del(&phy->dev);
+		return error;
 	}
+	transport_configure_device(&phy->dev);
 
-	return error;
+	return 0;
 }
 EXPORT_SYMBOL(sas_phy_add);
 
diff --git a/drivers/siox/siox-core.c b/drivers/siox/siox-core.c
index 7c4f32d76966..561408583b2b 100644
--- a/drivers/siox/siox-core.c
+++ b/drivers/siox/siox-core.c
@@ -839,6 +839,8 @@ static struct siox_device *siox_device_add(struct siox_master *smaster,
 
 err_device_register:
 	/* don't care to make the buffer smaller again */
+	put_device(&sdevice->dev);
+	sdevice = NULL;
 
 err_buf_alloc:
 	siox_master_unlock(smaster);
diff --git a/drivers/slimbus/Kconfig b/drivers/slimbus/Kconfig
index 1235b7dc8496..e25d280a68ee 100644
--- a/drivers/slimbus/Kconfig
+++ b/drivers/slimbus/Kconfig
@@ -23,7 +23,7 @@ config SLIM_QCOM_CTRL
 config SLIM_QCOM_NGD_CTRL
 	tristate "Qualcomm SLIMbus Satellite Non-Generic Device Component"
 	depends on HAS_IOMEM && DMA_ENGINE && NET && QCOM_RPROC_COMMON
-	depends on ARCH_QCOM || COMPILE_TEST
+	depends on ARCH_QCOM || (COMPILE_TEST && !QCOM_RPROC_COMMON)
 	select QCOM_QMI_HELPERS
 	select QCOM_PDR_HELPERS
 	help
diff --git a/drivers/slimbus/stream.c b/drivers/slimbus/stream.c
index 75f87b3d8b95..73a2aa362957 100644
--- a/drivers/slimbus/stream.c
+++ b/drivers/slimbus/stream.c
@@ -67,10 +67,10 @@ static const int slim_presence_rate_table[] = {
 	384000,
 	768000,
 	0, /* Reserved */
-	110250,
-	220500,
-	441000,
-	882000,
+	11025,
+	22050,
+	44100,
+	88200,
 	176400,
 	352800,
 	705600,
diff --git a/drivers/soc/imx/soc-imx8m.c b/drivers/soc/imx/soc-imx8m.c
index cc57a384d74d..28144c699b0c 100644
--- a/drivers/soc/imx/soc-imx8m.c
+++ b/drivers/soc/imx/soc-imx8m.c
@@ -11,6 +11,7 @@
 #include <linux/platform_device.h>
 #include <linux/arm-smccc.h>
 #include <linux/of.h>
+#include <linux/clk.h>
 
 #define REV_B1				0x21
 
@@ -56,6 +57,7 @@ static u32 __init imx8mq_soc_revision(void)
 	void __iomem *ocotp_base;
 	u32 magic;
 	u32 rev;
+	struct clk *clk;
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx8mq-ocotp");
 	if (!np)
@@ -63,6 +65,13 @@ static u32 __init imx8mq_soc_revision(void)
 
 	ocotp_base = of_iomap(np, 0);
 	WARN_ON(!ocotp_base);
+	clk = of_clk_get_by_name(np, NULL);
+	if (!clk) {
+		WARN_ON(!clk);
+		return 0;
+	}
+
+	clk_prepare_enable(clk);
 
 	/*
 	 * SOC revision on older imx8mq is not available in fuses so query
@@ -79,6 +88,8 @@ static u32 __init imx8mq_soc_revision(void)
 	soc_uid <<= 32;
 	soc_uid |= readl_relaxed(ocotp_base + OCOTP_UID_LOW);
 
+	clk_disable_unprepare(clk);
+	clk_put(clk);
 	iounmap(ocotp_base);
 	of_node_put(np);
 
diff --git a/drivers/spi/spi-intel.c b/drivers/spi/spi-intel.c
index 3f6db482b6c7..a1dbd71bf83e 100644
--- a/drivers/spi/spi-intel.c
+++ b/drivers/spi/spi-intel.c
@@ -114,7 +114,7 @@
 #define ERASE_OPCODE_SHIFT		8
 #define ERASE_OPCODE_MASK		(0xff << ERASE_OPCODE_SHIFT)
 #define ERASE_64K_OPCODE_SHIFT		16
-#define ERASE_64K_OPCODE_MASK		(0xff << ERASE_OPCODE_SHIFT)
+#define ERASE_64K_OPCODE_MASK		(0xff << ERASE_64K_OPCODE_SHIFT)
 
 #define INTEL_SPI_TIMEOUT		5000 /* ms */
 #define INTEL_SPI_FIFO_SZ		64
diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 6fe617b445a5..3c2fa2e2f94a 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -886,6 +886,7 @@ static irqreturn_t stm32h7_spi_irq_thread(int irq, void *dev_id)
 		static DEFINE_RATELIMIT_STATE(rs,
 					      DEFAULT_RATELIMIT_INTERVAL * 10,
 					      1);
+		ratelimit_set_flags(&rs, RATELIMIT_MSG_ON_RELEASE);
 		if (__ratelimit(&rs))
 			dev_dbg_ratelimited(spi->dev, "Communication suspended\n");
 		if (!spi->cur_usedma && (spi->rx_buf && (spi->rx_len > 0)))
diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index c89592b21ffc..904972606bd4 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1157,6 +1157,11 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 		msg->actual_length += xfer->len;
 		transfer_phase++;
 	}
+	if (!xfer->cs_change) {
+		tegra_qspi_transfer_end(spi);
+		spi_transfer_delay_exec(xfer);
+	}
+	ret = 0;
 
 exit:
 	msg->status = ret;
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 4407b56aa6d1..139031ccb700 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -397,6 +397,7 @@ static int tcm_loop_setup_hba_bus(struct tcm_loop_hba *tl_hba, int tcm_loop_host
 	ret = device_register(&tl_hba->dev);
 	if (ret) {
 		pr_err("device_register() failed for tl_hba->dev: %d\n", ret);
+		put_device(&tl_hba->dev);
 		return -ENODEV;
 	}
 
@@ -1073,7 +1074,7 @@ static struct se_wwn *tcm_loop_make_scsi_hba(
 	 */
 	ret = tcm_loop_setup_hba_bus(tl_hba, tcm_loop_hba_no_cnt);
 	if (ret)
-		goto out;
+		return ERR_PTR(ret);
 
 	sh = tl_hba->sh;
 	tcm_loop_hba_no_cnt++;
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 01c112e2e214..2a0de70e0be4 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1670,7 +1670,7 @@ static struct gsm_control *gsm_control_send(struct gsm_mux *gsm,
 		unsigned int command, u8 *data, int clen)
 {
 	struct gsm_control *ctrl = kzalloc(sizeof(struct gsm_control),
-						GFP_KERNEL);
+						GFP_ATOMIC);
 	unsigned long flags;
 	if (ctrl == NULL)
 		return NULL;
diff --git a/drivers/tty/serial/8250/8250_lpss.c b/drivers/tty/serial/8250/8250_lpss.c
index 4ba43bef9933..93643fe6fd9c 100644
--- a/drivers/tty/serial/8250/8250_lpss.c
+++ b/drivers/tty/serial/8250/8250_lpss.c
@@ -174,6 +174,8 @@ static int ehl_serial_setup(struct lpss8250 *lpss, struct uart_port *port)
 	 */
 	up->dma = dma;
 
+	lpss->dma_maxburst = 16;
+
 	port->set_termios = dw8250_do_set_termios;
 
 	return 0;
@@ -277,8 +279,13 @@ static int lpss8250_dma_setup(struct lpss8250 *lpss, struct uart_8250_port *port
 	struct dw_dma_slave *rx_param, *tx_param;
 	struct device *dev = port->port.dev;
 
-	if (!lpss->dma_param.dma_dev)
+	if (!lpss->dma_param.dma_dev) {
+		dma = port->dma;
+		if (dma)
+			goto out_configuration_only;
+
 		return 0;
+	}
 
 	rx_param = devm_kzalloc(dev, sizeof(*rx_param), GFP_KERNEL);
 	if (!rx_param)
@@ -289,16 +296,18 @@ static int lpss8250_dma_setup(struct lpss8250 *lpss, struct uart_8250_port *port
 		return -ENOMEM;
 
 	*rx_param = lpss->dma_param;
-	dma->rxconf.src_maxburst = lpss->dma_maxburst;
-
 	*tx_param = lpss->dma_param;
-	dma->txconf.dst_maxburst = lpss->dma_maxburst;
 
 	dma->fn = lpss8250_dma_filter;
 	dma->rx_param = rx_param;
 	dma->tx_param = tx_param;
 
 	port->dma = dma;
+
+out_configuration_only:
+	dma->rxconf.src_maxburst = lpss->dma_maxburst;
+	dma->txconf.dst_maxburst = lpss->dma_maxburst;
+
 	return 0;
 }
 
diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 38ee3e42251a..b96fbf8d31df 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -157,7 +157,11 @@ static u32 uart_read(struct uart_8250_port *up, u32 reg)
 	return readl(up->port.membase + (reg << up->port.regshift));
 }
 
-static void omap8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
+/*
+ * Called on runtime PM resume path from omap8250_restore_regs(), and
+ * omap8250_set_mctrl().
+ */
+static void __omap8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
 	struct omap8250_priv *priv = up->port.private_data;
@@ -181,6 +185,20 @@ static void omap8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 	}
 }
 
+static void omap8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	int err;
+
+	err = pm_runtime_resume_and_get(port->dev);
+	if (err)
+		return;
+
+	__omap8250_set_mctrl(port, mctrl);
+
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
+}
+
 /*
  * Work Around for Errata i202 (2430, 3430, 3630, 4430 and 4460)
  * The access to uart register after MDR1 Access
@@ -193,27 +211,10 @@ static void omap8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 static void omap_8250_mdr1_errataset(struct uart_8250_port *up,
 				     struct omap8250_priv *priv)
 {
-	u8 timeout = 255;
-
 	serial_out(up, UART_OMAP_MDR1, priv->mdr1);
 	udelay(2);
 	serial_out(up, UART_FCR, up->fcr | UART_FCR_CLEAR_XMIT |
 			UART_FCR_CLEAR_RCVR);
-	/*
-	 * Wait for FIFO to empty: when empty, RX_FIFO_E bit is 0 and
-	 * TX_FIFO_E bit is 1.
-	 */
-	while (UART_LSR_THRE != (serial_in(up, UART_LSR) &
-				(UART_LSR_THRE | UART_LSR_DR))) {
-		timeout--;
-		if (!timeout) {
-			/* Should *never* happen. we warn and carry on */
-			dev_crit(up->port.dev, "Errata i202: timedout %x\n",
-				 serial_in(up, UART_LSR));
-			break;
-		}
-		udelay(1);
-	}
 }
 
 static void omap_8250_get_divisor(struct uart_port *port, unsigned int baud,
@@ -341,7 +342,7 @@ static void omap8250_restore_regs(struct uart_8250_port *up)
 
 	omap8250_update_mdr1(up, priv);
 
-	up->port.ops->set_mctrl(&up->port, up->port.mctrl);
+	__omap8250_set_mctrl(&up->port, up->port.mctrl);
 
 	if (up->port.rs485.flags & SER_RS485_ENABLED)
 		serial8250_em485_stop_tx(up);
@@ -1460,9 +1461,15 @@ static int omap8250_probe(struct platform_device *pdev)
 static int omap8250_remove(struct platform_device *pdev)
 {
 	struct omap8250_priv *priv = platform_get_drvdata(pdev);
+	int err;
+
+	err = pm_runtime_resume_and_get(&pdev->dev);
+	if (err)
+		return err;
 
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
+	flush_work(&priv->qos_work);
 	pm_runtime_disable(&pdev->dev);
 	serial8250_unregister_port(priv->line);
 	cpu_latency_qos_remove_request(&priv->pm_qos_request);
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 2030a92ac66e..ca7415360f10 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1892,10 +1892,13 @@ EXPORT_SYMBOL_GPL(serial8250_modem_status);
 static bool handle_rx_dma(struct uart_8250_port *up, unsigned int iir)
 {
 	switch (iir & 0x3f) {
-	case UART_IIR_RX_TIMEOUT:
-		serial8250_rx_dma_flush(up);
+	case UART_IIR_RDI:
+		if (!up->dma->rx_running)
+			break;
 		fallthrough;
 	case UART_IIR_RLSI:
+	case UART_IIR_RX_TIMEOUT:
+		serial8250_rx_dma_flush(up);
 		return true;
 	}
 	return up->dma->rx_dma(up);
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 34990901c805..c8297102e087 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -12,6 +12,7 @@
 #include <linux/dmaengine.h>
 #include <linux/dmapool.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -404,33 +405,6 @@ static unsigned int lpuart_get_baud_clk_rate(struct lpuart_port *sport)
 #define lpuart_enable_clks(x)	__lpuart_enable_clks(x, true)
 #define lpuart_disable_clks(x)	__lpuart_enable_clks(x, false)
 
-static int lpuart_global_reset(struct lpuart_port *sport)
-{
-	struct uart_port *port = &sport->port;
-	void __iomem *global_addr;
-	int ret;
-
-	if (uart_console(port))
-		return 0;
-
-	ret = clk_prepare_enable(sport->ipg_clk);
-	if (ret) {
-		dev_err(sport->port.dev, "failed to enable uart ipg clk: %d\n", ret);
-		return ret;
-	}
-
-	if (is_imx7ulp_lpuart(sport) || is_imx8qxp_lpuart(sport)) {
-		global_addr = port->membase + UART_GLOBAL - IMX_REG_OFF;
-		writel(UART_GLOBAL_RST, global_addr);
-		usleep_range(GLOBAL_RST_MIN_US, GLOBAL_RST_MAX_US);
-		writel(0, global_addr);
-		usleep_range(GLOBAL_RST_MIN_US, GLOBAL_RST_MAX_US);
-	}
-
-	clk_disable_unprepare(sport->ipg_clk);
-	return 0;
-}
-
 static void lpuart_stop_tx(struct uart_port *port)
 {
 	unsigned char temp;
@@ -2641,6 +2615,54 @@ static const struct serial_rs485 lpuart_rs485_supported = {
 	/* delay_rts_* and RX_DURING_TX are not supported */
 };
 
+static int lpuart_global_reset(struct lpuart_port *sport)
+{
+	struct uart_port *port = &sport->port;
+	void __iomem *global_addr;
+	unsigned long ctrl, bd;
+	unsigned int val = 0;
+	int ret;
+
+	ret = clk_prepare_enable(sport->ipg_clk);
+	if (ret) {
+		dev_err(sport->port.dev, "failed to enable uart ipg clk: %d\n", ret);
+		return ret;
+	}
+
+	if (is_imx7ulp_lpuart(sport) || is_imx8qxp_lpuart(sport)) {
+		/*
+		 * If the transmitter is used by earlycon, wait for transmit engine to
+		 * complete and then reset.
+		 */
+		ctrl = lpuart32_read(port, UARTCTRL);
+		if (ctrl & UARTCTRL_TE) {
+			bd = lpuart32_read(&sport->port, UARTBAUD);
+			if (read_poll_timeout(lpuart32_tx_empty, val, val, 1, 100000, false,
+					      port)) {
+				dev_warn(sport->port.dev,
+					 "timeout waiting for transmit engine to complete\n");
+				clk_disable_unprepare(sport->ipg_clk);
+				return 0;
+			}
+		}
+
+		global_addr = port->membase + UART_GLOBAL - IMX_REG_OFF;
+		writel(UART_GLOBAL_RST, global_addr);
+		usleep_range(GLOBAL_RST_MIN_US, GLOBAL_RST_MAX_US);
+		writel(0, global_addr);
+		usleep_range(GLOBAL_RST_MIN_US, GLOBAL_RST_MAX_US);
+
+		/* Recover the transmitter for earlycon. */
+		if (ctrl & UARTCTRL_TE) {
+			lpuart32_write(port, bd, UARTBAUD);
+			lpuart32_write(port, ctrl, UARTCTRL);
+		}
+	}
+
+	clk_disable_unprepare(sport->ipg_clk);
+	return 0;
+}
+
 static int lpuart_probe(struct platform_device *pdev)
 {
 	const struct lpuart_soc_data *sdata = of_device_get_match_data(&pdev->dev);
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 278b4033a3cc..57e3fda979ea 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2594,6 +2594,7 @@ static const struct dev_pm_ops imx_uart_pm_ops = {
 	.suspend_noirq = imx_uart_suspend_noirq,
 	.resume_noirq = imx_uart_resume_noirq,
 	.freeze_noirq = imx_uart_suspend_noirq,
+	.thaw_noirq = imx_uart_resume_noirq,
 	.restore_noirq = imx_uart_resume_noirq,
 	.suspend = imx_uart_suspend,
 	.resume = imx_uart_resume,
diff --git a/drivers/usb/cdns3/host.c b/drivers/usb/cdns3/host.c
index 9643b905e2d8..6164fc4c96a4 100644
--- a/drivers/usb/cdns3/host.c
+++ b/drivers/usb/cdns3/host.c
@@ -24,11 +24,37 @@
 #define CFG_RXDET_P3_EN		BIT(15)
 #define LPM_2_STB_SWITCH_EN	BIT(25)
 
-static int xhci_cdns3_suspend_quirk(struct usb_hcd *hcd);
+static void xhci_cdns3_plat_start(struct usb_hcd *hcd)
+{
+	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
+	u32 value;
+
+	/* set usbcmd.EU3S */
+	value = readl(&xhci->op_regs->command);
+	value |= CMD_PM_INDEX;
+	writel(value, &xhci->op_regs->command);
+
+	if (hcd->regs) {
+		value = readl(hcd->regs + XECP_AUX_CTRL_REG1);
+		value |= CFG_RXDET_P3_EN;
+		writel(value, hcd->regs + XECP_AUX_CTRL_REG1);
+
+		value = readl(hcd->regs + XECP_PORT_CAP_REG);
+		value |= LPM_2_STB_SWITCH_EN;
+		writel(value, hcd->regs + XECP_PORT_CAP_REG);
+	}
+}
+
+static int xhci_cdns3_resume_quirk(struct usb_hcd *hcd)
+{
+	xhci_cdns3_plat_start(hcd);
+	return 0;
+}
 
 static const struct xhci_plat_priv xhci_plat_cdns3_xhci = {
 	.quirks = XHCI_SKIP_PHY_INIT | XHCI_AVOID_BEI,
-	.suspend_quirk = xhci_cdns3_suspend_quirk,
+	.plat_start = xhci_cdns3_plat_start,
+	.resume_quirk = xhci_cdns3_resume_quirk,
 };
 
 static int __cdns_host_init(struct cdns *cdns)
@@ -90,32 +116,6 @@ static int __cdns_host_init(struct cdns *cdns)
 	return ret;
 }
 
-static int xhci_cdns3_suspend_quirk(struct usb_hcd *hcd)
-{
-	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
-	u32 value;
-
-	if (pm_runtime_status_suspended(hcd->self.controller))
-		return 0;
-
-	/* set usbcmd.EU3S */
-	value = readl(&xhci->op_regs->command);
-	value |= CMD_PM_INDEX;
-	writel(value, &xhci->op_regs->command);
-
-	if (hcd->regs) {
-		value = readl(hcd->regs + XECP_AUX_CTRL_REG1);
-		value |= CFG_RXDET_P3_EN;
-		writel(value, hcd->regs + XECP_AUX_CTRL_REG1);
-
-		value = readl(hcd->regs + XECP_PORT_CAP_REG);
-		value |= LPM_2_STB_SWITCH_EN;
-		writel(value, hcd->regs + XECP_PORT_CAP_REG);
-	}
-
-	return 0;
-}
-
 static void cdns_host_exit(struct cdns *cdns)
 {
 	kfree(cdns->xhci_plat_data);
diff --git a/drivers/usb/chipidea/otg_fsm.c b/drivers/usb/chipidea/otg_fsm.c
index 61b157b9c662..a78584624288 100644
--- a/drivers/usb/chipidea/otg_fsm.c
+++ b/drivers/usb/chipidea/otg_fsm.c
@@ -256,8 +256,10 @@ static void ci_otg_del_timer(struct ci_hdrc *ci, enum otg_fsm_timer t)
 	ci->enabled_otg_timer_bits &= ~(1 << t);
 	if (ci->next_otg_timer == t) {
 		if (ci->enabled_otg_timer_bits == 0) {
+			spin_unlock_irqrestore(&ci->lock, flags);
 			/* No enabled timers after delete it */
 			hrtimer_cancel(&ci->otg_fsm_hrtimer);
+			spin_lock_irqsave(&ci->lock, flags);
 			ci->next_otg_timer = NUM_OTG_FSM_TIMERS;
 		} else {
 			/* Find the next timer */
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 0722d2131305..079e183cf3bf 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -362,6 +362,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x0781, 0x5583), .driver_info = USB_QUIRK_NO_LPM },
 	{ USB_DEVICE(0x0781, 0x5591), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Realforce 87U Keyboard */
+	{ USB_DEVICE(0x0853, 0x011b), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* M-Systems Flash Disk Pioneers */
 	{ USB_DEVICE(0x08ec, 0x1000), .driver_info = USB_QUIRK_RESET_RESUME },
 
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index d03e1a9c144c..038140b1de37 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1710,6 +1710,16 @@ static struct extcon_dev *dwc3_get_extcon(struct dwc3 *dwc)
 	if (device_property_read_string(dev, "linux,extcon-name", &name) == 0)
 		return extcon_get_extcon_dev(name);
 
+	/*
+	 * Check explicitly if "usb-role-switch" is used since
+	 * extcon_find_edev_by_node() can not be used to check the absence of
+	 * an extcon device. In the absence of an device it will always return
+	 * EPROBE_DEFER.
+	 */
+	if (IS_ENABLED(CONFIG_USB_ROLE_SWITCH) &&
+	    device_property_read_bool(dev, "usb-role-switch"))
+		return NULL;
+
 	/*
 	 * Try to get an extcon device from the USB PHY controller's "port"
 	 * node. Check if it has the "port" node first, to avoid printing the
diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
index a7154fe8206d..f6f13e7f1ba1 100644
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -11,13 +11,8 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 
-#include "../host/xhci-plat.h"
 #include "core.h"
 
-static const struct xhci_plat_priv dwc3_xhci_plat_priv = {
-	.quirks = XHCI_SKIP_PHY_INIT,
-};
-
 static void dwc3_host_fill_xhci_irq_res(struct dwc3 *dwc,
 					int irq, char *name)
 {
@@ -97,11 +92,6 @@ int dwc3_host_init(struct dwc3 *dwc)
 		goto err;
 	}
 
-	ret = platform_device_add_data(xhci, &dwc3_xhci_plat_priv,
-					sizeof(dwc3_xhci_plat_priv));
-	if (ret)
-		goto err;
-
 	memset(props, 0, sizeof(struct property_entry) * ARRAY_SIZE(props));
 
 	if (dwc->usb3_lpm_capable)
diff --git a/drivers/usb/host/bcma-hcd.c b/drivers/usb/host/bcma-hcd.c
index 2df52f75f6b3..7558cc4d90cc 100644
--- a/drivers/usb/host/bcma-hcd.c
+++ b/drivers/usb/host/bcma-hcd.c
@@ -285,7 +285,7 @@ static void bcma_hci_platform_power_gpio(struct bcma_device *dev, bool val)
 {
 	struct bcma_hcd_device *usb_dev = bcma_get_drvdata(dev);
 
-	if (IS_ERR_OR_NULL(usb_dev->gpio_desc))
+	if (!usb_dev->gpio_desc)
 		return;
 
 	gpiod_set_value(usb_dev->gpio_desc, val);
@@ -406,9 +406,11 @@ static int bcma_hcd_probe(struct bcma_device *core)
 		return -ENOMEM;
 	usb_dev->core = core;
 
-	if (core->dev.of_node)
-		usb_dev->gpio_desc = devm_gpiod_get(&core->dev, "vcc",
-						    GPIOD_OUT_HIGH);
+	usb_dev->gpio_desc = devm_gpiod_get_optional(&core->dev, "vcc",
+						     GPIOD_OUT_HIGH);
+	if (IS_ERR(usb_dev->gpio_desc))
+		return dev_err_probe(&core->dev, PTR_ERR(usb_dev->gpio_desc),
+				     "error obtaining VCC GPIO");
 
 	switch (core->id.id) {
 	case BCMA_CORE_USB20_HOST:
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 697683e3fbff..c3b7f1d98e78 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -162,6 +162,8 @@ static void option_instat_callback(struct urb *urb);
 #define NOVATELWIRELESS_PRODUCT_G2		0xA010
 #define NOVATELWIRELESS_PRODUCT_MC551		0xB001
 
+#define UBLOX_VENDOR_ID				0x1546
+
 /* AMOI PRODUCTS */
 #define AMOI_VENDOR_ID				0x1614
 #define AMOI_PRODUCT_H01			0x0800
@@ -240,7 +242,6 @@ static void option_instat_callback(struct urb *urb);
 #define QUECTEL_PRODUCT_UC15			0x9090
 /* These u-blox products use Qualcomm's vendor ID */
 #define UBLOX_PRODUCT_R410M			0x90b2
-#define UBLOX_PRODUCT_R6XX			0x90fa
 /* These Yuga products use Qualcomm's vendor ID */
 #define YUGA_PRODUCT_CLM920_NC5			0x9625
 
@@ -581,6 +582,9 @@ static void option_instat_callback(struct urb *urb);
 #define OPPO_VENDOR_ID				0x22d9
 #define OPPO_PRODUCT_R11			0x276c
 
+/* Sierra Wireless products */
+#define SIERRA_VENDOR_ID			0x1199
+#define SIERRA_PRODUCT_EM9191			0x90d3
 
 /* Device flags */
 
@@ -1124,8 +1128,16 @@ static const struct usb_device_id option_ids[] = {
 	/* u-blox products using Qualcomm vendor ID */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R410M),
 	  .driver_info = RSVD(1) | RSVD(3) },
-	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R6XX),
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x908b),	/* u-blox LARA-R6 00B */
+	  .driver_info = RSVD(4) },
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x90fa),
 	  .driver_info = RSVD(3) },
+	/* u-blox products */
+	{ USB_DEVICE(UBLOX_VENDOR_ID, 0x1341) },	/* u-blox LARA-L6 */
+	{ USB_DEVICE(UBLOX_VENDOR_ID, 0x1342),		/* u-blox LARA-L6 (RMNET) */
+	  .driver_info = RSVD(4) },
+	{ USB_DEVICE(UBLOX_VENDOR_ID, 0x1343),		/* u-blox LARA-L6 (ECM) */
+	  .driver_info = RSVD(4) },
 	/* Quectel products using Quectel vendor ID */
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC21, 0xff, 0xff, 0xff),
 	  .driver_info = NUMEP2 },
@@ -2167,6 +2179,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x010a, 0xff) },			/* Fibocom MA510 (ECM mode) */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x010b, 0xff, 0xff, 0x30) },	/* Fibocom FG150 Diag */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x010b, 0xff, 0, 0) },		/* Fibocom FG150 AT */
+	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0111, 0xff) },			/* Fibocom FM160 (MBIM mode) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a0, 0xff) },			/* Fibocom NL668-AM/NL652-EU (laptop MBIM) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a2, 0xff) },			/* Fibocom FM101-GL (laptop MBIM) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a4, 0xff),			/* Fibocom FM101-GL (laptop MBIM) */
@@ -2176,6 +2189,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1405, 0xff) },			/* GosunCn GM500 MBIM */
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1406, 0xff) },			/* GosunCn GM500 ECM/NCM */
 	{ USB_DEVICE_AND_INTERFACE_INFO(OPPO_VENDOR_ID, OPPO_PRODUCT_R11, 0xff, 0xff, 0x30) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(SIERRA_VENDOR_ID, SIERRA_PRODUCT_EM9191, 0xff, 0xff, 0x30) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(SIERRA_VENDOR_ID, SIERRA_PRODUCT_EM9191, 0xff, 0, 0) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
diff --git a/drivers/usb/typec/mux/intel_pmc_mux.c b/drivers/usb/typec/mux/intel_pmc_mux.c
index a8e273fe204a..795829ffe776 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -369,13 +369,24 @@ pmc_usb_mux_usb4(struct pmc_usb_port *port, struct typec_mux_state *state)
 	return pmc_usb_command(port, (void *)&req, sizeof(req));
 }
 
-static int pmc_usb_mux_safe_state(struct pmc_usb_port *port)
+static int pmc_usb_mux_safe_state(struct pmc_usb_port *port,
+				  struct typec_mux_state *state)
 {
 	u8 msg;
 
 	if (IOM_PORT_ACTIVITY_IS(port->iom_status, SAFE_MODE))
 		return 0;
 
+	if ((IOM_PORT_ACTIVITY_IS(port->iom_status, DP) ||
+	     IOM_PORT_ACTIVITY_IS(port->iom_status, DP_MFD)) &&
+	     state->alt && state->alt->svid == USB_TYPEC_DP_SID)
+		return 0;
+
+	if ((IOM_PORT_ACTIVITY_IS(port->iom_status, TBT) ||
+	     IOM_PORT_ACTIVITY_IS(port->iom_status, ALT_MODE_TBT_USB)) &&
+	     state->alt && state->alt->svid == USB_TYPEC_TBT_SID)
+		return 0;
+
 	msg = PMC_USB_SAFE_MODE;
 	msg |= port->usb3_port << PMC_USB_MSG_USB3_PORT_SHIFT;
 
@@ -443,7 +454,7 @@ pmc_usb_mux_set(struct typec_mux_dev *mux, struct typec_mux_state *state)
 		return 0;
 
 	if (state->mode == TYPEC_STATE_SAFE)
-		return pmc_usb_mux_safe_state(port);
+		return pmc_usb_mux_safe_state(port, state);
 	if (state->mode == TYPEC_STATE_USB)
 		return pmc_usb_connect(port, port->role);
 
diff --git a/drivers/usb/typec/tipd/core.c b/drivers/usb/typec/tipd/core.c
index dfbba5ae9487..92e35e62e78c 100644
--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -474,7 +474,7 @@ static void tps6598x_handle_plug_event(struct tps6598x *tps, u32 status)
 static irqreturn_t cd321x_interrupt(int irq, void *data)
 {
 	struct tps6598x *tps = data;
-	u64 event;
+	u64 event = 0;
 	u32 status;
 	int ret;
 
@@ -519,8 +519,8 @@ static irqreturn_t cd321x_interrupt(int irq, void *data)
 static irqreturn_t tps6598x_interrupt(int irq, void *data)
 {
 	struct tps6598x *tps = data;
-	u64 event1;
-	u64 event2;
+	u64 event1 = 0;
+	u64 event2 = 0;
 	u32 status;
 	int ret;
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 7cb56c382c97..48ceca04d9b8 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -710,8 +710,9 @@ EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 /*
  * VFIO base fd, /dev/vfio/vfio
  */
-static long vfio_ioctl_check_extension(struct vfio_container *container,
-				       unsigned long arg)
+static long
+vfio_container_ioctl_check_extension(struct vfio_container *container,
+				     unsigned long arg)
 {
 	struct vfio_iommu_driver *driver;
 	long ret = 0;
@@ -868,7 +869,7 @@ static long vfio_fops_unl_ioctl(struct file *filep,
 		ret = VFIO_API_VERSION;
 		break;
 	case VFIO_CHECK_EXTENSION:
-		ret = vfio_ioctl_check_extension(container, arg);
+		ret = vfio_container_ioctl_check_extension(container, arg);
 		break;
 	case VFIO_SET_IOMMU:
 		ret = vfio_ioctl_set_iommu(container, arg);
@@ -1085,9 +1086,28 @@ static void vfio_device_unassign_container(struct vfio_device *device)
 	up_write(&device->group->group_rwsem);
 }
 
+static void vfio_device_container_register(struct vfio_device *device)
+{
+	struct vfio_iommu_driver *iommu_driver =
+		device->group->container->iommu_driver;
+
+	if (iommu_driver && iommu_driver->ops->register_device)
+		iommu_driver->ops->register_device(
+			device->group->container->iommu_data, device);
+}
+
+static void vfio_device_container_unregister(struct vfio_device *device)
+{
+	struct vfio_iommu_driver *iommu_driver =
+		device->group->container->iommu_driver;
+
+	if (iommu_driver && iommu_driver->ops->unregister_device)
+		iommu_driver->ops->unregister_device(
+			device->group->container->iommu_data, device);
+}
+
 static struct file *vfio_device_open(struct vfio_device *device)
 {
-	struct vfio_iommu_driver *iommu_driver;
 	struct file *filep;
 	int ret;
 
@@ -1118,12 +1138,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
 			if (ret)
 				goto err_undo_count;
 		}
-
-		iommu_driver = device->group->container->iommu_driver;
-		if (iommu_driver && iommu_driver->ops->register_device)
-			iommu_driver->ops->register_device(
-				device->group->container->iommu_data, device);
-
+		vfio_device_container_register(device);
 		up_read(&device->group->group_rwsem);
 	}
 	mutex_unlock(&device->dev_set->lock);
@@ -1161,10 +1176,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	if (device->open_count == 1 && device->ops->close_device) {
 		device->ops->close_device(device);
 
-		iommu_driver = device->group->container->iommu_driver;
-		if (iommu_driver && iommu_driver->ops->unregister_device)
-			iommu_driver->ops->unregister_device(
-				device->group->container->iommu_data, device);
+		vfio_device_container_unregister(device);
 	}
 err_undo_count:
 	up_read(&device->group->group_rwsem);
@@ -1360,7 +1372,6 @@ static const struct file_operations vfio_group_fops = {
 static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 {
 	struct vfio_device *device = filep->private_data;
-	struct vfio_iommu_driver *iommu_driver;
 
 	mutex_lock(&device->dev_set->lock);
 	vfio_assert_device_open(device);
@@ -1368,10 +1379,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	if (device->open_count == 1 && device->ops->close_device)
 		device->ops->close_device(device);
 
-	iommu_driver = device->group->container->iommu_driver;
-	if (iommu_driver && iommu_driver->ops->unregister_device)
-		iommu_driver->ops->unregister_device(
-			device->group->container->iommu_data, device);
+	vfio_device_container_unregister(device);
 	up_read(&device->group->group_rwsem);
 	device->open_count--;
 	if (device->open_count == 0)
@@ -1763,8 +1771,8 @@ bool vfio_file_enforced_coherent(struct file *file)
 
 	down_read(&group->group_rwsem);
 	if (group->container) {
-		ret = vfio_ioctl_check_extension(group->container,
-						 VFIO_DMA_CC_IOMMU);
+		ret = vfio_container_ioctl_check_extension(group->container,
+							   VFIO_DMA_CC_IOMMU);
 	} else {
 		/*
 		 * Since the coherency state is determined only once a container
diff --git a/drivers/xen/pcpu.c b/drivers/xen/pcpu.c
index 47aa3a1ccaf5..fd3a644b0855 100644
--- a/drivers/xen/pcpu.c
+++ b/drivers/xen/pcpu.c
@@ -228,7 +228,7 @@ static int register_pcpu(struct pcpu *pcpu)
 
 	err = device_register(dev);
 	if (err) {
-		pcpu_release(dev);
+		put_device(dev);
 		return err;
 	}
 
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 2feb5c20641a..a21b9e085d1b 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2767,8 +2767,10 @@ raid56_alloc_missing_rbio(struct bio *bio, struct btrfs_io_context *bioc)
 
 	rbio->faila = find_logical_bio_stripe(rbio, bio);
 	if (rbio->faila == -1) {
-		BUG();
-		kfree(rbio);
+		btrfs_warn_rl(fs_info,
+	"can not determine the failed stripe number for full stripe %llu",
+			      bioc->raid_map[0]);
+		__free_raid_bio(rbio);
 		return NULL;
 	}
 
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index 843dd3d3adbe..63676ea19f29 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -225,7 +225,6 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	 */
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots, false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -240,7 +239,6 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -252,17 +250,18 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 		return ret;
 	}
 
+	/* btrfs_qgroup_account_extent() always frees the ulists passed to it. */
+	old_roots = NULL;
+	new_roots = NULL;
+
 	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID,
 				nodesize, nodesize)) {
 		test_err("qgroup counts didn't match expected values");
 		return -EINVAL;
 	}
-	old_roots = NULL;
-	new_roots = NULL;
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots, false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -276,7 +275,6 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -326,7 +324,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots, false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -341,7 +338,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -361,7 +357,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots, false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -376,7 +371,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -402,7 +396,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots, false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -417,7 +410,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
diff --git a/fs/buffer.c b/fs/buffer.c
index 55e762a58eb6..e1198f4b28c8 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2352,7 +2352,7 @@ int generic_cont_expand_simple(struct inode *inode, loff_t size)
 	struct address_space *mapping = inode->i_mapping;
 	const struct address_space_operations *aops = mapping->a_ops;
 	struct page *page;
-	void *fsdata;
+	void *fsdata = NULL;
 	int err;
 
 	err = inode_newsize_ok(inode, size);
@@ -2378,7 +2378,7 @@ static int cont_expand_zero(struct file *file, struct address_space *mapping,
 	const struct address_space_operations *aops = mapping->a_ops;
 	unsigned int blocksize = i_blocksize(inode);
 	struct page *page;
-	void *fsdata;
+	void *fsdata = NULL;
 	pgoff_t index, curidx;
 	loff_t curpos;
 	unsigned zerofrom, offset, len;
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 864cdaa0d2bd..e4151852184e 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -763,7 +763,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	struct ceph_mds_snap_realm *ri;    /* encoded */
 	__le64 *snaps;                     /* encoded */
 	__le64 *prior_parent_snaps;        /* encoded */
-	struct ceph_snap_realm *realm = NULL;
+	struct ceph_snap_realm *realm;
 	struct ceph_snap_realm *first_realm = NULL;
 	struct ceph_snap_realm *realm_to_rebuild = NULL;
 	int rebuild_snapcs;
@@ -774,6 +774,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 
 	dout("%s deletion=%d\n", __func__, deletion);
 more:
+	realm = NULL;
 	rebuild_snapcs = 0;
 	ceph_decode_need(&p, e, sizeof(*ri), bad);
 	ri = p;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c2c36451a883..317ca1be9c4c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3846,9 +3846,13 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	uuid_copy(&cifs_sb->dfs_mount_id, &mnt_ctx.mount_id);
 
 out:
-	free_xid(mnt_ctx.xid);
 	cifs_try_adding_channels(cifs_sb, mnt_ctx.ses);
-	return mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
+	rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
+	if (rc)
+		goto error;
+
+	free_xid(mnt_ctx.xid);
+	return rc;
 
 error:
 	dfs_cache_put_refsrv_sessions(&mnt_ctx.mount_id);
@@ -3875,8 +3879,12 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 			goto error;
 	}
 
+	rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
+	if (rc)
+		goto error;
+
 	free_xid(mnt_ctx.xid);
-	return mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
+	return rc;
 
 error:
 	mount_put_conns(&mnt_ctx);
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index b6e6e5d6c8dd..baccda02deab 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -343,7 +343,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 					rc = put_user(ExtAttrBits &
 						FS_FL_USER_VISIBLE,
 						(int __user *)arg);
-				if (rc != EOPNOTSUPP)
+				if (rc != -EOPNOTSUPP)
 					break;
 			}
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
@@ -373,7 +373,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			 *		       pSMBFile->fid.netfid,
 			 *		       extAttrBits,
 			 *		       &ExtAttrMask);
-			 * if (rc != EOPNOTSUPP)
+			 * if (rc != -EOPNOTSUPP)
 			 *	break;
 			 */
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 87f60f736731..35085fa86636 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -400,6 +400,7 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 {
 	struct smb_hdr *buf = (struct smb_hdr *)buffer;
 	struct smb_com_lock_req *pSMB = (struct smb_com_lock_req *)buf;
+	struct TCP_Server_Info *pserver;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	struct cifsInodeInfo *pCifsInode;
@@ -464,9 +465,12 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 	if (!(pSMB->LockType & LOCKING_ANDX_OPLOCK_RELEASE))
 		return false;
 
+	/* If server is a channel, select the primary channel */
+	pserver = CIFS_SERVER_IS_CHAN(srv) ? srv->primary_server : srv;
+
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(ses, &srv->smb_ses_list, smb_ses_list) {
+	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->tid != buf->Tid)
 				continue;
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index d73e5672aac4..3bcd3ac65dc1 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -135,6 +135,7 @@ static __u32 get_neg_ctxt_len(struct smb2_hdr *hdr, __u32 len,
 int
 smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
 {
+	struct TCP_Server_Info *pserver;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	struct smb2_pdu *pdu = (struct smb2_pdu *)shdr;
 	int hdr_size = sizeof(struct smb2_hdr);
@@ -143,6 +144,9 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
 	__u32 calc_len; /* calculated length */
 	__u64 mid;
 
+	/* If server is a channel, select the primary channel */
+	pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
+
 	/*
 	 * Add function to do table lookup of StructureSize by command
 	 * ie Validate the wct via smb2_struct_sizes table above
@@ -155,7 +159,7 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
 
 		/* decrypt frame now that it is completely read in */
 		spin_lock(&cifs_tcp_ses_lock);
-		list_for_each_entry(iter, &server->smb_ses_list, smb_ses_list) {
+		list_for_each_entry(iter, &pserver->smb_ses_list, smb_ses_list) {
 			if (iter->Suid == le64_to_cpu(thdr->SessionId)) {
 				ses = iter;
 				break;
@@ -671,6 +675,7 @@ bool
 smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 {
 	struct smb2_oplock_break *rsp = (struct smb2_oplock_break *)buffer;
+	struct TCP_Server_Info *pserver;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	struct cifsInodeInfo *cinode;
@@ -691,9 +696,12 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 
 	cifs_dbg(FYI, "oplock level 0x%x\n", rsp->OplockLevel);
 
+	/* If server is a channel, select the primary channel */
+	pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
+
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 
 			spin_lock(&tcon->open_file_lock);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 14376437187a..b724bf42b540 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1123,6 +1123,8 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 				COMPOUND_FID, current->tgid,
 				FILE_FULL_EA_INFORMATION,
 				SMB2_O_INFO_FILE, 0, data, size);
+	if (rc)
+		goto sea_exit;
 	smb2_set_next_command(tcon, &rqst[1]);
 	smb2_set_related(&rqst[1]);
 
@@ -1133,6 +1135,8 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst[2].rq_nvec = 1;
 	rc = SMB2_close_init(tcon, server,
 			     &rqst[2], COMPOUND_FID, COMPOUND_FID, false);
+	if (rc)
+		goto sea_exit;
 	smb2_set_related(&rqst[2]);
 
 	rc = compound_send_recv(xid, ses, server,
@@ -2288,14 +2292,18 @@ static void
 smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
 {
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
+	struct TCP_Server_Info *pserver;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 
 	if (shdr->Status != STATUS_NETWORK_NAME_DELETED)
 		return;
 
+	/* If server is a channel, select the primary channel */
+	pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
+
 	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->tid == le32_to_cpu(shdr->Id.SyncId.TreeId)) {
 				spin_lock(&tcon->tc_lock);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 4640fc4a8b13..da85cfd7803b 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -140,9 +140,13 @@ int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 static struct cifs_ses *
 smb2_find_smb_ses_unlocked(struct TCP_Server_Info *server, __u64 ses_id)
 {
+	struct TCP_Server_Info *pserver;
 	struct cifs_ses *ses;
 
-	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+	/* If server is a channel, select the primary channel */
+	pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
+
+	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
 		if (ses->Suid != ses_id)
 			continue;
 		++ses->ses_count;
diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
index b5fd9d71e67f..46ab2b3f9a3c 100644
--- a/fs/erofs/fscache.c
+++ b/fs/erofs/fscache.c
@@ -69,11 +69,15 @@ static void erofs_fscache_rreq_unlock_folios(struct netfs_io_request *rreq)
 
 	rcu_read_lock();
 	xas_for_each(&xas, folio, last_page) {
-		unsigned int pgpos =
-			(folio_index(folio) - start_page) * PAGE_SIZE;
-		unsigned int pgend = pgpos + folio_size(folio);
+		unsigned int pgpos, pgend;
 		bool pg_failed = false;
 
+		if (xas_retry(&xas, folio))
+			continue;
+
+		pgpos = (folio_index(folio) - start_page) * PAGE_SIZE;
+		pgend = pgpos + folio_size(folio);
+
 		for (;;) {
 			if (!subreq) {
 				pg_failed = true;
@@ -234,113 +238,114 @@ static int erofs_fscache_meta_read_folio(struct file *data, struct folio *folio)
 	return ret;
 }
 
-static int erofs_fscache_read_folio_inline(struct folio *folio,
-					 struct erofs_map_blocks *map)
-{
-	struct super_block *sb = folio_mapping(folio)->host->i_sb;
-	struct erofs_buf buf = __EROFS_BUF_INITIALIZER;
-	erofs_blk_t blknr;
-	size_t offset, len;
-	void *src, *dst;
-
-	/* For tail packing layout, the offset may be non-zero. */
-	offset = erofs_blkoff(map->m_pa);
-	blknr = erofs_blknr(map->m_pa);
-	len = map->m_llen;
-
-	src = erofs_read_metabuf(&buf, sb, blknr, EROFS_KMAP);
-	if (IS_ERR(src))
-		return PTR_ERR(src);
-
-	dst = kmap_local_folio(folio, 0);
-	memcpy(dst, src + offset, len);
-	memset(dst + len, 0, PAGE_SIZE - len);
-	kunmap_local(dst);
-
-	erofs_put_metabuf(&buf);
-	return 0;
-}
-
-static int erofs_fscache_read_folio(struct file *file, struct folio *folio)
+/*
+ * Read into page cache in the range described by (@pos, @len).
+ *
+ * On return, the caller is responsible for page unlocking if the output @unlock
+ * is true, or the callee will take this responsibility through netfs_io_request
+ * interface.
+ *
+ * The return value is the number of bytes successfully handled, or negative
+ * error code on failure. The only exception is that, the length of the range
+ * instead of the error code is returned on failure after netfs_io_request is
+ * allocated, so that .readahead() could advance rac accordingly.
+ */
+static int erofs_fscache_data_read(struct address_space *mapping,
+				   loff_t pos, size_t len, bool *unlock)
 {
-	struct inode *inode = folio_mapping(folio)->host;
+	struct inode *inode = mapping->host;
 	struct super_block *sb = inode->i_sb;
+	struct netfs_io_request *rreq;
 	struct erofs_map_blocks map;
 	struct erofs_map_dev mdev;
-	struct netfs_io_request *rreq;
-	erofs_off_t pos;
-	loff_t pstart;
+	struct iov_iter iter;
+	size_t count;
 	int ret;
 
-	DBG_BUGON(folio_size(folio) != EROFS_BLKSIZ);
+	*unlock = true;
 
-	pos = folio_pos(folio);
 	map.m_la = pos;
-
 	ret = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_RAW);
 	if (ret)
-		goto out_unlock;
+		return ret;
 
-	if (!(map.m_flags & EROFS_MAP_MAPPED)) {
-		folio_zero_range(folio, 0, folio_size(folio));
-		goto out_uptodate;
+	if (map.m_flags & EROFS_MAP_META) {
+		struct erofs_buf buf = __EROFS_BUF_INITIALIZER;
+		erofs_blk_t blknr;
+		size_t offset, size;
+		void *src;
+
+		/* For tail packing layout, the offset may be non-zero. */
+		offset = erofs_blkoff(map.m_pa);
+		blknr = erofs_blknr(map.m_pa);
+		size = map.m_llen;
+
+		src = erofs_read_metabuf(&buf, sb, blknr, EROFS_KMAP);
+		if (IS_ERR(src))
+			return PTR_ERR(src);
+
+		iov_iter_xarray(&iter, READ, &mapping->i_pages, pos, PAGE_SIZE);
+		if (copy_to_iter(src + offset, size, &iter) != size) {
+			erofs_put_metabuf(&buf);
+			return -EFAULT;
+		}
+		iov_iter_zero(PAGE_SIZE - size, &iter);
+		erofs_put_metabuf(&buf);
+		return PAGE_SIZE;
 	}
 
-	if (map.m_flags & EROFS_MAP_META) {
-		ret = erofs_fscache_read_folio_inline(folio, &map);
-		goto out_uptodate;
+	if (!(map.m_flags & EROFS_MAP_MAPPED)) {
+		count = len;
+		iov_iter_xarray(&iter, READ, &mapping->i_pages, pos, count);
+		iov_iter_zero(count, &iter);
+		return count;
 	}
 
+	count = min_t(size_t, map.m_llen - (pos - map.m_la), len);
+	DBG_BUGON(!count || count % PAGE_SIZE);
+
 	mdev = (struct erofs_map_dev) {
 		.m_deviceid = map.m_deviceid,
 		.m_pa = map.m_pa,
 	};
-
 	ret = erofs_map_dev(sb, &mdev);
 	if (ret)
-		goto out_unlock;
-
-
-	rreq = erofs_fscache_alloc_request(folio_mapping(folio),
-				folio_pos(folio), folio_size(folio));
-	if (IS_ERR(rreq)) {
-		ret = PTR_ERR(rreq);
-		goto out_unlock;
-	}
+		return ret;
 
-	pstart = mdev.m_pa + (pos - map.m_la);
-	return erofs_fscache_read_folios_async(mdev.m_fscache->cookie,
-				rreq, pstart);
+	rreq = erofs_fscache_alloc_request(mapping, pos, count);
+	if (IS_ERR(rreq))
+		return PTR_ERR(rreq);
 
-out_uptodate:
-	if (!ret)
-		folio_mark_uptodate(folio);
-out_unlock:
-	folio_unlock(folio);
-	return ret;
+	*unlock = false;
+	erofs_fscache_read_folios_async(mdev.m_fscache->cookie,
+			rreq, mdev.m_pa + (pos - map.m_la));
+	return count;
 }
 
-static void erofs_fscache_advance_folios(struct readahead_control *rac,
-					 size_t len, bool unlock)
+static int erofs_fscache_read_folio(struct file *file, struct folio *folio)
 {
-	while (len) {
-		struct folio *folio = readahead_folio(rac);
-		len -= folio_size(folio);
-		if (unlock) {
+	bool unlock;
+	int ret;
+
+	DBG_BUGON(folio_size(folio) != EROFS_BLKSIZ);
+
+	ret = erofs_fscache_data_read(folio_mapping(folio), folio_pos(folio),
+				      folio_size(folio), &unlock);
+	if (unlock) {
+		if (ret > 0)
 			folio_mark_uptodate(folio);
-			folio_unlock(folio);
-		}
+		folio_unlock(folio);
 	}
+	return ret < 0 ? ret : 0;
 }
 
 static void erofs_fscache_readahead(struct readahead_control *rac)
 {
-	struct inode *inode = rac->mapping->host;
-	struct super_block *sb = inode->i_sb;
-	size_t len, count, done = 0;
-	erofs_off_t pos;
-	loff_t start, offset;
-	int ret;
+	struct folio *folio;
+	size_t len, done = 0;
+	loff_t start, pos;
+	bool unlock;
+	int ret, size;
 
 	if (!readahead_count(rac))
 		return;
@@ -349,67 +354,22 @@ static void erofs_fscache_readahead(struct readahead_control *rac)
 	len = readahead_length(rac);
 
 	do {
-		struct erofs_map_blocks map;
-		struct erofs_map_dev mdev;
-		struct netfs_io_request *rreq;
-
 		pos = start + done;
-		map.m_la = pos;
-
-		ret = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_RAW);
-		if (ret)
+		ret = erofs_fscache_data_read(rac->mapping, pos,
+					      len - done, &unlock);
+		if (ret <= 0)
 			return;
 
-		offset = start + done;
-		count = min_t(size_t, map.m_llen - (pos - map.m_la),
-			      len - done);
-
-		if (!(map.m_flags & EROFS_MAP_MAPPED)) {
-			struct iov_iter iter;
-
-			iov_iter_xarray(&iter, READ, &rac->mapping->i_pages,
-					offset, count);
-			iov_iter_zero(count, &iter);
-
-			erofs_fscache_advance_folios(rac, count, true);
-			ret = count;
-			continue;
-		}
-
-		if (map.m_flags & EROFS_MAP_META) {
-			struct folio *folio = readahead_folio(rac);
-
-			ret = erofs_fscache_read_folio_inline(folio, &map);
-			if (!ret) {
+		size = ret;
+		while (size) {
+			folio = readahead_folio(rac);
+			size -= folio_size(folio);
+			if (unlock) {
 				folio_mark_uptodate(folio);
-				ret = folio_size(folio);
+				folio_unlock(folio);
 			}
-
-			folio_unlock(folio);
-			continue;
 		}
-
-		mdev = (struct erofs_map_dev) {
-			.m_deviceid = map.m_deviceid,
-			.m_pa = map.m_pa,
-		};
-		ret = erofs_map_dev(sb, &mdev);
-		if (ret)
-			return;
-
-		rreq = erofs_fscache_alloc_request(rac->mapping, offset, count);
-		if (IS_ERR(rreq))
-			return;
-		/*
-		 * Drop the ref of folios here. Unlock them in
-		 * rreq_unlock_folios() when rreq complete.
-		 */
-		erofs_fscache_advance_folios(rac, count, false);
-		ret = erofs_fscache_read_folios_async(mdev.m_fscache->cookie,
-					rreq, mdev.m_pa + (pos - map.m_la));
-		if (!ret)
-			ret = count;
-	} while (ret > 0 && ((done += ret) < len));
+	} while ((done += ret) < len);
 }
 
 static const struct address_space_operations erofs_fscache_meta_aops = {
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 549879929c84..c7e2e6238366 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -178,7 +178,10 @@ static int gfs2_check_sb(struct gfs2_sbd *sdp, int silent)
 		pr_warn("Invalid block size\n");
 		return -EINVAL;
 	}
-
+	if (sb->sb_bsize_shift != ffs(sb->sb_bsize) - 1) {
+		pr_warn("Invalid block size shift\n");
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -381,8 +384,10 @@ static int init_names(struct gfs2_sbd *sdp, int silent)
 	if (!table[0])
 		table = sdp->sd_vfs->s_id;
 
-	strlcpy(sdp->sd_proto_name, proto, GFS2_FSNAME_LEN);
-	strlcpy(sdp->sd_table_name, table, GFS2_FSNAME_LEN);
+	BUILD_BUG_ON(GFS2_LOCKNAME_LEN > GFS2_FSNAME_LEN);
+
+	strscpy(sdp->sd_proto_name, proto, GFS2_LOCKNAME_LEN);
+	strscpy(sdp->sd_table_name, table, GFS2_LOCKNAME_LEN);
 
 	table = sdp->sd_table_name;
 	while ((table = strchr(table, '/')))
@@ -1439,13 +1444,13 @@ static int gfs2_parse_param(struct fs_context *fc, struct fs_parameter *param)
 
 	switch (o) {
 	case Opt_lockproto:
-		strlcpy(args->ar_lockproto, param->string, GFS2_LOCKNAME_LEN);
+		strscpy(args->ar_lockproto, param->string, GFS2_LOCKNAME_LEN);
 		break;
 	case Opt_locktable:
-		strlcpy(args->ar_locktable, param->string, GFS2_LOCKNAME_LEN);
+		strscpy(args->ar_locktable, param->string, GFS2_LOCKNAME_LEN);
 		break;
 	case Opt_hostdata:
-		strlcpy(args->ar_hostdata, param->string, GFS2_LOCKNAME_LEN);
+		strscpy(args->ar_hostdata, param->string, GFS2_LOCKNAME_LEN);
 		break;
 	case Opt_spectator:
 		args->ar_spectator = 1;
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index f7a5b5124d8a..fbcfa6bfee80 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -328,6 +328,12 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		} else {
 			unlock_page(page);
 
+			if (PageHWPoison(page)) {
+				put_page(page);
+				retval = -EIO;
+				break;
+			}
+
 			/*
 			 * We have the page, copy it to user space buffer.
 			 */
@@ -364,7 +370,7 @@ static int hugetlbfs_write_end(struct file *file, struct address_space *mapping,
 	return -EINVAL;
 }
 
-static void remove_huge_page(struct page *page)
+static void hugetlb_delete_from_page_cache(struct page *page)
 {
 	ClearPageDirty(page);
 	ClearPageUptodate(page);
@@ -487,15 +493,14 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 			folio_lock(folio);
 			/*
 			 * We must free the huge page and remove from page
-			 * cache (remove_huge_page) BEFORE removing the
-			 * region/reserve map (hugetlb_unreserve_pages).  In
-			 * rare out of memory conditions, removal of the
-			 * region/reserve map could fail. Correspondingly,
-			 * the subpool and global reserve usage count can need
-			 * to be adjusted.
+			 * cache BEFORE removing the region/reserve map
+			 * (hugetlb_unreserve_pages).  In rare out of memory
+			 * conditions, removal of the region/reserve map could
+			 * fail. Correspondingly, the subpool and global
+			 * reserve usage count can need to be adjusted.
 			 */
 			VM_BUG_ON(HPageRestoreReserve(&folio->page));
-			remove_huge_page(&folio->page);
+			hugetlb_delete_from_page_cache(&folio->page);
 			freed++;
 			if (!truncate_op) {
 				if (unlikely(hugetlb_unreserve_pages(inode,
@@ -737,7 +742,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 		}
 		clear_huge_page(page, addr, pages_per_huge_page(h));
 		__SetPageUptodate(page);
-		error = huge_add_to_page_cache(page, mapping, index);
+		error = hugetlb_add_to_page_cache(page, mapping, index);
 		if (unlikely(error)) {
 			restore_reserve_on_error(h, &pseudo_vma, addr, page);
 			put_page(page);
@@ -749,7 +754,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 
 		SetHPageMigratable(page);
 		/*
-		 * unlock_page because locked by huge_add_to_page_cache()
+		 * unlock_page because locked by hugetlb_add_to_page_cache()
 		 * put_page() due to reference from alloc_huge_page()
 		 */
 		unlock_page(page);
@@ -991,13 +996,6 @@ static int hugetlbfs_migrate_folio(struct address_space *mapping,
 static int hugetlbfs_error_remove_page(struct address_space *mapping,
 				struct page *page)
 {
-	struct inode *inode = mapping->host;
-	pgoff_t index = page->index;
-
-	remove_huge_page(page);
-	if (unlikely(hugetlb_unreserve_pages(inode, index, index + 1, 1)))
-		hugetlb_fix_reserve_counts(inode);
-
 	return 0;
 }
 
diff --git a/fs/namei.c b/fs/namei.c
index 53b4bc094db2..076ae96ca0b1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5088,7 +5088,7 @@ int page_symlink(struct inode *inode, const char *symname, int len)
 	const struct address_space_operations *aops = mapping->a_ops;
 	bool nofs = !mapping_gfp_constraint(mapping, __GFP_FS);
 	struct page *page;
-	void *fsdata;
+	void *fsdata = NULL;
 	int err;
 	unsigned int flags;
 
diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 0ce535852151..7679a68e8193 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -17,9 +17,9 @@ void netfs_rreq_unlock_folios(struct netfs_io_request *rreq)
 {
 	struct netfs_io_subrequest *subreq;
 	struct folio *folio;
-	unsigned int iopos, account = 0;
 	pgoff_t start_page = rreq->start / PAGE_SIZE;
 	pgoff_t last_page = ((rreq->start + rreq->len) / PAGE_SIZE) - 1;
+	size_t account = 0;
 	bool subreq_failed = false;
 
 	XA_STATE(xas, &rreq->mapping->i_pages, start_page);
@@ -39,18 +39,23 @@ void netfs_rreq_unlock_folios(struct netfs_io_request *rreq)
 	 */
 	subreq = list_first_entry(&rreq->subrequests,
 				  struct netfs_io_subrequest, rreq_link);
-	iopos = 0;
 	subreq_failed = (subreq->error < 0);
 
 	trace_netfs_rreq(rreq, netfs_rreq_trace_unlock);
 
 	rcu_read_lock();
 	xas_for_each(&xas, folio, last_page) {
-		unsigned int pgpos = (folio_index(folio) - start_page) * PAGE_SIZE;
-		unsigned int pgend = pgpos + folio_size(folio);
+		loff_t pg_end;
 		bool pg_failed = false;
 
+		if (xas_retry(&xas, folio))
+			continue;
+
+		pg_end = folio_pos(folio) + folio_size(folio) - 1;
+
 		for (;;) {
+			loff_t sreq_end;
+
 			if (!subreq) {
 				pg_failed = true;
 				break;
@@ -58,11 +63,11 @@ void netfs_rreq_unlock_folios(struct netfs_io_request *rreq)
 			if (test_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags))
 				folio_start_fscache(folio);
 			pg_failed |= subreq_failed;
-			if (pgend < iopos + subreq->len)
+			sreq_end = subreq->start + subreq->len - 1;
+			if (pg_end < sreq_end)
 				break;
 
 			account += subreq->transferred;
-			iopos += subreq->len;
 			if (!list_is_last(&subreq->rreq_link, &rreq->subrequests)) {
 				subreq = list_next_entry(subreq, rreq_link);
 				subreq_failed = (subreq->error < 0);
@@ -70,7 +75,8 @@ void netfs_rreq_unlock_folios(struct netfs_io_request *rreq)
 				subreq = NULL;
 				subreq_failed = false;
 			}
-			if (pgend == iopos)
+
+			if (pg_end == sreq_end)
 				break;
 		}
 
diff --git a/fs/netfs/io.c b/fs/netfs/io.c
index 428925899282..e374767d1b68 100644
--- a/fs/netfs/io.c
+++ b/fs/netfs/io.c
@@ -121,6 +121,9 @@ static void netfs_rreq_unmark_after_write(struct netfs_io_request *rreq,
 		XA_STATE(xas, &rreq->mapping->i_pages, subreq->start / PAGE_SIZE);
 
 		xas_for_each(&xas, folio, (subreq->start + subreq->len - 1) / PAGE_SIZE) {
+			if (xas_retry(&xas, folio))
+				continue;
+
 			/* We might have multiple writes from the same huge
 			 * folio, but we mustn't unlock a folio more than once.
 			 */
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 3ed14a2a84a4..313e9145b6c9 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7137,6 +7137,7 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 {
 	struct nfs4_lockdata *data = calldata;
 	struct nfs4_lock_state *lsp = data->lsp;
+	struct nfs_server *server = NFS_SERVER(d_inode(data->ctx->dentry));
 
 	if (!nfs4_sequence_done(task, &data->res.seq_res))
 		return;
@@ -7144,8 +7145,7 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 	data->rpc_status = task->tk_status;
 	switch (task->tk_status) {
 	case 0:
-		renew_lease(NFS_SERVER(d_inode(data->ctx->dentry)),
-				data->timestamp);
+		renew_lease(server, data->timestamp);
 		if (data->arg.new_lock && !data->cancelled) {
 			data->fl.fl_flags &= ~(FL_SLEEP | FL_ACCESS);
 			if (locks_lock_inode_wait(lsp->ls_state->inode, &data->fl) < 0)
@@ -7166,6 +7166,8 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 			if (!nfs4_stateid_match(&data->arg.open_stateid,
 						&lsp->ls_state->open_stateid))
 				goto out_restart;
+			else if (nfs4_async_handle_error(task, server, lsp->ls_state, NULL) == -EAGAIN)
+				goto out_restart;
 		} else if (!nfs4_stateid_match(&data->arg.lock_stateid,
 						&lsp->ls_stateid))
 				goto out_restart;
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 0bc36472f8b7..ddb2bf078fda 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5313,6 +5313,7 @@ nfsd4_verify_deleg_dentry(struct nfsd4_open *open, struct nfs4_file *fp,
 	if (err)
 		return -EAGAIN;
 
+	exp_put(exp);
 	dput(child);
 	if (child != file_dentry(fp->fi_deleg_file->nf_file))
 		return -EAGAIN;
diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 52615e6090e1..a3865bc4a0c6 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -594,17 +594,37 @@ static int ntfs_attr_find(const ATTR_TYPE type, const ntfschar *name,
 	for (;;	a = (ATTR_RECORD*)((u8*)a + le32_to_cpu(a->length))) {
 		u8 *mrec_end = (u8 *)ctx->mrec +
 		               le32_to_cpu(ctx->mrec->bytes_allocated);
-		u8 *name_end = (u8 *)a + le16_to_cpu(a->name_offset) +
-			       a->name_length * sizeof(ntfschar);
-		if ((u8*)a < (u8*)ctx->mrec || (u8*)a > mrec_end ||
-		    name_end > mrec_end)
+		u8 *name_end;
+
+		/* check whether ATTR_RECORD wrap */
+		if ((u8 *)a < (u8 *)ctx->mrec)
+			break;
+
+		/* check whether Attribute Record Header is within bounds */
+		if ((u8 *)a > mrec_end ||
+		    (u8 *)a + sizeof(ATTR_RECORD) > mrec_end)
+			break;
+
+		/* check whether ATTR_RECORD's name is within bounds */
+		name_end = (u8 *)a + le16_to_cpu(a->name_offset) +
+			   a->name_length * sizeof(ntfschar);
+		if (name_end > mrec_end)
 			break;
+
 		ctx->attr = a;
 		if (unlikely(le32_to_cpu(a->type) > le32_to_cpu(type) ||
 				a->type == AT_END))
 			return -ENOENT;
 		if (unlikely(!a->length))
 			break;
+
+		/* check whether ATTR_RECORD's length wrap */
+		if ((u8 *)a + le32_to_cpu(a->length) < (u8 *)a)
+			break;
+		/* check whether ATTR_RECORD's length is within bounds */
+		if ((u8 *)a + le32_to_cpu(a->length) > mrec_end)
+			break;
+
 		if (a->type != type)
 			continue;
 		/*
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index db0f1995aedd..08c659332e26 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -1829,6 +1829,13 @@ int ntfs_read_inode_mount(struct inode *vi)
 		goto err_out;
 	}
 
+	/* Sanity check offset to the first attribute */
+	if (le16_to_cpu(m->attrs_offset) >= le32_to_cpu(m->bytes_allocated)) {
+		ntfs_error(sb, "Incorrect mft offset to the first attribute %u in superblock.",
+			       le16_to_cpu(m->attrs_offset));
+		goto err_out;
+	}
+
 	/* Need this to sanity check attribute list references to $MFT. */
 	vi->i_generation = ni->seq_no = le16_to_cpu(m->sequence_number);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 84b13fdd34a7..79624711fda7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -311,6 +311,13 @@ struct queue_limits {
 	unsigned char		discard_misaligned;
 	unsigned char		raid_partial_stripes_expensive;
 	enum blk_zoned_model	zoned;
+
+	/*
+	 * Drivers that set dma_alignment to less than 511 must be prepared to
+	 * handle individual bvec's that are not a multiple of a SECTOR_SIZE
+	 * due to possible offsets.
+	 */
+	unsigned int		dma_alignment;
 };
 
 typedef int (*report_zones_cb)(struct blk_zone *zone, unsigned int idx,
@@ -456,12 +463,6 @@ struct request_queue {
 	unsigned long		nr_requests;	/* Max # of requests */
 
 	unsigned int		dma_pad_mask;
-	/*
-	 * Drivers that set dma_alignment to less than 511 must be prepared to
-	 * handle individual bvec's that are not a multiple of a SECTOR_SIZE
-	 * due to possible offsets.
-	 */
-	unsigned int		dma_alignment;
 
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION
 	struct blk_crypto_profile *crypto_profile;
@@ -1311,7 +1312,7 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
 
 static inline int queue_dma_alignment(const struct request_queue *q)
 {
-	return q ? q->dma_alignment : 511;
+	return q ? q->limits.dma_alignment : 511;
 }
 
 static inline unsigned int bdev_dma_alignment(struct block_device *bdev)
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 80fc8a88c610..73662fbabd78 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1967,6 +1967,7 @@ static inline bool unprivileged_ebpf_enabled(void)
 	return !sysctl_unprivileged_bpf_disabled;
 }
 
+void notrace bpf_prog_inc_misses_counter(struct bpf_prog *prog);
 #else /* !CONFIG_BPF_SYSCALL */
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
 {
@@ -2176,6 +2177,9 @@ static inline bool unprivileged_ebpf_enabled(void)
 	return false;
 }
 
+static inline void bpf_prog_inc_misses_counter(struct bpf_prog *prog)
+{
+}
 #endif /* CONFIG_BPF_SYSCALL */
 
 void __bpf_free_used_btfs(struct bpf_prog_aux *aux,
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 67c88b82fc32..53db3648207a 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -665,7 +665,7 @@ struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask);
 struct page *alloc_huge_page_vma(struct hstate *h, struct vm_area_struct *vma,
 				unsigned long address);
-int huge_add_to_page_cache(struct page *page, struct address_space *mapping,
+int hugetlb_add_to_page_cache(struct page *page, struct address_space *mapping,
 			pgoff_t idx);
 void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
 				unsigned long address, struct page *page);
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 4a2f6cc5a492..ad88c4fa1113 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -15,6 +15,9 @@ enum io_uring_cmd_flags {
 	IO_URING_F_SQE128		= 4,
 	IO_URING_F_CQE32		= 8,
 	IO_URING_F_IOPOLL		= 16,
+
+	/* the request is executed from poll, it should not be freed */
+	IO_URING_F_MULTISHOT		= 32,
 };
 
 struct io_uring_cmd {
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 2504df9a0453..3c7d295746f6 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -100,7 +100,7 @@ __ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *k
 
 int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full);
 __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
-			  struct file *filp, poll_table *poll_table);
+			  struct file *filp, poll_table *poll_table, int full);
 void ring_buffer_wake_waiters(struct trace_buffer *buffer, int cpu);
 
 #define RING_BUFFER_ALL_CPUS -1
diff --git a/include/linux/trace.h b/include/linux/trace.h
index b5e16e438448..80ffda871749 100644
--- a/include/linux/trace.h
+++ b/include/linux/trace.h
@@ -26,13 +26,13 @@ struct trace_export {
 	int flags;
 };
 
+struct trace_array;
+
 #ifdef CONFIG_TRACING
 
 int register_ftrace_export(struct trace_export *export);
 int unregister_ftrace_export(struct trace_export *export);
 
-struct trace_array;
-
 void trace_printk_init_buffers(void);
 __printf(3, 4)
 int trace_array_printk(struct trace_array *tr, unsigned long ip,
diff --git a/include/linux/wireless.h b/include/linux/wireless.h
index 2d1b54556eff..e6e34d74dda0 100644
--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -26,7 +26,15 @@ struct compat_iw_point {
 struct __compat_iw_event {
 	__u16		len;			/* Real length of this stuff */
 	__u16		cmd;			/* Wireless IOCTL */
-	compat_caddr_t	pointer;
+
+	union {
+		compat_caddr_t	pointer;
+
+		/* we need ptr_bytes to make memcpy() run-time destination
+		 * buffer bounds checking happy, nothing special
+		 */
+		DECLARE_FLEX_ARRAY(__u8, ptr_bytes);
+	};
 };
 #define IW_EV_COMPAT_LCP_LEN offsetof(struct __compat_iw_event, pointer)
 #define IW_EV_COMPAT_POINT_OFF offsetof(struct compat_iw_point, length)
diff --git a/include/net/ip.h b/include/net/ip.h
index 1c979fd1904c..1eca38ac6c67 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -563,7 +563,7 @@ static inline void iph_to_flow_copy_v4addrs(struct flow_keys *flow,
 	BUILD_BUG_ON(offsetof(typeof(flow->addrs), v4addrs.dst) !=
 		     offsetof(typeof(flow->addrs), v4addrs.src) +
 			      sizeof(flow->addrs.v4addrs.src));
-	memcpy(&flow->addrs.v4addrs, &iph->saddr, sizeof(flow->addrs.v4addrs));
+	memcpy(&flow->addrs.v4addrs, &iph->addrs, sizeof(flow->addrs.v4addrs));
 	flow->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
 }
 
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index de9dcc5652c4..59125562c1a4 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -897,7 +897,7 @@ static inline void iph_to_flow_copy_v6addrs(struct flow_keys *flow,
 	BUILD_BUG_ON(offsetof(typeof(flow->addrs), v6addrs.dst) !=
 		     offsetof(typeof(flow->addrs), v6addrs.src) +
 		     sizeof(flow->addrs.v6addrs.src));
-	memcpy(&flow->addrs.v6addrs, &iph->saddr, sizeof(flow->addrs.v6addrs));
+	memcpy(&flow->addrs.v6addrs, &iph->addrs, sizeof(flow->addrs.v6addrs));
 	flow->control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
 }
 
diff --git a/include/soc/at91/sama7-ddr.h b/include/soc/at91/sama7-ddr.h
index 6ce3bd22f6c6..5ad7ac2e3a7c 100644
--- a/include/soc/at91/sama7-ddr.h
+++ b/include/soc/at91/sama7-ddr.h
@@ -26,7 +26,10 @@
 #define	DDR3PHY_PGSR				(0x0C)		/* DDR3PHY PHY General Status Register */
 #define		DDR3PHY_PGSR_IDONE		(1 << 0)	/* Initialization Done */
 
-#define DDR3PHY_ACIOCR				(0x24)		/*  DDR3PHY AC I/O Configuration Register */
+#define	DDR3PHY_ACDLLCR				(0x14)		/* DDR3PHY AC DLL Control Register */
+#define		DDR3PHY_ACDLLCR_DLLSRST		(1 << 30)	/* DLL Soft Reset */
+
+#define DDR3PHY_ACIOCR				(0x24)		/* DDR3PHY AC I/O Configuration Register */
 #define		DDR3PHY_ACIOCR_CSPDD_CS0	(1 << 18)	/* CS#[0] Power Down Driver */
 #define		DDR3PHY_ACIOCR_CKPDD_CK0	(1 << 8)	/* CK[0] Power Down Driver */
 #define		DDR3PHY_ACIORC_ACPDD		(1 << 3)	/* AC Power Down Driver */
diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
index 961ec16a26b8..874a92349bf5 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -100,8 +100,10 @@ struct iphdr {
 	__u8	ttl;
 	__u8	protocol;
 	__sum16	check;
-	__be32	saddr;
-	__be32	daddr;
+	__struct_group(/* no tag */, addrs, /* no attrs */,
+		__be32	saddr;
+		__be32	daddr;
+	);
 	/*The options start here. */
 };
 
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 03cdbe798fe3..81f4243bebb1 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -130,8 +130,10 @@ struct ipv6hdr {
 	__u8			nexthdr;
 	__u8			hop_limit;
 
-	struct	in6_addr	saddr;
-	struct	in6_addr	daddr;
+	__struct_group(/* no tag */, addrs, /* no attrs */,
+		struct	in6_addr	saddr;
+		struct	in6_addr	daddr;
+	);
 };
 
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d29f397f095e..adf73d162521 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -171,6 +171,11 @@ static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
 	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
 }
 
+static inline unsigned int __io_cqring_events_user(struct io_ring_ctx *ctx)
+{
+	return READ_ONCE(ctx->rings->cq.tail) - READ_ONCE(ctx->rings->cq.head);
+}
+
 static bool io_match_linked(struct io_kiocb *head)
 {
 	struct io_kiocb *req;
@@ -1613,7 +1618,7 @@ int io_poll_issue(struct io_kiocb *req, bool *locked)
 	io_tw_lock(req->ctx, locked);
 	if (unlikely(req->task->flags & PF_EXITING))
 		return -EFAULT;
-	return io_issue_sqe(req, IO_URING_F_NONBLOCK);
+	return io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_MULTISHOT);
 }
 
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
@@ -2163,7 +2168,7 @@ struct io_wait_queue {
 static inline bool io_should_wake(struct io_wait_queue *iowq)
 {
 	struct io_ring_ctx *ctx = iowq->ctx;
-	int dist = ctx->cached_cq_tail - (int) iowq->cq_tail;
+	int dist = READ_ONCE(ctx->rings->cq.tail) - (int) iowq->cq_tail;
 
 	/*
 	 * Wake up if we have enough events, or if a timeout occurred since we
@@ -2240,7 +2245,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	do {
 		io_cqring_overflow_flush(ctx);
 
-		if (io_cqring_events(ctx) >= min_events)
+		/* if user messes with these they will just get an early return */
+		if (__io_cqring_events_user(ctx) >= min_events)
 			return 0;
 		if (!io_run_task_work())
 			break;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 5121b20a9193..1b552d213763 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -17,8 +17,8 @@ enum {
 	IOU_ISSUE_SKIP_COMPLETE	= -EIOCBQUEUED,
 
 	/*
-	 * Intended only when both REQ_F_POLLED and REQ_F_APOLL_MULTISHOT
-	 * are set to indicate to the poll runner that multishot should be
+	 * Intended only when both IO_URING_F_MULTISHOT is passed
+	 * to indicate to the poll runner that multishot should be
 	 * removed and the result is set on req->cqe.res.
 	 */
 	IOU_STOP_MULTISHOT	= -ECANCELED,
diff --git a/io_uring/net.c b/io_uring/net.c
index 7804ac77745b..8205cfecd647 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -66,8 +66,6 @@ struct io_sr_msg {
 	struct io_kiocb 		*notif;
 };
 
-#define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
-
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_shutdown *shutdown = io_kiocb_to_cmd(req, struct io_shutdown);
@@ -558,7 +556,8 @@ static inline void io_recv_prep_retry(struct io_kiocb *req)
  * again (for multishot).
  */
 static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
-				  unsigned int cflags, bool mshot_finished)
+				  unsigned int cflags, bool mshot_finished,
+				  unsigned issue_flags)
 {
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
 		io_req_set_res(req, *ret, cflags);
@@ -581,7 +580,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 
 	io_req_set_res(req, *ret, cflags);
 
-	if (req->flags & REQ_F_POLLED)
+	if (issue_flags & IO_URING_F_MULTISHOT)
 		*ret = IOU_STOP_MULTISHOT;
 	else
 		*ret = IOU_OK;
@@ -740,8 +739,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock) {
 			ret = io_setup_async_msg(req, kmsg, issue_flags);
-			if (ret == -EAGAIN && (req->flags & IO_APOLL_MULTI_POLLED) ==
-					       IO_APOLL_MULTI_POLLED) {
+			if (ret == -EAGAIN && (issue_flags & IO_URING_F_MULTISHOT)) {
 				io_kbuf_recycle(req, issue_flags);
 				return IOU_ISSUE_SKIP_COMPLETE;
 			}
@@ -770,7 +768,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (kmsg->msg.msg_inq)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
-	if (!io_recv_finish(req, &ret, cflags, mshot_finished))
+	if (!io_recv_finish(req, &ret, cflags, mshot_finished, issue_flags))
 		goto retry_multishot;
 
 	if (mshot_finished) {
@@ -836,7 +834,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	ret = sock_recvmsg(sock, &msg, flags);
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock) {
-			if ((req->flags & IO_APOLL_MULTI_POLLED) == IO_APOLL_MULTI_POLLED) {
+			if (issue_flags & IO_URING_F_MULTISHOT) {
 				io_kbuf_recycle(req, issue_flags);
 				return IOU_ISSUE_SKIP_COMPLETE;
 			}
@@ -869,7 +867,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (msg.msg_inq)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
-	if (!io_recv_finish(req, &ret, cflags, ret <= 0))
+	if (!io_recv_finish(req, &ret, cflags, ret <= 0, issue_flags))
 		goto retry_multishot;
 
 	return ret;
@@ -1168,8 +1166,7 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 			 * return EAGAIN to arm the poll infra since it
 			 * has already been done
 			 */
-			if ((req->flags & IO_APOLL_MULTI_POLLED) ==
-			    IO_APOLL_MULTI_POLLED)
+			if (issue_flags & IO_URING_F_MULTISHOT)
 				ret = IOU_ISSUE_SKIP_COMPLETE;
 			return ret;
 		}
@@ -1194,9 +1191,7 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		goto retry;
 
 	io_req_set_res(req, ret, 0);
-	if (req->flags & REQ_F_POLLED)
-		return IOU_STOP_MULTISHOT;
-	return IOU_OK;
+	return (issue_flags & IO_URING_F_MULTISHOT) ? IOU_STOP_MULTISHOT : IOU_OK;
 }
 
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0d9f49c575e0..ba0f68466930 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -226,6 +226,13 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 			return IOU_POLL_DONE;
 		if (v & IO_POLL_CANCEL_FLAG)
 			return -ECANCELED;
+		/*
+		 * cqe.res contains only events of the first wake up
+		 * and all others are be lost. Redo vfs_poll() to get
+		 * up to date state.
+		 */
+		if ((v & IO_POLL_REF_MASK) != 1)
+			req->cqe.res = 0;
 
 		/* the mask was stashed in __io_poll_execute */
 		if (!req->cqe.res) {
@@ -237,6 +244,8 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 			continue;
 		if (req->apoll_events & EPOLLONESHOT)
 			return IOU_POLL_DONE;
+		if (io_is_uring_fops(req->file))
+			return IOU_POLL_DONE;
 
 		/* multishot, just fill a CQE and proceed */
 		if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
@@ -256,6 +265,9 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 				return ret;
 		}
 
+		/* force the next iteration to vfs_poll() */
+		req->cqe.res = 0;
+
 		/*
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
@@ -394,7 +406,8 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	return 1;
 }
 
-static void io_poll_double_prepare(struct io_kiocb *req)
+/* fails only when polling is already completing by the first entry */
+static bool io_poll_double_prepare(struct io_kiocb *req)
 {
 	struct wait_queue_head *head;
 	struct io_poll *poll = io_poll_get_single(req);
@@ -403,20 +416,20 @@ static void io_poll_double_prepare(struct io_kiocb *req)
 	rcu_read_lock();
 	head = smp_load_acquire(&poll->head);
 	/*
-	 * poll arm may not hold ownership and so race with
-	 * io_poll_wake() by modifying req->flags. There is only one
-	 * poll entry queued, serialise with it by taking its head lock.
+	 * poll arm might not hold ownership and so race for req->flags with
+	 * io_poll_wake(). There is only one poll entry queued, serialise with
+	 * it by taking its head lock. As we're still arming the tw hanlder
+	 * is not going to be run, so there are no races with it.
 	 */
-	if (head)
+	if (head) {
 		spin_lock_irq(&head->lock);
-
-	req->flags |= REQ_F_DOUBLE_POLL;
-	if (req->opcode == IORING_OP_POLL_ADD)
-		req->flags |= REQ_F_ASYNC_DATA;
-
-	if (head)
+		req->flags |= REQ_F_DOUBLE_POLL;
+		if (req->opcode == IORING_OP_POLL_ADD)
+			req->flags |= REQ_F_ASYNC_DATA;
 		spin_unlock_irq(&head->lock);
+	}
 	rcu_read_unlock();
+	return !!head;
 }
 
 static void __io_queue_proc(struct io_poll *poll, struct io_poll_table *pt,
@@ -454,7 +467,11 @@ static void __io_queue_proc(struct io_poll *poll, struct io_poll_table *pt,
 		/* mark as double wq entry */
 		wqe_private |= IO_WQE_F_DOUBLE;
 		io_init_poll_iocb(poll, first->events, first->wait.func);
-		io_poll_double_prepare(req);
+		if (!io_poll_double_prepare(req)) {
+			/* the request is completing, just back off */
+			kfree(poll);
+			return;
+		}
 		*poll_ptr = poll;
 	} else {
 		/* fine to modify, there is no poll queued to race with us */
diff --git a/kernel/bpf/percpu_freelist.c b/kernel/bpf/percpu_freelist.c
index 00b874c8e889..2ffb741eee8d 100644
--- a/kernel/bpf/percpu_freelist.c
+++ b/kernel/bpf/percpu_freelist.c
@@ -102,22 +102,21 @@ void pcpu_freelist_populate(struct pcpu_freelist *s, void *buf, u32 elem_size,
 			    u32 nr_elems)
 {
 	struct pcpu_freelist_head *head;
-	int i, cpu, pcpu_entries;
+	unsigned int cpu, cpu_idx, i, j, n, m;
 
-	pcpu_entries = nr_elems / num_possible_cpus() + 1;
-	i = 0;
+	n = nr_elems / num_possible_cpus();
+	m = nr_elems % num_possible_cpus();
 
+	cpu_idx = 0;
 	for_each_possible_cpu(cpu) {
-again:
 		head = per_cpu_ptr(s->freelist, cpu);
-		/* No locking required as this is not visible yet. */
-		pcpu_freelist_push_node(head, buf);
-		i++;
-		buf += elem_size;
-		if (i == nr_elems)
-			break;
-		if (i % pcpu_entries)
-			goto again;
+		j = n + (cpu_idx < m ? 1 : 0);
+		for (i = 0; i < j; i++) {
+			/* No locking required as this is not visible yet. */
+			pcpu_freelist_push_node(head, buf);
+			buf += elem_size;
+		}
+		cpu_idx++;
 	}
 }
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 22e7a805c672..0e758911d963 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2094,6 +2094,17 @@ struct bpf_prog_kstats {
 	u64 misses;
 };
 
+void notrace bpf_prog_inc_misses_counter(struct bpf_prog *prog)
+{
+	struct bpf_prog_stats *stats;
+	unsigned int flags;
+
+	stats = this_cpu_ptr(prog->stats);
+	flags = u64_stats_update_begin_irqsave(&stats->syncp);
+	u64_stats_inc(&stats->misses);
+	u64_stats_update_end_irqrestore(&stats->syncp, flags);
+}
+
 static void bpf_prog_get_stats(const struct bpf_prog *prog,
 			       struct bpf_prog_kstats *stats)
 {
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index ad76940b02cc..41b67eb83ab3 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -863,17 +863,6 @@ static __always_inline u64 notrace bpf_prog_start_time(void)
 	return start;
 }
 
-static void notrace inc_misses_counter(struct bpf_prog *prog)
-{
-	struct bpf_prog_stats *stats;
-	unsigned int flags;
-
-	stats = this_cpu_ptr(prog->stats);
-	flags = u64_stats_update_begin_irqsave(&stats->syncp);
-	u64_stats_inc(&stats->misses);
-	u64_stats_update_end_irqrestore(&stats->syncp, flags);
-}
-
 /* The logic is similar to bpf_prog_run(), but with an explicit
  * rcu_read_lock() and migrate_disable() which are required
  * for the trampoline. The macro is split into
@@ -896,7 +885,7 @@ u64 notrace __bpf_prog_enter(struct bpf_prog *prog, struct bpf_tramp_run_ctx *ru
 	run_ctx->saved_run_ctx = bpf_set_run_ctx(&run_ctx->run_ctx);
 
 	if (unlikely(this_cpu_inc_return(*(prog->active)) != 1)) {
-		inc_misses_counter(prog);
+		bpf_prog_inc_misses_counter(prog);
 		return 0;
 	}
 	return bpf_prog_start_time();
@@ -967,7 +956,7 @@ u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog, struct bpf_tramp_r
 	might_fault();
 
 	if (unlikely(this_cpu_inc_return(*(prog->active)) != 1)) {
-		inc_misses_counter(prog);
+		bpf_prog_inc_misses_counter(prog);
 		return 0;
 	}
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 69fb46fdf763..b781075dd510 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6674,11 +6674,11 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 	/* Transfer references to the callee */
 	err = copy_reference_state(callee, caller);
 	if (err)
-		return err;
+		goto err_out;
 
 	err = set_callee_state_cb(env, caller, callee, *insn_idx);
 	if (err)
-		return err;
+		goto err_out;
 
 	clear_caller_saved_regs(env, caller->regs);
 
@@ -6695,6 +6695,11 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		print_verifier_state(env, callee, true);
 	}
 	return 0;
+
+err_out:
+	free_func_state(callee);
+	state->frame[state->curframe + 1] = NULL;
+	return err;
 }
 
 int map_set_for_each_callback_args(struct bpf_verifier_env *env,
@@ -6880,8 +6885,7 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 		return -EINVAL;
 	}
 
-	state->curframe--;
-	caller = state->frame[state->curframe];
+	caller = state->frame[state->curframe - 1];
 	if (callee->in_callback_fn) {
 		/* enforce R0 return value range [0, 1]. */
 		struct tnum range = tnum_range(0, 1);
@@ -6920,7 +6924,7 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 	}
 	/* clear everything in the callee */
 	free_func_state(callee);
-	state->frame[state->curframe + 1] = NULL;
+	state->frame[state->curframe--] = NULL;
 	return 0;
 }
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 072ab26269c0..bec18d81b116 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9282,14 +9282,27 @@ static int __perf_event_overflow(struct perf_event *event,
 	}
 
 	if (event->attr.sigtrap) {
-		/*
-		 * Should not be able to return to user space without processing
-		 * pending_sigtrap (kernel events can overflow multiple times).
-		 */
-		WARN_ON_ONCE(event->pending_sigtrap && event->attr.exclude_kernel);
+		unsigned int pending_id = 1;
+
+		if (regs)
+			pending_id = hash32_ptr((void *)instruction_pointer(regs)) ?: 1;
 		if (!event->pending_sigtrap) {
-			event->pending_sigtrap = 1;
+			event->pending_sigtrap = pending_id;
 			local_inc(&event->ctx->nr_pending);
+		} else if (event->attr.exclude_kernel) {
+			/*
+			 * Should not be able to return to user space without
+			 * consuming pending_sigtrap; with exceptions:
+			 *
+			 *  1. Where !exclude_kernel, events can overflow again
+			 *     in the kernel without returning to user space.
+			 *
+			 *  2. Events that can overflow again before the IRQ-
+			 *     work without user space progress (e.g. hrtimer).
+			 *     To approximate progress (with false negatives),
+			 *     check 32-bit hash of the current IP.
+			 */
+			WARN_ON_ONCE(event->pending_sigtrap != pending_id);
 		}
 		event->pending_addr = data->addr;
 		irq_work_queue(&event->pending_irq);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 917b92ae2382..6d2a8623ec7b 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1762,7 +1762,13 @@ static int __unregister_kprobe_top(struct kprobe *p)
 				if ((list_p != p) && (list_p->post_handler))
 					goto noclean;
 			}
-			ap->post_handler = NULL;
+			/*
+			 * For the kprobe-on-ftrace case, we keep the
+			 * post_handler setting to identify this aggrprobe
+			 * armed with kprobe_ipmodify_ops.
+			 */
+			if (!kprobe_ftrace(ap))
+				ap->post_handler = NULL;
 		}
 noclean:
 		/*
diff --git a/kernel/rseq.c b/kernel/rseq.c
index bda8175f8f99..d38ab944105d 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -171,12 +171,27 @@ static int rseq_get_rseq_cs(struct task_struct *t, struct rseq_cs *rseq_cs)
 	return 0;
 }
 
+static bool rseq_warn_flags(const char *str, u32 flags)
+{
+	u32 test_flags;
+
+	if (!flags)
+		return false;
+	test_flags = flags & RSEQ_CS_NO_RESTART_FLAGS;
+	if (test_flags)
+		pr_warn_once("Deprecated flags (%u) in %s ABI structure", test_flags, str);
+	test_flags = flags & ~RSEQ_CS_NO_RESTART_FLAGS;
+	if (test_flags)
+		pr_warn_once("Unknown flags (%u) in %s ABI structure", test_flags, str);
+	return true;
+}
+
 static int rseq_need_restart(struct task_struct *t, u32 cs_flags)
 {
 	u32 flags, event_mask;
 	int ret;
 
-	if (WARN_ON_ONCE(cs_flags & RSEQ_CS_NO_RESTART_FLAGS) || cs_flags)
+	if (rseq_warn_flags("rseq_cs", cs_flags))
 		return -EINVAL;
 
 	/* Get thread flags. */
@@ -184,7 +199,7 @@ static int rseq_need_restart(struct task_struct *t, u32 cs_flags)
 	if (ret)
 		return ret;
 
-	if (WARN_ON_ONCE(flags & RSEQ_CS_NO_RESTART_FLAGS) || flags)
+	if (rseq_warn_flags("rseq", flags))
 		return -EINVAL;
 
 	/*
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index b1daf7c9b895..ec4b81007796 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2058,9 +2058,15 @@ static __always_inline
 void __bpf_trace_run(struct bpf_prog *prog, u64 *args)
 {
 	cant_sleep();
+	if (unlikely(this_cpu_inc_return(*(prog->active)) != 1)) {
+		bpf_prog_inc_misses_counter(prog);
+		goto out;
+	}
 	rcu_read_lock();
 	(void) bpf_prog_run(prog, args);
 	rcu_read_unlock();
+out:
+	this_cpu_dec(*(prog->active));
 }
 
 #define UNPACK(...)			__VA_ARGS__
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8cc9eb60c3c2..9e6231f4a04f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1289,6 +1289,7 @@ static int ftrace_add_mod(struct trace_array *tr,
 	if (!ftrace_mod)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&ftrace_mod->list);
 	ftrace_mod->func = kstrdup(func, GFP_KERNEL);
 	ftrace_mod->module = kstrdup(module, GFP_KERNEL);
 	ftrace_mod->enable = enable;
@@ -3193,7 +3194,7 @@ static int ftrace_allocate_records(struct ftrace_page *pg, int count)
 		/* if we can't allocate this size, try something smaller */
 		if (!order)
 			return -ENOMEM;
-		order >>= 1;
+		order--;
 		goto again;
 	}
 
@@ -7394,7 +7395,7 @@ void __init ftrace_init(void)
 	}
 
 	pr_info("ftrace: allocating %ld entries in %ld pages\n",
-		count, count / ENTRIES_PER_PAGE + 1);
+		count, DIV_ROUND_UP(count, ENTRIES_PER_PAGE));
 
 	ret = ftrace_process_locs(NULL,
 				  __start_mcount_loc,
diff --git a/kernel/trace/kprobe_event_gen_test.c b/kernel/trace/kprobe_event_gen_test.c
index d81f7c51025c..c736487fc0e4 100644
--- a/kernel/trace/kprobe_event_gen_test.c
+++ b/kernel/trace/kprobe_event_gen_test.c
@@ -73,6 +73,10 @@ static struct trace_event_file *gen_kretprobe_test;
 #define KPROBE_GEN_TEST_ARG3	NULL
 #endif
 
+static bool trace_event_file_is_valid(struct trace_event_file *input)
+{
+	return input && !IS_ERR(input);
+}
 
 /*
  * Test to make sure we can create a kprobe event, then add more
@@ -139,6 +143,8 @@ static int __init test_gen_kprobe_cmd(void)
 	kfree(buf);
 	return ret;
  delete:
+	if (trace_event_file_is_valid(gen_kprobe_test))
+		gen_kprobe_test = NULL;
 	/* We got an error after creating the event, delete it */
 	ret = kprobe_event_delete("gen_kprobe_test");
 	goto out;
@@ -202,6 +208,8 @@ static int __init test_gen_kretprobe_cmd(void)
 	kfree(buf);
 	return ret;
  delete:
+	if (trace_event_file_is_valid(gen_kretprobe_test))
+		gen_kretprobe_test = NULL;
 	/* We got an error after creating the event, delete it */
 	ret = kprobe_event_delete("gen_kretprobe_test");
 	goto out;
@@ -217,10 +225,12 @@ static int __init kprobe_event_gen_test_init(void)
 
 	ret = test_gen_kretprobe_cmd();
 	if (ret) {
-		WARN_ON(trace_array_set_clr_event(gen_kretprobe_test->tr,
-						  "kprobes",
-						  "gen_kretprobe_test", false));
-		trace_put_event_file(gen_kretprobe_test);
+		if (trace_event_file_is_valid(gen_kretprobe_test)) {
+			WARN_ON(trace_array_set_clr_event(gen_kretprobe_test->tr,
+							  "kprobes",
+							  "gen_kretprobe_test", false));
+			trace_put_event_file(gen_kretprobe_test);
+		}
 		WARN_ON(kprobe_event_delete("gen_kretprobe_test"));
 	}
 
@@ -229,24 +239,30 @@ static int __init kprobe_event_gen_test_init(void)
 
 static void __exit kprobe_event_gen_test_exit(void)
 {
-	/* Disable the event or you can't remove it */
-	WARN_ON(trace_array_set_clr_event(gen_kprobe_test->tr,
-					  "kprobes",
-					  "gen_kprobe_test", false));
+	if (trace_event_file_is_valid(gen_kprobe_test)) {
+		/* Disable the event or you can't remove it */
+		WARN_ON(trace_array_set_clr_event(gen_kprobe_test->tr,
+						  "kprobes",
+						  "gen_kprobe_test", false));
+
+		/* Now give the file and instance back */
+		trace_put_event_file(gen_kprobe_test);
+	}
 
-	/* Now give the file and instance back */
-	trace_put_event_file(gen_kprobe_test);
 
 	/* Now unregister and free the event */
 	WARN_ON(kprobe_event_delete("gen_kprobe_test"));
 
-	/* Disable the event or you can't remove it */
-	WARN_ON(trace_array_set_clr_event(gen_kretprobe_test->tr,
-					  "kprobes",
-					  "gen_kretprobe_test", false));
+	if (trace_event_file_is_valid(gen_kretprobe_test)) {
+		/* Disable the event or you can't remove it */
+		WARN_ON(trace_array_set_clr_event(gen_kretprobe_test->tr,
+						  "kprobes",
+						  "gen_kretprobe_test", false));
+
+		/* Now give the file and instance back */
+		trace_put_event_file(gen_kretprobe_test);
+	}
 
-	/* Now give the file and instance back */
-	trace_put_event_file(gen_kretprobe_test);
 
 	/* Now unregister and free the event */
 	WARN_ON(kprobe_event_delete("gen_kretprobe_test"));
diff --git a/kernel/trace/rethook.c b/kernel/trace/rethook.c
index c69d82273ce7..32c3dfdb4d6a 100644
--- a/kernel/trace/rethook.c
+++ b/kernel/trace/rethook.c
@@ -83,8 +83,10 @@ struct rethook *rethook_alloc(void *data, rethook_handler_t handler)
 {
 	struct rethook *rh = kzalloc(sizeof(struct rethook), GFP_KERNEL);
 
-	if (!rh || !handler)
+	if (!rh || !handler) {
+		kfree(rh);
 		return NULL;
+	}
 
 	rh->data = data;
 	rh->handler = handler;
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 9c72571ffb0b..0b93dc17457d 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -519,6 +519,7 @@ struct ring_buffer_per_cpu {
 	local_t				committing;
 	local_t				commits;
 	local_t				pages_touched;
+	local_t				pages_lost;
 	local_t				pages_read;
 	long				last_pages_touch;
 	size_t				shortest_full;
@@ -894,10 +895,18 @@ size_t ring_buffer_nr_pages(struct trace_buffer *buffer, int cpu)
 size_t ring_buffer_nr_dirty_pages(struct trace_buffer *buffer, int cpu)
 {
 	size_t read;
+	size_t lost;
 	size_t cnt;
 
 	read = local_read(&buffer->buffers[cpu]->pages_read);
+	lost = local_read(&buffer->buffers[cpu]->pages_lost);
 	cnt = local_read(&buffer->buffers[cpu]->pages_touched);
+
+	if (WARN_ON_ONCE(cnt < lost))
+		return 0;
+
+	cnt -= lost;
+
 	/* The reader can read an empty page, but not more than that */
 	if (cnt < read) {
 		WARN_ON_ONCE(read > cnt + 1);
@@ -907,6 +916,21 @@ size_t ring_buffer_nr_dirty_pages(struct trace_buffer *buffer, int cpu)
 	return cnt - read;
 }
 
+static __always_inline bool full_hit(struct trace_buffer *buffer, int cpu, int full)
+{
+	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
+	size_t nr_pages;
+	size_t dirty;
+
+	nr_pages = cpu_buffer->nr_pages;
+	if (!nr_pages || !full)
+		return true;
+
+	dirty = ring_buffer_nr_dirty_pages(buffer, cpu);
+
+	return (dirty * 100) > (full * nr_pages);
+}
+
 /*
  * rb_wake_up_waiters - wake up tasks waiting for ring buffer input
  *
@@ -1046,22 +1070,20 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
 		    !ring_buffer_empty_cpu(buffer, cpu)) {
 			unsigned long flags;
 			bool pagebusy;
-			size_t nr_pages;
-			size_t dirty;
+			bool done;
 
 			if (!full)
 				break;
 
 			raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 			pagebusy = cpu_buffer->reader_page == cpu_buffer->commit_page;
-			nr_pages = cpu_buffer->nr_pages;
-			dirty = ring_buffer_nr_dirty_pages(buffer, cpu);
+			done = !pagebusy && full_hit(buffer, cpu, full);
+
 			if (!cpu_buffer->shortest_full ||
 			    cpu_buffer->shortest_full > full)
 				cpu_buffer->shortest_full = full;
 			raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
-			if (!pagebusy &&
-			    (!nr_pages || (dirty * 100) > full * nr_pages))
+			if (done)
 				break;
 		}
 
@@ -1087,6 +1109,7 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
  * @cpu: the cpu buffer to wait on
  * @filp: the file descriptor
  * @poll_table: The poll descriptor
+ * @full: wait until the percentage of pages are available, if @cpu != RING_BUFFER_ALL_CPUS
  *
  * If @cpu == RING_BUFFER_ALL_CPUS then the task will wake up as soon
  * as data is added to any of the @buffer's cpu buffers. Otherwise
@@ -1096,14 +1119,15 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
  * zero otherwise.
  */
 __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
-			  struct file *filp, poll_table *poll_table)
+			  struct file *filp, poll_table *poll_table, int full)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct rb_irq_work *work;
 
-	if (cpu == RING_BUFFER_ALL_CPUS)
+	if (cpu == RING_BUFFER_ALL_CPUS) {
 		work = &buffer->irq_work;
-	else {
+		full = 0;
+	} else {
 		if (!cpumask_test_cpu(cpu, buffer->cpumask))
 			return -EINVAL;
 
@@ -1111,8 +1135,14 @@ __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
 		work = &cpu_buffer->irq_work;
 	}
 
-	poll_wait(filp, &work->waiters, poll_table);
-	work->waiters_pending = true;
+	if (full) {
+		poll_wait(filp, &work->full_waiters, poll_table);
+		work->full_waiters_pending = true;
+	} else {
+		poll_wait(filp, &work->waiters, poll_table);
+		work->waiters_pending = true;
+	}
+
 	/*
 	 * There's a tight race between setting the waiters_pending and
 	 * checking if the ring buffer is empty.  Once the waiters_pending bit
@@ -1128,6 +1158,9 @@ __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
 	 */
 	smp_mb();
 
+	if (full)
+		return full_hit(buffer, cpu, full) ? EPOLLIN | EPOLLRDNORM : 0;
+
 	if ((cpu == RING_BUFFER_ALL_CPUS && !ring_buffer_empty(buffer)) ||
 	    (cpu != RING_BUFFER_ALL_CPUS && !ring_buffer_empty_cpu(buffer, cpu)))
 		return EPOLLIN | EPOLLRDNORM;
@@ -1769,9 +1802,9 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
 
 	free_buffer_page(cpu_buffer->reader_page);
 
-	rb_head_page_deactivate(cpu_buffer);
-
 	if (head) {
+		rb_head_page_deactivate(cpu_buffer);
+
 		list_for_each_entry_safe(bpage, tmp, head, list) {
 			list_del_init(&bpage->list);
 			free_buffer_page(bpage);
@@ -2007,6 +2040,7 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned long nr_pages)
 			 */
 			local_add(page_entries, &cpu_buffer->overrun);
 			local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
+			local_inc(&cpu_buffer->pages_lost);
 		}
 
 		/*
@@ -2491,6 +2525,7 @@ rb_handle_head_page(struct ring_buffer_per_cpu *cpu_buffer,
 		 */
 		local_add(entries, &cpu_buffer->overrun);
 		local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
+		local_inc(&cpu_buffer->pages_lost);
 
 		/*
 		 * The entries will be zeroed out when we move the
@@ -3155,10 +3190,6 @@ static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
 static __always_inline void
 rb_wakeups(struct trace_buffer *buffer, struct ring_buffer_per_cpu *cpu_buffer)
 {
-	size_t nr_pages;
-	size_t dirty;
-	size_t full;
-
 	if (buffer->irq_work.waiters_pending) {
 		buffer->irq_work.waiters_pending = false;
 		/* irq_work_queue() supplies it's own memory barriers */
@@ -3182,10 +3213,7 @@ rb_wakeups(struct trace_buffer *buffer, struct ring_buffer_per_cpu *cpu_buffer)
 
 	cpu_buffer->last_pages_touch = local_read(&cpu_buffer->pages_touched);
 
-	full = cpu_buffer->shortest_full;
-	nr_pages = cpu_buffer->nr_pages;
-	dirty = ring_buffer_nr_dirty_pages(buffer, cpu_buffer->cpu);
-	if (full && nr_pages && (dirty * 100) <= full * nr_pages)
+	if (!full_hit(buffer, cpu_buffer->cpu, cpu_buffer->shortest_full))
 		return;
 
 	cpu_buffer->irq_work.wakeup_full = true;
@@ -5248,6 +5276,7 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	local_set(&cpu_buffer->committing, 0);
 	local_set(&cpu_buffer->commits, 0);
 	local_set(&cpu_buffer->pages_touched, 0);
+	local_set(&cpu_buffer->pages_lost, 0);
 	local_set(&cpu_buffer->pages_read, 0);
 	cpu_buffer->last_pages_touch = 0;
 	cpu_buffer->shortest_full = 0;
diff --git a/kernel/trace/synth_event_gen_test.c b/kernel/trace/synth_event_gen_test.c
index 0b15e975d2c2..8d77526892f4 100644
--- a/kernel/trace/synth_event_gen_test.c
+++ b/kernel/trace/synth_event_gen_test.c
@@ -120,15 +120,13 @@ static int __init test_gen_synth_cmd(void)
 
 	/* Now generate a gen_synth_test event */
 	ret = synth_event_trace_array(gen_synth_test, vals, ARRAY_SIZE(vals));
- out:
+ free:
+	kfree(buf);
 	return ret;
  delete:
 	/* We got an error after creating the event, delete it */
 	synth_event_delete("gen_synth_test");
- free:
-	kfree(buf);
-
-	goto out;
+	goto free;
 }
 
 /*
@@ -227,15 +225,13 @@ static int __init test_empty_synth_event(void)
 
 	/* Now trace an empty_synth_test event */
 	ret = synth_event_trace_array(empty_synth_test, vals, ARRAY_SIZE(vals));
- out:
+ free:
+	kfree(buf);
 	return ret;
  delete:
 	/* We got an error after creating the event, delete it */
 	synth_event_delete("empty_synth_test");
- free:
-	kfree(buf);
-
-	goto out;
+	goto free;
 }
 
 static struct synth_field_desc create_synth_test_fields[] = {
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index cc65887b31bd..7132e21e90d6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6657,6 +6657,7 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
 	mutex_unlock(&trace_types_lock);
 
 	free_cpumask_var(iter->started);
+	kfree(iter->fmt);
 	mutex_destroy(&iter->mutex);
 	kfree(iter);
 
@@ -6681,7 +6682,7 @@ trace_poll(struct trace_iterator *iter, struct file *filp, poll_table *poll_tabl
 		return EPOLLIN | EPOLLRDNORM;
 	else
 		return ring_buffer_poll_wait(iter->array_buffer->buffer, iter->cpu_file,
-					     filp, poll_table);
+					     filp, poll_table, iter->tr->buffer_percent);
 }
 
 static __poll_t
@@ -7802,6 +7803,7 @@ static struct tracing_log_err *get_tracing_log_err(struct trace_array *tr,
 						   int len)
 {
 	struct tracing_log_err *err;
+	char *cmd;
 
 	if (tr->n_err_log_entries < TRACING_LOG_ERRS_MAX) {
 		err = alloc_tracing_log_err(len);
@@ -7810,12 +7812,12 @@ static struct tracing_log_err *get_tracing_log_err(struct trace_array *tr,
 
 		return err;
 	}
-
+	cmd = kzalloc(len, GFP_KERNEL);
+	if (!cmd)
+		return ERR_PTR(-ENOMEM);
 	err = list_first_entry(&tr->err_log, struct tracing_log_err, list);
 	kfree(err->cmd);
-	err->cmd = kzalloc(len, GFP_KERNEL);
-	if (!err->cmd)
-		return ERR_PTR(-ENOMEM);
+	err->cmd = cmd;
 	list_del(&err->list);
 
 	return err;
diff --git a/kernel/trace/trace_eprobe.c b/kernel/trace/trace_eprobe.c
index 860f5fb9514d..3b055aaee89a 100644
--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -560,6 +560,9 @@ static void eprobe_trigger_func(struct event_trigger_data *data,
 {
 	struct eprobe_data *edata = data->private_data;
 
+	if (unlikely(!rec))
+		return;
+
 	__eprobe_trace_func(edata, rec);
 }
 
diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index e310052dc83c..29fbfb27c2b2 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -828,10 +828,9 @@ static int register_synth_event(struct synth_event *event)
 	}
 
 	ret = set_synth_event_print_fmt(call);
-	if (ret < 0) {
+	/* unregister_trace_event() will be called inside */
+	if (ret < 0)
 		trace_remove_event_call(call);
-		goto err;
-	}
  out:
 	return ret;
  err:
diff --git a/mm/filemap.c b/mm/filemap.c
index 15800334147b..ada25b9f45ad 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3712,7 +3712,7 @@ ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
 		unsigned long offset;	/* Offset into pagecache page */
 		unsigned long bytes;	/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
-		void *fsdata;
+		void *fsdata = NULL;
 
 		offset = (pos & (PAGE_SIZE - 1));
 		bytes = min_t(unsigned long, PAGE_SIZE - offset,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ecc197d24efb..dbb558e71e9e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5445,7 +5445,7 @@ static bool hugetlbfs_pagecache_present(struct hstate *h,
 	return page != NULL;
 }
 
-int huge_add_to_page_cache(struct page *page, struct address_space *mapping,
+int hugetlb_add_to_page_cache(struct page *page, struct address_space *mapping,
 			   pgoff_t idx)
 {
 	struct folio *folio = page_folio(page);
@@ -5583,7 +5583,7 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 		new_page = true;
 
 		if (vma->vm_flags & VM_MAYSHARE) {
-			int err = huge_add_to_page_cache(page, mapping, idx);
+			int err = hugetlb_add_to_page_cache(page, mapping, idx);
 			if (err) {
 				put_page(page);
 				if (err == -EEXIST)
@@ -6008,11 +6008,11 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 
 		/*
 		 * Serialization between remove_inode_hugepages() and
-		 * huge_add_to_page_cache() below happens through the
+		 * hugetlb_add_to_page_cache() below happens through the
 		 * hugetlb_fault_mutex_table that here must be hold by
 		 * the caller.
 		 */
-		ret = huge_add_to_page_cache(page, mapping, idx);
+		ret = hugetlb_add_to_page_cache(page, mapping, idx);
 		if (ret)
 			goto out_release_nounlock;
 		page_in_pagecache = true;
@@ -6021,6 +6021,10 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 	ptl = huge_pte_lockptr(h, dst_mm, dst_pte);
 	spin_lock(ptl);
 
+	ret = -EIO;
+	if (PageHWPoison(page))
+		goto out_release_unlock;
+
 	/*
 	 * Recheck the i_size after holding PT lock to make sure not
 	 * to leave any page mapped (as page_mapped()) beyond the end
diff --git a/mm/maccess.c b/mm/maccess.c
index 5f4d240f67ec..074f6b086671 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -97,7 +97,7 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 	return src - unsafe_addr;
 Efault:
 	pagefault_enable();
-	dst[-1] = '\0';
+	dst[0] = '\0';
 	return -EFAULT;
 }
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index e7ac570dda75..4d302f6b02fc 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1079,6 +1079,7 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 	int res;
 	struct page *hpage = compound_head(p);
 	struct address_space *mapping;
+	bool extra_pins = false;
 
 	if (!PageHuge(hpage))
 		return MF_DELAYED;
@@ -1086,6 +1087,8 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 	mapping = page_mapping(hpage);
 	if (mapping) {
 		res = truncate_error_page(hpage, page_to_pfn(p), mapping);
+		/* The page is kept in page cache. */
+		extra_pins = true;
 		unlock_page(hpage);
 	} else {
 		unlock_page(hpage);
@@ -1103,7 +1106,7 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 		}
 	}
 
-	if (has_extra_refcount(ps, p, false))
+	if (has_extra_refcount(ps, p, extra_pins))
 		res = MF_FAILED;
 
 	return res;
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index e758978b44be..0191f22d1ec3 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -91,6 +91,7 @@ struct p9_poll_wait {
  * @mux_list: list link for mux to manage multiple connections (?)
  * @client: reference to client instance for this connection
  * @err: error state
+ * @req_lock: lock protecting req_list and requests statuses
  * @req_list: accounting for requests which have been sent
  * @unsent_req_list: accounting for requests that haven't been sent
  * @rreq: read request
@@ -114,6 +115,7 @@ struct p9_conn {
 	struct list_head mux_list;
 	struct p9_client *client;
 	int err;
+	spinlock_t req_lock;
 	struct list_head req_list;
 	struct list_head unsent_req_list;
 	struct p9_req_t *rreq;
@@ -189,10 +191,10 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 
 	p9_debug(P9_DEBUG_ERROR, "mux %p err %d\n", m, err);
 
-	spin_lock(&m->client->lock);
+	spin_lock(&m->req_lock);
 
 	if (m->err) {
-		spin_unlock(&m->client->lock);
+		spin_unlock(&m->req_lock);
 		return;
 	}
 
@@ -205,6 +207,8 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 		list_move(&req->req_list, &cancel_list);
 	}
 
+	spin_unlock(&m->req_lock);
+
 	list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
 		p9_debug(P9_DEBUG_ERROR, "call back req %p\n", req);
 		list_del(&req->req_list);
@@ -212,7 +216,6 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 			req->t_err = err;
 		p9_client_cb(m->client, req, REQ_STATUS_ERROR);
 	}
-	spin_unlock(&m->client->lock);
 }
 
 static __poll_t
@@ -359,7 +362,7 @@ static void p9_read_work(struct work_struct *work)
 	if ((m->rreq) && (m->rc.offset == m->rc.capacity)) {
 		p9_debug(P9_DEBUG_TRANS, "got new packet\n");
 		m->rreq->rc.size = m->rc.offset;
-		spin_lock(&m->client->lock);
+		spin_lock(&m->req_lock);
 		if (m->rreq->status == REQ_STATUS_SENT) {
 			list_del(&m->rreq->req_list);
 			p9_client_cb(m->client, m->rreq, REQ_STATUS_RCVD);
@@ -368,14 +371,14 @@ static void p9_read_work(struct work_struct *work)
 			p9_debug(P9_DEBUG_TRANS,
 				 "Ignore replies associated with a cancelled request\n");
 		} else {
-			spin_unlock(&m->client->lock);
+			spin_unlock(&m->req_lock);
 			p9_debug(P9_DEBUG_ERROR,
 				 "Request tag %d errored out while we were reading the reply\n",
 				 m->rc.tag);
 			err = -EIO;
 			goto error;
 		}
-		spin_unlock(&m->client->lock);
+		spin_unlock(&m->req_lock);
 		m->rc.sdata = NULL;
 		m->rc.offset = 0;
 		m->rc.capacity = 0;
@@ -453,10 +456,10 @@ static void p9_write_work(struct work_struct *work)
 	}
 
 	if (!m->wsize) {
-		spin_lock(&m->client->lock);
+		spin_lock(&m->req_lock);
 		if (list_empty(&m->unsent_req_list)) {
 			clear_bit(Wworksched, &m->wsched);
-			spin_unlock(&m->client->lock);
+			spin_unlock(&m->req_lock);
 			return;
 		}
 
@@ -471,7 +474,7 @@ static void p9_write_work(struct work_struct *work)
 		m->wpos = 0;
 		p9_req_get(req);
 		m->wreq = req;
-		spin_unlock(&m->client->lock);
+		spin_unlock(&m->req_lock);
 	}
 
 	p9_debug(P9_DEBUG_TRANS, "mux %p pos %d size %d\n",
@@ -588,6 +591,7 @@ static void p9_conn_create(struct p9_client *client)
 	INIT_LIST_HEAD(&m->mux_list);
 	m->client = client;
 
+	spin_lock_init(&m->req_lock);
 	INIT_LIST_HEAD(&m->req_list);
 	INIT_LIST_HEAD(&m->unsent_req_list);
 	INIT_WORK(&m->rq, p9_read_work);
@@ -669,10 +673,10 @@ static int p9_fd_request(struct p9_client *client, struct p9_req_t *req)
 	if (m->err < 0)
 		return m->err;
 
-	spin_lock(&client->lock);
+	spin_lock(&m->req_lock);
 	req->status = REQ_STATUS_UNSENT;
 	list_add_tail(&req->req_list, &m->unsent_req_list);
-	spin_unlock(&client->lock);
+	spin_unlock(&m->req_lock);
 
 	if (test_and_clear_bit(Wpending, &m->wsched))
 		n = EPOLLOUT;
@@ -687,11 +691,13 @@ static int p9_fd_request(struct p9_client *client, struct p9_req_t *req)
 
 static int p9_fd_cancel(struct p9_client *client, struct p9_req_t *req)
 {
+	struct p9_trans_fd *ts = client->trans;
+	struct p9_conn *m = &ts->conn;
 	int ret = 1;
 
 	p9_debug(P9_DEBUG_TRANS, "client %p req %p\n", client, req);
 
-	spin_lock(&client->lock);
+	spin_lock(&m->req_lock);
 
 	if (req->status == REQ_STATUS_UNSENT) {
 		list_del(&req->req_list);
@@ -699,21 +705,24 @@ static int p9_fd_cancel(struct p9_client *client, struct p9_req_t *req)
 		p9_req_put(client, req);
 		ret = 0;
 	}
-	spin_unlock(&client->lock);
+	spin_unlock(&m->req_lock);
 
 	return ret;
 }
 
 static int p9_fd_cancelled(struct p9_client *client, struct p9_req_t *req)
 {
+	struct p9_trans_fd *ts = client->trans;
+	struct p9_conn *m = &ts->conn;
+
 	p9_debug(P9_DEBUG_TRANS, "client %p req %p\n", client, req);
 
-	spin_lock(&client->lock);
+	spin_lock(&m->req_lock);
 	/* Ignore cancelled request if message has been received
 	 * before lock.
 	 */
 	if (req->status == REQ_STATUS_RCVD) {
-		spin_unlock(&client->lock);
+		spin_unlock(&m->req_lock);
 		return 0;
 	}
 
@@ -722,7 +731,8 @@ static int p9_fd_cancelled(struct p9_client *client, struct p9_req_t *req)
 	 */
 	list_del(&req->req_list);
 	req->status = REQ_STATUS_FLSHD;
-	spin_unlock(&client->lock);
+	spin_unlock(&m->req_lock);
+
 	p9_req_put(client, req);
 
 	return 0;
@@ -821,11 +831,14 @@ static int p9_fd_open(struct p9_client *client, int rfd, int wfd)
 		goto out_free_ts;
 	if (!(ts->rd->f_mode & FMODE_READ))
 		goto out_put_rd;
+	/* prevent workers from hanging on IO when fd is a pipe */
+	ts->rd->f_flags |= O_NONBLOCK;
 	ts->wr = fget(wfd);
 	if (!ts->wr)
 		goto out_put_rd;
 	if (!(ts->wr->f_mode & FMODE_WRITE))
 		goto out_put_wr;
+	ts->wr->f_flags |= O_NONBLOCK;
 
 	client->trans = ts;
 	client->status = Connected;
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 4df3d0ed6c80..9c24947aa41e 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1990,7 +1990,7 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
 		if (link_type == LE_LINK && c->src_type == BDADDR_BREDR)
 			continue;
 
-		if (c->psm == psm) {
+		if (c->chan_type != L2CAP_CHAN_FIXED && c->psm == psm) {
 			int src_match, dst_match;
 			int src_any, dst_any;
 
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index d11209367dd0..b422238f9f86 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -733,6 +733,7 @@ static void *bpf_test_init(const union bpf_attr *kattr, u32 user_size,
 	if (user_size > size)
 		return ERR_PTR(-EMSGSIZE);
 
+	size = SKB_DATA_ALIGN(size);
 	data = kzalloc(size + headroom + tailroom, GFP_USER);
 	if (!data)
 		return ERR_PTR(-ENOMEM);
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 6e53dc991409..9ffd40b8270c 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -959,6 +959,8 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
 	list_for_each_entry(p, &br->port_list, list) {
 		vg = nbp_vlan_group(p);
 		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
+			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
+				continue;
 			err = vlan_vid_add(p->dev, proto, vlan->vid);
 			if (err)
 				goto err_filt;
@@ -973,8 +975,11 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
 	/* Delete VLANs for the old proto from the device filter. */
 	list_for_each_entry(p, &br->port_list, list) {
 		vg = nbp_vlan_group(p);
-		list_for_each_entry(vlan, &vg->vlan_list, vlist)
+		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
+			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
+				continue;
 			vlan_vid_del(p->dev, oldproto, vlan->vid);
+		}
 	}
 
 	return 0;
@@ -983,13 +988,19 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
 	attr.u.vlan_protocol = ntohs(oldproto);
 	switchdev_port_attr_set(br->dev, &attr, NULL);
 
-	list_for_each_entry_continue_reverse(vlan, &vg->vlan_list, vlist)
+	list_for_each_entry_continue_reverse(vlan, &vg->vlan_list, vlist) {
+		if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
+			continue;
 		vlan_vid_del(p->dev, proto, vlan->vid);
+	}
 
 	list_for_each_entry_continue_reverse(p, &br->port_list, list) {
 		vg = nbp_vlan_group(p);
-		list_for_each_entry(vlan, &vg->vlan_list, vlist)
+		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
+			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
+				continue;
 			vlan_vid_del(p->dev, proto, vlan->vid);
+		}
 	}
 
 	return err;
diff --git a/net/caif/chnl_net.c b/net/caif/chnl_net.c
index 4d63ef13a1fd..f35fc87c453a 100644
--- a/net/caif/chnl_net.c
+++ b/net/caif/chnl_net.c
@@ -310,9 +310,6 @@ static int chnl_net_open(struct net_device *dev)
 
 	if (result == 0) {
 		pr_debug("connect timeout\n");
-		caif_disconnect_client(dev_net(dev), &priv->chnl);
-		priv->state = CAIF_DISCONNECTED;
-		pr_debug("state disconnected\n");
 		result = -ETIMEDOUT;
 		goto error;
 	}
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index e537655e442b..befa954b0a47 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -850,6 +850,14 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 	return err;
 }
 
+static void dsa_switch_teardown_tag_protocol(struct dsa_switch *ds)
+{
+	const struct dsa_device_ops *tag_ops = ds->dst->tag_ops;
+
+	if (tag_ops->disconnect)
+		tag_ops->disconnect(ds);
+}
+
 static int dsa_switch_setup(struct dsa_switch *ds)
 {
 	struct dsa_devlink_priv *dl_priv;
@@ -953,6 +961,8 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 		ds->slave_mii_bus = NULL;
 	}
 
+	dsa_switch_teardown_tag_protocol(ds);
+
 	if (ds->ops->teardown)
 		ds->ops->teardown(ds);
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d9722e49864b..acea875c05e5 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -201,6 +201,7 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 }
 
 /* port.c */
+bool dsa_port_supports_hwtstamp(struct dsa_port *dp, struct ifreq *ifr);
 void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
 			       const struct dsa_device_ops *tag_ops);
 int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age);
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 2851e44c4cf0..46b1f0455a7b 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -204,8 +204,7 @@ static int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		 * switch in the tree that is PTP capable.
 		 */
 		list_for_each_entry(dp, &dst->ports, list)
-			if (dp->ds->ops->port_hwtstamp_get ||
-			    dp->ds->ops->port_hwtstamp_set)
+			if (dsa_port_supports_hwtstamp(dp, ifr))
 				return -EBUSY;
 		break;
 	}
diff --git a/net/dsa/port.c b/net/dsa/port.c
index a8895ee3cd60..9ac87063cca8 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -109,6 +109,22 @@ static bool dsa_port_can_configure_learning(struct dsa_port *dp)
 	return !err;
 }
 
+bool dsa_port_supports_hwtstamp(struct dsa_port *dp, struct ifreq *ifr)
+{
+	struct dsa_switch *ds = dp->ds;
+	int err;
+
+	if (!ds->ops->port_hwtstamp_get || !ds->ops->port_hwtstamp_set)
+		return false;
+
+	/* "See through" shim implementations of the "get" method.
+	 * This will clobber the ifreq structure, but we will either return an
+	 * error, or the master will overwrite it with proper values.
+	 */
+	err = ds->ops->port_hwtstamp_get(ds, dp->index, ifr);
+	return err != -EOPNOTSUPP;
+}
+
 int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age)
 {
 	struct dsa_switch *ds = dp->ds;
diff --git a/net/ipv4/tcp_cdg.c b/net/ipv4/tcp_cdg.c
index ddc7ba0554bd..112f28f93693 100644
--- a/net/ipv4/tcp_cdg.c
+++ b/net/ipv4/tcp_cdg.c
@@ -375,6 +375,7 @@ static void tcp_cdg_init(struct sock *sk)
 	struct cdg *ca = inet_csk_ca(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 
+	ca->gradients = NULL;
 	/* We silently fall back to window = 1 if allocation fails. */
 	if (window > 1)
 		ca->gradients = kcalloc(window, sizeof(ca->gradients[0]),
@@ -388,6 +389,7 @@ static void tcp_cdg_release(struct sock *sk)
 	struct cdg *ca = inet_csk_ca(sk);
 
 	kfree(ca->gradients);
+	ca->gradients = NULL;
 }
 
 static struct tcp_congestion_ops tcp_cdg __read_mostly = {
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index befc62606cdf..890a2423f559 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -222,7 +222,7 @@ static void requeue_rx_msgs(struct kcm_mux *mux, struct sk_buff_head *head)
 	struct sk_buff *skb;
 	struct kcm_sock *kcm;
 
-	while ((skb = __skb_dequeue(head))) {
+	while ((skb = skb_dequeue(head))) {
 		/* Reset destructor to avoid calling kcm_rcv_ready */
 		skb->destructor = sock_rfree;
 		skb_orphan(skb);
@@ -1085,53 +1085,17 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	return err;
 }
 
-static struct sk_buff *kcm_wait_data(struct sock *sk, int flags,
-				     long timeo, int *err)
-{
-	struct sk_buff *skb;
-
-	while (!(skb = skb_peek(&sk->sk_receive_queue))) {
-		if (sk->sk_err) {
-			*err = sock_error(sk);
-			return NULL;
-		}
-
-		if (sock_flag(sk, SOCK_DONE))
-			return NULL;
-
-		if ((flags & MSG_DONTWAIT) || !timeo) {
-			*err = -EAGAIN;
-			return NULL;
-		}
-
-		sk_wait_data(sk, &timeo, NULL);
-
-		/* Handle signals */
-		if (signal_pending(current)) {
-			*err = sock_intr_errno(timeo);
-			return NULL;
-		}
-	}
-
-	return skb;
-}
-
 static int kcm_recvmsg(struct socket *sock, struct msghdr *msg,
 		       size_t len, int flags)
 {
 	struct sock *sk = sock->sk;
 	struct kcm_sock *kcm = kcm_sk(sk);
 	int err = 0;
-	long timeo;
 	struct strp_msg *stm;
 	int copied = 0;
 	struct sk_buff *skb;
 
-	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
-
-	lock_sock(sk);
-
-	skb = kcm_wait_data(sk, flags, timeo, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
@@ -1162,14 +1126,11 @@ static int kcm_recvmsg(struct socket *sock, struct msghdr *msg,
 			/* Finished with message */
 			msg->msg_flags |= MSG_EOR;
 			KCM_STATS_INCR(kcm->stats.rx_msgs);
-			skb_unlink(skb, &sk->sk_receive_queue);
-			kfree_skb(skb);
 		}
 	}
 
 out:
-	release_sock(sk);
-
+	skb_free_datagram(sk, skb);
 	return copied ? : err;
 }
 
@@ -1179,7 +1140,6 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
 {
 	struct sock *sk = sock->sk;
 	struct kcm_sock *kcm = kcm_sk(sk);
-	long timeo;
 	struct strp_msg *stm;
 	int err = 0;
 	ssize_t copied;
@@ -1187,11 +1147,7 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
 
 	/* Only support splice for SOCKSEQPACKET */
 
-	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
-
-	lock_sock(sk);
-
-	skb = kcm_wait_data(sk, flags, timeo, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto err_out;
 
@@ -1219,13 +1175,11 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
 	 * finish reading the message.
 	 */
 
-	release_sock(sk);
-
+	skb_free_datagram(sk, skb);
 	return copied;
 
 err_out:
-	release_sock(sk);
-
+	skb_free_datagram(sk, skb);
 	return err;
 }
 
@@ -1845,10 +1799,10 @@ static int kcm_release(struct socket *sock)
 	kcm = kcm_sk(sk);
 	mux = kcm->mux;
 
+	lock_sock(sk);
 	sock_orphan(sk);
 	kfree_skb(kcm->seq_skb);
 
-	lock_sock(sk);
 	/* Purge queue under lock to avoid race condition with tx_work trying
 	 * to act when queue is nonempty. If tx_work runs after this point
 	 * it will just return.
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 16ae92054baa..6b31746f9be3 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1719,11 +1719,13 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 		skb2 = nlmsg_new(payload, GFP_KERNEL);
 		if (!skb2)
 			return -ENOMEM;
-		rep = __nlmsg_put(skb2, NETLINK_CB(skb).portid,
-				  nlh->nlmsg_seq, NLMSG_ERROR, payload, 0);
+		rep = nlmsg_put(skb2, NETLINK_CB(skb).portid,
+				nlh->nlmsg_seq, NLMSG_ERROR, payload, 0);
 		errmsg = nlmsg_data(rep);
 		errmsg->error = ret;
-		memcpy(&errmsg->msg, nlh, nlh->nlmsg_len);
+		unsafe_memcpy(&errmsg->msg, nlh, nlh->nlmsg_len,
+			      /* Bounds checked by the skb layer. */);
+
 		cmdattr = (void *)&errmsg->msg + min_len;
 
 		ret = nla_parse(cda, IPSET_ATTR_CMD_MAX, cmdattr,
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 0cd91f813a3b..d8d3ed2096a3 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2440,11 +2440,13 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 		return;
 	}
 
-	rep = __nlmsg_put(skb, NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
-			  NLMSG_ERROR, payload, flags);
+	rep = nlmsg_put(skb, NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
+			NLMSG_ERROR, payload, flags);
 	errmsg = nlmsg_data(rep);
 	errmsg->error = err;
-	memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg) ? nlh->nlmsg_len : sizeof(*nlh));
+	unsafe_memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg)
+					 ? nlh->nlmsg_len : sizeof(*nlh),
+		      /* Bounds checked by the skb layer. */);
 
 	if (nlk_has_extack && extack) {
 		if (extack->_msg) {
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index e213aaf45d67..20831079fb09 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -384,6 +384,7 @@ static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
 {
 	struct sctp_outq *q = &asoc->outqueue;
 	struct sctp_chunk *chk, *temp;
+	struct sctp_stream_out *sout;
 
 	q->sched->unsched_all(&asoc->stream);
 
@@ -398,12 +399,14 @@ static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
 		sctp_sched_dequeue_common(q, chk);
 		asoc->sent_cnt_removable--;
 		asoc->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
-		if (chk->sinfo.sinfo_stream < asoc->stream.outcnt) {
-			struct sctp_stream_out *streamout =
-				SCTP_SO(&asoc->stream, chk->sinfo.sinfo_stream);
 
-			streamout->ext->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
-		}
+		sout = SCTP_SO(&asoc->stream, chk->sinfo.sinfo_stream);
+		sout->ext->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
+
+		/* clear out_curr if all frag chunks are pruned */
+		if (asoc->stream.out_curr == sout &&
+		    list_is_last(&chk->frag_list, &chk->msg->chunks))
+			asoc->stream.out_curr = NULL;
 
 		msg_len -= chk->skb->truesize + sizeof(struct sctp_chunk);
 		sctp_chunk_free(chk);
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index a31a27816cc0..7bb247c51e2f 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -1989,7 +1989,7 @@ gss_unwrap_resp_integ(struct rpc_task *task, struct rpc_cred *cred,
 		goto unwrap_failed;
 	mic.len = len;
 	mic.data = kmalloc(len, GFP_KERNEL);
-	if (!mic.data)
+	if (ZERO_OR_NULL_PTR(mic.data))
 		goto unwrap_failed;
 	if (read_bytes_from_xdr_buf(rcv_buf, offset, mic.data, mic.len))
 		goto unwrap_failed;
diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index 76a80a41615b..fe8765c4075d 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -468,6 +468,7 @@ void wireless_send_event(struct net_device *	dev,
 	struct __compat_iw_event *compat_event;
 	struct compat_iw_point compat_wrqu;
 	struct sk_buff *compskb;
+	int ptr_len;
 #endif
 
 	/*
@@ -582,6 +583,9 @@ void wireless_send_event(struct net_device *	dev,
 	nlmsg_end(skb, nlh);
 #ifdef CONFIG_COMPAT
 	hdr_len = compat_event_type_size[descr->header_type];
+
+	/* ptr_len is remaining size in event header apart from LCP */
+	ptr_len = hdr_len - IW_EV_COMPAT_LCP_LEN;
 	event_len = hdr_len + extra_len;
 
 	compskb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
@@ -612,16 +616,15 @@ void wireless_send_event(struct net_device *	dev,
 	if (descr->header_type == IW_HEADER_TYPE_POINT) {
 		compat_wrqu.length = wrqu->data.length;
 		compat_wrqu.flags = wrqu->data.flags;
-		memcpy(&compat_event->pointer,
-			((char *) &compat_wrqu) + IW_EV_COMPAT_POINT_OFF,
-			hdr_len - IW_EV_COMPAT_LCP_LEN);
+		memcpy(compat_event->ptr_bytes,
+		       ((char *)&compat_wrqu) + IW_EV_COMPAT_POINT_OFF,
+			ptr_len);
 		if (extra_len)
-			memcpy(((char *) compat_event) + hdr_len,
-				extra, extra_len);
+			memcpy(&compat_event->ptr_bytes[ptr_len],
+			       extra, extra_len);
 	} else {
 		/* extra_len must be zero, so no if (extra) needed */
-		memcpy(&compat_event->pointer, wrqu,
-			hdr_len - IW_EV_COMPAT_LCP_LEN);
+		memcpy(compat_event->ptr_bytes, wrqu, ptr_len);
 	}
 
 	nlmsg_end(compskb, nlh);
diff --git a/net/x25/x25_dev.c b/net/x25/x25_dev.c
index 5259ef8f5242..748d8630ab58 100644
--- a/net/x25/x25_dev.c
+++ b/net/x25/x25_dev.c
@@ -117,7 +117,7 @@ int x25_lapb_receive_frame(struct sk_buff *skb, struct net_device *dev,
 
 	if (!pskb_may_pull(skb, 1)) {
 		x25_neigh_put(nb);
-		return 0;
+		goto drop;
 	}
 
 	switch (skb->data[0]) {
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index b7cccbef401c..bf58e98c7a69 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9446,6 +9446,8 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc176, "Samsung Notebook 9 Pro (NP930MBE-K04US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Flex Book (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc1a3, "Samsung Galaxy Book Pro (NP935XDB-KC1SE)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc1a6, "Samsung Galaxy Book Pro 360 (NP930QBD)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc740, "Samsung Ativ book 8 (NP870Z5G)", ALC269_FIXUP_ATIV_BOOK_8),
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),
diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 2cb50d5cf1a9..6c0f1de10429 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -45,6 +45,27 @@ static struct snd_soc_card acp6x_card = {
 };
 
 static const struct dmi_system_id yc_acp_quirk_table[] = {
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21D0"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21D0"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21D1"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
diff --git a/sound/soc/codecs/jz4725b.c b/sound/soc/codecs/jz4725b.c
index 5201a8f6d7b6..71ea576f7e67 100644
--- a/sound/soc/codecs/jz4725b.c
+++ b/sound/soc/codecs/jz4725b.c
@@ -136,14 +136,17 @@ enum {
 #define REG_CGR3_GO1L_OFFSET		0
 #define REG_CGR3_GO1L_MASK		(0x1f << REG_CGR3_GO1L_OFFSET)
 
+#define REG_CGR10_GIL_OFFSET		0
+#define REG_CGR10_GIR_OFFSET		4
+
 struct jz_icdc {
 	struct regmap *regmap;
 	void __iomem *base;
 	struct clk *clk;
 };
 
-static const SNDRV_CTL_TLVD_DECLARE_DB_LINEAR(jz4725b_dac_tlv, -2250, 0);
-static const SNDRV_CTL_TLVD_DECLARE_DB_LINEAR(jz4725b_line_tlv, -1500, 600);
+static const SNDRV_CTL_TLVD_DECLARE_DB_SCALE(jz4725b_adc_tlv,     0, 150, 0);
+static const SNDRV_CTL_TLVD_DECLARE_DB_SCALE(jz4725b_dac_tlv, -2250, 150, 0);
 
 static const struct snd_kcontrol_new jz4725b_codec_controls[] = {
 	SOC_DOUBLE_TLV("Master Playback Volume",
@@ -151,11 +154,11 @@ static const struct snd_kcontrol_new jz4725b_codec_controls[] = {
 		       REG_CGR1_GODL_OFFSET,
 		       REG_CGR1_GODR_OFFSET,
 		       0xf, 1, jz4725b_dac_tlv),
-	SOC_DOUBLE_R_TLV("Master Capture Volume",
-			 JZ4725B_CODEC_REG_CGR3,
-			 JZ4725B_CODEC_REG_CGR2,
-			 REG_CGR2_GO1R_OFFSET,
-			 0x1f, 1, jz4725b_line_tlv),
+	SOC_DOUBLE_TLV("Master Capture Volume",
+		       JZ4725B_CODEC_REG_CGR10,
+		       REG_CGR10_GIL_OFFSET,
+		       REG_CGR10_GIR_OFFSET,
+		       0xf, 0, jz4725b_adc_tlv),
 
 	SOC_SINGLE("Master Playback Switch", JZ4725B_CODEC_REG_CR1,
 		   REG_CR1_DAC_MUTE_OFFSET, 1, 1),
@@ -180,7 +183,7 @@ static SOC_VALUE_ENUM_SINGLE_DECL(jz4725b_codec_adc_src_enum,
 				  jz4725b_codec_adc_src_texts,
 				  jz4725b_codec_adc_src_values);
 static const struct snd_kcontrol_new jz4725b_codec_adc_src_ctrl =
-			SOC_DAPM_ENUM("Route", jz4725b_codec_adc_src_enum);
+	SOC_DAPM_ENUM("ADC Source Capture Route", jz4725b_codec_adc_src_enum);
 
 static const struct snd_kcontrol_new jz4725b_codec_mixer_controls[] = {
 	SOC_DAPM_SINGLE("Line In Bypass", JZ4725B_CODEC_REG_CR1,
@@ -225,7 +228,7 @@ static const struct snd_soc_dapm_widget jz4725b_codec_dapm_widgets[] = {
 	SND_SOC_DAPM_ADC("ADC", "Capture",
 			 JZ4725B_CODEC_REG_PMR1, REG_PMR1_SB_ADC_OFFSET, 1),
 
-	SND_SOC_DAPM_MUX("ADC Source", SND_SOC_NOPM, 0, 0,
+	SND_SOC_DAPM_MUX("ADC Source Capture Route", SND_SOC_NOPM, 0, 0,
 			 &jz4725b_codec_adc_src_ctrl),
 
 	/* Mixer */
@@ -236,7 +239,8 @@ static const struct snd_soc_dapm_widget jz4725b_codec_dapm_widgets[] = {
 	SND_SOC_DAPM_MIXER("DAC to Mixer", JZ4725B_CODEC_REG_CR1,
 			   REG_CR1_DACSEL_OFFSET, 0, NULL, 0),
 
-	SND_SOC_DAPM_MIXER("Line In", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_MIXER("Line In", JZ4725B_CODEC_REG_PMR1,
+			   REG_PMR1_SB_LIN_OFFSET, 1, NULL, 0),
 	SND_SOC_DAPM_MIXER("HP Out", JZ4725B_CODEC_REG_CR1,
 			   REG_CR1_HP_DIS_OFFSET, 1, NULL, 0),
 
@@ -283,11 +287,11 @@ static const struct snd_soc_dapm_route jz4725b_codec_dapm_routes[] = {
 	{"Mixer", NULL, "DAC to Mixer"},
 
 	{"Mixer to ADC", NULL, "Mixer"},
-	{"ADC Source", "Mixer", "Mixer to ADC"},
-	{"ADC Source", "Line In", "Line In"},
-	{"ADC Source", "Mic 1", "Mic 1"},
-	{"ADC Source", "Mic 2", "Mic 2"},
-	{"ADC", NULL, "ADC Source"},
+	{"ADC Source Capture Route", "Mixer", "Mixer to ADC"},
+	{"ADC Source Capture Route", "Line In", "Line In"},
+	{"ADC Source Capture Route", "Mic 1", "Mic 1"},
+	{"ADC Source Capture Route", "Mic 2", "Mic 2"},
+	{"ADC", NULL, "ADC Source Capture Route"},
 
 	{"Out Stage", NULL, "Mixer"},
 	{"HP Out", NULL, "Out Stage"},
diff --git a/sound/soc/codecs/mt6660.c b/sound/soc/codecs/mt6660.c
index 45e0df13afb9..b8369eeccc30 100644
--- a/sound/soc/codecs/mt6660.c
+++ b/sound/soc/codecs/mt6660.c
@@ -503,14 +503,14 @@ static int mt6660_i2c_probe(struct i2c_client *client)
 		dev_err(chip->dev, "read chip revision fail\n");
 		goto probe_fail;
 	}
+	pm_runtime_set_active(chip->dev);
+	pm_runtime_enable(chip->dev);
 
 	ret = devm_snd_soc_register_component(chip->dev,
 					       &mt6660_component_driver,
 					       &mt6660_codec_dai, 1);
-	if (!ret) {
-		pm_runtime_set_active(chip->dev);
-		pm_runtime_enable(chip->dev);
-	}
+	if (ret)
+		pm_runtime_disable(chip->dev);
 
 	return ret;
 
diff --git a/sound/soc/codecs/rt1019.c b/sound/soc/codecs/rt1019.c
index b66bfecbb879..49f527c61a7a 100644
--- a/sound/soc/codecs/rt1019.c
+++ b/sound/soc/codecs/rt1019.c
@@ -391,18 +391,18 @@ static int rt1019_set_tdm_slot(struct snd_soc_dai *dai, unsigned int tx_mask,
 			unsigned int rx_mask, int slots, int slot_width)
 {
 	struct snd_soc_component *component = dai->component;
-	unsigned int val = 0, rx_slotnum;
+	unsigned int cn = 0, cl = 0, rx_slotnum;
 	int ret = 0, first_bit;
 
 	switch (slots) {
 	case 4:
-		val |= RT1019_I2S_TX_4CH;
+		cn = RT1019_I2S_TX_4CH;
 		break;
 	case 6:
-		val |= RT1019_I2S_TX_6CH;
+		cn = RT1019_I2S_TX_6CH;
 		break;
 	case 8:
-		val |= RT1019_I2S_TX_8CH;
+		cn = RT1019_I2S_TX_8CH;
 		break;
 	case 2:
 		break;
@@ -412,16 +412,16 @@ static int rt1019_set_tdm_slot(struct snd_soc_dai *dai, unsigned int tx_mask,
 
 	switch (slot_width) {
 	case 20:
-		val |= RT1019_I2S_DL_20;
+		cl = RT1019_TDM_CL_20;
 		break;
 	case 24:
-		val |= RT1019_I2S_DL_24;
+		cl = RT1019_TDM_CL_24;
 		break;
 	case 32:
-		val |= RT1019_I2S_DL_32;
+		cl = RT1019_TDM_CL_32;
 		break;
 	case 8:
-		val |= RT1019_I2S_DL_8;
+		cl = RT1019_TDM_CL_8;
 		break;
 	case 16:
 		break;
@@ -470,8 +470,10 @@ static int rt1019_set_tdm_slot(struct snd_soc_dai *dai, unsigned int tx_mask,
 		goto _set_tdm_err_;
 	}
 
+	snd_soc_component_update_bits(component, RT1019_TDM_1,
+		RT1019_TDM_CL_MASK, cl);
 	snd_soc_component_update_bits(component, RT1019_TDM_2,
-		RT1019_I2S_CH_TX_MASK | RT1019_I2S_DF_MASK, val);
+		RT1019_I2S_CH_TX_MASK, cn);
 
 _set_tdm_err_:
 	return ret;
diff --git a/sound/soc/codecs/rt1019.h b/sound/soc/codecs/rt1019.h
index 64df831eeb72..48ba15efb48d 100644
--- a/sound/soc/codecs/rt1019.h
+++ b/sound/soc/codecs/rt1019.h
@@ -95,6 +95,12 @@
 #define RT1019_TDM_BCLK_MASK		(0x1 << 6)
 #define RT1019_TDM_BCLK_NORM		(0x0 << 6)
 #define RT1019_TDM_BCLK_INV			(0x1 << 6)
+#define RT1019_TDM_CL_MASK			(0x7)
+#define RT1019_TDM_CL_8				(0x4)
+#define RT1019_TDM_CL_32			(0x3)
+#define RT1019_TDM_CL_24			(0x2)
+#define RT1019_TDM_CL_20			(0x1)
+#define RT1019_TDM_CL_16			(0x0)
 
 /* 0x0401 TDM Control-2 */
 #define RT1019_I2S_CH_TX_MASK		(0x3 << 6)
diff --git a/sound/soc/codecs/rt1308-sdw.h b/sound/soc/codecs/rt1308-sdw.h
index 6668e19d85d4..b5f231f708cb 100644
--- a/sound/soc/codecs/rt1308-sdw.h
+++ b/sound/soc/codecs/rt1308-sdw.h
@@ -139,10 +139,12 @@ static const struct reg_default rt1308_reg_defaults[] = {
 	{ 0x3005, 0x23 },
 	{ 0x3008, 0x02 },
 	{ 0x300a, 0x00 },
+	{ 0xc000 | (RT1308_DATA_PATH << 4), 0x00 },
 	{ 0xc003 | (RT1308_DAC_SET << 4), 0x00 },
 	{ 0xc000 | (RT1308_POWER << 4), 0x00 },
 	{ 0xc001 | (RT1308_POWER << 4), 0x00 },
 	{ 0xc002 | (RT1308_POWER << 4), 0x00 },
+	{ 0xc000 | (RT1308_POWER_STATUS << 4), 0x00 },
 };
 
 #define RT1308_SDW_OFFSET 0xc000
diff --git a/sound/soc/codecs/rt5514-spi.c b/sound/soc/codecs/rt5514-spi.c
index 1a25a3787935..362663abcb89 100644
--- a/sound/soc/codecs/rt5514-spi.c
+++ b/sound/soc/codecs/rt5514-spi.c
@@ -298,13 +298,14 @@ static int rt5514_spi_pcm_new(struct snd_soc_component *component,
 }
 
 static const struct snd_soc_component_driver rt5514_spi_component = {
-	.name		= DRV_NAME,
-	.probe		= rt5514_spi_pcm_probe,
-	.open		= rt5514_spi_pcm_open,
-	.hw_params	= rt5514_spi_hw_params,
-	.hw_free	= rt5514_spi_hw_free,
-	.pointer	= rt5514_spi_pcm_pointer,
-	.pcm_construct	= rt5514_spi_pcm_new,
+	.name			= DRV_NAME,
+	.probe			= rt5514_spi_pcm_probe,
+	.open			= rt5514_spi_pcm_open,
+	.hw_params		= rt5514_spi_hw_params,
+	.hw_free		= rt5514_spi_hw_free,
+	.pointer		= rt5514_spi_pcm_pointer,
+	.pcm_construct		= rt5514_spi_pcm_new,
+	.legacy_dai_naming	= 1,
 };
 
 /**
diff --git a/sound/soc/codecs/rt5677-spi.c b/sound/soc/codecs/rt5677-spi.c
index 8f3993a4c1cc..d25703dd7499 100644
--- a/sound/soc/codecs/rt5677-spi.c
+++ b/sound/soc/codecs/rt5677-spi.c
@@ -396,15 +396,16 @@ static int rt5677_spi_pcm_probe(struct snd_soc_component *component)
 }
 
 static const struct snd_soc_component_driver rt5677_spi_dai_component = {
-	.name		= DRV_NAME,
-	.probe		= rt5677_spi_pcm_probe,
-	.open		= rt5677_spi_pcm_open,
-	.close		= rt5677_spi_pcm_close,
-	.hw_params	= rt5677_spi_hw_params,
-	.hw_free	= rt5677_spi_hw_free,
-	.prepare	= rt5677_spi_prepare,
-	.pointer	= rt5677_spi_pcm_pointer,
-	.pcm_construct	= rt5677_spi_pcm_new,
+	.name			= DRV_NAME,
+	.probe			= rt5677_spi_pcm_probe,
+	.open			= rt5677_spi_pcm_open,
+	.close			= rt5677_spi_pcm_close,
+	.hw_params		= rt5677_spi_hw_params,
+	.hw_free		= rt5677_spi_hw_free,
+	.prepare		= rt5677_spi_prepare,
+	.pointer		= rt5677_spi_pcm_pointer,
+	.pcm_construct		= rt5677_spi_pcm_new,
+	.legacy_dai_naming	= 1,
 };
 
 /* Select a suitable transfer command for the next transfer to ensure
diff --git a/sound/soc/codecs/rt5682s.c b/sound/soc/codecs/rt5682s.c
index eb47e7cd485a..95fe993d59cb 100644
--- a/sound/soc/codecs/rt5682s.c
+++ b/sound/soc/codecs/rt5682s.c
@@ -1932,7 +1932,7 @@ static int rt5682s_set_tdm_slot(struct snd_soc_dai *dai, unsigned int tx_mask,
 		unsigned int rx_mask, int slots, int slot_width)
 {
 	struct snd_soc_component *component = dai->component;
-	unsigned int cl, val = 0;
+	unsigned int cl, val = 0, tx_slotnum;
 
 	if (tx_mask || rx_mask)
 		snd_soc_component_update_bits(component,
@@ -1941,6 +1941,16 @@ static int rt5682s_set_tdm_slot(struct snd_soc_dai *dai, unsigned int tx_mask,
 		snd_soc_component_update_bits(component,
 			RT5682S_TDM_ADDA_CTRL_2, RT5682S_TDM_EN, 0);
 
+	/* Tx slot configuration */
+	tx_slotnum = hweight_long(tx_mask);
+	if (tx_slotnum) {
+		if (tx_slotnum > slots) {
+			dev_err(component->dev, "Invalid or oversized Tx slots.\n");
+			return -EINVAL;
+		}
+		val |= (tx_slotnum - 1) << RT5682S_TDM_ADC_DL_SFT;
+	}
+
 	switch (slots) {
 	case 4:
 		val |= RT5682S_TDM_TX_CH_4;
@@ -1961,7 +1971,8 @@ static int rt5682s_set_tdm_slot(struct snd_soc_dai *dai, unsigned int tx_mask,
 	}
 
 	snd_soc_component_update_bits(component, RT5682S_TDM_CTRL,
-		RT5682S_TDM_TX_CH_MASK | RT5682S_TDM_RX_CH_MASK, val);
+		RT5682S_TDM_TX_CH_MASK | RT5682S_TDM_RX_CH_MASK |
+		RT5682S_TDM_ADC_DL_MASK, val);
 
 	switch (slot_width) {
 	case 8:
diff --git a/sound/soc/codecs/rt5682s.h b/sound/soc/codecs/rt5682s.h
index 7353831c73dd..b660a311b6c2 100644
--- a/sound/soc/codecs/rt5682s.h
+++ b/sound/soc/codecs/rt5682s.h
@@ -899,6 +899,7 @@
 #define RT5682S_TDM_RX_CH_8			(0x3 << 8)
 #define RT5682S_TDM_ADC_LCA_MASK		(0x7 << 4)
 #define RT5682S_TDM_ADC_LCA_SFT			4
+#define RT5682S_TDM_ADC_DL_MASK			(0x3 << 0)
 #define RT5682S_TDM_ADC_DL_SFT			0
 
 /* TDM control 2 (0x007a) */
diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index 39902f77a2e0..6c87c3cf5ef7 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -386,20 +386,13 @@ static int tas2764_set_dai_tdm_slot(struct snd_soc_dai *dai,
 	if (tx_mask == 0 || rx_mask != 0)
 		return -EINVAL;
 
-	if (slots == 1) {
-		if (tx_mask != 1)
-			return -EINVAL;
-		left_slot = 0;
-		right_slot = 0;
+	left_slot = __ffs(tx_mask);
+	tx_mask &= ~(1 << left_slot);
+	if (tx_mask == 0) {
+		right_slot = left_slot;
 	} else {
-		left_slot = __ffs(tx_mask);
-		tx_mask &= ~(1 << left_slot);
-		if (tx_mask == 0) {
-			right_slot = left_slot;
-		} else {
-			right_slot = __ffs(tx_mask);
-			tx_mask &= ~(1 << right_slot);
-		}
+		right_slot = __ffs(tx_mask);
+		tx_mask &= ~(1 << right_slot);
 	}
 
 	if (tx_mask != 0 || left_slot >= slots || right_slot >= slots)
diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index b6765235a4b3..8557759acb1f 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -395,21 +395,13 @@ static int tas2770_set_dai_tdm_slot(struct snd_soc_dai *dai,
 	if (tx_mask == 0 || rx_mask != 0)
 		return -EINVAL;
 
-	if (slots == 1) {
-		if (tx_mask != 1)
-			return -EINVAL;
-
-		left_slot = 0;
-		right_slot = 0;
+	left_slot = __ffs(tx_mask);
+	tx_mask &= ~(1 << left_slot);
+	if (tx_mask == 0) {
+		right_slot = left_slot;
 	} else {
-		left_slot = __ffs(tx_mask);
-		tx_mask &= ~(1 << left_slot);
-		if (tx_mask == 0) {
-			right_slot = left_slot;
-		} else {
-			right_slot = __ffs(tx_mask);
-			tx_mask &= ~(1 << right_slot);
-		}
+		right_slot = __ffs(tx_mask);
+		tx_mask &= ~(1 << right_slot);
 	}
 
 	if (tx_mask != 0 || left_slot >= slots || right_slot >= slots)
diff --git a/sound/soc/codecs/tas2780.c b/sound/soc/codecs/tas2780.c
index a6db6f0e5431..afdf0c863aa1 100644
--- a/sound/soc/codecs/tas2780.c
+++ b/sound/soc/codecs/tas2780.c
@@ -380,20 +380,13 @@ static int tas2780_set_dai_tdm_slot(struct snd_soc_dai *dai,
 	if (tx_mask == 0 || rx_mask != 0)
 		return -EINVAL;
 
-	if (slots == 1) {
-		if (tx_mask != 1)
-			return -EINVAL;
-		left_slot = 0;
-		right_slot = 0;
+	left_slot = __ffs(tx_mask);
+	tx_mask &= ~(1 << left_slot);
+	if (tx_mask == 0) {
+		right_slot = left_slot;
 	} else {
-		left_slot = __ffs(tx_mask);
-		tx_mask &= ~(1 << left_slot);
-		if (tx_mask == 0) {
-			right_slot = left_slot;
-		} else {
-			right_slot = __ffs(tx_mask);
-			tx_mask &= ~(1 << right_slot);
-		}
+		right_slot = __ffs(tx_mask);
+		tx_mask &= ~(1 << right_slot);
 	}
 
 	if (tx_mask != 0 || left_slot >= slots || right_slot >= slots)
diff --git a/sound/soc/codecs/wm5102.c b/sound/soc/codecs/wm5102.c
index c09c9ac51b3e..af7d324e3352 100644
--- a/sound/soc/codecs/wm5102.c
+++ b/sound/soc/codecs/wm5102.c
@@ -2099,6 +2099,9 @@ static int wm5102_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm5102_digital_vu[i],
 				   WM5102_DIG_VU, WM5102_DIG_VU);
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	ret = arizona_request_irq(arizona, ARIZONA_IRQ_DSP_IRQ1,
 				  "ADSP2 Compressed IRQ", wm5102_adsp2_irq,
 				  wm5102);
@@ -2131,9 +2134,6 @@ static int wm5102_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	return ret;
 
 err_spk_irqs:
diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index fc634c995834..f3f4a10bf0f7 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -2457,6 +2457,9 @@ static int wm5110_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm5110_digital_vu[i],
 				   WM5110_DIG_VU, WM5110_DIG_VU);
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	ret = arizona_request_irq(arizona, ARIZONA_IRQ_DSP_IRQ1,
 				  "ADSP2 Compressed IRQ", wm5110_adsp2_irq,
 				  wm5110);
@@ -2489,9 +2492,6 @@ static int wm5110_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	return ret;
 
 err_spk_irqs:
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 398c448ea854..6df06fba4377 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -1840,6 +1840,49 @@ SOC_SINGLE_TLV("SPKOUTR Mixer DACR Volume", WM8962_SPEAKER_MIXER_5,
 	       4, 1, 0, inmix_tlv),
 };
 
+static int tp_event(struct snd_soc_dapm_widget *w,
+		    struct snd_kcontrol *kcontrol, int event)
+{
+	int ret, reg, val, mask;
+	struct snd_soc_component *component = snd_soc_dapm_to_component(w->dapm);
+
+	ret = pm_runtime_resume_and_get(component->dev);
+	if (ret < 0) {
+		dev_err(component->dev, "Failed to resume device: %d\n", ret);
+		return ret;
+	}
+
+	reg = WM8962_ADDITIONAL_CONTROL_4;
+
+	if (!strcmp(w->name, "TEMP_HP")) {
+		mask = WM8962_TEMP_ENA_HP_MASK;
+		val = WM8962_TEMP_ENA_HP;
+	} else if (!strcmp(w->name, "TEMP_SPK")) {
+		mask = WM8962_TEMP_ENA_SPK_MASK;
+		val = WM8962_TEMP_ENA_SPK;
+	} else {
+		pm_runtime_put(component->dev);
+		return -EINVAL;
+	}
+
+	switch (event) {
+	case SND_SOC_DAPM_POST_PMD:
+		val = 0;
+		fallthrough;
+	case SND_SOC_DAPM_POST_PMU:
+		ret = snd_soc_component_update_bits(component, reg, mask, val);
+		break;
+	default:
+		WARN(1, "Invalid event %d\n", event);
+		pm_runtime_put(component->dev);
+		return -EINVAL;
+	}
+
+	pm_runtime_put(component->dev);
+
+	return 0;
+}
+
 static int cp_event(struct snd_soc_dapm_widget *w,
 		    struct snd_kcontrol *kcontrol, int event)
 {
@@ -2140,8 +2183,10 @@ SND_SOC_DAPM_SUPPLY("TOCLK", WM8962_ADDITIONAL_CONTROL_1, 0, 0, NULL, 0),
 SND_SOC_DAPM_SUPPLY_S("DSP2", 1, WM8962_DSP2_POWER_MANAGEMENT,
 		      WM8962_DSP2_ENA_SHIFT, 0, dsp2_event,
 		      SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD),
-SND_SOC_DAPM_SUPPLY("TEMP_HP", WM8962_ADDITIONAL_CONTROL_4, 2, 0, NULL, 0),
-SND_SOC_DAPM_SUPPLY("TEMP_SPK", WM8962_ADDITIONAL_CONTROL_4, 1, 0, NULL, 0),
+SND_SOC_DAPM_SUPPLY("TEMP_HP", SND_SOC_NOPM, 0, 0, tp_event,
+		SND_SOC_DAPM_POST_PMU|SND_SOC_DAPM_POST_PMD),
+SND_SOC_DAPM_SUPPLY("TEMP_SPK", SND_SOC_NOPM, 0, 0, tp_event,
+		SND_SOC_DAPM_POST_PMU|SND_SOC_DAPM_POST_PMD),
 
 SND_SOC_DAPM_MIXER("INPGAL", WM8962_LEFT_INPUT_PGA_CONTROL, 4, 0,
 		   inpgal, ARRAY_SIZE(inpgal)),
@@ -3763,6 +3808,11 @@ static int wm8962_i2c_probe(struct i2c_client *i2c)
 	if (ret < 0)
 		goto err_pm_runtime;
 
+	regmap_update_bits(wm8962->regmap, WM8962_ADDITIONAL_CONTROL_4,
+			    WM8962_TEMP_ENA_HP_MASK, 0);
+	regmap_update_bits(wm8962->regmap, WM8962_ADDITIONAL_CONTROL_4,
+			    WM8962_TEMP_ENA_SPK_MASK, 0);
+
 	regcache_cache_only(wm8962->regmap, true);
 
 	/* The drivers should power up as needed */
diff --git a/sound/soc/codecs/wm8997.c b/sound/soc/codecs/wm8997.c
index 77136a521605..210ad662fc26 100644
--- a/sound/soc/codecs/wm8997.c
+++ b/sound/soc/codecs/wm8997.c
@@ -1161,6 +1161,9 @@ static int wm8997_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm8997_digital_vu[i],
 				   WM8997_DIG_VU, WM8997_DIG_VU);
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	arizona_init_common(arizona);
 
 	ret = arizona_init_vol_limit(arizona);
@@ -1179,9 +1182,6 @@ static int wm8997_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	return ret;
 
 err_spk_irqs:
diff --git a/sound/soc/fsl/fsl_asrc.c b/sound/soc/fsl/fsl_asrc.c
index aa5edf32d988..d90adb6ee43d 100644
--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -1224,7 +1224,7 @@ static int fsl_asrc_probe(struct platform_device *pdev)
 	}
 
 	ret = pm_runtime_put_sync(&pdev->dev);
-	if (ret < 0)
+	if (ret < 0 && ret != -ENOSYS)
 		goto err_pm_get_sync;
 
 	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_asrc_component,
diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index 5c21fc490fce..17fefd27ec90 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -1069,7 +1069,7 @@ static int fsl_esai_probe(struct platform_device *pdev)
 	regmap_write(esai_priv->regmap, REG_ESAI_RSMB, 0);
 
 	ret = pm_runtime_put_sync(&pdev->dev);
-	if (ret < 0)
+	if (ret < 0 && ret != -ENOSYS)
 		goto err_pm_get_sync;
 
 	/*
diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index d430eece1d6b..887063f9cbea 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -1415,7 +1415,7 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	}
 
 	ret = pm_runtime_put_sync(dev);
-	if (ret < 0)
+	if (ret < 0 && ret != -ENOSYS)
 		goto err_pm_get_sync;
 
 	/*
diff --git a/sound/soc/intel/boards/sof_rt5682.c b/sound/soc/intel/boards/sof_rt5682.c
index 045965312245..30c53dca342e 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -225,6 +225,18 @@ static const struct dmi_system_id sof_rt5682_quirk_table[] = {
 					SOF_RT5682_SSP_AMP(2) |
 					SOF_RT5682_NUM_HDMIDEV(4)),
 	},
+	{
+		.callback = sof_rt5682_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_FAMILY, "Google_Rex"),
+		},
+		.driver_data = (void *)(SOF_RT5682_MCLK_EN |
+					SOF_RT5682_SSP_CODEC(2) |
+					SOF_SPEAKER_AMP_PRESENT |
+					SOF_RT5682_SSP_AMP(0) |
+					SOF_RT5682_NUM_HDMIDEV(4)
+					),
+	},
 	{}
 };
 
diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 2ff30b40a1e4..ee9857dc3135 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -202,6 +202,17 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					SOF_SDW_PCH_DMIC |
 					RT711_JD1),
 	},
+	{
+		/* NUC15 LAPBC710 skews */
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "LAPBC710"),
+		},
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					SOF_SDW_PCH_DMIC |
+					RT711_JD1),
+	},
 	/* TigerLake-SDCA devices */
 	{
 		.callback = sof_sdw_quirk_cb,
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index e824ff1a9fc0..3d057784cbd5 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3472,10 +3472,23 @@ EXPORT_SYMBOL_GPL(snd_soc_of_get_dai_link_cpus);
 
 static int __init snd_soc_init(void)
 {
+	int ret;
+
 	snd_soc_debugfs_init();
-	snd_soc_util_init();
+	ret = snd_soc_util_init();
+	if (ret)
+		goto err_util_init;
 
-	return platform_driver_register(&soc_driver);
+	ret = platform_driver_register(&soc_driver);
+	if (ret)
+		goto err_register;
+	return 0;
+
+err_register:
+	snd_soc_util_exit();
+err_util_init:
+	snd_soc_debugfs_exit();
+	return ret;
 }
 module_init(snd_soc_init);
 
diff --git a/sound/soc/soc-utils.c b/sound/soc/soc-utils.c
index 70c380c0ac7b..d1308904e6e0 100644
--- a/sound/soc/soc-utils.c
+++ b/sound/soc/soc-utils.c
@@ -263,7 +263,7 @@ int __init snd_soc_util_init(void)
 	return ret;
 }
 
-void __exit snd_soc_util_exit(void)
+void snd_soc_util_exit(void)
 {
 	platform_driver_unregister(&soc_dummy_driver);
 	platform_device_unregister(soc_dummy_dev);
diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index 9273a70fec25..e1b7f07de7fc 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -1346,16 +1346,6 @@ static int sof_widget_ready(struct snd_soc_component *scomp, int index,
 		break;
 	}
 
-	if (sof_debug_check_flag(SOF_DBG_DISABLE_MULTICORE)) {
-		swidget->core = SOF_DSP_PRIMARY_CORE;
-	} else {
-		int core = sof_get_token_value(SOF_TKN_COMP_CORE_ID, swidget->tuples,
-					       swidget->num_tuples);
-
-		if (core >= 0)
-			swidget->core = core;
-	}
-
 	/* check token parsing reply */
 	if (ret < 0) {
 		dev_err(scomp->dev,
@@ -1367,6 +1357,16 @@ static int sof_widget_ready(struct snd_soc_component *scomp, int index,
 		return ret;
 	}
 
+	if (sof_debug_check_flag(SOF_DBG_DISABLE_MULTICORE)) {
+		swidget->core = SOF_DSP_PRIMARY_CORE;
+	} else {
+		int core = sof_get_token_value(SOF_TKN_COMP_CORE_ID, swidget->tuples,
+					       swidget->num_tuples);
+
+		if (core >= 0)
+			swidget->core = core;
+	}
+
 	/* bind widget to external event */
 	if (tw->event_type) {
 		if (widget_ops[w->id].bind_event) {
diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index bbff0923d264..2839f6b6f09b 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1133,10 +1133,8 @@ static int snd_usbmidi_output_open(struct snd_rawmidi_substream *substream)
 					port = &umidi->endpoints[i].out->ports[j];
 					break;
 				}
-	if (!port) {
-		snd_BUG();
+	if (!port)
 		return -ENXIO;
-	}
 
 	substream->runtime->private_data = port;
 	port->state = STATE_UNKNOWN;
diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index a072b2d3e726..133e4c73d370 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -695,7 +695,7 @@ static __init int cxl_test_init(void)
 
 		pdev = platform_device_alloc("cxl_switch_uport", i);
 		if (!pdev)
-			goto err_port;
+			goto err_uport;
 		pdev->dev.parent = &root_port->dev;
 
 		rc = platform_device_add(pdev);
@@ -713,7 +713,7 @@ static __init int cxl_test_init(void)
 
 		pdev = platform_device_alloc("cxl_switch_dport", i);
 		if (!pdev)
-			goto err_port;
+			goto err_dport;
 		pdev->dev.parent = &uport->dev;
 
 		rc = platform_device_add(pdev);
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 3561c97701f2..a07b8ae64bf8 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -993,7 +993,7 @@ static inline const char *str_msg(const struct msg *msg, char *buf)
 			msg->subtest_done.have_log);
 		break;
 	case MSG_TEST_LOG:
-		sprintf(buf, "MSG_TEST_LOG (cnt: %ld, last: %d)",
+		sprintf(buf, "MSG_TEST_LOG (cnt: %zu, last: %d)",
 			strlen(msg->test_log.log_buf),
 			msg->test_log.is_last);
 		break;
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index f9d553fbf68a..ce97a9262698 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -1260,7 +1260,7 @@ static int get_xlated_program(int fd_prog, struct bpf_insn **buf, int *cnt)
 
 	bzero(&info, sizeof(info));
 	info.xlated_prog_len = xlated_prog_len;
-	info.xlated_prog_insns = (__u64)*buf;
+	info.xlated_prog_insns = (__u64)(unsigned long)*buf;
 	if (bpf_obj_get_info_by_fd(fd_prog, &info, &info_len)) {
 		perror("second bpf_obj_get_info_by_fd failed");
 		goto out_free_buf;
diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/testing/selftests/futex/functional/Makefile
index 732149011692..5a0e0df8de9b 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -3,11 +3,11 @@ INCLUDES := -I../include -I../../ -I../../../../../usr/include/
 CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE -pthread $(INCLUDES) $(KHDR_INCLUDES)
 LDLIBS := -lpthread -lrt
 
-HEADERS := \
+LOCAL_HDRS := \
 	../include/futextest.h \
 	../include/atomic.h \
 	../include/logging.h
-TEST_GEN_FILES := \
+TEST_GEN_PROGS := \
 	futex_wait_timeout \
 	futex_wait_wouldblock \
 	futex_requeue_pi \
@@ -24,5 +24,3 @@ TEST_PROGS := run.sh
 top_srcdir = ../../../../..
 DEFAULT_INSTALL_HDR_PATH := 1
 include ../../lib.mk
-
-$(TEST_GEN_FILES): $(HEADERS)
diff --git a/tools/testing/selftests/intel_pstate/Makefile b/tools/testing/selftests/intel_pstate/Makefile
index 39f0fa2a8fd6..05d66ef50c97 100644
--- a/tools/testing/selftests/intel_pstate/Makefile
+++ b/tools/testing/selftests/intel_pstate/Makefile
@@ -2,10 +2,10 @@
 CFLAGS := $(CFLAGS) -Wall -D_GNU_SOURCE
 LDLIBS += -lm
 
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+ARCH_PROCESSED := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
 
-ifeq (x86,$(ARCH))
+ifeq (x86,$(ARCH_PROCESSED))
 TEST_GEN_FILES := msr aperf
 endif
 
diff --git a/tools/testing/selftests/kexec/Makefile b/tools/testing/selftests/kexec/Makefile
index 806a150648c3..67fe7a46cb62 100644
--- a/tools/testing/selftests/kexec/Makefile
+++ b/tools/testing/selftests/kexec/Makefile
@@ -1,10 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
 # Makefile for kexec tests
 
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+ARCH_PROCESSED := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
 
-ifeq ($(ARCH),$(filter $(ARCH),x86 ppc64le))
+ifeq ($(ARCH_PROCESSED),$(filter $(ARCH_PROCESSED),x86 ppc64le))
 TEST_PROGS := test_kexec_load.sh test_kexec_file_load.sh
 TEST_FILES := kexec_common_lib.sh
 
diff --git a/tools/testing/selftests/pidfd/pidfd_wait.c b/tools/testing/selftests/pidfd/pidfd_wait.c
index 070c1c876df1..c3e2a3041f55 100644
--- a/tools/testing/selftests/pidfd/pidfd_wait.c
+++ b/tools/testing/selftests/pidfd/pidfd_wait.c
@@ -95,20 +95,28 @@ TEST(wait_states)
 		.flags = CLONE_PIDFD | CLONE_PARENT_SETTID,
 		.exit_signal = SIGCHLD,
 	};
+	int pfd[2];
 	pid_t pid;
 	siginfo_t info = {
 		.si_signo = 0,
 	};
 
+	ASSERT_EQ(pipe(pfd), 0);
 	pid = sys_clone3(&args);
 	ASSERT_GE(pid, 0);
 
 	if (pid == 0) {
+		char buf[2];
+
+		close(pfd[1]);
 		kill(getpid(), SIGSTOP);
+		ASSERT_EQ(read(pfd[0], buf, 1), 1);
+		close(pfd[0]);
 		kill(getpid(), SIGSTOP);
 		exit(EXIT_SUCCESS);
 	}
 
+	close(pfd[0]);
 	ASSERT_EQ(sys_waitid(P_PIDFD, pidfd, &info, WSTOPPED, NULL), 0);
 	ASSERT_EQ(info.si_signo, SIGCHLD);
 	ASSERT_EQ(info.si_code, CLD_STOPPED);
@@ -117,6 +125,8 @@ TEST(wait_states)
 	ASSERT_EQ(sys_pidfd_send_signal(pidfd, SIGCONT, NULL, 0), 0);
 
 	ASSERT_EQ(sys_waitid(P_PIDFD, pidfd, &info, WCONTINUED, NULL), 0);
+	ASSERT_EQ(write(pfd[1], "C", 1), 1);
+	close(pfd[1]);
 	ASSERT_EQ(info.si_signo, SIGCHLD);
 	ASSERT_EQ(info.si_code, CLD_CONTINUED);
 	ASSERT_EQ(info.si_pid, parent_tid);
