Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9AA429152
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242335AbhJKORX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:17:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244367AbhJKOPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:15:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4475761356;
        Mon, 11 Oct 2021 14:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961112;
        bh=1Gbx6fsPMq0Zh33VWR0PPSXpKSZSHF2Fi7f9ZTfARBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLSv52/jpt1A1f0qTxgzbM0smYrb55j/gTcDW6S/r7PFTPAkKZ7M9xOwIOFk4O/lh
         6uCvoaD14A8n4bJBbObEel45WQmUEuiIJRRUOluH8UQyv+bSGxW6x4xfpqsF8bK9fo
         F7P741YhQl2W5HJMqUfw1v+kwxMwk4+F91IHb5y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/28] net: sfp: Fix typo in state machine debug string
Date:   Mon, 11 Oct 2021 15:47:10 +0200
Message-Id: <20211011134641.356657572@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134640.711218469@linuxfoundation.org>
References: <20211011134640.711218469@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Anderson <sean.anderson@seco.com>

[ Upstream commit 25a9da6641f1f66006e93ddbefee13a437efa8c0 ]

The string should be "tx_disable" to match the state enum.

Fixes: 4005a7cb4f55 ("net: phy: sftp: print debug message with text, not numbers")
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 47d518e6d5d4..71bafc8f5ed0 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -113,7 +113,7 @@ static const char * const sm_state_strings[] = {
 	[SFP_S_LINK_UP] = "link_up",
 	[SFP_S_TX_FAULT] = "tx_fault",
 	[SFP_S_REINIT] = "reinit",
-	[SFP_S_TX_DISABLE] = "rx_disable",
+	[SFP_S_TX_DISABLE] = "tx_disable",
 };
 
 static const char *sm_state_to_str(unsigned short sm_state)
-- 
2.33.0



