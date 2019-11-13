Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E88FFA1EE
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbfKMCAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:00:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730527AbfKMCAg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:00:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 907F02053B;
        Wed, 13 Nov 2019 02:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610436;
        bh=xI+skwa8kTa6/wPWYDcvAJcHAf1EsrACC8CuciHJb3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGXPbuPCYGFWpKPFb3irvi2xQIcFu0qPgEqRCw+qxXK0XSaJlYY2Asx+oDLbu4UTE
         BZPFid82nel9ZtoKvJA5ZOBJRDMRAJiWBkn7D9TfFEOyPSUgvYbsbhjRya5iWSB5tY
         vWqaY0ModYcQefxdCjdYg3uu1IhHsUAS0aBF40bo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 36/68] i2c: brcmstb: Allow enabling the driver on DSL SoCs
Date:   Tue, 12 Nov 2019 20:59:00 -0500
Message-Id: <20191113015932.12655-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
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
index d252276feadf6..759c621a860a9 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -397,12 +397,13 @@ config I2C_BCM_KONA
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

