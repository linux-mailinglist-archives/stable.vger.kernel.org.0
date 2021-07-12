Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19A63C4C5A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240216AbhGLHD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:03:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241864AbhGLHDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:03:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D94E6113E;
        Mon, 12 Jul 2021 07:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073211;
        bh=k6FFS/KA2Q+CKN1NE/2N+LNS14D2bJG97qZEbgZw+dQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbtAHKvPo9QyuD8hMfsG4lWCyM2UIC9hxg51qu0Q5MJ5wFgDHfUiSit2owcsXKW2p
         WZojzxzJh92eWZaIWTttn50LIbku71WXD/or/hpDdIEuqZ1eFa6f5fUursmVlp8NLt
         05hHRPqM/CC4qOcqPyNCv9Pk+JVeXmkstfDB5V4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai Ye <yekai13@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 162/700] crypto: hisilicon/sec - fixup 3des minimum key size declaration
Date:   Mon, 12 Jul 2021 08:04:05 +0200
Message-Id: <20210712060948.522563918@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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



