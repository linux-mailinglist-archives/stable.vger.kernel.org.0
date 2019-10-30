Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70082E9F8D
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbfJ3Ptp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:49:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727432AbfJ3Pto (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:49:44 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FC5D208E3;
        Wed, 30 Oct 2019 15:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450584;
        bh=SnSrBVejywLMeyE9C0F/6AVkXlcUCkdN+mdYWqUZVu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ImMheSFmhxGJQYn2H8AgpAa2SKSOstLKTbROfHDQeusZE5XO5Dapqkp+bvp4jnlZf
         TOyhq9xdiOylVAACeE1Uav8HxklFs7U3ON1g0IXg5/TLV9b1J54yo1HOKv63CPrajY
         yzQDzRk5B+6SxKdE0aAfee4Qs6LJf95/3VTrIaOE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Khoruzhick <anarsoul@gmail.com>,
        Harald Geyer <harald@ccbib.org>,
        "Jared D . McNeill" <jmcneill@NetBSD.org>,
        Emmanuel Vadot <manu@FreeBSD.org>,
        Maxime Ripard <mripard@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 07/81] arm64: dts: allwinner: a64: Drop PMU node
Date:   Wed, 30 Oct 2019 11:48:13 -0400
Message-Id: <20191030154928.9432-7-sashal@kernel.org>
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

From: Vasily Khoruzhick <anarsoul@gmail.com>

[ Upstream commit ed3e9406bcbc32f84dc4aa4cb4767852e5ab086c ]

Looks like PMU in A64 is broken, it generates no interrupts at all and
as result 'perf top' shows no events.

Tested on Pine64-LTS.

Fixes: 34a97fcc71c2 ("arm64: dts: allwinner: a64: Add PMU node")
Cc: Harald Geyer <harald@ccbib.org>
Cc: Jared D. McNeill <jmcneill@NetBSD.org>
Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Reviewed-by: Emmanuel Vadot <manu@FreeBSD.org>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
index 9cc9bdde81ac2..cd92f546c4838 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -142,15 +142,6 @@
 		clock-output-names = "ext-osc32k";
 	};
 
-	pmu {
-		compatible = "arm,cortex-a53-pmu";
-		interrupts = <GIC_SPI 152 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 153 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 154 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 155 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-affinity = <&cpu0>, <&cpu1>, <&cpu2>, <&cpu3>;
-	};
-
 	psci {
 		compatible = "arm,psci-0.2";
 		method = "smc";
-- 
2.20.1

