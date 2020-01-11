Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12028138063
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730777AbgAKK24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:28:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731321AbgAKK2z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:28:55 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FC2E20842;
        Sat, 11 Jan 2020 10:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738535;
        bh=X+Ebr00IaI3qLwvQu4pO4xc+Xvp9x6957Zo4dXEN+6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uG7s4teWMg9yLUrl8XV8lj5ln97c9HVQA4DW29+3+ni2LrPxXsEb2JUiZK6EeC+yf
         KP7fvxEoQM88CBhYH1Y+6w/vyflRQBlFqqG/dCIluuy9Haw9xH9oZxHtqMPH0Iv+3L
         bSJ4crpx+1XNtMej7rJ8gKLR1kh1awNx7Y13prPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Birsan <cristian.birsan@microchip.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/165] net: usb: lan78xx: Fix error message format specifier
Date:   Sat, 11 Jan 2020 10:50:05 +0100
Message-Id: <20200111094928.355598363@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
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
index 0becc79fd431..e3cdfdde2265 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -511,7 +511,7 @@ static int lan78xx_read_stats(struct lan78xx_net *dev,
 		}
 	} else {
 		netdev_warn(dev->net,
-			    "Failed to read stat ret = 0x%x", ret);
+			    "Failed to read stat ret = %d", ret);
 	}
 
 	kfree(stats);
-- 
2.20.1



