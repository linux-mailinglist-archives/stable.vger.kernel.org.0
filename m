Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C9C593E6E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345083AbiHOUn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346701AbiHOUly (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:41:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DAF37FAB;
        Mon, 15 Aug 2022 12:07:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3621E61019;
        Mon, 15 Aug 2022 19:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3FAC433C1;
        Mon, 15 Aug 2022 19:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590446;
        bh=xcqoyNeCZGUKnAm0ZNoqzjIJy8FHk8pmDFlWwIkilg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AwkhyNfr9p91sLnXIZzDhEXMWAHRrystBBwu2EB+0hv+VeyEORDGa3wUpAWSo68mP
         8+TsiPXaV9tF0G8O5BscPFdCy2YP+muDAc9zeCpyI7qPk0sdMzorsYHayqMdqGJwgJ
         IaCsmYiMKMcVQligy/KOyreaUPk7Ry5cjGx5sjXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0232/1095] ARM: dts: qcom-apq8074-dragonboard: Use &labels
Date:   Mon, 15 Aug 2022 19:53:51 +0200
Message-Id: <20220815180439.347551436@linuxfoundation.org>
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

[ Upstream commit 9f440d17e2309c7d14eba0898c775be6d6e6d6b7 ]

Use &labels to align with the style used in new DTS and apply tiny
style fixes.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
[bjorn: Rebased ontop of Krzysztof's underscore fixes]
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220415115633.575010-9-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm/boot/dts/qcom-apq8074-dragonboard.dts | 605 +++++++++---------
 arch/arm/boot/dts/qcom-msm8974.dtsi           |   2 +-
 2 files changed, 296 insertions(+), 311 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
index 9076a24408c6..f114debe4d95 100644
--- a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
+++ b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
@@ -16,331 +16,316 @@ aliases {
 	chosen {
 		stdout-path = "serial0:115200n8";
 	};
+};
+
+&blsp1_uart2 {
+	status = "okay";
+};
+
+&blsp2_i2c5 {
+	status = "okay";
+	clock-frequency = <200000>;
+
+	pinctrl-0 = <&i2c11_pins>;
+	pinctrl-names = "default";
+
+	eeprom: eeprom@52 {
+		compatible = "atmel,24c128";
+		reg = <0x52>;
+		pagesize = <32>;
+		read-only;
+	};
+};
+
+&otg {
+	status = "okay";
 
-	soc {
-		serial@f991e000 {
+	phys = <&usb_hs2_phy>;
+	phy-select = <&tcsr 0xb000 1>;
+	extcon = <&smbb>, <&usb_id>;
+	vbus-supply = <&chg_otg>;
+	hnp-disable;
+	srp-disable;
+	adp-disable;
+
+	ulpi {
+		phy@b {
 			status = "okay";
+			v3p3-supply = <&pm8941_l24>;
+			v1p8-supply = <&pm8941_l6>;
+			extcon = <&smbb>;
+			qcom,init-seq = /bits/ 8 <0x1 0x63>;
+		};
+	};
+};
+
+&rpm_requests {
+	pm8841-regulators {
+		pm8841_s1: s1 {
+			regulator-min-microvolt = <675000>;
+			regulator-max-microvolt = <1050000>;
 		};
 
-		sdhci@f9824900 {
-			bus-width = <8>;
-			non-removable;
-			status = "okay";
+		pm8841_s2: s2 {
+			regulator-min-microvolt = <500000>;
+			regulator-max-microvolt = <1050000>;
+		};
+
+		pm8841_s3: s3 {
+			regulator-min-microvolt = <500000>;
+			regulator-max-microvolt = <1050000>;
+		};
 
-			vmmc-supply = <&pm8941_l20>;
-			vqmmc-supply = <&pm8941_s3>;
+		pm8841_s4: s4 {
+			regulator-min-microvolt = <500000>;
+			regulator-max-microvolt = <1050000>;
+		};
+	};
 
-			pinctrl-names = "default";
-			pinctrl-0 = <&sdhc1_pin_a>;
+	pm8941-regulators {
+		vdd_l1_l3-supply = <&pm8941_s1>;
+		vdd_l2_lvs1_2_3-supply = <&pm8941_s3>;
+		vdd_l4_l11-supply = <&pm8941_s1>;
+		vdd_l5_l7-supply = <&pm8941_s2>;
+		vdd_l6_l12_l14_l15-supply = <&pm8941_s2>;
+		vin_5vs-supply = <&pm8941_5v>;
+
+		pm8941_s1: s1 {
+			regulator-min-microvolt = <1300000>;
+			regulator-max-microvolt = <1300000>;
+			regulator-always-on;
+			regulator-boot-on;
 		};
 
-		sdhci@f98a4900 {
-			cd-gpios = <&tlmm 62 0x1>;
-			pinctrl-names = "default";
-			pinctrl-0 = <&sdhc2_pin_a>, <&sdhc2_cd_pin_a>;
-			bus-width = <4>;
-			status = "okay";
+		pm8941_s2: s2 {
+			regulator-min-microvolt = <2150000>;
+			regulator-max-microvolt = <2150000>;
+			regulator-boot-on;
+		};
 
-			vmmc-supply = <&pm8941_l21>;
-			vqmmc-supply = <&pm8941_l13>;
+		pm8941_s3: s3 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-always-on;
+			regulator-boot-on;
 		};
 
-		usb@f9a55000 {
-			status = "okay";
-			phys = <&usb_hs2_phy>;
-			phy-select = <&tcsr 0xb000 1>;
-			extcon = <&smbb>, <&usb_id>;
-			vbus-supply = <&chg_otg>;
-			hnp-disable;
-			srp-disable;
-			adp-disable;
-			ulpi {
-				phy@b {
-					status = "okay";
-					v3p3-supply = <&pm8941_l24>;
-					v1p8-supply = <&pm8941_l6>;
-					extcon = <&smbb>;
-					qcom,init-seq = /bits/ 8 <0x1 0x63>;
-				};
-			};
-		};
-
-
-		pinctrl@fd510000 {
-			i2c11_pins: i2c11 {
-				mux {
-					pins = "gpio83", "gpio84";
-					function = "blsp_i2c11";
-				};
-			};
-
-			spi8_default: spi8_default {
-				mosi {
-					pins = "gpio45";
-					function = "blsp_spi8";
-				};
-				miso {
-					pins = "gpio46";
-					function = "blsp_spi8";
-				};
-				cs {
-					pins = "gpio47";
-					function = "blsp_spi8";
-				};
-				clk {
-					pins = "gpio48";
-					function = "blsp_spi8";
-				};
-			};
-
-			sdhc1_pin_a: sdhc1-pin-active {
-				clk {
-					pins = "sdc1_clk";
-					drive-strength = <16>;
-					bias-disable;
-				};
-
-				cmd-data {
-					pins = "sdc1_cmd", "sdc1_data";
-					drive-strength = <10>;
-					bias-pull-up;
-				};
-			};
-
-			sdhc2_cd_pin_a: sdhc2-cd-pin-active {
-				pins = "gpio62";
-				function = "gpio";
-
-				drive-strength = <2>;
-				bias-disable;
-			};
-
-			sdhc2_pin_a: sdhc2-pin-active {
-				clk {
-					pins = "sdc2_clk";
-					drive-strength = <10>;
-					bias-disable;
-				};
-
-				cmd-data {
-					pins = "sdc2_cmd", "sdc2_data";
-					drive-strength = <6>;
-					bias-pull-up;
-				};
-			};
-		};
-
-		i2c@f9967000 {
-			status = "okay";
-			clock-frequency = <200000>;
-			pinctrl-0 = <&i2c11_pins>;
-			pinctrl-names = "default";
+		pm8941_l1: l1 {
+			regulator-min-microvolt = <1225000>;
+			regulator-max-microvolt = <1225000>;
+			regulator-always-on;
+			regulator-boot-on;
+		};
+
+		pm8941_l2: l2 {
+			regulator-min-microvolt = <1200000>;
+			regulator-max-microvolt = <1200000>;
+		};
+
+		pm8941_l3: l3 {
+			regulator-min-microvolt = <1225000>;
+			regulator-max-microvolt = <1225000>;
+		};
+
+		pm8941_l4: l4 {
+			regulator-min-microvolt = <1225000>;
+			regulator-max-microvolt = <1225000>;
+		};
+
+		pm8941_l5: l5 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		pm8941_l6: l6 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-boot-on;
+		};
+
+		pm8941_l7: l7 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-boot-on;
+		};
+
+		pm8941_l8: l8 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		pm8941_l9: l9 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <2950000>;
+		};
+
+		pm8941_l10: l10 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-always-on;
+		};
+
+		pm8941_l11: l11 {
+			regulator-min-microvolt = <1300000>;
+			regulator-max-microvolt = <1300000>;
+		};
+
+		pm8941_l12: l12 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-always-on;
+			regulator-boot-on;
+		};
+
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
+			regulator-min-microvolt = <2700000>;
+			regulator-max-microvolt = <2700000>;
+		};
+
+		pm8941_l18: l18 {
+			regulator-min-microvolt = <2850000>;
+			regulator-max-microvolt = <2850000>;
+		};
+
+		pm8941_l19: l19 {
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
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
+			regulator-max-microvolt = <3000000>;
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
+	};
+};
+
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
+	cd-gpios = <&tlmm 62 0x1>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&sdhc2_pin_a>, <&sdhc2_cd_pin_a>;
+
+	vmmc-supply = <&pm8941_l21>;
+	vqmmc-supply = <&pm8941_l13>;
+};
+
+&tlmm {
+	i2c11_pins: i2c11 {
+		mux {
+			pins = "gpio83", "gpio84";
+			function = "blsp_i2c11";
+		};
+	};
+
+	spi8_default: spi8_default {
+		mosi {
+			pins = "gpio45";
+			function = "blsp_spi8";
+		};
+		miso {
+			pins = "gpio46";
+			function = "blsp_spi8";
+		};
+		cs {
+			pins = "gpio47";
+			function = "blsp_spi8";
+		};
+		clk {
+			pins = "gpio48";
+			function = "blsp_spi8";
+		};
+	};
+
+	sdhc1_pin_a: sdhc1-pin-active {
+		clk {
+			pins = "sdc1_clk";
+			drive-strength = <16>;
+			bias-disable;
+		};
 
-			eeprom: eeprom@52 {
-				compatible = "atmel,24c128";
-				reg = <0x52>;
-				pagesize = <32>;
-				read-only;
-			};
+		cmd-data {
+			pins = "sdc1_cmd", "sdc1_data";
+			drive-strength = <10>;
+			bias-pull-up;
 		};
 	};
 
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
-						regulator-min-microvolt = <500000>;
-						regulator-max-microvolt = <1050000>;
-					};
-
-					s4 {
-						regulator-min-microvolt = <500000>;
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
-					vin_5vs-supply = <&pm8941_5v>;
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
-						regulator-max-microvolt = <1800000>;
-						regulator-always-on;
-					};
-
-					l11 {
-						regulator-min-microvolt = <1300000>;
-						regulator-max-microvolt = <1300000>;
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
-						regulator-min-microvolt = <3300000>;
-						regulator-max-microvolt = <3300000>;
-						regulator-always-on;
-					};
-
-					l20 {
-						regulator-min-microvolt = <2950000>;
-						regulator-max-microvolt = <2950000>;
-
-						regulator-allow-set-load;
-						regulator-boot-on;
-						regulator-system-load = <200000>;
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
+	sdhc2_cd_pin_a: sdhc2-cd-pin-active {
+		pins = "gpio62";
+		function = "gpio";
+
+		drive-strength = <2>;
+		bias-disable;
+	};
+
+	sdhc2_pin_a: sdhc2-pin-active {
+		clk {
+			pins = "sdc2_clk";
+			drive-strength = <10>;
+			bias-disable;
+		};
+
+		cmd-data {
+			pins = "sdc2_cmd", "sdc2_data";
+			drive-strength = <6>;
+			bias-pull-up;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 2182d2755926..ad05f0665035 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -1612,7 +1612,7 @@ rpm {
 			qcom,ipc = <&apcs 8 0>;
 			qcom,smd-edge = <15>;
 
-			rpm-requests {
+			rpm_requests: rpm-requests {
 				compatible = "qcom,rpm-msm8974";
 				qcom,smd-channels = "rpm_requests";
 
-- 
2.35.1



