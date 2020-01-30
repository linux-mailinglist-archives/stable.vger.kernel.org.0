Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFF614E36F
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 20:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbgA3Tzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 14:55:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgA3Tzm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 14:55:42 -0500
Received: from localhost.localdomain (unknown [194.230.155.229])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8280D20708;
        Thu, 30 Jan 2020 19:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580414142;
        bh=h28+OzWv84FMorXQcpuwm+CgBd4CxAA13jLAZ5nqeG4=;
        h=From:To:Cc:Subject:Date:From;
        b=etdT/+iMcutb7+ZqXyY9N7nNmLoyK+tYGnjhtJEfT1PGuvNPHJNUdk/GrCYWz6n6R
         LDOk2fkt7m8UqvCWVC35I1x2fRXINQXEIlFRuXy87RUBXbE6jwA6GgiJc7M+F6It96
         By1Qf5Pul1V2ML6bPiIECano85qKpLoFCLjnKMI8=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Russell King <linux@armlinux.org.uk>,
        Alexander Shiyan <shc_work@mail.ru>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Avi Fishman <avifishman70@gmail.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Tali Perry <tali.perry1@gmail.com>,
        Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, openbmc@lists.ozlabs.org,
        arm@kernel.org, soc@kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] ARM: npcm: Bring back GPIOLIB support
Date:   Thu, 30 Jan 2020 20:55:24 +0100
Message-Id: <20200130195525.4525-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The CONFIG_ARCH_REQUIRE_GPIOLIB is gone since commit 65053e1a7743
("gpio: delete ARCH_[WANTS_OPTIONAL|REQUIRE]_GPIOLIB") and all platforms
should explicitly select GPIOLIB to have it.

Cc: <stable@vger.kernel.org>
Fixes: 65053e1a7743 ("gpio: delete ARCH_[WANTS_OPTIONAL|REQUIRE]_GPIOLIB")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 arch/arm/mach-npcm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-npcm/Kconfig b/arch/arm/mach-npcm/Kconfig
index 880bc2a5cada..7f7002dc2b21 100644
--- a/arch/arm/mach-npcm/Kconfig
+++ b/arch/arm/mach-npcm/Kconfig
@@ -11,7 +11,7 @@ config ARCH_NPCM7XX
 	depends on ARCH_MULTI_V7
 	select PINCTRL_NPCM7XX
 	select NPCM7XX_TIMER
-	select ARCH_REQUIRE_GPIOLIB
+	select GPIOLIB
 	select CACHE_L2X0
 	select ARM_GIC
 	select HAVE_ARM_TWD if SMP
-- 
2.17.1

