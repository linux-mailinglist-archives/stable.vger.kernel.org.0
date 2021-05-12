Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DF137C8D4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbhELQNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:13:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239165AbhELQHc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC10161C46;
        Wed, 12 May 2021 15:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833796;
        bh=sAX8Qj28y672B6LgOjOJXG8TU8kiOFn5cx4W3WgI0ro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2vKZ2FTjSqQj3evthS8ehvTH5n6rHrh//ZowMwGh0gjEYWzrhLWND+ZKMvGvwBhz
         U8ovtfxKLut468fc69OqIlYWczV03U6LJj15CrmTcggL9rhtDaBdXruN97hkejUtcU
         zTafWsh6mzVeKO0ZTgKitxP0+/SOX6KmJNjAYO/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 257/601] crypto: allwinner - add missing CRYPTO_ prefix
Date:   Wed, 12 May 2021 16:45:34 +0200
Message-Id: <20210512144836.290046767@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe.montjoie@gmail.com>

[ Upstream commit ac1af1a788b2002eb9d6f5ca6054517ad27f1930 ]

Some CONFIG select miss CRYPTO_.

Reported-by: Chen-Yu Tsai <wens@csie.org>
Fixes: 56f6d5aee88d1 ("crypto: sun8i-ce - support hash algorithms")
Fixes: d9b45418a9177 ("crypto: sun8i-ss - support hash algorithms")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/Kconfig | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/allwinner/Kconfig b/drivers/crypto/allwinner/Kconfig
index 180c8a9db819..02e6855a6ed7 100644
--- a/drivers/crypto/allwinner/Kconfig
+++ b/drivers/crypto/allwinner/Kconfig
@@ -62,10 +62,10 @@ config CRYPTO_DEV_SUN8I_CE_DEBUG
 config CRYPTO_DEV_SUN8I_CE_HASH
 	bool "Enable support for hash on sun8i-ce"
 	depends on CRYPTO_DEV_SUN8I_CE
-	select MD5
-	select SHA1
-	select SHA256
-	select SHA512
+	select CRYPTO_MD5
+	select CRYPTO_SHA1
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
 	help
 	  Say y to enable support for hash algorithms.
 
@@ -123,8 +123,8 @@ config CRYPTO_DEV_SUN8I_SS_PRNG
 config CRYPTO_DEV_SUN8I_SS_HASH
 	bool "Enable support for hash on sun8i-ss"
 	depends on CRYPTO_DEV_SUN8I_SS
-	select MD5
-	select SHA1
-	select SHA256
+	select CRYPTO_MD5
+	select CRYPTO_SHA1
+	select CRYPTO_SHA256
 	help
 	  Say y to enable support for hash algorithms.
-- 
2.30.2



