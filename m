Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A019F551BF7
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346143AbiFTNef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347216AbiFTNeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:34:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE410275EF;
        Mon, 20 Jun 2022 06:13:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEB38B811D8;
        Mon, 20 Jun 2022 13:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B984C3411C;
        Mon, 20 Jun 2022 13:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730721;
        bh=IXRIJ1GHDIZo2SuBShIm4o6PtlLtHIr1VFnSfZwBj5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3LVD1Mv+TDW+eCBeTIpLtm/NeWfplcUlF5dVViKuhrnC2OC8uKDhSkKtNFweVDrD
         hIbzweLLoifaX5JsA55MmINMzC3oPhnKge55yiEzRoqcJTxnt56pxyEzlLLCgCdVRZ
         hJSNDrLjhjWGN9cFoliC7Y/bE0ueXNYzZnkO+0rM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 036/240] crypto: blake2s - adjust include guard naming
Date:   Mon, 20 Jun 2022 14:48:57 +0200
Message-Id: <20220620124738.948395788@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 8786841bc2020f7f2513a6c74e64912f07b9c0dc upstream.

Use the full path in the include guards for the BLAKE2s headers to avoid
ambiguity and to match the convention for most files in include/crypto/.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/crypto/blake2s.h          |    6 +++---
 include/crypto/internal/blake2s.h |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/crypto/blake2s.h
+++ b/include/crypto/blake2s.h
@@ -3,8 +3,8 @@
  * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  */
 
-#ifndef BLAKE2S_H
-#define BLAKE2S_H
+#ifndef _CRYPTO_BLAKE2S_H
+#define _CRYPTO_BLAKE2S_H
 
 #include <linux/bug.h>
 #include <linux/types.h>
@@ -99,4 +99,4 @@ static inline void blake2s(u8 *out, cons
 	blake2s_final(&state, out);
 }
 
-#endif /* BLAKE2S_H */
+#endif /* _CRYPTO_BLAKE2S_H */
--- a/include/crypto/internal/blake2s.h
+++ b/include/crypto/internal/blake2s.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 OR MIT */
 
-#ifndef BLAKE2S_INTERNAL_H
-#define BLAKE2S_INTERNAL_H
+#ifndef _CRYPTO_INTERNAL_BLAKE2S_H
+#define _CRYPTO_INTERNAL_BLAKE2S_H
 
 #include <crypto/blake2s.h>
 
@@ -16,4 +16,4 @@ static inline void blake2s_set_lastblock
 	state->f[0] = -1;
 }
 
-#endif /* BLAKE2S_INTERNAL_H */
+#endif /* _CRYPTO_INTERNAL_BLAKE2S_H */


