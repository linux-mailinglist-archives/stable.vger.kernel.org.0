Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BA7535F6F
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235282AbiE0Lhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351352AbiE0Lhn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:37:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCC970347;
        Fri, 27 May 2022 04:37:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1F2B4CE251F;
        Fri, 27 May 2022 11:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6A9C3411A;
        Fri, 27 May 2022 11:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651455;
        bh=PORpr+2wqIhjQhXaitWImoIa4fAJzrqRfApNA41YQwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VLDpmT5pwGri38ZdOZy9lraN36Vf0is7vJvQ+zxhJ8Wyca+akrR/IVXLdnC6T2fHp
         xKo5A8hY9+bXYazoYc7Hl27Nx8e7tQ1B652bPCGbq1FMZ2CvgIGBfbHBOaQX0rXycA
         PKFcJBYmd9vkBAKjMpA0y6hxMLLX86tNX3ZmvEeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 022/163] crypto: blake2s - add comment for blake2s_state fields
Date:   Fri, 27 May 2022 10:48:22 +0200
Message-Id: <20220527084831.270485281@linuxfoundation.org>
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

commit 7d87131fadd53a0401b5c078dd64e58c3ea6994c upstream.

The first three fields of 'struct blake2s_state' are used in assembly
code, which isn't immediately obvious, so add a comment to this effect.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/crypto/blake2s.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/crypto/blake2s.h
+++ b/include/crypto/blake2s.h
@@ -24,6 +24,7 @@ enum blake2s_lengths {
 };
 
 struct blake2s_state {
+	/* 'h', 't', and 'f' are used in assembly code, so keep them as-is. */
 	u32 h[8];
 	u32 t[2];
 	u32 f[2];


