Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196A15A269D
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 13:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343859AbiHZLJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 07:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343637AbiHZLJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 07:09:42 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F81E4B48F;
        Fri, 26 Aug 2022 04:09:41 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oRXDP-00FQH2-6w; Fri, 26 Aug 2022 21:09:32 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Aug 2022 19:09:31 +0800
Date:   Fri, 26 Aug 2022 19:09:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        "Jason A . Donenfeld " <Jason@zx2c4.com>,
        "Justin M . Forbes" <jforbes@fedoraproject.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: lib - remove unneeded selection of XOR_BLOCKS
Message-ID: <Ywip6/79IEQFXt3g@gondor.apana.org.au>
References: <20220826050456.101321-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826050456.101321-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 25, 2022 at 10:04:56PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> CRYPTO_LIB_CHACHA_GENERIC doesn't need to select XOR_BLOCKS.  It perhaps
> was thought that it's needed for __crypto_xor, but that's not the case.
> 
> Enabling XOR_BLOCKS is problematic because the XOR_BLOCKS code runs a
> benchmark when it is initialized.  That causes a boot time regression on
> systems that didn't have it enabled before.
> 
> Therefore, remove this unnecessary and problematic selection.
> 
> Fixes: e56e18985596 ("lib/crypto: add prompts back to crypto libraries")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> I've separated this fix out from the larger patch
> https://lore.kernel.org/r/20220725183636.97326-3-ebiggers@kernel.org
> that is currently queued in cryptodev.
> 
>  lib/crypto/Kconfig | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks. 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
