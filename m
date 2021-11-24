Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F3D45C2A4
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348523AbhKXNbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:31:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350938AbhKXN26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:28:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5002861527;
        Wed, 24 Nov 2021 12:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758289;
        bh=I1NDbiP/OZcVSxcRizSJiaW68LTtAtJEcjCXt0+/oh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQre5HihtJbIQZ+lDnZgYWBp2g5m6t5CSNvmaR2HII3Q/ZPZwzWDebxIP7jc8mPNB
         bRJ0Iv/GKefTJ6rUSXnapB1uzSa8vNfZTDpZcF1qvute+te0m3TaUyYNZUa5HTZ4vR
         BIihvGKJBDAb9HSbDNV4wwpxKLms7m78vYMpjlis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/154] ARM: dts: sunxi: Fix OPPs node name
Date:   Wed, 24 Nov 2021 12:56:39 +0100
Message-Id: <20211124115702.477447706@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit ffbe853a3f5a37fa0a511265b21abf097ffdbe45 ]

The operating-points-v2 nodes are named inconsistently, but mostly
either opp_table0 or gpu-opp-table.  However, the underscore is an
invalid character for a node name and the thermal zone binding
explicitly requires that zones are called opp-table-*. Let's fix it.

Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20210901091852.479202-43-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-a33.dtsi                      | 4 ++--
 arch/arm/boot/dts/sun8i-a83t.dtsi                     | 4 ++--
 arch/arm/boot/dts/sun8i-h3.dtsi                       | 4 ++--
 arch/arm64/boot/dts/allwinner/sun50i-a64-cpu-opp.dtsi | 2 +-
 arch/arm64/boot/dts/allwinner/sun50i-h5-cpu-opp.dtsi  | 2 +-
 arch/arm64/boot/dts/allwinner/sun50i-h6-cpu-opp.dtsi  | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/sun8i-a33.dtsi b/arch/arm/boot/dts/sun8i-a33.dtsi
index c458f5fb124fb..46f4242e9f95d 100644
--- a/arch/arm/boot/dts/sun8i-a33.dtsi
+++ b/arch/arm/boot/dts/sun8i-a33.dtsi
@@ -46,7 +46,7 @@
 #include <dt-bindings/thermal/thermal.h>
 
 / {
-	cpu0_opp_table: opp_table0 {
+	cpu0_opp_table: opp-table-cpu {
 		compatible = "operating-points-v2";
 		opp-shared;
 
@@ -164,7 +164,7 @@
 		io-channels = <&ths>;
 	};
 
-	mali_opp_table: gpu-opp-table {
+	mali_opp_table: opp-table-gpu {
 		compatible = "operating-points-v2";
 
 		opp-144000000 {
diff --git a/arch/arm/boot/dts/sun8i-a83t.dtsi b/arch/arm/boot/dts/sun8i-a83t.dtsi
index c010b27fdb6a6..a746e449b0bae 100644
--- a/arch/arm/boot/dts/sun8i-a83t.dtsi
+++ b/arch/arm/boot/dts/sun8i-a83t.dtsi
@@ -200,7 +200,7 @@
 		status = "disabled";
 	};
 
-	cpu0_opp_table: opp_table0 {
+	cpu0_opp_table: opp-table-cluster0 {
 		compatible = "operating-points-v2";
 		opp-shared;
 
@@ -253,7 +253,7 @@
 		};
 	};
 
-	cpu1_opp_table: opp_table1 {
+	cpu1_opp_table: opp-table-cluster1 {
 		compatible = "operating-points-v2";
 		opp-shared;
 
diff --git a/arch/arm/boot/dts/sun8i-h3.dtsi b/arch/arm/boot/dts/sun8i-h3.dtsi
index 4e89701df91f8..ae4f933abb895 100644
--- a/arch/arm/boot/dts/sun8i-h3.dtsi
+++ b/arch/arm/boot/dts/sun8i-h3.dtsi
@@ -44,7 +44,7 @@
 #include <dt-bindings/thermal/thermal.h>
 
 / {
-	cpu0_opp_table: opp_table0 {
+	cpu0_opp_table: opp-table-cpu {
 		compatible = "operating-points-v2";
 		opp-shared;
 
@@ -112,7 +112,7 @@
 		};
 	};
 
-	gpu_opp_table: gpu-opp-table {
+	gpu_opp_table: opp-table-gpu {
 		compatible = "operating-points-v2";
 
 		opp-120000000 {
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-cpu-opp.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64-cpu-opp.dtsi
index 578c37490d901..e39db51eb4489 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-cpu-opp.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-cpu-opp.dtsi
@@ -4,7 +4,7 @@
  */
 
 / {
-	cpu0_opp_table: opp_table0 {
+	cpu0_opp_table: opp-table-cpu {
 		compatible = "operating-points-v2";
 		opp-shared;
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-cpu-opp.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h5-cpu-opp.dtsi
index b2657201957eb..1afad8b437d72 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-cpu-opp.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-cpu-opp.dtsi
@@ -2,7 +2,7 @@
 // Copyright (C) 2020 Chen-Yu Tsai <wens@csie.org>
 
 / {
-	cpu_opp_table: cpu-opp-table {
+	cpu_opp_table: opp-table-cpu {
 		compatible = "operating-points-v2";
 		opp-shared;
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-cpu-opp.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6-cpu-opp.dtsi
index 1a5eddc5a40f3..653452926d857 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-cpu-opp.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-cpu-opp.dtsi
@@ -3,7 +3,7 @@
 // Copyright (C) 2020 Clément Péron <peron.clem@gmail.com>
 
 / {
-	cpu_opp_table: cpu-opp-table {
+	cpu_opp_table: opp-table-cpu {
 		compatible = "allwinner,sun50i-h6-operating-points";
 		nvmem-cells = <&cpu_speed_grade>;
 		opp-shared;
-- 
2.33.0



