Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C18F167651
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbgBUILl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:11:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:47224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732392AbgBUILj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:11:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 070BD20578;
        Fri, 21 Feb 2020 08:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272698;
        bh=JtLdoFb5vk4yL5BF0/BYDK63z/UKKfyFPF6sQjWHJAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CiwRV08gOTYlT5UaVDfA0eJr1G92JcDk8q1ppSQBpk3/S+JIrA1cJG5TJ9d+oWFhV
         nnzR39rVtk0f8yF4Vgmh8azsy7n8RbDeJftQ3DZvA6GMGXoWhK/jMbvscZYfNsRArw
         wObE5NeZ5H/lokuqYeN0MNS58Mvhz6dUMq3dlXD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 241/344] crypto: essiv - fix AEAD capitalization and preposition use in help text
Date:   Fri, 21 Feb 2020 08:40:40 +0100
Message-Id: <20200221072411.220742279@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit ab3d436bf3e9d05f58ceaa85ff7475bfcd6e45af ]

"AEAD" is capitalized everywhere else.
Use "an" when followed by a written or spoken vowel.

Fixes: be1eb7f78aa8fbe3 ("crypto: essiv - create wrapper template for ESSIV generation")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 29472fb795f34..b2cc0ad3792ad 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -500,10 +500,10 @@ config CRYPTO_ESSIV
 	  encryption.
 
 	  This driver implements a crypto API template that can be
-	  instantiated either as a skcipher or as a aead (depending on the
+	  instantiated either as an skcipher or as an AEAD (depending on the
 	  type of the first template argument), and which defers encryption
 	  and decryption requests to the encapsulated cipher after applying
-	  ESSIV to the input IV. Note that in the aead case, it is assumed
+	  ESSIV to the input IV. Note that in the AEAD case, it is assumed
 	  that the keys are presented in the same format used by the authenc
 	  template, and that the IV appears at the end of the authenticated
 	  associated data (AAD) region (which is how dm-crypt uses it.)
-- 
2.20.1



