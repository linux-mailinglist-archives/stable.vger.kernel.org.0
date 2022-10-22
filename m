Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE676089C5
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbiJVIlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234848AbiJVIkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:40:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6812D446C;
        Sat, 22 Oct 2022 01:06:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C178A60B4D;
        Sat, 22 Oct 2022 07:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5398C4314C;
        Sat, 22 Oct 2022 07:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425304;
        bh=qv6GhL++iCfHg3FVW2VZhiZ6RiB16PZ7hQc1kPHkqT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Joqec5TSQvDMyuNv+hs4Pyc64oBftmnpyq561RLU9/ICHJKYoSfblbgdYloW9cn1K
         tonMOxp4uGB2OLr67qy89ps/IWqCuw7vWCveuaxgU9rEuOJvN/+SXsKx3KXtHj/5jp
         VlT9nhOY2FpOeisuVaRpcVtlGwQiZO9lxl9m8F5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 427/717] mtd: rawnand: intel: Remove undocumented compatible string
Date:   Sat, 22 Oct 2022 09:25:06 +0200
Message-Id: <20221022072517.324662751@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 68c02ebaa34d41063ccbbc789a352537ddc3cd8a ]

The "intel,nand-controller" compatible string is not part of the
dt-bindings. Remove it from the driver as it's not supposed to be used
without any documentation for it.

Fixes: 0b1039f016e8a3 ("mtd: rawnand: Add NAND controller support on Intel LGM SoC")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220702231227.1579176-5-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/intel-nand-controller.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/intel-nand-controller.c b/drivers/mtd/nand/raw/intel-nand-controller.c
index 3df3f32423f9..056835fd4562 100644
--- a/drivers/mtd/nand/raw/intel-nand-controller.c
+++ b/drivers/mtd/nand/raw/intel-nand-controller.c
@@ -723,7 +723,6 @@ static int ebu_nand_remove(struct platform_device *pdev)
 }
 
 static const struct of_device_id ebu_nand_match[] = {
-	{ .compatible = "intel,nand-controller" },
 	{ .compatible = "intel,lgm-ebunand" },
 	{}
 };
-- 
2.35.1



