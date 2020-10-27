Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091CE29B7E5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760013AbgJ0P2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798144AbgJ0PZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:25:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39A552064B;
        Tue, 27 Oct 2020 15:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812352;
        bh=y7On0RCz/haadqxRkMbWjY19ZAc0IGLkSro9W9aNuLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=na/0COTQIUHSu/C/eL5UG2xnn76SPpVjbuoLfjNwOujnXh3l3J2+Fg17zHkqUtO/W
         yLCKpzrejlQVZYXJDHRgSjdGJ04V4KAYqn71nQ2UmLoVZmpAZn7My7ovEE22YFykmc
         XwTphO1Odxc+CJJtFkRI/rjomqoXr5FfG1IA4ETc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Keerthy <j-keerthy@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 149/757] crypto: sa2ul - Select CRYPTO_AUTHENC
Date:   Tue, 27 Oct 2020 14:46:39 +0100
Message-Id: <20201027135457.595489327@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 61f033ba18c37e6b9ddfc4ee6dffe049d981fe7e ]

The sa2ul driver uses crypto_authenc_extractkeys and therefore
must select CRYPTO_AUTHENC.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 52a9b7cf6576f..ab941cfd27a88 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -876,6 +876,7 @@ config CRYPTO_DEV_SA2UL
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
+	select CRYPTO_AUTHENC
 	select HW_RANDOM
 	select SG_SPLIT
 	help
-- 
2.25.1



