Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3646F1B3E08
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730389AbgDVKYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:24:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729949AbgDVKXz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:23:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FC3220781;
        Wed, 22 Apr 2020 10:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551034;
        bh=2OzrXsnZI6VeFmjEUumNOJf3tK1Ls686mWfBeZijVvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/9OobrWSbwn+RcWdOsWyfZNV6StUPhx/yCvC6va1H2U4zg9fEYv1av+NzD2InmyK
         jsE0uLl6ns9hEtugi+tA4W0d7jM2fXFqLjGwXXUFQCBRas2sLzspOegwxtw9E/LMCY
         WB8SsF905o7XGMrdSTocEi0MRfFjBb4VVa83njBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Kucheria <amit.kucheria@linaro.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 067/166] arm64: dts: marvell: Fix cpu compatible for AP807-quad
Date:   Wed, 22 Apr 2020 11:56:34 +0200
Message-Id: <20200422095056.093853715@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



