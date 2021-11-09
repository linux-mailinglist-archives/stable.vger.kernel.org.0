Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6852944B735
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344767AbhKIWcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:32:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:55112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344796AbhKIWau (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:30:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4737561A8D;
        Tue,  9 Nov 2021 22:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496468;
        bh=eEMNO466/+1l4wU8272HJly0CW1obvnDSJC7HgDhY8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3oyL6ylQHCN5drz7TEMMkx3mywpf8Vu/12u8HHNXQNtb4q5q++HyK5DsXlEb1qNK
         /oCFOsrcRVx9Zs2lt7UTFJ4t2Cn4BHARrnCPQounHdzQdEDEQLF2Ts1AFDuzvktEDx
         mNwJkAvlse4rg59hXZ0YBv3ae7gd2+w1FSWa3VlW2/SyPROLEKUIV54aBv7Z71HUln
         9bXoVdGmNjl0l9jHO49HFJqwYYkekCZm2tJGPCKX1uGlmhJadfBOVTVrRdLDr5DkCk
         W4g4Xojl26LYpGuKIe4dJ5VROwxIQKxDBuBD2xcPtilTdIn5Do3RlHwnnsa8U1RZ5+
         wv2rJa2JbQRtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 02/50] arm64: zynqmp: Fix serial compatible string
Date:   Tue,  9 Nov 2021 17:20:15 -0500
Message-Id: <20211109222103.1234885-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

[ Upstream commit 812fa2f0e9d33564bd0131a69750e0d165f4c82a ]

Based on commit 65a2c14d4f00 ("dt-bindings: serial: convert Cadence UART
bindings to YAML") compatible string should look like differently that's
why fix it to be aligned with dt binding.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/89b36e0a6187cc6b05b27a035efdf79173bd4486.1628240307.git.michal.simek@xilinx.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
index 771f60e0346d0..9e198cacc37dd 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -688,7 +688,7 @@
 		};
 
 		uart0: serial@ff000000 {
-			compatible = "cdns,uart-r1p12", "xlnx,xuartps";
+			compatible = "xlnx,zynqmp-uart", "cdns,uart-r1p12";
 			status = "disabled";
 			interrupt-parent = <&gic>;
 			interrupts = <0 21 4>;
@@ -698,7 +698,7 @@
 		};
 
 		uart1: serial@ff010000 {
-			compatible = "cdns,uart-r1p12", "xlnx,xuartps";
+			compatible = "xlnx,zynqmp-uart", "cdns,uart-r1p12";
 			status = "disabled";
 			interrupt-parent = <&gic>;
 			interrupts = <0 22 4>;
-- 
2.33.0

