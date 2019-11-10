Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBBB7F629E
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfKJCoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:44:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728495AbfKJCoN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2326F21655;
        Sun, 10 Nov 2019 02:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353853;
        bh=wOI/QU4y8qLszeihRbu28akQEhXLJhHGcVOEfMMH57o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLXqx1SqkC+mZKRDTpOyWXggLTmJ2GFEOy9ksbe/mJPqx0F6M0DAxRm/QzwGkLkEb
         WguJFMWAyztco2x/w/wU32+EuCe0Y5OvdSj81on/e40CQ3cfcLsULfE9v/364PYiuy
         jl8HElC4qdInaenxG7QCK98/NZO8Gu0JUCDflBkw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Stefan Agner <stefan@agner.ch>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 138/191] ARM: dts: tegra20: restore address order
Date:   Sat,  9 Nov 2019 21:39:20 -0500
Message-Id: <20191110024013.29782-138-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

[ Upstream commit 8188391c127ea34d66f37eda6755d0acb51dc600 ]

Commit 6c468f109884 ("ARM: dts: tegra: add Tegra20 NAND flash
controller node") introduced the nand-controller node. However, it got
added at the wrong spot not honoring the address order. Fix this.

Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Reviewed-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/tegra20.dtsi | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 15b73bd377f04..80854f7de765c 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -419,19 +419,6 @@
 		status = "disabled";
 	};
 
-	gmi@70009000 {
-		compatible = "nvidia,tegra20-gmi";
-		reg = <0x70009000 0x1000>;
-		#address-cells = <2>;
-		#size-cells = <1>;
-		ranges = <0 0 0xd0000000 0xfffffff>;
-		clocks = <&tegra_car TEGRA20_CLK_NOR>;
-		clock-names = "gmi";
-		resets = <&tegra_car 42>;
-		reset-names = "gmi";
-		status = "disabled";
-	};
-
 	nand-controller@70008000 {
 		compatible = "nvidia,tegra20-nand";
 		reg = <0x70008000 0x100>;
@@ -447,6 +434,19 @@
 		status = "disabled";
 	};
 
+	gmi@70009000 {
+		compatible = "nvidia,tegra20-gmi";
+		reg = <0x70009000 0x1000>;
+		#address-cells = <2>;
+		#size-cells = <1>;
+		ranges = <0 0 0xd0000000 0xfffffff>;
+		clocks = <&tegra_car TEGRA20_CLK_NOR>;
+		clock-names = "gmi";
+		resets = <&tegra_car 42>;
+		reset-names = "gmi";
+		status = "disabled";
+	};
+
 	pwm: pwm@7000a000 {
 		compatible = "nvidia,tegra20-pwm";
 		reg = <0x7000a000 0x100>;
-- 
2.20.1

