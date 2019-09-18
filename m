Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A99E9B5D43
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbfIRGVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729016AbfIRGVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:21:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6308920678;
        Wed, 18 Sep 2019 06:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787672;
        bh=UwPwWnQUujDomChcfZB29rRr6co/+JKonyQaGZ7csTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OX8gB78gp8LpvdGm8FJYZk/R0+XJGrFePxh/GOdVfMPfB18EhfMr2BDr6dIXHWf6k
         cl0vHWKu7/OVffuguL5oXveDgK2Jy1eXQRBp/APZe4TsOo/X1gIvFFribX1vHN1XX/
         X84x19cbMOFLXsyzkYcSGccLTSW0gN78eV6JX9Lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 35/45] crypto: talitos - fix CTR alg blocksize
Date:   Wed, 18 Sep 2019 08:19:13 +0200
Message-Id: <20190918061227.116560649@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061222.854132812@linuxfoundation.org>
References: <20190918061222.854132812@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit b9a05b6041cb9810a291315569b2af0d63c3680a upstream.

CTR has a blocksize of 1.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 5e75ae1b3cef ("crypto: talitos - add new crypto modes")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/talitos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2644,7 +2644,7 @@ static struct talitos_alg_template drive
 		.alg.crypto = {
 			.cra_name = "ctr(aes)",
 			.cra_driver_name = "ctr-aes-talitos",
-			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_blocksize = 1,
 			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
 				     CRYPTO_ALG_ASYNC,
 			.cra_ablkcipher = {


