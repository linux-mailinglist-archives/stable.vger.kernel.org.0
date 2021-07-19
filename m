Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C273CE5BD
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349249AbhGSPxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347868AbhGSPsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:48:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCE0461241;
        Mon, 19 Jul 2021 16:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712085;
        bh=SmH4RdSucAySgz1/MtvrctKxE1srBsf7h2Nr4GwenXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/XtYRYqTsqmYPF5KmG3X6xZ5gSi+WUyP5C0FjpnAgwC33OK1xKj0Q19H9xIwG91C
         2f9N4o9cJhVVaGpUhXqK1FE7Phv1U0ADo+kUcBRi6zuZkAvffxFDFLqYuMI180a0sK
         nkyb96LP7TN/fop45DNVm8yCxsXwOnJsglrvda6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 244/292] arm64: dts: renesas: r8a7796[01]: Fix OPP table entry voltages
Date:   Mon, 19 Jul 2021 16:55:06 +0200
Message-Id: <20210719144950.979166144@linuxfoundation.org>
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

[ Upstream commit 659b38203f04f5c3d1dc60f1a3e54b582ad3841c ]

Correct the voltages in the "Power Optimized" (<= 1.5 GHz) Cortex-A57
operating point table entries for the R-Car M3-W and M3-W+ SoCs from
0.82V to 0.83V, as per the R-Car Gen3 EC Manual Errata for Revision
0.53.

Based on a patch for R-Car M3-W in the BSP by Takeshi Kihara
<takeshi.kihara.df@renesas.com>.

Fixes: da7e3113344fda50 ("arm64: dts: renesas: r8a7796: Add OPPs table for cpu devices")
Fixes: f51746ad7d1ff6b4 ("arm64: dts: renesas: Add Renesas R8A77961 SoC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/b9e9db907514790574429b83d070c823b36085ef.1619699909.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a77960.dtsi | 6 +++---
 arch/arm64/boot/dts/renesas/r8a77961.dtsi | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a77960.dtsi b/arch/arm64/boot/dts/renesas/r8a77960.dtsi
index 634fc8618bbb..949a8b787394 100644
--- a/arch/arm64/boot/dts/renesas/r8a77960.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77960.dtsi
@@ -63,17 +63,17 @@
 
 		opp-500000000 {
 			opp-hz = /bits/ 64 <500000000>;
-			opp-microvolt = <820000>;
+			opp-microvolt = <830000>;
 			clock-latency-ns = <300000>;
 		};
 		opp-1000000000 {
 			opp-hz = /bits/ 64 <1000000000>;
-			opp-microvolt = <820000>;
+			opp-microvolt = <830000>;
 			clock-latency-ns = <300000>;
 		};
 		opp-1500000000 {
 			opp-hz = /bits/ 64 <1500000000>;
-			opp-microvolt = <820000>;
+			opp-microvolt = <830000>;
 			clock-latency-ns = <300000>;
 			opp-suspend;
 		};
diff --git a/arch/arm64/boot/dts/renesas/r8a77961.dtsi b/arch/arm64/boot/dts/renesas/r8a77961.dtsi
index 2234a8ee6ed0..550b10a7e18b 100644
--- a/arch/arm64/boot/dts/renesas/r8a77961.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77961.dtsi
@@ -52,17 +52,17 @@
 
 		opp-500000000 {
 			opp-hz = /bits/ 64 <500000000>;
-			opp-microvolt = <820000>;
+			opp-microvolt = <830000>;
 			clock-latency-ns = <300000>;
 		};
 		opp-1000000000 {
 			opp-hz = /bits/ 64 <1000000000>;
-			opp-microvolt = <820000>;
+			opp-microvolt = <830000>;
 			clock-latency-ns = <300000>;
 		};
 		opp-1500000000 {
 			opp-hz = /bits/ 64 <1500000000>;
-			opp-microvolt = <820000>;
+			opp-microvolt = <830000>;
 			clock-latency-ns = <300000>;
 			opp-suspend;
 		};
-- 
2.30.2



