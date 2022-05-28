Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428E1536E34
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 21:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiE1T5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 15:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiE1T5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 15:57:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5826D977;
        Sat, 28 May 2022 12:50:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A9ADB808CF;
        Sat, 28 May 2022 19:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E26C34100;
        Sat, 28 May 2022 19:33:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="fXoFtTQf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1653766396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+oBgNWCrCEfj77D+ymOiG9RDteGb169SqLkPBOWO8Ns=;
        b=fXoFtTQfnuJBuQgF5I58jGt4fA7UvpU8LkrjsTeolpiULl7ACEY7MdrNmpFwZHs58etUr0
        Yct7vmxpXsfHOUI68UI829BkROs6/lSLGFYMf1189zSj2zOE3ZNd4/RIzhKzKCWPPUbE5A
        aPdNFJMKazJAX+kIqYQIErkwi4IAI+s=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b1635e8f (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 28 May 2022 19:33:16 +0000 (UTC)
Received: by mail-yb1-f171.google.com with SMTP id p13so1544812ybm.1;
        Sat, 28 May 2022 12:33:15 -0700 (PDT)
X-Gm-Message-State: AOAM533lO2OukQsjs2QOYhYYE8OQ9KXHQ30g6q9nmtzKbLm+8oLN67fQ
        mzunD2oMZl3Pw84VZ/mhx/lMydPhdwYSvDkwsCM=
X-Google-Smtp-Source: ABdhPJzSW7684S4JNrSQrof2q+N+nw7cgyupNrKx6SfXHvW9mwZtBj5oUTatTQV4ucp6vaOpKvJEX+1xTYrWcPAR93k=
X-Received: by 2002:a25:c803:0:b0:654:f985:9bbb with SMTP id
 y3-20020a25c803000000b00654f9859bbbmr21106059ybf.267.1653766394856; Sat, 28
 May 2022 12:33:14 -0700 (PDT)
MIME-Version: 1.0
References: <YpCGQvpirQWaAiRF@zx2c4.com> <20220527081106.63227-1-Jason@zx2c4.com>
 <YpGeIT1KHv9QwF4X@sol.localdomain> <YpHx7arH4lLaZuhm@zx2c4.com> <YpJZqJd9j1gEOdTe@sol.localdomain>
In-Reply-To: <YpJZqJd9j1gEOdTe@sol.localdomain>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 28 May 2022 21:33:03 +0200
X-Gmail-Original-Message-ID: <CAHmME9ozranfubv1qGbVvOWhmFpTn8OuALB0KY2yvJZJLcw3eg@mail.gmail.com>
Message-ID: <CAHmME9ozranfubv1qGbVvOWhmFpTn8OuALB0KY2yvJZJLcw3eg@mail.gmail.com>
Subject: Re: [PATCH crypto v2] crypto: blake2s - remove shash module
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        gaochao <gaochao49@huawei.com>, Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 28, 2022 at 7:19 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Sat, May 28, 2022 at 11:57:01AM +0200, Jason A. Donenfeld wrote:
> > > Also, the wrong value is being passed for the 'inc' argument.
> >
> > Are you sure? Not sure I'm seeing what you are on first glance.
>
> Yes, 'inc' is the increment amount per block.  It needs to always be
> BLAKE2S_BLOCK_SIZE unless a partial block is being processed.

Bingo, thanks. v+1 coming up.

Jason
