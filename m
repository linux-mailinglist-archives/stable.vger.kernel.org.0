Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19AFF3FDB3C
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344040AbhIAMkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245058AbhIAMhf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:37:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 799E561101;
        Wed,  1 Sep 2021 12:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499655;
        bh=P9xrq9NQToKaw7bqwLxxXk6vk1JvEi5Df8zr29u5XyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BG4g+pHb8uosn0VVZrCzfGnOHY6TXB8AC+IJaNY+0RuwBsLVALWqnADrCsM9mI2qr
         XPwDFCSuWBd5v+J0ygpR3wSojyvk+U8glNCiLyc1C/OaYhrJNC1UPb15BJQE8IxDgT
         jpbFkoGzTEZAc8Lkxzi/Z5ryuuxyzHs9OVgfTj88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kiselev <bigunclemax@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/103] net: marvell: fix MVNETA_TX_IN_PRGRS bit number
Date:   Wed,  1 Sep 2021 14:27:45 +0200
Message-Id: <20210901122301.732910951@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Kiselev <bigunclemax@gmail.com>

[ Upstream commit 359f4cdd7d78fdf8c098713b05fee950a730f131 ]

According to Armada XP datasheet bit at 0 position is corresponding for
TxInProg indication.

Fixes: c5aff18204da ("net: mvneta: driver for Marvell Armada 370/XP network unit")
Signed-off-by: Maxim Kiselev <bigunclemax@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index c6b735b30515..74e266c0b8e1 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -103,7 +103,7 @@
 #define      MVNETA_DESC_SWAP                    BIT(6)
 #define      MVNETA_TX_BRST_SZ_MASK(burst)       ((burst) << 22)
 #define MVNETA_PORT_STATUS                       0x2444
-#define      MVNETA_TX_IN_PRGRS                  BIT(1)
+#define      MVNETA_TX_IN_PRGRS                  BIT(0)
 #define      MVNETA_TX_FIFO_EMPTY                BIT(8)
 #define MVNETA_RX_MIN_FRAME_SIZE                 0x247c
 /* Only exists on Armada XP and Armada 370 */
-- 
2.30.2



