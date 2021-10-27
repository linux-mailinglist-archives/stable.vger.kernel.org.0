Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162AE43CF43
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 18:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243151AbhJ0RCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 13:02:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243147AbhJ0RBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 13:01:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DF61610A0;
        Wed, 27 Oct 2021 16:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635353967;
        bh=XPDZQSKu/oxCSRHobrKIa6UxkLgL9MvZLGmEVdFBR10=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WGif0o9JMu1zJEEycQk0nOLOX7EkiDBFLHTHCvrPnBnp5I2sDYZ2p0EJW/O1DZC01
         xsn93+UhBoUuc+FTAkRb//k+Gn//jbX+52/xI7hAeABgXMaYamqKs/JC7epi4fJ3Cs
         kgxfhLk1N4PhWzXXoUd4QK3aK6QvnvPykaRb3vVn1rDe9bZT4eyyFuosIEcfrLdyR3
         LUCX65oSagL6hmrrLuUREDRLc4RM7lLUB/22eDTYXSnhICDj2SSGj34mfd8JYoJW1p
         dgWqBdrakwVEJDjYQTMwAB0Y9sLLiF834ym7zHLIPgxZorKu58PPt5XXbZMXFxaMxD
         0IvZeJ/8R32SA==
Received: by mail-oi1-f171.google.com with SMTP id t4so4303588oie.5;
        Wed, 27 Oct 2021 09:59:27 -0700 (PDT)
X-Gm-Message-State: AOAM532Z0Px5dTsSrJGKzMnvqaLLK9VWhnOt4xVGAgrzZ45skvsRYOmr
        NQcfdycf9iCm/YpozOq+VY1aXY5ITuUWx+9eWsw=
X-Google-Smtp-Source: ABdhPJwY+2k7msq8E3hER2zI5uaEGtxK8/HPQuGKbUcnVM4YxgHSm9PxWrmcndYewPAwci0nPe/4lz7FIij3peH9fUQ=
X-Received: by 2002:a05:6808:4d9:: with SMTP id a25mr4477613oie.33.1635353966546;
 Wed, 27 Oct 2021 09:59:26 -0700 (PDT)
MIME-Version: 1.0
References: <8afff0c64feb6b96db36112cb865243f4ae280ca.1634922135.git.thomas.lendacky@amd.com>
 <c997e8a2-b364-2a8e-d247-438e9d937a1e@amd.com> <CAMj1kXGH7aGR==o1L2dnA9U9L==gM0__10UGznnyZwkHrT84sw@mail.gmail.com>
 <YXmEo8iMNIn1esYC@zn.tnic>
In-Reply-To: <YXmEo8iMNIn1esYC@zn.tnic>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 27 Oct 2021 18:59:15 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEZkw99MPssHWFRL_k0okeGF47VYL+o8p72hBWkqW927g@mail.gmail.com>
Message-ID: <CAMj1kXEZkw99MPssHWFRL_k0okeGF47VYL+o8p72hBWkqW927g@mail.gmail.com>
Subject: Re: [PATCH v2] x86/sme: Explicitly map new EFI memmap table as encrypted
To:     Borislav Petkov <bp@alien8.de>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Oct 2021 at 18:56, Borislav Petkov <bp@alien8.de> wrote:
>
> On Wed, Oct 27, 2021 at 05:14:35PM +0200, Ard Biesheuvel wrote:
> > I could take it, but since it will ultimately go through -tip anyway,
> > perhaps better if they just take it directly? (This will change after
> > the next -rc1 though)
> >
> > Boris?
>
> Yeah, I'm being told this is not urgent enough to rush in now so you
> could queue it into your fixes branch for 5.16 once -rc1 is out and send
> it to Linus then. The stable tag is just so it gets backported to the
> respective trees.
>
> But if you prefer I should take it, then I can queue it after -rc1.
> It'll boil down to the same thing though.
>

No, in that case, I can take it myself.

Tom, does that work for you?
