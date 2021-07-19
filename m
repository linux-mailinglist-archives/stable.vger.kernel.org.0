Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7253CDB76
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243756AbhGSOnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:43:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244827AbhGSOlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:41:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 025E161205;
        Mon, 19 Jul 2021 15:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708085;
        bh=VRiB4e/oV2wd/QVms/CEJTexIoeWeKX66K3/aNZKRQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQmTOp7mGrZE19nFq/RgKqS3gpWjjNt//UV3S7NJF85PeNSkVo9BrnaHir59GW1vM
         +UaD4X2rjjUVSvTGQGfrqwsX3IZGFIwWXJr8QNm7iLZ64ie14vonSxtLM2lDt7YHjK
         LsaEfH7bi3rq8mvEJvHuFRyNJAefOEUV6F64RbCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 173/315] clk: renesas: r8a77995: Add ZA2 clock
Date:   Mon, 19 Jul 2021 16:51:02 +0200
Message-Id: <20210719144948.583845643@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8434d5530fb1..4a3633ebcc6b 100644
--- a/drivers/clk/renesas/r8a77995-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a77995-cpg-mssr.c
@@ -73,6 +73,7 @@ static const struct cpg_core_clk r8a77995_core_clks[] __initconst = {
 	DEF_FIXED(".sdsrc",    CLK_SDSRC,          CLK_PLL1,       2, 1),
 
 	/* Core Clock Outputs */
+	DEF_FIXED("za2",       R8A77995_CLK_ZA2,   CLK_PLL0D3,     2, 1),
 	DEF_FIXED("z2",        R8A77995_CLK_Z2,    CLK_PLL0D3,     1, 1),
 	DEF_FIXED("ztr",       R8A77995_CLK_ZTR,   CLK_PLL1,       6, 1),
 	DEF_FIXED("zt",        R8A77995_CLK_ZT,    CLK_PLL1,       4, 1),
-- 
2.30.2



