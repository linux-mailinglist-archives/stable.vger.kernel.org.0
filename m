Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1854B340C14
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 18:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhCRRpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 13:45:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhCRRp1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 13:45:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C57B364F1C;
        Thu, 18 Mar 2021 17:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616089526;
        bh=d8JkEJU1rIn8CZ8QWsdShpjfs3CLyo1Fdo2qn4336/8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hGrUvjtRBKZmC8yhuQm6tCk39uVJ224oAHfyQcOk4Hwd+236ufhnhq9Lo+RCKz8vT
         IUijQghNIAfgOQooUVBvd2T/o4nBKD2/1dydxlGzkxkjPbbXtq/ocrCtkbd1Yim65w
         1piuq0SkRHFp+Qws8GpVjsUZfcFrRmZoAnPIfP5NtVUYdFcercOPSLf/KR/1rpXEjK
         8p7JMrjq/2gUZLikiYcZRPAnu9Dg98spj/gHRr6ZHIDfRbiyigG3xSvKoDlBRQfNx6
         XS3ahDtONeta8t8Em7JlVlbk0hw2/QU+fE2Y0i/BUJc5TiJBj2WOniQn5I1QA1OFPf
         x5F5ggs8L3b3Q==
Received: by mail-oi1-f179.google.com with SMTP id i81so332449oif.6;
        Thu, 18 Mar 2021 10:45:26 -0700 (PDT)
X-Gm-Message-State: AOAM532Zfv/805GP5mwXY5VtXW26BZnVXirRpfko4nahrIFcbrjkoWgD
        g1Wgez04qkm8C8Vt3PO+F8Ce50YLj+Wplfusgeo=
X-Google-Smtp-Source: ABdhPJw+7CTrl4ljVHVlLD/s2PFQt6mPirbqYjstgHpm2Fy9hbeutn6FOHN4aDO7Bp1WPJ9FXxSs986XQGx6GAm2bA0=
X-Received: by 2002:aca:538c:: with SMTP id h134mr3940196oib.174.1616089526164;
 Thu, 18 Mar 2021 10:45:26 -0700 (PDT)
MIME-Version: 1.0
References: <d5c825ba-cdcb-29eb-c434-83ef4db05ee0@tmb.nu> <CAMj1kXEM76Dejv1fTZ-1EmXpSsE-ZtKWf19dPNTSBRuPcAkreA@mail.gmail.com>
 <1e6eb02b-e699-d1ff-9cfb-4ef77255e244@tmb.nu> <9493dced-908e-a9bd-009a-6b20a8422ec1@tmb.nu>
 <CAMj1kXHzEEU2-mVxVD8g=P_Py_WJMOn0q8m+k-txUUioS+2ajQ@mail.gmail.com>
 <YFNPiHAvEwDpGLrv@sashalap> <CAMj1kXG_D_Aw+kyrz7ShMuPaMhpnMhTRZ8tsqKUf0koq_UPSnw@mail.gmail.com>
 <YFODCo5hbvO+Vp5x@sashalap> <CAMj1kXEcmx09BsH140qoUTVLLsoxqUh7=x5OwKdLZMSGEHtEVg@mail.gmail.com>
In-Reply-To: <CAMj1kXEcmx09BsH140qoUTVLLsoxqUh7=x5OwKdLZMSGEHtEVg@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 18 Mar 2021 18:45:14 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEFE1xi3GyR8iDMeG+YX8n8sBjpCJD3vWy0O-coQNzHCw@mail.gmail.com>
Message-ID: <CAMj1kXEFE1xi3GyR8iDMeG+YX8n8sBjpCJD3vWy0O-coQNzHCw@mail.gmail.com>
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

On Thu, 18 Mar 2021 at 18:13, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Thu, 18 Mar 2021 at 17:42, Sasha Levin <sashal@kernel.org> wrote:
> >
> > On Thu, Mar 18, 2021 at 03:15:35PM +0100, Ard Biesheuvel wrote:
> > >On Thu, 18 Mar 2021 at 14:03, Sasha Levin <sashal@kernel.org> wrote:
> > >> What about anything older than 5.10? Looks like it's needed there too?
> > >>
> > >
> > >Yes, 4.19 and 5.4 should probably get this too. They should apply with
> > >minimal effort, afaict. The only conflicting change is
> > >34fdce6981b96920ced4e0ee56e9db3fb03a33f0, which changed
> > >
> > >--- a/arch/x86/crypto/aesni-intel_asm.S
> > >+++ b/arch/x86/crypto/aesni-intel_asm.S
> > >@@ -2758,7 +2758,7 @@ SYM_FUNC_START(aesni_xts_crypt8)
> > >        pxor INC, STATE4
> > >        movdqu IV, 0x30(OUTP)
> > >
> > >-       CALL_NOSPEC %r11
> > >+       CALL_NOSPEC r11
> > >
> > >        movdqu 0x00(OUTP), INC
> > >        pxor INC, STATE1
> > >@@ -2803,7 +2803,7 @@ SYM_FUNC_START(aesni_xts_crypt8)
> > >        _aesni_gf128mul_x_ble()
> > >        movups IV, (IVP)
> > >
> > >-       CALL_NOSPEC %r11
> > >+       CALL_NOSPEC r11
> > >
> > >        movdqu 0x40(OUTP), INC
> > >        pxor INC, STATE1
> > >
> > >but those CALL_NOSPEC calls are being removed by this patch anyway, so
> > >that shouldn't matter.
> >
> > Hm, I'm seeing a lot more conflicts on 5.4 that I'm not too comfortable
> > with resolving.
> >
> > I should be taking just these two, right?
> >
> >         032d049ea0f4 ("crypto: aesni - Use TEST %reg,%reg instead of CMP $0,%reg")
> >         86ad60a65f29 ("crypto: x86/aes-ni-xts - use direct calls to and 4-way stride")
> >
>
> I'll take a look into this, and send separate 5.4 and 4.19 backports
> if feasible, or forget about it otherwise.

v5.4 was straight-forward but v4.19 looks a bit more complicated, and
given that this only affects performance, I am not going to bother
unless anyone specifically asks for it.
