Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51659B863F
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393988AbfISWUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393986AbfISWUL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:20:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACBB5217D6;
        Thu, 19 Sep 2019 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931611;
        bh=1uYRIa9dJFLkZU1QyZXcVGUl/P1dDHw2UzJHa6GuqiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Du1aQhWoqFsvtwe/Rem77cWn8jF5LV//kYGQwv1nzNEP3HLcDbUIDo/RcTpdkOgKb
         dYRfWrrZuPBMaGHKDq1N58GA1adTdcmcELdYYnvtpMAF4+D0o+41pFWem0ktjW/NF0
         bSpYk5jxfNAWXPgYjcB89lyaU4u6z07Ls0PEIQAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 50/74] Kconfig: Fix the reference to the IDT77105 Phy driver in the description of ATM_NICSTAR_USE_IDT77105
Date:   Fri, 20 Sep 2019 00:04:03 +0200
Message-Id: <20190919214809.659324425@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
References: <20190919214800.519074117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit cd9d4ff9b78fcd0fc4708900ba3e52e71e1a7690 ]

This should be IDT77105, not IDT77015.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/Kconfig b/drivers/atm/Kconfig
index 31c60101a69a4..7fa840170151b 100644
--- a/drivers/atm/Kconfig
+++ b/drivers/atm/Kconfig
@@ -199,7 +199,7 @@ config ATM_NICSTAR_USE_SUNI
 	  make the card work).
 
 config ATM_NICSTAR_USE_IDT77105
-	bool "Use IDT77015 PHY driver (25Mbps)"
+	bool "Use IDT77105 PHY driver (25Mbps)"
 	depends on ATM_NICSTAR
 	help
 	  Support for the PHYsical layer chip in ForeRunner LE25 cards. In
-- 
2.20.1



