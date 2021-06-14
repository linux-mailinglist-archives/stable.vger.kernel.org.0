Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5A03A6287
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhFNLBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234828AbhFNK7R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:59:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2213E6142F;
        Mon, 14 Jun 2021 10:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667339;
        bh=sqob/9gAvgLS5yP52CmR/Jxa1TU4Yw2R3RZ2tNKUKAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N1YgFgCeNTpBkDykcWz2Xe4dIvBNDo3E9GwIj3QwRZk2Nnz9dqhfmjGb529EQs2K7
         NIz5+caBKCJxvBoRc+55x1LNq/LYjnX0/gBb6u40nUYIKl7a8eu9QzYwZ7XxeJW/DI
         aYZl0s8GGxZp0H7jLmf60lusFGdhqPj0M1KFelXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/131] net: dsa: microchip: enable phy errata workaround on 9567
Date:   Mon, 14 Jun 2021 12:26:33 +0200
Message-Id: <20210614102654.101065442@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
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
index abfd3802bb51..b3aa99eb6c2c 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1532,6 +1532,7 @@ static const struct ksz_chip_data ksz9477_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.phy_errata_9477 = true,
 	},
 };
 
-- 
2.30.2



