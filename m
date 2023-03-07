Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE936AE80E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjCGRMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjCGRMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:12:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18036A102D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:07:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D097CB81995
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB56C433D2;
        Tue,  7 Mar 2023 17:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208814;
        bh=UBrl6rgPoVy0si97V313R9e+lFMijy9jSb38gsa+eKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T00SGU83aUXbvQLBpXRZaDYpn0KPgXLUR1Goa96b9JA2Fx0fqQ5yKNdMAgc7JqFdh
         +4f/PMA3qyoDJrkVa4gmqwL8ugTRTQBRiqM8uF+lxcD+aE9GM7atAvKJD0B4K+8Odq
         j8c3mfrbC+L5vdzMQ5gmDjDpbMPg0D7XXN4GH/qY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0019/1001] arm64: dts: qcom: sm8350-sagami: Configure SLG51000 PMIC on PDX215
Date:   Tue,  7 Mar 2023 17:46:31 +0100
Message-Id: <20230307170022.984875451@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 8875b1d71f112b30e4c7e65ed337096bc0cc396b ]

Remove the mention of this PMIC from the common DTSI, as it's not
used on PDX214. Add the required nodes to support it on PDX215.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221118152028.59312-2-konrad.dybcio@linaro.org
Stable-dep-of: dcc7cd5c46ca ("arm64: dts: qcom: sm8350-sagami: Rectify GPIO keys")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../qcom/sm8350-sony-xperia-sagami-pdx215.dts | 66 +++++++++++++++++++
 .../dts/qcom/sm8350-sony-xperia-sagami.dtsi   |  2 +-
 2 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami-pdx215.dts b/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami-pdx215.dts
index c74c973a69d2d..d4afaa393c9a9 100644
--- a/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami-pdx215.dts
+++ b/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami-pdx215.dts
@@ -12,6 +12,72 @@ / {
 	compatible = "sony,pdx215-generic", "qcom,sm8350";
 };
 
+&i2c13 {
+	pmic@75 {
+		compatible = "dlg,slg51000";
+		reg = <0x75>;
+		dlg,cs-gpios = <&pm8350b_gpios 1 GPIO_ACTIVE_HIGH>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&cam_pwr_a_cs>;
+
+		regulators {
+			slg51000_a_ldo1: ldo1 {
+				regulator-name = "slg51000_a_ldo1";
+				regulator-min-microvolt = <2400000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			slg51000_a_ldo2: ldo2 {
+				regulator-name = "slg51000_a_ldo2";
+				regulator-min-microvolt = <2400000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			slg51000_a_ldo3: ldo3 {
+				regulator-name = "slg51000_a_ldo3";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <3750000>;
+			};
+
+			slg51000_a_ldo4: ldo4 {
+				regulator-name = "slg51000_a_ldo4";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <3750000>;
+			};
+
+			slg51000_a_ldo5: ldo5 {
+				regulator-name = "slg51000_a_ldo5";
+				regulator-min-microvolt = <500000>;
+				regulator-max-microvolt = <1200000>;
+			};
+
+			slg51000_a_ldo6: ldo6 {
+				regulator-name = "slg51000_a_ldo6";
+				regulator-min-microvolt = <500000>;
+				regulator-max-microvolt = <1200000>;
+			};
+
+			slg51000_a_ldo7: ldo7 {
+				regulator-name = "slg51000_a_ldo7";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <3750000>;
+			};
+		};
+	};
+};
+
+&pm8350b_gpios {
+	cam_pwr_a_cs: cam-pwr-a-cs-state {
+		pins = "gpio1";
+		function = "normal";
+		qcom,drive-strength = <PMIC_GPIO_STRENGTH_LOW>;
+		power-source = <1>;
+		drive-push-pull;
+		output-high;
+	};
+};
+
 &tlmm {
 	gpio-line-names = "APPS_I2C_0_SDA", /* GPIO_0 */
 			  "APPS_I2C_0_SCL",
diff --git a/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi b/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi
index 1f2d660f8f86c..a10306d82a3a1 100644
--- a/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi
@@ -3,6 +3,7 @@
  * Copyright (c) 2021, Konrad Dybcio <konrad.dybcio@somainline.org>
  */
 
+#include <dt-bindings/pinctrl/qcom,pmic-gpio.h>
 #include <dt-bindings/regulator/qcom,rpmh-regulator.h>
 #include "sm8350.dtsi"
 #include "pm8350.dtsi"
@@ -506,7 +507,6 @@ &i2c13 {
 	clock-frequency = <100000>;
 
 	/* Qualcomm PM8008i/PM8008j (?) @ 8, 9, c, d */
-	/* Dialog SLG51000 CMIC @ 75 */
 };
 
 &i2c15 {
-- 
2.39.2



