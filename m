Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9EF593E1B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245032AbiHOUg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345855AbiHOUeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:34:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE134E612;
        Mon, 15 Aug 2022 12:06:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E02B3612A0;
        Mon, 15 Aug 2022 19:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E260FC433D6;
        Mon, 15 Aug 2022 19:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590363;
        bh=piaSKTgFszLhRlG3ukpc4rqWWk26NNFQi+RoDH5l8MA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wy1aCVNSQbzRfqQXwQm6FFHwXAWLawMYl/RVcHU9gXD3GtabpPg/yYjR3e9a6qcxe
         yk5ig029f+yJ410hrDf/zVBmiOZj75ZwwgLnedW52cKpAxHA3Wgl7EUzXX8LZ2akzP
         VdcExnImNxEh5pE+bcrvptH3t+eqb/8KwJ2Z2aVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0229/1095] ARM: dts: qcom-msm8974: Fix up mdss nodes
Date:   Mon, 15 Aug 2022 19:53:48 +0200
Message-Id: <20220815180439.205569121@linuxfoundation.org>
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

[ Upstream commit 4de36f7b6d0e7e792d36800ac6c5e3392b59573a ]

Fix up formatting, move status=disabled to the end where it belongs,
rename DSI PHY label to match newer DTs, use tabs where possible,
unwrap lines where wrapping is not necessary and don't disable mdp,
as MDSS is useless without it.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220415115633.575010-6-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-msm8974.dtsi | 77 +++++++++++++----------------
 1 file changed, 34 insertions(+), 43 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 6e99903bb5f9..2d54d18310da 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -1461,35 +1461,29 @@ opp-27000000 {
 		};
 
 		mdss: mdss@fd900000 {
-			status = "disabled";
-
 			compatible = "qcom,mdss";
-			reg = <0xfd900000 0x100>,
-			      <0xfd924000 0x1000>;
-			reg-names = "mdss_phys",
-			            "vbif_phys";
+			reg = <0xfd900000 0x100>, <0xfd924000 0x1000>;
+			reg-names = "mdss_phys", "vbif_phys";
 
 			power-domains = <&mmcc MDSS_GDSC>;
 
 			clocks = <&mmcc MDSS_AHB_CLK>,
-			         <&mmcc MDSS_AXI_CLK>,
-			         <&mmcc MDSS_VSYNC_CLK>;
-			clock-names = "iface",
-			              "bus",
-			              "vsync";
+				 <&mmcc MDSS_AXI_CLK>,
+				 <&mmcc MDSS_VSYNC_CLK>;
+			clock-names = "iface", "bus", "vsync";
 
 			interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
 
 			interrupt-controller;
 			#interrupt-cells = <1>;
 
+			status = "disabled";
+
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges;
 
 			mdp: mdp@fd900000 {
-				status = "disabled";
-
 				compatible = "qcom,mdp5";
 				reg = <0xfd900100 0x22000>;
 				reg-names = "mdp_phys";
@@ -1501,10 +1495,7 @@ mdp: mdp@fd900000 {
 					 <&mmcc MDSS_AXI_CLK>,
 					 <&mmcc MDSS_MDP_CLK>,
 					 <&mmcc MDSS_VSYNC_CLK>;
-				clock-names = "iface",
-				              "bus",
-				              "core",
-				              "vsync";
+				clock-names = "iface", "bus", "core", "vsync";
 
 				interconnects = <&mmssnoc MNOC_MAS_MDP_PORT0 &bimc BIMC_SLV_EBI_CH0>;
 				interconnect-names = "mdp0-mem";
@@ -1523,8 +1514,6 @@ mdp5_intf1_out: endpoint {
 			};
 
 			dsi0: dsi@fd922800 {
-				status = "disabled";
-
 				compatible = "qcom,mdss-dsi-ctrl";
 				reg = <0xfd922800 0x1f8>;
 				reg-names = "dsi_ctrl";
@@ -1532,29 +1521,32 @@ dsi0: dsi@fd922800 {
 				interrupt-parent = <&mdss>;
 				interrupts = <4 IRQ_TYPE_LEVEL_HIGH>;
 
-				assigned-clocks = <&mmcc BYTE0_CLK_SRC>,
-				                  <&mmcc PCLK0_CLK_SRC>;
-				assigned-clock-parents = <&dsi_phy0 0>,
-				                         <&dsi_phy0 1>;
+				assigned-clocks = <&mmcc BYTE0_CLK_SRC>, <&mmcc PCLK0_CLK_SRC>;
+				assigned-clock-parents = <&dsi0_phy 0>, <&dsi0_phy 1>;
 
 				clocks = <&mmcc MDSS_MDP_CLK>,
-				         <&mmcc MDSS_AHB_CLK>,
-				         <&mmcc MDSS_AXI_CLK>,
-				         <&mmcc MDSS_BYTE0_CLK>,
-				         <&mmcc MDSS_PCLK0_CLK>,
-				         <&mmcc MDSS_ESC0_CLK>,
-				         <&mmcc MMSS_MISC_AHB_CLK>;
+					 <&mmcc MDSS_AHB_CLK>,
+					 <&mmcc MDSS_AXI_CLK>,
+					 <&mmcc MDSS_BYTE0_CLK>,
+					 <&mmcc MDSS_PCLK0_CLK>,
+					 <&mmcc MDSS_ESC0_CLK>,
+					 <&mmcc MMSS_MISC_AHB_CLK>;
 				clock-names = "mdp_core",
-				              "iface",
-				              "bus",
-				              "byte",
-				              "pixel",
-				              "core",
-				              "core_mmss";
-
-				phys = <&dsi_phy0>;
+					      "iface",
+					      "bus",
+					      "byte",
+					      "pixel",
+					      "core",
+					      "core_mmss";
+
+				phys = <&dsi0_phy>;
 				phy-names = "dsi-phy";
 
+				status = "disabled";
+
+				#address-cells = <1>;
+				#size-cells = <0>;
+
 				ports {
 					#address-cells = <1>;
 					#size-cells = <0>;
@@ -1574,23 +1566,22 @@ dsi0_out: endpoint {
 				};
 			};
 
-			dsi_phy0: dsi-phy@fd922a00 {
-				status = "disabled";
-
+			dsi0_phy: dsi-phy@fd922a00 {
 				compatible = "qcom,dsi-phy-28nm-hpm";
 				reg = <0xfd922a00 0xd4>,
 				      <0xfd922b00 0x280>,
 				      <0xfd922d80 0x30>;
 				reg-names = "dsi_pll",
-				            "dsi_phy",
-				            "dsi_phy_regulator";
+					    "dsi_phy",
+					    "dsi_phy_regulator";
 
 				#clock-cells = <1>;
 				#phy-cells = <0>;
-				qcom,dsi-phy-index = <0>;
 
 				clocks = <&mmcc MDSS_AHB_CLK>, <&xo_board>;
 				clock-names = "iface", "ref";
+
+				status = "disabled";
 			};
 		};
 
-- 
2.35.1



