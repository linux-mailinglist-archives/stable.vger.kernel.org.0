Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5B96C5BA
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390909AbfGRDI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:08:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390000AbfGRDI4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:08:56 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28376205F4;
        Thu, 18 Jul 2019 03:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419335;
        bh=tAdM5UhC7NFNTXYOntbvHjlWpTlO76HafP/8MJpomlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GEHzaiaSpDHx/2fdDSREI2bwlpVTrSjy0/b9WWkTsRPHdxuKq8VFN62GUEvL/+9bY
         Ge3eErQiOEiR0x2yVCPSh9LkcXdufW8FIBa6+4vZIMFjcFOik9nFEDkx8RWfLUtAgm
         yMexQUISfoPJF91u+6xgguCb4+hNB8/bNS4Na2bY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 06/80] crypto: talitos - rename alternative AEAD algos.
Date:   Thu, 18 Jul 2019 12:00:57 +0900
Message-Id: <20190718030059.371884139@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
References: <20190718030058.615992480@linuxfoundation.org>
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
@@ -2185,7 +2185,7 @@ static struct talitos_alg_template drive
 			.base = {
 				.cra_name = "authenc(hmac(sha1),cbc(aes))",
 				.cra_driver_name = "authenc-hmac-sha1-"
-						   "cbc-aes-talitos",
+						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC,
 			},
@@ -2229,7 +2229,7 @@ static struct talitos_alg_template drive
 				.cra_name = "authenc(hmac(sha1),"
 					    "cbc(des3_ede))",
 				.cra_driver_name = "authenc-hmac-sha1-"
-						   "cbc-3des-talitos",
+						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC,
 			},
@@ -2271,7 +2271,7 @@ static struct talitos_alg_template drive
 			.base = {
 				.cra_name = "authenc(hmac(sha224),cbc(aes))",
 				.cra_driver_name = "authenc-hmac-sha224-"
-						   "cbc-aes-talitos",
+						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC,
 			},
@@ -2315,7 +2315,7 @@ static struct talitos_alg_template drive
 				.cra_name = "authenc(hmac(sha224),"
 					    "cbc(des3_ede))",
 				.cra_driver_name = "authenc-hmac-sha224-"
-						   "cbc-3des-talitos",
+						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC,
 			},
@@ -2357,7 +2357,7 @@ static struct talitos_alg_template drive
 			.base = {
 				.cra_name = "authenc(hmac(sha256),cbc(aes))",
 				.cra_driver_name = "authenc-hmac-sha256-"
-						   "cbc-aes-talitos",
+						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC,
 			},
@@ -2401,7 +2401,7 @@ static struct talitos_alg_template drive
 				.cra_name = "authenc(hmac(sha256),"
 					    "cbc(des3_ede))",
 				.cra_driver_name = "authenc-hmac-sha256-"
-						   "cbc-3des-talitos",
+						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC,
 			},
@@ -2527,7 +2527,7 @@ static struct talitos_alg_template drive
 			.base = {
 				.cra_name = "authenc(hmac(md5),cbc(aes))",
 				.cra_driver_name = "authenc-hmac-md5-"
-						   "cbc-aes-talitos",
+						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC,
 			},
@@ -2569,7 +2569,7 @@ static struct talitos_alg_template drive
 			.base = {
 				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
 				.cra_driver_name = "authenc-hmac-md5-"
-						   "cbc-3des-talitos",
+						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC,
 			},


