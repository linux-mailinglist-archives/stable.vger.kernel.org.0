Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC892E130D
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730757AbgLWC03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:26:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730886AbgLWC01 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:26:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AF05221E5;
        Wed, 23 Dec 2020 02:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690347;
        bh=i7KtEEiOnV164DyJGwkyEAqwUDHPWEL1ofb/pVIao58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A0crKQDw54eF7eDloDbRyxJzJZFO3vhxX75IpLZ0q754UBNm2ztgBZ565I50eF7hC
         guyjdZT922uym1Uh0l/Z1NAW2ll1hF8nsmCpM2Q0WuJUxu5fSEuxNhCXz8uTzyWBpM
         ZD6j7MdVDVRGcxaDzKFsicuEBObm/Goz5wgj2Fn0e9dGA0BzGvxvCDw6+dnBixKxvC
         sUyn1Y1O2wy6OadoYinu4c3EW08iBpNY9mgEoSm0PnDrDWIUVABNZ94aUY1/94YpdV
         lbJ/fUxFt0uYk9ahWYSDNuVIVrw3CrHupRK1NemqwuBPtlw6YLTo5g6Oi64jefnlPW
         IrV5ZqBexnlpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 24/38] ARM: dts: hisilicon: fix errors detected by simple-bus.yaml
Date:   Tue, 22 Dec 2020 21:25:02 -0500
Message-Id: <20201223022516.2794471-24-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022516.2794471-1-sashal@kernel.org>
References: <20201223022516.2794471-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 8e9e8dd7ce093344a89792deaeb6caedde636dcf ]

Change bus node name from "amba" to "amba-bus" to match
'^([a-z][a-z0-9\\-]+-bus|bus|soc|axi|ahb|apb)(@[0-9a-f]+)?$'

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/hi3620-hi4511.dts | 2 +-
 arch/arm/boot/dts/hi3620.dtsi       | 2 +-
 arch/arm/boot/dts/hip01.dtsi        | 2 +-
 arch/arm/boot/dts/hisi-x5hd2.dtsi   | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/hi3620-hi4511.dts b/arch/arm/boot/dts/hi3620-hi4511.dts
index a579fbf13b5f5..a672c4e4babbd 100644
--- a/arch/arm/boot/dts/hi3620-hi4511.dts
+++ b/arch/arm/boot/dts/hi3620-hi4511.dts
@@ -25,7 +25,7 @@ memory {
 		reg = <0x40000000 0x20000000>;
 	};
 
-	amba {
+	amba-bus {
 		dual_timer0: dual_timer@800000 {
 			status = "ok";
 		};
diff --git a/arch/arm/boot/dts/hi3620.dtsi b/arch/arm/boot/dts/hi3620.dtsi
index 6cbb62e5c6a9e..c4b371acf1e71 100644
--- a/arch/arm/boot/dts/hi3620.dtsi
+++ b/arch/arm/boot/dts/hi3620.dtsi
@@ -64,7 +64,7 @@ cpu@3 {
 		};
 	};
 
-	amba {
+	amba-bus {
 
 		#address-cells = <1>;
 		#size-cells = <1>;
diff --git a/arch/arm/boot/dts/hip01.dtsi b/arch/arm/boot/dts/hip01.dtsi
index 96f6bd0312d09..ebb9661cae889 100644
--- a/arch/arm/boot/dts/hip01.dtsi
+++ b/arch/arm/boot/dts/hip01.dtsi
@@ -40,7 +40,7 @@ soc {
 		interrupt-parent = <&gic>;
 		ranges = <0 0x10000000 0x20000000>;
 
-		amba {
+		amba-bus {
 			#address-cells = <1>;
 			#size-cells = <1>;
 			compatible = "arm,amba-bus";
diff --git a/arch/arm/boot/dts/hisi-x5hd2.dtsi b/arch/arm/boot/dts/hisi-x5hd2.dtsi
index 98a8e76492b96..6aafb0e9ca272 100644
--- a/arch/arm/boot/dts/hisi-x5hd2.dtsi
+++ b/arch/arm/boot/dts/hisi-x5hd2.dtsi
@@ -31,7 +31,7 @@ soc {
 		interrupt-parent = <&gic>;
 		ranges = <0 0xf8000000 0x8000000>;
 
-		amba {
+		amba-bus {
 			#address-cells = <1>;
 			#size-cells = <1>;
 			compatible = "arm,amba-bus";
-- 
2.27.0

