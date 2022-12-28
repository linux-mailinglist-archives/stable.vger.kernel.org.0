Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C160658487
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbiL1Q54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235063AbiL1Q5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:57:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5A61DDED
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:53:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC40961563
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C06C433D2;
        Wed, 28 Dec 2022 16:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246414;
        bh=P6lOubP86MxuZA+q9UBA8Uu3tUIh58z96vk/I6b1Gt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rENsRNmXVmptJROxEHpHqyjUdJ2If2vM0mG2OAAPNl2Ekr60q7knuUEQHRYXkFU4c
         CiFonbnu0mMP+uLWrJJT3hZ2Z+Hakj7uSO8Ahvf5eiP8JhlzfLZ5x188scLoQJIZFX
         WIy5fxFybbqfiETTKel6buxZEmhCqe+sfa29xJoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.0 1068/1073] clk: renesas: r8a779f0: Fix SD0H clock name
Date:   Wed, 28 Dec 2022 15:44:16 +0100
Message-Id: <20221228144357.249657451@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 99c05a2b710f16ea592ccb63ef5fe5f1f6b15db9 upstream.

Correct the misspelled textual name of the SD0H clock.

Fixes: 9b5dd1ff705c6854 ("clk: renesas: r8a779f0: Add SDH0 clock")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/1f682d338f133608f138ae87323707436ad8c748.1665558014.git.geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/renesas/r8a779f0-cpg-mssr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/renesas/r8a779f0-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a779f0-cpg-mssr.c
@@ -113,7 +113,7 @@ static const struct cpg_core_clk r8a779f
 	DEF_FIXED("sasyncperd2", R8A779F0_CLK_SASYNCPERD2, R8A779F0_CLK_SASYNCPERD1, 2, 1),
 	DEF_FIXED("sasyncperd4", R8A779F0_CLK_SASYNCPERD4, R8A779F0_CLK_SASYNCPERD1, 4, 1),
 
-	DEF_GEN4_SDH("sdh0",	R8A779F0_CLK_SD0H,	CLK_SDSRC,	   0x870),
+	DEF_GEN4_SDH("sd0h",	R8A779F0_CLK_SD0H,	CLK_SDSRC,	   0x870),
 	DEF_GEN4_SD("sd0",	R8A779F0_CLK_SD0,	R8A779F0_CLK_SD0H, 0x870),
 
 	DEF_BASE("rpc",		R8A779F0_CLK_RPC,	CLK_TYPE_GEN4_RPC, CLK_RPCSRC),


