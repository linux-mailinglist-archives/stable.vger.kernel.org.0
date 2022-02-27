Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891AA4C5A6C
	for <lists+stable@lfdr.de>; Sun, 27 Feb 2022 11:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiB0KNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Feb 2022 05:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiB0KNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Feb 2022 05:13:16 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD7D22B3D
        for <stable@vger.kernel.org>; Sun, 27 Feb 2022 02:12:38 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id v3so911875yba.1
        for <stable@vger.kernel.org>; Sun, 27 Feb 2022 02:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YN5gXSHoby1JhWgy0jxqxZICsBW2QIk/PtIVlJI1hvU=;
        b=rJnEcVUeF28k2edHMPFZC2EO8rxyxAxJYv49OYC1Ro+QhIzCUCBWZvIjt/xAu38CrO
         fUMimmPDcvBQXsPngPaD6M5BUJcffKi8fusU5M3E404hq/cy4BCAXiK43kfsrDS8nGK6
         81WBGST8T4ArZ6pSl4KiiLi2dE3H38OOTzbVHrPKvpPgpZik//msTjTjm0R2tuNm8tws
         d8GCEzznR/2/0UqGVlIOoUpIAB/9/Pc1mDLIx4YWkr7mIssffrO/EoLMCvfm5vYaKwJe
         vXpO3lC9aU4XSkZMRu2an9E7BlaGmaRd51AuItWIeHXpToME8mkEa4h0Yeo9zq8kIARy
         jrNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YN5gXSHoby1JhWgy0jxqxZICsBW2QIk/PtIVlJI1hvU=;
        b=LV5en/hsSaZSfUwlEDSsamTjQ5gYaLU6S5KttLFU9gW+5s0G4KpTrjnK9MlZp9y8rc
         AHUHW1m8NzY81KjDGsvxJc5EzTgcyc+vLXBVtk3I7mkRB4/yb2SOEr9ZxIdFWEL/JXBs
         6OgZacge+RwEh6SlKQKKj8z/LccGaEF+mGndtofxcPLs+YyaSyIBw5n2AR33Ck5SWpUi
         bDielbTAxIiapD+/+BBvwh8ZztFMgrTKlvn3QzAWESx0jp5ri1l1hHkOFee0lP1wCzQV
         9VC1tQYNcnolSprdedXPb/9P6pv86lU6f4lH1o98OE4INdAF+0zilg2/j9nEy3hR7YT0
         Re6g==
X-Gm-Message-State: AOAM530pNeXRcu6j6+rJF0ChnorTr6+Y5Y4ZncNkeHaiO1h9SO2HA2Az
        872q/La6O2rbdYH1qEEseGmgtzWCIb+A30lDSMz0Gw==
X-Google-Smtp-Source: ABdhPJwlaLq9aI2Vm0ffDhMefpXJ3KAId9EfQSy0et+XHJjaU0jx09HPqwTfoypR/5Y1+2RIZZqaK5VyWbfRnYo5icA=
X-Received: by 2002:a25:ba04:0:b0:623:ed7a:701d with SMTP id
 t4-20020a25ba04000000b00623ed7a701dmr13888483ybg.209.1645956757868; Sun, 27
 Feb 2022 02:12:37 -0800 (PST)
MIME-Version: 1.0
References: <20220223080400.139367-1-gilad@benyossef.com> <Yhbjq3cVsMVUQLio@sol.localdomain>
 <YhblA1qQ9XLb2nmO@sol.localdomain> <CAOtvUMfFhQABmmZe7EH-o=ULEChm_t=KY7ORBRgm94O=1MiuFw@mail.gmail.com>
 <YhfWzLBq2A2nr5Ey@sol.localdomain>
In-Reply-To: <YhfWzLBq2A2nr5Ey@sol.localdomain>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sun, 27 Feb 2022 12:12:38 +0200
Message-ID: <CAOtvUMcDcouMPmVUYpYEPdxPS+7_r9S_OXz1FR5tQJM6hWzRmA@mail.gmail.com>
Subject: Re: [PATCH] crypto: drbg: fix crypto api abuse
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        stable <stable@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 24, 2022 at 9:04 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Feb 24, 2022 at 09:07:47AM +0200, Gilad Ben-Yossef wrote:
> > Hi Eric,
> >
> > On Thu, Feb 24, 2022 at 3:53 AM Eric Biggers <ebiggers@kernel.org> wrot=
e:
> > >
> > > On Wed, Feb 23, 2022 at 05:47:25PM -0800, Eric Biggers wrote:
> > > > On Wed, Feb 23, 2022 at 10:04:00AM +0200, Gilad Ben-Yossef wrote:
> > > > > the drbg code was binding the same buffer to two different
> > > > > scatter gather lists and submitting those as source and
> > > > > destination to a crypto api operation, thus potentially
> > > > > causing HW crypto drivers to perform overlapping DMA
> > > > > mappings which are not aware it is the same buffer.
> > > > >
> > > > > This can have serious consequences of data corruption of
> > > > > internal DRBG buffers and wrong RNG output.
> > > > >
> > > > > Fix this by reusing the same scatter gatther list for both
> > > > > src and dst.
> > > > >
> > > > > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> > > > > Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > > > > Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > > > > Tested-on: r8a7795-salvator-x
> > > > > Tested-on: xilinx-zc706
> > > > > Fixes: 43490e8046b5d ("crypto: drbg - in-place cipher operation f=
or CTR")
> > > > > Cc: stable@vger.kernel.org
> > > >
> > > > Where is it documented and tested that the API doesn't allow this?
> > > > I wasn't aware of this case; it sounds perfectly allowed to me.
> > > > There might be a lot of other users who do this, not just drbg.c.
> > > >
> > >
> > > Just quickly looking through the code I maintain, there is another pl=
ace that
> > > uses scatterlists like this: in fscrypt_crypt_block() in fs/crypto/cr=
ypto.c, the
> > > source and destination can be the same.  That's just the code I maint=
ain; I'm
> > > sure if you looked through the whole kernel you'd find a lot more.
> > >
> > > This sounds more like a driver bug, and a case we need to add self-te=
sts for.
> >
> > Thank you for the feedback. That is a very good question. Indeed, I
> > agree with you that in an ideal world the internal implementation detai=
ls of DMA
> > mapping would not pop up and interfere with higher level layer logic.
> >
> > Let me describe my point of view and I would be very happy to hear
> > where I am wrong:
> >
> > The root cause underlying this is that, of course,  hardware crypto
> > drivers map the sglists passed to them for DMA . Indeed, we require
> > input to crypto
> > API as sglists of DMAable buffers (and not, say stack allocated buffers=
) because
> > of this. So far I am just stating the obvious...
> >
> > Now, it looks like the DMA api, accessed via dma_map_sg(), does not
> > like overlapping mappings. The bug report that triggered this patch (se=
e:
> > https://lkml.org/lkml/2022/2/20/240) was an oops message including this
> > warning: "DMA-API: ccree e6601000.crypto: cacheline tracking EEXIST,
> > overlapping mappings aren't supported".
> >
> > The messages comes from add_dma_entry() in kernel.dma/debug.c,
> > because, as stated in the commit message that added this check in May 2=
021:
> >
> > "Since, overlapping mappings are not supported by the DMA API we
> > should report an error if active_cacheline_insert returns -EEXIST."
> > (https://lkml.org/lkml/2021/5/18/572)
> >
> > For now, I will take it at a given that this is proper and you do not
> > consider this
> > an issue in the DMA API.
> >
> > Now, driver writers are of course aware of this DMA API limitation and =
thus we
> > check if the src sglist is the same as the dst sglist and if so only ma=
p once.
> > However, the underlying assumption is that the buffers pointed by diffe=
rent
> > sglists do not overlap. We do not iterate over all the sglist trying
> > to find overlaps.
> >
> > When I see "we", it is because this behavior is not unique to the ccree=
 driver:
> >
> > Here is the same logic from a marvell cesa driver:
> > https://elixir.bootlin.com/linux/latest/source/drivers/crypto/marvell/c=
esa/cipher.c#L326
> >
> > Here it is again in the camm driver:
> > https://elixir.bootlin.com/linux/latest/source/drivers/crypto/caam/caam=
alg.c#L1619
> >
> > I do believe that at least all crypto HW drivers apply the same logic.
> >
> > Of course, we can ask that every HW crypto driver (and possibly any oth=
er
> > sglist using HW driver) will add logic that scans each sglist for
> > overlapping buffers
> > and if found use a more sophisticated mapping (easy for a simple
> > sglist that has one buffer
> > identical to some other sglist, maybe more complicated if the overlap
> > is not identity).
> > The storage drivers sort of already do on some level, although I think
> > on a higher abstraction
> > layer than the drivers themselves if I'm not mistaken, though for
> > performance reasons.
> > This is certainly DOABLE in the sense that it can be achieved.
> >
> > However, I don't think this is desirable. This will add non trivial
> > code with non trivial runtime
> > costs just to spot these cases. And we will need to fix ALL the hw
> > drivers, because, to the best
> > of my knowledge, none of them do this right now.
> >
> > The remaining option is to enforce the rule of no overlap between
> > different sglists passed to the
> > crypto API. This seems much easier to me. Indeed, the fix I sent is a
> > one liner. I suspect all
> > other fixes are similar and I assume (but did not check) that there
> > are not many of those.
> > Indeed, I think it is much easier to impose the required limitation at
> > the API caller level.
> > It is not pretty, nor "just", but easier, I think.
> >
> > I hope I've managed to explain my logic here.
> >
> > I will note that even if we decide to follow the other route, we do
> > need to document and fix
> > probably every hw crypto (and possibly others) driver out there,
> > because AFAIK, no one is taking
> > into account this possibility right now.
>
> Decryption in dm-crypt is another example where different scatterlists ar=
e used
> for in-place data.  (This is because like the fscrypt case, it has a help=
er
> function which handles both in-place and out-of-place data.)
>
> I don't think it is reasonable to "fix" all these users who are using the=
 crypto
> API in a perfectly reasonable way.

I understand what you are saying, but assuming the issue is real, the
alternative seems to be
to fix all the HW crypto drivers by adding code that will impact their
performance, so it's a matter
of choosing the lesser of two evils.

>
> Are you saying that dm-crypt, fscrypt, drbg, etc. never worked with any h=
ardware
> crypto driver?  How could that possibly be the case?  Perhaps something c=
hanged
> in the DMA API recently that is causing this.  Or maybe it is specific to=
 the
> implementation of the DMA API on the platform you are testing.

That is a very good question. I became aware of this via a bug report
of Corentin Labbe
which saw the problem on a Salvator-X board. I have never seen the
specific issue anywhere else.

Having said that, the following is also true:
- The code that checks for this condition was only added in 2021.
- I am not sure why the DMA api prohibits aliased mappings, but I can
guess, and if my guess is correct this situation will only happen on a
platform that both: 1. uses a crypto HW accelerator driven by DMA and
2. uses some form of IO MMU. I guess the combination might have been
very rare in the past.

I think the right thing to do right now is to verify that we indeed
have a general issue and not something specific to one singular
platform
So the question becomes - do indeed the DMA api forbits aliased
mappings and if so, under what conditions?

Any ideas on how to check this?

Gilad



>
> - Eric



--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
