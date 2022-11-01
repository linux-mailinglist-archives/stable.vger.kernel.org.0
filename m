Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6CE61497C
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbiKALhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbiKALhZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:37:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73D91D668;
        Tue,  1 Nov 2022 04:32:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDCC0615FA;
        Tue,  1 Nov 2022 11:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8A2C433C1;
        Tue,  1 Nov 2022 11:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302276;
        bh=Q/K3/OmSb/+pV/16sKiDrK2TMY3OM84BEbvbM1slRfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wy66OX/G9crt0+o29B0e9cm49njcW705vflEFLzaPZQYWUumpM/tTxmIjWBcx5ke9
         fm1jJFs8oY2ggLuZ79c5t+hYSUJDUNWRoq4Y5JEZ+C+aQINuz67bQI8uKPslncCfOj
         Yw9vA48xy6eV/0/jKCg7oSvq5Qed5Zw0LQOxXsUlViGB2A+UyR7+5j6MM8fZDG1Ioo
         1gzFnX0Z+J3l+Ktca5uDWEoYQ4UBTXhC/vdsi1gWVY8joM9oV1m8UAfQg17Pe+AA2Y
         D/26nGKdlNB57NzabXk3ac0SPcGmsgtg1/ft++Vwqq2SRyHMfhTdbvSjcNaL7PQ3LT
         IEF7WEeNRVfxA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Martin=20T=C5=AFma?= <martin.tuma@digiteqautomotive.com>,
        Michal Simek <michal.simek@amd.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        michal.simek@xilinx.com, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 8/8] i2c: xiic: Add platform module alias
Date:   Tue,  1 Nov 2022 07:30:57 -0400
Message-Id: <20221101113059.800777-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101113059.800777-1-sashal@kernel.org>
References: <20221101113059.800777-1-sashal@kernel.org>
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
index a48bee59dcde..c92ea6990ec6 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -884,6 +884,7 @@ static struct platform_driver xiic_i2c_driver = {
 
 module_platform_driver(xiic_i2c_driver);
 
+MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_AUTHOR("info@mocean-labs.com");
 MODULE_DESCRIPTION("Xilinx I2C bus driver");
 MODULE_LICENSE("GPL v2");
-- 
2.35.1

