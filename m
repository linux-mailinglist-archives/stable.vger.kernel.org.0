Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80D844B659
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344475AbhKIW0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:26:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:41596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245463AbhKIWZG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:25:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FCEC6121F;
        Tue,  9 Nov 2021 22:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496357;
        bh=NWze0gFlrjnI7HEt+xI8OeJq0360NaeNAcNtYazfbbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJZxQQR7PQ+CZHLdvvQWOcapb+/gvCWXEm6xq99S6eaxHaKNChmpz1iBymEptdgga
         b2JpU/nWBI6Zu9qwg2MfnoXQcvX+UN1pTwoBRQya8VP9ERpGHWfwSGf1bzNVxq/gOi
         OL0RnnespQOU3PZSHCLRv4F0qNsM/Y2OQDjtWR6jqyM/7Q7D1yimeYgvs5GPvnKJC6
         /mooHXMGm2LZROs8dz7qYKUyOGNMiXH0nc/FtOkoPHmnhQX29QcIabNMYmCxYVQdwJ
         eaLOk+wjq2PFosHCP1QxUjro8fBA+1vJ6TMuTs9nQPBcYPD6W95WqT9MExqksYpqo0
         lXfs+5vmX/tWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, maxime.ripard@free-electrons.com,
        wens@csie.org, catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 04/75] ARM: dts: sunxi: Fix OPPs node name
Date:   Tue,  9 Nov 2021 17:17:54 -0500
Message-Id: <20211109221905.1234094-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 2beddbb3c5183..b3d1bdfb5118e 100644
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
index ac97eac91349b..82fdb04122caa 100644
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
index 8c6e8536b69fa..0baf0f8e4d272 100644
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

