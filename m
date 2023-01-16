Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7824866CA64
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbjAPRCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbjAPRCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:02:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A262939B93;
        Mon, 16 Jan 2023 08:44:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F64E61086;
        Mon, 16 Jan 2023 16:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51428C433EF;
        Mon, 16 Jan 2023 16:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887454;
        bh=/uD1altzWUbvTZtvp+kt0F96PDIo8Gh6WA/oadSVZsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/UWlysV3OANtZ1sxJbRiFyE6pFlni/1QLoE/y94Ci8Z9gXpl87+Zs4j/bwDWmFcj
         542jGm7CYv6cm9HAfloqvldchVlB80yeqs9mWBop59xs8lCkDZqXbB0K3LZ5BJ4pEb
         gglRt+H5kFk7FbajOFcaox67iA2IWdTHcw9733+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dinh Nguyen <dinguyen@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-clk@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 155/521] clk: socfpga: clk-pll: Remove unused variable rc
Date:   Mon, 16 Jan 2023 16:46:57 +0100
Message-Id: <20230116154854.174598801@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Lee Jones <lee.jones@linaro.org>

[ Upstream commit 75fddccbca32349570b2d53955982b4117fa5515 ]

Fixes the following W=1 kernel build warning(s):

 drivers/clk/socfpga/clk-pll.c: In function ‘__socfpga_pll_init’:
 drivers/clk/socfpga/clk-pll.c:83:6: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]

Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: linux-clk@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20210120093040.1719407-8-lee.jones@linaro.org
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/socfpga/clk-pll.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/socfpga/clk-pll.c b/drivers/clk/socfpga/clk-pll.c
index b4b44e9b5901..973c4713d085 100644
--- a/drivers/clk/socfpga/clk-pll.c
+++ b/drivers/clk/socfpga/clk-pll.c
@@ -90,7 +90,6 @@ static __init struct clk *__socfpga_pll_init(struct device_node *node,
 	const char *parent_name[SOCFPGA_MAX_PARENTS];
 	struct clk_init_data init;
 	struct device_node *clkmgr_np;
-	int rc;
 
 	of_property_read_u32(node, "reg", &reg);
 
@@ -123,7 +122,7 @@ static __init struct clk *__socfpga_pll_init(struct device_node *node,
 		kfree(pll_clk);
 		return NULL;
 	}
-	rc = of_clk_add_provider(node, of_clk_src_simple_get, clk);
+	of_clk_add_provider(node, of_clk_src_simple_get, clk);
 	return clk;
 }
 
-- 
2.35.1



