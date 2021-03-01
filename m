Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D487A328735
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238055AbhCARVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:21:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237858AbhCARNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:13:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A43864F48;
        Mon,  1 Mar 2021 16:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617077;
        bh=YFlR7b7bdDymkthAk25UG/II7awWfKQNABYkbzBdJJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4pOhsPnsGlJopmmBzU9oPlsnF7FGKUAdRsYcqVniJ9h1p76UHdbJ09dJviIX9yWV
         2RAvGycCMz5qS/mmp4MVcshpjp7220h7XMZQ9e0/Zm11MVjGbDtvyGjgDsVu/yMOGx
         10m8MzjadPDDpnwjwGR4j3/yDzpsLpkdhW64DOBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 155/247] misc: eeprom_93xx46: Add module alias to avoid breaking support for non device tree users
Date:   Mon,  1 Mar 2021 17:12:55 +0100
Message-Id: <20210301161039.252967436@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index afaa717207b37..a3248ebd28c62 100644
--- a/drivers/misc/eeprom/eeprom_93xx46.c
+++ b/drivers/misc/eeprom/eeprom_93xx46.c
@@ -522,4 +522,5 @@ module_spi_driver(eeprom_93xx46_driver);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Driver for 93xx46 EEPROMs");
 MODULE_AUTHOR("Anatolij Gustschin <agust@denx.de>");
+MODULE_ALIAS("spi:93xx46");
 MODULE_ALIAS("spi:eeprom-93xx46");
-- 
2.27.0



