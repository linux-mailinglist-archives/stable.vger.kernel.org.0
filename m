Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A89429084
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239556AbhJKOJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:09:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237698AbhJKOHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:07:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F3D360F11;
        Mon, 11 Oct 2021 14:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960842;
        bh=a5fGMIW0akIqyB//XpUFUABlfbxHyhFxFY6etl4qnYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4IgwPTBmbN45UvuN+CTKxJGDJCzk0MLdWz3xgyVWWkWgdjuJcWkO/e1FYcIFqNX4
         i00/KwFEINQo1SZLZnAQ/b9M+tHGpwDlPAvtZOmBJxxx0Tf0oZGmfxBD+jBLzlnFKY
         wyx1D/oEs6hVn7ElhiVv6kphRT21cvc9sZ7Bsipo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 091/151] net: sfp: Fix typo in state machine debug string
Date:   Mon, 11 Oct 2021 15:46:03 +0200
Message-Id: <20211011134520.775307280@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
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
index 34e90216bd2c..ab77a9f439ef 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -134,7 +134,7 @@ static const char * const sm_state_strings[] = {
 	[SFP_S_LINK_UP] = "link_up",
 	[SFP_S_TX_FAULT] = "tx_fault",
 	[SFP_S_REINIT] = "reinit",
-	[SFP_S_TX_DISABLE] = "rx_disable",
+	[SFP_S_TX_DISABLE] = "tx_disable",
 };
 
 static const char *sm_state_to_str(unsigned short sm_state)
-- 
2.33.0



