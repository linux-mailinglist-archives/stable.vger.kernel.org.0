Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173096AE8FE
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjCGRUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbjCGRT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:19:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E68F8E3E3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:15:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 391E1614E1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3017BC433D2;
        Tue,  7 Mar 2023 17:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209303;
        bh=HA0Z9NQJmlhgaNpdXkmO6fiN1ugLqryGxCVie8jE0Ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXv2GvS1FGjNOzD9FtZOjM5MId34IUZQrUAC7I4VUYjB5YYYqpci8JzBTH/db4WhG
         AimMOgbFLsaTpdyFdiT/9jQMKGG89oEXnl8G8ouBDp7DygcprmXJIV2n+wnxLIcDsZ
         ByGT6hgx/wzwE0VDRPlunAzK9NBhX5Q5m6ek9KwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0175/1001] crypto: ux500 - update debug config after ux500 cryp driver removal
Date:   Tue,  7 Mar 2023 17:49:07 +0100
Message-Id: <20230307170029.529170871@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit 49bc6a7786b7d03eab6912a88d09a7991a32174e ]

Commit 453de3eb08c4 ("crypto: ux500/cryp - delete driver") removes the
config CRYPTO_DEV_UX500_CRYP, but leaves an obsolete reference in the
dependencies of config CRYPTO_DEV_UX500_DEBUG.

Remove that obsolete reference, and adjust the description while at it.

Fixes: 453de3eb08c4 ("crypto: ux500/cryp - delete driver")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ux500/Kconfig | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ux500/Kconfig b/drivers/crypto/ux500/Kconfig
index dcbd7404768f1..ac89cd2de12a1 100644
--- a/drivers/crypto/ux500/Kconfig
+++ b/drivers/crypto/ux500/Kconfig
@@ -15,8 +15,7 @@ config CRYPTO_DEV_UX500_HASH
 	  Depends on UX500/STM DMA if running in DMA mode.
 
 config CRYPTO_DEV_UX500_DEBUG
-	bool "Activate ux500 platform debug-mode for crypto and hash block"
-	depends on CRYPTO_DEV_UX500_CRYP || CRYPTO_DEV_UX500_HASH
+	bool "Activate debug-mode for UX500 crypto driver for HASH block"
+	depends on CRYPTO_DEV_UX500_HASH
 	help
-	  Say Y if you want to add debug prints to ux500_hash and
-	  ux500_cryp devices.
+	  Say Y if you want to add debug prints to ux500_hash devices.
-- 
2.39.2



