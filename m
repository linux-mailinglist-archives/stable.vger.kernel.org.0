Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D223F33C4D9
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 18:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhCORxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 13:53:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhCORxX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 13:53:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 021A064EED
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 17:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615830803;
        bh=QdG9jdlQj7w++8Z5oPjF64esXNDEl7O81fSVyG5mflo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ipNjx5ZYMSOGBx9n6XG8E8ZgQmzcks5+xT6Gs3omphbysciExYLjNaNbTWNvHI+jk
         CJx6fg+9si6BLLZ1xqkK8CiGStpsO//FUk5joLwXxw0IvX9o1drS0umIeFQwlREanE
         V6PoRb3GjBL0i06h5aLlkLwJtZI7YiO9UYLR35qoDsn26Oxeg/1l+h8Kyrd0I2sG7U
         ISzh7TkkMjOZT3Qo0P0J6hrQfGYFBvYg5UvoH6M6pQPiuvCK28QWsei2go1n3n4vxv
         NWd4wtUYV+zGSKgDMLEWTxKYOoarknArpwCffLJsD1o8yFts5nL2j0WjL06Z5ck/7D
         5GOzRA6WwMGCQ==
Received: by mail-ot1-f48.google.com with SMTP id 31-20020a9d00220000b02901b64b9b50b1so5562205ota.9
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 10:53:22 -0700 (PDT)
X-Gm-Message-State: AOAM532vOpv4tN6APEzha2HQoNfr8K+gcLBfJoYu6lA5OHSRl/hoXYTK
        yH5pUSkkuPWnXAfsgHGSjFIphFLy7HdMar9Imxk=
X-Google-Smtp-Source: ABdhPJzkmWyTgOqm+NWLNRU/LVWHOcgwVVCulNyhdeM0XQGaeVFoUGBZzC9festgoJRBvTgcL45TFaeVf3PYeYn8LZY=
X-Received: by 2002:a9d:42c:: with SMTP id 41mr268639otc.108.1615830802156;
 Mon, 15 Mar 2021 10:53:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAKwvOdka=y54W=ssgCZRgr2B+NaYFHF07KnnNDfrwv79-geSQw@mail.gmail.com>
 <YEs+iaQzEQYNgXcw@kroah.com> <CAKwvOd=xr5je726djQeMMrZAuNcJpX9=R-X19epVy85cjbNbqw@mail.gmail.com>
 <YEw6i39k6hqZJS8+@sashalap> <YE8kIbyWKSojC1SV@kroah.com> <YE8k/2WTPFGwMpHk@kroah.com>
 <YE8l2qhycaGPYdNn@kroah.com> <CAMj1kXGLrVXZPAoxTtMueB9toeoktuKza-mRpd4vZ0SLN6bSSQ@mail.gmail.com>
 <CAKwvOdmJm3v3sHfopWXrSPFn46qaSX9cna=Nd+FZiN=Nz9zmQQ@mail.gmail.com>
In-Reply-To: <CAKwvOdmJm3v3sHfopWXrSPFn46qaSX9cna=Nd+FZiN=Nz9zmQQ@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 15 Mar 2021 18:53:10 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHfQmObPZaVOZu+0M3SKFKNg5vcKmyJMXQ3RTBCqho9WQ@mail.gmail.com>
Message-ID: <CAMj1kXHfQmObPZaVOZu+0M3SKFKNg5vcKmyJMXQ3RTBCqho9WQ@mail.gmail.com>
Subject: Re: ARCH=arm LLVM_IAS=1 patches for 5.10, 5.4, and 4.19
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>, Stefan Agner <stefan@agner.ch>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>, candle.sun@unisoc.com,
        =?UTF-8?B?TWlsZXMgQ2hlbiAo6Zmz5rCR5qi6KQ==?= 
        <miles.chen@mediatek.com>, Stephen Hines <srhines@google.com>,
        Luis Lozano <llozano@google.com>,
        Sandeep Patil <sspatil@google.com>,
        Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Mar 2021 at 18:43, Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Mon, Mar 15, 2021 at 3:37 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > Note that the 5.4 Thumb2 build is still broken today because
> > it carries
> >
> > eff8728fe698 vmlinux.lds.h: Add PGO and AutoFDO input sections
> >
> > but does not carry
> >
> > f77ac2e378be ARM: 9030/1: entry: omit FP emulation for UND exceptions
> > taken in kernel mode
> >
> > which is tagged as a fix for the former patch, and landed in v5.11.
> > (Side question: anyone have a clue why the patch in question was never
> > selected for backporting?)
>
> I will follow up on the rest, but some quick forensics.
>
> f77ac2e378be ("ARM: 9030/1: entry: omit FP emulation for UND
> exceptions taken in kernel mode")
>
> was selected for inclusion into 5.10.y on 2020-12-20:
> https://lore.kernel.org/stable/20201228125038.405690346@linuxfoundation.org/
>
> I actually don't have a
> Subject: FAILED: patch "[PATCH] <oneline>" failed to apply to X.YY-stable tree
> email for this, which seems unusual. I don't know if one wasn't sent,
> or message engine had a hiccup or what, so I don't know if it simply
> failed to apply to older trees.  Ard, did you as the author receive
> such an email?  Usually everyone cc'ed on the patch gets such emails
> from autosel, it looks like.
>

Not that I am aware of, no.

> Then *later*
> eff8728fe698 ("vmlinux.lds.h: Add PGO and AutoFDO input sections")
> was sent to stable on 2021-01-13:
> https://lore.kernel.org/stable/20210113185758.GA571703@ubuntu-m3-large-x86/
>
> I was cc'ed on both, and didn't notice or forgot that one had
> additional fixes necessary.  My mistake.
>

So it was backported after it already been identified as being broken?
That makes it even worse, imho.

> I think one way to avoid that in the future in a semi automated
> fashion would be to have an in tree script like checkpatch that given
> a sha from mainline would check git log for any Fixes tag that may
> exist on subsequent patches.  Then it should be possible for any patch
> that itself is backported (contains "commit XXX upstream") to be fed
> in when auto selected or submitted to stable (or before then) to check
> for new fixes.  Probably would still need to be run periodically, as
> Fixes: aren't necessarily available when AutoSel runs.  For the
> toolchain, we have a bot that watches for reverts for example, but
> non-standard commit messages denoting one patch fixes another makes
> this far from perfect.  Would still need to be run periodically,
> because if a Fixes: exists, but hasn't been merged yet, it could get
> missed.
>
> Though I'm curious how the machinery that picks up Fixes: tags works.
> Does it run on a time based cadence?  Is it only run as part of
> AutoSel, but not for manual backports sent to the list?  Would it have
> picked up on f77ac2e378be at some point?
>
> f77ac2e378be doesn't apply cleanly to linux-5.4.y. There's a conflict
> in arch/arm/vfp/vfphw.S due to 5.4 missing
> commit 2cbd1cc3dcd3 ("ARM: 8991/1: use VFP assembler mnemonics if available")
> which is one of the patches I sent in the 5.4 series in this thread.
> That was 1 of a 3 patch series:
> https://lore.kernel.org/linux-arm-kernel/cover.1593205699.git.stefan@agner.ch/
>
> Should I separate out just those 3 and f77ac2e378be and send that for
> 5.4, or manually backport just f77ac2e378be and note in the commit
> message the conflict?
>

You haven't explained why all this effort is justified to begin with.

Who cares about being able to build 4.19 or 5.4 mainline with Clang 12
and IAS? I am aware that Clang enablement is a prerequisite for CFI
and LTO etcetera, and so I am fully on board with this activity for
current and future kernels.

Stable kernels are a different matter, though. I tend to get
stable-kernel-rules.rst thrown in my face for proposing backports that
aren't nearly as large or intrusive as this stuff, but for some
reason, those rules do not seem to apply here.

So my suggestion would be to forget about 4.19 and 5.4 entirely for
these changes, unless there is an obvious benefit to all consumers of
these stable trees. Otherwise, exposing them to ongoing breakage like
this is indefensible IMHO.

-- 
Ard.



> eff8728fe698 was sent back to 4.4, so if it's easy to reproduce the
> observed failure, we can test to see if branches older than 5.4 are
> also affected.  It sounds like eff8728fe698 was merged 2021-01-15, so
> THUMB2 would have been broken since then. I didn't see any reports on
> https://lore.kernel.org/stable/20210113185758.GA571703@ubuntu-m3-large-x86/;
> was this reported elsewhere earlier? Did automated testing help find
> this, or was it found manually just now?  I'm curious if there's a way
> to expand our automated coverage since this eluded us?
>
> commit 3ce47d95b734 ("powerpc: Handle .text.{hot,unlikely}.* in linker script")
> is the only other commit in mainline that refers to eff8728fe698, but
> doesn't use that in its Fixes tag.  I don't see any other follow up
> patches (yet! *ducks*).
> --
> Thanks,
> ~Nick Desaulniers
