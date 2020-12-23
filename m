Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EF22E1527
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729826AbgLWCsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:48:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:51036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728450AbgLWCWP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A34542312E;
        Wed, 23 Dec 2020 02:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690116;
        bh=un0cieuQXduU8ykd0LiZTiK8/nwwTiR0gABskFJ+b9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMjbViU0E+JnnWKy1P1XT3MljTlxbbIUIl870tMAigaxzxaiUT8Y2tpjcxwI5hYTJ
         mqDG5DuWdaoDyIv/5a0TdCFPcST9wCjy/hd9xCePSDdOGM/vJw28NbZff6L82qRS2r
         UMKhahc3Zxmh9Q6H0a/JeXPLlG6wCn7bW7a1gbsksjK5W8u5Xr2Tp5sKBze/lg3HSB
         HbW4UIpBlYtl8IEHrRrtpFP47df65KEYBVA8Z8TGx93BYp6bl0zMhBAKma0AdeGdKR
         FoHYmVA7P0O3ThpwK2fhIRPYmgduNozhFYW1ydzTF0cqbyQPdSHbDQM4IJ3BhxJbQB
         hrx5JE6yzD3qA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 43/87] ARM: dts: hisilicon: fix errors detected by simple-bus.yaml
Date:   Tue, 22 Dec 2020 21:20:19 -0500
Message-Id: <20201223022103.2792705-43-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
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
index 847920004f34c..65df6b8684ffc 100644
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
index 9c12f3df78fd7..40bf9ed299458 100644
--- a/arch/arm/boot/dts/hi3620.dtsi
+++ b/arch/arm/boot/dts/hi3620.dtsi
@@ -66,7 +66,7 @@ cpu@3 {
 		};
 	};
 
-	amba {
+	amba-bus {
 
 		#address-cells = <1>;
 		#size-cells = <1>;
diff --git a/arch/arm/boot/dts/hip01.dtsi b/arch/arm/boot/dts/hip01.dtsi
index db4c813896b96..a1acc7bfc4325 100644
--- a/arch/arm/boot/dts/hip01.dtsi
+++ b/arch/arm/boot/dts/hip01.dtsi
@@ -38,7 +38,7 @@ soc {
 		interrupt-parent = <&gic>;
 		ranges = <0 0x10000000 0x20000000>;
 
-		amba {
+		amba-bus {
 			#address-cells = <1>;
 			#size-cells = <1>;
 			compatible = "simple-bus";
diff --git a/arch/arm/boot/dts/hisi-x5hd2.dtsi b/arch/arm/boot/dts/hisi-x5hd2.dtsi
index d199dbe318a66..cf98f7adab462 100644
--- a/arch/arm/boot/dts/hisi-x5hd2.dtsi
+++ b/arch/arm/boot/dts/hisi-x5hd2.dtsi
@@ -33,7 +33,7 @@ soc {
 		interrupt-parent = <&gic>;
 		ranges = <0 0xf8000000 0x8000000>;
 
-		amba {
+		amba-bus {
 			#address-cells = <1>;
 			#size-cells = <1>;
 			compatible = "simple-bus";
-- 
2.27.0

