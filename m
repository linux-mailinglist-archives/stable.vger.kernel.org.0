Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1752837C8AA
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236477AbhELQL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238721AbhELQGJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:06:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B08F61CF2;
        Wed, 12 May 2021 15:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833705;
        bh=rJIFdw0isvR2p8mFPAxdcvlKcGl++/Z9rC67JVzr8Uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jOC2I/Zh8YZGCQkWaVLoEIj1MSUdvcA9tWCWowUTrAOdkxpWvkKF9CkPrlIinxIrl
         5mrPJm4Go4gMiGMgYxMlpcmzBLs4fJE890OPOGl75hBR3QLYuzmnJxjpDy6mXfUrW6
         DLz7jz5tKXxY8FUzaNNXqAmmVug2GaBfxMXzC2o8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabien Parent <fparent@baylibre.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 220/601] arm64: dts: mediatek: fix reset GPIO level on pumpkin
Date:   Wed, 12 May 2021 16:44:57 +0200
Message-Id: <20210512144835.085407647@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabien Parent <fparent@baylibre.com>

[ Upstream commit a7dceafed43a4a610d340da3703653cca2c50c1d ]

The tca6416 chip is active low. Fix the reset-gpios value.

Fixes: e2a8fa1e0faa ("arm64: dts: mediatek: fix tca6416 reset GPIOs in pumpkin")
Signed-off-by: Fabien Parent <fparent@baylibre.com>
Link: https://lore.kernel.org/r/20210223221826.2063911-1-fparent@baylibre.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
index 63fd70086bb8..9f27e7ed5e22 100644
--- a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
+++ b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
@@ -56,7 +56,7 @@
 	tca6416: gpio@20 {
 		compatible = "ti,tca6416";
 		reg = <0x20>;
-		reset-gpios = <&pio 65 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&pio 65 GPIO_ACTIVE_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&tca6416_pins>;
 
-- 
2.30.2



