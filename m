Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E036356F9BF
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiGKJIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiGKJHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:07:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF00D24952;
        Mon, 11 Jul 2022 02:07:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64601B80E7D;
        Mon, 11 Jul 2022 09:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57E2C34115;
        Mon, 11 Jul 2022 09:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530449;
        bh=VtGNo2A9OFnwe6G3BOiowxmO1MwkozVOw/vTKsK1Tig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9HVi0s+Db0RT862Z6rROmaUKgszBJofuvS2CATI06woVMn6eppwYCSO8DGCS6vPc
         kJ2WJmxHcMvpR65wRAXxDb4r0iTnHBJPuZRlGEilADvp8+h+p7++IScRtDwn6Y0XKk
         6tDuxhqAlfQ3L5t2MCeJCweKY43h4a52WfVg5UyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 09/14] pinctrl: sunxi: a83t: Fix NAND function name for some pins
Date:   Mon, 11 Jul 2022 11:06:28 +0200
Message-Id: <20220711090535.795538668@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090535.517697227@linuxfoundation.org>
References: <20220711090535.517697227@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit aaefa29270d9551b604165a08406543efa9d16f5 ]

The other NAND pins on Port C use the "nand0" function name.
"nand0" also matches all of the other Allwinner SoCs.

Fixes: 4730f33f0d82 ("pinctrl: sunxi: add allwinner A83T PIO controller support")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20220526024956.49500-1-samuel@sholland.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-sun8i-a83t.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sun8i-a83t.c b/drivers/pinctrl/sunxi/pinctrl-sun8i-a83t.c
index 383977ea3a3c..0b5aba4bf338 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sun8i-a83t.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sun8i-a83t.c
@@ -158,26 +158,26 @@ static const struct sunxi_desc_pin sun8i_a83t_pins[] = {
 	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 14),
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
 		  SUNXI_FUNCTION(0x1, "gpio_out"),
-		  SUNXI_FUNCTION(0x2, "nand"),		/* DQ6 */
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQ6 */
 		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D6 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 15),
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
 		  SUNXI_FUNCTION(0x1, "gpio_out"),
-		  SUNXI_FUNCTION(0x2, "nand"),		/* DQ7 */
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQ7 */
 		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D7 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 16),
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
 		  SUNXI_FUNCTION(0x1, "gpio_out"),
-		  SUNXI_FUNCTION(0x2, "nand"),		/* DQS */
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQS */
 		  SUNXI_FUNCTION(0x3, "mmc2")),		/* RST */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 17),
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
 		  SUNXI_FUNCTION(0x1, "gpio_out"),
-		  SUNXI_FUNCTION(0x2, "nand")),		/* CE2 */
+		  SUNXI_FUNCTION(0x2, "nand0")),	/* CE2 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 18),
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
 		  SUNXI_FUNCTION(0x1, "gpio_out"),
-		  SUNXI_FUNCTION(0x2, "nand")),		/* CE3 */
+		  SUNXI_FUNCTION(0x2, "nand0")),	/* CE3 */
 	/* Hole */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 2),
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
-- 
2.35.1



