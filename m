Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE249535F68
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351404AbiE0LiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351378AbiE0Lhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:37:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373CB7090F;
        Fri, 27 May 2022 04:37:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8396E61CE4;
        Fri, 27 May 2022 11:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C90C385A9;
        Fri, 27 May 2022 11:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651465;
        bh=CdqK0PbI7muPYvM317tvTG8fKcq7eG5iKABmhbF7GFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AhNBaEqqshEZ9f1abCSt8wa4rfRm2joDaASD86iVNNbVazKlZkiX3WfAkfYJi6U29
         gstjO/xMEADPymTQyCGfs6kC+c731FpvPBnmXiLmJ+3lsEIhSB1hrgCLQM7tq8m/Me
         3Mv5xpRJT8E/jlRk+o9KS7otOU+TABeIdsR8AvwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 023/163] crypto: blake2s - adjust include guard naming
Date:   Fri, 27 May 2022 10:48:23 +0200
Message-Id: <20220527084831.434749439@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -105,4 +105,4 @@ static inline void blake2s(u8 *out, cons
 void blake2s256_hmac(u8 *out, const u8 *in, const u8 *key, const size_t inlen,
 		     const size_t keylen);
 
-#endif /* BLAKE2S_H */
+#endif /* _CRYPTO_BLAKE2S_H */
--- a/include/crypto/internal/blake2s.h
+++ b/include/crypto/internal/blake2s.h
@@ -4,8 +4,8 @@
  * Keep this in sync with the corresponding BLAKE2b header.
  */
 
-#ifndef BLAKE2S_INTERNAL_H
-#define BLAKE2S_INTERNAL_H
+#ifndef _CRYPTO_INTERNAL_BLAKE2S_H
+#define _CRYPTO_INTERNAL_BLAKE2S_H
 
 #include <crypto/blake2s.h>
 #include <crypto/internal/hash.h>
@@ -116,4 +116,4 @@ static inline int crypto_blake2s_final(s
 	return 0;
 }
 
-#endif /* BLAKE2S_INTERNAL_H */
+#endif /* _CRYPTO_INTERNAL_BLAKE2S_H */


