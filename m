Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901AD6583F5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235175AbiL1Qxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235179AbiL1Qww (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:52:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D1DFC4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:47:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86C24B8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97DDC433D2;
        Wed, 28 Dec 2022 16:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246071;
        bh=LTIEMs3jUwd4MNBCGFtthpNq7nlSQdLSupImvk5ZNcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfD9qmd/VlOd5hHiAuGUejebyiZdjm71yYHsG8UYPzBHXMYr1qFMXMyrC+gkLW2ou
         7z3VnX5mpNtYRt0m/XKRj0bZJNJIXsnFGJ2FkLdIOXv+3GLQ5Z3BGLloLZl3lT21u5
         8IDtSXZ6wezF5GgRUw6Dz5nl5Wt0aW2D1FKUZC3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0994/1073] clk: renesas: r8a779f0: Add SDH0 clock
Date:   Wed, 28 Dec 2022 15:43:02 +0100
Message-Id: <20221228144355.118782601@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 9b5dd1ff705c68549f7a2a91dd8beee14bc543e1 ]

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20220711134656.277730-2-wsa+renesas@sang-engineering.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: 1e56ebc9872f ("clk: renesas: r8a779f0: Add TMU and parent SASYNC clocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r8a779f0-cpg-mssr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/r8a779f0-cpg-mssr.c b/drivers/clk/renesas/r8a779f0-cpg-mssr.c
index b7936f422c27..9bd6746e6a07 100644
--- a/drivers/clk/renesas/r8a779f0-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a779f0-cpg-mssr.c
@@ -108,7 +108,8 @@ static const struct cpg_core_clk r8a779f0_core_clks[] __initconst = {
 	DEF_FIXED("cbfusa",	R8A779F0_CLK_CBFUSA,	CLK_EXTAL,	2, 1),
 	DEF_FIXED("cpex",	R8A779F0_CLK_CPEX,	CLK_EXTAL,	2, 1),
 
-	DEF_GEN4_SD("sd0",	R8A779F0_CLK_SD0,	CLK_SDSRC,	0x870),
+	DEF_GEN4_SDH("sdh0",	R8A779F0_CLK_SD0H,	CLK_SDSRC,	   0x870),
+	DEF_GEN4_SD("sd0",	R8A779F0_CLK_SD0,	R8A779F0_CLK_SD0H, 0x870),
 
 	DEF_BASE("rpc",		R8A779F0_CLK_RPC,	CLK_TYPE_GEN4_RPC, CLK_RPCSRC),
 	DEF_BASE("rpcd2",	R8A779F0_CLK_RPCD2,	CLK_TYPE_GEN4_RPCD2, R8A779F0_CLK_RPC),
-- 
2.35.1



