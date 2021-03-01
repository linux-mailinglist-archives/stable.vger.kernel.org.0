Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D28E328DFF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241294AbhCATWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:22:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:43894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241332AbhCATRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:17:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2663864F5D;
        Mon,  1 Mar 2021 17:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620973;
        bh=P2+lfdkn8hMJBSDQkhdOr0cwDgsXFORUZGJ3xAg5pKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZoQw17/a565oao20sEtfr9ZG57DNGOdroquBleQhiLCshFOFtfBmGr+9UgjhvL69f
         uAvDcjND6Vdpo9KrPXcnC4wFodk4fiyf0isGJhkjUzmjrJ52AsTzHEWRnCFnwBt5dn
         6QUXOg2FtT1FBHqYo8LP0b6dBpDQ942Fw7hrYnDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 348/775] power: reset: at91-sama5d2_shdwc: fix wkupdbc mask
Date:   Mon,  1 Mar 2021 17:08:36 +0100
Message-Id: <20210301161218.820096727@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 95aa21a3f1183260db1b0395e03df5bebc5ed641 ]

According to datasheet WKUPDBC mask is b/w bits 26..24.

Fixes: f80cb48843987 ("power: reset: at91-shdwc: add new shutdown controller driver")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/at91-sama5d2_shdwc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/reset/at91-sama5d2_shdwc.c b/drivers/power/reset/at91-sama5d2_shdwc.c
index 2fe3a627cb535..d9cf91e5b06d0 100644
--- a/drivers/power/reset/at91-sama5d2_shdwc.c
+++ b/drivers/power/reset/at91-sama5d2_shdwc.c
@@ -37,7 +37,7 @@
 
 #define AT91_SHDW_MR	0x04		/* Shut Down Mode Register */
 #define AT91_SHDW_WKUPDBC_SHIFT	24
-#define AT91_SHDW_WKUPDBC_MASK	GENMASK(31, 16)
+#define AT91_SHDW_WKUPDBC_MASK	GENMASK(26, 24)
 #define AT91_SHDW_WKUPDBC(x)	(((x) << AT91_SHDW_WKUPDBC_SHIFT) \
 						& AT91_SHDW_WKUPDBC_MASK)
 
-- 
2.27.0



