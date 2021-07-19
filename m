Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8583CE250
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348070AbhGSPaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348114AbhGSPYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D653B61446;
        Mon, 19 Jul 2021 16:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710514;
        bh=Uw4znneNdE3+jEIxxj3FTsKuwbyYOUj7XuRGv0103cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJHGby9voafge/GJoHNSrnVOoO+Kg9mpNE/tIyv5kmGFwOlzgjeFStzT4BMLGmq8k
         TwxZLdO3W3rTvJr5PkGFuEKiJYuJCh6auol3KWpqiPGdHQvH6PhfWJPzAwMKAEb1it
         ipMK6As+ANdPlkJK8L/V26NJMvepsTv/jIupYP54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 223/243] ARM: dts: am437x: align ti,pindir-d0-out-d1-in property with dt-shema
Date:   Mon, 19 Jul 2021 16:54:12 +0200
Message-Id: <20210719144948.123838078@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aswath Govindraju <a-govindraju@ti.com>

[ Upstream commit 9b11fec7345f21995f4ea4bafb0e108b9a620238 ]

ti,pindir-d0-out-d1-in property is expected to be of type boolean.
Therefore, fix the property accordingly.

Fixes: b0b039515445 ("ARM: dts: am43x-epos-evm: set data pin directions for spi0 and spi1")
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am43x-epos-evm.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index f517d1e843cf..8b696107eef8 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -860,7 +860,7 @@
 	pinctrl-names = "default", "sleep";
 	pinctrl-0 = <&spi0_pins_default>;
 	pinctrl-1 = <&spi0_pins_sleep>;
-	ti,pindir-d0-out-d1-in = <1>;
+	ti,pindir-d0-out-d1-in;
 };
 
 &spi1 {
@@ -868,7 +868,7 @@
 	pinctrl-names = "default", "sleep";
 	pinctrl-0 = <&spi1_pins_default>;
 	pinctrl-1 = <&spi1_pins_sleep>;
-	ti,pindir-d0-out-d1-in = <1>;
+	ti,pindir-d0-out-d1-in;
 };
 
 &usb2_phy1 {
-- 
2.30.2



