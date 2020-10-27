Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F4129B9BD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802771AbgJ0PvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:51:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802001AbgJ0PpV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:45:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ECE922265;
        Tue, 27 Oct 2020 15:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813521;
        bh=mXlfEoOKvOoOf0/qxN5r3Z0mJdTrnEpMoaKhFUsxWcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+ItEi+zVVJ+PlAToBJutQi3Odj+ug8LHX3vAJG6utqZWvjTY677y7+kOykWASMLO
         0gPXQ4zMSk3nFQ74EftCsCSLzndHU1VXQdh5x83cbRFb4tb3ludlXY4ioWi4RXgnFk
         B0kaTXKOK71fMsAK9ERSqTcYDMT1+j6jo4YEJQKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 548/757] clk: at91: sam9x60: support only two programmable clocks
Date:   Tue, 27 Oct 2020 14:53:18 +0100
Message-Id: <20201027135516.200143972@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit fcedb589b5a88d73d3155c4a8690d6dda91a3156 ]

According to datasheet (Chapter 29.16.13, PMC Programmable Clock Register)
there are only two programmable clocks on SAM9X60.

Fixes: 01e2113de9a5 ("clk: at91: add sam9x60 pmc driver")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/1602686072-28296-1-git-send-email-claudiu.beznea@microchip.com
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/sam9x60.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/at91/sam9x60.c b/drivers/clk/at91/sam9x60.c
index ab6318c0589e9..3c4c956035954 100644
--- a/drivers/clk/at91/sam9x60.c
+++ b/drivers/clk/at91/sam9x60.c
@@ -279,7 +279,7 @@ static void __init sam9x60_pmc_setup(struct device_node *np)
 	parent_names[3] = "masterck";
 	parent_names[4] = "pllack_divck";
 	parent_names[5] = "upllck_divck";
-	for (i = 0; i < 8; i++) {
+	for (i = 0; i < 2; i++) {
 		char name[6];
 
 		snprintf(name, sizeof(name), "prog%d", i);
-- 
2.25.1



