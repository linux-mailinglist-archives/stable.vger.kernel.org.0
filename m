Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1065BAA6D
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbiIPKOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbiIPKNt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:13:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55686A99DF;
        Fri, 16 Sep 2022 03:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C69962A0A;
        Fri, 16 Sep 2022 10:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47569C433C1;
        Fri, 16 Sep 2022 10:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323006;
        bh=g2Wmzi2h5AurOU7Q7uLwWj3zs71sGecKWErlU3thULc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HX/AXwTf9QC3COQiTDI6v7E41WGWW1473zk1f6TWaZwY33WLoaaG2JZDr340RxdZw
         RKkNghqs5IfYBYlcodIOVYPlvqPHWkG8EEpNlWaepcPX9jg6bTkcZErtqEKgs1hDGO
         d5J90GmrlZz1nX364tSv7+Vf16vcjNl96roQXKao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/24] ARM: dts: imx: align SPI NOR node name with dtschema
Date:   Fri, 16 Sep 2022 12:08:26 +0200
Message-Id: <20220916100445.419170990@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100445.354452396@linuxfoundation.org>
References: <20220916100445.354452396@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit ba9fe460dc2cfe90dc115b22af14dd3f13cffa0f ]

The node names should be generic and SPI NOR dtschema expects "flash".

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: af7d78c95701 ("ARM: dts: imx6qdl-kontron-samx6i: fix spi-flash compatible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx28-evk.dts                        | 2 +-
 arch/arm/boot/dts/imx28-m28evk.dts                     | 2 +-
 arch/arm/boot/dts/imx28-sps1.dts                       | 2 +-
 arch/arm/boot/dts/imx6dl-rex-basic.dts                 | 2 +-
 arch/arm/boot/dts/imx6q-ba16.dtsi                      | 2 +-
 arch/arm/boot/dts/imx6q-bx50v3.dtsi                    | 2 +-
 arch/arm/boot/dts/imx6q-cm-fx6.dts                     | 2 +-
 arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts                | 2 +-
 arch/arm/boot/dts/imx6q-dms-ba16.dts                   | 2 +-
 arch/arm/boot/dts/imx6q-gw5400-a.dts                   | 2 +-
 arch/arm/boot/dts/imx6q-marsboard.dts                  | 2 +-
 arch/arm/boot/dts/imx6q-rex-pro.dts                    | 2 +-
 arch/arm/boot/dts/imx6qdl-aristainetos.dtsi            | 2 +-
 arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi           | 2 +-
 arch/arm/boot/dts/imx6qdl-dfi-fs700-m60.dtsi           | 2 +-
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi          | 2 +-
 arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi               | 2 +-
 arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi           | 2 +-
 arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi          | 2 +-
 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi              | 2 +-
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi               | 2 +-
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi               | 2 +-
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi                 | 2 +-
 arch/arm/boot/dts/imx6sl-evk.dts                       | 2 +-
 arch/arm/boot/dts/imx6sx-nitrogen6sx.dts               | 2 +-
 arch/arm/boot/dts/imx6sx-sdb-reva.dts                  | 4 ++--
 arch/arm/boot/dts/imx6sx-sdb.dts                       | 4 ++--
 arch/arm/boot/dts/imx6ul-14x14-evk.dtsi                | 2 +-
 arch/arm/boot/dts/imx6ul-kontron-n6310-som.dtsi        | 2 +-
 arch/arm/boot/dts/imx6ul-kontron-n6311-som.dtsi        | 2 +-
 arch/arm/boot/dts/imx6ul-kontron-n6x1x-som-common.dtsi | 2 +-
 arch/arm/boot/dts/imx6ull-kontron-n6411-som.dtsi       | 2 +-
 32 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/arch/arm/boot/dts/imx28-evk.dts b/arch/arm/boot/dts/imx28-evk.dts
index 7e2b0f198dfad..1053b7c584d81 100644
--- a/arch/arm/boot/dts/imx28-evk.dts
+++ b/arch/arm/boot/dts/imx28-evk.dts
@@ -129,7 +129,7 @@
 				pinctrl-0 = <&spi2_pins_a>;
 				status = "okay";
 
-				flash: m25p80@0 {
+				flash: flash@0 {
 					#address-cells = <1>;
 					#size-cells = <1>;
 					compatible = "sst,sst25vf016b", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx28-m28evk.dts b/arch/arm/boot/dts/imx28-m28evk.dts
index f3bddc5ada4b8..13acdc7916b9b 100644
--- a/arch/arm/boot/dts/imx28-m28evk.dts
+++ b/arch/arm/boot/dts/imx28-m28evk.dts
@@ -33,7 +33,7 @@
 				pinctrl-0 = <&spi2_pins_a>;
 				status = "okay";
 
-				flash: m25p80@0 {
+				flash: flash@0 {
 					#address-cells = <1>;
 					#size-cells = <1>;
 					compatible = "m25p80", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx28-sps1.dts b/arch/arm/boot/dts/imx28-sps1.dts
index 43be7a6a769bc..90928db0df701 100644
--- a/arch/arm/boot/dts/imx28-sps1.dts
+++ b/arch/arm/boot/dts/imx28-sps1.dts
@@ -51,7 +51,7 @@
 				pinctrl-0 = <&spi2_pins_a>;
 				status = "okay";
 
-				flash: m25p80@0 {
+				flash: flash@0 {
 					#address-cells = <1>;
 					#size-cells = <1>;
 					compatible = "everspin,mr25h256", "mr25h256";
diff --git a/arch/arm/boot/dts/imx6dl-rex-basic.dts b/arch/arm/boot/dts/imx6dl-rex-basic.dts
index 0f1616bfa9a80..b72f8ea1e6f6c 100644
--- a/arch/arm/boot/dts/imx6dl-rex-basic.dts
+++ b/arch/arm/boot/dts/imx6dl-rex-basic.dts
@@ -19,7 +19,7 @@
 };
 
 &ecspi3 {
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "sst,sst25vf016b", "jedec,spi-nor";
 		spi-max-frequency = <20000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6q-ba16.dtsi b/arch/arm/boot/dts/imx6q-ba16.dtsi
index e4578ed3371ef..133991ca8c633 100644
--- a/arch/arm/boot/dts/imx6q-ba16.dtsi
+++ b/arch/arm/boot/dts/imx6q-ba16.dtsi
@@ -139,7 +139,7 @@
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: n25q032@0 {
+	flash: flash@0 {
 		compatible = "jedec,spi-nor";
 		#address-cells = <1>;
 		#size-cells = <1>;
diff --git a/arch/arm/boot/dts/imx6q-bx50v3.dtsi b/arch/arm/boot/dts/imx6q-bx50v3.dtsi
index 2a98cc657595f..66be04299cbf8 100644
--- a/arch/arm/boot/dts/imx6q-bx50v3.dtsi
+++ b/arch/arm/boot/dts/imx6q-bx50v3.dtsi
@@ -160,7 +160,7 @@
 	pinctrl-0 = <&pinctrl_ecspi5>;
 	status = "okay";
 
-	m25_eeprom: m25p80@0 {
+	m25_eeprom: flash@0 {
 		compatible = "atmel,at25";
 		spi-max-frequency = <10000000>;
 		size = <0x8000>;
diff --git a/arch/arm/boot/dts/imx6q-cm-fx6.dts b/arch/arm/boot/dts/imx6q-cm-fx6.dts
index bfb530f29d9de..1ad41c944b4b9 100644
--- a/arch/arm/boot/dts/imx6q-cm-fx6.dts
+++ b/arch/arm/boot/dts/imx6q-cm-fx6.dts
@@ -260,7 +260,7 @@
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	m25p80@0 {
+	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "st,m25p", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts b/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts
index fa2307d8ce861..4dee1b22d5c17 100644
--- a/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts
+++ b/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts
@@ -102,7 +102,7 @@
 	cs-gpios = <&gpio1 12 GPIO_ACTIVE_LOW>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "m25p80", "jedec,spi-nor";
 		spi-max-frequency = <40000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6q-dms-ba16.dts b/arch/arm/boot/dts/imx6q-dms-ba16.dts
index 48fb47e715f6d..137db38f0d27b 100644
--- a/arch/arm/boot/dts/imx6q-dms-ba16.dts
+++ b/arch/arm/boot/dts/imx6q-dms-ba16.dts
@@ -47,7 +47,7 @@
 	pinctrl-0 = <&pinctrl_ecspi5>;
 	status = "okay";
 
-	m25_eeprom: m25p80@0 {
+	m25_eeprom: flash@0 {
 		compatible = "atmel,at25256B", "atmel,at25";
 		spi-max-frequency = <20000000>;
 		size = <0x8000>;
diff --git a/arch/arm/boot/dts/imx6q-gw5400-a.dts b/arch/arm/boot/dts/imx6q-gw5400-a.dts
index 4cde45d5c90c8..e894faba571f9 100644
--- a/arch/arm/boot/dts/imx6q-gw5400-a.dts
+++ b/arch/arm/boot/dts/imx6q-gw5400-a.dts
@@ -137,7 +137,7 @@
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "sst,w25q256", "jedec,spi-nor";
 		spi-max-frequency = <30000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6q-marsboard.dts b/arch/arm/boot/dts/imx6q-marsboard.dts
index 05ee283882290..cc18010023942 100644
--- a/arch/arm/boot/dts/imx6q-marsboard.dts
+++ b/arch/arm/boot/dts/imx6q-marsboard.dts
@@ -100,7 +100,7 @@
 	cs-gpios = <&gpio2 30 GPIO_ACTIVE_LOW>;
 	status = "okay";
 
-	m25p80@0 {
+	flash@0 {
 		compatible = "microchip,sst25vf016b";
 		spi-max-frequency = <20000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6q-rex-pro.dts b/arch/arm/boot/dts/imx6q-rex-pro.dts
index 1767e1a3cd53a..271f4b2d9b9f0 100644
--- a/arch/arm/boot/dts/imx6q-rex-pro.dts
+++ b/arch/arm/boot/dts/imx6q-rex-pro.dts
@@ -19,7 +19,7 @@
 };
 
 &ecspi3 {
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "sst,sst25vf032b", "jedec,spi-nor";
 		spi-max-frequency = <20000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6qdl-aristainetos.dtsi b/arch/arm/boot/dts/imx6qdl-aristainetos.dtsi
index e21f6ac864e54..baa197c90060e 100644
--- a/arch/arm/boot/dts/imx6qdl-aristainetos.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-aristainetos.dtsi
@@ -96,7 +96,7 @@
 	pinctrl-0 = <&pinctrl_ecspi4>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "micron,n25q128a11", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi b/arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi
index ead7ba27e1053..ff8cb47fb9fdb 100644
--- a/arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi
@@ -131,7 +131,7 @@
 	pinctrl-0 = <&pinctrl_ecspi4>;
 	status = "okay";
 
-	flash: m25p80@1 {
+	flash: flash@1 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "micron,n25q128a11", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx6qdl-dfi-fs700-m60.dtsi b/arch/arm/boot/dts/imx6qdl-dfi-fs700-m60.dtsi
index 648f5fcb72e65..2c1d6f28e6950 100644
--- a/arch/arm/boot/dts/imx6qdl-dfi-fs700-m60.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-dfi-fs700-m60.dtsi
@@ -35,7 +35,7 @@
 	pinctrl-0 = <&pinctrl_ecspi3>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "sst,sst25vf040b", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index e9a4115124eb0..02ab8a59df23a 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -248,7 +248,7 @@
 	status = "okay";
 
 	/* default boot source: workaround #1 for errata ERR006282 */
-	smarc_flash: spi-flash@0 {
+	smarc_flash: flash@0 {
 		compatible = "winbond,w25q16dw", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <20000000>;
diff --git a/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi b/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi
index d526f01a2c520..b7e74d859a962 100644
--- a/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi
@@ -179,7 +179,7 @@
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "microchip,sst25vf016b";
 		spi-max-frequency = <20000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi b/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi
index a0917823c244f..a88323ac6c696 100644
--- a/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi
@@ -321,7 +321,7 @@
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "microchip,sst25vf016b";
 		spi-max-frequency = <20000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi b/arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi
index 92d09a3ebe0ee..ee7e2371f94bd 100644
--- a/arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi
@@ -252,7 +252,7 @@
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "microchip,sst25vf016b";
 		spi-max-frequency = <20000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi b/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
index 1243677b5f977..5adeb7aed2204 100644
--- a/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
@@ -237,7 +237,7 @@
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "sst,sst25vf016b", "jedec,spi-nor";
 		spi-max-frequency = <20000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
index afe477f329846..17535bf12516d 100644
--- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
@@ -272,7 +272,7 @@
 	pinctrl-0 = <&pinctrl_ecspi1 &pinctrl_ecspi1_cs>;
 	status = "disabled"; /* pin conflict with WEIM NOR */
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "st,m25p32", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
index fdc3aa9d544d3..0aa1a0a28de0c 100644
--- a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
@@ -313,7 +313,7 @@
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "sst,sst25vf016b", "jedec,spi-nor";
 		spi-max-frequency = <20000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
index f824c9abd11a3..758c62fb9cac1 100644
--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -194,7 +194,7 @@
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "st,m25p32", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx6sl-evk.dts b/arch/arm/boot/dts/imx6sl-evk.dts
index 25f6f2fb1555e..f16c830f1e918 100644
--- a/arch/arm/boot/dts/imx6sl-evk.dts
+++ b/arch/arm/boot/dts/imx6sl-evk.dts
@@ -137,7 +137,7 @@
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "st,m25p32", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx6sx-nitrogen6sx.dts b/arch/arm/boot/dts/imx6sx-nitrogen6sx.dts
index 66af78e83b701..a2c79bcf9a11c 100644
--- a/arch/arm/boot/dts/imx6sx-nitrogen6sx.dts
+++ b/arch/arm/boot/dts/imx6sx-nitrogen6sx.dts
@@ -107,7 +107,7 @@
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "microchip,sst25vf016b";
 		spi-max-frequency = <20000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6sx-sdb-reva.dts b/arch/arm/boot/dts/imx6sx-sdb-reva.dts
index dce5dcf96c255..7dda42553f4bc 100644
--- a/arch/arm/boot/dts/imx6sx-sdb-reva.dts
+++ b/arch/arm/boot/dts/imx6sx-sdb-reva.dts
@@ -123,7 +123,7 @@
 	pinctrl-0 = <&pinctrl_qspi2>;
 	status = "okay";
 
-	flash0: s25fl128s@0 {
+	flash0: flash@0 {
 		reg = <0>;
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -133,7 +133,7 @@
 		spi-tx-bus-width = <4>;
 	};
 
-	flash1: s25fl128s@2 {
+	flash1: flash@2 {
 		reg = <2>;
 		#address-cells = <1>;
 		#size-cells = <1>;
diff --git a/arch/arm/boot/dts/imx6sx-sdb.dts b/arch/arm/boot/dts/imx6sx-sdb.dts
index 5a63ca6157229..1b808563a536a 100644
--- a/arch/arm/boot/dts/imx6sx-sdb.dts
+++ b/arch/arm/boot/dts/imx6sx-sdb.dts
@@ -108,7 +108,7 @@
 	pinctrl-0 = <&pinctrl_qspi2>;
 	status = "okay";
 
-	flash0: n25q256a@0 {
+	flash0: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "micron,n25q256a", "jedec,spi-nor";
@@ -118,7 +118,7 @@
 		reg = <0>;
 	};
 
-	flash1: n25q256a@2 {
+	flash1: flash@2 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "micron,n25q256a", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi b/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
index 64c2d1e9f7fce..71d3c7e05e08f 100644
--- a/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
+++ b/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
@@ -239,7 +239,7 @@
 	pinctrl-0 = <&pinctrl_qspi>;
 	status = "okay";
 
-	flash0: n25q256a@0 {
+	flash0: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "micron,n25q256a", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx6ul-kontron-n6310-som.dtsi b/arch/arm/boot/dts/imx6ul-kontron-n6310-som.dtsi
index 47d3ce5d255fa..acd936540d898 100644
--- a/arch/arm/boot/dts/imx6ul-kontron-n6310-som.dtsi
+++ b/arch/arm/boot/dts/imx6ul-kontron-n6310-som.dtsi
@@ -19,7 +19,7 @@
 };
 
 &qspi {
-	spi-flash@0 {
+	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "spi-nand";
diff --git a/arch/arm/boot/dts/imx6ul-kontron-n6311-som.dtsi b/arch/arm/boot/dts/imx6ul-kontron-n6311-som.dtsi
index a095a7654ac65..29ed38dce5802 100644
--- a/arch/arm/boot/dts/imx6ul-kontron-n6311-som.dtsi
+++ b/arch/arm/boot/dts/imx6ul-kontron-n6311-som.dtsi
@@ -18,7 +18,7 @@
 };
 
 &qspi {
-	spi-flash@0 {
+	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "spi-nand";
diff --git a/arch/arm/boot/dts/imx6ul-kontron-n6x1x-som-common.dtsi b/arch/arm/boot/dts/imx6ul-kontron-n6x1x-som-common.dtsi
index 2a449a3c1ae27..09a83dbdf6510 100644
--- a/arch/arm/boot/dts/imx6ul-kontron-n6x1x-som-common.dtsi
+++ b/arch/arm/boot/dts/imx6ul-kontron-n6x1x-som-common.dtsi
@@ -19,7 +19,7 @@
 	pinctrl-0 = <&pinctrl_ecspi2>;
 	status = "okay";
 
-	spi-flash@0 {
+	flash@0 {
 		compatible = "mxicy,mx25v8035f", "jedec,spi-nor";
 		spi-max-frequency = <50000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6ull-kontron-n6411-som.dtsi b/arch/arm/boot/dts/imx6ull-kontron-n6411-som.dtsi
index b7e984284e1ad..d000606c07049 100644
--- a/arch/arm/boot/dts/imx6ull-kontron-n6411-som.dtsi
+++ b/arch/arm/boot/dts/imx6ull-kontron-n6411-som.dtsi
@@ -18,7 +18,7 @@
 };
 
 &qspi {
-	spi-flash@0 {
+	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "spi-nand";
-- 
2.35.1



