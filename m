Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEBE36AE8A
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhDZHpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233538AbhDZHoG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:44:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61524613CF;
        Mon, 26 Apr 2021 07:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422820;
        bh=fRKMYZvYhGVmJMK3RmuKLhM0C0YEvl0xVllUaPM6n1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJgt5rlLtqdIGM/Yz3t9fkZrasTXg+m4J8iohU7bbzDyAAd/XK/Oq1UwXQ6w9wLZT
         nIexKDkRTMxRgAyP6y1IQJnVVeN5E6rZaR1LWVMqK3/fQWr/aBagIiMnGAolvEp0MX
         EemAS8B51Fu4+yTPT2ZYx0uGFv2bJqVcxr3naqXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wan Jiabing <wanjiabing@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/36] cavium/liquidio: Fix duplicate argument
Date:   Mon, 26 Apr 2021 09:30:13 +0200
Message-Id: <20210426072819.842374271@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072818.777662399@linuxfoundation.org>
References: <20210426072818.777662399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wan Jiabing <wanjiabing@vivo.com>

[ Upstream commit 416dcc5ce9d2a810477171c62ffa061a98f87367 ]

Fix the following coccicheck warning:

./drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h:413:6-28:
duplicated argument to & or |

The CN6XXX_INTR_M1UPB0_ERR here is duplicate.
Here should be CN6XXX_INTR_M1UNB0_ERR.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h b/drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h
index b248966837b4..7aad40b2aa73 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h
+++ b/drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h
@@ -412,7 +412,7 @@
 	   | CN6XXX_INTR_M0UNWI_ERR             \
 	   | CN6XXX_INTR_M1UPB0_ERR             \
 	   | CN6XXX_INTR_M1UPWI_ERR             \
-	   | CN6XXX_INTR_M1UPB0_ERR             \
+	   | CN6XXX_INTR_M1UNB0_ERR             \
 	   | CN6XXX_INTR_M1UNWI_ERR             \
 	   | CN6XXX_INTR_INSTR_DB_OF_ERR        \
 	   | CN6XXX_INTR_SLIST_DB_OF_ERR        \
-- 
2.30.2



