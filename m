Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E8065781F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbiL1OsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbiL1Orm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:47:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0777E120B8
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:47:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3F82B816D6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D73C433D2;
        Wed, 28 Dec 2022 14:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238832;
        bh=lg8VjT05t0WdZpKXwapbTdguYeyPivlUPLrvrgbA2sU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IOcUJ1kS/5GgWQnHC/FZW/VUmweSmPvFuNvFYAQhMN+NBA17ekA3gJFb+cC9o+IPr
         TlKrzybF39cbUXj+zMhH44nws3ZxopiJMhOtSDKnazcQ6smWP1QJB4Hi1hT0NEiHjU
         L3GbxKEaS38smpwfKp8gnGACOEoKqrq0dEkSQAoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shawn Guo <shawn.guo@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/731] arm64: dts: qcom: Correct QMP PHY child node name
Date:   Wed, 28 Dec 2022 15:32:06 +0100
Message-Id: <20221228144257.094984934@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Shawn Guo <shawn.guo@linaro.org>

[ Upstream commit 1351512f29b4348e6b497f6343896c1033d409b4 ]

Many child nodes of QMP PHY are named without following bindings schema
and causing dtbs_check warnings like below.

phy@1c06000: 'lane@1c06800' does not match any of the regexes: '^phy@[0-9a-f]+$'
        arch/arm64/boot/dts/qcom/msm8998-asus-novago-tp370ql.dt.yaml
        arch/arm64/boot/dts/qcom/msm8998-hp-envy-x2.dt.yaml
        arch/arm64/boot/dts/qcom/msm8998-lenovo-miix-630.dt.yaml
        arch/arm64/boot/dts/qcom/msm8998-mtp.dt.yaml
        arch/arm64/boot/dts/qcom/msm8998-oneplus-cheeseburger.dt.yaml
        arch/arm64/boot/dts/qcom/msm8998-oneplus-dumpling.dt.yaml

Correct them to fix the warnings.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210929034253.24570-5-shawn.guo@linaro.org
Stable-dep-of: 36a31b3a8d9b ("arm64: dts: qcom: sm8150: fix UFS PHY registers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi |  2 +-
 arch/arm64/boot/dts/qcom/ipq8074.dtsi |  4 ++--
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 10 +++++-----
 arch/arm64/boot/dts/qcom/msm8998.dtsi |  6 +++---
 arch/arm64/boot/dts/qcom/sdm845.dtsi  | 10 +++++-----
 arch/arm64/boot/dts/qcom/sm8150.dtsi  |  6 +++---
 arch/arm64/boot/dts/qcom/sm8250.dtsi  | 10 +++++-----
 arch/arm64/boot/dts/qcom/sm8350.dtsi  |  2 +-
 8 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index ce4c2b4a5fc0..30ac0b2e8c89 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -401,7 +401,7 @@ pcie_phy: phy@84000 {
 			reset-names = "phy",
 				      "common";
 
-			pcie_phy0: lane@84200 {
+			pcie_phy0: phy@84200 {
 				reg = <0x0 0x84200 0x0 0x16c>, /* Serdes Tx */
 				      <0x0 0x84400 0x0 0x200>, /* Serdes Rx */
 				      <0x0 0x84800 0x0 0x4f4>; /* PCS: Lane0, COM, PCIE */
diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index 6b9ac0550490..9d4019e0949a 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -106,7 +106,7 @@ ssphy_1: phy@58000 {
 			reset-names = "phy","common";
 			status = "disabled";
 
-			usb1_ssphy: lane@58200 {
+			usb1_ssphy: phy@58200 {
 				reg = <0x00058200 0x130>,       /* Tx */
 				      <0x00058400 0x200>,     /* Rx */
 				      <0x00058800 0x1f8>,     /* PCS  */
@@ -149,7 +149,7 @@ ssphy_0: phy@78000 {
 			reset-names = "phy","common";
 			status = "disabled";
 
-			usb0_ssphy: lane@78200 {
+			usb0_ssphy: phy@78200 {
 				reg = <0x00078200 0x130>,       /* Tx */
 				      <0x00078400 0x200>,     /* Rx */
 				      <0x00078800 0x1f8>,     /* PCS  */
diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 70187fd03a26..40174220e8e2 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -618,7 +618,7 @@ pcie_phy: phy@34000 {
 			reset-names = "phy", "common", "cfg";
 			status = "disabled";
 
-			pciephy_0: lane@35000 {
+			pciephy_0: phy@35000 {
 				reg = <0x00035000 0x130>,
 				      <0x00035200 0x200>,
 				      <0x00035400 0x1dc>;
@@ -631,7 +631,7 @@ pciephy_0: lane@35000 {
 				reset-names = "lane0";
 			};
 
-			pciephy_1: lane@36000 {
+			pciephy_1: phy@36000 {
 				reg = <0x00036000 0x130>,
 				      <0x00036200 0x200>,
 				      <0x00036400 0x1dc>;
@@ -644,7 +644,7 @@ pciephy_1: lane@36000 {
 				reset-names = "lane1";
 			};
 
-			pciephy_2: lane@37000 {
+			pciephy_2: phy@37000 {
 				reg = <0x00037000 0x130>,
 				      <0x00037200 0x200>,
 				      <0x00037400 0x1dc>;
@@ -1763,7 +1763,7 @@ ufsphy: phy@627000 {
 			reset-names = "ufsphy";
 			status = "disabled";
 
-			ufsphy_lane: lanes@627400 {
+			ufsphy_lane: phy@627400 {
 				reg = <0x627400 0x12c>,
 				      <0x627600 0x200>,
 				      <0x627c00 0x1b4>;
@@ -2618,7 +2618,7 @@ usb3phy: phy@7410000 {
 			reset-names = "phy", "common";
 			status = "disabled";
 
-			ssusb_phy_0: lane@7410200 {
+			ssusb_phy_0: phy@7410200 {
 				reg = <0x07410200 0x200>,
 				      <0x07410400 0x130>,
 				      <0x07410600 0x1a8>;
diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
index 228339f81c32..5350b911f4f6 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -994,7 +994,7 @@ pcie_phy: phy@1c06000 {
 			vdda-phy-supply = <&vreg_l1a_0p875>;
 			vdda-pll-supply = <&vreg_l2a_1p2>;
 
-			pciephy: lane@1c06800 {
+			pciephy: phy@1c06800 {
 				reg = <0x01c06200 0x128>, <0x01c06400 0x1fc>, <0x01c06800 0x20c>;
 				#phy-cells = <0>;
 
@@ -1066,7 +1066,7 @@ ufsphy: phy@1da7000 {
 			reset-names = "ufsphy";
 			resets = <&ufshc 0>;
 
-			ufsphy_lanes: lanes@1da7400 {
+			ufsphy_lanes: phy@1da7400 {
 				reg = <0x01da7400 0x128>,
 				      <0x01da7600 0x1fc>,
 				      <0x01da7c00 0x1dc>,
@@ -1999,7 +1999,7 @@ usb3phy: phy@c010000 {
 				 <&gcc GCC_USB3PHY_PHY_BCR>;
 			reset-names = "phy", "common";
 
-			usb1_ssphy: lane@c010200 {
+			usb1_ssphy: phy@c010200 {
 				reg = <0xc010200 0x128>,
 				      <0xc010400 0x200>,
 				      <0xc010c00 0x20c>,
diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index ea7a272d267a..ed293f635f14 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2064,7 +2064,7 @@ pcie0_phy: phy@1c06000 {
 
 			status = "disabled";
 
-			pcie0_lane: lanes@1c06200 {
+			pcie0_lane: phy@1c06200 {
 				reg = <0 0x01c06200 0 0x128>,
 				      <0 0x01c06400 0 0x1fc>,
 				      <0 0x01c06800 0 0x218>,
@@ -2174,7 +2174,7 @@ pcie1_phy: phy@1c0a000 {
 
 			status = "disabled";
 
-			pcie1_lane: lanes@1c06200 {
+			pcie1_lane: phy@1c06200 {
 				reg = <0 0x01c0a800 0 0x800>,
 				      <0 0x01c0a800 0 0x800>,
 				      <0 0x01c0b800 0 0x400>;
@@ -2302,7 +2302,7 @@ ufs_mem_phy: phy@1d87000 {
 			reset-names = "ufsphy";
 			status = "disabled";
 
-			ufs_mem_phy_lanes: lanes@1d87400 {
+			ufs_mem_phy_lanes: phy@1d87400 {
 				reg = <0 0x01d87400 0 0x108>,
 				      <0 0x01d87600 0 0x1e0>,
 				      <0 0x01d87c00 0 0x1dc>,
@@ -3699,7 +3699,7 @@ usb_1_qmpphy: phy@88e9000 {
 				 <&gcc GCC_USB3_PHY_PRIM_BCR>;
 			reset-names = "phy", "common";
 
-			usb_1_ssphy: lanes@88e9200 {
+			usb_1_ssphy: phy@88e9200 {
 				reg = <0 0x088e9200 0 0x128>,
 				      <0 0x088e9400 0 0x200>,
 				      <0 0x088e9c00 0 0x218>,
@@ -3732,7 +3732,7 @@ usb_2_qmpphy: phy@88eb000 {
 				 <&gcc GCC_USB3_PHY_SEC_BCR>;
 			reset-names = "phy", "common";
 
-			usb_2_ssphy: lane@88eb200 {
+			usb_2_ssphy: phy@88eb200 {
 				reg = <0 0x088eb200 0 0x128>,
 				      <0 0x088eb400 0 0x1fc>,
 				      <0 0x088eb800 0 0x218>,
diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index f347f752d536..74c4acb8598b 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -1692,7 +1692,7 @@ ufs_mem_phy: phy@1d87000 {
 			reset-names = "ufsphy";
 			status = "disabled";
 
-			ufs_mem_phy_lanes: lanes@1d87400 {
+			ufs_mem_phy_lanes: phy@1d87400 {
 				reg = <0 0x01d87400 0 0x108>,
 				      <0 0x01d87600 0 0x1e0>,
 				      <0 0x01d87c00 0 0x1dc>,
@@ -3010,7 +3010,7 @@ usb_1_qmpphy: phy@88e9000 {
 				 <&gcc GCC_USB3_PHY_PRIM_BCR>;
 			reset-names = "phy", "common";
 
-			usb_1_ssphy: lanes@88e9200 {
+			usb_1_ssphy: phy@88e9200 {
 				reg = <0 0x088e9200 0 0x200>,
 				      <0 0x088e9400 0 0x200>,
 				      <0 0x088e9c00 0 0x218>,
@@ -3043,7 +3043,7 @@ usb_2_qmpphy: phy@88eb000 {
 				 <&gcc GCC_USB3_PHY_SEC_BCR>;
 			reset-names = "phy", "common";
 
-			usb_2_ssphy: lane@88eb200 {
+			usb_2_ssphy: phy@88eb200 {
 				reg = <0 0x088eb200 0 0x200>,
 				      <0 0x088eb400 0 0x200>,
 				      <0 0x088eb800 0 0x800>,
diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 9a95c15c7e8b..bcc948f6f326 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -1463,7 +1463,7 @@ pcie0_phy: phy@1c06000 {
 
 			status = "disabled";
 
-			pcie0_lane: lanes@1c06200 {
+			pcie0_lane: phy@1c06200 {
 				reg = <0 0x1c06200 0 0x170>, /* tx */
 				      <0 0x1c06400 0 0x200>, /* rx */
 				      <0 0x1c06800 0 0x1f0>, /* pcs */
@@ -1569,7 +1569,7 @@ pcie1_phy: phy@1c0e000 {
 
 			status = "disabled";
 
-			pcie1_lane: lanes@1c0e200 {
+			pcie1_lane: phy@1c0e200 {
 				reg = <0 0x1c0e200 0 0x170>, /* tx0 */
 				      <0 0x1c0e400 0 0x200>, /* rx0 */
 				      <0 0x1c0ea00 0 0x1f0>, /* pcs */
@@ -1677,7 +1677,7 @@ pcie2_phy: phy@1c16000 {
 
 			status = "disabled";
 
-			pcie2_lane: lanes@1c16200 {
+			pcie2_lane: phy@1c16200 {
 				reg = <0 0x1c16200 0 0x170>, /* tx0 */
 				      <0 0x1c16400 0 0x200>, /* rx0 */
 				      <0 0x1c16a00 0 0x1f0>, /* pcs */
@@ -1756,7 +1756,7 @@ ufs_mem_phy: phy@1d87000 {
 			reset-names = "ufsphy";
 			status = "disabled";
 
-			ufs_mem_phy_lanes: lanes@1d87400 {
+			ufs_mem_phy_lanes: phy@1d87400 {
 				reg = <0 0x01d87400 0 0x108>,
 				      <0 0x01d87600 0 0x1e0>,
 				      <0 0x01d87c00 0 0x1dc>,
@@ -2336,7 +2336,7 @@ usb_2_qmpphy: phy@88eb000 {
 				 <&gcc GCC_USB3_PHY_SEC_BCR>;
 			reset-names = "phy", "common";
 
-			usb_2_ssphy: lanes@88eb200 {
+			usb_2_ssphy: phy@88eb200 {
 				reg = <0 0x088eb200 0 0x200>,
 				      <0 0x088eb400 0 0x200>,
 				      <0 0x088eb800 0 0x800>;
diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index c0a3ea47302f..d6dc55687c2a 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1123,7 +1123,7 @@ ufs_mem_phy: phy@1d87000 {
 			reset-names = "ufsphy";
 			status = "disabled";
 
-			ufs_mem_phy_lanes: lanes@1d87400 {
+			ufs_mem_phy_lanes: phy@1d87400 {
 				reg = <0 0x01d87400 0 0x108>,
 				      <0 0x01d87600 0 0x1e0>,
 				      <0 0x01d87c00 0 0x1dc>,
-- 
2.35.1



