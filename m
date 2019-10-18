Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E147EDD1EA
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732293AbfJRWHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732275AbfJRWHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:07:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38DDF22468;
        Fri, 18 Oct 2019 22:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436420;
        bh=aCSTbAXnQHzJmonbmjRU/TNSmpSmUo2JY9jr4+RSpH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UGGcueTAINxrjRjROzRRfHKy289JVCfrgJpcEvGesZ6FnpQk2/hXLZy+QyEvRF9W8
         8WLh1bEp0SgDTamqvIrjB7wM1K3CFEyeBa70uvjlTdQ7dFXhxZrP4KvwqMD0Q6T0GO
         JmurC0sFVW/Zp8Cy/lzY7tRSvhQUPwglzyWmhBPs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 063/100] crypto: arm/aes-ce - add dependency on AES library
Date:   Fri, 18 Oct 2019 18:04:48 -0400
Message-Id: <20191018220525.9042-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

[ Upstream commit f703964fc66804e6049f2670fc11045aa8359b1a ]

The ARM accelerated AES driver depends on the new AES library for
its non-SIMD fallback so express this in its Kconfig declaration.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index b8e69fe282b8d..44278f375ae23 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -89,6 +89,7 @@ config CRYPTO_AES_ARM_CE
 	tristate "Accelerated AES using ARMv8 Crypto Extensions"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_LIB_AES
 	select CRYPTO_SIMD
 	help
 	  Use an implementation of AES in CBC, CTR and XTS modes that uses
-- 
2.20.1

