Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE373BD525
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbhGFMTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:19:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237106AbhGFLfz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A89F961EA2;
        Tue,  6 Jul 2021 11:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570732;
        bh=HDfHPYQwwpyTICElBbarl1+e5AjEczXziSteyeJ7H24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VNAWBxFWCWxrWHSLIsVqhZnjZ5vnrWErnnrKCfSPy18WBVOWyvMKsknxsB/FpR2I/
         W7wmKhl0xIdcKESma8mGG/T0G+VtV8+k/h6Bcce17radbZekCLuYZDPLR1sD7nQKOM
         PPoGKTWIYVuDCvxzRn8xHcXRexFBmvA8IhlWXAK+1xuJJSdJJOqIWhhHdqHtb+wBF6
         fg0PgkFdsQ2LMi2/ZMpn6HPojFdc9yWcRPrK54qYmGtkuyI4tkcKabJyrcj0G5hT0A
         m6R9Qy8bGb/vATTS0PEfNqQwI7uEyugDBbWkeBTIgYTEw7ejVsYF4bT50iAzSn+zH5
         HjlP4iVnQEUSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/74] clk: renesas: r8a77995: Add ZA2 clock
Date:   Tue,  6 Jul 2021 07:24:11 -0400
Message-Id: <20210706112502.2064236-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 790c06cc5df263cdaff748670cc65958c81b0951 ]

R-Car D3 ZA2 clock is from PLL0D3 or S0,
and it can be controlled by ZA2CKCR.
It is needed for R-Car Sound, but is not used so far.
Using default settings is very enough at this point.
This patch adds it by DEF_FIXED().

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87pmxclrmy.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r8a77995-cpg-mssr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/renesas/r8a77995-cpg-mssr.c b/drivers/clk/renesas/r8a77995-cpg-mssr.c
index 962bb337f2e7..315f0d4bc420 100644
--- a/drivers/clk/renesas/r8a77995-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a77995-cpg-mssr.c
@@ -75,6 +75,7 @@ static const struct cpg_core_clk r8a77995_core_clks[] __initconst = {
 	DEF_RATE(".oco",       CLK_OCO,            8 * 1000 * 1000),
 
 	/* Core Clock Outputs */
+	DEF_FIXED("za2",       R8A77995_CLK_ZA2,   CLK_PLL0D3,     2, 1),
 	DEF_FIXED("z2",        R8A77995_CLK_Z2,    CLK_PLL0D3,     1, 1),
 	DEF_FIXED("ztr",       R8A77995_CLK_ZTR,   CLK_PLL1,       6, 1),
 	DEF_FIXED("zt",        R8A77995_CLK_ZT,    CLK_PLL1,       4, 1),
-- 
2.30.2

