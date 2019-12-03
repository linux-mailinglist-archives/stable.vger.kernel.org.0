Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEF2E111F0E
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbfLCWsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:48:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:38680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729403AbfLCWsJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:48:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A39C20862;
        Tue,  3 Dec 2019 22:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413288;
        bh=S/UYcjtquDy0CcPqAHpXYiJOsV3eqyYvXDEKlXM21iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tSy415VkfuohadFC920jKaPnYtWxyWld3RePokfg/YlkX/GegUFLr/G4lmW54bJvN
         DQTUnD0ODyidTW+HVhKVqmsGR5PZU67WDcUjOEJz8gqJVhgsF5hKo6zXh20gVPhcz8
         TzA9CVLy3xX54boJEkKpg7V1iSQlx5W0ZOPhpVwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 070/321] ARM: dts: Fix hsi gdd range for omap4
Date:   Tue,  3 Dec 2019 23:32:16 +0100
Message-Id: <20191203223430.807658504@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit e9e685480b74aef3f3d0967dadb52eea3ff625d2 ]

While reviewing the missing mcasp ranges I noticed omap4 hsi range
for gdd is wrong so let's fix it.

I'm not aware of any omap4 devices in mainline kernel though that use
hsi though.

Fixes: 84badc5ec5fc ("ARM: dts: omap4: Move l4 child devices to probe
them with ti-sysc")
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap4-l4.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-l4.dtsi b/arch/arm/boot/dts/omap4-l4.dtsi
index 6eb26b837446c..5059ecac44787 100644
--- a/arch/arm/boot/dts/omap4-l4.dtsi
+++ b/arch/arm/boot/dts/omap4-l4.dtsi
@@ -196,12 +196,12 @@
 			clock-names = "fck";
 			#address-cells = <1>;
 			#size-cells = <1>;
-			ranges = <0x0 0x58000 0x4000>;
+			ranges = <0x0 0x58000 0x5000>;
 
 			hsi: hsi@0 {
 				compatible = "ti,omap4-hsi";
 				reg = <0x0 0x4000>,
-				      <0x4a05c000 0x1000>;
+				      <0x5000 0x1000>;
 				reg-names = "sys", "gdd";
 
 				clocks = <&l3_init_clkctrl OMAP4_HSI_CLKCTRL 0>;
-- 
2.20.1



