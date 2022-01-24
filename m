Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2ABE498BFC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245338AbiAXTSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:18:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45302 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344024AbiAXTQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:16:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6271060918;
        Mon, 24 Jan 2022 19:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F701C340E5;
        Mon, 24 Jan 2022 19:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051769;
        bh=R/8W69jPQrWexMmMn+5pYEBZEBte7tNLSs8/YEVRk5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qLjh70yvt5bJ/HuqpF8Gwy6+TuHHTQ9m3W4VweGsdbrD/KyM66Ike/FECks2jnaJY
         LwbklB5ShgR2i63GWARqWeyU53am6AWhbvtycJXzUJ+0HQl4rDjqGKtxWiGdbQs+SD
         TLjBF1ySLf8MZTe7ezH7Rz2L5aOWtFNwvbOF1fc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 082/239] ARM: dts: armada-38x: Add generic compatible to UART nodes
Date:   Mon, 24 Jan 2022 19:42:00 +0100
Message-Id: <20220124183945.730959014@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 62480772263ab6b52e758f2346c70a526abd1d28 ]

Add generic compatible string "ns16550a" to serial port nodes of Armada
38x.

This makes it possible to use earlycon.

Fixes: 0d3d96ab0059 ("ARM: mvebu: add Device Tree description of the Armada 380/385 SoCs")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-38x.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/armada-38x.dtsi b/arch/arm/boot/dts/armada-38x.dtsi
index 929459c427605..6f32f12332824 100644
--- a/arch/arm/boot/dts/armada-38x.dtsi
+++ b/arch/arm/boot/dts/armada-38x.dtsi
@@ -163,7 +163,7 @@
 			};
 
 			uart0: serial@12000 {
-				compatible = "marvell,armada-38x-uart";
+				compatible = "marvell,armada-38x-uart", "ns16550a";
 				reg = <0x12000 0x100>;
 				reg-shift = <2>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
@@ -173,7 +173,7 @@
 			};
 
 			uart1: serial@12100 {
-				compatible = "marvell,armada-38x-uart";
+				compatible = "marvell,armada-38x-uart", "ns16550a";
 				reg = <0x12100 0x100>;
 				reg-shift = <2>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.34.1



