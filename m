Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32FE5AEADC
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbiIFNuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239115AbiIFNtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:49:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275A81DA70;
        Tue,  6 Sep 2022 06:39:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF866B81632;
        Tue,  6 Sep 2022 13:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37191C433D6;
        Tue,  6 Sep 2022 13:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471535;
        bh=KVv4gUUYnMZjZn/wQMVT5nktF6J1T/dYM5MRmkmit04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bVX7EnB+yl+mVhBiUIPgMEFeNYD7SkKAziBz5oHTeiVgt7cOJBietI35WR6rYnCx4
         /G+vC4uvh0URr7immVBgPPu3pywk60aDMMiQYgYFoqLJt7i1md4Drg3G4/b5d/LbLb
         lxLLTOREM+5dQlIaeCVB4JtOpMcxe/8sEP3C2o58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Ivan T. Ivanov" <iivanov@suse.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/107] clk: bcm: rpi: Add missing newline
Date:   Tue,  6 Sep 2022 15:30:39 +0200
Message-Id: <20220906132824.289205911@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit 13b5cf8d6a0d4a5d289e1ed046cadc63b416db85 ]

Some log messages lacks the final newline. So add them.

Fixes: 93d2725affd6 ("clk: bcm: rpi: Discover the firmware clocks")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/20220713154953.3336-3-stefan.wahren@i2se.com
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Ivan T. Ivanov <iivanov@suse.de>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-raspberrypi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/bcm/clk-raspberrypi.c b/drivers/clk/bcm/clk-raspberrypi.c
index 834bcc256e921..56c5166f841ae 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -156,7 +156,7 @@ static int raspberrypi_fw_set_rate(struct clk_hw *hw, unsigned long rate,
 	ret = raspberrypi_clock_property(rpi->firmware, data,
 					 RPI_FIRMWARE_SET_CLOCK_RATE, &_rate);
 	if (ret)
-		dev_err_ratelimited(rpi->dev, "Failed to change %s frequency: %d",
+		dev_err_ratelimited(rpi->dev, "Failed to change %s frequency: %d\n",
 				    clk_hw_get_name(hw), ret);
 
 	return ret;
@@ -208,7 +208,7 @@ static struct clk_hw *raspberrypi_clk_register(struct raspberrypi_clk *rpi,
 					 RPI_FIRMWARE_GET_MIN_CLOCK_RATE,
 					 &min_rate);
 	if (ret) {
-		dev_err(rpi->dev, "Failed to get clock %d min freq: %d",
+		dev_err(rpi->dev, "Failed to get clock %d min freq: %d\n",
 			id, ret);
 		return ERR_PTR(ret);
 	}
-- 
2.35.1



