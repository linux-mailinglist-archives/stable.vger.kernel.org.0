Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9F5370F0
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 11:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbfFFJyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 05:54:55 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:53427 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727734AbfFFJyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 05:54:54 -0400
Received: by mail-it1-f194.google.com with SMTP id m187so2199423ite.3
        for <stable@vger.kernel.org>; Thu, 06 Jun 2019 02:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8P8yzaRHEtc9JnJhJ2Vcca1eVVavzK9/2U+jP565fm0=;
        b=soldPpgwSbwWi7a0R2nLws0VmYyEMoN2MS6nALAIJ2i8Ny6tl1OSqjSZ/ScD8YR4+z
         /MUIhRqMAswM8bnBZUwQUBXderhwnAMhb09fpeeviwpQMgB+M6FeSdkFanasIMI9cXXj
         siA7L6gR7LpSIdujqDGXl7vKvKNpYNnmLYP5Yv+jvOvFIDUCkFnauTX6Xnz014PIEKho
         3c8DPdOBy9jEjvoTVGJUwcWaTONl21AbTcm3vmeAnpirAmfhkpAi7o/Qnmv43+uw+YQ+
         QKaU8tZe/eoILactvgNvkdS5vQhGvuYXLv9XWakLeadWlEBbrIUkY4Ha78NZPOxXvSf3
         CTYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8P8yzaRHEtc9JnJhJ2Vcca1eVVavzK9/2U+jP565fm0=;
        b=dyVtU/GfCDGL+Irj0Rb8uUzKeMfFgxMrpUfmn3+fR34NYGIX/RAFDziJCBPm0d/bqY
         gDd+ltfR5m6hPjEdHhlQ/L8ILvkx7K892oOjMxzeidpscWUOWvY3BUY+UC6rzlRVF2Ic
         hfmlB0yWRUo1tMLeVgYWGnr+KVLmZVbdkLN6J4D9W29/P6ChULTZnwsgbEH1kQ2crDuU
         Sdrt/E13SJGOtnK83usgeCjP5LPvVwTLWF3M/qzlucNuKbBLRLXlVEV70hwE4iA6aKUp
         J3WIfQudAyuf2Qpev2Xlkzrov77QofG3Z1N8sFGJ9GB1q5WBSDPEn/0HAVN8eqlroJU6
         jBTg==
X-Gm-Message-State: APjAAAXGNjY3SQ2QjJTMyK0KdR/tkLSKZF15MVDyCMuICprRVm70j8Xx
        gqXBfKjphLgAddPJpfYdAxm2OMXM9CO/OScPKO6tIw==
X-Google-Smtp-Source: APXvYqz6XRs3yBdb3JcP7AkuvjidH9m/e8zfPFvfRXiSbwTxc22Z2J/y3l2mcT9Y1/3ogKBHOBlDgqUV4+rbTiVEyBw=
X-Received: by 2002:a02:b01c:: with SMTP id p28mr30692269jah.130.1559814891244;
 Thu, 06 Jun 2019 02:54:51 -0700 (PDT)
MIME-Version: 1.0
References: <779905244.a0lJJiZRjM@devpool35> <1993275.kHlTELq40E@devpool35>
 <CAKv+Gu9oq+LseNvB9h1u+Q7QVOJFJwm_RyE1dMRgeVuL6D9fNQ@mail.gmail.com> <2433398.iiuBUrR0On@devpool35>
In-Reply-To: <2433398.iiuBUrR0On@devpool35>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 6 Jun 2019 11:54:37 +0200
Message-ID: <CAKv+Gu_GOprKzXmm0kzi50hR8MJ6g02uZBAnKi=5x+kFOuqz1w@mail.gmail.com>
Subject: Re: Building arm64 EFI stub with -fpie breaks build of 4.9.x
 (undefined reference to `__efistub__GLOBAL_OFFSET_TABLE_')
To:     Rolf Eike Beer <eb@emlix.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 6 Jun 2019 at 11:40, Rolf Eike Beer <eb@emlix.com> wrote:
>
> Ard Biesheuvel wrote:
> > On Thu, 6 Jun 2019 at 09:50, Rolf Eike Beer <eb@emlix.com> wrote:
> > > Am Donnerstag, 6. Juni 2019, 09:38:41 CEST schrieb Rolf Eike Beer:
> > > > Greg KH wrote:
> > > > > On Wed, Jun 05, 2019 at 05:19:40PM +0200, Rolf Eike Beer wrote:
> > > > > > I decided to dig out a toy project which uses a DragonBoard 410c.
> > > > > > This
> > > > > > has
> > > > > > been "running" with kernel 4.9, which I would keep this way for
> > > > > > unrelated
> > > > > > reasons. The vanilla 4.9 kernel wasn't bootable back then, but it
> > > > > > was
> > > > > > buildable, which was good enough.
> > > > > >
> > > > > > Upgrading the kernel to 4.9.180 caused the boot to suddenly fail:
> > > > > >
> > > > > > aarch64-unknown-linux-gnueabi-ld:
> > > > > > ./drivers/firmware/efi/libstub/lib.a(arm64- stub.stub.o): in
> > > > > > function
> > > > > > `handle_kernel_image':
> > > > > > /tmp/e2/build/linux-4.9.139/drivers/firmware/efi/libstub/arm64-stub.
> > > > > > c:63
> > > > > >
> > > > > > undefined reference to `__efistub__GLOBAL_OFFSET_TABLE_'
> > > > > > aarch64-unknown-linux-gnueabi-ld:
> > > > > > ./drivers/firmware/efi/libstub/lib.a(arm64- stub.stub.o): relocation
> > > > > > R_AARCH64_ADR_PREL_PG_HI21 against symbol
> > > > > > `__efistub__GLOBAL_OFFSET_TABLE_' which may bind externally can not
> > > > > > be
> > > > > > used when making a shared object; recompile with -fPIC
> > > > > > /tmp/e2/build/linux-4.9.139/drivers/firmware/efi/libstub/arm64-stub.
> > > > > > c:63
> > > > > >
> > > > > > (.init.text+0xc): dangerous relocation: unsupported relocation
> > > > > > /tmp/e2/build/linux-4.9.139/Makefile:1001: recipe for target
> > > > > > 'vmlinux'
> > > > > > failed -make[1]: *** [vmlinux] Error 1
> > > > > >
> > > > > > This is caused by commit 27b5ebf61818749b3568354c64a8ec2d9cd5ecca
> > > > > > from
> > > > > > linux-4.9.y (which is 91ee5b21ee026c49e4e7483de69b55b8b47042be),
> > > > > > reverting
> > > > > > this commit fixes the build.
> > > > > >
> > > > > > This happens with vanilla binutils 2.32 and gcc 8.3.0 as well as
> > > > > > 9.1.0.
> > > > > > See
> > > > > > the attached .config for reference.
> > > > > >
> > > > > > If you have questions or patches just ping me.
> > > > >
> > > > > Does Linus's latest tree also fail for you (or 5.1)?
> > > >
> > > > 5.1.7 with the same config as before and "make olddefconfig" builds for
> > > > me.
> > >
> > > Just for the fun of it: both 4.19 and 4.19.48 also work.
>
> > Could you please check whether patch
> > 60f38de7a8d4e816100ceafd1b382df52527bd50 applies cleanly, and whether
> > it fixes the problem? Thanks.
>
> The part in drivers/firmware/efi/libstub/arm-stub.c needs to be applied by
> hand, but afterwards things build fine.
>

Thanks.

I'll send out a backport.
