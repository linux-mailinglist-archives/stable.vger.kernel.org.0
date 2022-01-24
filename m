Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6C049934B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350672AbiAXUcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:32:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59238 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353543AbiAXUXG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:23:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0345AB812A4;
        Mon, 24 Jan 2022 20:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F6EC340E5;
        Mon, 24 Jan 2022 20:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055783;
        bh=U+Nb0NPZWLh7Nmoze8/HV96EGs6PbpH8kYa4V7Ihd9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCZ40Rc6a4/UyF2yKSwDThDNRRlaoaB7Ahv9eymcYoakfsyrtRabZ96dBQoSudYGQ
         XYHhPKQ2adQeypIwjnjCqo1U9oHGk1BhCB4EgeIiwH0kKzCslhHJfCnyRtzui2s2b6
         hPorjJpFwILuFCId1yr7lsrHkF/y3WgvMYkPiBSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 265/846] ARM: dts: armada-38x: Add generic compatible to UART nodes
Date:   Mon, 24 Jan 2022 19:36:22 +0100
Message-Id: <20220124184110.069355958@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 9b1a24cc5e91f..df3c8d1d8f641 100644
--- a/arch/arm/boot/dts/armada-38x.dtsi
+++ b/arch/arm/boot/dts/armada-38x.dtsi
@@ -168,7 +168,7 @@
 			};
 
 			uart0: serial@12000 {
-				compatible = "marvell,armada-38x-uart";
+				compatible = "marvell,armada-38x-uart", "ns16550a";
 				reg = <0x12000 0x100>;
 				reg-shift = <2>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
@@ -178,7 +178,7 @@
 			};
 
 			uart1: serial@12100 {
-				compatible = "marvell,armada-38x-uart";
+				compatible = "marvell,armada-38x-uart", "ns16550a";
 				reg = <0x12100 0x100>;
 				reg-shift = <2>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.34.1



