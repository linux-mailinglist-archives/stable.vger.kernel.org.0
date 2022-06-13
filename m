Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5DB548417
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 12:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbiFMJqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 05:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiFMJqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 05:46:11 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECC912D2B;
        Mon, 13 Jun 2022 02:46:09 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o0gdr-0068Bw-NO; Mon, 13 Jun 2022 19:45:53 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Jun 2022 17:45:52 +0800
Date:   Mon, 13 Jun 2022 17:45:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Jason Self <jason@bluehome.net>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: Build error on openrisc with CONFIG_CRYPTO_LIB_CURVE25519
Message-ID: <YqcHUOe2QH+N8FbV@gondor.apana.org.au>
References: <20220609162943.6e3bba4f@valencia>
 <YqLTecx7MGFPOvhw@kroah.com>
 <20220610182523.2f5620a2@valencia>
 <20220610184255.20ecde41@valencia>
 <YqQHZB6/u4nrFzIm@sol.localdomain>
 <YqWOVp2P8Qp/9/Ek@gondor.apana.org.au>
 <YqWg8h8G39WA6LI/@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqWg8h8G39WA6LI/@zx2c4.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 12, 2022 at 10:16:50AM +0200, Jason A. Donenfeld wrote:
> Hi Herbert,
> 
> On Sun, Jun 12, 2022 at 02:57:26PM +0800, Herbert Xu wrote:
> > On Fri, Jun 10, 2022 at 08:09:24PM -0700, Eric Biggers wrote:
> > >
> > > It looks like "crypto: memneq - move into lib/" is going to fix this
> > > (https://lore.kernel.org/linux-crypto/20220528102429.189731-1-Jason@zx2c4.com).
> > > At the moment it's queued in cryptodev/master.  Herbert, are you planning to
> > > send it upstream soon?
> > 
> > OK I have added it to the crypto tree.
> 
> Could you do the same with
> https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=2d16803c562ecc644803d42ba98a8e0aef9c014e
> It fixes a similar bug.

Sorry, that one is a bit too big for my taste.  If this issue is
so critical that we must fix it right away can you please do a
minimal patch?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
