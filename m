Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283B83283BA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237653AbhCAQX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:23:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235435AbhCAQVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:21:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54D0C64EF2;
        Mon,  1 Mar 2021 16:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615508;
        bh=OqRej/ncr0rfA9AhuUADgm9UDDDXA5bhAokqEdgSLoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCX6P3fYxPXYPxDC0j4I+5spGzCUIhabyL++nBbD5lpCDb9/8XMwXxnvFIytTlPAo
         /Kaqa8BuCHpQYBoHegf019h4FIK8VLYMYmxGr9O9Nza9aNcvm06HECGVpVyVoFlQhU
         jfnlFsMO2hZDazEc0pOYDYDXEkRtMexpw5i7Ucvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 53/93] misc: eeprom_93xx46: Fix module alias to enable module autoprobe
Date:   Mon,  1 Mar 2021 17:13:05 +0100
Message-Id: <20210301161009.507969667@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aswath Govindraju <a-govindraju@ti.com>

[ Upstream commit 13613a2246bf531f5fc04e8e62e8f21a3d39bf1c ]

Fix module autoprobe by correcting module alias to match the string from
/sys/class/.../spi1.0/modalias content.

Fixes: 06b4501e88ad ("misc/eeprom: add driver for microwire 93xx46 EEPROMs")
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Link: https://lore.kernel.org/r/20210107163957.28664-2-a-govindraju@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/eeprom_93xx46.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/eeprom/eeprom_93xx46.c b/drivers/misc/eeprom/eeprom_93xx46.c
index ff63f05edc763..15c7e3574bcb2 100644
--- a/drivers/misc/eeprom/eeprom_93xx46.c
+++ b/drivers/misc/eeprom/eeprom_93xx46.c
@@ -380,4 +380,4 @@ module_spi_driver(eeprom_93xx46_driver);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Driver for 93xx46 EEPROMs");
 MODULE_AUTHOR("Anatolij Gustschin <agust@denx.de>");
-MODULE_ALIAS("spi:93xx46");
+MODULE_ALIAS("spi:eeprom-93xx46");
-- 
2.27.0



