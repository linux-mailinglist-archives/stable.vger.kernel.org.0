Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3245D11B528
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732300AbfLKPVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:21:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732167AbfLKPVL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:21:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 030732073D;
        Wed, 11 Dec 2019 15:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077670;
        bh=5Sp5yUHgoMyXmrbW9X9JdEoez6QcUp6xJ50vpCzx0b0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hk1qsV43cV4abeYPFzmDHZz17e4IVyNGUWz67mOxqDBj373Y3dKvcTOQC5AEr9HBT
         2/AmZA2hhmw17zHgtybEd0beckBsoygSuv5Pg9Um1flBBhuZsZ67NoywAHUT0R4MLo
         8OQb1g9GTMOjnVYn+1OTDYqi46AtAkWKtUGuEnz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 127/243] ARM: dts: sun8i: a23/a33: Fix OPP DTC warnings
Date:   Wed, 11 Dec 2019 16:04:49 +0100
Message-Id: <20191211150347.699074067@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime.ripard@bootlin.com>

[ Upstream commit a858f569b80a69076c521532a289097af905cf1e ]

DTC will emit a warning on our OPPs nodes for the common DTSI between the
A23 and A33 since those nodes use the frequency as unit addresses, but
don't have a matching reg property.

Fix this by moving the frequency to the node name instead.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-h3.dtsi              | 6 +++---
 arch/arm/boot/dts/sun8i-r16-bananapi-m2m.dts | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/sun8i-h3.dtsi b/arch/arm/boot/dts/sun8i-h3.dtsi
index f0096074a4678..97de6ad133dc2 100644
--- a/arch/arm/boot/dts/sun8i-h3.dtsi
+++ b/arch/arm/boot/dts/sun8i-h3.dtsi
@@ -47,19 +47,19 @@
 		compatible = "operating-points-v2";
 		opp-shared;
 
-		opp@648000000 {
+		opp-648000000 {
 			opp-hz = /bits/ 64 <648000000>;
 			opp-microvolt = <1040000 1040000 1300000>;
 			clock-latency-ns = <244144>; /* 8 32k periods */
 		};
 
-		opp@816000000 {
+		opp-816000000 {
 			opp-hz = /bits/ 64 <816000000>;
 			opp-microvolt = <1100000 1100000 1300000>;
 			clock-latency-ns = <244144>; /* 8 32k periods */
 		};
 
-		opp@1008000000 {
+		opp-1008000000 {
 			opp-hz = /bits/ 64 <1008000000>;
 			opp-microvolt = <1200000 1200000 1300000>;
 			clock-latency-ns = <244144>; /* 8 32k periods */
diff --git a/arch/arm/boot/dts/sun8i-r16-bananapi-m2m.dts b/arch/arm/boot/dts/sun8i-r16-bananapi-m2m.dts
index 0dbdb29a8fff9..ee7ce3752581b 100644
--- a/arch/arm/boot/dts/sun8i-r16-bananapi-m2m.dts
+++ b/arch/arm/boot/dts/sun8i-r16-bananapi-m2m.dts
@@ -103,13 +103,13 @@
 };
 
 &cpu0_opp_table {
-	opp@1104000000 {
+	opp-1104000000 {
 		opp-hz = /bits/ 64 <1104000000>;
 		opp-microvolt = <1320000>;
 		clock-latency-ns = <244144>; /* 8 32k periods */
 	};
 
-	opp@1200000000 {
+	opp-1200000000 {
 		opp-hz = /bits/ 64 <1200000000>;
 		opp-microvolt = <1320000>;
 		clock-latency-ns = <244144>; /* 8 32k periods */
-- 
2.20.1



