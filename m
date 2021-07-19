Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B953CE5E7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242698AbhGSPz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:55:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350541AbhGSPvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:51:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89415613B0;
        Mon, 19 Jul 2021 16:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712222;
        bh=/4K0Bqp2C6DeGRLBbM6uAVcC0W+ZJfZ/D+wLlYlOnbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a1VfkE9OM8yJG1LDnTKmv5FLY1WCzvGu6BnAgnRUuF2z5vYGIJiaunH9GktzaethD
         L9RXycSG6owYXk++ns2KKTZkzup+JZ7/sqjfisS+vYSpTavHU5xvoMbUB9zEB/eHlZ
         Rft94oIZ0JMYLflU5yJFwwuZITa6UhkX9dkLhijk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 265/292] ARM: dts: am335x: align ti,pindir-d0-out-d1-in property with dt-shema
Date:   Mon, 19 Jul 2021 16:55:27 +0200
Message-Id: <20210719144951.638885074@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aswath Govindraju <a-govindraju@ti.com>

[ Upstream commit 414bfe1d26b60ef20b58e36efd5363188a694bab ]

ti,pindir-d0-out-d1-in property is expected to be of type boolean.
Therefore, fix the property accordingly.

Fixes: 444d66fafab8 ("ARM: dts: add spi wifi support to cm-t335")
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am335x-cm-t335.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am335x-cm-t335.dts b/arch/arm/boot/dts/am335x-cm-t335.dts
index 36d963db4026..ec4730c82d39 100644
--- a/arch/arm/boot/dts/am335x-cm-t335.dts
+++ b/arch/arm/boot/dts/am335x-cm-t335.dts
@@ -496,7 +496,7 @@ status = "okay";
 	status = "okay";
 	pinctrl-names = "default";
 	pinctrl-0 = <&spi0_pins>;
-	ti,pindir-d0-out-d1-in = <1>;
+	ti,pindir-d0-out-d1-in;
 	/* WLS1271 WiFi */
 	wlcore: wlcore@1 {
 		compatible = "ti,wl1271";
-- 
2.30.2



