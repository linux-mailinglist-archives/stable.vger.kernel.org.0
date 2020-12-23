Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC83D2E146B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730657AbgLWCjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:39:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730080AbgLWCXx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A34A122525;
        Wed, 23 Dec 2020 02:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690218;
        bh=GrdGkYHq16gFPHfVyShWYyUmnLGNIegsrkfPIMt4/3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eOfERPkWVIidh9ABcp5tWJ4eIUcAKeUYvnygXSd/0yjRdybJDtgKA87hJS2l8enkl
         GR7KFE9plsYvIfMr/JvCQG5VuVt+C/e0NynpiMt/ZxQ/5q8A6UkHSQ3zTSwnn4+AQn
         YpQGg3qiKWAL5QJcdzSE9xVWBDKNP9ioiIkKJ2UGbDIZJP573R0J9exGkcTAkUDffK
         3OVo53yyBsJYt9B2rPOSycU5M/x6I3F907LmopWPOlxvnwSLw0hiHJ7OdM1+MWJq7U
         Zqnm1+sGIZ2iOlOVY+C6exvH3omXQWL5fvHFAxvPGICVhH9i9wjwjhAlWykDIMOTlt
         t6pEYG/G1lz6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 36/66] ARM: dts: hisilicon: fix errors detected by simple-bus.yaml
Date:   Tue, 22 Dec 2020 21:22:22 -0500
Message-Id: <20201223022253.2793452-36-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
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
index 541d700945444..dbce3d6dad191 100644
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
index 98667ca26c037..8823481789331 100644
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
index 6bbe560742c6a..2a9ef32e92f86 100644
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

