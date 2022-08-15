Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3A7593E67
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344736AbiHOUnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346006AbiHOUkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:40:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44785AF0EC;
        Mon, 15 Aug 2022 12:07:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32B94612D3;
        Mon, 15 Aug 2022 19:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A4DC433D7;
        Mon, 15 Aug 2022 19:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590449;
        bh=nwGTDbmhz7lz1hU/LdXHRNjHbpqmF4gNeTYuKSTzrI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ezfxC/7y1adHiYuSFAMP53UFniW0H+KyJHYu1/Q5SqsdQ8o+wcbW8IjYaunPpgHsf
         XYouRqT75S45pwJtZasHtB0/nQFTCjGAT1eRlywiMXn3jJzGpHn+qcb30X/rKbWZoD
         hHdvRP9fLDcl+V39l9bP7KKSGIWksLXBqBwIk0cE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0233/1095] ARM: dts: qcom-msm8974-fp2: Use &labels
Date:   Mon, 15 Aug 2022 19:53:52 +0200
Message-Id: <20220815180439.394296060@linuxfoundation.org>
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

[ Upstream commit 409ab7dc57c41d9db54d221f4d247e229ba34cf9 ]

Use &labels to align with the style used in new DTS and apply tiny
style fixes.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
[bjorn: Rebased on top of Krzysztof underscore fixes]
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220415115633.575010-10-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom-msm8974-fairphone-fp2.dts   | 577 +++++++++---------
 arch/arm/boot/dts/qcom-msm8974.dtsi           |   2 +-
 2 files changed, 276 insertions(+), 303 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts b/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
index 1e947bab06b6..38e48ea021d9 100644
--- a/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
@@ -5,7 +5,6 @@
 #include <dt-bindings/input/input.h>
 #include <dt-bindings/pinctrl/qcom,pmic-gpio.h>
 
-
 / {
 	model = "Fairphone 2";
 	compatible = "fairphone,fp2", "qcom,msm8974";
@@ -54,356 +53,330 @@ vibrator {
 		enable-gpios = <&tlmm 86 GPIO_ACTIVE_HIGH>;
 		vcc-supply = <&pm8941_l18>;
 	};
+};
+
+&blsp1_uart2 {
+	status = "okay";
+};
+
+&imem {
+	status = "okay";
+
+	reboot-mode {
+		mode-normal	= <0x77665501>;
+		mode-bootloader	= <0x77665500>;
+		mode-recovery	= <0x77665502>;
+	};
+};
+
+&otg {
+	status = "okay";
+
+	phys = <&usb_hs1_phy>;
+	phy-select = <&tcsr 0xb000 0>;
+	extcon = <&smbb>, <&usb_id>;
+	vbus-supply = <&chg_otg>;
 
-	smd {
-		rpm {
-			rpm-requests {
-				pm8841-regulators {
-					s1 {
-						regulator-min-microvolt = <675000>;
-						regulator-max-microvolt = <1050000>;
-					};
-
-					s2 {
-						regulator-min-microvolt = <500000>;
-						regulator-max-microvolt = <1050000>;
-					};
-
-					s3 {
-						regulator-min-microvolt = <1050000>;
-						regulator-max-microvolt = <1050000>;
-					};
-				};
-
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
-
-						regulator-always-on;
-						regulator-boot-on;
-					};
-
-					s2 {
-						regulator-min-microvolt = <2150000>;
-						regulator-max-microvolt = <2150000>;
-
-						regulator-boot-on;
-					};
-
-					s3 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <1800000>;
-
-						regulator-always-on;
-						regulator-boot-on;
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
-						regulator-min-microvolt = <1225000>;
-						regulator-max-microvolt = <1225000>;
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
-					l10 {
-						regulator-min-microvolt = <1800000>;
-						regulator-max-microvolt = <2950000>;
-					};
-
-					l11 {
-						regulator-min-microvolt = <1225000>;
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
-						regulator-min-microvolt = <2850000>;
-						regulator-max-microvolt = <2850000>;
-					};
-
-					l18 {
-						regulator-min-microvolt = <2850000>;
-						regulator-max-microvolt = <2850000>;
-					};
-
-					l19 {
-						regulator-min-microvolt = <2900000>;
-						regulator-max-microvolt = <3350000>;
-					};
-
-					l20 {
-						regulator-min-microvolt = <2950000>;
-						regulator-max-microvolt = <2950000>;
-
-						regulator-boot-on;
-						regulator-system-load = <200000>;
-						regulator-allow-set-load;
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
-						regulator-max-microvolt = <3300000>;
-					};
-
-					l23 {
-						regulator-min-microvolt = <3000000>;
-						regulator-max-microvolt = <3000000>;
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
+	hnp-disable;
+	srp-disable;
+	adp-disable;
+
+	ulpi {
+		phy@a {
+			status = "okay";
+
+			v1p8-supply = <&pm8941_l6>;
+			v3p3-supply = <&pm8941_l24>;
+
+			extcon = <&smbb>;
+			qcom,init-seq = /bits/ 8 <0x1 0x64>;
 		};
 	};
 };
 
-&soc {
-	serial@f991e000 {
-		status = "okay";
+&pm8941_gpios {
+	gpio_keys_pin_a: gpio-keys-active {
+		pins = "gpio1", "gpio2", "gpio5";
+		function = "normal";
+
+		bias-pull-up;
+		power-source = <PM8941_GPIO_S3>;
 	};
+};
 
-	remoteproc@fb21b000 {
-		status = "okay";
+&pronto {
+	status = "okay";
 
-		vddmx-supply = <&pm8841_s1>;
-		vddcx-supply = <&pm8841_s2>;
+	vddmx-supply = <&pm8841_s1>;
+	vddcx-supply = <&pm8841_s2>;
 
-		pinctrl-names = "default";
-		pinctrl-0 = <&wcnss_pin_a>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&wcnss_pin_a>;
 
-		smd-edge {
-			qcom,remote-pid = <4>;
-			label = "pronto";
+	smd-edge {
+		qcom,remote-pid = <4>;
+		label = "pronto";
 
-			wcnss {
-				status = "okay";
-			};
+		wcnss {
+			status = "okay";
 		};
 	};
+};
+
+&rpm_requests {
+	pm8841-regulators {
+		pm8841_s1: s1 {
+			regulator-min-microvolt = <675000>;
+			regulator-max-microvolt = <1050000>;
+		};
 
-	pinctrl@fd510000 {
-		sdhc1_pin_a: sdhc1-pin-active {
-			clk {
-				pins = "sdc1_clk";
-				drive-strength = <16>;
-				bias-disable;
-			};
+		pm8841_s2: s2 {
+			regulator-min-microvolt = <500000>;
+			regulator-max-microvolt = <1050000>;
+		};
 
-			cmd-data {
-				pins = "sdc1_cmd", "sdc1_data";
-				drive-strength = <10>;
-				bias-pull-up;
-			};
+		pm8841_s3: s3 {
+			regulator-min-microvolt = <1050000>;
+			regulator-max-microvolt = <1050000>;
 		};
+	};
 
-		sdhc2_pin_a: sdhc2-pin-active {
-			clk {
-				pins = "sdc2_clk";
-				drive-strength = <10>;
-				bias-disable;
-			};
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
 
-			cmd-data {
-				pins = "sdc2_cmd", "sdc2_data";
-				drive-strength = <6>;
-				bias-pull-up;
-			};
+		pm8941_s2: s2 {
+			regulator-min-microvolt = <2150000>;
+			regulator-max-microvolt = <2150000>;
+			regulator-boot-on;
 		};
 
-		wcnss_pin_a: wcnss-pin-active {
-			wlan {
-				pins =  "gpio36", "gpio37", "gpio38", "gpio39", "gpio40";
-				function = "wlan";
+		pm8941_s3: s3 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-always-on;
+			regulator-boot-on;
+		};
 
-				drive-strength = <6>;
-				bias-pull-down;
-			};
+		pm8941_l1: l1 {
+			regulator-min-microvolt = <1225000>;
+			regulator-max-microvolt = <1225000>;
+			regulator-always-on;
+			regulator-boot-on;
+		};
 
-			bt {
-				pins = "gpio35", "gpio43", "gpio44";
-				function = "bt";
+		pm8941_l2: l2 {
+			regulator-min-microvolt = <1200000>;
+			regulator-max-microvolt = <1200000>;
+		};
 
-				drive-strength = <2>;
-				bias-pull-down;
-			};
+		pm8941_l3: l3 {
+			regulator-min-microvolt = <1225000>;
+			regulator-max-microvolt = <1225000>;
+		};
 
-			fm {
-				pins = "gpio41", "gpio42";
-				function = "fm";
+		pm8941_l4: l4 {
+			regulator-min-microvolt = <1225000>;
+			regulator-max-microvolt = <1225000>;
+		};
 
-				drive-strength = <2>;
-				bias-pull-down;
-			};
+		pm8941_l5: l5 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
 		};
-	};
 
-	sdhci@f9824900 {
-		status = "okay";
+		pm8941_l6: l6 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-boot-on;
+		};
 
-		vmmc-supply = <&pm8941_l20>;
-		vqmmc-supply = <&pm8941_s3>;
+		pm8941_l7: l7 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-boot-on;
+		};
 
-		bus-width = <8>;
-		non-removable;
+		pm8941_l8: l8 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
 
-		pinctrl-names = "default";
-		pinctrl-0 = <&sdhc1_pin_a>;
-	};
+		pm8941_l9: l9 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <2950000>;
+		};
 
-	sdhci@f98a4900 {
-		status = "okay";
+		pm8941_l10: l10 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <2950000>;
+		};
 
-		vmmc-supply = <&pm8941_l21>;
-		vqmmc-supply = <&pm8941_l13>;
+		pm8941_l11: l11 {
+			regulator-min-microvolt = <1225000>;
+			regulator-max-microvolt = <1350000>;
+		};
 
-		bus-width = <4>;
+		pm8941_l12: l12 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-always-on;
+			regulator-boot-on;
+		};
 
-		pinctrl-names = "default";
-		pinctrl-0 = <&sdhc2_pin_a>;
+		pm8941_l13: l13 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <2950000>;
+			regulator-boot-on;
+		};
+
+		pm8941_l14: l14 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		pm8941_l15: l15 {
+			regulator-min-microvolt = <2050000>;
+			regulator-max-microvolt = <2050000>;
+		};
+
+		pm8941_l16: l16 {
+			regulator-min-microvolt = <2700000>;
+			regulator-max-microvolt = <2700000>;
+		};
+
+		pm8941_l17: l17 {
+			regulator-min-microvolt = <2850000>;
+			regulator-max-microvolt = <2850000>;
+		};
+
+		pm8941_l18: l18 {
+			regulator-min-microvolt = <2850000>;
+			regulator-max-microvolt = <2850000>;
+		};
+
+		pm8941_l19: l19 {
+			regulator-min-microvolt = <2900000>;
+			regulator-max-microvolt = <3350000>;
+		};
+
+		pm8941_l20: l20 {
+			regulator-min-microvolt = <2950000>;
+			regulator-max-microvolt = <2950000>;
+			regulator-system-load = <200000>;
+			regulator-allow-set-load;
+			regulator-boot-on;
+		};
+
+		pm8941_l21: l21 {
+			regulator-min-microvolt = <2950000>;
+			regulator-max-microvolt = <2950000>;
+			regulator-boot-on;
+		};
+
+		pm8941_l22: l22 {
+			regulator-min-microvolt = <3000000>;
+			regulator-max-microvolt = <3300000>;
+		};
+
+		pm8941_l23: l23 {
+			regulator-min-microvolt = <3000000>;
+			regulator-max-microvolt = <3000000>;
+		};
+
+		pm8941_l24: l24 {
+			regulator-min-microvolt = <3075000>;
+			regulator-max-microvolt = <3075000>;
+			regulator-boot-on;
+		};
 	};
+};
 
-	usb@f9a55000 {
-		status = "okay";
+&sdhc_1 {
+	status = "okay";
 
-		phys = <&usb_hs1_phy>;
-		phy-select = <&tcsr 0xb000 0>;
-		extcon = <&smbb>, <&usb_id>;
-		vbus-supply = <&chg_otg>;
+	vmmc-supply = <&pm8941_l20>;
+	vqmmc-supply = <&pm8941_s3>;
 
-		hnp-disable;
-		srp-disable;
-		adp-disable;
+	pinctrl-names = "default";
+	pinctrl-0 = <&sdhc1_pin_a>;
+};
+
+&sdhc_2 {
+	status = "okay";
 
-		ulpi {
-			phy@a {
-				status = "okay";
+	vmmc-supply = <&pm8941_l21>;
+	vqmmc-supply = <&pm8941_l13>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&sdhc2_pin_a>;
+};
 
-				v1p8-supply = <&pm8941_l6>;
-				v3p3-supply = <&pm8941_l24>;
+&tlmm {
+	sdhc1_pin_a: sdhc1-pin-active {
+		clk {
+			pins = "sdc1_clk";
+			drive-strength = <16>;
+			bias-disable;
+		};
 
-				extcon = <&smbb>;
-				qcom,init-seq = /bits/ 8 <0x1 0x64>;
-			};
+		cmd-data {
+			pins = "sdc1_cmd", "sdc1_data";
+			drive-strength = <10>;
+			bias-pull-up;
 		};
 	};
 
-	imem@fe805000 {
-		status = "okay";
+	sdhc2_pin_a: sdhc2-pin-active {
+		clk {
+			pins = "sdc2_clk";
+			drive-strength = <10>;
+			bias-disable;
+		};
 
-		reboot-mode {
-			mode-normal	= <0x77665501>;
-			mode-bootloader	= <0x77665500>;
-			mode-recovery	= <0x77665502>;
+		cmd-data {
+			pins = "sdc2_cmd", "sdc2_data";
+			drive-strength = <6>;
+			bias-pull-up;
 		};
 	};
-};
 
-&spmi_bus {
-	pm8941@0 {
-		gpios@c000 {
-			gpio_keys_pin_a: gpio-keys-active {
-				pins = "gpio1", "gpio2", "gpio5";
-				function = "normal";
+	wcnss_pin_a: wcnss-pin-active {
+		wlan {
+			pins =  "gpio36", "gpio37", "gpio38", "gpio39", "gpio40";
+			function = "wlan";
+
+			drive-strength = <6>;
+			bias-pull-down;
+		};
+
+		bt {
+			pins = "gpio35", "gpio43", "gpio44";
+			function = "bt";
+
+			drive-strength = <2>;
+			bias-pull-down;
+		};
+
+		fm {
+			pins = "gpio41", "gpio42";
+			function = "fm";
 
-				bias-pull-up;
-				power-source = <PM8941_GPIO_S3>;
-			};
+			drive-strength = <2>;
+			bias-pull-down;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index ad05f0665035..f1278d39ff6c 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -1592,7 +1592,7 @@ dsi0_phy: dsi-phy@fd922a00 {
 			};
 		};
 
-		imem@fe805000 {
+		imem: imem@fe805000 {
 			status = "disabled";
 			compatible = "syscon", "simple-mfd";
 			reg = <0xfe805000 0x1000>;
-- 
2.35.1



