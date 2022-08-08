Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD7858BF34
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242461AbiHHBgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242213AbiHHBff (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:35:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9786FBF76;
        Sun,  7 Aug 2022 18:33:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10DBF60DE1;
        Mon,  8 Aug 2022 01:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49439C433D6;
        Mon,  8 Aug 2022 01:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922392;
        bh=w8+zR29nLfSfbW01P7TliFKqHJpE7i6L9aCfrauck+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nkicrl0Mtep2dzC/2Aevv9LiW2WxHGqokpHW3j54X9CTb6PsMQSuxq54V60LYhIW+
         tO1PR93AkgphD4ShHoHHwrAGYw6EgwoBJXatwjwrs8H7nPD4STCN+k9vu4S//9pwpf
         FVMVREAu47GkOTFKuGq5/pxLTbDaz9D9k/uCqBFmEHBvIzz2tXC0mpZfxI9e0JJSiz
         chBKMYiH0Cf7drIFi7TUuaNihirTr2xM3X6VvHXWwiGq08ANKAYTKrx6zjuquyk1Ld
         KXnatCUOO+59D462oZZGKd4VRQmhihpWAEgPs4LTVR9ulDVgUAGeDdYYPlzfcPAy2Y
         AxmKxGh8o3Njw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 43/58] arm64: dts: qcom: add missing AOSS QMP compatible fallback
Date:   Sun,  7 Aug 2022 21:31:01 -0400
Message-Id: <20220808013118.313965-43-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 6ba93ba9f63fbc44c3a6af7fe6f2536d009cfd5a ]

The AOSS QMP bindings expect all compatibles to be followed by fallback
"qcom,aoss-qmp" because all of these are actually compatible with each
other.  This fixes dtbs_check warnings like:

  sm8250-hdk.dtb: power-controller@c300000: compatible: ['qcom,sm8250-aoss-qmp'] is too short

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220504131923.214367-6-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 2 +-
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 2 +-
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 2 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 2006f416e3e2..8769ad30f1c7 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -3215,7 +3215,7 @@ aoss_reset: reset-controller@c2a0000 {
 		};
 
 		aoss_qmp: power-controller@c300000 {
-			compatible = "qcom,sc7180-aoss-qmp";
+			compatible = "qcom,sc7180-aoss-qmp", "qcom,aoss-qmp";
 			reg = <0 0x0c300000 0 0x400>;
 			interrupts = <GIC_SPI 389 IRQ_TYPE_EDGE_RISING>;
 			mboxes = <&apss_shared 0>;
diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index a7b128186b65..d22405658f13 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -3843,7 +3843,7 @@ aoss_reset: reset-controller@c2a0000 {
 		};
 
 		aoss_qmp: power-controller@c300000 {
-			compatible = "qcom,sc7280-aoss-qmp";
+			compatible = "qcom,sc7280-aoss-qmp", "qcom,aoss-qmp";
 			reg = <0 0x0c300000 0 0x400>;
 			interrupts-extended = <&ipcc IPCC_CLIENT_AOP
 						     IPCC_MPROC_SIGNAL_GLINK_QMP
diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 592be9945cb8..8abaa28cebbc 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3718,7 +3718,7 @@ pdc: interrupt-controller@b220000 {
 		};
 
 		aoss_qmp: power-controller@c300000 {
-			compatible = "qcom,sm8150-aoss-qmp";
+			compatible = "qcom,sm8150-aoss-qmp", "qcom,aoss-qmp";
 			reg = <0x0 0x0c300000 0x0 0x400>;
 			interrupts = <GIC_SPI 389 IRQ_TYPE_EDGE_RISING>;
 			mboxes = <&apss_shared 0>;
diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 5dae1b8469a2..d0760e6ec942 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -3734,7 +3734,7 @@ tsens1: thermal-sensor@c265000 {
 		};
 
 		aoss_qmp: power-controller@c300000 {
-			compatible = "qcom,sm8250-aoss-qmp";
+			compatible = "qcom,sm8250-aoss-qmp", "qcom,aoss-qmp";
 			reg = <0 0x0c300000 0 0x400>;
 			interrupts-extended = <&ipcc IPCC_CLIENT_AOP
 						     IPCC_MPROC_SIGNAL_GLINK_QMP
diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 2b80d8f89d18..3293f76478df 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1718,7 +1718,7 @@ tsens1: thermal-sensor@c265000 {
 		};
 
 		aoss_qmp: power-controller@c300000 {
-			compatible = "qcom,sm8350-aoss-qmp";
+			compatible = "qcom,sm8350-aoss-qmp", "qcom,aoss-qmp";
 			reg = <0 0x0c300000 0 0x400>;
 			interrupts-extended = <&ipcc IPCC_CLIENT_AOP IPCC_MPROC_SIGNAL_GLINK_QMP
 						     IRQ_TYPE_EDGE_RISING>;
-- 
2.35.1

