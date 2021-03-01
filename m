Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4BC328557
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbhCAQx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:53:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:46552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235327AbhCAQo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:44:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D472D64D73;
        Mon,  1 Mar 2021 16:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616226;
        bh=3TK0yicQuSVWNt6sQ9tEOq0iZyfjg7CppEvx3hHWzFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYsno4ygibq3ouIyNp5JIT1HcTQKY5jv23lzVkahUdj+cosLA68PQXMhWi5SIyva3
         ODSgCzNKT4UvGSfHXofrn2y5U26Rd3aLpBNlRI/BBYI9k81yedQm8fLBqxbBCL/Ors
         QJ9t5a567o6sEBKag7D0yNSciopQM+1imBfcpnVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 078/176] power: reset: at91-sama5d2_shdwc: fix wkupdbc mask
Date:   Mon,  1 Mar 2021 17:12:31 +0100
Message-Id: <20210301161024.841493761@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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
index 037976a1fe40b..c2fab93b556bb 100644
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



