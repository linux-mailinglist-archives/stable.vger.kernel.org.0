Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFF53BB2F8
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhGDXPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:15:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhGDXNP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:13:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9754461960;
        Sun,  4 Jul 2021 23:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440141;
        bh=EwONuDiDclzvsM2MjoctyHGHG0D1+bQenust0cxuNPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LS4fREZ8njo9A+TcWCwZ/hCNGwrQzswmbKgaCof9dVjmq3MX4K3plZd8r9VqM1R3q
         Mt2CYp+EDUeDDSF8DjKwulRN6GHSG9GSJ+AJ0suPSACBmmIX1PNzJyQWA3g7nZyGtP
         EtZAzja+ppg+QYY0wSUGL/qqu9VyBpgqEJRBOysgWOm+S4Lpo00A2eg5ozP9yT+Ppj
         ZilVB3V6u/F2SWsFhdaPbxbo64DtU1VdnMSNjCC6L9lQHS3I8Ciwtdb3PkIfKze/pZ
         frDGR8lS4BjAEgL27JnfQol30VukP3YWvQTcHGIV1sbXPGXizWmPTDe9LCu/jif7hq
         0mXbkLLti6Ktw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Ye <yekai13@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 42/70] crypto: hisilicon/sec - fixup 3des minimum key size declaration
Date:   Sun,  4 Jul 2021 19:07:35 -0400
Message-Id: <20210704230804.1490078-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Ye <yekai13@huawei.com>

[ Upstream commit 6161f40c630bd7ced5f236cd5fbabec06e47afae ]

Fixup the 3des algorithm  minimum key size declaration.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 41f1fcacb280..630dcb59ad56 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1515,11 +1515,11 @@ static struct skcipher_alg sec_skciphers[] = {
 			 AES_BLOCK_SIZE, AES_BLOCK_SIZE)
 
 	SEC_SKCIPHER_ALG("ecb(des3_ede)", sec_setkey_3des_ecb,
-			 SEC_DES3_2KEY_SIZE, SEC_DES3_3KEY_SIZE,
+			 SEC_DES3_3KEY_SIZE, SEC_DES3_3KEY_SIZE,
 			 DES3_EDE_BLOCK_SIZE, 0)
 
 	SEC_SKCIPHER_ALG("cbc(des3_ede)", sec_setkey_3des_cbc,
-			 SEC_DES3_2KEY_SIZE, SEC_DES3_3KEY_SIZE,
+			 SEC_DES3_3KEY_SIZE, SEC_DES3_3KEY_SIZE,
 			 DES3_EDE_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE)
 
 	SEC_SKCIPHER_ALG("xts(sm4)", sec_setkey_sm4_xts,
-- 
2.30.2

