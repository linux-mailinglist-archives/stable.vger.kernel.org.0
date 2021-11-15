Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2314D45117A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243044AbhKOTJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:09:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:35164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243885AbhKOTEg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:04:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4F88632A9;
        Mon, 15 Nov 2021 18:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000147;
        bh=QPAv+pnlnR8/JQUrSyaxyj0CGOv8mdSEsO2XRhRn57E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qolPPSvIH3v5BAGdWiD/z9SfY4erTSl32hkP5QPGzikBddPLtALl7g7peeP1EYFRL
         VGP0LJcOZv7nE9B3NUGgLR6tqxDWpBdqZ4bD1k/V2+ppB+dFIQJ0M5sXwHVhq9ZOdC
         k9nJUy0kvd9P5Fej6nDUbEnxe0WZrBbSWy5OdC7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 554/849] arm64: dts: broadcom: bcm4908: Fix UART clock name
Date:   Mon, 15 Nov 2021 18:00:37 +0100
Message-Id: <20211115165438.999435405@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 6c38c39ab2141f53786d73e706675e8819a3f2cb ]

According to the binding the correct clock name is "refclk".

Fixes: 2961f69f151c ("arm64: dts: broadcom: add BCM4908 and Asus GT-AC5300 early DTS files")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
index a5a64d17d9ea6..f6b93bbb49228 100644
--- a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
@@ -292,7 +292,7 @@
 			reg = <0x640 0x18>;
 			interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&periph_clk>;
-			clock-names = "periph";
+			clock-names = "refclk";
 			status = "okay";
 		};
 
-- 
2.33.0



