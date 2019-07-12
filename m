Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D6366DBE
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbfGLMdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:33:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729577AbfGLMdH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:33:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD4EB2166E;
        Fri, 12 Jul 2019 12:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934786;
        bh=w2Mla/p4PjybQS54QgZANvsxxpQKNbj0heX9OK1ESHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TYimfjnh2V9k3UJQegLwJ4frvue3cKKAfSnkLdQVJ0qWn6bacrkNOmo+taB3/zf9R
         m5S50QscL7OszjzYSFQuOXMeUT74LWJLXTYUbmWlWEwVvt1G6jyfhvPj4F3LmHT4nW
         0lQ4tjhDuK7yGA1+MJTINsIEh/Qqsed/0z1lUx5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.2 03/61] crypto: talitos - rename alternative AEAD algos.
Date:   Fri, 12 Jul 2019 14:19:16 +0200
Message-Id: <20190712121620.802125011@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit a1a42f84011fae6ff08441a91aefeb7febc984fc upstream.

The talitos driver has two ways to perform AEAD depending on the
HW capability. Some HW support both. It is needed to give them
different names to distingish which one it is for instance when
a test fails.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 7405c8d7ff97 ("crypto: talitos - templates for AEAD using HMAC_SNOOP_NO_AFEU")
Cc: stable@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/talitos.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2352,7 +2352,7 @@ static struct talitos_alg_template drive
 			.base = {
 				.cra_name = "authenc(hmac(sha1),cbc(aes))",
 				.cra_driver_name = "authenc-hmac-sha1-"
-						   "cbc-aes-talitos",
+						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC,
 			},
@@ -2397,7 +2397,7 @@ static struct talitos_alg_template drive
 				.cra_name = "authenc(hmac(sha1),"
 					    "cbc(des3_ede))",
 				.cra_driver_name = "authenc-hmac-sha1-"
-						   "cbc-3des-talitos",
+						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC,
 			},
@@ -2440,7 +2440,7 @@ static struct talitos_alg_template drive
 			.base = {
 				.cra_name = "authenc(hmac(sha224),cbc(aes))",
 				.cra_driver_name = "authenc-hmac-sha224-"
-						   "cbc-aes-talitos",
+						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC,
 			},
@@ -2485,7 +2485,7 @@ static struct talitos_alg_template drive
 				.cra_name = "authenc(hmac(sha224),"
 					    "cbc(des3_ede))",
 				.cra_driver_name = "authenc-hmac-sha224-"
-						   "cbc-3des-talitos",
+						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC,
 			},
@@ -2528,7 +2528,7 @@ static struct talitos_alg_template drive
 			.base = {
 				.cra_name = "authenc(hmac(sha256),cbc(aes))",
 				.cra_driver_name = "authenc-hmac-sha256-"
-						   "cbc-aes-talitos",
+						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC,
 			},
@@ -2573,7 +2573,7 @@ static struct talitos_alg_template drive
 				.cra_name = "authenc(hmac(sha256),"
 					    "cbc(des3_ede))",
 				.cra_driver_name = "authenc-hmac-sha256-"
-						   "cbc-3des-talitos",
+						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC,
 			},
@@ -2702,7 +2702,7 @@ static struct talitos_alg_template drive
 			.base = {
 				.cra_name = "authenc(hmac(md5),cbc(aes))",
 				.cra_driver_name = "authenc-hmac-md5-"
-						   "cbc-aes-talitos",
+						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC,
 			},
@@ -2745,7 +2745,7 @@ static struct talitos_alg_template drive
 			.base = {
 				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
 				.cra_driver_name = "authenc-hmac-md5-"
-						   "cbc-3des-talitos",
+						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC,
 			},


