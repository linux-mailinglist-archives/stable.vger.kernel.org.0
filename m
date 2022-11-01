Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54501614976
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbiKALhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiKALhV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:37:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0474A1D650;
        Tue,  1 Nov 2022 04:32:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CBE8B81CD4;
        Tue,  1 Nov 2022 11:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0475AC43140;
        Tue,  1 Nov 2022 11:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302292;
        bh=RI5oWsf36IKFdL2Ds9xFDe1V9RldHdh6tP6+iYVvoL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thwsUi0nW2aICAacoMQFKWjYjzDd+j3xE/WxSm9u4yz4aWNDu2EzOhjbudmy5AGoD
         +qSGTp6uZoEZE944/7N/Jz0qVKo4+b10yOm+N8NICx8hQGIVpTzTSFdfzmw6jsgjiP
         J5FHjGV34NJRWg7FKorPwfA+pLmEDvwviti++Hy7rdYCYZOSHnNyRtTqERItsS+U2Z
         rBk6WajA6OB9c01F8rg+HhuC5YmhjxXb0BdADJShZllq5yFJfZ25CvVrIO1BKFStnu
         2xAMfX3GIbr/U00vI4r/QBt95y5p+HCR9i4cbzWBoX4L5SBSDxbHiAr8ix5OKejvzj
         5SnVEiGtR6HyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Martin=20T=C5=AFma?= <martin.tuma@digiteqautomotive.com>,
        Michal Simek <michal.simek@amd.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        michal.simek@xilinx.com, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 6/6] i2c: xiic: Add platform module alias
Date:   Tue,  1 Nov 2022 07:31:16 -0400
Message-Id: <20221101113118.800889-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101113118.800889-1-sashal@kernel.org>
References: <20221101113118.800889-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Tůma <martin.tuma@digiteqautomotive.com>

[ Upstream commit b8caf0a0e04583fb71e21495bef84509182227ea ]

The missing "platform" alias is required for the mgb4 v4l2 driver to load
the i2c controller driver when probing the HW.

Signed-off-by: Martin Tůma <martin.tuma@digiteqautomotive.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 52acb185a29c..03ce9b7d6456 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -893,6 +893,7 @@ static struct platform_driver xiic_i2c_driver = {
 
 module_platform_driver(xiic_i2c_driver);
 
+MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_AUTHOR("info@mocean-labs.com");
 MODULE_DESCRIPTION("Xilinx I2C bus driver");
 MODULE_LICENSE("GPL v2");
-- 
2.35.1

