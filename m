Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB2C7F3BB
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406475AbfHBJzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:55:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406473AbfHBJzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:55:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BA462064A;
        Fri,  2 Aug 2019 09:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739707;
        bh=ZJLlD6lG1D/sD35fvAMV/F87BNGYs5jRgT1y3pNuACY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDjd571QfImw2P3OSn4tLPy3EEMk4gJSc9lmfBSDDJWF/RAKmT988fiST5yl8aK55
         kYar9sNA/IEEuPfOQZ0GwS/n2UD+/C9i9542KUxBU4RLw9RobFuAbPFaSWD2170vVS
         dzi/OXc/VZyUHqt+Ci57yEv6IxaQLJMgpmif8Xa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, allen yan <yanwei@marvell.com>,
        Miquel Raynal <miquel.raynal@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 4.14 06/25] arm64: dts: marvell: Fix A37xx UART0 register size
Date:   Fri,  2 Aug 2019 11:39:38 +0200
Message-Id: <20190802092100.542820564@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092058.428079740@linuxfoundation.org>
References: <20190802092058.428079740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: allen yan <yanwei@marvell.com>

commit c737abc193d16e62e23e2fb585b8b7398ab380d8 upstream.

Armada-37xx UART0 registers are 0x200 bytes wide. Right next to them are
the UART1 registers that should not be declared in this node.

Update the example in DT bindings document accordingly.

Signed-off-by: allen yan <yanwei@marvell.com>
Signed-off-by: Miquel Raynal <miquel.raynal@free-electrons.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/serial/mvebu-uart.txt |    2 +-
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/serial/mvebu-uart.txt
+++ b/Documentation/devicetree/bindings/serial/mvebu-uart.txt
@@ -8,6 +8,6 @@ Required properties:
 Example:
 	serial@12000 {
 		compatible = "marvell,armada-3700-uart";
-		reg = <0x12000 0x400>;
+		reg = <0x12000 0x200>;
 		interrupts = <43>;
 	};
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -134,7 +134,7 @@
 
 			uart0: serial@12000 {
 				compatible = "marvell,armada-3700-uart";
-				reg = <0x12000 0x400>;
+				reg = <0x12000 0x200>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};


