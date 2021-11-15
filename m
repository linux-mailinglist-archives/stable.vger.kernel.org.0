Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231B945242F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353787AbhKPBgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:36:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:46114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242427AbhKOSkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:40:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E09E63289;
        Mon, 15 Nov 2021 18:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999478;
        bh=1GVKqIUicULaHSXvC3FcNUMyGBmqNj1rjcN5UXNL2Ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hmoJHyP/a59XL5Tgzfi3XxwcYGyGZdbjaOjOi6HZyWIQSZqyJjpRZrDYFUzIvCgPO
         h/rTwB1dFczeTvqqOV2ym7DFtibfDs2Cp8z+3qSpMktUOQd1i7WVnxN2LjVPsZKQO1
         69tNtyzcEXuv+7MuZIpELtiSDdVTh/SSfM9Ke/O8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gary Bisson <bisson.gary@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 310/849] can: bittiming: can_fixup_bittiming(): change type of tseg1 and alltseg to unsigned int
Date:   Mon, 15 Nov 2021 17:56:33 +0100
Message-Id: <20211115165430.738842899@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit e346290439609a8ac67122418ca2efbad8d0a7e7 ]

All timing calculation is done with unsigned integers, so change type
of tseg1 and alltseg to unsigned int, too.

Link: https://lore.kernel.org/all/20211013130653.1513627-1-mkl@pengutronix.de
Link: https://github.com/linux-can/can-utils/pull/314
Reported-by: Gary Bisson <bisson.gary@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/bittiming.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index f49170eadd547..b1b5a82f08299 100644
--- a/drivers/net/can/dev/bittiming.c
+++ b/drivers/net/can/dev/bittiming.c
@@ -209,7 +209,7 @@ static int can_fixup_bittiming(struct net_device *dev, struct can_bittiming *bt,
 			       const struct can_bittiming_const *btc)
 {
 	struct can_priv *priv = netdev_priv(dev);
-	int tseg1, alltseg;
+	unsigned int tseg1, alltseg;
 	u64 brp64;
 
 	tseg1 = bt->prop_seg + bt->phase_seg1;
-- 
2.33.0



