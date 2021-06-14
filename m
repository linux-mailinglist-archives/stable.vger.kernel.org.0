Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A8E3A5F3F
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 11:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbhFNJnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 05:43:02 -0400
Received: from mail-ej1-f41.google.com ([209.85.218.41]:36653 "EHLO
        mail-ej1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbhFNJnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 05:43:02 -0400
Received: by mail-ej1-f41.google.com with SMTP id nd37so7852618ejc.3
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 02:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ja1bm8uQ0jh/d0+nTm8jS2wS8bWGfI7Z1rAGyNRhrVY=;
        b=YMb6zoutyncIB7GrutvBlDXQjiA2eMiB48g09WNgwdHRjNVgOioo30rh8+3IA9d/Yp
         nrTqNNipDrL4Ubiwim2Fv0ldHugdmulRpGQw+ctyQH4ylD50bI2ReSWgwaW6t+6yIAVI
         BGlxxfd4zzHbyxYpgE5kR2PkIqgbfNNhbOKcMTC2ZWK6exLGHYeAhZ2bBtupApOecFWb
         P9uJ1sX5mr5lkfowoLfu/0Znw+EfMxfd5flvlt/zEbtFe28SuRjCYbL7MBKHcFdcUIhU
         tDHmn+/T7fmtudcsaQXNZxkNgTy1RZV8rCEYRKwXadR+wEvi8vpDRXteem3gNy0Dlicy
         8SbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ja1bm8uQ0jh/d0+nTm8jS2wS8bWGfI7Z1rAGyNRhrVY=;
        b=ogWFz33RwHwL8gioP72VlMuLbpsxumgt5IHtkKiG5lcwOVckH8Ji+eDegbjcLPt00K
         waeHo7w76SejX2GGGMnMdDWTK5MBu3YxDsaN6pfJuQyCOJBknjpak6vwpHmwRNjAf1K4
         WvKbau4U/KpQsD2AHHOD/ZsPZLobgmxVUzBJp2uv0hqhz4S5vPAbIj1d3xHDub8o8szj
         M091PpKlsMaGqjgpI+U9UAO6C0QT1hPXqlpVgfLhJjcocOaluALPD9P5PIrmAEq62I21
         XR3TuJRX4FMW/t5/6LYceMIdwzA3QD/C5sU0bxwD2xqwXL3bojQ2Q1VZzbjFPZmv9wni
         1QJA==
X-Gm-Message-State: AOAM530gYeSZnt86tTsZQPyT+i+N5LxGQxUHhd4xkYQ/fmuUGpAAql7D
        szkciZC3BK7hZJc1c+AobzOuByqLN7+jkky5K5XsVw==
X-Google-Smtp-Source: ABdhPJysQ/T0BUCgDYoHNJSlDsInWOV6oXdmJKT9lGLLPqxVqhaQ4PL3IdPEmd7SpoTK+SzcIguDY0qZbfkFDyq7BVw=
X-Received: by 2002:a17:906:d0da:: with SMTP id bq26mr14787800ejb.287.1623663598574;
 Mon, 14 Jun 2021 02:39:58 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYuBo_WgjtW1BugKLPeYnmLEe65zU7Ttt=FB2uqMzZy1eQ@mail.gmail.com>
 <YMYepbrAxKbgaXi8@kroah.com> <CA+G9fYsEwbLh2Tisdmsmb=yThZCmhWi4ZzqearrN_nQXStoJVA@mail.gmail.com>
 <YMbmsV7JYb7e1CVO@kroah.com> <CA+G9fYtBWywZDePUiwVDAAqhAdDKNtUtyZScJy01eO61o=5ppw@mail.gmail.com>
 <YMcU/ra96gxzlBhm@kroah.com> <YMcV4PfzrZWhmLOO@kroah.com>
In-Reply-To: <YMcV4PfzrZWhmLOO@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 14 Jun 2021 15:09:47 +0530
Message-ID: <CA+G9fYsqbiWe=ducTfwX_fyi+WvsBn2Eibi0BuuTA_m3iGn-bg@mail.gmail.com>
Subject: Re: compiler.h:417:38: error: call to '__compiletime_assert_59'
 declared with attribute error: BUILD_BUG_ON failed: sizeof(_i) > sizeof(long)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Jun 2021 at 14:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jun 14, 2021 at 10:36:14AM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Jun 14, 2021 at 11:54:40AM +0530, Naresh Kamboju wrote:
> > > On Mon, 14 Jun 2021 at 10:48, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Mon, Jun 14, 2021 at 10:24:23AM +0530, Naresh Kamboju wrote:
> > > > > On Sun, 13 Jun 2021 at 20:35, Greg Kroah-Hartman
> > > > > <gregkh@linuxfoundation.org> wrote:
> > > > > >
> > > > > > On Sun, Jun 13, 2021 at 08:25:19PM +0530, Naresh Kamboju wrote:
> > > > > > > The following error was noticed on stable-rc 5.12, 5.10, 5.4, 4.19,
> > > > > > > 4.14, 4.9 and 4.4
> > > > > > > for i386 and arm.
> > > > > > >
> > > > > > > make --silent --keep-going --jobs=8
> > > > > > > O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm
> > > > > > > CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
> > > > > > > arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc'
> > > > > > > In file included from /builds/linux/include/linux/kernel.h:11,
> > > > > > >                  from /builds/linux/include/linux/list.h:9,
> > > > > > >                  from /builds/linux/include/linux/preempt.h:11,
> > > > > > >                  from /builds/linux/include/linux/hardirq.h:5,
> > > > > > >                  from /builds/linux/include/linux/kvm_host.h:7,
> > > > > > >                  from
> > > > > > > /builds/linux/arch/arm/kvm/../../../virt/kvm/kvm_main.c:18:
> > > > > > > In function '__gfn_to_hva_memslot',
> > > > > > >     inlined from '__gfn_to_hva_many.part.6' at
> > > > > > > /builds/linux/arch/arm/kvm/../../../virt/kvm/kvm_main.c:1446:9,
> > > > > > >     inlined from '__gfn_to_hva_many' at
> > > > > > > /builds/linux/arch/arm/kvm/../../../virt/kvm/kvm_main.c:1434:22:
> > > > > > > /builds/linux/include/linux/compiler.h:417:38: error: call to
> > > > > > > '__compiletime_assert_59' declared with attribute error: BUILD_BUG_ON
> > > > > > > failed: sizeof(_i) > sizeof(long)
> > > > > > >   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> > > > > > >                                       ^
> > > > > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > > > > >
> > > > > > > ref:
> > > > > > > https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1342604370#L389
> > > > > >
> > > > > > Odd.  Does Linus's tree have this problem?
> > > > > >
> > > > > > The only arm changes was in arch/arm/include/asm/cpuidle.h in the tree
> > > > > > right now.  There are some kvm changes, but they are tiny...
> > > > > >
> > > > > > Can you bisect this?
> > > > >
> > > > > The bisect script pointing to,
> > > > >
> > > > > commit 1aa1b47db53e0a66899d63103b3ac1d7f54816bc
> > > > > Author: Paolo Bonzini <pbonzini@redhat.com>
> > > > > Date:   Tue Jun 8 15:31:42 2021 -0400
> > > > >     kvm: avoid speculation-based attacks from out-of-range memslot accesses
> > > > >
> > > > >     commit da27a83fd6cc7780fea190e1f5c19e87019da65c upstream.
> > > >
> > > > Ah, so is Linus's tree also broken the same way?
> > >
> > > No.
> > > Linus's tree builds successfully.
> >
> > Odd.  Paolo, did your above commit da27a83fd6cc ("kvm: avoid
> > speculation-based attacks from out-of-range memslot accesses"), require
> > any other changes to get arm32 systems to build properly?
>
> Doh, I need 4422829e8053 ("kvm: fix previous commit for 32-bit builds")
> as well...
>
> Nevermind, will go queue that up right now...


The reported build issue is fixed now.

- Naresh
