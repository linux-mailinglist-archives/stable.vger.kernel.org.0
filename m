Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346672E4114
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440186AbgL1ONa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:13:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440158AbgL1ON3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:13:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 544AB206D4;
        Mon, 28 Dec 2020 14:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164768;
        bh=DqmKWsSMxc56eY8uJE+/3azdVSzrWl3bhx8mBCLS9f0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wYpRHLkX1ElSakWLkk506sPLEbtgZf618v3Ofy+J31ziFVkdsPIvJ2scqEnVOoZKP
         A4CqgsJ17kgYnfLBkcqO7daDjfEnHSJdoxkFdQaR9unA9Tf46/fjSTXmdhHNkR0cfo
         LzyiLwzJlA4QNrnUB0+2dpNWqPpC9Ms3AR8fxPag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Marco Cardellini <marco.cardellini@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 292/717] ARM: dts: at91: sam9x60ek: remove bypass property
Date:   Mon, 28 Dec 2020 13:44:50 +0100
Message-Id: <20201228125035.024539672@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit ab8a9bb41b2c330a0b280280bf37b6f3b1dd1e58 ]

atmel,osc-bypass property sets the bit 1 at main oscillator register.
On SAM9X60 this bit is not valid according to datasheet (chapter
28.16.9 PMC Clock Generator Main Oscillator Register).

Fixes: 1e5f532c2737 ("ARM: dts: at91: sam9x60: add device tree for soc and board")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Marco Cardellini <marco.cardellini@microchip.com>
Link: https://lore.kernel.org/r/1606903025-14197-2-git-send-email-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sam9x60ek.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sam9x60ek.dts b/arch/arm/boot/dts/at91-sam9x60ek.dts
index 0e3b6147069f9..73b6b1f89de99 100644
--- a/arch/arm/boot/dts/at91-sam9x60ek.dts
+++ b/arch/arm/boot/dts/at91-sam9x60ek.dts
@@ -578,10 +578,6 @@
 	};
 }; /* pinctrl */
 
-&pmc {
-	atmel,osc-bypass;
-};
-
 &pwm0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_pwm0_0 &pinctrl_pwm0_1 &pinctrl_pwm0_2 &pinctrl_pwm0_3>;
-- 
2.27.0



