Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78202657925
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbiL1O6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbiL1O6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:58:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E835712AB7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:57:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50199B8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A52C433D2;
        Wed, 28 Dec 2022 14:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239472;
        bh=UXU4IV6IRj8BIE2RBX0qICfYUSO2iLSH4xpToNNqxS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ylmradfxmkNqqA/Wb3CrbcHmRe3q9arhtMIA1xBeNpAJGys31DXYaXmhVXjv10iQ+
         ZgJIePL45rAuaTx6Bsq6dm29D1blJkoyDVW5yQpryZAJn3eZ3/vCO0/gh2hXcVrsYX
         OWmO89KB90To/xPrLNBZi+UTvKzoPUqn0/2plb7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0035/1073] arm64: dts: qcom: use GPIO flags for tlmm
Date:   Wed, 28 Dec 2022 15:27:03 +0100
Message-Id: <20221228144329.088629045@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 36c9d012f193747d42af80b634217addd974c522 ]

Use respective GPIO_ACTIVE_LOW/HIGH flags for tlmm GPIOs.  Include
gpio.h header if this is first usage of that flag.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220802153947.44457-4-krzysztof.kozlowski@linaro.org
Stable-dep-of: 76d21ffc5d42 ("arm64: dts: qcom: msm8996: fix sound card reset line polarity")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/apq8096-ifc6640.dts               | 2 +-
 arch/arm64/boot/dts/qcom/msm8994-sony-xperia-kitakami.dtsi | 2 +-
 arch/arm64/boot/dts/qcom/msm8994.dtsi                      | 3 ++-
 arch/arm64/boot/dts/qcom/msm8996.dtsi                      | 3 ++-
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts                 | 4 ++--
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts       | 2 +-
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts         | 4 ++--
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts       | 2 +-
 arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts           | 2 +-
 arch/arm64/boot/dts/qcom/sm8250-mtp.dts                    | 2 +-
 10 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/apq8096-ifc6640.dts b/arch/arm64/boot/dts/qcom/apq8096-ifc6640.dts
index 567b33106556..92f264891d84 100644
--- a/arch/arm64/boot/dts/qcom/apq8096-ifc6640.dts
+++ b/arch/arm64/boot/dts/qcom/apq8096-ifc6640.dts
@@ -368,7 +368,7 @@ &sdhc2 {
 
 	bus-width = <4>;
 
-	cd-gpios = <&tlmm 38 0x1>;
+	cd-gpios = <&tlmm 38 GPIO_ACTIVE_LOW>;
 
 	vmmc-supply = <&vreg_l21a_2p95>;
 	vqmmc-supply = <&vreg_l13a_2p95>;
diff --git a/arch/arm64/boot/dts/qcom/msm8994-sony-xperia-kitakami.dtsi b/arch/arm64/boot/dts/qcom/msm8994-sony-xperia-kitakami.dtsi
index f430d797196f..ff60b7004d26 100644
--- a/arch/arm64/boot/dts/qcom/msm8994-sony-xperia-kitakami.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994-sony-xperia-kitakami.dtsi
@@ -471,7 +471,7 @@ &sdhc1 {
 &sdhc2 {
 	status = "okay";
 
-	cd-gpios = <&tlmm 100 0>;
+	cd-gpios = <&tlmm 100 GPIO_ACTIVE_HIGH>;
 	vmmc-supply = <&pm8994_l21>;
 	vqmmc-supply = <&pm8994_l13>;
 };
diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index 8bc6c070e306..86ef0091caff 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -6,6 +6,7 @@
 #include <dt-bindings/clock/qcom,gcc-msm8994.h>
 #include <dt-bindings/clock/qcom,mmcc-msm8994.h>
 #include <dt-bindings/clock/qcom,rpmcc.h>
+#include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/power/qcom-rpmpd.h>
 
 / {
@@ -502,7 +503,7 @@ sdhc2: mmc@f98a4900 {
 			pinctrl-0 = <&sdc2_clk_on &sdc2_cmd_on &sdc2_data_on>;
 			pinctrl-1 = <&sdc2_clk_off &sdc2_cmd_off &sdc2_data_off>;
 
-			cd-gpios = <&tlmm 100 0>;
+			cd-gpios = <&tlmm 100 GPIO_ACTIVE_HIGH>;
 			bus-width = <4>;
 			status = "disabled";
 		};
diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index c8b9d7d60774..d3cf0677ea28 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -7,6 +7,7 @@
 #include <dt-bindings/clock/qcom,mmcc-msm8996.h>
 #include <dt-bindings/clock/qcom,rpmcc.h>
 #include <dt-bindings/interconnect/qcom,msm8996.h>
+#include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/power/qcom-rpmpd.h>
 #include <dt-bindings/soc/qcom,apr.h>
 #include <dt-bindings/thermal/thermal.h>
@@ -3357,7 +3358,7 @@ wcd9335: codec@1{
 					interrupt-names = "intr1", "intr2";
 					interrupt-controller;
 					#interrupt-cells = <1>;
-					reset-gpios = <&tlmm 64 0>;
+					reset-gpios = <&tlmm 64 GPIO_ACTIVE_HIGH>;
 
 					slim-ifc-dev = <&tasha_ifd>;
 
diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index c6e2c571b452..b2eddcd87506 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -1081,7 +1081,7 @@ &wcd9340{
 	pinctrl-names = "default";
 	clock-names = "extclk";
 	clocks = <&rpmhcc RPMH_LN_BB_CLK2>;
-	reset-gpios = <&tlmm 64 0>;
+	reset-gpios = <&tlmm 64 GPIO_ACTIVE_HIGH>;
 	vdd-buck-supply = <&vreg_s4a_1p8>;
 	vdd-buck-sido-supply = <&vreg_s4a_1p8>;
 	vdd-tx-supply = <&vreg_s4a_1p8>;
@@ -1255,7 +1255,7 @@ camera@60 {
 		reg = <0x60>;
 
 		// CAM3_RST_N
-		enable-gpios = <&tlmm 21 0>;
+		enable-gpios = <&tlmm 21 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&cam3_default>;
 		gpios = <&tlmm 16 0>,
diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
index 82c27f90d300..0f470cf1ed1c 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
@@ -546,7 +546,7 @@ &wcd9340{
 	pinctrl-names = "default";
 	clock-names = "extclk";
 	clocks = <&rpmhcc RPMH_LN_BB_CLK2>;
-	reset-gpios = <&tlmm 64 0>;
+	reset-gpios = <&tlmm 64 GPIO_ACTIVE_HIGH>;
 	vdd-buck-supply = <&vreg_s4a_1p8>;
 	vdd-buck-sido-supply = <&vreg_s4a_1p8>;
 	vdd-tx-supply = <&vreg_s4a_1p8>;
diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
index 2611a5c40ba3..1cc477c30945 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
@@ -126,7 +126,7 @@ vreg_tp_vddio: vreg-tp-vddio {
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <1800000>;
 
-		gpio = <&tlmm 23 0>;
+		gpio = <&tlmm 23 GPIO_ACTIVE_HIGH>;
 		regulator-always-on;
 		regulator-boot-on;
 		enable-active-high;
@@ -712,7 +712,7 @@ &wcd9340 {
 	pinctrl-names = "default";
 	clock-names = "extclk";
 	clocks = <&rpmhcc RPMH_LN_BB_CLK2>;
-	reset-gpios = <&tlmm 64 0>;
+	reset-gpios = <&tlmm 64 GPIO_ACTIVE_HIGH>;
 	vdd-buck-sido-supply = <&vreg_s4a_1p8>;
 	vdd-buck-supply = <&vreg_s4a_1p8>;
 	vdd-tx-supply = <&vreg_s4a_1p8>;
diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index a7af1bed4312..be59a8ba9c1f 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -772,7 +772,7 @@ &wcd9340{
 	pinctrl-names = "default";
 	clock-names = "extclk";
 	clocks = <&rpmhcc RPMH_LN_BB_CLK2>;
-	reset-gpios = <&tlmm 64 0>;
+	reset-gpios = <&tlmm 64 GPIO_ACTIVE_HIGH>;
 	vdd-buck-supply = <&vreg_s4a_1p8>;
 	vdd-buck-sido-supply = <&vreg_s4a_1p8>;
 	vdd-tx-supply = <&vreg_s4a_1p8>;
diff --git a/arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts b/arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts
index b0315eeb1320..f954fe5cb61a 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts
@@ -704,7 +704,7 @@ &wcd9340{
 	pinctrl-names = "default";
 	clock-names = "extclk";
 	clocks = <&rpmhcc RPMH_LN_BB_CLK2>;
-	reset-gpios = <&tlmm 64 0>;
+	reset-gpios = <&tlmm 64 GPIO_ACTIVE_HIGH>;
 	vdd-buck-supply = <&vreg_s4a_1p8>;
 	vdd-buck-sido-supply = <&vreg_s4a_1p8>;
 	vdd-tx-supply = <&vreg_s4a_1p8>;
diff --git a/arch/arm64/boot/dts/qcom/sm8250-mtp.dts b/arch/arm64/boot/dts/qcom/sm8250-mtp.dts
index 7ab3627cc347..a102aa5efa32 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sm8250-mtp.dts
@@ -635,7 +635,7 @@ &soc {
 	wcd938x: codec {
 		compatible = "qcom,wcd9380-codec";
 		#sound-dai-cells = <1>;
-		reset-gpios = <&tlmm 32 0>;
+		reset-gpios = <&tlmm 32 GPIO_ACTIVE_HIGH>;
 		vdd-buck-supply = <&vreg_s4a_1p8>;
 		vdd-rxtx-supply = <&vreg_s4a_1p8>;
 		vdd-io-supply = <&vreg_s4a_1p8>;
-- 
2.35.1



