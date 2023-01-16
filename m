Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCED266CC57
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234447AbjAPRZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234413AbjAPRYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:24:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAFA39B89
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:01:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D918C61083
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA88FC433EF;
        Mon, 16 Jan 2023 17:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888512;
        bh=e57jkr2Sx5K9DUL/Lko2+9PfYTAyX7jH74mpGE/pcnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sorLNzZZD/WVyy2YhAxms5EW2Xwei18h4b1DTxzzA8x3Z1ReEz/J9oYX+SoDdYrcY
         YEtSG4KLdt1/mUXnwg/VH7XvsC3sNhrG84n/HlCLgBRDJMxZxqhKa+WK5oEZzCi2lV
         gPQt13MWxnr5X7He6DRjV3hYCr4ElJ++HM/yQ+Z4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 033/338] ARM: dts: armada-38x: Fix assigned-addresses for every PCIe Root Port
Date:   Mon, 16 Jan 2023 16:48:26 +0100
Message-Id: <20230116154822.222442461@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 44f47b7a8fa4678ce4c38ea74837e4996b9df6d6 ]

BDF of resource in DT assigned-addresses property of Marvell PCIe Root Port
(PCI-to-PCI bridge) should match BDF in address part in that DT node name
as specified resource belongs to Marvell PCIe Root Port itself.

Fixes: 0d3d96ab0059 ("ARM: mvebu: add Device Tree description of the Armada 380/385 SoCs")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-380.dtsi | 4 ++--
 arch/arm/boot/dts/armada-385.dtsi | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/armada-380.dtsi b/arch/arm/boot/dts/armada-380.dtsi
index 132596fd0860..91dbf11ef0f9 100644
--- a/arch/arm/boot/dts/armada-380.dtsi
+++ b/arch/arm/boot/dts/armada-380.dtsi
@@ -116,7 +116,7 @@ pcie@1,0 {
 			/* x1 port */
 			pcie@2,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x40000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -135,7 +135,7 @@ pcie@2,0 {
 			/* x1 port */
 			pcie@3,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
+				assigned-addresses = <0x82001800 0 0x44000 0 0x2000>;
 				reg = <0x1800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
diff --git a/arch/arm/boot/dts/armada-385.dtsi b/arch/arm/boot/dts/armada-385.dtsi
index 74863aff01c6..1f047dc7739e 100644
--- a/arch/arm/boot/dts/armada-385.dtsi
+++ b/arch/arm/boot/dts/armada-385.dtsi
@@ -121,7 +121,7 @@ pcie1: pcie@1,0 {
 			/* x1 port */
 			pcie2: pcie@2,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x40000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -140,7 +140,7 @@ pcie2: pcie@2,0 {
 			/* x1 port */
 			pcie3: pcie@3,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
+				assigned-addresses = <0x82001800 0 0x44000 0 0x2000>;
 				reg = <0x1800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -162,7 +162,7 @@ pcie3: pcie@3,0 {
 			 */
 			pcie4: pcie@4,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x48000 0 0x2000>;
+				assigned-addresses = <0x82002000 0 0x48000 0 0x2000>;
 				reg = <0x2000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
-- 
2.35.1



