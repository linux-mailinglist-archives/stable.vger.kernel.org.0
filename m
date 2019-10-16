Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26B11D9319
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 15:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389791AbfJPNzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 09:55:19 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43271 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388087AbfJPNzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 09:55:19 -0400
Received: by mail-pf1-f194.google.com with SMTP id a2so14773464pfo.10
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 06:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aaUppV8qH9+oKD0e3JTizSF2n5oQBgfNTLofkGsoBd4=;
        b=ukzIJVQ2pFl09wsAu5eXbC7THVXe/23Pn8vQW6mE3D9YWJ8K3c/M8OJ7Ix48FHkN6/
         3LkYT8BFK7ItnZ88aVPSq8O5CEjId2S5Pf9Dtd9g2glEvklSeFGKaaQvL6GM9InhfHU9
         +6skNKDMkMHb8u5hAmrKc7VZ0Wbg7sko6ahcRl8bbnW7o8P3Ownlg3NS1SSyNPbxt6v3
         66WWXe1kw1BYLhN2eAgixqxw94pxxXwC+YgbiBLZZ6C7CMKt4zvOPPArfANXzQ2qC3kJ
         GnjlRFwCunKydfc8/5WUJ16VMX/ljy66nYmwJQXQa9wGwbJQdZV7V8BFowbfWqi4JMAB
         Iayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aaUppV8qH9+oKD0e3JTizSF2n5oQBgfNTLofkGsoBd4=;
        b=PnYFulAdWIO+P2t5lAGKgCANxCuEusB1WaJzn61OLokkZopLOSbAnIt9XH1AbPpbtV
         RzgPk24vlok4ae6A2giPb23z7jodHYiqRAhvGMrNR0P2RJPopfwcRKOoSf7ZdfY+uEif
         +FUnH6UBI6IXhOE7djJcvkxlZGkve3wnR0TdIvUdUQIG1MCad3KJvyV2Y1bQukj51D3z
         BitqP4Kk2ofLNI69OmN8Yjkn8oCkFolnKj3/hlYM3NX1H1O39W4HckfaIUQhIHvR/qnd
         25zhvrcpEhbD0kVsFe1fU01kCxy+ZoWAXiLdT2NkzXWNGeNW8VYHcVtgN6+lAR3LaJK3
         yW7g==
X-Gm-Message-State: APjAAAXlONTD6BQYonBdX/vxXJv925z44UkAJM1jvKzOFXT5BEeDxS3S
        imrB47Bw6DcckM3mmgtv32uoCRyTi1rS2d48iza7cg==
X-Google-Smtp-Source: APXvYqwIaLq5I7Ob9AIKVb3PU5oJ6Ix9O7TxarpzaSquKNXxtNGItIEeMeASyjxm4DdoRQeELmG0lMSwbvX9CAwTkgY=
X-Received: by 2002:a17:90a:6509:: with SMTP id i9mr5165430pjj.47.1571234117347;
 Wed, 16 Oct 2019 06:55:17 -0700 (PDT)
MIME-Version: 1.0
References: <cki.B4A567748F.PFM8G4WKXI@redhat.com> <805988176.6044584.1571038139105.JavaMail.zimbra@redhat.com>
 <CAAeHK+zxFWvCOgTYrMuD-oHJAFMn5DVYmQ6-RvU8NrapSz01mQ@mail.gmail.com>
 <20191014162651.GF19200@arrakis.emea.arm.com> <20191014213332.mmq7narumxtkqumt@willie-the-truck>
 <20191015152651.GG13874@arrakis.emea.arm.com> <20191015161453.lllrp2gfwa5evd46@willie-the-truck>
 <20191016042933.bemrrurjbghuiw73@willie-the-truck>
In-Reply-To: <20191016042933.bemrrurjbghuiw73@willie-the-truck>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Wed, 16 Oct 2019 15:55:06 +0200
Message-ID: <CAAeHK+wKup2EmhWSe7iJ=ZpUnsNmAfbOyuRf6VCdjJp1eMOK=A@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOKdjCBGQUlMOiBUZXN0IHJlcG9ydCBmb3Iga2VybmVsIDUuNC4wLXJjMi1kNmMyYw==?=
        =?UTF-8?B?MjMuY2tpIChzdGFibGUtbmV4dCk=?=
To:     Will Deacon <will@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Jan Stancek <jstancek@redhat.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        CKI Project <cki-project@redhat.com>,
        LTP List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Szabolcs Nagy <szabolcs.nagy@arm.com>,
        Dave P Martin <Dave.Martin@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 6:29 AM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Oct 15, 2019 at 05:14:53PM +0100, Will Deacon wrote:
> > On Tue, Oct 15, 2019 at 04:26:51PM +0100, Catalin Marinas wrote:
> > > On Mon, Oct 14, 2019 at 10:33:32PM +0100, Will Deacon wrote:
> > > > On Mon, Oct 14, 2019 at 05:26:51PM +0100, Catalin Marinas wrote:
> > > > > The options I see:
> > > > >
> > > > > 1. Revert commit 057d3389108e and try again to document that the memory
> > > > >    syscalls do not support tagged pointers
> > > > >
> > > > > 2. Change untagged_addr() to only 0-extend from bit 55 or leave the
> > > > >    tag unchanged if bit 55 is 1. We could mask out the tag (0 rather
> > > > >    than sign-extend) but if we had an mlock test passing ULONG_MASK,
> > > > >    then we get -ENOMEM instead of -EINVAL
> > > > >
> > > > > 3. Make untagged_addr() depend on the TIF_TAGGED_ADDR bit and we only
> > > > >    break the ABI for applications opting in to this new ABI. We did look
> > > > >    at this but the ptrace(PEEK/POKE_DATA) needs a bit more thinking on
> > > > >    whether we check the ptrace'd process or the debugger flags
> > > > >
> > > > > 4. Leave things as they are, consider the address space 56-bit and
> > > > >    change the test to not use LONG_MAX on arm64. This needs to be passed
> > > > >    by the sparc guys since they probably have a similar issue
> > > >
> > > > I'm in favour of (2) or (4) as long as there's also an update to the docs.
> > >
> > > With (4) we'd start differing from other architectures supported by
> > > Linux. This works if we consider the test to be broken. However, reading
> > > the mlock man page:
> > >
> > >        EINVAL The result of the addition addr+len was less than addr
> > >        (e.g., the addition may have resulted in an overflow).
> > >
> > >        ENOMEM Some of the specified address range does not correspond to
> > >        mapped pages in the address space of the process.
> > >
> > > There is no mention of EINVAL outside the TASK_SIZE, seems to fall more
> > > within the ENOMEM description above.
> >
> > Sorry, I was being too vague in my wording. What I was trying to say is I'm
> > ok with (2) or (4), but either way we need to update our ABI documentation
> > under Documentation/arm64/.
>
> Having looked at making that change, I actually think the text is ok as-is
> if we go with option (2). We only make guarantees about "valid tagged
> pointer", which are defined to "reference an address in the user process
> address space" and therefore must have bit 55 == 0.
>
> Untested patch below.
>
> Will
>
> --->8
>
> From 517d979e84191ae9997c9513a88a5b798af6912f Mon Sep 17 00:00:00 2001
> From: Will Deacon <will@kernel.org>
> Date: Tue, 15 Oct 2019 21:04:18 -0700
> Subject: [PATCH] arm64: tags: Preserve tags for addresses translated via TTBR1
>
> Sign-extending TTBR1 addresses when converting to an untagged address
> breaks the documented POSIX semantics for mlock() in some obscure error
> cases where we end up returning -EINVAL instead of -ENOMEM as a direct
> result of rewriting the upper address bits.
>
> Rework the untagged_addr() macro to preserve the upper address bits for
> TTBR1 addresses and only clear the tag bits for user addresses. This
> matches the behaviour of the 'clear_address_tag' assembly macro, so
> rename that and align the implementations at the same time so that they
> use the same instruction sequences for the tag manipulation.
>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Link: https://lore.kernel.org/stable/20191014162651.GF19200@arrakis.emea.arm.com/
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Andrey Konovalov <andreyknvl@google.com>

Thanks!

> ---
>  arch/arm64/include/asm/asm-uaccess.h |  7 +++----
>  arch/arm64/include/asm/memory.h      | 10 ++++++++--
>  arch/arm64/kernel/entry.S            |  4 ++--
>  3 files changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/include/asm/asm-uaccess.h b/arch/arm64/include/asm/asm-uaccess.h
> index f74909ba29bd..5bf963830b17 100644
> --- a/arch/arm64/include/asm/asm-uaccess.h
> +++ b/arch/arm64/include/asm/asm-uaccess.h
> @@ -78,10 +78,9 @@ alternative_else_nop_endif
>  /*
>   * Remove the address tag from a virtual address, if present.
>   */
> -       .macro  clear_address_tag, dst, addr
> -       tst     \addr, #(1 << 55)
> -       bic     \dst, \addr, #(0xff << 56)
> -       csel    \dst, \dst, \addr, eq
> +       .macro  untagged_addr, dst, addr
> +       sbfx    \dst, \addr, #0, #56
> +       and     \dst, \dst, \addr
>         .endm
>
>  #endif
> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> index b61b50bf68b1..c23c47360664 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -215,12 +215,18 @@ static inline unsigned long kaslr_offset(void)
>   * up with a tagged userland pointer. Clear the tag to get a sane pointer to
>   * pass on to access_ok(), for instance.
>   */
> -#define untagged_addr(addr)    \
> +#define __untagged_addr(addr)  \
>         ((__force __typeof__(addr))sign_extend64((__force u64)(addr), 55))
>
> +#define untagged_addr(addr)    ({                                      \
> +       u64 __addr = (__force u64)addr;                                 \
> +       __addr &= __untagged_addr(__addr);                              \
> +       (__force __typeof__(addr))__addr;                               \
> +})
> +
>  #ifdef CONFIG_KASAN_SW_TAGS
>  #define __tag_shifted(tag)     ((u64)(tag) << 56)
> -#define __tag_reset(addr)      untagged_addr(addr)
> +#define __tag_reset(addr)      __untagged_addr(addr)
>  #define __tag_get(addr)                (__u8)((u64)(addr) >> 56)
>  #else
>  #define __tag_shifted(tag)     0UL
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index e304fe04b098..9ae336cc5833 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -604,7 +604,7 @@ el1_da:
>          */
>         mrs     x3, far_el1
>         inherit_daif    pstate=x23, tmp=x2
> -       clear_address_tag x0, x3
> +       untagged_addr   x0, x3
>         mov     x2, sp                          // struct pt_regs
>         bl      do_mem_abort
>
> @@ -808,7 +808,7 @@ el0_da:
>         mrs     x26, far_el1
>         ct_user_exit_irqoff
>         enable_daif
> -       clear_address_tag x0, x26
> +       untagged_addr   x0, x26
>         mov     x1, x25
>         mov     x2, sp
>         bl      do_mem_abort
> --
> 2.23.0.700.g56cf767bdb-goog
>
