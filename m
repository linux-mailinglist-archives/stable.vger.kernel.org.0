Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37CFC4B4A8A
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345603AbiBNKMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:12:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345862AbiBNKLF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:11:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762AB65412;
        Mon, 14 Feb 2022 01:50:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1132D60F65;
        Mon, 14 Feb 2022 09:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCB1C340E9;
        Mon, 14 Feb 2022 09:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832235;
        bh=lUg6UgIUo1yE4iHE1a1K4H9EBvuK+VqmJ7QfNaWBFas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=leHm6UwdViOr4upyB2+wiV3j1i6JOE4IJ3dpIzunDVpbSy5WCEpWnQvUxh242MMHY
         v19I0uzBm66kyJj9qn/weQNtGwQ3nXnnV9w7fpoLRNxor1O1jLbkx640YuWC3DJCIr
         D4PiAsCcWngnNwZPmYjnbIikAD3y+n0VwRv1Lm6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Andrew Lunn <andrew@lunn.ch>, Andrew Jeffery <andrew@aj.id.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/172] net: mdio: aspeed: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 14 Feb 2022 10:26:20 +0100
Message-Id: <20220214092510.635104407@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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



