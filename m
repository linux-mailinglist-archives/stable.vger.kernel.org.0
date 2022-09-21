Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40DD5C02DC
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbiIUP4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbiIUPyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:54:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4339F77A;
        Wed, 21 Sep 2022 08:50:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C665B830B1;
        Wed, 21 Sep 2022 15:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC25C433D7;
        Wed, 21 Sep 2022 15:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775377;
        bh=APIfy+CENXuoyhydiMfxIatMOxxvZLvNCfx6BXp/sOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jyXCz0Tpn0XsAD4q0SVxTI3dJy78FnHh/KZBUiG4iUmrSPMSENfDS822ucHe8zLot
         UuJLRW8YN8fKUgwsLjuLiwldGutpaJWcwd4cTP5oX8cXm88WSVg7wGy0g9UGxKt3Bz
         O0srvdVUM18t33vMf9qDqFss3/gEZGNtrh+OBW0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Wu <michael@allwinnertech.com>,
        Samuel Holland <samuel@sholland.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 09/45] pinctrl: sunxi: Fix name for A100 R_PIO
Date:   Wed, 21 Sep 2022 17:45:59 +0200
Message-Id: <20220921153647.210173201@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
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



