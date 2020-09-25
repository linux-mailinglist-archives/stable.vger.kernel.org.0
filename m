Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8352787E1
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbgIYMvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:51:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729185AbgIYMvS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:51:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8371A23899;
        Fri, 25 Sep 2020 12:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038278;
        bh=N+ErJo9ydW+4jVOkbbnWBYKU0mfyroW9Z58jkwIuYRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EHyBR4Is4ADxcklbSPHCl1uLTe6gDhCXg4sdfOnxteaPjVkZiy6NLBbaDK0QuoOPc
         bzFKf6EUJNhrtlOfBzPwG9BJv4n0ue6H4g2fafuG4jO09r38BvHWMYusHRNiQ0HX0k
         zTLio/CK3CrzcJ2of+EjZZ/8dDsS46soAPGkqUa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/43] ibmvnic: add missing parenthesis in do_reset()
Date:   Fri, 25 Sep 2020 14:48:15 +0200
Message-Id: <20200925124724.031895006@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 8ae4dff882eb879c17bf46574201bd37fc6bc8b5 ]

Indentation and logic clearly show that this code is missing
parenthesis.

Fixes: 9f1345737790 ("ibmvnic fix NULL tx_pools and rx_tools issue at do_reset")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index de45b3709c14e..5329af2337a91 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1939,16 +1939,18 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 
 		} else {
 			rc = reset_tx_pools(adapter);
-			if (rc)
+			if (rc) {
 				netdev_dbg(adapter->netdev, "reset tx pools failed (%d)\n",
 						rc);
 				goto out;
+			}
 
 			rc = reset_rx_pools(adapter);
-			if (rc)
+			if (rc) {
 				netdev_dbg(adapter->netdev, "reset rx pools failed (%d)\n",
 						rc);
 				goto out;
+			}
 		}
 		ibmvnic_disable_irqs(adapter);
 	}
-- 
2.25.1



