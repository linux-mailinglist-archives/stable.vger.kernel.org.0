Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023D6547942
	for <lists+stable@lfdr.de>; Sun, 12 Jun 2022 10:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbiFLIRC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jun 2022 04:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiFLIQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jun 2022 04:16:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57767674D8;
        Sun, 12 Jun 2022 01:16:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFC0960B07;
        Sun, 12 Jun 2022 08:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBB7C34115;
        Sun, 12 Jun 2022 08:16:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Uj0hpe+B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1655021813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PRNGBc4WtLenG6ZP6j9C3B95VAb7JdLqXsJhXnodvsQ=;
        b=Uj0hpe+BW1gyjuB/IqS6RflhJZgFTlFxir3ev2KcKWObv5Nxr6GRAcABW4TfeIRVYk5nQA
        EqDwPNGqDMV0btVf/2ch33HWCtTJ2Xvh1lqRQ4tM9ZakjxhMYpitUPyJZtVVcgdrfy6KSi
        6VILZK77MU3mMxxu3UNyEwLUQYj/ULw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id dee71699 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sun, 12 Jun 2022 08:16:53 +0000 (UTC)
Date:   Sun, 12 Jun 2022 10:16:50 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Jason Self <jason@bluehome.net>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: Build error on openrisc with CONFIG_CRYPTO_LIB_CURVE25519
Message-ID: <YqWg8h8G39WA6LI/@zx2c4.com>
References: <20220609162943.6e3bba4f@valencia>
 <YqLTecx7MGFPOvhw@kroah.com>
 <20220610182523.2f5620a2@valencia>
 <20220610184255.20ecde41@valencia>
 <YqQHZB6/u4nrFzIm@sol.localdomain>
 <YqWOVp2P8Qp/9/Ek@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YqWOVp2P8Qp/9/Ek@gondor.apana.org.au>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Herbert,

On Sun, Jun 12, 2022 at 02:57:26PM +0800, Herbert Xu wrote:
> On Fri, Jun 10, 2022 at 08:09:24PM -0700, Eric Biggers wrote:
> >
> > It looks like "crypto: memneq - move into lib/" is going to fix this
> > (https://lore.kernel.org/linux-crypto/20220528102429.189731-1-Jason@zx2c4.com).
> > At the moment it's queued in cryptodev/master.  Herbert, are you planning to
> > send it upstream soon?
> 
> OK I have added it to the crypto tree.

Could you do the same with
https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=2d16803c562ecc644803d42ba98a8e0aef9c014e
It fixes a similar bug.

Jason

> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
