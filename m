Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F07D32909E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbhCAULb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:11:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242285AbhCAT5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:57:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B668265381;
        Mon,  1 Mar 2021 17:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621344;
        bh=0CKkUiDriWAC0w6++OGrKVmH23JaGJ3QDThEO9jZUO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ikuaN5RJ5SnNxjMvyauzx15gREQo82KomytfV3x7mngt5GUNN5fN/cYIB9GzT+dM
         eV1m1oM8Vp2cfOCMKzIpUp41a3zkhUrgCS+PcJRXyuRLAGJs7SAqgaKOYRcEXXItHT
         H4sl74+6xTmmDdogxveWnWxqz1dRsggJG9AfKGqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 481/775] misc: eeprom_93xx46: Add module alias to avoid breaking support for non device tree users
Date:   Mon,  1 Mar 2021 17:10:49 +0100
Message-Id: <20210301161225.302028036@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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



