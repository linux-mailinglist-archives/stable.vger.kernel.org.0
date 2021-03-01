Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2363328475
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhCAQgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:36:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:36960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231710AbhCAQaI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:30:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A1B664F50;
        Mon,  1 Mar 2021 16:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615828;
        bh=1fbJrKp+jZiH4r4kB4gqbtf/daeGz47fYBJ1PM/YFUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZ+vyF2CJ53GbHjLmzVML6tjU+bMIXI0u5nRmQNWoGkAdFvQw7+RFAn52rsmFS5g8
         3/2hi+N7chZfFFyPUPayvT16Nx24j4CiYcAZfAeEhQ+Q60Xs6or3rpPq3cj3OAIaIF
         iS+Nm4/n9zwj386UOdS4h5f8C0r2PTISa8SD+tfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 075/134] misc: eeprom_93xx46: Add module alias to avoid breaking support for non device tree users
Date:   Mon,  1 Mar 2021 17:12:56 +0100
Message-Id: <20210301161017.252829723@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
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
index 275906b37eb89..d30deee1effda 100644
--- a/drivers/misc/eeprom/eeprom_93xx46.c
+++ b/drivers/misc/eeprom/eeprom_93xx46.c
@@ -532,4 +532,5 @@ module_spi_driver(eeprom_93xx46_driver);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Driver for 93xx46 EEPROMs");
 MODULE_AUTHOR("Anatolij Gustschin <agust@denx.de>");
+MODULE_ALIAS("spi:93xx46");
 MODULE_ALIAS("spi:eeprom-93xx46");
-- 
2.27.0



