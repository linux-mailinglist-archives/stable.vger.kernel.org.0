Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9C2328C34
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240055AbhCASql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:46:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234762AbhCASjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:39:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B164651D0;
        Mon,  1 Mar 2021 17:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619044;
        bh=P2+lfdkn8hMJBSDQkhdOr0cwDgsXFORUZGJ3xAg5pKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3IzZKZFyiw1jX7O8rK/+zEQbuamC3A3nt0r2vssn4DCL2tv12TDGwawG6QbB2Pf5
         qX4x7Baa7XfaARJRn3HbzBePLyGe+qTn5HgLRzQ8l4eoSmEr5fl7hyuvDgpz0haRcx
         BFqYyiALMOtmEzLD1+1VryxTm5VUBPHKXTxux9HM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 294/663] power: reset: at91-sama5d2_shdwc: fix wkupdbc mask
Date:   Mon,  1 Mar 2021 17:09:02 +0100
Message-Id: <20210301161156.381486938@linuxfoundation.org>
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



