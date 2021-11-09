Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D32544B81D
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345440AbhKIWkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:40:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345558AbhKIWiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:38:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82A5961B01;
        Tue,  9 Nov 2021 22:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496595;
        bh=2iodbM1BE0NpXrnkO5lNNPKsyTOunAEJAc2f7GmqjsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YNxr25WMAxY8fE0/PxIsE9k8GQw4avy0KDAFzBB9on/dp6XHvrmY+xCng0zTNivtM
         M0FqTR6ClmBbAQ/aYKv9eeBP2jf8K0M9E3OGmkctV/lQfGyWsEW/HsfXf++5y0gWIQ
         0a73Rf0wh1tVBKVvYfCKoQgngDtIA33XVb6M37WPyhfMt49pEL/UI8RfL3ESc275y6
         TeJyEpm4b748udO1l4KqRJMp1X4JeuglzhAS0ptsn0isaaya1b5AYjAvjJ4HSsO7xQ
         B611sdYpxK3Wd5OlY315QYteC3a6ym/fpx0Up8QMkXzeDvsy8srRA9Usi53qkYYFcT
         LbVENoHtJVq0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 02/21] arm64: zynqmp: Fix serial compatible string
Date:   Tue,  9 Nov 2021 17:22:51 -0500
Message-Id: <20211109222311.1235686-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222311.1235686-1-sashal@kernel.org>
References: <20211109222311.1235686-1-sashal@kernel.org>
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
index 8a885ae647b7e..6478bca018197 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -574,7 +574,7 @@
 		};
 
 		uart0: serial@ff000000 {
-			compatible = "cdns,uart-r1p12", "xlnx,xuartps";
+			compatible = "xlnx,zynqmp-uart", "cdns,uart-r1p12";
 			status = "disabled";
 			interrupt-parent = <&gic>;
 			interrupts = <0 21 4>;
@@ -583,7 +583,7 @@
 		};
 
 		uart1: serial@ff010000 {
-			compatible = "cdns,uart-r1p12", "xlnx,xuartps";
+			compatible = "xlnx,zynqmp-uart", "cdns,uart-r1p12";
 			status = "disabled";
 			interrupt-parent = <&gic>;
 			interrupts = <0 22 4>;
-- 
2.33.0

