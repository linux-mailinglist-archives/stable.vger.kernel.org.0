Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1ED15EC2D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391104AbgBNRZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:25:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:32984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391087AbgBNQIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:08:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19A4D2467E;
        Fri, 14 Feb 2020 16:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696533;
        bh=JtLdoFb5vk4yL5BF0/BYDK63z/UKKfyFPF6sQjWHJAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZs9M9EAa5thcKJRj7BYWughQH/naNcpuGA6XKXvoMuA2/pafGf8IlkFRA0yk8iDy
         T9gq99v8pKVMJCoRbPC0kgNsWStBe8Z8AushMVhqlSwSQDYa7UitrJ5CC169vlMAsM
         4vWxRnM3pn8lrxx2N73aWhw2A+B2U5fUHRMrPhag=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 330/459] crypto: essiv - fix AEAD capitalization and preposition use in help text
Date:   Fri, 14 Feb 2020 10:59:40 -0500
Message-Id: <20200214160149.11681-330-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

