Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1050137CC7D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240939AbhELQpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243228AbhELQg6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:36:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FF6061E14;
        Wed, 12 May 2021 16:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835284;
        bh=UkhjWy9KdcOIHVki4EooZ/8niR3cq3A/4yMJ1rCYm9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1e/Bf3rjp20bfU0Bo4tov2CWSpW3YxtyirHZcsHL0pspoQrvKhunw1gCymEmhXme
         9ga0Xd9WsgLLQ4n0Ks/ytYMb9S+axwK7Yb+KIqWku2SNLsWs9YtSiATWmcTcb98BVE
         Tbn/eSWC0FqEzh830ybrEiLgmWqeSZXPOn++Jb7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 282/677] crypto: allwinner - add missing CRYPTO_ prefix
Date:   Wed, 12 May 2021 16:45:28 +0200
Message-Id: <20210512144846.585749047@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 856fb2045656..b8e75210a0e3 100644
--- a/drivers/crypto/allwinner/Kconfig
+++ b/drivers/crypto/allwinner/Kconfig
@@ -71,10 +71,10 @@ config CRYPTO_DEV_SUN8I_CE_DEBUG
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
 
@@ -132,8 +132,8 @@ config CRYPTO_DEV_SUN8I_SS_PRNG
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



