Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E921340791
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 15:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhCROQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 10:16:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231408AbhCROPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 10:15:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D48564F24;
        Thu, 18 Mar 2021 14:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616076947;
        bh=gaH7KOpqa0mh8Td2vFO8Q9uJaIe40TCSMBkbNqSg+R0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=L++pIO1kLRARcA+NCpzuHGudtAdtwgx2QLANmUyb3vndLyelFxURtMJh3EJBQ05ja
         s5ArnWcHWLflLAauq87tku82sGhdB2vqsuI823kwWRbuBz1Fx5j6NEiU8FEOQKOGu7
         hn+8jXRL8QhHInG9ebGu8v9HwNgzbkuH/hylpUSFU4kCbuDtnm7XQh/OoXK5IkyDoe
         lR4oYd5LpCzcZkPF22JZPq5auyFvYzhWX/136pWiBuRw2gDjw1XebCrbatX2dOOo8T
         FagaOvdUaHybUkDd1+p+COA4vhg3PJeN9KG8VpqhpC4aFM3UAb7FS3sKv+6dQac6SR
         i5BFeCykBm6rw==
Received: by mail-ot1-f41.google.com with SMTP id h6-20020a0568300346b02901b71a850ab4so5315405ote.6;
        Thu, 18 Mar 2021 07:15:47 -0700 (PDT)
X-Gm-Message-State: AOAM531H4UjQf45VLZlhwNVBr1Kt/e5gSaX70M/jwnLOYyzVEDoGUh+G
        aDqaZs/VROn+UARKZahaXZCrEWP53GUaujuKqAk=
X-Google-Smtp-Source: ABdhPJzAnAlsSlpVebKZ3lyjrI7JeKROhZXVtYuFJrV41ko7Liu7GFD25Xz0rbl8O7HOAbrna5TulhXfcOlP5V1bjxM=
X-Received: by 2002:a9d:42c:: with SMTP id 41mr7407978otc.108.1616076946466;
 Thu, 18 Mar 2021 07:15:46 -0700 (PDT)
MIME-Version: 1.0
References: <d5c825ba-cdcb-29eb-c434-83ef4db05ee0@tmb.nu> <CAMj1kXEM76Dejv1fTZ-1EmXpSsE-ZtKWf19dPNTSBRuPcAkreA@mail.gmail.com>
 <1e6eb02b-e699-d1ff-9cfb-4ef77255e244@tmb.nu> <9493dced-908e-a9bd-009a-6b20a8422ec1@tmb.nu>
 <CAMj1kXHzEEU2-mVxVD8g=P_Py_WJMOn0q8m+k-txUUioS+2ajQ@mail.gmail.com> <YFNPiHAvEwDpGLrv@sashalap>
In-Reply-To: <YFNPiHAvEwDpGLrv@sashalap>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 18 Mar 2021 15:15:35 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG_D_Aw+kyrz7ShMuPaMhpnMhTRZ8tsqKUf0koq_UPSnw@mail.gmail.com>
Message-ID: <CAMj1kXG_D_Aw+kyrz7ShMuPaMhpnMhTRZ8tsqKUf0koq_UPSnw@mail.gmail.com>
Subject: Re: stable request
To:     Sasha Levin <sashal@kernel.org>
Cc:     Thomas Backlund <tmb@tmb.nu>, "# 3.4.x" <stable@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 18 Mar 2021 at 14:03, Sasha Levin <sashal@kernel.org> wrote:
>
> On Tue, Mar 16, 2021 at 01:35:40PM +0100, Ard Biesheuvel wrote:
> >On Tue, 16 Mar 2021 at 13:28, Thomas Backlund <tmb@tmb.nu> wrote:
> >>
> >>
> >> Den 16.3.2021 kl. 14:15, skrev Thomas Backlund:
> >> >
> >> > Den 16.3.2021 kl. 12:17, skrev Ard Biesheuvel:
> >> >> On Tue, 16 Mar 2021 at 10:21, Thomas Backlund <tmb@tmb.nu> wrote:
> >> >>> Den 16.3.2021 kl. 08:37, skrev Ard Biesheuvel:
> >> >>>> Please consider backporting commit
> >> >>>>
> >> >>>> 86ad60a65f29dd862a11c22bb4b5be28d6c5cef1
> >> >>>> crypto: x86/aes-ni-xts - use direct calls to and 4-way stride
> >> >>>>
> >> >>>> to stable. It addresses a rather substantial retpoline-related
> >> >>>> performance regression in the AES-NI XTS code, which is a widely used
> >> >>>> disk encryption algorithm on x86.
> >> >>>>
> >> >>> To get all the nice bits, we added the following in Mageia 5.10 / 5.11
> >> >>> series kerenels (the 2 first is needed to get the third to apply/build
> >> >>> nicely):
> >> >>>
> >> >> I will leave it up to the -stable maintainers to decide, but I will
> >> >> point out that none of the additional patches fix any bugs, so this
> >> >> may violate the stable kernel rules. In fact, I deliberately split the
> >> >> XTS changes into two  patches so that the first one could be
> >> >> backported individually.
> >> >
> >> > Yes, I understand that.
> >> >
> >> > but commit
> >> >
> >> > 86ad60a65f29dd862a11c22bb4b5be28d6c5cef1
> >> > crypto: x86/aes-ni-xts - use direct calls to and 4-way stride
> >> >
> >> > only applies cleanly on 5.11.
> >> >
> >> >
> >> > So if it's wanted in 5.10 you need the 2 others too... unless you intend to provide a tested backport...
> >> > and IIRC GregKH prefers 1:1 matching of patches between -stable and linus tree unless they are too intrusive.
> >> >
> >> >
> >> > As for the last one I seem to remember comments that it too was part of the "affects performance", but I might be remembering wrong... and since you are Author of them I assume you know better about the facts :)
> >> >
> >> >
> >> > That's why I listed them as an extra "hopefully helfpful" info and datapoint that they work...
> >> > We have been carrying them in 5.10 series since we rebased to 5.10.8 on January 17th, 2021
> >> >
> >> >
> >> > but in the end it's up to the -stable maintainers as you point out...
> >>
> >>
> >> and now  I re-checked...
> >>
> >> Only the first is needed to get your fix to apply cleanly on 5.10
> >>
> >>
> >> the second came in as a pre-req for the fourth patch...
> >>
> >
> >OK so that would be
> >
> >032d049ea0f45b45c21f3f02b542aa18bc6b6428
> >Uros Bizjak <ubizjak@gmail.com>
> >crypto: aesni - Use TEST %reg,%reg instead of CMP $0,%reg
> >
> >which is already in 5.11, but needs to be backported as well for the
> >originally requested backport to apply cleanly to 5.10 and earlier.
> >
> >Thanks for digging that up.
>
> Queued up for 5.10 and 5.11.
>
> What about anything older than 5.10? Looks like it's needed there too?
>

Yes, 4.19 and 5.4 should probably get this too. They should apply with
minimal effort, afaict. The only conflicting change is
34fdce6981b96920ced4e0ee56e9db3fb03a33f0, which changed

--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -2758,7 +2758,7 @@ SYM_FUNC_START(aesni_xts_crypt8)
        pxor INC, STATE4
        movdqu IV, 0x30(OUTP)

-       CALL_NOSPEC %r11
+       CALL_NOSPEC r11

        movdqu 0x00(OUTP), INC
        pxor INC, STATE1
@@ -2803,7 +2803,7 @@ SYM_FUNC_START(aesni_xts_crypt8)
        _aesni_gf128mul_x_ble()
        movups IV, (IVP)

-       CALL_NOSPEC %r11
+       CALL_NOSPEC r11

        movdqu 0x40(OUTP), INC
        pxor INC, STATE1

but those CALL_NOSPEC calls are being removed by this patch anyway, so
that shouldn't matter.
