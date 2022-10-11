Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED60D5FB582
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbiJKOyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiJKOxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:53:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABB49B87A;
        Tue, 11 Oct 2022 07:51:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00065611C2;
        Tue, 11 Oct 2022 14:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B818C43146;
        Tue, 11 Oct 2022 14:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499894;
        bh=YhQGSn+4euG52qTRPodDzsWPzobAa2ip+rcfkbfDx1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bBBNf1RiOi37KHk6KiomzEZCUMHV7n08BwQMkBcN/ZfzPJYC4yPqSfd3Mbe9/6J0N
         IuJ5RSvlD5hyXFuIPO0Oirge2NdwXmNjZfEK3iAOXCoNGNQVdx5LnZMeyuvQEujnPf
         XwAyW7kDfTaqPYULGXyPvP2txAQNME5lydJvlyoRleq+qNeeKPYfB+l4ePS5DnRBrQ
         Ap+l3XVlltYXYw8rtDCX3zb75MZ/O/M/FKJvQb9trDLrhWfdizuY6+P4VBW7Tqs+tz
         3zYOVyg5eM19UCeMgsNd1h7EHP6sXw0a1Z6KiGODACBTXAG7gbEXQwKVXcJ5Jat0pE
         Fs/Sl0jRt2Ggw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 02/40] ARM: dts: imx6: delete interrupts property if interrupts-extended is set
Date:   Tue, 11 Oct 2022 10:50:51 -0400
Message-Id: <20221011145129.1623487-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145129.1623487-1-sashal@kernel.org>
References: <20221011145129.1623487-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit c9d38ff7080b2c4fa6786b82210fa13115895aae ]

In most cases this is related to fsl,err006687-workaround-present, which
requires a GPIO interrupt next a GIC interrupt.

This fixes the dtbs_check warning:
imx6dl-mba6a.dtb: ethernet@2188000: More than one condition true in oneOf schema:
        {'$filename': 'Documentation/devicetree/bindings/net/fsl,fec.yaml',
[...]

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6dl-riotboard.dts        | 1 +
 arch/arm/boot/dts/imx6q-arm2.dts              | 1 +
 arch/arm/boot/dts/imx6q-evi.dts               | 1 +
 arch/arm/boot/dts/imx6q-mccmon6.dts           | 1 +
 arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi      | 1 +
 arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi  | 1 +
 arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi | 1 +
 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi     | 1 +
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi      | 1 +
 arch/arm/boot/dts/imx6qdl-tqma6a.dtsi         | 1 +
 arch/arm/boot/dts/imx6qdl-ts7970.dtsi         | 1 +
 11 files changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/imx6dl-riotboard.dts b/arch/arm/boot/dts/imx6dl-riotboard.dts
index e7d9bfbfd0e4..e7be05f205d3 100644
--- a/arch/arm/boot/dts/imx6dl-riotboard.dts
+++ b/arch/arm/boot/dts/imx6dl-riotboard.dts
@@ -90,6 +90,7 @@ &fec {
 	pinctrl-0 = <&pinctrl_enet>;
 	phy-mode = "rgmii-id";
 	phy-handle = <&rgmii_phy>;
+	/delete-property/ interrupts;
 	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
 			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
 	fsl,err006687-workaround-present;
diff --git a/arch/arm/boot/dts/imx6q-arm2.dts b/arch/arm/boot/dts/imx6q-arm2.dts
index 0b40f52268b3..75586299d9ca 100644
--- a/arch/arm/boot/dts/imx6q-arm2.dts
+++ b/arch/arm/boot/dts/imx6q-arm2.dts
@@ -178,6 +178,7 @@ &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
 	phy-mode = "rgmii";
+	/delete-property/ interrupts;
 	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
 			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
 	fsl,err006687-workaround-present;
diff --git a/arch/arm/boot/dts/imx6q-evi.dts b/arch/arm/boot/dts/imx6q-evi.dts
index c63f371ede8b..78d941fef5df 100644
--- a/arch/arm/boot/dts/imx6q-evi.dts
+++ b/arch/arm/boot/dts/imx6q-evi.dts
@@ -146,6 +146,7 @@ &fec {
 	pinctrl-0 = <&pinctrl_enet>;
 	phy-mode = "rgmii";
 	phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
+	/delete-property/ interrupts;
 	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
 			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
 	fsl,err006687-workaround-present;
diff --git a/arch/arm/boot/dts/imx6q-mccmon6.dts b/arch/arm/boot/dts/imx6q-mccmon6.dts
index 55692c73943d..64ab01018b71 100644
--- a/arch/arm/boot/dts/imx6q-mccmon6.dts
+++ b/arch/arm/boot/dts/imx6q-mccmon6.dts
@@ -100,6 +100,7 @@ &fec {
 	pinctrl-0 = <&pinctrl_enet>;
 	phy-mode = "rgmii";
 	phy-reset-gpios = <&gpio1 27 GPIO_ACTIVE_LOW>;
+	/delete-property/ interrupts;
 	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
 			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
 	status = "okay";
diff --git a/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi b/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi
index 0ad4cb4f1e82..a53a5d0766a5 100644
--- a/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi
@@ -192,6 +192,7 @@ &fec {
 	phy-mode = "rgmii";
 	phy-handle = <&ethphy>;
 	phy-reset-gpios = <&gpio1 27 GPIO_ACTIVE_LOW>;
+	/delete-property/ interrupts;
 	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
 			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
 	fsl,err006687-workaround-present;
diff --git a/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi b/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi
index beaa2dcd436c..57c21a01f126 100644
--- a/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi
@@ -334,6 +334,7 @@ &fec {
 	phy-mode = "rgmii";
 	phy-handle = <&ethphy>;
 	phy-reset-gpios = <&gpio1 27 GPIO_ACTIVE_LOW>;
+	/delete-property/ interrupts;
 	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
 			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
 	fsl,err006687-workaround-present;
diff --git a/arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi b/arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi
index ee7e2371f94b..000e9dc97b1a 100644
--- a/arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi
@@ -263,6 +263,7 @@ &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
 	phy-mode = "rgmii";
+	/delete-property/ interrupts;
 	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
 			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
 	fsl,err006687-workaround-present;
diff --git a/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi b/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
index 904d5d051d63..731759bdd7f5 100644
--- a/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
@@ -267,6 +267,7 @@ &fec {
 	phy-mode = "rgmii";
 	phy-handle = <&ethphy>;
 	phy-reset-gpios = <&gpio1 27 GPIO_ACTIVE_LOW>;
+	/delete-property/ interrupts;
 	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
 			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
 	fsl,err006687-workaround-present;
diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
index 1368a4762037..3dbb460ef102 100644
--- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
@@ -295,6 +295,7 @@ &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
 	phy-mode = "rgmii-id";
+	/delete-property/ interrupts;
 	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
 			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
 	fsl,err006687-workaround-present;
diff --git a/arch/arm/boot/dts/imx6qdl-tqma6a.dtsi b/arch/arm/boot/dts/imx6qdl-tqma6a.dtsi
index 7dc3f0005b0f..0a36e1bce375 100644
--- a/arch/arm/boot/dts/imx6qdl-tqma6a.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-tqma6a.dtsi
@@ -7,6 +7,7 @@
 #include <dt-bindings/gpio/gpio.h>
 
 &fec {
+	/delete-property/ interrupts;
 	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
 			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
 	fsl,err006687-workaround-present;
diff --git a/arch/arm/boot/dts/imx6qdl-ts7970.dtsi b/arch/arm/boot/dts/imx6qdl-ts7970.dtsi
index d6ba4b2a60f6..c096d25a6f5b 100644
--- a/arch/arm/boot/dts/imx6qdl-ts7970.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-ts7970.dtsi
@@ -192,6 +192,7 @@ &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
 	phy-mode = "rgmii";
+	/delete-property/ interrupts;
 	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
 			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
 	fsl,err006687-workaround-present;
-- 
2.35.1

