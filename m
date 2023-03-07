Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0012F6AE882
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbjCGRQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:16:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjCGRQS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:16:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB61095BD3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:11:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A895BB81995
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF1DC433D2;
        Tue,  7 Mar 2023 17:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209107;
        bh=s7l1xUCZGT7iM65ouzHlDRI47WTcmC58NpaaizK3dxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0uRiUQ+6Ms7DbCetu/dY5f3XY3zY99wldW1kXoaDyfidOjyTOD2rRn0R6Mf++NVI3
         Gyi9MGYbV8f11xvzLuJaOhIccAUihDp4qv/4hidK7ebm5/+3DGhGRph5d54k2B5a2T
         GLrv+8+34PPxvgF71w3W1Ka5pUl3r+P89mY9496U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0112/1001] arm64: dts: qcom: msm8996 switch from RPM_SMD_BB_CLK1 to RPM_SMD_XO_CLK_SRC
Date:   Tue,  7 Mar 2023 17:48:04 +0100
Message-Id: <20230307170026.971042854@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 8ae72166c2b73b0f2ce498ea15d4feceb9fef50e ]

The vendor kernel uses RPM_SMD_XO_CLK_SRC clock as an CXO clock rather
than using the RPM_SMD_BB_CLK1 directly. Follow this example and switch
msm8996.dtsi to use RPM_SMD_XO_CLK_SRC clock instead of RPM_SMB_BB_CLK1.

Fixes: 2b8c9c77c268 ("arm64: dts: qcom: msm8996: convert xo_board to RPM_SMD_BB_CLK1")
Suggested-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230120061417.2623751-7-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 286f7b44057dd..a444d9b531228 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -713,7 +713,7 @@ gcc: clock-controller@300000 {
 			#power-domain-cells = <1>;
 			reg = <0x00300000 0x90000>;
 
-			clocks = <&rpmcc RPM_SMD_BB_CLK1>,
+			clocks = <&rpmcc RPM_SMD_XO_CLK_SRC>,
 				 <&rpmcc RPM_SMD_LN_BB_CLK>,
 				 <&sleep_clk>,
 				 <&pciephy_0>,
@@ -1050,7 +1050,7 @@ dsi0_phy: phy@994400 {
 				#clock-cells = <1>;
 				#phy-cells = <0>;
 
-				clocks = <&mmcc MDSS_AHB_CLK>, <&rpmcc RPM_SMD_BB_CLK1>;
+				clocks = <&mmcc MDSS_AHB_CLK>, <&rpmcc RPM_SMD_XO_CLK_SRC>;
 				clock-names = "iface", "ref";
 				status = "disabled";
 			};
@@ -1117,7 +1117,7 @@ dsi1_phy: phy@996400 {
 				#clock-cells = <1>;
 				#phy-cells = <0>;
 
-				clocks = <&mmcc MDSS_AHB_CLK>, <&rpmcc RPM_SMD_BB_CLK1>;
+				clocks = <&mmcc MDSS_AHB_CLK>, <&rpmcc RPM_SMD_XO_CLK_SRC>;
 				clock-names = "iface", "ref";
 				status = "disabled";
 			};
@@ -2941,7 +2941,7 @@ kryocc: clock-controller@6400000 {
 			reg = <0x06400000 0x90000>;
 
 			clock-names = "xo", "sys_apcs_aux";
-			clocks = <&rpmcc RPM_SMD_BB_CLK1>, <&apcs_glb>;
+			clocks = <&rpmcc RPM_SMD_XO_A_CLK_SRC>, <&apcs_glb>;
 
 			#clock-cells = <1>;
 		};
@@ -3060,7 +3060,7 @@ sdhc1: mmc@7464900 {
 			clock-names = "iface", "core", "xo";
 			clocks = <&gcc GCC_SDCC1_AHB_CLK>,
 				<&gcc GCC_SDCC1_APPS_CLK>,
-				<&rpmcc RPM_SMD_BB_CLK1>;
+				<&rpmcc RPM_SMD_XO_CLK_SRC>;
 			resets = <&gcc GCC_SDCC1_BCR>;
 
 			pinctrl-names = "default", "sleep";
@@ -3084,7 +3084,7 @@ sdhc2: mmc@74a4900 {
 			clock-names = "iface", "core", "xo";
 			clocks = <&gcc GCC_SDCC2_AHB_CLK>,
 				<&gcc GCC_SDCC2_APPS_CLK>,
-				<&rpmcc RPM_SMD_BB_CLK1>;
+				<&rpmcc RPM_SMD_XO_CLK_SRC>;
 			resets = <&gcc GCC_SDCC2_BCR>;
 
 			pinctrl-names = "default", "sleep";
@@ -3406,7 +3406,7 @@ adsp_pil: remoteproc@9300000 {
 			interrupt-names = "wdog", "fatal", "ready",
 					  "handover", "stop-ack";
 
-			clocks = <&rpmcc RPM_SMD_BB_CLK1>;
+			clocks = <&rpmcc RPM_SMD_XO_CLK_SRC>;
 			clock-names = "xo";
 
 			memory-region = <&adsp_mem>;
-- 
2.39.2



