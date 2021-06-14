Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B6C3A5D0F
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 08:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbhFNG2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 02:28:11 -0400
Received: from mail-ej1-f54.google.com ([209.85.218.54]:33491 "EHLO
        mail-ej1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbhFNG2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 02:28:08 -0400
Received: by mail-ej1-f54.google.com with SMTP id g20so14743413ejt.0
        for <stable@vger.kernel.org>; Sun, 13 Jun 2021 23:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OF2+ZQxBhUjZ+uMl4Jz5Kcir/GKwJGai7yR7rlacUK8=;
        b=oDvB7CQs44N7js5QLU0KkCxqawUaGypIzHdULfItgileS7P2l+Ezd2bkx2Ve9bkeyk
         /9/B3DLuL3xIZIETaaVpNXbTVjRg0CARhynDwVQP/gthrl3iBMmwJx4VlyOb413hlqp1
         ex3AObbziTvxQnmZ04w5enUu/6BvGfezx/6tXFoT5nAUc/MtI9oJvaDkGlpJYbXjP/UV
         2yixHKK8sj/4vGBdIxX9siCgGdYS3a9WiVIrqMmYsnkfVbWbKVfIdEg4vst7MFDNIV3M
         E8qfYjaXzeY3qwTtQY1j2YZhs3LjHnAPwJwidEpaWVDBk3jbaAvbCZjzxYCsOnZPxuh+
         dILw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OF2+ZQxBhUjZ+uMl4Jz5Kcir/GKwJGai7yR7rlacUK8=;
        b=YfZSZILQJKl8Ymu1IZsHXzrueaSplYkpQ4qGcSqfFWZmHf5CCnI27NYeMXp9EbsfBh
         bx4VkLIL7zYv1B3CSRlh3tBkVLpDfR+mwvTbF7xmM+kM22pSYej7m3swGrrxiFI2065P
         FzuxDAuUxWRmMt/VSfjhzIUXmWNL43DqaygfQuuDq1ndUcRBgwua0NGtW2BIQriT0+NW
         f6fqHkM18gLroXvd2lf01hurOuHh5yN8NzZvQTSyb9lZrU6fJ5rRMHGYGjxzQGORfVt4
         rGzgKhf+fF61TCLXCGdqr3kTsuUhbddhlqOb49DgfwGH9qEUAeqSXWjQXOeKuhvdBCDo
         /eqw==
X-Gm-Message-State: AOAM530fD4wvE5ipzHLLkZMaHwvuhZ07Qm8xsVcfJxoo1k29ffpgnjGD
        77gUgH4NUaQrDWp4iTL3VKVSzas/VevPM2wpJoahY2weOaTxKw==
X-Google-Smtp-Source: ABdhPJwvfdFus6zLxh3DOxnK1Y9spBTuDEgKTqquHn4a+kH95LIy8lnnIWvVE+hVoG5uTBnk69r5OMX44Ie2XCktlYI=
X-Received: by 2002:a17:906:9d05:: with SMTP id fn5mr13561173ejc.133.1623651892205;
 Sun, 13 Jun 2021 23:24:52 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYuBo_WgjtW1BugKLPeYnmLEe65zU7Ttt=FB2uqMzZy1eQ@mail.gmail.com>
 <YMYepbrAxKbgaXi8@kroah.com> <CA+G9fYsEwbLh2Tisdmsmb=yThZCmhWi4ZzqearrN_nQXStoJVA@mail.gmail.com>
 <YMbmsV7JYb7e1CVO@kroah.com>
In-Reply-To: <YMbmsV7JYb7e1CVO@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 14 Jun 2021 11:54:40 +0530
Message-ID: <CA+G9fYtBWywZDePUiwVDAAqhAdDKNtUtyZScJy01eO61o=5ppw@mail.gmail.com>
Subject: Re: compiler.h:417:38: error: call to '__compiletime_assert_59'
 declared with attribute error: BUILD_BUG_ON failed: sizeof(_i) > sizeof(long)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Jun 2021 at 10:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jun 14, 2021 at 10:24:23AM +0530, Naresh Kamboju wrote:
> > On Sun, 13 Jun 2021 at 20:35, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Sun, Jun 13, 2021 at 08:25:19PM +0530, Naresh Kamboju wrote:
> > > > The following error was noticed on stable-rc 5.12, 5.10, 5.4, 4.19,
> > > > 4.14, 4.9 and 4.4
> > > > for i386 and arm.
> > > >
> > > > make --silent --keep-going --jobs=8
> > > > O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm
> > > > CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
> > > > arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc'
> > > > In file included from /builds/linux/include/linux/kernel.h:11,
> > > >                  from /builds/linux/include/linux/list.h:9,
> > > >                  from /builds/linux/include/linux/preempt.h:11,
> > > >                  from /builds/linux/include/linux/hardirq.h:5,
> > > >                  from /builds/linux/include/linux/kvm_host.h:7,
> > > >                  from
> > > > /builds/linux/arch/arm/kvm/../../../virt/kvm/kvm_main.c:18:
> > > > In function '__gfn_to_hva_memslot',
> > > >     inlined from '__gfn_to_hva_many.part.6' at
> > > > /builds/linux/arch/arm/kvm/../../../virt/kvm/kvm_main.c:1446:9,
> > > >     inlined from '__gfn_to_hva_many' at
> > > > /builds/linux/arch/arm/kvm/../../../virt/kvm/kvm_main.c:1434:22:
> > > > /builds/linux/include/linux/compiler.h:417:38: error: call to
> > > > '__compiletime_assert_59' declared with attribute error: BUILD_BUG_ON
> > > > failed: sizeof(_i) > sizeof(long)
> > > >   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> > > >                                       ^
> > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > >
> > > > ref:
> > > > https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1342604370#L389
> > >
> > > Odd.  Does Linus's tree have this problem?
> > >
> > > The only arm changes was in arch/arm/include/asm/cpuidle.h in the tree
> > > right now.  There are some kvm changes, but they are tiny...
> > >
> > > Can you bisect this?
> >
> > The bisect script pointing to,
> >
> > commit 1aa1b47db53e0a66899d63103b3ac1d7f54816bc
> > Author: Paolo Bonzini <pbonzini@redhat.com>
> > Date:   Tue Jun 8 15:31:42 2021 -0400
> >     kvm: avoid speculation-based attacks from out-of-range memslot accesses
> >
> >     commit da27a83fd6cc7780fea190e1f5c19e87019da65c upstream.
>
> Ah, so is Linus's tree also broken the same way?

No.
Linus's tree builds successfully.

- Naresh
