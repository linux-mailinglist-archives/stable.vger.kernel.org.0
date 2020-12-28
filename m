Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637A22E3C7A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437061AbgL1ODE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:03:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:34086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407951AbgL1OAY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:00:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F1FE2063A;
        Mon, 28 Dec 2020 13:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163984;
        bh=jeIUE17zVvGWBS3vjNP95/oZhOzvIpMbOirAKwcHewY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k41Ti5v03LrZ0Gxm1cLcXVEk3puIJhyHGGtJmmKpMo7Rp8wPPqcNp5o099afzfS1/
         nOJjU2aUij/C6RG6lJa8OahO5/kh7oZIvYUqsKjyyvO6LaLyeCqsx6iP6kAIypH51u
         ZrXIFWu4/WkMegZO9PjRX7lmyi85ZJA6nJFenJB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Billy Tsai <billy_tsai@aspeedtech.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/717] ARM: dts: aspeed-g6: Fix the GPIO memory size
Date:   Mon, 28 Dec 2020 13:40:18 +0100
Message-Id: <20201228125021.953521794@linuxfoundation.org>
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

From: Billy Tsai <billy_tsai@aspeedtech.com>

[ Upstream commit 886f82ce9f1f4559c139fdb2d79d158999ca38cd ]

The GPIO controller is a GPIO controller followed by some SGPIO
controllers, which are a different type of device with their own binding
and drivers.

Make the gpio node cover the only conventional GPIO controller.

Fixes: 8dbcb5b709b9 ("ARM: dts: aspeed-g6: Add gpio devices")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20201012033150.21056-2-billy_tsai@aspeedtech.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-g6.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/aspeed-g6.dtsi b/arch/arm/boot/dts/aspeed-g6.dtsi
index b58220a49cbd8..bf97aaad7be9b 100644
--- a/arch/arm/boot/dts/aspeed-g6.dtsi
+++ b/arch/arm/boot/dts/aspeed-g6.dtsi
@@ -357,7 +357,7 @@
 				#gpio-cells = <2>;
 				gpio-controller;
 				compatible = "aspeed,ast2600-gpio";
-				reg = <0x1e780000 0x800>;
+				reg = <0x1e780000 0x400>;
 				interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
 				gpio-ranges = <&pinctrl 0 0 208>;
 				ngpios = <208>;
-- 
2.27.0



