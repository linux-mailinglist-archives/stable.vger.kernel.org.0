Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 179174B4C31
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348254AbiBNKht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:37:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349615AbiBNKgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:36:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C38A41A2;
        Mon, 14 Feb 2022 02:02:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DB3760B31;
        Mon, 14 Feb 2022 10:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367D5C340E9;
        Mon, 14 Feb 2022 10:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832966;
        bh=lUg6UgIUo1yE4iHE1a1K4H9EBvuK+VqmJ7QfNaWBFas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0TxgY2Jyl5ZVkEyBKyRJH9ti72TThmy965Y5VKM9JC+ZtHsZ99mcN9JLyMx60S6Mc
         Xj2ZqAhJ4YZhmsFctpN/xmbMGeGzaTb1sAPz9n0Ct6Ts0QV7CdaqvFT06C9qIoac93
         WjUFinVYAy0am6vqKGRW66E6Z7+N0EFUHWB1wrGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Andrew Lunn <andrew@lunn.ch>, Andrew Jeffery <andrew@aj.id.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 149/203] net: mdio: aspeed: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 14 Feb 2022 10:26:33 +0100
Message-Id: <20220214092515.309426817@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit bc1c3c3b10db4f37c41e6107751a8d450d9c431c ]

Fix loading of the driver when built as a module.

Fixes: f160e99462c6 ("net: phy: Add mdio-aspeed")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Andrew Jeffery <andrew@aj.id.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-aspeed.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
index 966c3b4ad59d1..e2273588c75b6 100644
--- a/drivers/net/mdio/mdio-aspeed.c
+++ b/drivers/net/mdio/mdio-aspeed.c
@@ -148,6 +148,7 @@ static const struct of_device_id aspeed_mdio_of_match[] = {
 	{ .compatible = "aspeed,ast2600-mdio", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, aspeed_mdio_of_match);
 
 static struct platform_driver aspeed_mdio_driver = {
 	.driver = {
-- 
2.34.1



