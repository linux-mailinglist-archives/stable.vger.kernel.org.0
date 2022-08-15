Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD5E593DF5
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345429AbiHOUdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348291AbiHOUc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:32:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121125A2EC;
        Mon, 15 Aug 2022 12:05:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAC81612AF;
        Mon, 15 Aug 2022 19:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC31DC433C1;
        Mon, 15 Aug 2022 19:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590335;
        bh=NpP1xSHXN7C1Bjs+TVA9esRLrTXCrQMqK4pxcramw2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c8UV2xKoLPRqnp0eHlKAH4xkktLJ+FWFc6NI3rPoA1dqqgwSEDJ7FT5tknVqI29X8
         8/Oo5rLwGIP3kkW7G35LeQ4Tbp4/jAUbMYPXUOu4bLKhlYxWCJepRWqngLFxyWENrl
         NQVt0QdG4kHawWlT0R3At01fIQTb4LCMte1yXOgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0226/1095] ARM: dts: qcom: do not use underscore in node name
Date:   Mon, 15 Aug 2022 19:53:45 +0200
Message-Id: <20220815180439.060686085@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 43cdc159d203eb6d02b312409e634a3fa06632ac ]

Align RPM requests node with DT schema by using hyphen instead of
underscore.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
[bjorn: Fixed up qcom-{apq8074,msm8974}-*.dts to match the qcom-msm8974.dtsi]
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220401201035.189106-8-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-apq8064.dtsi                      | 8 ++++----
 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts           | 2 +-
 arch/arm/boot/dts/qcom-apq8084.dtsi                      | 2 +-
 arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts         | 2 +-
 arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts | 2 +-
 arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts          | 2 +-
 arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dts     | 2 +-
 arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts    | 2 +-
 arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts    | 2 +-
 arch/arm/boot/dts/qcom-msm8974.dtsi                      | 2 +-
 10 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index a1c8ae516d21..33a4d3441959 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -227,7 +227,7 @@ smem {
 	smd {
 		compatible = "qcom,smd";
 
-		modem@0 {
+		modem-edge {
 			interrupts = <0 37 IRQ_TYPE_EDGE_RISING>;
 
 			qcom,ipc = <&l2cc 8 3>;
@@ -236,7 +236,7 @@ modem@0 {
 			status = "disabled";
 		};
 
-		q6@1 {
+		q6-edge {
 			interrupts = <0 90 IRQ_TYPE_EDGE_RISING>;
 
 			qcom,ipc = <&l2cc 8 15>;
@@ -245,7 +245,7 @@ q6@1 {
 			status = "disabled";
 		};
 
-		dsps@3 {
+		dsps-edge {
 			interrupts = <0 138 IRQ_TYPE_EDGE_RISING>;
 
 			qcom,ipc = <&sps_sic_non_secure 0x4080 0>;
@@ -254,7 +254,7 @@ dsps@3 {
 			status = "disabled";
 		};
 
-		riva@6 {
+		riva-edge {
 			interrupts = <0 198 IRQ_TYPE_EDGE_RISING>;
 
 			qcom,ipc = <&l2cc 8 25>;
diff --git a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
index 83793b835d40..e2b4e4fc6377 100644
--- a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
+++ b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
@@ -147,7 +147,7 @@ eeprom: eeprom@52 {
 
 	smd {
 		rpm {
-			rpm_requests {
+			rpm-requests {
 				pm8841-regulators {
 					s1 {
 						regulator-min-microvolt = <675000>;
diff --git a/arch/arm/boot/dts/qcom-apq8084.dtsi b/arch/arm/boot/dts/qcom-apq8084.dtsi
index 52240fc7a1a6..da50a1a0197f 100644
--- a/arch/arm/boot/dts/qcom-apq8084.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8084.dtsi
@@ -470,7 +470,7 @@ rpm {
 			qcom,ipc = <&apcs 8 0>;
 			qcom,smd-edge = <15>;
 
-			rpm_requests {
+			rpm-requests {
 				compatible = "qcom,rpm-apq8084";
 				qcom,smd-channels = "rpm_requests";
 
diff --git a/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts b/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
index 6d77e0f8ca4d..9dbfc9f8646a 100644
--- a/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
@@ -57,7 +57,7 @@ vibrator {
 
 	smd {
 		rpm {
-			rpm_requests {
+			rpm-requests {
 				pm8841-regulators {
 					s1 {
 						regulator-min-microvolt = <675000>;
diff --git a/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts b/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts
index 6d5fb60e798f..5fbdba73c07f 100644
--- a/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts
@@ -42,7 +42,7 @@ volume-down {
 
 	smd {
 		rpm {
-			rpm_requests {
+			rpm-requests {
 				pm8841-regulators {
 					s1 {
 						regulator-min-microvolt = <675000>;
diff --git a/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts b/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
index 6e036a440532..1f630120c01f 100644
--- a/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
@@ -54,7 +54,7 @@ volume-up {
 
 	smd {
 		rpm {
-			rpm_requests {
+			rpm-requests {
 				pma8084-regulators {
 					compatible = "qcom,rpm-pma8084-regulators";
 					status = "okay";
diff --git a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dts b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dts
index 79e2cfbbb1ba..8cace789fb26 100644
--- a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dts
@@ -60,7 +60,7 @@ memory@0 {
 
 	smd {
 		rpm {
-			rpm_requests {
+			rpm-requests {
 				pm8841-regulators {
 					s1 {
 						regulator-min-microvolt = <675000>;
diff --git a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts
index e66937e3f7dd..3c4a7d760ba9 100644
--- a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts
@@ -55,7 +55,7 @@ volume-up {
 
 	smd {
 		rpm {
-			rpm_requests {
+			rpm-requests {
 				pm8941-regulators {
 					vdd_l1_l3-supply = <&pm8941_s1>;
 					vdd_l2_lvs1_2_3-supply = <&pm8941_s3>;
diff --git a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts
index a62e5c25b23c..f4a2e2560777 100644
--- a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts
@@ -60,7 +60,7 @@ memory@0 {
 
 	smd {
 		rpm {
-			rpm_requests {
+			rpm-requests {
 				pm8841-regulators {
 					s1 {
 						regulator-min-microvolt = <675000>;
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 412d94736c35..08497783757a 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -1614,7 +1614,7 @@ rpm {
 			qcom,ipc = <&apcs 8 0>;
 			qcom,smd-edge = <15>;
 
-			rpm_requests {
+			rpm-requests {
 				compatible = "qcom,rpm-msm8974";
 				qcom,smd-channels = "rpm_requests";
 
-- 
2.35.1



