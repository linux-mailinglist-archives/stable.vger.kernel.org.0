Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B8D3BD4D6
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238567AbhGFMRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:17:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233767AbhGFLd1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:33:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA09461D16;
        Tue,  6 Jul 2021 11:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570570;
        bh=y8iXxVXXd/AOH5XweXyaMmgPxDeTzTqTSdSk83oT19w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NaayqTvJfKFVxd2+FmH9QUZZaMcfll/8GGx35TZtaUyQ3p45JbuaXEF08yKsKlG6f
         TOOcVk+hUJt6CGdiS8Tv0Lkke80sq0yQM7HEjKNlqcORbb8dD6wIq5GqGdmbH42OQv
         zmKMiTYr2EjZP5IY589/5GBgLSqaRk9cREOQTjP1QltU/OQViXm+VFaR719i8LLUSn
         CpwHeVAgUoRppQf22XYVxDLY5h6uIELnpHSYCRDlizQ+kZJb+KnIJ3LavbzB7LQYGY
         GHCoKPYauOZvpCpCa6J4aKnYgfSjVAps8d7nNvnHlid7bsS9K8i/azWf/pJLoGZFFn
         Ljg8/J8yfcHZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 036/137] clk: renesas: r8a77995: Add ZA2 clock
Date:   Tue,  6 Jul 2021 07:20:22 -0400
Message-Id: <20210706112203.2062605-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index 5b4691117b47..026e2612c33c 100644
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

