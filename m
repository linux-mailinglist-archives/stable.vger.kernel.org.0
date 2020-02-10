Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93928157786
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbgBJMko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:41428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728568AbgBJMko (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:44 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D90F2173E;
        Mon, 10 Feb 2020 12:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338443;
        bh=8Sa8/RzdvR/yozr7Cazg+eUBPoVAQJx9MjoIwYNUYmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KEVpWpBadw8/ajbbjc8oDjRq2YkoGtkBym9V5SSmOtQYXHF19FJ0yho+HL/avmixo
         qz5MN4IHTJYtRMkkaO39/bO2FvmlkdVGT+kYSlOKAQwr6PQSUPYAVD0qy3a2DxsWLa
         4thvpUK8wcjdcQGNa1L3rfAMC6Uw6nlgIAdi/Bgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.5 183/367] crypto: hisilicon - select CRYPTO_SKCIPHER, not CRYPTO_BLKCIPHER
Date:   Mon, 10 Feb 2020 04:31:36 -0800
Message-Id: <20200210122441.612820339@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 8e8c778d9ed4fdc5a9af108c7023bfb640a673f2 upstream.

Another instance of CRYPTO_BLKCIPHER made it in just after it was
renamed to CRYPTO_SKCIPHER.  Fix it.

Fixes: 416d82204df4 ("crypto: hisilicon - add HiSilicon SEC V2 driver")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/hisilicon/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -16,7 +16,7 @@ config CRYPTO_DEV_HISI_SEC
 
 config CRYPTO_DEV_HISI_SEC2
 	tristate "Support for HiSilicon SEC2 crypto block cipher accelerator"
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_SKCIPHER
 	select CRYPTO_ALGAPI
 	select CRYPTO_LIB_DES
 	select CRYPTO_DEV_HISI_QM


