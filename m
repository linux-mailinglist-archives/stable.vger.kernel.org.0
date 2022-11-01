Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D282761494E
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbiKALgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbiKALfc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:35:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A25A1CFCC;
        Tue,  1 Nov 2022 04:31:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C4D8615ED;
        Tue,  1 Nov 2022 11:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C8AC433D7;
        Tue,  1 Nov 2022 11:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302256;
        bh=NBStALmNljR8+uMJV4rH7+lAIwrVfUG1e/uawsZ6k5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6WxZF4jofb45MMjXOVauN1y471ptqyIXFYM2mjE/x3qcbKdtvIoE3jIK+JqOLrRs
         kj8wpJOyKucQWKYT7RwOAxVNxAf3G0F8Dj/UaZ9x4DaIuGykdE5mGeyjMCLGRJGvXn
         PYmybh3WKrovE3/V+d2rnuf98WHn4lxo1ntpCCsoMeeOK/ebouMxA4TF7yXGoCY8jH
         EGvnIuwUpKOaWJJiO4qjV7LwvUrP/r+AYlXewmNEgJ4IhE/fY6MX6mN8DeXzBG4aE1
         uryBBNr3yEQvdzHiD/T+J+CFwq3CibBtj/L/a+TFpwni3CwLItBNx2FNH3n/qdpQvL
         iySVQA4gacZrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Martin=20T=C5=AFma?= <martin.tuma@digiteqautomotive.com>,
        Michal Simek <michal.simek@amd.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        michal.simek@xilinx.com, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 14/14] i2c: xiic: Add platform module alias
Date:   Tue,  1 Nov 2022 07:30:10 -0400
Message-Id: <20221101113012.800271-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101113012.800271-1-sashal@kernel.org>
References: <20221101113012.800271-1-sashal@kernel.org>
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
index 8dabb6ffb1a4..3b564e68130b 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -935,6 +935,7 @@ static struct platform_driver xiic_i2c_driver = {
 
 module_platform_driver(xiic_i2c_driver);
 
+MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_AUTHOR("info@mocean-labs.com");
 MODULE_DESCRIPTION("Xilinx I2C bus driver");
 MODULE_LICENSE("GPL v2");
-- 
2.35.1

