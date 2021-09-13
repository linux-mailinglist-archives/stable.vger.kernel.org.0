Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965BC40912E
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343876AbhIMN7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343686AbhIMN4o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:56:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A00F619E5;
        Mon, 13 Sep 2021 13:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540167;
        bh=Sb8lbuMfS9MD3trjtxUHze8qnCxnpnEbJ1LFxhHHmys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZyRJVssaL3PR52v1ZVyIiotkmt3MJ8W1coYD78yQeI3MvSWbZPwsvr7EUalNTt+1
         EeUl7rfyR4FtG02rjnLt8Ir1dmdXN+YJ4oUClUJ29DLKaImxwgL8SYJBxQyEk44W58
         vem+Vk+00SHDt7pin0/bApRcf3Z06Tvtvf122yiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 079/300] crypto: rmd320 - remove rmd320 in Makefile
Date:   Mon, 13 Sep 2021 15:12:20 +0200
Message-Id: <20210913131112.030623766@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit ff1469a21df5a2e981dd2f78e96e412fecb3ba59 ]

Commit 93f64202926f ("crypto: rmd320 - remove RIPE-MD 320 hash algorithm")
removes the Kconfig and code, but misses to adjust the Makefile.

Hence, ./scripts/checkkconfigsymbols.py warns:

CRYPTO_RMD320
Referencing files: crypto/Makefile

Remove the missing piece of this code removal.

Fixes: 93f64202926f ("crypto: rmd320 - remove RIPE-MD 320 hash algorithm")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 10526d4559b8..c633f15a0481 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -74,7 +74,6 @@ obj-$(CONFIG_CRYPTO_NULL2) += crypto_null.o
 obj-$(CONFIG_CRYPTO_MD4) += md4.o
 obj-$(CONFIG_CRYPTO_MD5) += md5.o
 obj-$(CONFIG_CRYPTO_RMD160) += rmd160.o
-obj-$(CONFIG_CRYPTO_RMD320) += rmd320.o
 obj-$(CONFIG_CRYPTO_SHA1) += sha1_generic.o
 obj-$(CONFIG_CRYPTO_SHA256) += sha256_generic.o
 obj-$(CONFIG_CRYPTO_SHA512) += sha512_generic.o
-- 
2.30.2



