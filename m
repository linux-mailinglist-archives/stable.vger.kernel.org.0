Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD3A593E71
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345184AbiHOUnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347065AbiHOUmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:42:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A317B14EF;
        Mon, 15 Aug 2022 12:07:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1E8D3CE10E7;
        Mon, 15 Aug 2022 19:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EE3C433D6;
        Mon, 15 Aug 2022 19:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590456;
        bh=IlBtRUe7fQ991zsBoGn2EV5UFBHqP9Ucl3aDHFynZMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DFAyQ6dczbPixNRXsL1+s5cV0TwW4YFQj2nKB//+FmQrWGGoHxhwUnmwRCTxZqGMK
         YMVuiaLa2GrqW4XX6T0potui4bSLQvRndQagvgKcCUGNk06EbNlOgIAt9FgMwaDeyL
         rwfwvwKaP4YcYO8A/yNt81Lepc+iU4gG7fuGB268=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0235/1095] ARM: dts: qcom-msm8974-klte: Use &labels
Date:   Mon, 15 Aug 2022 19:53:54 +0200
Message-Id: <20220815180439.496470595@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit 1d59524b9181e17110ae7b809c62a6a66f336fd6 ]

Use &labels to align with the style used in new DTS and apply tiny
style fixes.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
[bjorn: Rebased on top of Krzysztof's fixes]
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220415115633.575010-12-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom-msm8974-samsung-klte.dts    | 1202 ++++++++---------
 arch/arm/boot/dts/qcom-msm8974.dtsi           |    4 +-
 2 files changed, 585 insertions(+), 621 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts b/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
index 60244e0c37ba..3b1ea8c24f57 100644
--- a/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
@@ -13,7 +13,7 @@ / {
 	aliases {
 		serial0 = &blsp1_uart1;
 		mmc0 = &sdhc_1; /* SDC1 eMMC slot */
-		mmc1 = &sdhc_2; /* SDC2 SD card slot */
+		mmc1 = &sdhc_3; /* SDC2 SD card slot */
 	};
 
 	chosen {
@@ -52,197 +52,6 @@ volume-up {
 		};
 	};
 
-	smd {
-		rpm {
-			rpm-requests {
-				pma8084-regulators {
-					compatible = "qcom,rpm-pma8084-regulators";
-					status = "okay";
-
-					pma8084_s1: s1 {
-						regulator-min-microvolt = <675000>;
-						regulator-max-microvolt = <1050000>;
-						regulator-always-on;
-					};
-
-					pma8084_s2: s2 {
-						regulator-min-microvolt = <500000>;
-						regulator-max-microvolt = <1050000>;
-					};
-
-					pma8084_s3: s3 {
-						regulator-min-microvolt = <1300000>;
-						regulator-max-microvolt = <1300000>;
-					};
-
-					pma8084_s4: s4 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-					};
-
-					pma8084_s5: s5 {
-						regulator-min-microvolt = <2150000>;
-						regulator-max-microvolt = <2150000>;
-					};
-
-					pma8084_s6: s6 {
-						regulator-min-microvolt = <1050000>;
-						regulator-max-microvolt = <1050000>;
-					};
-
-					pma8084_l1: l1 {
-						regulator-min-microvolt = <1225000>;
-						regulator-max-microvolt = <1225000>;
-					};
-
-					pma8084_l2: l2 {
-						regulator-min-microvolt = <1200000>;
-						regulator-max-microvolt = <1200000>;
-					};
-
-					pma8084_l3: l3 {
-						regulator-min-microvolt = <1050000>;
-						regulator-max-microvolt = <1200000>;
-					};
-
-					pma8084_l4: l4 {
-						regulator-min-microvolt = <1200000>;
-						regulator-max-microvolt = <1225000>;
-					};
-
-					pma8084_l5: l5 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-					};
-
-					pma8084_l6: l6 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-					};
-
-					pma8084_l7: l7 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-					};
-
-					pma8084_l8: l8 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-					};
-
-					pma8084_l9: l9 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <2950000>;
-					};
-
-					pma8084_l10: l10 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <2950000>;
-					};
-
-					pma8084_l11: l11 {
-						regulator-min-microvolt = <1300000>;
-						regulator-max-microvolt = <1300000>;
-					};
-
-					pma8084_l12: l12 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-						regulator-always-on;
-					};
-
-					pma8084_l13: l13 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <2950000>;
-					};
-
-					pma8084_l14: l14 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-					};
-
-					pma8084_l15: l15 {
-						regulator-min-microvolt = <2050000>;
-						regulator-max-microvolt = <2050000>;
-					};
-
-					pma8084_l16: l16 {
-						regulator-min-microvolt = <2700000>;
-						regulator-max-microvolt = <2700000>;
-					};
-
-					pma8084_l17: l17 {
-						regulator-min-microvolt = <2850000>;
-						regulator-max-microvolt = <2850000>;
-					};
-
-					pma8084_l18: l18 {
-						regulator-min-microvolt = <2850000>;
-						regulator-max-microvolt = <2850000>;
-					};
-
-					pma8084_l19: l19 {
-						regulator-min-microvolt = <3300000>;
-						regulator-max-microvolt = <3300000>;
-					};
-
-					pma8084_l20: l20 {
-						regulator-min-microvolt = <2950000>;
-						regulator-max-microvolt = <2950000>;
-
-						regulator-allow-set-load;
-						regulator-system-load = <200000>;
-					};
-
-					pma8084_l21: l21 {
-						regulator-min-microvolt = <2950000>;
-						regulator-max-microvolt = <2950000>;
-
-						regulator-allow-set-load;
-						regulator-system-load = <200000>;
-					};
-
-					pma8084_l22: l22 {
-						regulator-min-microvolt = <3000000>;
-						regulator-max-microvolt = <3300000>;
-					};
-
-					pma8084_l23: l23 {
-						regulator-min-microvolt = <3000000>;
-						regulator-max-microvolt = <3000000>;
-					};
-
-					pma8084_l24: l24 {
-						regulator-min-microvolt = <3075000>;
-						regulator-max-microvolt = <3075000>;
-					};
-
-					pma8084_l25: l25 {
-						regulator-min-microvolt = <2100000>;
-						regulator-max-microvolt = <2100000>;
-					};
-
-					pma8084_l26: l26 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <2050000>;
-					};
-
-					pma8084_l27: l27 {
-						regulator-min-microvolt = <1000000>;
-						regulator-max-microvolt = <1225000>;
-					};
-
-					pma8084_lvs1: lvs1 {};
-					pma8084_lvs2: lvs2 {};
-					pma8084_lvs3: lvs3 {};
-					pma8084_lvs4: lvs4 {};
-
-					pma8084_5vs1: 5vs1 {};
-				};
-			};
-		};
-	};
-
 	i2c-gpio-touchkey {
 		compatible = "i2c-gpio";
 		#address-cells = <1>;
@@ -347,562 +156,717 @@ vreg_panel: panel-regulator {
 	};
 
 	/delete-node/ vreg-boost;
-
-	adsp-pil {
-		cx-supply = <&pma8084_s2>;
-	};
 };
 
-&soc {
-	serial@f991e000 {
-		status = "okay";
-	};
+&blsp1_i2c2 {
+	status = "okay";
 
-	/* blsp2_uart2 */
-	serial@f995e000 {
-		status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c2_pins>;
 
-		pinctrl-names = "default", "sleep";
-		pinctrl-0 = <&blsp2_uart2_pins_active>;
-		pinctrl-1 = <&blsp2_uart2_pins_sleep>;
+	touchscreen@20 {
+		compatible = "syna,rmi4-i2c";
+		reg = <0x20>;
 
-		bluetooth {
-			compatible = "brcm,bcm43540-bt";
-			max-speed = <3000000>;
-			pinctrl-names = "default";
-			pinctrl-0 = <&bt_pins>;
-			device-wakeup-gpios = <&tlmm 91 GPIO_ACTIVE_HIGH>;
-			shutdown-gpios = <&gpio_expander 9 GPIO_ACTIVE_HIGH>;
-			interrupt-parent = <&tlmm>;
-			interrupts = <75 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "host-wakeup";
-		};
-	};
+		interrupt-parent = <&pma8084_gpios>;
+		interrupts = <8 IRQ_TYPE_EDGE_FALLING>;
 
-	pinctrl@fd510000 {
-		blsp2_uart2_pins_active: blsp2-uart2-pins-active {
-			pins = "gpio45", "gpio46", "gpio47", "gpio48";
-			function = "blsp_uart8";
-			drive-strength = <8>;
-			bias-disable;
+		vdd-supply = <&max77826_ldo13>;
+		vio-supply = <&pma8084_lvs2>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&touch_pin>;
+
+		syna,startup-delay-ms = <100>;
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		rmi4-f01@1 {
+			reg = <0x1>;
+			syna,nosleep-mode = <1>;
 		};
 
-		blsp2_uart2_pins_sleep: blsp2-uart2-pins-sleep {
-			pins = "gpio45", "gpio46", "gpio47", "gpio48";
-			function = "gpio";
-			drive-strength = <2>;
-			bias-pull-down;
+		rmi4-f12@12 {
+			reg = <0x12>;
+			syna,sensor-type = <1>;
 		};
+	};
+};
+
+&blsp1_i2c6 {
+	status = "okay";
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c6_pins>;
 
-		bt_pins: bt-pins {
-			hostwake {
-				pins = "gpio75";
-				function = "gpio";
-				drive-strength = <16>;
-				input-enable;
+	pmic@60 {
+		reg = <0x60>;
+		compatible = "maxim,max77826";
+
+		regulators {
+			max77826_ldo1: LDO1 {
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
 			};
 
-			devwake {
-				pins = "gpio91";
-				function = "gpio";
-				drive-strength = <2>;
+			max77826_ldo2: LDO2 {
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
 			};
-		};
 
-		sdhc1_pin_a: sdhc1-pin-active {
-			clk {
-				pins = "sdc1_clk";
-				drive-strength = <4>;
-				bias-disable;
+			max77826_ldo3: LDO3 {
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
 			};
 
-			cmd-data {
-				pins = "sdc1_cmd", "sdc1_data";
-				drive-strength = <4>;
-				bias-pull-up;
+			max77826_ldo4: LDO4 {
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
 			};
-		};
 
-		sdhc2_pin_a: sdhc2-pin-active {
-			clk-cmd-data {
-				pins = "gpio35", "gpio36", "gpio37", "gpio38",
-					"gpio39", "gpio40";
-				function = "sdc3";
-				drive-strength = <8>;
-				bias-disable;
+			max77826_ldo5: LDO5 {
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
 			};
-		};
 
-		sdhc2_cd_pin: sdhc2-cd {
-			pins = "gpio62";
-			function = "gpio";
+			max77826_ldo6: LDO6 {
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
+			};
 
-			drive-strength = <2>;
-			bias-disable;
-		};
+			max77826_ldo7: LDO7 {
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
 
-		sdhc3_pin_a: sdhc3-pin-active {
-			clk {
-				pins = "sdc2_clk";
-				drive-strength = <6>;
-				bias-disable;
+			max77826_ldo8: LDO8 {
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
 			};
 
-			cmd-data {
-				pins = "sdc2_cmd", "sdc2_data";
-				drive-strength = <6>;
-				bias-pull-up;
+			max77826_ldo9: LDO9 {
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
 			};
-		};
 
-		i2c2_pins: i2c2 {
-			mux {
-				pins = "gpio6", "gpio7";
-				function = "blsp_i2c2";
+			max77826_ldo10: LDO10 {
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2950000>;
+			};
 
-				drive-strength = <2>;
-				bias-disable;
+			max77826_ldo11: LDO11 {
+				regulator-min-microvolt = <2700000>;
+				regulator-max-microvolt = <2950000>;
 			};
-		};
 
-		i2c6_pins: i2c6 {
-			mux {
-				pins = "gpio29", "gpio30";
-				function = "blsp_i2c6";
+			max77826_ldo12: LDO12 {
+				regulator-min-microvolt = <2500000>;
+				regulator-max-microvolt = <3300000>;
+			};
 
-				drive-strength = <2>;
-				bias-disable;
+			max77826_ldo13: LDO13 {
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
 			};
-		};
 
-		i2c12_pins: i2c12 {
-			mux {
-				pins = "gpio87", "gpio88";
-				function = "blsp_i2c12";
+			max77826_ldo14: LDO14 {
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+			};
 
-				drive-strength = <2>;
-				bias-disable;
+			max77826_ldo15: LDO15 {
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
 			};
-		};
 
-		i2c_touchkey_pins: i2c-touchkey {
-			mux {
-				pins = "gpio95", "gpio96";
-				function = "gpio";
-				input-enable;
-				bias-pull-up;
+			max77826_buck: BUCK {
+				regulator-min-microvolt = <1225000>;
+				regulator-max-microvolt = <1225000>;
 			};
-		};
 
-		i2c_led_gpioex_pins: i2c-led-gpioex {
-			mux {
-				pins = "gpio120", "gpio121";
-				function = "gpio";
-				input-enable;
-				bias-pull-down;
+			max77826_buckboost: BUCKBOOST {
+				regulator-min-microvolt = <3400000>;
+				regulator-max-microvolt = <3400000>;
 			};
 		};
+	};
+};
 
-		gpioex_pin: gpioex {
-			res {
-				pins = "gpio145";
-				function = "gpio";
+&blsp1_uart2 {
+	status = "okay";
+};
 
-				bias-pull-up;
-				drive-strength = <2>;
-			};
-		};
+&blsp2_i2c6 {
+	status = "okay";
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c12_pins>;
+
+	fuelgauge@36 {
+		compatible = "maxim,max17048";
+		reg = <0x36>;
+
+		maxim,double-soc;
+		maxim,rcomp = /bits/ 8 <0x56>;
+
+		interrupt-parent = <&pma8084_gpios>;
+		interrupts = <21 IRQ_TYPE_LEVEL_LOW>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&fuelgauge_pin>;
+	};
+};
 
-		wifi_pin: wifi {
-			int {
-				pins = "gpio92";
-				function = "gpio";
+&blsp2_uart2 {
+	status = "okay";
 
-				input-enable;
-				bias-pull-down;
+	pinctrl-names = "default", "sleep";
+	pinctrl-0 = <&blsp2_uart2_pins_active>;
+	pinctrl-1 = <&blsp2_uart2_pins_sleep>;
+
+	bluetooth {
+		compatible = "brcm,bcm43540-bt";
+		max-speed = <3000000>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&bt_pins>;
+		device-wakeup-gpios = <&tlmm 91 GPIO_ACTIVE_HIGH>;
+		shutdown-gpios = <&gpio_expander 9 GPIO_ACTIVE_HIGH>;
+		interrupt-parent = <&tlmm>;
+		interrupts = <75 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "host-wakeup";
+	};
+};
+
+&dsi0 {
+	status = "okay";
+
+	vdda-supply = <&pma8084_l2>;
+	vdd-supply = <&pma8084_l22>;
+	vddio-supply = <&pma8084_l12>;
+
+	panel: panel@0 {
+		reg = <0>;
+		compatible = "samsung,s6e3fa2";
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&panel_te_pin &panel_rst_pin>;
+
+		iovdd-supply = <&pma8084_lvs4>;
+		vddr-supply = <&vreg_panel>;
+
+		reset-gpios = <&pma8084_gpios 17 GPIO_ACTIVE_LOW>;
+		te-gpios = <&tlmm 12 GPIO_ACTIVE_HIGH>;
+
+		port {
+			panel_in: endpoint {
+				remote-endpoint = <&dsi0_out>;
 			};
 		};
+	};
+};
 
-		panel_te_pin: panel {
-			te {
-				pins = "gpio12";
-				function = "mdp_vsync";
+&dsi0_out {
+	remote-endpoint = <&panel_in>;
+	data-lanes = <0 1 2 3>;
+};
 
-				drive-strength = <2>;
-				bias-disable;
-			};
+&dsi0_phy {
+	status = "okay";
+
+	vddio-supply = <&pma8084_l12>;
+};
+
+&gpu {
+	status = "okay";
+};
+
+&mdss {
+	status = "okay";
+};
+
+&otg {
+	status = "okay";
+
+	phys = <&usb_hs1_phy>;
+	phy-select = <&tcsr 0xb000 0>;
+
+	hnp-disable;
+	srp-disable;
+	adp-disable;
+
+	ulpi {
+		phy@a {
+			status = "okay";
+
+			v1p8-supply = <&pma8084_l6>;
+			v3p3-supply = <&pma8084_l24>;
+
+			qcom,init-seq = /bits/ 8 <0x1 0x64>;
 		};
 	};
+};
 
-	sdhci@f9824900 {
-		status = "okay";
+&pma8084_gpios {
+	gpio_keys_pin_a: gpio-keys-active {
+		pins = "gpio2", "gpio3", "gpio5";
+		function = "normal";
 
-		vmmc-supply = <&pma8084_l20>;
-		vqmmc-supply = <&pma8084_s4>;
+		bias-pull-up;
+		power-source = <PMA8084_GPIO_S4>;
+	};
 
-		bus-width = <8>;
-		non-removable;
+	touchkey_pin: touchkey-int-pin {
+		pins = "gpio6";
+		function = "normal";
+		bias-disable;
+		input-enable;
+		power-source = <PMA8084_GPIO_S4>;
+	};
 
-		pinctrl-names = "default";
-		pinctrl-0 = <&sdhc1_pin_a>;
+	touch_pin: touchscreen-int-pin {
+		pins = "gpio8";
+		function = "normal";
+		bias-disable;
+		input-enable;
+		power-source = <PMA8084_GPIO_S4>;
 	};
 
-	sdhci@f9864900 {
-		status = "okay";
+	panel_en_pin: panel-en-pin {
+		pins = "gpio14";
+		function = "normal";
+		bias-pull-up;
+		power-source = <PMA8084_GPIO_S4>;
+		qcom,drive-strength = <PMIC_GPIO_STRENGTH_LOW>;
+	};
 
-		max-frequency = <100000000>;
+	wlan_sleep_clk_pin: wlan-sleep-clk-pin {
+		pins = "gpio16";
+		function = "func2";
 
-		vmmc-supply = <&pma8084_l21>;
-		vqmmc-supply = <&pma8084_l13>;
+		output-high;
+		power-source = <PMA8084_GPIO_S4>;
+		qcom,drive-strength = <PMIC_GPIO_STRENGTH_HIGH>;
+	};
 
-		bus-width = <4>;
+	panel_rst_pin: panel-rst-pin {
+		pins = "gpio17";
+		function = "normal";
+		bias-disable;
+		power-source = <PMA8084_GPIO_S4>;
+		qcom,drive-strength = <PMIC_GPIO_STRENGTH_LOW>;
+	};
 
-		/* cd-gpio is intentionally disabled. If enabled, an SD card
-		 * present during boot is not initialized correctly. Without
-		 * cd-gpios the driver resorts to polling, so hotplug works.
-		 */
-		pinctrl-names = "default";
-		pinctrl-0 = <&sdhc2_pin_a /* &sdhc2_cd_pin */>;
-		// cd-gpios = <&tlmm 62 GPIO_ACTIVE_LOW>;
+	fuelgauge_pin: fuelgauge-int-pin {
+		pins = "gpio21";
+		function = "normal";
+		bias-disable;
+		input-enable;
+		power-source = <PMA8084_GPIO_S4>;
 	};
+};
 
-	sdhci@f98a4900 {
-		status = "okay";
+&remoteproc_adsp {
+	cx-supply = <&pma8084_s2>;
+};
 
-		#address-cells = <1>;
-		#size-cells = <0>;
+&remoteproc_mss {
+	cx-supply = <&pma8084_s2>;
+	mss-supply = <&pma8084_s6>;
+	mx-supply = <&pma8084_s1>;
+	pll-supply = <&pma8084_l12>;
+};
 
-		max-frequency = <100000000>;
+&rpm_requests {
+	pma8084-regulators {
+		compatible = "qcom,rpm-pma8084-regulators";
 
-		pinctrl-names = "default";
-		pinctrl-0 = <&sdhc3_pin_a>;
+		pma8084_s1: s1 {
+			regulator-min-microvolt = <675000>;
+			regulator-max-microvolt = <1050000>;
+			regulator-always-on;
+		};
 
-		vmmc-supply = <&vreg_wlan>;
-		vqmmc-supply = <&pma8084_s4>;
+		pma8084_s2: s2 {
+			regulator-min-microvolt = <500000>;
+			regulator-max-microvolt = <1050000>;
+		};
 
-		bus-width = <4>;
-		non-removable;
+		pma8084_s3: s3 {
+			regulator-min-microvolt = <1300000>;
+			regulator-max-microvolt = <1300000>;
+		};
 
-		wifi@1 {
-			reg = <1>;
-			compatible = "brcm,bcm4329-fmac";
+		pma8084_s4: s4 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
 
-			interrupt-parent = <&tlmm>;
-			interrupts = <92 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "host-wake";
+		pma8084_s5: s5 {
+			regulator-min-microvolt = <2150000>;
+			regulator-max-microvolt = <2150000>;
+		};
 
-			pinctrl-names = "default";
-			pinctrl-0 = <&wlan_sleep_clk_pin &wifi_pin>;
+		pma8084_s6: s6 {
+			regulator-min-microvolt = <1050000>;
+			regulator-max-microvolt = <1050000>;
 		};
-	};
 
-	usb@f9a55000 {
-		status = "okay";
+		pma8084_l1: l1 {
+			regulator-min-microvolt = <1225000>;
+			regulator-max-microvolt = <1225000>;
+		};
 
-		phys = <&usb_hs1_phy>;
-		phy-select = <&tcsr 0xb000 0>;
-		/*extcon = <&smbb>, <&usb_id>;*/
-		/*vbus-supply = <&chg_otg>;*/
+		pma8084_l2: l2 {
+			regulator-min-microvolt = <1200000>;
+			regulator-max-microvolt = <1200000>;
+		};
 
-		hnp-disable;
-		srp-disable;
-		adp-disable;
+		pma8084_l3: l3 {
+			regulator-min-microvolt = <1050000>;
+			regulator-max-microvolt = <1200000>;
+		};
 
-		ulpi {
-			phy@a {
-				status = "okay";
+		pma8084_l4: l4 {
+			regulator-min-microvolt = <1200000>;
+			regulator-max-microvolt = <1225000>;
+		};
 
-				v1p8-supply = <&pma8084_l6>;
-				v3p3-supply = <&pma8084_l24>;
+		pma8084_l5: l5 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
 
-				/*extcon = <&smbb>;*/
-				qcom,init-seq = /bits/ 8 <0x1 0x64>;
-			};
+		pma8084_l6: l6 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
 		};
-	};
 
-	i2c@f9924000 {
-		status = "okay";
+		pma8084_l7: l7 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
 
-		pinctrl-names = "default";
-		pinctrl-0 = <&i2c2_pins>;
+		pma8084_l8: l8 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
 
-		touchscreen@20 {
-			compatible = "syna,rmi4-i2c";
-			reg = <0x20>;
+		pma8084_l9: l9 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <2950000>;
+		};
 
-			interrupt-parent = <&pma8084_gpios>;
-			interrupts = <8 IRQ_TYPE_EDGE_FALLING>;
+		pma8084_l10: l10 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <2950000>;
+		};
 
-			vdd-supply = <&max77826_ldo13>;
-			vio-supply = <&pma8084_lvs2>;
+		pma8084_l11: l11 {
+			regulator-min-microvolt = <1300000>;
+			regulator-max-microvolt = <1300000>;
+		};
 
-			pinctrl-names = "default";
-			pinctrl-0 = <&touch_pin>;
+		pma8084_l12: l12 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-always-on;
+		};
 
-			syna,startup-delay-ms = <100>;
+		pma8084_l13: l13 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <2950000>;
+		};
 
-			#address-cells = <1>;
-			#size-cells = <0>;
+		pma8084_l14: l14 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
 
-			rmi4-f01@1 {
-				reg = <0x1>;
-				syna,nosleep-mode = <1>;
-			};
+		pma8084_l15: l15 {
+			regulator-min-microvolt = <2050000>;
+			regulator-max-microvolt = <2050000>;
+		};
 
-			rmi4-f12@12 {
-				reg = <0x12>;
-				syna,sensor-type = <1>;
-			};
+		pma8084_l16: l16 {
+			regulator-min-microvolt = <2700000>;
+			regulator-max-microvolt = <2700000>;
 		};
-	};
 
-	i2c@f9928000 {
-		status = "okay";
+		pma8084_l17: l17 {
+			regulator-min-microvolt = <2850000>;
+			regulator-max-microvolt = <2850000>;
+		};
 
-		pinctrl-names = "default";
-		pinctrl-0 = <&i2c6_pins>;
-
-		pmic@60 {
-			reg = <0x60>;
-			compatible = "maxim,max77826";
-
-			regulators {
-				max77826_ldo1: LDO1 {
-					regulator-min-microvolt = <1200000>;
-					regulator-max-microvolt = <1200000>;
-				};
-
-				max77826_ldo2: LDO2 {
-					regulator-min-microvolt = <1000000>;
-					regulator-max-microvolt = <1000000>;
-				};
-
-				max77826_ldo3: LDO3 {
-					regulator-min-microvolt = <1200000>;
-					regulator-max-microvolt = <1200000>;
-				};
-
-				max77826_ldo4: LDO4 {
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-				};
-
-				max77826_ldo5: LDO5 {
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-				};
-
-				max77826_ldo6: LDO6 {
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <3300000>;
-				};
-
-				max77826_ldo7: LDO7 {
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-				};
-
-				max77826_ldo8: LDO8 {
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <3300000>;
-				};
-
-				max77826_ldo9: LDO9 {
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-				};
-
-				max77826_ldo10: LDO10 {
-					regulator-min-microvolt = <2800000>;
-					regulator-max-microvolt = <2950000>;
-				};
-
-				max77826_ldo11: LDO11 {
-					regulator-min-microvolt = <2700000>;
-					regulator-max-microvolt = <2950000>;
-				};
-
-				max77826_ldo12: LDO12 {
-					regulator-min-microvolt = <2500000>;
-					regulator-max-microvolt = <3300000>;
-				};
-
-				max77826_ldo13: LDO13 {
-					regulator-min-microvolt = <3300000>;
-					regulator-max-microvolt = <3300000>;
-				};
-
-				max77826_ldo14: LDO14 {
-					regulator-min-microvolt = <3300000>;
-					regulator-max-microvolt = <3300000>;
-				};
-
-				max77826_ldo15: LDO15 {
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-				};
-
-				max77826_buck: BUCK {
-					regulator-min-microvolt = <1225000>;
-					regulator-max-microvolt = <1225000>;
-				};
-
-				max77826_buckboost: BUCKBOOST {
-					regulator-min-microvolt = <3400000>;
-					regulator-max-microvolt = <3400000>;
-				};
-			};
+		pma8084_l18: l18 {
+			regulator-min-microvolt = <2850000>;
+			regulator-max-microvolt = <2850000>;
 		};
-	};
 
-	i2c@f9968000 {
-		status = "okay";
+		pma8084_l19: l19 {
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+		};
 
-		pinctrl-names = "default";
-		pinctrl-0 = <&i2c12_pins>;
+		pma8084_l20: l20 {
+			regulator-min-microvolt = <2950000>;
+			regulator-max-microvolt = <2950000>;
+			regulator-system-load = <200000>;
+			regulator-allow-set-load;
+		};
 
-		fuelgauge@36 {
-			compatible = "maxim,max17048";
-			reg = <0x36>;
+		pma8084_l21: l21 {
+			regulator-min-microvolt = <2950000>;
+			regulator-max-microvolt = <2950000>;
+			regulator-system-load = <200000>;
+			regulator-allow-set-load;
+		};
 
-			maxim,double-soc;
-			maxim,rcomp = /bits/ 8 <0x56>;
+		pma8084_l22: l22 {
+			regulator-min-microvolt = <3000000>;
+			regulator-max-microvolt = <3300000>;
+		};
 
-			interrupt-parent = <&pma8084_gpios>;
-			interrupts = <21 IRQ_TYPE_LEVEL_LOW>;
+		pma8084_l23: l23 {
+			regulator-min-microvolt = <3000000>;
+			regulator-max-microvolt = <3000000>;
+		};
 
-			pinctrl-names = "default";
-			pinctrl-0 = <&fuelgauge_pin>;
+		pma8084_l24: l24 {
+			regulator-min-microvolt = <3075000>;
+			regulator-max-microvolt = <3075000>;
 		};
+
+		pma8084_l25: l25 {
+			regulator-min-microvolt = <2100000>;
+			regulator-max-microvolt = <2100000>;
+		};
+
+		pma8084_l26: l26 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <2050000>;
+		};
+
+		pma8084_l27: l27 {
+			regulator-min-microvolt = <1000000>;
+			regulator-max-microvolt = <1225000>;
+		};
+
+		pma8084_lvs1: lvs1 {};
+		pma8084_lvs2: lvs2 {};
+		pma8084_lvs3: lvs3 {};
+		pma8084_lvs4: lvs4 {};
+
+		pma8084_5vs1: 5vs1 {};
 	};
+};
+
+&sdhc_1 {
+	status = "okay";
+
+	vmmc-supply = <&pma8084_l20>;
+	vqmmc-supply = <&pma8084_s4>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&sdhc1_pin_a>;
+};
+
+&sdhc_2 {
+	status = "okay";
+	max-frequency = <100000000>;
 
-	adreno@fdb00000 {
-		status = "ok";
+	pinctrl-names = "default";
+	pinctrl-0 = <&sdhc3_pin_a>;
+
+	vmmc-supply = <&vreg_wlan>;
+	vqmmc-supply = <&pma8084_s4>;
+
+	non-removable;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	wifi@1 {
+		reg = <1>;
+		compatible = "brcm,bcm4329-fmac";
+
+		interrupt-parent = <&tlmm>;
+		interrupts = <92 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "host-wake";
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&wlan_sleep_clk_pin &wifi_pin>;
 	};
+};
 
-	mdss@fd900000 {
-		status = "ok";
+&sdhc_3 {
+	status = "okay";
+	max-frequency = <100000000>;
+
+	vmmc-supply = <&pma8084_l21>;
+	vqmmc-supply = <&pma8084_l13>;
+
+	/*
+	 * cd-gpio is intentionally disabled. If enabled, an SD card
+	 * present during boot is not initialized correctly. Without
+	 * cd-gpios the driver resorts to polling, so hotplug works.
+	 */
+	pinctrl-names = "default";
+	pinctrl-0 = <&sdhc2_pin_a /* &sdhc2_cd_pin */>;
+	/* cd-gpios = <&tlmm 62 GPIO_ACTIVE_LOW>; */
+};
 
-		mdp@fd900000 {
-			status = "ok";
-		};
+&tlmm {
+	blsp2_uart2_pins_active: blsp2-uart2-pins-active {
+		pins = "gpio45", "gpio46", "gpio47", "gpio48";
+		function = "blsp_uart8";
+		drive-strength = <8>;
+		bias-disable;
+	};
 
-		dsi@fd922800 {
-			status = "ok";
+	blsp2_uart2_pins_sleep: blsp2-uart2-pins-sleep {
+		pins = "gpio45", "gpio46", "gpio47", "gpio48";
+		function = "gpio";
+		drive-strength = <2>;
+		bias-pull-down;
+	};
 
-			vdda-supply = <&pma8084_l2>;
-			vdd-supply = <&pma8084_l22>;
-			vddio-supply = <&pma8084_l12>;
+	bt_pins: bt-pins {
+		hostwake {
+			pins = "gpio75";
+			function = "gpio";
+			drive-strength = <16>;
+			input-enable;
+		};
 
-			#address-cells = <1>;
-			#size-cells = <0>;
+		devwake {
+			pins = "gpio91";
+			function = "gpio";
+			drive-strength = <2>;
+		};
+	};
 
-			ports {
-				port@1 {
-					endpoint {
-						remote-endpoint = <&panel_in>;
-						data-lanes = <0 1 2 3>;
-					};
-				};
-			};
+	sdhc1_pin_a: sdhc1-pin-active {
+		clk {
+			pins = "sdc1_clk";
+			drive-strength = <4>;
+			bias-disable;
+		};
 
-			panel: panel@0 {
-				reg = <0>;
-				compatible = "samsung,s6e3fa2";
+		cmd-data {
+			pins = "sdc1_cmd", "sdc1_data";
+			drive-strength = <4>;
+			bias-pull-up;
+		};
+	};
+
+	sdhc2_pin_a: sdhc2-pin-active {
+		clk-cmd-data {
+			pins = "gpio35", "gpio36", "gpio37", "gpio38",
+				"gpio39", "gpio40";
+			function = "sdc3";
+			drive-strength = <8>;
+			bias-disable;
+		};
+	};
 
-				pinctrl-names = "default";
-				pinctrl-0 = <&panel_te_pin &panel_rst_pin>;
+	sdhc2_cd_pin: sdhc2-cd {
+		pins = "gpio62";
+		function = "gpio";
 
-				iovdd-supply = <&pma8084_lvs4>;
-				vddr-supply = <&vreg_panel>;
+		drive-strength = <2>;
+		bias-disable;
+	};
 
-				reset-gpios = <&pma8084_gpios 17 GPIO_ACTIVE_LOW>;
-				te-gpios = <&tlmm 12 GPIO_ACTIVE_HIGH>;
+	sdhc3_pin_a: sdhc3-pin-active {
+		clk {
+			pins = "sdc2_clk";
+			drive-strength = <6>;
+			bias-disable;
+		};
 
-				port {
-					panel_in: endpoint {
-						remote-endpoint = <&dsi0_out>;
-					};
-				};
-			};
+		cmd-data {
+			pins = "sdc2_cmd", "sdc2_data";
+			drive-strength = <6>;
+			bias-pull-up;
 		};
+	};
 
-		dsi-phy@fd922a00 {
-			status = "ok";
+	i2c2_pins: i2c2 {
+		mux {
+			pins = "gpio6", "gpio7";
+			function = "blsp_i2c2";
 
-			vddio-supply = <&pma8084_l12>;
+			drive-strength = <2>;
+			bias-disable;
 		};
 	};
 
-	remoteproc@fc880000 {
-		cx-supply = <&pma8084_s2>;
-		mss-supply = <&pma8084_s6>;
-		mx-supply = <&pma8084_s1>;
-		pll-supply = <&pma8084_l12>;
+	i2c6_pins: i2c6 {
+		mux {
+			pins = "gpio29", "gpio30";
+			function = "blsp_i2c6";
+
+			drive-strength = <2>;
+			bias-disable;
+		};
 	};
-};
 
-&spmi_bus {
-	pma8084@0 {
-		gpios@c000 {
-			gpio_keys_pin_a: gpio-keys-active {
-				pins = "gpio2", "gpio3", "gpio5";
-				function = "normal";
+	i2c12_pins: i2c12 {
+		mux {
+			pins = "gpio87", "gpio88";
+			function = "blsp_i2c12";
 
-				bias-pull-up;
-				power-source = <PMA8084_GPIO_S4>;
-			};
+			drive-strength = <2>;
+			bias-disable;
+		};
+	};
 
-			touchkey_pin: touchkey-int-pin {
-				pins = "gpio6";
-				function = "normal";
-				bias-disable;
-				input-enable;
-				power-source = <PMA8084_GPIO_S4>;
-			};
+	i2c_touchkey_pins: i2c-touchkey {
+		mux {
+			pins = "gpio95", "gpio96";
+			function = "gpio";
+			input-enable;
+			bias-pull-up;
+		};
+	};
 
-			touch_pin: touchscreen-int-pin {
-				pins = "gpio8";
-				function = "normal";
-				bias-disable;
-				input-enable;
-				power-source = <PMA8084_GPIO_S4>;
-			};
+	i2c_led_gpioex_pins: i2c-led-gpioex {
+		mux {
+			pins = "gpio120", "gpio121";
+			function = "gpio";
+			input-enable;
+			bias-pull-down;
+		};
+	};
 
-			panel_en_pin: panel-en-pin {
-				pins = "gpio14";
-				function = "normal";
-				bias-pull-up;
-				power-source = <PMA8084_GPIO_S4>;
-				qcom,drive-strength = <PMIC_GPIO_STRENGTH_LOW>;
-			};
+	gpioex_pin: gpioex {
+		res {
+			pins = "gpio145";
+			function = "gpio";
 
-			wlan_sleep_clk_pin: wlan-sleep-clk-pin {
-				pins = "gpio16";
-				function = "func2";
+			bias-pull-up;
+			drive-strength = <2>;
+		};
+	};
 
-				output-high;
-				power-source = <PMA8084_GPIO_S4>;
-				qcom,drive-strength = <PMIC_GPIO_STRENGTH_HIGH>;
-			};
+	wifi_pin: wifi {
+		int {
+			pins = "gpio92";
+			function = "gpio";
 
-			panel_rst_pin: panel-rst-pin {
-				pins = "gpio17";
-				function = "normal";
-				bias-disable;
-				power-source = <PMA8084_GPIO_S4>;
-				qcom,drive-strength = <PMIC_GPIO_STRENGTH_LOW>;
-			};
+			input-enable;
+			bias-pull-down;
+		};
+	};
 
+	panel_te_pin: panel {
+		te {
+			pins = "gpio12";
+			function = "mdp_vsync";
 
-			fuelgauge_pin: fuelgauge-int-pin {
-				pins = "gpio21";
-				function = "normal";
-				bias-disable;
-				input-enable;
-				power-source = <PMA8084_GPIO_S4>;
-			};
+			drive-strength = <2>;
+			bias-disable;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index f1278d39ff6c..ea3491d47b9f 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -341,7 +341,7 @@ timer {
 		clock-frequency = <19200000>;
 	};
 
-	adsp-pil {
+	remoteproc_adsp: adsp-pil {
 		compatible = "qcom,msm8974-adsp-pil";
 
 		interrupts-extended = <&intc GIC_SPI 162 IRQ_TYPE_EDGE_RISING>,
@@ -842,7 +842,7 @@ rng@f9bff000 {
 			clock-names = "core";
 		};
 
-		remoteproc@fc880000 {
+		remoteproc_mss: remoteproc@fc880000 {
 			compatible = "qcom,msm8974-mss-pil";
 			reg = <0xfc880000 0x100>, <0xfc820000 0x020>;
 			reg-names = "qdsp6", "rmb";
-- 
2.35.1



