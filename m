Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A12D593DE7
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345327AbiHOU3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345956AbiHOU2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:28:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEC6A0305;
        Mon, 15 Aug 2022 12:04:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDE8661281;
        Mon, 15 Aug 2022 19:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA74C433C1;
        Mon, 15 Aug 2022 19:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590247;
        bh=m7W2Uu+7QdsldiMwSIaJvP+5QGzHdK7f+nSQK7+tS2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nu0RKXMtDbCTcEK26fj5GvlDLs6Ie03kHCLT2fnKqxzUFa04s8LPZePmma5dxqBtF
         zi2D+bjBaT4GQApe1+x3NV/ZpjJwgNCrU/zGEaAVJ31OvZmK+q4aOg9oub7fKOIybD
         vIWm+MK/zODDp/ZsH2j24b2xwVWufx3LqwLeycsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0169/1095] arm64: dts: qcom: add missing AOSS QMP compatible fallback
Date:   Mon, 15 Aug 2022 19:52:48 +0200
Message-Id: <20220815180436.603356159@linuxfoundation.org>
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
index e9fb3c9a2d6e..120db2d0a309 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -3219,7 +3219,7 @@ aoss_reset: reset-controller@c2a0000 {
 		};
 
 		aoss_qmp: power-controller@c300000 {
-			compatible = "qcom,sc7180-aoss-qmp";
+			compatible = "qcom,sc7180-aoss-qmp", "qcom,aoss-qmp";
 			reg = <0 0x0c300000 0 0x400>;
 			interrupts = <GIC_SPI 389 IRQ_TYPE_EDGE_RISING>;
 			mboxes = <&apss_shared 0>;
diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 8a4fd614d0a1..7925c8561117 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -3467,7 +3467,7 @@ aoss_reset: reset-controller@c2a0000 {
 		};
 
 		aoss_qmp: power-controller@c300000 {
-			compatible = "qcom,sc7280-aoss-qmp";
+			compatible = "qcom,sc7280-aoss-qmp", "qcom,aoss-qmp";
 			reg = <0 0x0c300000 0 0x400>;
 			interrupts-extended = <&ipcc IPCC_CLIENT_AOP
 						     IPCC_MPROC_SIGNAL_GLINK_QMP
diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index d4f288edf3c9..6edb3986a473 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3382,7 +3382,7 @@ camnoc_virt: interconnect@ac00000 {
 		};
 
 		aoss_qmp: power-controller@c300000 {
-			compatible = "qcom,sm8150-aoss-qmp";
+			compatible = "qcom,sm8150-aoss-qmp", "qcom,aoss-qmp";
 			reg = <0x0 0x0c300000 0x0 0x400>;
 			interrupts = <GIC_SPI 389 IRQ_TYPE_EDGE_RISING>;
 			mboxes = <&apss_shared 0>;
diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index ed4e288c921f..1d62b2130e04 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -3475,7 +3475,7 @@ tsens1: thermal-sensor@c265000 {
 		};
 
 		aoss_qmp: power-controller@c300000 {
-			compatible = "qcom,sm8250-aoss-qmp";
+			compatible = "qcom,sm8250-aoss-qmp", "qcom,aoss-qmp";
 			reg = <0 0x0c300000 0 0x400>;
 			interrupts-extended = <&ipcc IPCC_CLIENT_AOP
 						     IPCC_MPROC_SIGNAL_GLINK_QMP
diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index d843a550314a..ee6c202ab68c 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1537,7 +1537,7 @@ tsens1: thermal-sensor@c265000 {
 		};
 
 		aoss_qmp: power-controller@c300000 {
-			compatible = "qcom,sm8350-aoss-qmp";
+			compatible = "qcom,sm8350-aoss-qmp", "qcom,aoss-qmp";
 			reg = <0 0x0c300000 0 0x400>;
 			interrupts-extended = <&ipcc IPCC_CLIENT_AOP IPCC_MPROC_SIGNAL_GLINK_QMP
 						     IRQ_TYPE_EDGE_RISING>;
-- 
2.35.1



