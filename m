Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901ED44B64F
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240004AbhKIW02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:26:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:41388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235193AbhKIWYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:24:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3185F617E5;
        Tue,  9 Nov 2021 22:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496350;
        bh=kPxX8Ibz8j/DEU/LjYZR6lYgG89AyU+9mad55ZEPNCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbpwCooDt5RjZnr1nNxUtGvEcb9b1bN8T7nGxanmmL/R5NSBlYfzHCS3HOD+k8vP8
         8zk1taWVBSWdGR9Jeak2ZTDHDiuVIjmsNa0LGRPg2kyZh0WvkheVVoIYCwJ1DzDjut
         vATmeAtaUdyiS7iuqBzDALUCNAWE1xcP/3NBg3VmEMzZny+bwMpBvlLB10ZEvrrB5c
         Iw5vTBT4JXyuwUoD9ao1bkWFF1/eiulIYUD9vupiexER57Z6sSJEURA0yTABGgBJ5V
         B5uD4TDkmmRJG4JJBGFQJovuHSmbJPoyME0B2waPIr9j+MvTrj252zr0rvBbjCuT3G
         YTUXbxLcZMGqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 02/75] arm64: zynqmp: Fix serial compatible string
Date:   Tue,  9 Nov 2021 17:17:52 -0500
Message-Id: <20211109221905.1234094-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
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

