Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE9F33D3F7
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 13:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbhCPMgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 08:36:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231977AbhCPMfx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 08:35:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E16265040;
        Tue, 16 Mar 2021 12:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615898152;
        bh=H3O4NuvSwKi9LOZxul/dwOu19z4w5SYM6eVgy3tlGl4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EC67N6d4ZEuOfBVZm07793FK6CyuONBV7DqLEzX0fFOLK/LMJoP5M+hX3PdNzaDMy
         /ODuRiHu5+UMsTT9iZjSxSooVBJSQwQkGLX5AHn479DCg2ygf0ekVKoWcq5seP7ejz
         BZzcASRW2iAs3jpKATZzJ+nwfVPezVtIvkjhNEwqt4hQweAWrWz2LTAPjvnNumVJmX
         W4hwnrQxeY1OStRrzPeR7wwuU1qMyNBYTsZfCkX97DSL2FTbHKF/P2DVZhzaAuhhel
         pDSUa0oOfmGzXUXQTWKQ/pNJLDGb3qoWJhVAqPMWrZ2tPOE/8QxJcstsf/h18gunhv
         hgzYEHM3N/Wpg==
Received: by mail-oo1-f41.google.com with SMTP id h3-20020a4ae8c30000b02901b68b39e2d3so4089832ooe.9;
        Tue, 16 Mar 2021 05:35:52 -0700 (PDT)
X-Gm-Message-State: AOAM530eioC8X+2rsxiHxfQTbN+imnjApdHQWWaGMERXIjk0rOR+z73F
        YiLGiFOeT34G/C6ReGZkQfiKLg5bzNgQbbi/7C4=
X-Google-Smtp-Source: ABdhPJwkOkoQ7BPhocLBhTon+VlAEgpihLRlimKNoo25/QMzFtJ8vaa54DC+rqpUCQNfzSJrac3p/N3nBoubslgZrW0=
X-Received: by 2002:a4a:395d:: with SMTP id x29mr3596246oog.41.1615898151683;
 Tue, 16 Mar 2021 05:35:51 -0700 (PDT)
MIME-Version: 1.0
References: <d5c825ba-cdcb-29eb-c434-83ef4db05ee0@tmb.nu> <CAMj1kXEM76Dejv1fTZ-1EmXpSsE-ZtKWf19dPNTSBRuPcAkreA@mail.gmail.com>
 <1e6eb02b-e699-d1ff-9cfb-4ef77255e244@tmb.nu> <9493dced-908e-a9bd-009a-6b20a8422ec1@tmb.nu>
In-Reply-To: <9493dced-908e-a9bd-009a-6b20a8422ec1@tmb.nu>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 16 Mar 2021 13:35:40 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHzEEU2-mVxVD8g=P_Py_WJMOn0q8m+k-txUUioS+2ajQ@mail.gmail.com>
Message-ID: <CAMj1kXHzEEU2-mVxVD8g=P_Py_WJMOn0q8m+k-txUUioS+2ajQ@mail.gmail.com>
Subject: Re: stable request
To:     Thomas Backlund <tmb@tmb.nu>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Mar 2021 at 13:28, Thomas Backlund <tmb@tmb.nu> wrote:
>
>
> Den 16.3.2021 kl. 14:15, skrev Thomas Backlund:
> >
> > Den 16.3.2021 kl. 12:17, skrev Ard Biesheuvel:
> >> On Tue, 16 Mar 2021 at 10:21, Thomas Backlund <tmb@tmb.nu> wrote:
> >>> Den 16.3.2021 kl. 08:37, skrev Ard Biesheuvel:
> >>>> Please consider backporting commit
> >>>>
> >>>> 86ad60a65f29dd862a11c22bb4b5be28d6c5cef1
> >>>> crypto: x86/aes-ni-xts - use direct calls to and 4-way stride
> >>>>
> >>>> to stable. It addresses a rather substantial retpoline-related
> >>>> performance regression in the AES-NI XTS code, which is a widely used
> >>>> disk encryption algorithm on x86.
> >>>>
> >>> To get all the nice bits, we added the following in Mageia 5.10 / 5.11
> >>> series kerenels (the 2 first is needed to get the third to apply/build
> >>> nicely):
> >>>
> >> I will leave it up to the -stable maintainers to decide, but I will
> >> point out that none of the additional patches fix any bugs, so this
> >> may violate the stable kernel rules. In fact, I deliberately split the
> >> XTS changes into two  patches so that the first one could be
> >> backported individually.
> >
> > Yes, I understand that.
> >
> > but commit
> >
> > 86ad60a65f29dd862a11c22bb4b5be28d6c5cef1
> > crypto: x86/aes-ni-xts - use direct calls to and 4-way stride
> >
> > only applies cleanly on 5.11.
> >
> >
> > So if it's wanted in 5.10 you need the 2 others too... unless you intend to provide a tested backport...
> > and IIRC GregKH prefers 1:1 matching of patches between -stable and linus tree unless they are too intrusive.
> >
> >
> > As for the last one I seem to remember comments that it too was part of the "affects performance", but I might be remembering wrong... and since you are Author of them I assume you know better about the facts :)
> >
> >
> > That's why I listed them as an extra "hopefully helfpful" info and datapoint that they work...
> > We have been carrying them in 5.10 series since we rebased to 5.10.8 on January 17th, 2021
> >
> >
> > but in the end it's up to the -stable maintainers as you point out...
>
>
> and now  I re-checked...
>
> Only the first is needed to get your fix to apply cleanly on 5.10
>
>
> the second came in as a pre-req for the fourth patch...
>

OK so that would be

032d049ea0f45b45c21f3f02b542aa18bc6b6428
Uros Bizjak <ubizjak@gmail.com>
crypto: aesni - Use TEST %reg,%reg instead of CMP $0,%reg

which is already in 5.11, but needs to be backported as well for the
originally requested backport to apply cleanly to 5.10 and earlier.

Thanks for digging that up.

-- 
Ard.
