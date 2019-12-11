Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC6811B4E5
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732680AbfLKPXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:23:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732249AbfLKPXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:23:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 553A7222C4;
        Wed, 11 Dec 2019 15:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077791;
        bh=zq/M6UOMe+CWRdrxQgWzQuOO7Bh5fIRw+WLZwbKBgbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=peTyC7Lt6FSaH0k5uCl+ByUhgEondG0TwXPa3+2FhbN+Oj0SevkmXHv33fON89Pxj
         cDIu7iz4iCQMLsj6jY4KuYeUvrbFElaA7y0glklioovbtC/fUljuJBjEby9tth2NDY
         8tkrW1xRQPK5N8WlUoWAFr2jZud5u2iHYGqVe6Sc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephen Boyd <sboyd@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 172/243] clk: renesas: r8a77995: Correct parent clock of DU
Date:   Wed, 11 Dec 2019 16:05:34 +0100
Message-Id: <20191211150350.789321920@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 515b2915ee08060ad4f6a3b3de38c5c2c5258e8b ]

According to the R-Car Gen3 Hardware Manual Rev 1.00, the parent clock
of the DU module clocks on R-Car D3 is S1D1.

Fixes: d71e851d82c6cfe5 ("clk: renesas: cpg-mssr: Add R8A77995 support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r8a77995-cpg-mssr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/renesas/r8a77995-cpg-mssr.c b/drivers/clk/renesas/r8a77995-cpg-mssr.c
index ea4cafbe6e851..9e16931e6f28a 100644
--- a/drivers/clk/renesas/r8a77995-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a77995-cpg-mssr.c
@@ -141,8 +141,8 @@ static const struct mssr_mod_clk r8a77995_mod_clks[] __initconst = {
 	DEF_MOD("vspbs",		 627,	R8A77995_CLK_S0D1),
 	DEF_MOD("ehci0",		 703,	R8A77995_CLK_S3D2),
 	DEF_MOD("hsusb",		 704,	R8A77995_CLK_S3D2),
-	DEF_MOD("du1",			 723,	R8A77995_CLK_S2D1),
-	DEF_MOD("du0",			 724,	R8A77995_CLK_S2D1),
+	DEF_MOD("du1",			 723,	R8A77995_CLK_S1D1),
+	DEF_MOD("du0",			 724,	R8A77995_CLK_S1D1),
 	DEF_MOD("lvds",			 727,	R8A77995_CLK_S2D1),
 	DEF_MOD("vin7",			 804,	R8A77995_CLK_S1D2),
 	DEF_MOD("vin6",			 805,	R8A77995_CLK_S1D2),
-- 
2.20.1



