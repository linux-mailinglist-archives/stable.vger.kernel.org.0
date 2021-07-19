Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDF83CE183
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349264AbhGSP0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:26:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347975AbhGSPXq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:23:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 576AA613CF;
        Mon, 19 Jul 2021 16:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710408;
        bh=Hw6Bt4NlAfIbcwYTNNJHzSfSZ2UD2OKIEiYo73AuUqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtoPHBHR2WaxXgo4Xl+mU1NpFwI8egBts1ey4Rv9hZakGYGVfwzKF//pO+M5Pxvr0
         p33rVyenabOxt9YdjASXyMMQCoXYVTLt/luFk7P9/G55+/34yVYVoVpBmdj0CMh3IH
         B2cdrM6ZItOqzNxWw9SLiSRbiBhOGKYgoBtEnav8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 203/243] arm64: dts: renesas: Add missing opp-suspend properties
Date:   Mon, 19 Jul 2021 16:53:52 +0200
Message-Id: <20210719144947.483718724@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 44b615ac9fab16d1552cd8360454077d411e3c35 ]

Tag the highest "Power Optimized" (1.5 GHz) Cortex-A57 operating point
table entries for the RZ/G2M, R-Car M3-W and M3-W+ SoCs with the
"opp-suspend" property.  This makes sure the system will enter suspend
in the same performance state as it will be resumed by the firmware
later, avoiding state inconsistencies after resume.

Based on a patch for R-Car M3-W in the BSP by Takeshi Kihara
<takeshi.kihara.df@renesas.com>.

Fixes: 800037e815b91d8c ("arm64: dts: renesas: r8a774a1: Add operating points")
Fixes: da7e3113344fda50 ("arm64: dts: renesas: r8a7796: Add OPPs table for cpu devices")
Fixes: f51746ad7d1ff6b4 ("arm64: dts: renesas: Add Renesas R8A77961 SoC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/r/45a061c3b0463aac7d10664f47c4afdd999da50d.1619699721.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a77960.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a77961.dtsi | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
index c15f1c571eb0..db091fa75115 100644
--- a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
@@ -76,6 +76,7 @@
 			opp-hz = /bits/ 64 <1500000000>;
 			opp-microvolt = <820000>;
 			clock-latency-ns = <300000>;
+			opp-suspend;
 		};
 	};
 
diff --git a/arch/arm64/boot/dts/renesas/r8a77960.dtsi b/arch/arm64/boot/dts/renesas/r8a77960.dtsi
index f379c8d1511d..5e2bd09b134b 100644
--- a/arch/arm64/boot/dts/renesas/r8a77960.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77960.dtsi
@@ -75,6 +75,7 @@
 			opp-hz = /bits/ 64 <1500000000>;
 			opp-microvolt = <820000>;
 			clock-latency-ns = <300000>;
+			opp-suspend;
 		};
 		opp-1600000000 {
 			opp-hz = /bits/ 64 <1600000000>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77961.dtsi b/arch/arm64/boot/dts/renesas/r8a77961.dtsi
index 1ba30313c8b8..5d030b300662 100644
--- a/arch/arm64/boot/dts/renesas/r8a77961.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77961.dtsi
@@ -64,6 +64,7 @@
 			opp-hz = /bits/ 64 <1500000000>;
 			opp-microvolt = <820000>;
 			clock-latency-ns = <300000>;
+			opp-suspend;
 		};
 		opp-1600000000 {
 			opp-hz = /bits/ 64 <1600000000>;
-- 
2.30.2



