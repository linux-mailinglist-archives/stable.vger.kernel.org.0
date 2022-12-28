Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71ED65782C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbiL1OsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbiL1Orq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:47:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8D2BCA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:47:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8BC86154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A79C433D2;
        Wed, 28 Dec 2022 14:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238864;
        bh=xQsys8Xw44yVNsnuzHKAhkrsd+IFPKZTLmySj/hhbAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7GRq2gK9HTXlDDw7/F/rTCIon3nfyzbCUJ3s6vie8rhOfRdzuVEoYU4so6TJvwxm
         XBCDVOhEFf+1foiYweddeuhXsedGxpgdF7aYiVGwpkqGY4A0kfa+QTWwe0mRl2FI4a
         LPgt88pKL54GaLrRX27tYy85H/u5dC3JrTrfkTVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/731] ARM: dts: nuvoton: Remove bogus unit addresses from fixed-partition nodes
Date:   Wed, 28 Dec 2022 15:32:25 +0100
Message-Id: <20221228144257.657663397@linuxfoundation.org>
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

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

[ Upstream commit ea3ce4cf076ba11bb591c8013c5315136cae52c8 ]

The unit addresses do not correspond to the nodes' reg properties,
because they don't have any.

Fixes: e42b650f828d ("ARM: dts: nuvoton: Add new device nodes to NPCM750 EVB")
Fixes: ee33e2fb3d70 ("ARM: dts: nuvoton: Add Quanta GBS BMC Device Tree")
Fixes: 59f5abe09f0a ("ARM: dts: nuvoton: Add Quanta GSJ BMC")
Fixes: 14579c76f5ca ("ARM: dts: nuvoton: Add Fii Kudo system")
Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20221031221553.163273-1-j.neuschaefer@gmx.net
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nuvoton-npcm730-gbs.dts            | 2 +-
 arch/arm/boot/dts/nuvoton-npcm730-gsj.dts            | 2 +-
 arch/arm/boot/dts/nuvoton-npcm730-kudo.dts           | 6 +++---
 arch/arm/boot/dts/nuvoton-npcm750-evb.dts            | 4 ++--
 arch/arm/boot/dts/nuvoton-npcm750-runbmc-olympus.dts | 6 +++---
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/nuvoton-npcm730-gbs.dts b/arch/arm/boot/dts/nuvoton-npcm730-gbs.dts
index eb6eb21cb2a4..33c8d5b3d679 100644
--- a/arch/arm/boot/dts/nuvoton-npcm730-gbs.dts
+++ b/arch/arm/boot/dts/nuvoton-npcm730-gbs.dts
@@ -366,7 +366,7 @@ spi-nor@0 {
 		spi-max-frequency = <20000000>;
 		spi-rx-bus-width = <2>;
 		label = "bmc";
-		partitions@80000000 {
+		partitions {
 			compatible = "fixed-partitions";
 			#address-cells = <1>;
 			#size-cells = <1>;
diff --git a/arch/arm/boot/dts/nuvoton-npcm730-gsj.dts b/arch/arm/boot/dts/nuvoton-npcm730-gsj.dts
index d4ff49939a3d..bbe18618f5c5 100644
--- a/arch/arm/boot/dts/nuvoton-npcm730-gsj.dts
+++ b/arch/arm/boot/dts/nuvoton-npcm730-gsj.dts
@@ -142,7 +142,7 @@ spi-nor@0 {
 		reg = <0>;
 		spi-rx-bus-width = <2>;
 
-		partitions@80000000 {
+		partitions {
 			compatible = "fixed-partitions";
 			#address-cells = <1>;
 			#size-cells = <1>;
diff --git a/arch/arm/boot/dts/nuvoton-npcm730-kudo.dts b/arch/arm/boot/dts/nuvoton-npcm730-kudo.dts
index 82a104b2a65f..8e3425cb8e8b 100644
--- a/arch/arm/boot/dts/nuvoton-npcm730-kudo.dts
+++ b/arch/arm/boot/dts/nuvoton-npcm730-kudo.dts
@@ -388,7 +388,7 @@ spi-nor@0 {
 		spi-max-frequency = <5000000>;
 		spi-rx-bus-width = <2>;
 		label = "bmc";
-		partitions@80000000 {
+		partitions {
 			compatible = "fixed-partitions";
 			#address-cells = <1>;
 			#size-cells = <1>;
@@ -422,7 +422,7 @@ spi-nor@1 {
 		reg = <1>;
 		spi-max-frequency = <5000000>;
 		spi-rx-bus-width = <2>;
-		partitions@88000000 {
+		partitions {
 			compatible = "fixed-partitions";
 			#address-cells = <1>;
 			#size-cells = <1>;
@@ -447,7 +447,7 @@ spi-nor@0 {
 		reg = <0>;
 		spi-max-frequency = <5000000>;
 		spi-rx-bus-width = <2>;
-		partitions@A0000000 {
+		partitions {
 			compatible = "fixed-partitions";
 			#address-cells = <1>;
 			#size-cells = <1>;
diff --git a/arch/arm/boot/dts/nuvoton-npcm750-evb.dts b/arch/arm/boot/dts/nuvoton-npcm750-evb.dts
index 0334641f8829..cf274c926711 100644
--- a/arch/arm/boot/dts/nuvoton-npcm750-evb.dts
+++ b/arch/arm/boot/dts/nuvoton-npcm750-evb.dts
@@ -74,7 +74,7 @@ spi-nor@0 {
 		spi-rx-bus-width = <2>;
 		reg = <0>;
 		spi-max-frequency = <5000000>;
-		partitions@80000000 {
+		partitions {
 			compatible = "fixed-partitions";
 			#address-cells = <1>;
 			#size-cells = <1>;
@@ -135,7 +135,7 @@ spi-nor@0 {
 		spi-rx-bus-width = <2>;
 		reg = <0>;
 		spi-max-frequency = <5000000>;
-		partitions@A0000000 {
+		partitions {
 			compatible = "fixed-partitions";
 			#address-cells = <1>;
 			#size-cells = <1>;
diff --git a/arch/arm/boot/dts/nuvoton-npcm750-runbmc-olympus.dts b/arch/arm/boot/dts/nuvoton-npcm750-runbmc-olympus.dts
index 767e0ac0df7c..7fe7efee28ac 100644
--- a/arch/arm/boot/dts/nuvoton-npcm750-runbmc-olympus.dts
+++ b/arch/arm/boot/dts/nuvoton-npcm750-runbmc-olympus.dts
@@ -107,7 +107,7 @@ spi-nor@0 {
 		reg = <0>;
 		spi-rx-bus-width = <2>;
 
-		partitions@80000000 {
+		partitions {
 			compatible = "fixed-partitions";
 			#address-cells = <1>;
 			#size-cells = <1>;
@@ -146,7 +146,7 @@ spi-nor@1 {
 		reg = <1>;
 		npcm,fiu-rx-bus-width = <2>;
 
-		partitions@88000000 {
+		partitions {
 			compatible = "fixed-partitions";
 			#address-cells = <1>;
 			#size-cells = <1>;
@@ -173,7 +173,7 @@ spi-nor@0 {
 		reg = <0>;
 		spi-rx-bus-width = <2>;
 
-		partitions@A0000000 {
+		partitions {
 			compatible = "fixed-partitions";
 			#address-cells = <1>;
 			#size-cells = <1>;
-- 
2.35.1



