Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D5E3BB11E
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbhGDXKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232135AbhGDXKD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:10:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EA9B613F1;
        Sun,  4 Jul 2021 23:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440038;
        bh=k6FFS/KA2Q+CKN1NE/2N+LNS14D2bJG97qZEbgZw+dQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQrRbOn9fTMl1p78Iem2abPI6Zpg12mp0ans5mpH9exQcYPNDSIwVHWoecVK54/lK
         aTFexB87Jv1rLr0petFhK73oHVHouGfIwWbxiBsnDsEYHVddRg248CQKB7zlEUA54/
         WkGV6rFwlVPtOtcIHe3sOHHSVrEAwlgZTuAqz4zdXpVv9fyTjFC9cHGW6Y26HG1ZPz
         3K1bZUM8XB+MIVkghlDfbb+G61sGgJ1XlXq1SrI7nllWqMpXAn9gUiV/xSqEe5b1rs
         XgkxbkSkw9bBAyWL/qnTjBlfWvFG8BFVNcFvPbvR9MfJbjdrIzKn2U4M+W+eM/XLdi
         4cLBIGyo4+DNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Ye <yekai13@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 45/80] crypto: hisilicon/sec - fixup 3des minimum key size declaration
Date:   Sun,  4 Jul 2021 19:05:41 -0400
Message-Id: <20210704230616.1489200-45-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
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
index 8adcbb327126..c86b01abd0a6 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1513,11 +1513,11 @@ static struct skcipher_alg sec_skciphers[] = {
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

