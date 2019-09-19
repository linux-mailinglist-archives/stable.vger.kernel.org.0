Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04975B8731
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405248AbfISWe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:34:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405342AbfISWJC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:09:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 403CE21928;
        Thu, 19 Sep 2019 22:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930939;
        bh=98bX0MPt6vFtYJpPxfdI5sUpNttahp3t6HhrK1Ib86Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3vQXqx1EXb03YM0N5eVUdM0F3m5evCgumjIKDXvyOEYH3UWm/TmD73BbkeksFMzu
         m1w36+ZnGgXgXozQozKNhCS/teaytnT7XfCxLEx1xjJFY/rvSo/c/YXgyo+ixL8836
         xsTWfPW9K6sn05B9SKdvmzUnvWlaR/okbfAgaC1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Emmanuel Vadot <manu@freebsd.org>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 038/124] ARM: dts: am335x: Fix UARTs length
Date:   Fri, 20 Sep 2019 00:02:06 +0200
Message-Id: <20190919214820.397686697@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Vadot <manu@freebsd.org>

[ Upstream commit 8613e2ca4fff764f23785eadfa54a08631ee682a ]

As seen on the AM335x TRM all the UARTs controller only are 0x1000 in size.
Fix this in the DTS.

Signed-off-by: Emmanuel Vadot <manu@freebsd.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am33xx-l4.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx-l4.dtsi b/arch/arm/boot/dts/am33xx-l4.dtsi
index 4bd22c1edf963..46849d6ecb3e2 100644
--- a/arch/arm/boot/dts/am33xx-l4.dtsi
+++ b/arch/arm/boot/dts/am33xx-l4.dtsi
@@ -185,7 +185,7 @@
 			uart0: serial@0 {
 				compatible = "ti,am3352-uart", "ti,omap3-uart";
 				clock-frequency = <48000000>;
-				reg = <0x0 0x2000>;
+				reg = <0x0 0x1000>;
 				interrupts = <72>;
 				status = "disabled";
 				dmas = <&edma 26 0>, <&edma 27 0>;
@@ -934,7 +934,7 @@
 			uart1: serial@0 {
 				compatible = "ti,am3352-uart", "ti,omap3-uart";
 				clock-frequency = <48000000>;
-				reg = <0x0 0x2000>;
+				reg = <0x0 0x1000>;
 				interrupts = <73>;
 				status = "disabled";
 				dmas = <&edma 28 0>, <&edma 29 0>;
@@ -966,7 +966,7 @@
 			uart2: serial@0 {
 				compatible = "ti,am3352-uart", "ti,omap3-uart";
 				clock-frequency = <48000000>;
-				reg = <0x0 0x2000>;
+				reg = <0x0 0x1000>;
 				interrupts = <74>;
 				status = "disabled";
 				dmas = <&edma 30 0>, <&edma 31 0>;
@@ -1614,7 +1614,7 @@
 			uart3: serial@0 {
 				compatible = "ti,am3352-uart", "ti,omap3-uart";
 				clock-frequency = <48000000>;
-				reg = <0x0 0x2000>;
+				reg = <0x0 0x1000>;
 				interrupts = <44>;
 				status = "disabled";
 			};
@@ -1644,7 +1644,7 @@
 			uart4: serial@0 {
 				compatible = "ti,am3352-uart", "ti,omap3-uart";
 				clock-frequency = <48000000>;
-				reg = <0x0 0x2000>;
+				reg = <0x0 0x1000>;
 				interrupts = <45>;
 				status = "disabled";
 			};
@@ -1674,7 +1674,7 @@
 			uart5: serial@0 {
 				compatible = "ti,am3352-uart", "ti,omap3-uart";
 				clock-frequency = <48000000>;
-				reg = <0x0 0x2000>;
+				reg = <0x0 0x1000>;
 				interrupts = <46>;
 				status = "disabled";
 			};
-- 
2.20.1



