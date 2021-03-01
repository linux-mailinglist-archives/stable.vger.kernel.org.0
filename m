Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45AB5328BB3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240301AbhCASii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:47668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239940AbhCASbt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:31:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DA1865219;
        Mon,  1 Mar 2021 17:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619363;
        bh=0CKkUiDriWAC0w6++OGrKVmH23JaGJ3QDThEO9jZUO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=On45CnfrgCgvg0O6a4Csgqem4GuV3Q8QxXUXZl9ofXEwYu1CTYtyUV/ZPxlOxpcL8
         tdin4d4FuGQLlJ4AIIWVrXmARe056eJKObse/hVIW5kSA+y4x8fMNzEOdZ2oPF/hIO
         9LXyvpgrTf7fy0CvfUw8Ca7a/xtLW3NgEGOfaNkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 397/663] misc: eeprom_93xx46: Add module alias to avoid breaking support for non device tree users
Date:   Mon,  1 Mar 2021 17:10:45 +0100
Message-Id: <20210301161201.509903055@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aswath Govindraju <a-govindraju@ti.com>

[ Upstream commit 4540b9fbd8ebb21bb3735796d300a1589ee5fbf2 ]

Module alias "spi:93xx46" is used by non device tree users like
drivers/misc/eeprom/digsy_mtc_eeprom.c  and removing it will
break support for them.

Fix this by adding back the module alias "spi:93xx46".

Fixes: 13613a2246bf ("misc: eeprom_93xx46: Fix module alias to enable module autoprobe")
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Link: https://lore.kernel.org/r/20210113051253.15061-1-a-govindraju@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/eeprom_93xx46.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/eeprom/eeprom_93xx46.c b/drivers/misc/eeprom/eeprom_93xx46.c
index 206d920dc92fc..d92c4d2c521a3 100644
--- a/drivers/misc/eeprom/eeprom_93xx46.c
+++ b/drivers/misc/eeprom/eeprom_93xx46.c
@@ -511,4 +511,5 @@ module_spi_driver(eeprom_93xx46_driver);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Driver for 93xx46 EEPROMs");
 MODULE_AUTHOR("Anatolij Gustschin <agust@denx.de>");
+MODULE_ALIAS("spi:93xx46");
 MODULE_ALIAS("spi:eeprom-93xx46");
-- 
2.27.0



