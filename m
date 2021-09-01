Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105603FD994
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 14:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244093AbhIAM1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:27:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244103AbhIAM1l (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:27:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D8F8610CA;
        Wed,  1 Sep 2021 12:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499204;
        bh=+SeTpWH5hi/JihCWkbbktBKmfzieD5NkdIzJKObOigk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tonEDq0AjuJM/EnGBGyihVTnEAjNiH/2ZBwdjK2nZaBBJh5xthcQOdYySXT+LlqJw
         pTQspBV/Mhc2jMxyFXoDGzxad0H2wBAoAnF7nWPQZg9kS21o8jJekB8CZM3+4rTkTD
         LUNjQqVIrRYQHNmzkWqdMRHz1gazmooTPBNIp5lA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kiselev <bigunclemax@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 05/10] net: marvell: fix MVNETA_TX_IN_PRGRS bit number
Date:   Wed,  1 Sep 2021 14:26:19 +0200
Message-Id: <20210901122248.220071213@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122248.051808371@linuxfoundation.org>
References: <20210901122248.051808371@linuxfoundation.org>
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
index 575da945f151..d6b25aba4004 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -90,7 +90,7 @@
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



