Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559EB3BCF07
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbhGFL1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:27:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234980AbhGFLZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:25:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE7B761D48;
        Tue,  6 Jul 2021 11:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570360;
        bh=9PUz2JEzNqP8FPrrAIuHzZWbBfeElfuJOzxMMKfDIaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7hFEYV0HvZmGCB6Q3jUWaHhl00YLVt6aaGpi4rrfja0XhVimXPA0AnkuDLzOIv+Q
         YSTdlC+L1B2f6kCDuiDl1yyWIGJNvkq2/w3L2Sw4o7aS1sAx2hpoGUr+Wf82lInWUq
         n5jNCwh1wF4msdb2B26psfpdELUrBppNlcV7jTfMhLw6fy638sMNx/cRJkLUHL9qh9
         FdWoafBilF8orrLGyvmtGP8wz2vzmqnOuky4IC6QOjgwjybmLi7huqhEqtoyDthrmK
         /9dfyfjfH34wuXyDYbKnDhlOaiygyURzVcio3QazUJaYIdEUGkbfJvoN8NS12co73x
         K/TLHCk/RhFWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 040/160] clk: renesas: r8a77995: Add ZA2 clock
Date:   Tue,  6 Jul 2021 07:16:26 -0400
Message-Id: <20210706111827.2060499-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 9cfd00cf4e69..81c0bc1e78af 100644
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

