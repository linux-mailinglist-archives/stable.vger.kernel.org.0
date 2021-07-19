Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2F53CE5B9
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349073AbhGSPxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347840AbhGSPsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:48:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 565C76145A;
        Mon, 19 Jul 2021 16:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712083;
        bh=+I/ctHPHHRAff2tUHjXcoGL7iz9J3PIPmwh0p51c5Kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4okvjew3CrwRbiC+MRIzh8ZjZC/uGlQsAiGKc8ZsZeZPe2QsaW9Yt4g/kds+NBSG
         WxNV+jMTjJFqxDJyy/71qbB+9K1hpNA++vhZPOCF2kQ/CwiozO0hyewKxWqjvTvUtq
         A92D3sRKiGFMNAgTnYNnYG3CJlbb2IOzDfAsLfEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 243/292] arm64: dts: renesas: Add missing opp-suspend properties
Date:   Mon, 19 Jul 2021 16:55:05 +0200
Message-Id: <20210719144950.948475640@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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
index d64fb8b1b86c..2e427f21130d 100644
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
index 25d947a81b29..634fc8618bbb 100644
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
index e8c31ebec097..2234a8ee6ed0 100644
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



