Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3DA6268EA
	for <lists+stable@lfdr.de>; Sat, 12 Nov 2022 11:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiKLKiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Nov 2022 05:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiKLKiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Nov 2022 05:38:13 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3231A1
        for <stable@vger.kernel.org>; Sat, 12 Nov 2022 02:38:11 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d20so6159575plr.10
        for <stable@vger.kernel.org>; Sat, 12 Nov 2022 02:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=omnom-net.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kDuzQEJ/vfTCz3X53jjJoYD/pbdjljof7AB8Sd/6cNo=;
        b=C4vD25zQW8ni/DSfqcMcJolhz1iNkIzleveX/jdzL51eQXYYziH536EbFrda/fmKvl
         N7qLwtkXVLtGTasJufgrsliqAWfCL639qGyWmWn27AE3a5TFUMyyV8EAyUr/XZybkAJN
         d08XmHlxmnNOO5R+o1CmNZmkENLhVEYYxHqHYgWYcLILM5KkqGRqeBLwZ136XXdZDK6I
         60yVAbhHlGGzU9hhLRIryNFbb82VmvOC8wrSc60Wcw4vKeOuIdAjQjzO0LT60AvKw4SS
         9MwjxE47pGjJKZy1Ju+MkAgaMgN52QR/webAWMXYJmdCoaRYYqOtk5Kshjqvvk1eRE/s
         kxCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kDuzQEJ/vfTCz3X53jjJoYD/pbdjljof7AB8Sd/6cNo=;
        b=lefWgzRx/BRkOHiotW8d55TqfT0p6hpgD2ObShdiHaqIWy1dbXRAwi4Dmfx4UNxu5W
         A4dPnD45VEhqPKkQNFT5T4VSskz3bLSnvMWINOo/5H8HakddmcK7nRW87XrLfRXfXX7y
         2GmVb9w6h43NnaxVjOE4CJqfgu38fTpHt7pRcxXqHtn9/26URhuRS4X+dsjFYH66qkTH
         cLSAlqwrm7tE2eum0j2lrHNFaas/Na2jtXKWl/siGNG2Rm6pDXbxAM5WhoHg+R3ryNsZ
         O/bMRCssDwiXFnnGNYiMuQO1IpTX0GqGebeq5O+L9hi7CjZyLqLjSkIHtdOtssiCq8vp
         DwVA==
X-Gm-Message-State: ANoB5pkdQPLc4JERCg7Eqcmkp9OLarHamVDYCBQeCOf2x1B68ItFSd/v
        JaWve7sh4zy9Kmz30hSQ6gZSJuAKy3aFNrJv
X-Google-Smtp-Source: AA0mqf5apmSNIPvquOAjiIQSgiHzSxPqs5XhQLlh/XbVkB2tnPYO8sYJ1wPH0JujZf+1jOVzhGKUlA==
X-Received: by 2002:a17:90b:2750:b0:212:c87e:dc8b with SMTP id qi16-20020a17090b275000b00212c87edc8bmr5933448pjb.229.1668249491311;
        Sat, 12 Nov 2022 02:38:11 -0800 (PST)
Received: from astraea-lnx.home.neggl.es (119-18-16-128.771210.mel.static.aussiebb.net. [119.18.16.128])
        by smtp.gmail.com with ESMTPSA id n63-20020a622742000000b0056cea9530b9sm2998757pfn.200.2022.11.12.02.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Nov 2022 02:38:10 -0800 (PST)
From:   Andrew Powers-Holmes <aholmes@omnom.net>
To:     aholmes@omnom.net
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/1] arm64: dts: rockchip: rk356x: Fix PCIe register and range mappings
Date:   Sat, 12 Nov 2022 21:36:06 +1100
Message-Id: <20221112103606.1595375-2-aholmes@omnom.net>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221112103606.1595375-1-aholmes@omnom.net>
References: <20221112103606.1595375-1-aholmes@omnom.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The register and range mappings for the PCIe controller in Rockchip's
RK356x SoCs are incorrect. Replace them with corrected values from the
vendor BSP sources, updated to match current DT schema.

Cc: stable@vger.kernel.org
Signed-off-by: Andrew Powers-Holmes <aholmes@omnom.net>
---
 arch/arm64/boot/dts/rockchip/rk3568.dtsi | 14 ++++++++------
 arch/arm64/boot/dts/rockchip/rk356x.dtsi |  7 ++++---
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
index ba67b58f05b7..c1128d0c4406 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
@@ -94,9 +94,10 @@ pcie3x1: pcie@fe270000 {
 		power-domains = <&power RK3568_PD_PIPE>;
 		reg = <0x3 0xc0400000 0x0 0x00400000>,
 		      <0x0 0xfe270000 0x0 0x00010000>,
-		      <0x3 0x7f000000 0x0 0x01000000>;
-		ranges = <0x01000000 0x0 0x3ef00000 0x3 0x7ef00000 0x0 0x00100000>,
-			 <0x02000000 0x0 0x00000000 0x3 0x40000000 0x0 0x3ef00000>;
+		      <0x0 0xf2000000 0x0 0x00100000>;
+		ranges = <0x01000000 0x0 0xf2100000 0x0 0xf2100000 0x0 0x00100000>,
+			 <0x02000000 0x0 0xf2200000 0x0 0xf2200000 0x0 0x01e00000>,
+			 <0x03000000 0x0 0x40000000 0x3 0x40000000 0x0 0x40000000>;
 		reg-names = "dbi", "apb", "config";
 		resets = <&cru SRST_PCIE30X1_POWERUP>;
 		reset-names = "pipe";
@@ -146,9 +147,10 @@ pcie3x2: pcie@fe280000 {
 		power-domains = <&power RK3568_PD_PIPE>;
 		reg = <0x3 0xc0800000 0x0 0x00400000>,
 		      <0x0 0xfe280000 0x0 0x00010000>,
-		      <0x3 0xbf000000 0x0 0x01000000>;
-		ranges = <0x01000000 0x0 0x3ef00000 0x3 0xbef00000 0x0 0x00100000>,
-			 <0x02000000 0x0 0x00000000 0x3 0x80000000 0x0 0x3ef00000>;
+		      <0x0 0xf2000000 0x0 0x01000000>;
+		ranges = <0x01000000 0x0 0xf0100000 0x0 0xf0100000 0x0 0x00100000>,
+			 <0x02000000 0x0 0xf0200000 0x0 0xf0200000 0x0 0x01e00000>,
+			 <0x03000000 0x0 0x40000000 0x3 0x80000000 0x0 0x40000000>;
 		reg-names = "dbi", "apb", "config";
 		resets = <&cru SRST_PCIE30X2_POWERUP>;
 		reset-names = "pipe";
diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
index 164708f1eb67..eec1d496c617 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -951,7 +951,7 @@ pcie2x1: pcie@fe260000 {
 		compatible = "rockchip,rk3568-pcie";
 		reg = <0x3 0xc0000000 0x0 0x00400000>,
 		      <0x0 0xfe260000 0x0 0x00010000>,
-		      <0x3 0x3f000000 0x0 0x01000000>;
+		      <0x0 0xf4000000 0x0 0x00100000>;
 		reg-names = "dbi", "apb", "config";
 		interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>,
@@ -980,8 +980,9 @@ pcie2x1: pcie@fe260000 {
 		phys = <&combphy2 PHY_TYPE_PCIE>;
 		phy-names = "pcie-phy";
 		power-domains = <&power RK3568_PD_PIPE>;
-		ranges = <0x01000000 0x0 0x3ef00000 0x3 0x3ef00000 0x0 0x00100000
-			  0x02000000 0x0 0x00000000 0x3 0x00000000 0x0 0x3ef00000>;
+		ranges = <0x01000000 0x0 0xf4100000 0x0 0xf4100000 0x0 0x00100000>,
+			 <0x02000000 0x0 0xf4200000 0x0 0xf4200000 0x0 0x01e00000>,
+			 <0x03000000 0x0 0x40000000 0x3 0x00000000 0x0 0x40000000>;
 		resets = <&cru SRST_PCIE20_POWERUP>;
 		reset-names = "pipe";
 		#address-cells = <3>;
-- 
2.38.0

