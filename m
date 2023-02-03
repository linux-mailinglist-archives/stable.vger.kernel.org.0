Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877E2689692
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbjBCK1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233606AbjBCK1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:27:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEC9A0014
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:26:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 973A6B82A6C
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8029C433D2;
        Fri,  3 Feb 2023 10:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419688;
        bh=TAjISH3kC9VlyZ71RgLxYE9fYC9FDp1gSpzujC+9D8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwSH/WnoWZ2jza59DQ2kV/rb/uUJlz4mqJt6IVJbh1cL5yunExNTkUsNEYKBETipK
         RD803RJyDDGXVwiAkW5MaSNmpMrCgVk745GwnH48g++6gG2fVqMmr0GtKk7vir/YYg
         V8SG0U4rBIF1g8HlHExLxbCN92KoySDCIqnk3qpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 03/28] arm64: dts: freescale: Fix pca954x i2c-mux node names
Date:   Fri,  3 Feb 2023 11:12:51 +0100
Message-Id: <20230203101010.120524672@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit b025b4f5c288e29bbea421613a5b4eacf9261fbb ]

"make dtbs_check":

    arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dtb: pca9547@77: $nodename:0: 'pca9547@77' does not match '^(i2c-?)?mux'
	    From schema: Documentation/devicetree/bindings/i2c/i2c-mux-pca954x.yaml
    arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dtb: pca9547@77: Unevaluated properties are not allowed ('#address-cells', '#size-cells', 'i2c@4' were unexpected)
	    From schema: Documentation/devicetree/bindings/i2c/i2c-mux-pca954x.yaml
    ...

Fix this by renaming PCA954x nodes to "i2c-mux", to match the I2C bus
multiplexer/switch DT bindings and the Generic Names Recommendation in
the Devicetree Specification.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts    | 2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts    | 2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts    | 2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts    | 2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts    | 2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts  | 2 +-
 arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi   | 2 +-
 arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi   | 2 +-
 arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi  | 2 +-
 arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts | 2 +-
 arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts    | 4 ++--
 arch/arm64/boot/dts/freescale/imx8qxp-mek.dts        | 2 +-
 12 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts
index 5a8d85a7d161..bbdf989058ff 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts
@@ -110,7 +110,7 @@ &esdhc1 {
 &i2c0 {
 	status = "okay";
 
-	pca9547@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts
index 9b726c2a4842..dda27ed7aaf2 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts
@@ -89,7 +89,7 @@ fpga: board-control@2,0 {
 &i2c0 {
 	status = "okay";
 
-	pca9547@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts
index b2fcbba60d3a..3b0ed9305f2b 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts
@@ -88,7 +88,7 @@ &duart1 {
 &i2c0 {
 	status = "okay";
 
-	pca9547@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts
index 41d8b15f25a5..aa52ff73ff9e 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts
@@ -53,7 +53,7 @@ flash@2 {
 &i2c0 {
 	status = "okay";
 
-	i2c-switch@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
index 1bfbce69cc8b..ee8e932628d1 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
@@ -136,7 +136,7 @@ mdio2_aquantia_phy: ethernet-phy@0 {
 &i2c0 {
 	status = "okay";
 
-	i2c-switch@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts b/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts
index ef6c8967533e..d4867d6cf47c 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts
@@ -245,7 +245,7 @@ rx8035: rtc@32 {
 &i2c3 {
 	status = "okay";
 
-	i2c-switch@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9540";
 		#address-cells = <1>;
 		#size-cells = <0>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi
index f598669e742f..52c5a43b30a0 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi
@@ -103,7 +103,7 @@ mdio0_phy15: mdio-phy3@1f {
 
 &i2c0 {
 	status = "okay";
-	pca9547@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi
index 3d9647b3da14..537cecb13dd0 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi
@@ -44,7 +44,7 @@ cpld@3,0 {
 
 &i2c0 {
 	status = "okay";
-	pca9547@75 {
+	i2c-mux@75 {
 		compatible = "nxp,pca9547";
 		reg = <0x75>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi
index afb455210bd0..d32a52ab00a4 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi
@@ -54,7 +54,7 @@ &esdhc1 {
 &i2c0 {
 	status = "okay";
 
-	i2c-switch@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		#address-cells = <1>;
 		#size-cells = <0>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts b/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts
index 74c09891600f..6357078185ed 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts
@@ -214,7 +214,7 @@ &i2c3 {
 	pinctrl-0 = <&pinctrl_i2c3>;
 	status = "okay";
 
-	i2cmux@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9540";
 		reg = <0x70>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts b/arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts
index 9dda2a1554c3..8614c18b5998 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts
@@ -133,7 +133,7 @@ &i2c1 {
 	pinctrl-0 = <&pinctrl_i2c1>;
 	status = "okay";
 
-	i2cmux@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9546";
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_i2c1_pca9546>;
@@ -216,7 +216,7 @@ &i2c4 {
 	pinctrl-0 = <&pinctrl_i2c4>;
 	status = "okay";
 
-	pca9546: i2cmux@70 {
+	pca9546: i2c-mux@70 {
 		compatible = "nxp,pca9546";
 		reg = <0x70>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
index 07d8dd8160f6..afa883389456 100644
--- a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
@@ -61,7 +61,7 @@ &i2c1 {
 	pinctrl-0 = <&pinctrl_lpi2c1 &pinctrl_ioexp_rst>;
 	status = "okay";
 
-	i2c-switch@71 {
+	i2c-mux@71 {
 		compatible = "nxp,pca9646", "nxp,pca9546";
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
2.39.0



