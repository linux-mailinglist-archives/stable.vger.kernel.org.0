Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59ED43286B0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237776AbhCARNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:13:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:37620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237430AbhCARIQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:08:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02C3764F82;
        Mon,  1 Mar 2021 16:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616863;
        bh=gGnf96rWAn+vW4HHRwWuuPkalKpOOMB+USCk1pWsxEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbHd+717AIbumLiILfXxwcjtsP9fOyNR8Hw8hbfi7vU+9avDOb34AL6VYf38PI6WF
         LbQOa1h9mISLHKdH6ySMwasLWU7YUWdfL4c+6Rxy9nC2dQc5dgpQj5eKjq2LZaQecQ
         MhOiqL4uEaWoWFLKZgtXpEdckRjoEuqB8gd3j12s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 120/247] power: reset: at91-sama5d2_shdwc: fix wkupdbc mask
Date:   Mon,  1 Mar 2021 17:12:20 +0100
Message-Id: <20210301161037.551640403@linuxfoundation.org>
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
index d9493e893d64e..7cf59e764ef28 100644
--- a/drivers/power/reset/at91-sama5d2_shdwc.c
+++ b/drivers/power/reset/at91-sama5d2_shdwc.c
@@ -36,7 +36,7 @@
 
 #define AT91_SHDW_MR	0x04		/* Shut Down Mode Register */
 #define AT91_SHDW_WKUPDBC_SHIFT	24
-#define AT91_SHDW_WKUPDBC_MASK	GENMASK(31, 16)
+#define AT91_SHDW_WKUPDBC_MASK	GENMASK(26, 24)
 #define AT91_SHDW_WKUPDBC(x)	(((x) << AT91_SHDW_WKUPDBC_SHIFT) \
 						& AT91_SHDW_WKUPDBC_MASK)
 
-- 
2.27.0



