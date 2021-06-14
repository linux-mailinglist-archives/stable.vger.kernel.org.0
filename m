Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106D43A63C5
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234767AbhFNLQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:16:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235756AbhFNLOp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:14:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35C6061956;
        Mon, 14 Jun 2021 10:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667769;
        bh=FkN6Rw5FRuamBtoMbv6YLtAawJtD3g5PU7GlD6qaFyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N74K24hRj2ls7d3u3RDigJx4y/ZlT5zn2+X2bOlWLCPBJ1J1ePupu4H6POF0rKnk7
         np0TurroulKbh2IRLNwGstylXIVCu6u/k6nZJTJ7EqQeR9ukKjWV5CFw7CbsRKbtHw
         gsjdNC5pEMaaFSWuNngJ927t2RprERRVnxwGLNVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 034/173] net: dsa: microchip: enable phy errata workaround on 9567
Date:   Mon, 14 Jun 2021 12:26:06 +0200
Message-Id: <20210614102659.284778902@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George McCollister <george.mccollister@gmail.com>

[ Upstream commit 8c42a49738f16af0061f9ae5c2f5a955f268d9e3 ]

Also enable phy errata workaround on 9567 since has the same errata as
the 9477 according to the manufacture's documentation.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz9477.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 55e5d479acce..854e25f43fa7 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1530,6 +1530,7 @@ static const struct ksz_chip_data ksz9477_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.phy_errata_9477 = true,
 	},
 };
 
-- 
2.30.2



