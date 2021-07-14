Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7293C8F35
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241297AbhGNTwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237211AbhGNTsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:48:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00CCB613EF;
        Wed, 14 Jul 2021 19:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291827;
        bh=+DqbFS5x2s+/musCghSMU5KuavezsX0x4DSciolvi5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YyCMumc6CXTcn37yYpG5cETA4AAIxdsHsfT/bkfFjgnoeaK0zUc71/vZrHQrruc5v
         78sOerZC9zp1poj7MGASWu1FwuGrHMoY0/mI3u5+tOdgL2apJv0M+a68qI9LRRFX09
         ON+cdLd+cocUjdH0Z8xvTkTLaNqi6AtasYDCwmIPbhPqIp0+ui15Z1xWI4PM+CXE0i
         DUZTftCRd0o05f26Ps8T4g+EP5KJ/y7bHpOImdEQG1P0xyoQXbWyaMiGun6bQBbBrm
         l6htfWPOnekXpPUVphUgShPfSSGHlnZX+7UjViv3pKh9yyhPN+zbJUHkhyhwjjs+om
         V8ztZznleIXQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 27/88] ARM: dts: ux500: Fix orientation of accelerometer
Date:   Wed, 14 Jul 2021 15:42:02 -0400
Message-Id: <20210714194303.54028-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 4beba4011995a2c44ee27e1d358dc32e6b9211b3 ]

This adds a mounting matrix to the accelerometer
on the TVK1281618 R3.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi b/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi
index c0de1337bdaa..457bddabc32c 100644
--- a/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi
+++ b/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi
@@ -19,6 +19,9 @@ accelerometer@19 {
 					     <19 IRQ_TYPE_EDGE_RISING>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&accel_tvk_mode>;
+				mount-matrix = "0", "-1", "0",
+					       "-1", "0", "0",
+					       "0", "0", "-1";
 			};
 			magnetometer@1e {
 				compatible = "st,lsm303dlm-magn";
-- 
2.30.2

