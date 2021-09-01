Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F103FD9BF
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 14:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244360AbhIAM2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:28:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244366AbhIAM2k (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:28:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB2F161027;
        Wed,  1 Sep 2021 12:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499264;
        bh=0lkcn9p9HBPmvxNCo+5s2y6YRdg49KcGtWZEOvL2L5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VczSjkd9frS7aYUNQIE1HoHQ2+iClhZNS+XIfBTWzUwWTsORrX4Rx+yK1DHLyj779
         9R/Ui364T7sPXOggguYq5ut5HjVvz9UlkW/LY/lFWZKT0kTQG+b+/5Q/yUur/Q1fsu
         BZJjMG2R0qXn7PNALQ1fOtXCs9xC6pkpfyR83Aw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kiselev <bigunclemax@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 09/16] net: marvell: fix MVNETA_TX_IN_PRGRS bit number
Date:   Wed,  1 Sep 2021 14:26:35 +0200
Message-Id: <20210901122249.214441660@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122248.920548099@linuxfoundation.org>
References: <20210901122248.920548099@linuxfoundation.org>
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
index bb6bc84995a2..ccacdcfb5932 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -100,7 +100,7 @@
 #define      MVNETA_DESC_SWAP                    BIT(6)
 #define      MVNETA_TX_BRST_SZ_MASK(burst)       ((burst) << 22)
 #define MVNETA_PORT_STATUS                       0x2444
-#define      MVNETA_TX_IN_PRGRS                  BIT(1)
+#define      MVNETA_TX_IN_PRGRS                  BIT(0)
 #define      MVNETA_TX_FIFO_EMPTY                BIT(8)
 #define MVNETA_RX_MIN_FRAME_SIZE                 0x247c
 #define MVNETA_SERDES_CFG			 0x24A0
-- 
2.30.2



