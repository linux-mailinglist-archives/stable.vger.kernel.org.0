Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D50BE9FFD
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbfJ3Pwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728030AbfJ3Pwk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:52:40 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0AA020856;
        Wed, 30 Oct 2019 15:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450759;
        bh=3Yhs3WqnnkrvAAFYoJ4Y+AVbVYIMGkIaxwp46Lt48+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrYaqn6FJ2rQ5uOfW31w2RhkvvZgvBf0pk/eAMAPwBn6IsK/hZtGL6tD8zXsjxBPM
         ws3tdK+nBBjzk/UpvQJeWC01TTqoEv6WgjxR9a+JC18jKRrQR8V9uMIhDz/3Ml5AGd
         bfFrkbtJg3HsWPyGBHg8xyVopRZi7ajlTmAyOs7A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ran Wang <ran.wang_1@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 43/81] arm64: dts: lx2160a: Correct CPU core idle state name
Date:   Wed, 30 Oct 2019 11:48:49 -0400
Message-Id: <20191030154928.9432-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ran Wang <ran.wang_1@nxp.com>

[ Upstream commit 07159f67c77134dfdfdbdf3d8f657f5890de5b7f ]

lx2160a support PW15 but not PW20, correct name to avoid confusing.

Signed-off-by: Ran Wang <ran.wang_1@nxp.com>
Fixes: 00c5ce8ac023 ("arm64: dts: lx2160a: add cpu idle support")
Acked-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 36 +++++++++----------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index e6fdba39453c3..228ab83037d0e 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -33,7 +33,7 @@
 			i-cache-line-size = <64>;
 			i-cache-sets = <192>;
 			next-level-cache = <&cluster0_l2>;
-			cpu-idle-states = <&cpu_pw20>;
+			cpu-idle-states = <&cpu_pw15>;
 		};
 
 		cpu@1 {
@@ -49,7 +49,7 @@
 			i-cache-line-size = <64>;
 			i-cache-sets = <192>;
 			next-level-cache = <&cluster0_l2>;
-			cpu-idle-states = <&cpu_pw20>;
+			cpu-idle-states = <&cpu_pw15>;
 		};
 
 		cpu@100 {
@@ -65,7 +65,7 @@
 			i-cache-line-size = <64>;
 			i-cache-sets = <192>;
 			next-level-cache = <&cluster1_l2>;
-			cpu-idle-states = <&cpu_pw20>;
+			cpu-idle-states = <&cpu_pw15>;
 		};
 
 		cpu@101 {
@@ -81,7 +81,7 @@
 			i-cache-line-size = <64>;
 			i-cache-sets = <192>;
 			next-level-cache = <&cluster1_l2>;
-			cpu-idle-states = <&cpu_pw20>;
+			cpu-idle-states = <&cpu_pw15>;
 		};
 
 		cpu@200 {
@@ -97,7 +97,7 @@
 			i-cache-line-size = <64>;
 			i-cache-sets = <192>;
 			next-level-cache = <&cluster2_l2>;
-			cpu-idle-states = <&cpu_pw20>;
+			cpu-idle-states = <&cpu_pw15>;
 		};
 
 		cpu@201 {
@@ -113,7 +113,7 @@
 			i-cache-line-size = <64>;
 			i-cache-sets = <192>;
 			next-level-cache = <&cluster2_l2>;
-			cpu-idle-states = <&cpu_pw20>;
+			cpu-idle-states = <&cpu_pw15>;
 		};
 
 		cpu@300 {
@@ -129,7 +129,7 @@
 			i-cache-line-size = <64>;
 			i-cache-sets = <192>;
 			next-level-cache = <&cluster3_l2>;
-			cpu-idle-states = <&cpu_pw20>;
+			cpu-idle-states = <&cpu_pw15>;
 		};
 
 		cpu@301 {
@@ -145,7 +145,7 @@
 			i-cache-line-size = <64>;
 			i-cache-sets = <192>;
 			next-level-cache = <&cluster3_l2>;
-			cpu-idle-states = <&cpu_pw20>;
+			cpu-idle-states = <&cpu_pw15>;
 		};
 
 		cpu@400 {
@@ -161,7 +161,7 @@
 			i-cache-line-size = <64>;
 			i-cache-sets = <192>;
 			next-level-cache = <&cluster4_l2>;
-			cpu-idle-states = <&cpu_pw20>;
+			cpu-idle-states = <&cpu_pw15>;
 		};
 
 		cpu@401 {
@@ -177,7 +177,7 @@
 			i-cache-line-size = <64>;
 			i-cache-sets = <192>;
 			next-level-cache = <&cluster4_l2>;
-			cpu-idle-states = <&cpu_pw20>;
+			cpu-idle-states = <&cpu_pw15>;
 		};
 
 		cpu@500 {
@@ -193,7 +193,7 @@
 			i-cache-line-size = <64>;
 			i-cache-sets = <192>;
 			next-level-cache = <&cluster5_l2>;
-			cpu-idle-states = <&cpu_pw20>;
+			cpu-idle-states = <&cpu_pw15>;
 		};
 
 		cpu@501 {
@@ -209,7 +209,7 @@
 			i-cache-line-size = <64>;
 			i-cache-sets = <192>;
 			next-level-cache = <&cluster5_l2>;
-			cpu-idle-states = <&cpu_pw20>;
+			cpu-idle-states = <&cpu_pw15>;
 		};
 
 		cpu@600 {
@@ -225,7 +225,7 @@
 			i-cache-line-size = <64>;
 			i-cache-sets = <192>;
 			next-level-cache = <&cluster6_l2>;
-			cpu-idle-states = <&cpu_pw20>;
+			cpu-idle-states = <&cpu_pw15>;
 		};
 
 		cpu@601 {
@@ -241,7 +241,7 @@
 			i-cache-line-size = <64>;
 			i-cache-sets = <192>;
 			next-level-cache = <&cluster6_l2>;
-			cpu-idle-states = <&cpu_pw20>;
+			cpu-idle-states = <&cpu_pw15>;
 		};
 
 		cpu@700 {
@@ -257,7 +257,7 @@
 			i-cache-line-size = <64>;
 			i-cache-sets = <192>;
 			next-level-cache = <&cluster7_l2>;
-			cpu-idle-states = <&cpu_pw20>;
+			cpu-idle-states = <&cpu_pw15>;
 		};
 
 		cpu@701 {
@@ -273,7 +273,7 @@
 			i-cache-line-size = <64>;
 			i-cache-sets = <192>;
 			next-level-cache = <&cluster7_l2>;
-			cpu-idle-states = <&cpu_pw20>;
+			cpu-idle-states = <&cpu_pw15>;
 		};
 
 		cluster0_l2: l2-cache0 {
@@ -340,9 +340,9 @@
 			cache-level = <2>;
 		};
 
-		cpu_pw20: cpu-pw20 {
+		cpu_pw15: cpu-pw15 {
 			compatible = "arm,idle-state";
-			idle-state-name = "PW20";
+			idle-state-name = "PW15";
 			arm,psci-suspend-param = <0x0>;
 			entry-latency-us = <2000>;
 			exit-latency-us = <2000>;
-- 
2.20.1

