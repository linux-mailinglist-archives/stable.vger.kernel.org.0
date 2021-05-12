Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA65737C497
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbhELPcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235479AbhELP2K (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:28:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C6AF617C9;
        Wed, 12 May 2021 15:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832390;
        bh=6lsWD2I7fGEiNV/RJ6NBeRaICBlgLVSzILNr2actdeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qwacaxjoasd5qyCpWOEVPhLx6s8DaB0X3Wn9rh/32OzFRvq9Qz2qwiLRcxnqCOimB
         40u5ce+gjJft1Sd0L1aZCAag1N5DQrHpX0s8QGMxBeTE8GPQHgsNI2ZHfUW4hHlDVb
         ZvpTxT4TVWR1EGfqAD5LDSSiXdc7XF8gESqqscxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 226/530] crypto: allwinner - add missing CRYPTO_ prefix
Date:   Wed, 12 May 2021 16:45:36 +0200
Message-Id: <20210512144827.258315385@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index 0cdfe0e8cc66..ce34048d0d68 100644
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



