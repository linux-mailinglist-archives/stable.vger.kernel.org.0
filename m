Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C939F44B543
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245346AbhKIWTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:19:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245262AbhKIWTd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:19:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4767461221;
        Tue,  9 Nov 2021 22:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496206;
        bh=kPxX8Ibz8j/DEU/LjYZR6lYgG89AyU+9mad55ZEPNCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/jFls9qUZYnd3IUTQpNwNd4YH6JDHVlkj4M688cr4tVgT9nlgrusgbOAG8YRl23g
         ybeDYqbELeR1mLpb4Ct8h16AT6Y1AopDi9gZhb2yK+cahueuQxdQEMm0wTSlmzWkMH
         Uw1x5N4154TY3j5XSZlGloVj9Lu/eB4AhoMO2DJe7pqmPpBCSI4nCQRYUNYkr7BfXC
         Ev34Qq1U5YRCESZGva/AwviKe46aYmmAjUY2Fw4J0nTdUwy7DCkLZRzt3dlNmM9NXu
         0Fq47Dzztmto6Ke78h6i1L+chFLLqi0QQ1waI1XiLF7ZAsjLLN/IlkcPCXcXXG/H8q
         916Azc8eZulHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 02/82] arm64: zynqmp: Fix serial compatible string
Date:   Tue,  9 Nov 2021 17:15:20 -0500
Message-Id: <20211109221641.1233217-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
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
index 28dccb891a535..8278876ad33fa 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -792,7 +792,7 @@
 		};
 
 		uart0: serial@ff000000 {
-			compatible = "cdns,uart-r1p12", "xlnx,xuartps";
+			compatible = "xlnx,zynqmp-uart", "cdns,uart-r1p12";
 			status = "disabled";
 			interrupt-parent = <&gic>;
 			interrupts = <0 21 4>;
@@ -802,7 +802,7 @@
 		};
 
 		uart1: serial@ff010000 {
-			compatible = "cdns,uart-r1p12", "xlnx,xuartps";
+			compatible = "xlnx,zynqmp-uart", "cdns,uart-r1p12";
 			status = "disabled";
 			interrupt-parent = <&gic>;
 			interrupts = <0 22 4>;
-- 
2.33.0

