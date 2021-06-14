Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41663A5C4A
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 06:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhFNE4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 00:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhFNE4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 00:56:47 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FDDC061574
        for <stable@vger.kernel.org>; Sun, 13 Jun 2021 21:54:36 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id u24so44685530edy.11
        for <stable@vger.kernel.org>; Sun, 13 Jun 2021 21:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9C6jMbiLXffjIwXDedqlh1ig0D8ZwixuR0hdHIftrkw=;
        b=bA2Ly0yZd4ZKYJFVF1jJzN/oCKCwiW8siQOmh3aIXN1ICTe0DuE/jdgN7VnDH8YhF3
         a9MGKFZZs82Obd8pj6GUSQrqMoyWEZZnC58kwzfl1TTLIZTU485/4CicaAIhc9qpOJoV
         h5xRgyc/PNqqTlbjim9tuChLPyAdg/v/cJVyrCYIEms7bz+WVyO8EyT60VKRrqhPI++c
         TjaF8KX9Tci1ohLsbFS+IuJkL8W2DqoayuBcQSAh6NtidKsG78ZML3ShLUEyJtaGsWpF
         M25OezF9A7JdTdlc8sHvZwM3gi9c8FLAZTR5fv/FdGhW58EHUVD3Fp3PiDpFleETnqw1
         qxig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9C6jMbiLXffjIwXDedqlh1ig0D8ZwixuR0hdHIftrkw=;
        b=V3nm7M1NvIVpIu+MG8XyXIYVNk3mTrNY2t0SC5JBMUvVwB9pNuADLchaH+ZF21VWhG
         we4RYubilqWNV6ASvkNB58jm/YcC3x/Jy4/DPkbq6EXCYP+AJ8YfSYpHp+0lmdmSUSTn
         xW+HyhXf/wQPJHQQSRwopBJLs/TAbsv731aGvYSVnn7VrUQnZTQ32q2KJXIsk5g2erpF
         HyJZhn7alkO6tX31O67+JpTF6U8xFkQ6HabiTY1Az8H6gzk5awTQSglcmm7K3+dLuX/2
         9VbdFZ2FMiuDrl8S8M0WX4I36JjA7KwmmTWqNin9+eo5+cnE7gAjQAt9xM2IWHqe2NLw
         FXVw==
X-Gm-Message-State: AOAM533Lnijw4hga+Vh5qauSAuJDo/PZ8bBRroJfGwuN2FKzx+BiaUHm
        566GLpiolLDtwk/7xGq2ynpet5rZI9vJcz5CyLgruw==
X-Google-Smtp-Source: ABdhPJwFSfHQVi5BLo/WjCXFex8Nl9cpU6MU2hqbV+0QS/ZNTgBvoLAz5+TBwGmpfGitA+z1DTC6Xmk+Rs8pLfRgYBU=
X-Received: by 2002:aa7:de18:: with SMTP id h24mr15025453edv.23.1623646474643;
 Sun, 13 Jun 2021 21:54:34 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYuBo_WgjtW1BugKLPeYnmLEe65zU7Ttt=FB2uqMzZy1eQ@mail.gmail.com>
 <YMYepbrAxKbgaXi8@kroah.com>
In-Reply-To: <YMYepbrAxKbgaXi8@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 14 Jun 2021 10:24:23 +0530
Message-ID: <CA+G9fYsEwbLh2Tisdmsmb=yThZCmhWi4ZzqearrN_nQXStoJVA@mail.gmail.com>
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

On Sun, 13 Jun 2021 at 20:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sun, Jun 13, 2021 at 08:25:19PM +0530, Naresh Kamboju wrote:
> > The following error was noticed on stable-rc 5.12, 5.10, 5.4, 4.19,
> > 4.14, 4.9 and 4.4
> > for i386 and arm.
> >
> > make --silent --keep-going --jobs=8
> > O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm
> > CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
> > arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc'
> > In file included from /builds/linux/include/linux/kernel.h:11,
> >                  from /builds/linux/include/linux/list.h:9,
> >                  from /builds/linux/include/linux/preempt.h:11,
> >                  from /builds/linux/include/linux/hardirq.h:5,
> >                  from /builds/linux/include/linux/kvm_host.h:7,
> >                  from
> > /builds/linux/arch/arm/kvm/../../../virt/kvm/kvm_main.c:18:
> > In function '__gfn_to_hva_memslot',
> >     inlined from '__gfn_to_hva_many.part.6' at
> > /builds/linux/arch/arm/kvm/../../../virt/kvm/kvm_main.c:1446:9,
> >     inlined from '__gfn_to_hva_many' at
> > /builds/linux/arch/arm/kvm/../../../virt/kvm/kvm_main.c:1434:22:
> > /builds/linux/include/linux/compiler.h:417:38: error: call to
> > '__compiletime_assert_59' declared with attribute error: BUILD_BUG_ON
> > failed: sizeof(_i) > sizeof(long)
> >   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> >                                       ^
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > ref:
> > https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1342604370#L389
>
> Odd.  Does Linus's tree have this problem?
>
> The only arm changes was in arch/arm/include/asm/cpuidle.h in the tree
> right now.  There are some kvm changes, but they are tiny...
>
> Can you bisect this?

The bisect script pointing to,

commit 1aa1b47db53e0a66899d63103b3ac1d7f54816bc
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue Jun 8 15:31:42 2021 -0400
    kvm: avoid speculation-based attacks from out-of-range memslot accesses

    commit da27a83fd6cc7780fea190e1f5c19e87019da65c upstream.

    KVM's mechanism for accessing guest memory translates a guest physical
    address (gpa) to a host virtual address using the right-shifted gpa
    (also known as gfn) and a struct kvm_memory_slot.  The translation is
    performed in __gfn_to_hva_memslot using the following formula:

          hva = slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE

    It is expected that gfn falls within the boundaries of the guest's
    physical memory.  However, a guest can access invalid physical addresses
    in such a way that the gfn is invalid.

    __gfn_to_hva_memslot is called from kvm_vcpu_gfn_to_hva_prot, which first
    retrieves a memslot through __gfn_to_memslot.  While __gfn_to_memslot
    does check that the gfn falls within the boundaries of the guest's
    physical memory or not, a CPU can speculate the result of the check and
    continue execution speculatively using an illegal gfn. The speculation
    can result in calculating an out-of-bounds hva.  If the resulting host
    virtual address is used to load another guest physical address, this
    is effectively a Spectre gadget consisting of two consecutive reads,
    the second of which is data dependent on the first.

    Right now it's not clear if there are any cases in which this is
    exploitable.  One interesting case was reported by the original author
    of this patch, and involves visiting guest page tables on x86.  Right
    now these are not vulnerable because the hva read goes through get_user(),
    which contains an LFENCE speculation barrier.  However, there are
    patches in progress for x86 uaccess.h to mask kernel addresses instead of
    using LFENCE; once these land, a guest could use speculation to read
    from the VMM's ring 3 address space.  Other architectures such as ARM
    already use the address masking method, and would be susceptible to
    this same kind of data-dependent access gadgets.  Therefore, this patch
    proactively protects from these attacks by masking out-of-bounds gfns
    in __gfn_to_hva_memslot, which blocks speculation of invalid hvas.

    Sean Christopherson noted that this patch does not cover
    kvm_read_guest_offset_cached.  This however is limited to a few bytes
    past the end of the cache, and therefore it is unlikely to be useful in
    the context of building a chain of data dependent accesses.

    Reported-by: Artemiy Margaritov <artemiy.margaritov@gmail.com>
    Co-developed-by: Artemiy Margaritov <artemiy.margaritov@gmail.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 include/linux/kvm_host.h | 10 +++++++++-

- Naresh
