Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 729E7137D35
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 10:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbgAKJyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:54:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728868AbgAKJyp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:54:45 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E06A2077C;
        Sat, 11 Jan 2020 09:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736485;
        bh=qP6wAILzhbdBxme3nfpCR6FxBQ980w+RpCK5piHz7pQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0DOEjsBh/1gbQWRsE6JTKRS8Lt+nYx/B0BjOyxWJw0ou0rS719l0lSNl9y5VdGsr
         zAJW0lZWcSvMxmqR7uUHNoeD4hABQjHhFB8yvwKOM1X1c6HP3SiBumP5qsyU8ldd/0
         rLPPDAi4QkKSqHZWA7Jb91R3dkDhkHhizmrnr/mQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Birsan <cristian.birsan@microchip.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 42/59] net: usb: lan78xx: Fix error message format specifier
Date:   Sat, 11 Jan 2020 10:49:51 +0100
Message-Id: <20200111094846.522658425@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
References: <20200111094835.417654274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Birsan <cristian.birsan@microchip.com>

[ Upstream commit 858ce8ca62ea1530f2779d0e3f934b0176e663c3 ]

Display the return code as decimal integer.

Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
Signed-off-by: Cristian Birsan <cristian.birsan@microchip.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index c813c5345a52..2340c61073de 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -370,7 +370,7 @@ static int lan78xx_read_stats(struct lan78xx_net *dev,
 		}
 	} else {
 		netdev_warn(dev->net,
-			    "Failed to read stat ret = 0x%x", ret);
+			    "Failed to read stat ret = %d", ret);
 	}
 
 	kfree(stats);
-- 
2.20.1



