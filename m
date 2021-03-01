Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B08328913
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238989AbhCARti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:49:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:32854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238905AbhCARnv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:43:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FCD7650C8;
        Mon,  1 Mar 2021 16:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617885;
        bh=wCL9VpEWofr8LPDZntjWQClGHRlNcNjj4x289U0wR6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JbY1X0ObQ8eNLZCxc2F5HMP7JVSskIhxWAToZzHKUflNjT/0yBpl1YSjmr8jQlQY/
         T2Ao0MtjPwQ2LkRsP5647wU8WwPOrnM1Gjzm99NlKp2QXcGXLJOkl8RIDZpjT7e+J9
         53gfD0OfEGjL50l9gMKW6FnuE2kLabScZWK5MSUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 201/340] misc: eeprom_93xx46: Fix module alias to enable module autoprobe
Date:   Mon,  1 Mar 2021 17:12:25 +0100
Message-Id: <20210301161058.198510515@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index 94cfb675fe4ed..6adf979299667 100644
--- a/drivers/misc/eeprom/eeprom_93xx46.c
+++ b/drivers/misc/eeprom/eeprom_93xx46.c
@@ -510,4 +510,4 @@ module_spi_driver(eeprom_93xx46_driver);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Driver for 93xx46 EEPROMs");
 MODULE_AUTHOR("Anatolij Gustschin <agust@denx.de>");
-MODULE_ALIAS("spi:93xx46");
+MODULE_ALIAS("spi:eeprom-93xx46");
-- 
2.27.0



