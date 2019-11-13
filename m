Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEDEDFA3D5
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbfKMCMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:12:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729953AbfKMB6K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:58:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 325F8222D3;
        Wed, 13 Nov 2019 01:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610289;
        bh=Vp7x52tWRWgDfeFgld4Gwk0u6iwjQtfSbiDkxb/zxYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nyUDzTsVoFb1Z8Hw556ddpsgyPB/kdYhGVdT3UTNpkhSRnZWHd9VkNZ2UphzubvtF
         uNUTDKk1gGHN1m+m7l214wRdACSxjAHJBRC2zCOxx2NwjV4t1t3xpsu5i6nKm+r5YU
         KeBl6sG6TGSHd/JlRnRINS/6el+GnpIsHnwpTwYo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 065/115] i2c: brcmstb: Allow enabling the driver on DSL SoCs
Date:   Tue, 12 Nov 2019 20:55:32 -0500
Message-Id: <20191113015622.11592-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit e1eba2ea54a2de0e4c58d87270d25706bb77b844 ]

ARCH_BCM_63XX which is used by ARM-based DSL SoCs from Broadcom uses the
same controller, make it possible to select the STB driver and update
the Kconfig and help text a bit.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/Kconfig | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 45a3f3ca29b38..b72a25585d52b 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -429,12 +429,13 @@ config I2C_BCM_KONA
 	  If you do not need KONA I2C interface, say N.
 
 config I2C_BRCMSTB
-	tristate "BRCM Settop I2C controller"
-	depends on ARCH_BRCMSTB || BMIPS_GENERIC || COMPILE_TEST
+	tristate "BRCM Settop/DSL I2C controller"
+	depends on ARCH_BRCMSTB || BMIPS_GENERIC || ARCH_BCM_63XX || \
+		   COMPILE_TEST
 	default y
 	help
 	  If you say yes to this option, support will be included for the
-	  I2C interface on the Broadcom Settop SoCs.
+	  I2C interface on the Broadcom Settop/DSL SoCs.
 
 	  If you do not need I2C interface, say N.
 
-- 
2.20.1

