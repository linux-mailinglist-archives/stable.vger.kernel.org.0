Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EF245C144
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245559AbhKXNQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:16:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:53912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348757AbhKXNOA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:14:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10D9B6126A;
        Wed, 24 Nov 2021 12:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757821;
        bh=2iodbM1BE0NpXrnkO5lNNPKsyTOunAEJAc2f7GmqjsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQ+/Qx/9RLcAwFVv7EJP8DcHtkaiEUgj1J/6aMs3f5pDDX+H6diH6B3cO/NDORvUS
         rP32C8id7Qj8KOreHr2O7w7w4nkA3vM1LSx9RQhmZGJGh0gipvnR93ZuCfOgv0I891
         rd1YZ8uiIgCpb/0PtHj4B4cLBmdzbEXfz//XK/Ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 260/323] arm64: zynqmp: Fix serial compatible string
Date:   Wed, 24 Nov 2021 12:57:30 +0100
Message-Id: <20211124115727.670626892@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



