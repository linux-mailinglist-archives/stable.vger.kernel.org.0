Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835E7593E6D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345063AbiHOUn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345710AbiHOUju (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:39:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95758ABF1C;
        Mon, 15 Aug 2022 12:07:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD8B6612CD;
        Mon, 15 Aug 2022 19:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B2EC433C1;
        Mon, 15 Aug 2022 19:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590434;
        bh=L3ApvKRzOF3hbSDCVnYDFeM8CBFfmNYx6ZzEKkNECgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/MWAWdYYvgwjwgrqyyZhxtkT6nB4j9x5W7vyp6SHZV04klyEf67K+Glcfy58TbA4
         UPM/j503/Jm9W3RcfUyrvtot9Fz5dvl58Eb44DlBeyin+9O6sA4tWCqUEcDwYUkJP/
         bsLI4QBUV6ZAJ31mw0sR1gCRdKhbPLMzRmLeWtqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0231/1095] ARM: dts: qcom-msm8974*: Rename msmgpio to tlmm
Date:   Mon, 15 Aug 2022 19:53:50 +0200
Message-Id: <20220815180439.307388299@linuxfoundation.org>
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

[ Upstream commit 087c9704d5bb322dd5db52938416caeaf4cdc3c3 ]

Rename the label to match new the style used in newer DTs.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220415115633.575010-8-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm/boot/dts/qcom-apq8074-dragonboard.dts |  2 +-
 .../boot/dts/qcom-msm8974-fairphone-fp2.dts   |  2 +-
 .../qcom-msm8974-lge-nexus5-hammerhead.dts    | 18 ++++++++---------
 .../boot/dts/qcom-msm8974-samsung-klte.dts    | 20 +++++++++----------
 .../dts/qcom-msm8974-sony-xperia-amami.dts    |  2 +-
 .../dts/qcom-msm8974-sony-xperia-castor.dts   | 10 +++++-----
 .../dts/qcom-msm8974-sony-xperia-honami.dts   |  4 ++--
 arch/arm/boot/dts/qcom-msm8974.dtsi           |  4 ++--
 8 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
index e2b4e4fc6377..9076a24408c6 100644
--- a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
+++ b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
@@ -35,7 +35,7 @@ sdhci@f9824900 {
 		};
 
 		sdhci@f98a4900 {
-			cd-gpios = <&msmgpio 62 0x1>;
+			cd-gpios = <&tlmm 62 0x1>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&sdhc2_pin_a>, <&sdhc2_cd_pin_a>;
 			bus-width = <4>;
diff --git a/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts b/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
index 9dbfc9f8646a..1e947bab06b6 100644
--- a/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
@@ -51,7 +51,7 @@ volume-up {
 
 	vibrator {
 		compatible = "gpio-vibrator";
-		enable-gpios = <&msmgpio 86 GPIO_ACTIVE_HIGH>;
+		enable-gpios = <&tlmm 86 GPIO_ACTIVE_HIGH>;
 		vcc-supply = <&pm8941_l18>;
 	};
 
diff --git a/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts b/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts
index dd2d0647d4be..4154ffb207ac 100644
--- a/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts
@@ -250,7 +250,7 @@ vreg_wlan: wlan-regulator {
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
 
-		gpio = <&msmgpio 26 GPIO_ACTIVE_HIGH>;
+		gpio = <&tlmm 26 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 
 		pinctrl-names = "default";
@@ -482,9 +482,9 @@ bluetooth {
 			pinctrl-names = "default";
 			pinctrl-0 = <&bt_pin>;
 
-			host-wakeup-gpios = <&msmgpio 42 GPIO_ACTIVE_HIGH>;
-			device-wakeup-gpios = <&msmgpio 62 GPIO_ACTIVE_HIGH>;
-			shutdown-gpios = <&msmgpio 41 GPIO_ACTIVE_HIGH>;
+			host-wakeup-gpios = <&tlmm 42 GPIO_ACTIVE_HIGH>;
+			device-wakeup-gpios = <&tlmm 62 GPIO_ACTIVE_HIGH>;
+			shutdown-gpios = <&tlmm 41 GPIO_ACTIVE_HIGH>;
 		};
 	};
 
@@ -522,7 +522,7 @@ i2c@f9968000 {
 		mpu6515@68 {
 			compatible = "invensense,mpu6515";
 			reg = <0x68>;
-			interrupts-extended = <&msmgpio 73 IRQ_TYPE_EDGE_FALLING>;
+			interrupts-extended = <&tlmm 73 IRQ_TYPE_EDGE_FALLING>;
 			vddio-supply = <&pm8941_lvs1>;
 
 			pinctrl-names = "default";
@@ -538,7 +538,7 @@ i2c-gate {
 				ak8963@f {
 					compatible = "asahi-kasei,ak8963";
 					reg = <0x0f>;
-					gpios = <&msmgpio 67 0>;
+					gpios = <&tlmm 67 0>;
 					vid-supply = <&pm8941_lvs1>;
 					vdd-supply = <&pm8941_l17>;
 				};
@@ -577,7 +577,7 @@ fuelgauge: max17048@36 {
 			maxim,double-soc;
 			maxim,rcomp = /bits/ 8 <0x4d>;
 
-			interrupt-parent = <&msmgpio>;
+			interrupt-parent = <&tlmm>;
 			interrupts = <9 IRQ_TYPE_LEVEL_LOW>;
 
 			pinctrl-names = "default";
@@ -600,7 +600,7 @@ synaptics@70 {
 			compatible = "syna,rmi4-i2c";
 			reg = <0x70>;
 
-			interrupts-extended = <&msmgpio 5 IRQ_TYPE_EDGE_FALLING>;
+			interrupts-extended = <&tlmm 5 IRQ_TYPE_EDGE_FALLING>;
 			vdd-supply = <&pm8941_l22>;
 			vio-supply = <&pm8941_lvs3>;
 
@@ -632,7 +632,7 @@ i2c@f9925000 {
 		avago_apds993@39 {
 			compatible = "avago,apds9930";
 			reg = <0x39>;
-			interrupts-extended = <&msmgpio 61 IRQ_TYPE_EDGE_FALLING>;
+			interrupts-extended = <&tlmm 61 IRQ_TYPE_EDGE_FALLING>;
 			vdd-supply = <&pm8941_l17>;
 			vddio-supply = <&pm8941_lvs1>;
 			led-max-microamp = <100000>;
diff --git a/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts b/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
index 3ee2508b20fb..60244e0c37ba 100644
--- a/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
@@ -247,8 +247,8 @@ i2c-gpio-touchkey {
 		compatible = "i2c-gpio";
 		#address-cells = <1>;
 		#size-cells = <0>;
-		sda-gpios = <&msmgpio 95 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
-		scl-gpios = <&msmgpio 96 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+		sda-gpios = <&tlmm 95 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+		scl-gpios = <&tlmm 96 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2c_touchkey_pins>;
 
@@ -272,8 +272,8 @@ i2c-gpio-led {
 		compatible = "i2c-gpio";
 		#address-cells = <1>;
 		#size-cells = <0>;
-		scl-gpios = <&msmgpio 121 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
-		sda-gpios = <&msmgpio 120 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+		scl-gpios = <&tlmm 121 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+		sda-gpios = <&tlmm 120 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2c_led_gpioex_pins>;
 
@@ -291,7 +291,7 @@ gpio_expander: gpio@20 {
 			pinctrl-names = "default";
 			pinctrl-0 = <&gpioex_pin>;
 
-			reset-gpios = <&msmgpio 145 GPIO_ACTIVE_LOW>;
+			reset-gpios = <&tlmm 145 GPIO_ACTIVE_LOW>;
 		};
 
 		led-controller@30 {
@@ -371,9 +371,9 @@ bluetooth {
 			max-speed = <3000000>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&bt_pins>;
-			device-wakeup-gpios = <&msmgpio 91 GPIO_ACTIVE_HIGH>;
+			device-wakeup-gpios = <&tlmm 91 GPIO_ACTIVE_HIGH>;
 			shutdown-gpios = <&gpio_expander 9 GPIO_ACTIVE_HIGH>;
-			interrupt-parent = <&msmgpio>;
+			interrupt-parent = <&tlmm>;
 			interrupts = <75 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "host-wakeup";
 		};
@@ -563,7 +563,7 @@ sdhci@f9864900 {
 		 */
 		pinctrl-names = "default";
 		pinctrl-0 = <&sdhc2_pin_a /* &sdhc2_cd_pin */>;
-		// cd-gpios = <&msmgpio 62 GPIO_ACTIVE_LOW>;
+		// cd-gpios = <&tlmm 62 GPIO_ACTIVE_LOW>;
 	};
 
 	sdhci@f98a4900 {
@@ -587,7 +587,7 @@ wifi@1 {
 			reg = <1>;
 			compatible = "brcm,bcm4329-fmac";
 
-			interrupt-parent = <&msmgpio>;
+			interrupt-parent = <&tlmm>;
 			interrupts = <92 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "host-wake";
 
@@ -818,7 +818,7 @@ panel: panel@0 {
 				vddr-supply = <&vreg_panel>;
 
 				reset-gpios = <&pma8084_gpios 17 GPIO_ACTIVE_LOW>;
-				te-gpios = <&msmgpio 12 GPIO_ACTIVE_HIGH>;
+				te-gpios = <&tlmm 12 GPIO_ACTIVE_HIGH>;
 
 				port {
 					panel_in: endpoint {
diff --git a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dts b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dts
index 8cace789fb26..6545917dd489 100644
--- a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dts
@@ -280,7 +280,7 @@ sdhci@f98a4900 {
 		vmmc-supply = <&pm8941_l21>;
 		vqmmc-supply = <&pm8941_l13>;
 
-		cd-gpios = <&msmgpio 62 GPIO_ACTIVE_LOW>;
+		cd-gpios = <&tlmm 62 GPIO_ACTIVE_LOW>;
 
 		pinctrl-names = "default";
 		pinctrl-0 = <&sdhc2_pin_a>, <&sdhc2_cd_pin_a>;
diff --git a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts
index e27b360951fd..352689237140 100644
--- a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts
@@ -239,7 +239,7 @@ vreg_bl_vddio: lcd-backlight-vddio {
 		regulator-min-microvolt = <3150000>;
 		regulator-max-microvolt = <3150000>;
 
-		gpio = <&msmgpio 69 0>;
+		gpio = <&tlmm 69 0>;
 		enable-active-high;
 
 		vin-supply = <&pm8941_s3>;
@@ -323,7 +323,7 @@ sdhci@f98a4900 {
 		vmmc-supply = <&pm8941_l21>;
 		vqmmc-supply = <&pm8941_l13>;
 
-		cd-gpios = <&msmgpio 62 GPIO_ACTIVE_LOW>;
+		cd-gpios = <&tlmm 62 GPIO_ACTIVE_LOW>;
 
 		pinctrl-names = "default";
 		pinctrl-0 = <&sdhc2_pin_a>, <&sdhc2_cd_pin_a>;
@@ -351,8 +351,8 @@ bluetooth {
 				    <&bt_dev_wake_pin>,
 				    <&bt_reg_on_pin>;
 
-			host-wakeup-gpios = <&msmgpio 95 GPIO_ACTIVE_HIGH>;
-			device-wakeup-gpios = <&msmgpio 96 GPIO_ACTIVE_HIGH>;
+			host-wakeup-gpios = <&tlmm 95 GPIO_ACTIVE_HIGH>;
+			device-wakeup-gpios = <&tlmm 96 GPIO_ACTIVE_HIGH>;
 			shutdown-gpios = <&pm8941_gpios 16 GPIO_ACTIVE_HIGH>;
 		};
 	};
@@ -566,7 +566,7 @@ synaptics@2c {
 			compatible = "syna,rmi4-i2c";
 			reg = <0x2c>;
 
-			interrupt-parent = <&msmgpio>;
+			interrupt-parent = <&tlmm>;
 			interrupts = <86 IRQ_TYPE_EDGE_FALLING>;
 
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts
index f4a2e2560777..313c755f590f 100644
--- a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts
@@ -305,7 +305,7 @@ sdhci@f98a4900 {
 		vmmc-supply = <&pm8941_l21>;
 		vqmmc-supply = <&pm8941_l13>;
 
-		cd-gpios = <&msmgpio 62 GPIO_ACTIVE_LOW>;
+		cd-gpios = <&tlmm 62 GPIO_ACTIVE_LOW>;
 
 		pinctrl-names = "default";
 		pinctrl-0 = <&sdhc2_pin_a>, <&sdhc2_cd_pin_a>;
@@ -331,7 +331,7 @@ synaptics@2c {
 			compatible = "syna,rmi4-i2c";
 			reg = <0x2c>;
 
-			interrupts-extended = <&msmgpio 61 IRQ_TYPE_EDGE_FALLING>;
+			interrupts-extended = <&tlmm 61 IRQ_TYPE_EDGE_FALLING>;
 
 			#address-cells = <1>;
 			#size-cells = <0>;
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index d8a1ba5b845c..2182d2755926 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -955,11 +955,11 @@ wifi {
 			};
 		};
 
-		msmgpio: pinctrl@fd510000 {
+		tlmm: pinctrl@fd510000 {
 			compatible = "qcom,msm8974-pinctrl";
 			reg = <0xfd510000 0x4000>;
 			gpio-controller;
-			gpio-ranges = <&msmgpio 0 0 146>;
+			gpio-ranges = <&tlmm 0 0 146>;
 			#gpio-cells = <2>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
-- 
2.35.1



