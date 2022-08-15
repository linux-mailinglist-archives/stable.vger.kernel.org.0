Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78BF6593DFC
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345692AbiHOUdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348339AbiHOUcc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:32:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FE185FB8;
        Mon, 15 Aug 2022 12:05:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A931E61281;
        Mon, 15 Aug 2022 19:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D61C433C1;
        Mon, 15 Aug 2022 19:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590338;
        bh=esD0rQV8wZIFlZqYk+UwjZZhg1rXQIzw+OF5KHdrJ2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sGk5T7XgdkORR/MKiY6YNu4s55V8vwKODoa2xiQ9YBqiepJSINJ0gFT8KFeOXZVzB
         H2sT514gHmQ1SC4opFQnurHBPT0H9Xm0QgbTcyvIpYFZ9jz7nBJ9U8uX0iQFr5WRSr
         YGmG2vibE3NsvoEALAnMm4G94kItzSCJOtrRqXfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0227/1095] ARM: dts: qcom-msm8974*: Fix UART naming
Date:   Mon, 15 Aug 2022 19:53:46 +0200
Message-Id: <20220815180439.107102982@linuxfoundation.org>
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

[ Upstream commit b905c34ae7db6b564589f02fa7eac7afaa0294e9 ]

It's either uart10, or blsp2_uart4, not blsp2_uart10, as there aren't 10
UARTs on BLSP2. Fix the naming to align with what's done in arm64/qcom.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220415115633.575010-4-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts    |  6 +++---
 arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts        | 10 +++++-----
 arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts  |  2 +-
 arch/arm/boot/dts/qcom-msm8974.dtsi                    |  6 +++---
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts b/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts
index 5fbdba73c07f..dd2d0647d4be 100644
--- a/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts
@@ -12,7 +12,7 @@ / {
 
 	aliases {
 		serial0 = &blsp1_uart1;
-		serial1 = &blsp2_uart10;
+		serial1 = &blsp2_uart4;
 	};
 
 	chosen {
@@ -395,7 +395,7 @@ shutdown {
 			};
 		};
 
-		blsp2_uart10_pin_a: blsp2-uart10-pin-active {
+		blsp2_uart4_pin_a: blsp2-uart4-pin-active {
 			tx {
 				pins = "gpio53";
 				function = "blsp_uart10";
@@ -473,7 +473,7 @@ serial@f9960000 {
 		status = "okay";
 
 		pinctrl-names = "default";
-		pinctrl-0 = <&blsp2_uart10_pin_a>;
+		pinctrl-0 = <&blsp2_uart4_pin_a>;
 
 		bluetooth {
 			compatible = "brcm,bcm43438-bt";
diff --git a/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts b/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
index 1f630120c01f..95ae30d06554 100644
--- a/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
@@ -358,13 +358,13 @@ serial@f991e000 {
 		status = "okay";
 	};
 
-	/* blsp2_uart8 */
+	/* blsp2_uart2 */
 	serial@f995e000 {
 		status = "okay";
 
 		pinctrl-names = "default", "sleep";
-		pinctrl-0 = <&blsp2_uart8_pins_active>;
-		pinctrl-1 = <&blsp2_uart8_pins_sleep>;
+		pinctrl-0 = <&blsp2_uart2_pins_active>;
+		pinctrl-1 = <&blsp2_uart2_pins_sleep>;
 
 		bluetooth {
 			compatible = "brcm,bcm43540-bt";
@@ -380,14 +380,14 @@ bluetooth {
 	};
 
 	pinctrl@fd510000 {
-		blsp2_uart8_pins_active: blsp2-uart8-pins-active {
+		blsp2_uart2_pins_active: blsp2-uart2-pins-active {
 			pins = "gpio45", "gpio46", "gpio47", "gpio48";
 			function = "blsp_uart8";
 			drive-strength = <8>;
 			bias-disable;
 		};
 
-		blsp2_uart8_pins_sleep: blsp2-uart8-pins-sleep {
+		blsp2_uart2_pins_sleep: blsp2-uart2-pins-sleep {
 			pins = "gpio45", "gpio46", "gpio47", "gpio48";
 			function = "gpio";
 			drive-strength = <2>;
diff --git a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts
index 3c4a7d760ba9..e27b360951fd 100644
--- a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts
@@ -11,7 +11,7 @@ / {
 
 	aliases {
 		serial0 = &blsp1_uart2;
-		serial1 = &blsp2_uart7;
+		serial1 = &blsp2_uart1;
 	};
 
 	chosen {
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 08497783757a..689ddaabf463 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -715,7 +715,7 @@ blsp1_uart2: serial@f991e000 {
 			status = "disabled";
 		};
 
-		blsp2_uart7: serial@f995d000 {
+		blsp2_uart1: serial@f995d000 {
 			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
 			reg = <0xf995d000 0x1000>;
 			interrupts = <GIC_SPI 113 IRQ_TYPE_NONE>;
@@ -724,7 +724,7 @@ blsp2_uart7: serial@f995d000 {
 			status = "disabled";
 		};
 
-		blsp2_uart8: serial@f995e000 {
+		blsp2_uart2: serial@f995e000 {
 			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
 			reg = <0xf995e000 0x1000>;
 			interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
@@ -733,7 +733,7 @@ blsp2_uart8: serial@f995e000 {
 			status = "disabled";
 		};
 
-		blsp2_uart10: serial@f9960000 {
+		blsp2_uart4: serial@f9960000 {
 			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
 			reg = <0xf9960000 0x1000>;
 			interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.35.1



