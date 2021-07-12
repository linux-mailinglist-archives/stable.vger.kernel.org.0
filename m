Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FF93C520B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349740AbhGLHof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:44:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347568AbhGLHju (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:39:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C67A261360;
        Mon, 12 Jul 2021 07:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075297;
        bh=nSAQl4N0ksjmALGA8Vfx17EaJJ31UKUQVACEeMKFCyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpQCKCiUvxDPAmDp2/HqcPMyFtkkAkpDSjnEruzSwJgIFHrPH1mah5zkcnpOp3ojr
         hYPuZXVLNoC4hYjZUPScSRvk7yw9YRGxLEomHHEosvXIMr+zVvJNNXcDLFhPtgsJdN
         XfYc203ZyBYtdfqyQBaFlmD5NodGBqP+UnXuTUiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai Ye <yekai13@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 172/800] crypto: hisilicon/sec - fixup 3des minimum key size declaration
Date:   Mon, 12 Jul 2021 08:03:15 +0200
Message-Id: <20210712060937.152820848@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 133aede8bf07..b43fad8b9e8d 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1541,11 +1541,11 @@ static struct skcipher_alg sec_skciphers[] = {
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



