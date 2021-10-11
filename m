Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A6C428F5F
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237608AbhJKN54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237635AbhJKN4D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:56:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5EBD60C49;
        Mon, 11 Oct 2021 13:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960400;
        bh=jAz0QDhi7uwy6GomUW3C5wwwc48GcIieJyzK9BUlaGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abS5ZO+sDCwp3NO1q0/4W3i560UB4+24Lc4y5it2z3o3tLst+HO7dgASbnqOIoguP
         pDLSKQqvBYmDEptUY21txlrZ+1FwtXepjx65iVEjvcBmsq0SRaVyvAJVvFY6idjmS0
         2H2GD3SFZns8Y3wJDQE5kTR0Y0m0su0h22P1o2qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 50/83] net: sfp: Fix typo in state machine debug string
Date:   Mon, 11 Oct 2021 15:46:10 +0200
Message-Id: <20211011134510.123820625@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
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
index 2fff62695455..32c34c728c7a 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -133,7 +133,7 @@ static const char * const sm_state_strings[] = {
 	[SFP_S_LINK_UP] = "link_up",
 	[SFP_S_TX_FAULT] = "tx_fault",
 	[SFP_S_REINIT] = "reinit",
-	[SFP_S_TX_DISABLE] = "rx_disable",
+	[SFP_S_TX_DISABLE] = "tx_disable",
 };
 
 static const char *sm_state_to_str(unsigned short sm_state)
-- 
2.33.0



