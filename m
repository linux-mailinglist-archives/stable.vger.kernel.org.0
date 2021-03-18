Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E69340B77
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 18:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhCRRNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 13:13:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232184AbhCRRNj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 13:13:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A767864F2A;
        Thu, 18 Mar 2021 17:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616087618;
        bh=z1ZMt5lGKNPLJj7HI9Z0FIQQiYjuUQW4fPVR4s1Xopw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=O7WuWJGvmQ032Tqgf0oEcyorvMaPeCDPRMQYmrHdttaqcIaCldlujExtjb84rQg8t
         I7SsplQPViqMGKvi6hK/ZntPkDWIiZ5MbB3Ly5yen0tqbq61hSW1ZRRwzPfb/b+ALf
         28ZPitbe3SGDBqwJTHD8frDk8YYijKIEFIR24/T7nyAnC1G3YEisojxoHK16NSGI/q
         GfbaY38KS9atSb+QzeOw1D1SfmbXAryAzmXScSBQFy5LzzMVzNqllWqAL3bZxVL0D7
         S6BLPOEEDE8iXPVG55IhAQI2KQZw5P8h8TM+3ozLpaJxY+WovJwKwkT7Ta+udqJKTh
         PyjQiSSDAygDA==
Received: by mail-ot1-f44.google.com with SMTP id h6-20020a0568300346b02901b71a850ab4so5881674ote.6;
        Thu, 18 Mar 2021 10:13:38 -0700 (PDT)
X-Gm-Message-State: AOAM533Z9+/SO8x+9ckXKaOokeC+wnEPeQ3SHLm8KOnKMPyRLTtkIM6f
        bucWfSEQA0jyL2MsH42EmjfGEpFSGfOSuRmYNOE=
X-Google-Smtp-Source: ABdhPJzLfO7LUDij8Fb+lDuJv0KI1RtWO+fKmIadGan291DfvxQzbt+eWyhCgNuUJwwVhMg89PGiKFhHDfobLYtZiTE=
X-Received: by 2002:a9d:6e15:: with SMTP id e21mr8121413otr.77.1616087618036;
 Thu, 18 Mar 2021 10:13:38 -0700 (PDT)
MIME-Version: 1.0
References: <d5c825ba-cdcb-29eb-c434-83ef4db05ee0@tmb.nu> <CAMj1kXEM76Dejv1fTZ-1EmXpSsE-ZtKWf19dPNTSBRuPcAkreA@mail.gmail.com>
 <1e6eb02b-e699-d1ff-9cfb-4ef77255e244@tmb.nu> <9493dced-908e-a9bd-009a-6b20a8422ec1@tmb.nu>
 <CAMj1kXHzEEU2-mVxVD8g=P_Py_WJMOn0q8m+k-txUUioS+2ajQ@mail.gmail.com>
 <YFNPiHAvEwDpGLrv@sashalap> <CAMj1kXG_D_Aw+kyrz7ShMuPaMhpnMhTRZ8tsqKUf0koq_UPSnw@mail.gmail.com>
 <YFODCo5hbvO+Vp5x@sashalap>
In-Reply-To: <YFODCo5hbvO+Vp5x@sashalap>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 18 Mar 2021 18:13:26 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEcmx09BsH140qoUTVLLsoxqUh7=x5OwKdLZMSGEHtEVg@mail.gmail.com>
Message-ID: <CAMj1kXEcmx09BsH140qoUTVLLsoxqUh7=x5OwKdLZMSGEHtEVg@mail.gmail.com>
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

On Thu, 18 Mar 2021 at 17:42, Sasha Levin <sashal@kernel.org> wrote:
>
> On Thu, Mar 18, 2021 at 03:15:35PM +0100, Ard Biesheuvel wrote:
> >On Thu, 18 Mar 2021 at 14:03, Sasha Levin <sashal@kernel.org> wrote:
> >> What about anything older than 5.10? Looks like it's needed there too?
> >>
> >
> >Yes, 4.19 and 5.4 should probably get this too. They should apply with
> >minimal effort, afaict. The only conflicting change is
> >34fdce6981b96920ced4e0ee56e9db3fb03a33f0, which changed
> >
> >--- a/arch/x86/crypto/aesni-intel_asm.S
> >+++ b/arch/x86/crypto/aesni-intel_asm.S
> >@@ -2758,7 +2758,7 @@ SYM_FUNC_START(aesni_xts_crypt8)
> >        pxor INC, STATE4
> >        movdqu IV, 0x30(OUTP)
> >
> >-       CALL_NOSPEC %r11
> >+       CALL_NOSPEC r11
> >
> >        movdqu 0x00(OUTP), INC
> >        pxor INC, STATE1
> >@@ -2803,7 +2803,7 @@ SYM_FUNC_START(aesni_xts_crypt8)
> >        _aesni_gf128mul_x_ble()
> >        movups IV, (IVP)
> >
> >-       CALL_NOSPEC %r11
> >+       CALL_NOSPEC r11
> >
> >        movdqu 0x40(OUTP), INC
> >        pxor INC, STATE1
> >
> >but those CALL_NOSPEC calls are being removed by this patch anyway, so
> >that shouldn't matter.
>
> Hm, I'm seeing a lot more conflicts on 5.4 that I'm not too comfortable
> with resolving.
>
> I should be taking just these two, right?
>
>         032d049ea0f4 ("crypto: aesni - Use TEST %reg,%reg instead of CMP $0,%reg")
>         86ad60a65f29 ("crypto: x86/aes-ni-xts - use direct calls to and 4-way stride")
>

I'll take a look into this, and send separate 5.4 and 4.19 backports
if feasible, or forget about it otherwise.
