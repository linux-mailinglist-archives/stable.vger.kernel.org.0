Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6569593E65
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344962AbiHOUnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347128AbiHOUme (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:42:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC5C2FE;
        Mon, 15 Aug 2022 12:07:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A11CC612A0;
        Mon, 15 Aug 2022 19:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7000CC433C1;
        Mon, 15 Aug 2022 19:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590463;
        bh=dd2zDPf4tKX4sc/1OT8zO9hK9p9xmQ1IbCHvn+n/yGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYBgh2GPAgS3c4hIRuZaI6RvX76vXV7ZH1+BX7WfS5QRuw+yhn9NjXJHLrH72BWUu
         vtXaZqN5Alk7pyEUynZu/E4kbU6izJ+M8O7u6/6EjSjwdhfIVr57RN63pSJt14Yvkb
         fOojAeUytTMmmDTtTZNyukWrrU+/E7KfeT6PugFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0237/1095] ARM: dts: qcom-msm8974-castor: Use &labels
Date:   Mon, 15 Aug 2022 19:53:56 +0200
Message-Id: <20220815180439.590264499@linuxfoundation.org>
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

[ Upstream commit 598a1e333224e73ae8f078ed6aa8dcd416cfb490 ]

Use &labels to align with the style used in new DTS and apply tiny
style fixes.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
[bjorn: Rebased ontop of Krzysztof's fixes]
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220415115633.575010-14-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/qcom-msm8974-sony-xperia-castor.dts   | 988 +++++++++---------
 1 file changed, 481 insertions(+), 507 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts
index 352689237140..687f6149268c 100644
--- a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts
@@ -53,186 +53,6 @@ volume-up {
 		};
 	};
 
-	smd {
-		rpm {
-			rpm-requests {
-				pm8941-regulators {
-					vdd_l1_l3-supply = <&pm8941_s1>;
-					vdd_l2_lvs1_2_3-supply = <&pm8941_s3>;
-					vdd_l4_l11-supply = <&pm8941_s1>;
-					vdd_l5_l7-supply = <&pm8941_s2>;
-					vdd_l6_l12_l14_l15-supply = <&pm8941_s2>;
-					vdd_l9_l10_l17_l22-supply = <&vreg_boost>;
-					vdd_l13_l20_l23_l24-supply = <&vreg_boost>;
-					vdd_l21-supply = <&vreg_boost>;
-
-					s1 {
-						regulator-min-microvolt = <1300000>;
-						regulator-max-microvolt = <1300000>;
-						regulator-always-on;
-						regulator-boot-on;
-					};
-
-					s2 {
-						regulator-min-microvolt = <2150000>;
-						regulator-max-microvolt = <2150000>;
-						regulator-boot-on;
-					};
-
-					s3 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-						regulator-always-on;
-						regulator-boot-on;
-
-						regulator-system-load = <154000>;
-					};
-
-					s4 {
-						regulator-min-microvolt = <5000000>;
-						regulator-max-microvolt = <5000000>;
-					};
-
-					l1 {
-						regulator-min-microvolt = <1225000>;
-						regulator-max-microvolt = <1225000>;
-
-						regulator-always-on;
-						regulator-boot-on;
-					};
-
-					l2 {
-						regulator-min-microvolt = <1200000>;
-						regulator-max-microvolt = <1200000>;
-					};
-
-					l3 {
-						regulator-min-microvolt = <1200000>;
-						regulator-max-microvolt = <1200000>;
-					};
-
-					l4 {
-						regulator-min-microvolt = <1225000>;
-						regulator-max-microvolt = <1225000>;
-					};
-
-					l5 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-					};
-
-					l6 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-
-						regulator-boot-on;
-					};
-
-					l7 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-
-						regulator-boot-on;
-					};
-
-					l8 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-					};
-
-					l9 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <2950000>;
-					};
-
-					l11 {
-						regulator-min-microvolt = <1300000>;
-						regulator-max-microvolt = <1350000>;
-					};
-
-					l12 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-
-						regulator-always-on;
-						regulator-boot-on;
-					};
-
-					l13 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <2950000>;
-
-						regulator-boot-on;
-					};
-
-					l14 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-					};
-
-					l15 {
-						regulator-min-microvolt = <2050000>;
-						regulator-max-microvolt = <2050000>;
-					};
-
-					l16 {
-						regulator-min-microvolt = <2700000>;
-						regulator-max-microvolt = <2700000>;
-					};
-
-					l17 {
-						regulator-min-microvolt = <2700000>;
-						regulator-max-microvolt = <2700000>;
-					};
-
-					l18 {
-						regulator-min-microvolt = <2850000>;
-						regulator-max-microvolt = <2850000>;
-					};
-
-					l19 {
-						regulator-min-microvolt = <2850000>;
-						regulator-max-microvolt = <2850000>;
-					};
-
-					l20 {
-						regulator-min-microvolt = <2950000>;
-						regulator-max-microvolt = <2950000>;
-
-						regulator-allow-set-load;
-						regulator-boot-on;
-						regulator-allow-set-load;
-						regulator-system-load = <500000>;
-					};
-
-					l21 {
-						regulator-min-microvolt = <2950000>;
-						regulator-max-microvolt = <2950000>;
-
-						regulator-boot-on;
-					};
-
-					l22 {
-						regulator-min-microvolt = <3000000>;
-						regulator-max-microvolt = <3000000>;
-					};
-
-					l23 {
-						regulator-min-microvolt = <2800000>;
-						regulator-max-microvolt = <2800000>;
-					};
-
-					l24 {
-						regulator-min-microvolt = <3075000>;
-						regulator-max-microvolt = <3075000>;
-
-						regulator-boot-on;
-					};
-				};
-			};
-		};
-	};
-
 	vreg_bl_vddio: lcd-backlight-vddio {
 		compatible = "regulator-fixed";
 		regulator-name = "vreg_bl_vddio";
@@ -277,447 +97,601 @@ vreg_wlan: wlan-regulator {
 	};
 };
 
-&soc {
-	sdhci@f9824900 {
-		status = "okay";
+&blsp1_uart2 {
+	status = "okay";
 
-		vmmc-supply = <&pm8941_l20>;
-		vqmmc-supply = <&pm8941_s3>;
-
-		bus-width = <8>;
-		non-removable;
+	pinctrl-names = "default";
+	pinctrl-0 = <&blsp1_uart2_pin_a>;
+};
 
-		pinctrl-names = "default";
-		pinctrl-0 = <&sdhc1_pin_a>;
-	};
+&blsp2_i2c2 {
+	status = "okay";
+	clock-frequency = <355000>;
 
-	sdhci@f9864900 {
-		status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c8_pins>;
 
-		max-frequency = <100000000>;
-		non-removable;
-		vmmc-supply = <&vreg_wlan>;
+	synaptics@2c {
+		compatible = "syna,rmi4-i2c";
+		reg = <0x2c>;
 
-		pinctrl-names = "default";
-		pinctrl-0 = <&sdhc3_pin_a>;
+		interrupt-parent = <&tlmm>;
+		interrupts = <86 IRQ_TYPE_EDGE_FALLING>;
 
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		bcrmf@1 {
-			compatible = "brcm,bcm4339-fmac", "brcm,bcm4329-fmac";
-			reg = <1>;
+		vdd-supply = <&pm8941_l22>;
+		vio-supply = <&pm8941_lvs3>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&ts_int_pin>;
 
-			brcm,drive-strength = <10>;
+		syna,startup-delay-ms = <10>;
 
-			pinctrl-names = "default";
-			pinctrl-0 = <&wlan_sleep_clk_pin>;
+		rmi-f01@1 {
+			reg = <0x1>;
+			syna,nosleep = <1>;
 		};
-	};
 
-	sdhci@f98a4900 {
-		status = "okay";
+		rmi-f11@11 {
+			reg = <0x11>;
+			syna,f11-flip-x = <1>;
+			syna,sensor-type = <1>;
+		};
+	};
+};
 
-		bus-width = <4>;
+&blsp2_i2c5 {
+	status = "okay";
+	clock-frequency = <355000>;
 
-		vmmc-supply = <&pm8941_l21>;
-		vqmmc-supply = <&pm8941_l13>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c11_pins>;
 
-		cd-gpios = <&tlmm 62 GPIO_ACTIVE_LOW>;
+	lp8566_wled: backlight@2c {
+		compatible = "ti,lp8556";
+		reg = <0x2c>;
+		power-supply = <&vreg_bl_vddio>;
 
-		pinctrl-names = "default";
-		pinctrl-0 = <&sdhc2_pin_a>, <&sdhc2_cd_pin_a>;
+		bl-name = "backlight";
+		dev-ctrl = /bits/ 8 <0x05>;
+		init-brt = /bits/ 8 <0x3f>;
+		rom_a0h {
+			rom-addr = /bits/ 8 <0xa0>;
+			rom-val = /bits/ 8 <0xff>;
+		};
+		rom_a1h {
+			rom-addr = /bits/ 8 <0xa1>;
+			rom-val = /bits/ 8 <0x3f>;
+		};
+		rom_a2h {
+			rom-addr = /bits/ 8 <0xa2>;
+			rom-val = /bits/ 8 <0x20>;
+		};
+		rom_a3h {
+			rom-addr = /bits/ 8 <0xa3>;
+			rom-val = /bits/ 8 <0x5e>;
+		};
+		rom_a4h {
+			rom-addr = /bits/ 8 <0xa4>;
+			rom-val = /bits/ 8 <0x02>;
+		};
+		rom_a5h {
+			rom-addr = /bits/ 8 <0xa5>;
+			rom-val = /bits/ 8 <0x04>;
+		};
+		rom_a6h {
+			rom-addr = /bits/ 8 <0xa6>;
+			rom-val = /bits/ 8 <0x80>;
+		};
+		rom_a7h {
+			rom-addr = /bits/ 8 <0xa7>;
+			rom-val = /bits/ 8 <0xf7>;
+		};
+		rom_a9h {
+			rom-addr = /bits/ 8 <0xa9>;
+			rom-val = /bits/ 8 <0x80>;
+		};
+		rom_aah {
+			rom-addr = /bits/ 8 <0xaa>;
+			rom-val = /bits/ 8 <0x0f>;
+		};
+		rom_aeh {
+			rom-addr = /bits/ 8 <0xae>;
+			rom-val = /bits/ 8 <0x0f>;
+		};
 	};
+};
+
+&blsp2_uart1 {
+	status = "okay";
 
-	serial@f991e000 {
-		status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&blsp2_uart7_pin_a>;
+
+	bluetooth {
+		compatible = "brcm,bcm43438-bt";
+		max-speed = <3000000>;
 
 		pinctrl-names = "default";
-		pinctrl-0 = <&blsp1_uart2_pin_a>;
+		pinctrl-0 = <&bt_host_wake_pin>,
+				<&bt_dev_wake_pin>,
+				<&bt_reg_on_pin>;
+
+		host-wakeup-gpios = <&tlmm 95 GPIO_ACTIVE_HIGH>;
+		device-wakeup-gpios = <&tlmm 96 GPIO_ACTIVE_HIGH>;
+		shutdown-gpios = <&pm8941_gpios 16 GPIO_ACTIVE_HIGH>;
 	};
+};
 
-	serial@f995d000 {
-		status = "ok";
+&otg {
+	status = "okay";
 
-		pinctrl-names = "default";
-		pinctrl-0 = <&blsp2_uart7_pin_a>;
+	phys = <&usb_hs1_phy>;
+	phy-select = <&tcsr 0xb000 0>;
+	extcon = <&smbb>, <&usb_id>;
+	vbus-supply = <&chg_otg>;
 
-		bluetooth {
-			compatible = "brcm,bcm43438-bt";
-			max-speed = <3000000>;
+	hnp-disable;
+	srp-disable;
+	adp-disable;
 
-			pinctrl-names = "default";
-			pinctrl-0 = <&bt_host_wake_pin>,
-				    <&bt_dev_wake_pin>,
-				    <&bt_reg_on_pin>;
+	ulpi {
+		phy@a {
+			status = "okay";
 
-			host-wakeup-gpios = <&tlmm 95 GPIO_ACTIVE_HIGH>;
-			device-wakeup-gpios = <&tlmm 96 GPIO_ACTIVE_HIGH>;
-			shutdown-gpios = <&pm8941_gpios 16 GPIO_ACTIVE_HIGH>;
+			v1p8-supply = <&pm8941_l6>;
+			v3p3-supply = <&pm8941_l24>;
+
+			extcon = <&smbb>;
+			qcom,init-seq = /bits/ 8 <0x1 0x64>;
 		};
 	};
+};
 
-	usb@f9a55000 {
-		status = "okay";
+&pm8941_coincell {
+	status = "okay";
 
-		phys = <&usb_hs1_phy>;
-		phy-select = <&tcsr 0xb000 0>;
-		extcon = <&smbb>, <&usb_id>;
-		vbus-supply = <&chg_otg>;
+	qcom,rset-ohms = <2100>;
+	qcom,vset-millivolts = <3000>;
+};
 
-		hnp-disable;
-		srp-disable;
-		adp-disable;
+&pm8941_gpios {
+	gpio_keys_pin_a: gpio-keys-active {
+		pins = "gpio2", "gpio5";
+		function = "normal";
 
-		ulpi {
-			phy@a {
-				status = "okay";
+		bias-pull-up;
+		power-source = <PM8941_GPIO_S3>;
+	};
 
-				v1p8-supply = <&pm8941_l6>;
-				v3p3-supply = <&pm8941_l24>;
+	bt_reg_on_pin: bt-reg-on {
+		pins = "gpio16";
+		function = "normal";
 
-				extcon = <&smbb>;
-				qcom,init-seq = /bits/ 8 <0x1 0x64>;
-			};
-		};
+		output-low;
+		power-source = <PM8941_GPIO_S3>;
 	};
 
-	pinctrl@fd510000 {
-		blsp1_uart2_pin_a: blsp1-uart2-pin-active {
-			rx {
-				pins = "gpio5";
-				function = "blsp_uart2";
+	wlan_sleep_clk_pin: wl-sleep-clk {
+		pins = "gpio17";
+		function = "func2";
 
-				drive-strength = <2>;
-				bias-pull-up;
-			};
+		output-high;
+		power-source = <PM8941_GPIO_S3>;
+	};
 
-			tx {
-				pins = "gpio4";
-				function = "blsp_uart2";
+	wlan_regulator_pin: wl-reg-active {
+		pins = "gpio18";
+		function = "normal";
 
-				drive-strength = <4>;
-				bias-disable;
-			};
-		};
+		bias-disable;
+		power-source = <PM8941_GPIO_S3>;
+	};
 
-		blsp2_uart7_pin_a: blsp2-uart7-pin-active {
-			tx {
-				pins = "gpio41";
-				function = "blsp_uart7";
+	lcd_dcdc_en_pin_a: lcd-dcdc-en-active {
+		pins = "gpio20";
+		function = "normal";
 
-				drive-strength = <2>;
-				bias-disable;
-			};
+		bias-disable;
+		power-source = <PM8941_GPIO_S3>;
+		input-disable;
+		output-low;
+	};
 
-			rx {
-				pins = "gpio42";
-				function = "blsp_uart7";
+};
 
-				drive-strength = <2>;
-				bias-pull-up;
-			};
+&rpm_requests {
+	pm8941-regulators {
+		vdd_l1_l3-supply = <&pm8941_s1>;
+		vdd_l2_lvs1_2_3-supply = <&pm8941_s3>;
+		vdd_l4_l11-supply = <&pm8941_s1>;
+		vdd_l5_l7-supply = <&pm8941_s2>;
+		vdd_l6_l12_l14_l15-supply = <&pm8941_s2>;
+		vdd_l9_l10_l17_l22-supply = <&vreg_boost>;
+		vdd_l13_l20_l23_l24-supply = <&vreg_boost>;
+		vdd_l21-supply = <&vreg_boost>;
+
+		pm8941_s1: s1 {
+			regulator-min-microvolt = <1300000>;
+			regulator-max-microvolt = <1300000>;
+			regulator-always-on;
+			regulator-boot-on;
+		};
 
-			cts {
-				pins = "gpio43";
-				function = "blsp_uart7";
+		pm8941_s2: s2 {
+			regulator-min-microvolt = <2150000>;
+			regulator-max-microvolt = <2150000>;
+			regulator-boot-on;
+		};
 
-				drive-strength = <2>;
-				bias-pull-up;
-			};
+		pm8941_s3: s3 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-system-load = <154000>;
+			regulator-always-on;
+			regulator-boot-on;
+		};
 
-			rts {
-				pins = "gpio44";
-				function = "blsp_uart7";
+		pm8941_s4: s4 {
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+		};
 
-				drive-strength = <2>;
-				bias-disable;
-			};
+		pm8941_l1: l1 {
+			regulator-min-microvolt = <1225000>;
+			regulator-max-microvolt = <1225000>;
+			regulator-always-on;
+			regulator-boot-on;
 		};
 
-		i2c8_pins: i2c8 {
-			mux {
-				pins = "gpio47", "gpio48";
-				function = "blsp_i2c8";
+		pm8941_l2: l2 {
+			regulator-min-microvolt = <1200000>;
+			regulator-max-microvolt = <1200000>;
+		};
 
-				drive-strength = <2>;
-				bias-disable;
-			};
+		pm8941_l3: l3 {
+			regulator-min-microvolt = <1200000>;
+			regulator-max-microvolt = <1200000>;
 		};
 
-		i2c11_pins: i2c11 {
-			mux {
-				pins = "gpio83", "gpio84";
-				function = "blsp_i2c11";
+		pm8941_l4: l4 {
+			regulator-min-microvolt = <1225000>;
+			regulator-max-microvolt = <1225000>;
+		};
 
-				drive-strength = <2>;
-				bias-disable;
-			};
+		pm8941_l5: l5 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
 		};
 
-		lcd_backlight_en_pin_a: lcd-backlight-vddio {
-			pins = "gpio69";
-			drive-strength = <10>;
-			output-low;
-			bias-disable;
+		pm8941_l6: l6 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-boot-on;
 		};
 
-		sdhc1_pin_a: sdhc1-pin-active {
-			clk {
-				pins = "sdc1_clk";
-				drive-strength = <16>;
-				bias-disable;
-			};
+		pm8941_l7: l7 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-boot-on;
+		};
 
-			cmd-data {
-				pins = "sdc1_cmd", "sdc1_data";
-				drive-strength = <10>;
-				bias-pull-up;
-			};
+		pm8941_l8: l8 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
 		};
 
-		sdhc2_cd_pin_a: sdhc2-cd-pin-active {
-			pins = "gpio62";
-			function = "gpio";
+		pm8941_l9: l9 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <2950000>;
+		};
 
-			drive-strength = <2>;
-			bias-disable;
-		 };
+		pm8941_l11: l11 {
+			regulator-min-microvolt = <1300000>;
+			regulator-max-microvolt = <1350000>;
+		};
 
-		sdhc2_pin_a: sdhc2-pin-active {
-			clk {
-				pins = "sdc2_clk";
-				drive-strength = <6>;
-				bias-disable;
-			};
+		pm8941_l12: l12 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-always-on;
+			regulator-boot-on;
+		};
 
-			cmd-data {
-				pins = "sdc2_cmd", "sdc2_data";
-				drive-strength = <6>;
-				bias-pull-up;
-			};
+		pm8941_l13: l13 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <2950000>;
+			regulator-boot-on;
 		};
 
-		sdhc3_pin_a: sdhc3-pin-active {
-			clk {
-				pins = "gpio40";
-				function = "sdc3";
+		pm8941_l14: l14 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
 
-				drive-strength = <10>;
-				bias-disable;
-			};
+		pm8941_l15: l15 {
+			regulator-min-microvolt = <2050000>;
+			regulator-max-microvolt = <2050000>;
+		};
 
-			cmd {
-				pins = "gpio39";
-				function = "sdc3";
+		pm8941_l16: l16 {
+			regulator-min-microvolt = <2700000>;
+			regulator-max-microvolt = <2700000>;
+		};
+
+		pm8941_l17: l17 {
+			regulator-min-microvolt = <2700000>;
+			regulator-max-microvolt = <2700000>;
+		};
 
-				drive-strength = <10>;
-				bias-pull-up;
-			};
+		pm8941_l18: l18 {
+			regulator-min-microvolt = <2850000>;
+			regulator-max-microvolt = <2850000>;
+		};
 
-			data {
-				pins = "gpio35", "gpio36", "gpio37", "gpio38";
-				function = "sdc3";
+		pm8941_l19: l19 {
+			regulator-min-microvolt = <2850000>;
+			regulator-max-microvolt = <2850000>;
+		};
 
-				drive-strength = <10>;
-				bias-pull-up;
-			};
+		pm8941_l20: l20 {
+			regulator-min-microvolt = <2950000>;
+			regulator-max-microvolt = <2950000>;
+			regulator-system-load = <500000>;
+			regulator-allow-set-load;
+			regulator-boot-on;
 		};
 
-		ts_int_pin: synaptics {
-			pin {
-				pins = "gpio86";
-				function = "gpio";
+		pm8941_l21: l21 {
+			regulator-min-microvolt = <2950000>;
+			regulator-max-microvolt = <2950000>;
+			regulator-boot-on;
+		};
 
-				drive-strength = <2>;
-				bias-disable;
-				input-enable;
-			};
+		pm8941_l22: l22 {
+			regulator-min-microvolt = <3000000>;
+			regulator-max-microvolt = <3000000>;
 		};
 
-		bt_host_wake_pin: bt-host-wake {
-			pins = "gpio95";
-			function = "gpio";
+		pm8941_l23: l23 {
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+		};
 
-			drive-strength = <2>;
-			bias-disable;
-			output-low;
+		pm8941_l24: l24 {
+			regulator-min-microvolt = <3075000>;
+			regulator-max-microvolt = <3075000>;
+			regulator-boot-on;
 		};
+	};
+};
 
-		bt_dev_wake_pin: bt-dev-wake {
-			pins = "gpio96";
-			function = "gpio";
+&sdhc_1 {
+	status = "okay";
+
+	vmmc-supply = <&pm8941_l20>;
+	vqmmc-supply = <&pm8941_s3>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&sdhc1_pin_a>;
+};
+
+&sdhc_2 {
+	status = "okay";
+
+	vmmc-supply = <&pm8941_l21>;
+	vqmmc-supply = <&pm8941_l13>;
+
+	cd-gpios = <&tlmm 62 GPIO_ACTIVE_LOW>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&sdhc2_pin_a>, <&sdhc2_cd_pin_a>;
+};
+
+&sdhc_3 {
+	status = "okay";
+
+	max-frequency = <100000000>;
+	vmmc-supply = <&vreg_wlan>;
+	non-removable;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&sdhc3_pin_a>;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	bcrmf@1 {
+		compatible = "brcm,bcm4339-fmac", "brcm,bcm4329-fmac";
+		reg = <1>;
+
+		brcm,drive-strength = <10>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&wlan_sleep_clk_pin>;
+	};
+};
+
+&smbb {
+	qcom,fast-charge-safe-current = <1500000>;
+	qcom,fast-charge-current-limit = <1500000>;
+	qcom,dc-current-limit = <1800000>;
+	qcom,fast-charge-safe-voltage = <4400000>;
+	qcom,fast-charge-high-threshold-voltage = <4350000>;
+	qcom,fast-charge-low-threshold-voltage = <3400000>;
+	qcom,auto-recharge-threshold-voltage = <4200000>;
+	qcom,minimum-input-voltage = <4300000>;
+};
+
+&tlmm {
+	blsp1_uart2_pin_a: blsp1-uart2-pin-active {
+		rx {
+			pins = "gpio5";
+			function = "blsp_uart2";
 
 			drive-strength = <2>;
+			bias-pull-up;
+		};
+
+		tx {
+			pins = "gpio4";
+			function = "blsp_uart2";
+
+			drive-strength = <4>;
 			bias-disable;
 		};
 	};
 
-	i2c@f9964000 {
-		status = "okay";
+	blsp2_uart7_pin_a: blsp2-uart7-pin-active {
+		tx {
+			pins = "gpio41";
+			function = "blsp_uart7";
 
-		clock-frequency = <355000>;
-		qcom,src-freq = <50000000>;
-
-		pinctrl-names = "default";
-		pinctrl-0 = <&i2c8_pins>;
+			drive-strength = <2>;
+			bias-disable;
+		};
 
-		synaptics@2c {
-			compatible = "syna,rmi4-i2c";
-			reg = <0x2c>;
+		rx {
+			pins = "gpio42";
+			function = "blsp_uart7";
 
-			interrupt-parent = <&tlmm>;
-			interrupts = <86 IRQ_TYPE_EDGE_FALLING>;
+			drive-strength = <2>;
+			bias-pull-up;
+		};
 
-			#address-cells = <1>;
-			#size-cells = <0>;
+		cts {
+			pins = "gpio43";
+			function = "blsp_uart7";
 
-			vdd-supply = <&pm8941_l22>;
-			vio-supply = <&pm8941_lvs3>;
+			drive-strength = <2>;
+			bias-pull-up;
+		};
 
-			pinctrl-names = "default";
-			pinctrl-0 = <&ts_int_pin>;
+		rts {
+			pins = "gpio44";
+			function = "blsp_uart7";
 
-			syna,startup-delay-ms = <10>;
+			drive-strength = <2>;
+			bias-disable;
+		};
+	};
 
-			rmi-f01@1 {
-				reg = <0x1>;
-				syna,nosleep = <1>;
-			};
+	i2c8_pins: i2c8 {
+		mux {
+			pins = "gpio47", "gpio48";
+			function = "blsp_i2c8";
 
-			rmi-f11@11 {
-				reg = <0x11>;
-				syna,f11-flip-x = <1>;
-				syna,sensor-type = <1>;
-			};
+			drive-strength = <2>;
+			bias-disable;
 		};
 	};
 
-	i2c@f9967000 {
-		status = "okay";
-		pinctrl-names = "default";
-		pinctrl-0 = <&i2c11_pins>;
-		clock-frequency = <355000>;
-		qcom,src-freq = <50000000>;
-
-		lp8566_wled: backlight@2c {
-			compatible = "ti,lp8556";
-			reg = <0x2c>;
-			power-supply = <&vreg_bl_vddio>;
-
-			bl-name = "backlight";
-			dev-ctrl = /bits/ 8 <0x05>;
-			init-brt = /bits/ 8 <0x3f>;
-			rom_a0h {
-				rom-addr = /bits/ 8 <0xa0>;
-				rom-val = /bits/ 8 <0xff>;
-			};
-			rom_a1h {
-				rom-addr = /bits/ 8 <0xa1>;
-				rom-val = /bits/ 8 <0x3f>;
-			};
-			rom_a2h {
-				rom-addr = /bits/ 8 <0xa2>;
-				rom-val = /bits/ 8 <0x20>;
-			};
-			rom_a3h {
-				rom-addr = /bits/ 8 <0xa3>;
-				rom-val = /bits/ 8 <0x5e>;
-			};
-			rom_a4h {
-				rom-addr = /bits/ 8 <0xa4>;
-				rom-val = /bits/ 8 <0x02>;
-			};
-			rom_a5h {
-				rom-addr = /bits/ 8 <0xa5>;
-				rom-val = /bits/ 8 <0x04>;
-			};
-			rom_a6h {
-				rom-addr = /bits/ 8 <0xa6>;
-				rom-val = /bits/ 8 <0x80>;
-			};
-			rom_a7h {
-				rom-addr = /bits/ 8 <0xa7>;
-				rom-val = /bits/ 8 <0xf7>;
-			};
-			rom_a9h {
-				rom-addr = /bits/ 8 <0xa9>;
-				rom-val = /bits/ 8 <0x80>;
-			};
-			rom_aah {
-				rom-addr = /bits/ 8 <0xaa>;
-				rom-val = /bits/ 8 <0x0f>;
-			};
-			rom_aeh {
-				rom-addr = /bits/ 8 <0xae>;
-				rom-val = /bits/ 8 <0x0f>;
-			};
+	i2c11_pins: i2c11 {
+		mux {
+			pins = "gpio83", "gpio84";
+			function = "blsp_i2c11";
+
+			drive-strength = <2>;
+			bias-disable;
 		};
 	};
-};
 
-&spmi_bus {
-	pm8941@0 {
-		charger@1000 {
-			qcom,fast-charge-safe-current = <1500000>;
-			qcom,fast-charge-current-limit = <1500000>;
-			qcom,dc-current-limit = <1800000>;
-			qcom,fast-charge-safe-voltage = <4400000>;
-			qcom,fast-charge-high-threshold-voltage = <4350000>;
-			qcom,fast-charge-low-threshold-voltage = <3400000>;
-			qcom,auto-recharge-threshold-voltage = <4200000>;
-			qcom,minimum-input-voltage = <4300000>;
+	lcd_backlight_en_pin_a: lcd-backlight-vddio {
+		pins = "gpio69";
+		drive-strength = <10>;
+		output-low;
+		bias-disable;
+	};
+
+	sdhc1_pin_a: sdhc1-pin-active {
+		clk {
+			pins = "sdc1_clk";
+			drive-strength = <16>;
+			bias-disable;
 		};
 
-		gpios@c000 {
-			gpio_keys_pin_a: gpio-keys-active {
-				pins = "gpio2", "gpio5";
-				function = "normal";
+		cmd-data {
+			pins = "sdc1_cmd", "sdc1_data";
+			drive-strength = <10>;
+			bias-pull-up;
+		};
+	};
 
-				bias-pull-up;
-				power-source = <PM8941_GPIO_S3>;
-			};
+	sdhc2_cd_pin_a: sdhc2-cd-pin-active {
+		pins = "gpio62";
+		function = "gpio";
 
-			bt_reg_on_pin: bt-reg-on {
-				pins = "gpio16";
-				function = "normal";
+		drive-strength = <2>;
+		bias-disable;
+		};
 
-				output-low;
-				power-source = <PM8941_GPIO_S3>;
-			};
+	sdhc2_pin_a: sdhc2-pin-active {
+		clk {
+			pins = "sdc2_clk";
+			drive-strength = <6>;
+			bias-disable;
+		};
 
-			wlan_sleep_clk_pin: wl-sleep-clk {
-				pins = "gpio17";
-				function = "func2";
+		cmd-data {
+			pins = "sdc2_cmd", "sdc2_data";
+			drive-strength = <6>;
+			bias-pull-up;
+		};
+	};
 
-				output-high;
-				power-source = <PM8941_GPIO_S3>;
-			};
+	sdhc3_pin_a: sdhc3-pin-active {
+		clk {
+			pins = "gpio40";
+			function = "sdc3";
 
-			wlan_regulator_pin: wl-reg-active {
-				pins = "gpio18";
-				function = "normal";
+			drive-strength = <10>;
+			bias-disable;
+		};
 
-				bias-disable;
-				power-source = <PM8941_GPIO_S3>;
-			};
+		cmd {
+			pins = "gpio39";
+			function = "sdc3";
 
-			lcd_dcdc_en_pin_a: lcd-dcdc-en-active {
-				pins = "gpio20";
-				function = "normal";
+			drive-strength = <10>;
+			bias-pull-up;
+		};
 
-				bias-disable;
-				power-source = <PM8941_GPIO_S3>;
-				input-disable;
-				output-low;
-			};
+		data {
+			pins = "gpio35", "gpio36", "gpio37", "gpio38";
+			function = "sdc3";
 
+			drive-strength = <10>;
+			bias-pull-up;
 		};
+	};
 
-		coincell@2800 {
-			status = "okay";
-			qcom,rset-ohms = <2100>;
-			qcom,vset-millivolts = <3000>;
+	ts_int_pin: synaptics {
+		pin {
+			pins = "gpio86";
+			function = "gpio";
+
+			drive-strength = <2>;
+			bias-disable;
+			input-enable;
 		};
 	};
+
+	bt_host_wake_pin: bt-host-wake {
+		pins = "gpio95";
+		function = "gpio";
+
+		drive-strength = <2>;
+		bias-disable;
+		output-low;
+	};
+
+	bt_dev_wake_pin: bt-dev-wake {
+		pins = "gpio96";
+		function = "gpio";
+
+		drive-strength = <2>;
+		bias-disable;
+	};
 };
-- 
2.35.1



