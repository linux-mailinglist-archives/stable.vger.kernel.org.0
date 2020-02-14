Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD5415F0D1
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388136AbgBNP5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:57:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388128AbgBNP5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:57:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF19524681;
        Fri, 14 Feb 2020 15:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695826;
        bh=qkr6acl5AOx9HxzNSn2Ffkl5YYxSy9LryyRo9RewjuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hiG64iMqHOgzDFW9fkKFp6vIxfSbtI13upZ41yVKv63NZdsh2FStgFUO3+cF16lYy
         gFfgOyJJQ2ZHNIXVAMiwtae15kZO8pTsaj8Z1WNo7A3eslPHI74eCdjzEWedK3PV5Z
         MHaG81kr9FevP3ian4TsRTjIyXhPrAd+2EutWD0o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 380/542] crypto: essiv - fix AEAD capitalization and preposition use in help text
Date:   Fri, 14 Feb 2020 10:46:12 -0500
Message-Id: <20200214154854.6746-380-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
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
index 5575d48473bd4..cdb51d4272d0c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -511,10 +511,10 @@ config CRYPTO_ESSIV
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

