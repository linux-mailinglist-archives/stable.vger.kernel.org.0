Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C615C0309
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbiIUP6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbiIUP6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:58:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EF49FABF;
        Wed, 21 Sep 2022 08:51:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 464036314E;
        Wed, 21 Sep 2022 15:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35931C433D7;
        Wed, 21 Sep 2022 15:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775455;
        bh=APIfy+CENXuoyhydiMfxIatMOxxvZLvNCfx6BXp/sOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=puGGOvOHX8QewIIns+ZtTRW/2B32bLsRdzQMAwmNquOxJmhUrwb6mbqP02qBUp7gT
         IjwYYZ0Q59r8f8tsRdBdEkEj5uS+mv/UX7bilVDBlme0FjBcUI517veTbss0YvJhBL
         O6SR9PPjXFNSF/h3CwuPamH2VpfqBkCiJ/okZZA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Wu <michael@allwinnertech.com>,
        Samuel Holland <samuel@sholland.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/39] pinctrl: sunxi: Fix name for A100 R_PIO
Date:   Wed, 21 Sep 2022 17:46:18 +0200
Message-Id: <20220921153646.183129347@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
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

From: Michael Wu <michael@allwinnertech.com>

[ Upstream commit 76648c867c6c03b8a468d9c9222025873ecc613d ]

The name of A100 R_PIO driver should be sun50i-a100-r-pinctrl,
not sun50iw10p1-r-pinctrl.

Fixes: 473436e7647d6 ("pinctrl: sunxi: add support for the Allwinner A100 pin controller")
Signed-off-by: Michael Wu <michael@allwinnertech.com>
Acked-by: Samuel Holland <samuel@sholland.org>
Link: https://lore.kernel.org/r/20220819024541.74191-1-michael@allwinnertech.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-sun50i-a100-r.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sun50i-a100-r.c b/drivers/pinctrl/sunxi/pinctrl-sun50i-a100-r.c
index 21054fcacd34..18088f6f44b2 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sun50i-a100-r.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sun50i-a100-r.c
@@ -98,7 +98,7 @@ MODULE_DEVICE_TABLE(of, a100_r_pinctrl_match);
 static struct platform_driver a100_r_pinctrl_driver = {
 	.probe	= a100_r_pinctrl_probe,
 	.driver	= {
-		.name		= "sun50iw10p1-r-pinctrl",
+		.name		= "sun50i-a100-r-pinctrl",
 		.of_match_table	= a100_r_pinctrl_match,
 	},
 };
-- 
2.35.1



