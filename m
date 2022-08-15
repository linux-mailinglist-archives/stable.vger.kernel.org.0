Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A653C593E2A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345418AbiHOUhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346097AbiHOUff (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:35:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EE82CCB1;
        Mon, 15 Aug 2022 12:06:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 531FC61281;
        Mon, 15 Aug 2022 19:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A8CC433C1;
        Mon, 15 Aug 2022 19:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590399;
        bh=KllhjJV9VouH/3ISnHcF6h0zQoJcICFh8bxb8Ionq+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BYJMGEFOqQ9y3sCUX4y+80SVAnxnTQCivz91rOoobSkz8rjYiTzSUsRF9qoLjiN+4
         Hjmog4cdGdjSsXlx5oGlpY/0GxHlAd17IACQKl4YrBfnDe5DQcNsbNCSkJ6dvX0rz/
         731TZeFZyrtSGGGFhzHTYiSsE2S1P/cyNrM5DPgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0230/1095] ARM: dts: qcom-msm8974: Fix up SDHCI nodes
Date:   Mon, 15 Aug 2022 19:53:49 +0200
Message-Id: <20220815180439.252974319@linuxfoundation.org>
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

[ Upstream commit 64cf62683b5398e46cf967c308be95685137626a ]

- Add missing labels (and remove their redefinition from klte)
- Commonize bus-width
- Add non-removable on sdhc_1, as it's supposed to have an eMMC on it

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220415115633.575010-7-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts |  4 ++--
 arch/arm/boot/dts/qcom-msm8974.dtsi             | 13 ++++++++++---
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts b/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
index 95ae30d06554..3ee2508b20fb 100644
--- a/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
@@ -534,7 +534,7 @@ te {
 		};
 	};
 
-	sdhc_1: sdhci@f9824900 {
+	sdhci@f9824900 {
 		status = "okay";
 
 		vmmc-supply = <&pma8084_l20>;
@@ -547,7 +547,7 @@ sdhc_1: sdhci@f9824900 {
 		pinctrl-0 = <&sdhc1_pin_a>;
 	};
 
-	sdhc_2: sdhci@f9864900 {
+	sdhci@f9864900 {
 		status = "okay";
 
 		max-frequency = <100000000>;
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 2d54d18310da..d8a1ba5b845c 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -742,7 +742,7 @@ blsp2_uart4: serial@f9960000 {
 			status = "disabled";
 		};
 
-		sdhci@f9824900 {
+		sdhc_1: sdhci@f9824900 {
 			compatible = "qcom,msm8974-sdhci", "qcom,sdhci-msm-v4";
 			reg = <0xf9824900 0x11c>, <0xf9824000 0x800>;
 			reg-names = "hc_mem", "core_mem";
@@ -753,10 +753,13 @@ sdhci@f9824900 {
 				 <&gcc GCC_SDCC1_AHB_CLK>,
 				 <&xo_board>;
 			clock-names = "core", "iface", "xo";
+			bus-width = <8>;
+			non-removable;
+
 			status = "disabled";
 		};
 
-		sdhci@f9864900 {
+		sdhc_3: sdhci@f9864900 {
 			compatible = "qcom,msm8974-sdhci", "qcom,sdhci-msm-v4";
 			reg = <0xf9864900 0x11c>, <0xf9864000 0x800>;
 			reg-names = "hc_mem", "core_mem";
@@ -767,10 +770,12 @@ sdhci@f9864900 {
 				 <&gcc GCC_SDCC3_AHB_CLK>,
 				 <&xo_board>;
 			clock-names = "core", "iface", "xo";
+			bus-width = <4>;
+
 			status = "disabled";
 		};
 
-		sdhci@f98a4900 {
+		sdhc_2: sdhci@f98a4900 {
 			compatible = "qcom,msm8974-sdhci", "qcom,sdhci-msm-v4";
 			reg = <0xf98a4900 0x11c>, <0xf98a4000 0x800>;
 			reg-names = "hc_mem", "core_mem";
@@ -781,6 +786,8 @@ sdhci@f98a4900 {
 				 <&gcc GCC_SDCC2_AHB_CLK>,
 				 <&xo_board>;
 			clock-names = "core", "iface", "xo";
+			bus-width = <4>;
+
 			status = "disabled";
 		};
 
-- 
2.35.1



