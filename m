Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88CD55AED38
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241339AbiIFOM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241625AbiIFOKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:10:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB14975FE7;
        Tue,  6 Sep 2022 06:47:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAC53B818CB;
        Tue,  6 Sep 2022 13:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5AEC433D6;
        Tue,  6 Sep 2022 13:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471948;
        bh=WarHr6PGpY/oggEoSrmC5TxyDPqN9BSsEOcsJorSc8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qL26zKdbeyAujJ4ALJrJkcrd46NRdEFDyz0UAlljtgmMKGhTnynoVL3O9iEbQWSDv
         zzfWACEWy2VrS6OQxp8COmgUI3W9JAnByYLwO3SfePwqNdg1CMbJQ/2jwADnXvdQFg
         j9/eULWO21/fJUUaWt2tkk0gItQ5y1RTShO5XI8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Ivan T. Ivanov" <iivanov@suse.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 094/155] clk: bcm: rpi: Add missing newline
Date:   Tue,  6 Sep 2022 15:30:42 +0200
Message-Id: <20220906132833.438614077@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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
 drivers/clk/bcm/clk-raspberrypi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/bcm/clk-raspberrypi.c b/drivers/clk/bcm/clk-raspberrypi.c
index e495f5f382ab9..4df921d1e21ca 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -220,7 +220,7 @@ static int raspberrypi_fw_set_rate(struct clk_hw *hw, unsigned long rate,
 	ret = raspberrypi_clock_property(rpi->firmware, data,
 					 RPI_FIRMWARE_SET_CLOCK_RATE, &_rate);
 	if (ret)
-		dev_err_ratelimited(rpi->dev, "Failed to change %s frequency: %d",
+		dev_err_ratelimited(rpi->dev, "Failed to change %s frequency: %d\n",
 				    clk_hw_get_name(hw), ret);
 
 	return ret;
@@ -288,7 +288,7 @@ static struct clk_hw *raspberrypi_clk_register(struct raspberrypi_clk *rpi,
 					 RPI_FIRMWARE_GET_MIN_CLOCK_RATE,
 					 &min_rate);
 	if (ret) {
-		dev_err(rpi->dev, "Failed to get clock %d min freq: %d",
+		dev_err(rpi->dev, "Failed to get clock %d min freq: %d\n",
 			id, ret);
 		return ERR_PTR(ret);
 	}
@@ -365,7 +365,7 @@ static int raspberrypi_discover_clocks(struct raspberrypi_clk *rpi,
 		struct raspberrypi_clk_variant *variant;
 
 		if (clks->id > RPI_FIRMWARE_NUM_CLK_ID) {
-			dev_err(rpi->dev, "Unknown clock id: %u", clks->id);
+			dev_err(rpi->dev, "Unknown clock id: %u\n", clks->id);
 			return -EINVAL;
 		}
 
-- 
2.35.1



