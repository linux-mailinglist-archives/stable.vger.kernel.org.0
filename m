Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF94162344
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732876AbfGHPds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:33:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733027AbfGHPds (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:33:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D1AE21537;
        Mon,  8 Jul 2019 15:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562600027;
        bh=/FKc4kjIe82GxU9Sjc+/PTPdm3BLOpOWYvdj+AgWmkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0FDfSDdzF4y1LiM1F8pLxDydfOoxoSPedo87IMbjJwppTN/vXXriyR8kRhD3UHEx
         erSvKB0YBIRldD+kD/Wk9WErESU+C6qyZtywaRarQkcgqRUE38vGlY9xuGpw1geYAX
         4rfj4tcKXAb3/k1mb63JhLhZzm0tSj7mrfLZksCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Joshua Scott <joshua.scott@alliedtelesis.co.nz>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 5.1 70/96] ARM: dts: armada-xp-98dx3236: Switch to armada-38x-uart serial node
Date:   Mon,  8 Jul 2019 17:13:42 +0200
Message-Id: <20190708150530.239267964@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joshua Scott <joshua.scott@alliedtelesis.co.nz>

commit 80031361747aec92163464f2ee08870fec33bcb0 upstream.

Switch to the "marvell,armada-38x-uart" driver variant to empty
the UART buffer before writing to the UART_LCR register.

Signed-off-by: Joshua Scott <joshua.scott@alliedtelesis.co.nz>
Tested-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Gregory CLEMENT <gregory.clement@bootlin.com>.
Cc: stable@vger.kernel.org
Fixes: 43e28ba87708 ("ARM: dts: Use armada-370-xp as a base for armada-xp-98dx3236")
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/armada-xp-98dx3236.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/arm/boot/dts/armada-xp-98dx3236.dtsi
+++ b/arch/arm/boot/dts/armada-xp-98dx3236.dtsi
@@ -336,3 +336,11 @@
 	status = "disabled";
 };
 
+&uart0 {
+	compatible = "marvell,armada-38x-uart";
+};
+
+&uart1 {
+	compatible = "marvell,armada-38x-uart";
+};
+


