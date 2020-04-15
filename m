Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66691AA3EA
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506180AbgDONOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:14:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897044AbgDOLfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:35:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74B6A2076D;
        Wed, 15 Apr 2020 11:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950521;
        bh=2OzrXsnZI6VeFmjEUumNOJf3tK1Ls686mWfBeZijVvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3EfCy95V58RCDA5Gl42bAh4u82KRqec/YB5RwxVPhpicjUcqa8j8rOAjG/6+xLqe
         f1M1/K40Ny0GyZYfmsHWh01qzxyRDoIhMTD2GF8+D0sKz/1HDA9aZd/zujLSrRagHs
         iBHDhDGyoI65orJeod0q+adTZPecf+LFxtJgEGio=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amit Kucheria <amit.kucheria@linaro.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 030/129] arm64: dts: marvell: Fix cpu compatible for AP807-quad
Date:   Wed, 15 Apr 2020 07:33:05 -0400
Message-Id: <20200415113445.11881-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Kucheria <amit.kucheria@linaro.org>

[ Upstream commit d136d2588b21b1a07515632ed61120c9f262909b ]

make -k ARCH=arm64 dtbs_check shows the following errors. Fix them by
removing the "arm,armv8" compatible.

/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9130-db.dt.yaml:
cpu@0: compatible: Additional items are not allowed ('arm,armv8' was
unexpected)
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9130-db.dt.yaml:
cpu@0: compatible: ['arm,cortex-a72', 'arm,armv8'] is too long CHECK
arch/arm64/boot/dts/renesas/r8a774a1-hihope-rzg2m-ex.dt.yaml
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9130-db.dt.yaml:
cpu@1: compatible: Additional items are not allowed ('arm,armv8' was
unexpected)
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9130-db.dt.yaml:
cpu@1: compatible: ['arm,cortex-a72', 'arm,armv8'] is too long
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9130-db.dt.yaml:
cpu@100: compatible: Additional items are not allowed ('arm,armv8' was
unexpected)
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9130-db.dt.yaml:
cpu@100: compatible: ['arm,cortex-a72', 'arm,armv8'] is too long
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9130-db.dt.yaml:
cpu@101: compatible: Additional items are not allowed ('arm,armv8' was
unexpected)
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9130-db.dt.yaml:
cpu@101: compatible: ['arm,cortex-a72', 'arm,armv8'] is too long

/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9131-db.dt.yaml:
cpu@0: compatible: Additional items are not allowed ('arm,armv8' was
unexpected)
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9131-db.dt.yaml:
cpu@0: compatible: ['arm,cortex-a72', 'arm,armv8'] is too long
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9131-db.dt.yaml:
cpu@1: compatible: Additional items are not allowed ('arm,armv8' was
unexpected)
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9131-db.dt.yaml:
cpu@1: compatible: ['arm,cortex-a72', 'arm,armv8'] is too long
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9131-db.dt.yaml:
cpu@100: compatible: Additional items are not allowed ('arm,armv8' was
unexpected)
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9131-db.dt.yaml:
cpu@100: compatible: ['arm,cortex-a72', 'arm,armv8'] is too long
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9131-db.dt.yaml:
cpu@101: compatible: Additional items are not allowed ('arm,armv8' was
unexpected)
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9131-db.dt.yaml:
cpu@101: compatible: ['arm,cortex-a72', 'arm,armv8'] is too long

/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9132-db.dt.yaml:
cpu@0: compatible: Additional items are not allowed ('arm,armv8' was
unexpected)
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9132-db.dt.yaml:
cpu@0: compatible: ['arm,cortex-a72', 'arm,armv8'] is too long
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9132-db.dt.yaml:
cpu@1: compatible: Additional items are not allowed ('arm,armv8' was
unexpected)
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9132-db.dt.yaml:
cpu@1: compatible: ['arm,cortex-a72', 'arm,armv8'] is too long
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9132-db.dt.yaml:
cpu@100: compatible: Additional items are not allowed ('arm,armv8' was
unexpected)
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9132-db.dt.yaml:
cpu@100: compatible: ['arm,cortex-a72', 'arm,armv8'] is too long
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9132-db.dt.yaml:
cpu@101: compatible: Additional items are not allowed ('arm,armv8' was
unexpected)
/home/amit/work/builds/build-check/arch/arm64/boot/dts/marvell/cn9132-db.dt.yaml:
cpu@101: compatible: ['arm,cortex-a72', 'arm,armv8'] is too long

Signed-off-by: Amit Kucheria <amit.kucheria@linaro.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-ap807-quad.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-ap807-quad.dtsi b/arch/arm64/boot/dts/marvell/armada-ap807-quad.dtsi
index 840466e143b47..68782f161f122 100644
--- a/arch/arm64/boot/dts/marvell/armada-ap807-quad.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-ap807-quad.dtsi
@@ -17,7 +17,7 @@
 
 		cpu0: cpu@0 {
 			device_type = "cpu";
-			compatible = "arm,cortex-a72", "arm,armv8";
+			compatible = "arm,cortex-a72";
 			reg = <0x000>;
 			enable-method = "psci";
 			#cooling-cells = <2>;
@@ -32,7 +32,7 @@
 		};
 		cpu1: cpu@1 {
 			device_type = "cpu";
-			compatible = "arm,cortex-a72", "arm,armv8";
+			compatible = "arm,cortex-a72";
 			reg = <0x001>;
 			enable-method = "psci";
 			#cooling-cells = <2>;
@@ -47,7 +47,7 @@
 		};
 		cpu2: cpu@100 {
 			device_type = "cpu";
-			compatible = "arm,cortex-a72", "arm,armv8";
+			compatible = "arm,cortex-a72";
 			reg = <0x100>;
 			enable-method = "psci";
 			#cooling-cells = <2>;
@@ -62,7 +62,7 @@
 		};
 		cpu3: cpu@101 {
 			device_type = "cpu";
-			compatible = "arm,cortex-a72", "arm,armv8";
+			compatible = "arm,cortex-a72";
 			reg = <0x101>;
 			enable-method = "psci";
 			#cooling-cells = <2>;
-- 
2.20.1

