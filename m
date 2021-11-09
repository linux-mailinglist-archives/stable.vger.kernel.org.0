Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8689C44B85F
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345775AbhKIWmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:42:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345359AbhKIWkO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:40:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4526F619EC;
        Tue,  9 Nov 2021 22:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496626;
        bh=6l2sv+fSHki9vKTLYP6LdsRBvFL0kmdpUkYh0hyGpB8=;
        h=From:To:Cc:Subject:Date:From;
        b=UFBVr48H8v7eAARlS4GhQ3HDX/Ey0EHBh26JlS1VtOjLu78vXs7jKpG0PMITSN6cM
         pNIGtOhoHMyjFCBkmc3pYpb3ioMrf0m0iasEd8egtMXZmsSyo1+pdUAkA0IxydcrEZ
         RZF/O+frNi2SHqfeTvrecp9X6bUkpE7lvu2uRrPWD8duc18yVZYa/PlAwjClo+Cksk
         6D77u5H7uor5hRzfKdoQg2i881E7oIkIJgNLMGQG+eip1QhQZmmTsN8gScOLKWRIfX
         UDuso4cLgiOY6wgWrphUcG9GuAJH+tqh9SzPeVUVROiC7Qpdyoi2BoZl8OTMkISR4g
         Mj7jc7z9WNUwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 01/14] arm64: zynqmp: Fix serial compatible string
Date:   Tue,  9 Nov 2021 17:23:30 -0500
Message-Id: <20211109222343.1235902-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
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
index 0531843117f46..58028f23ad9aa 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -573,7 +573,7 @@
 		};
 
 		uart0: serial@ff000000 {
-			compatible = "cdns,uart-r1p12", "xlnx,xuartps";
+			compatible = "xlnx,zynqmp-uart", "cdns,uart-r1p12";
 			status = "disabled";
 			interrupt-parent = <&gic>;
 			interrupts = <0 21 4>;
@@ -582,7 +582,7 @@
 		};
 
 		uart1: serial@ff010000 {
-			compatible = "cdns,uart-r1p12", "xlnx,xuartps";
+			compatible = "xlnx,zynqmp-uart", "cdns,uart-r1p12";
 			status = "disabled";
 			interrupt-parent = <&gic>;
 			interrupts = <0 22 4>;
-- 
2.33.0

