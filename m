Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AA833C98D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 23:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhCOW6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 18:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbhCOW6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 18:58:21 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6ABC06174A
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 15:58:20 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id x4so52752549lfu.7
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 15:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tZjCk+P+jx5J0ycHj3LYEoImQk5e3nuq7wTJIjKCNTQ=;
        b=Uzcicgkrc66v8XkzJHGrOW4HJ2lQCfrjeMNCRoW2xmvUVWWKZjzgkFkLc+wviI+7U4
         pquGc+eoOr6bhX/UPQvADhJDIMesYjgy2t8Kdswuu3nMwL9EwozoseicDZbXWowBiQxM
         4a3TL1uckgkJ6CDm4aTm1Y3+m4eCkNW/XuGFN1w8KkUhCHfcU5FcPYbbCNIF5iVzPqQZ
         DIK0Alm7er1mDpu6S6B2o36h2/ZsGFPzwyhXwA11xSiKx0lmOa0Q5IjdEVg4hnUTEoqW
         5pH8WlClaXG7C2cVh3KPRRwFbGlsetPfwHFdMr0E5Ag43C2F0j01ZXjBd8NIh/MNLzC/
         9noQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tZjCk+P+jx5J0ycHj3LYEoImQk5e3nuq7wTJIjKCNTQ=;
        b=UL63qM4qMduhV/qm8a0uLCq0REpqX/KTYy1mnQcicL4NQzdQfHipk2iojPSGDgEGOK
         Bz/ivW3DOplr4MpzLG8saRE/doyMCFMICZEjkyAOS1PCypx7e1tDqUWwRdtj6/MOLLmw
         OVepbH99AlRUASK9tmR4kM6hZ0TDXVOa+JcWuB8g939TBIsBSmA9bq9ULH3KElcCJuZR
         jyfYjAoOWjsUQhORyw+U2+RUpLU+xekyUKYoV3+vL+rXZeVC10KfF6r8SFvGCjj2gHBF
         gYk9H35Lbp9v9GaQCNrENEuB4wcD4/KAiEb//IO4bbUJ7t/yQnLdFdmxELJp0B0fbeBp
         wYJQ==
X-Gm-Message-State: AOAM533v4OoakruIQu22D+LN1jDCMVsHzYHq3uVWy2mKarASRwT+Y8s2
        ktTFqvIRAxWVZxA3nrSFqIaB4p3CZku3MYqPkJwAsg==
X-Google-Smtp-Source: ABdhPJx+yE261Trq8JsxhICC/AK09aUx3g4UzqZG7iJ2PTAeRPzJ+us1CpZNRzfGv0RIZRUWLRhh6vkD1PshZMFvIDE=
X-Received: by 2002:a19:5055:: with SMTP id z21mr9074889lfj.297.1615849098902;
 Mon, 15 Mar 2021 15:58:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAKwvOdka=y54W=ssgCZRgr2B+NaYFHF07KnnNDfrwv79-geSQw@mail.gmail.com>
 <YEs+iaQzEQYNgXcw@kroah.com> <CAKwvOd=xr5je726djQeMMrZAuNcJpX9=R-X19epVy85cjbNbqw@mail.gmail.com>
 <YEw6i39k6hqZJS8+@sashalap> <YE8kIbyWKSojC1SV@kroah.com> <YE8k/2WTPFGwMpHk@kroah.com>
 <YE8l2qhycaGPYdNn@kroah.com> <CAMj1kXGLrVXZPAoxTtMueB9toeoktuKza-mRpd4vZ0SLN6bSSQ@mail.gmail.com>
 <CAKwvOdmJm3v3sHfopWXrSPFn46qaSX9cna=Nd+FZiN=Nz9zmQQ@mail.gmail.com> <CAMj1kXHfQmObPZaVOZu+0M3SKFKNg5vcKmyJMXQ3RTBCqho9WQ@mail.gmail.com>
In-Reply-To: <CAMj1kXHfQmObPZaVOZu+0M3SKFKNg5vcKmyJMXQ3RTBCqho9WQ@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 15 Mar 2021 15:58:07 -0700
Message-ID: <CAKwvOdm6FXWVu-9YkQNNyoYmw+hkj1a7MQrRbWyUxsO2vDcnQA@mail.gmail.com>
Subject: Re: ARCH=arm LLVM_IAS=1 patches for 5.10, 5.4, and 4.19
To:     Ard Biesheuvel <ardb@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
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

Ok, I see what went wrong.  I had tested allyesconfig and allmodconfig
on 5.4.y, but neither of those selects CONFIG_KVM=y for arm;
axm55xx_defconfig is literally the only config (out of 109) that does.

32b ARM KVM support was ripped out in
commit 541ad0150ca4 ("arm: Remove 32bit KVM host support")
which landed in v5.7-rc1. So when
commit 2cbd1cc3dcd3 ("ARM: 8991/1: use VFP assembler mnemonics if available")
was written, arch/arm/kvm/ no longer existed. If it did, then
2cbd1cc3dcd3 would have needed something like
https://gist.github.com/nickdesaulniers/980e68e9c0680fff06b1b64f2b973171.
And allmodconfig/allyesconfig testing wouldn't have caught this, only
testing axm55xx_defconfig would have.  Before KVM support was dropped,
that was the only config that explicitly enabled the config that
failed.

On Mon, Mar 15, 2021 at 10:53 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Mon, 15 Mar 2021 at 18:43, Nick Desaulniers <ndesaulniers@google.com> wrote:
> >
> > f77ac2e378be doesn't apply cleanly to linux-5.4.y. There's a conflict
> > in arch/arm/vfp/vfphw.S due to 5.4 missing
> > commit 2cbd1cc3dcd3 ("ARM: 8991/1: use VFP assembler mnemonics if available")
> > which is one of the patches I sent in the 5.4 series in this thread.
> > That was 1 of a 3 patch series:
> > https://lore.kernel.org/linux-arm-kernel/cover.1593205699.git.stefan@agner.ch/
> >
> > Should I separate out just those 3 and f77ac2e378be and send that for
> > 5.4, or manually backport just f77ac2e378be and note in the commit
> > message the conflict?

I assume we still want a fix for THUMB2, so I'll send a backport of
just f77ac2e378be modified to note that there was a fixup against
2cbd1cc3dcd3, since 2cbd1cc3dcd3 is problematic for CONFIG_KVM=y on
5.4.

> You haven't explained why all this effort is justified to begin with.
>
> Who cares about being able to build 4.19 or 5.4 mainline with Clang 12
> and IAS?

Ah, sorry, ChromeOS and Android very much do so.  (Google's production
kernels as well, though I don't think they have any 32b ARM machines).
Android is already building 4.19+ with LLVM_IAS=1 for
ARCH=arm64,x86_64,i686. ChromeOS is doing so for 5.4+ for
ARCH=arm64,x86_64 as well.  I'm not sure precisely what's going on in
prodkernel land, but I know they have LLVM_IAS=1 enabled for x86_64.
So when Greg says this is "for no real users" I disagree.  Maybe no
one is using LLVM_IAS=1 for ARCH=arm at this moment, but that was the
point of the backports, to enable more distros to do so.

Stable has already accepted patches to 4.19+ for these architectures
where it was made explicit that this was for LLVM_IAS=1 support.
https://lore.kernel.org/stable/CAKwvOdk_U6SEwOC-ykaVTMu1ZmEjWC8cCiTetvU2k2dQ6WPCoQ@mail.gmail.com/
https://lore.kernel.org/stable/CAKwvOd=F_wWLxhnV3J8jx1L3SXPd8NFYyOKzAh7rL0iRb_aNyA@mail.gmail.com/
https://lore.kernel.org/stable/CAKwvOdmEcjjw78K0Avj-7s5BBXcT7ARhEMMEYqpCP-ZT=2dAJw@mail.gmail.com/
https://lore.kernel.org/stable/CAKwvOdnGDHn+Y+g5AsKvOFiuF7iVAJ8+x53SgWxH9ejqEZwY9w@mail.gmail.com/
https://lore.kernel.org/stable/CAKwvOdkK1LgLC4ChptzUTC45WvE9-Sn0OqtgF7-odNSw8xLTYA@mail.gmail.com/
https://lore.kernel.org/stable/CAKwvOd=x+fVo1_mMJUGHYXpmGf8UM5yx+uWD-Ci=y=0oFX2ktg@mail.gmail.com/
https://lore.kernel.org/stable/CAKwvOdn78WAUiRtyPxW7oEhUz8GN6MkL=Jt+n17jEQXPPZE77g@mail.gmail.com/

Now it's just down to ARM and THUMB2 support.  Then we will be using a
similar toolchain regardless of ISA.  We will also then have an
evergreen toolchain, rather than one that will not be receiving future
updates and is unsupported (which becomes a problem when folks need
new things and is a liability to be removed), and more wood behind
fewer arrows so we can focus on starting on the feature requests we
have piling up (like kernel GCC plugin-like features in LLVM, like a
code model for the kernel, etc).

This has been communicated to Android OEMs
(https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+/master/BINUTILS_KERNEL_DEPRECATION.md)
for them to help test and report issues and likely will also happen
for the next release of the NDK
(https://github.com/android/ndk/wiki/Changelog-r23#announcements).

> I am aware that Clang enablement is a prerequisite for CFI
> and LTO etcetera, and so I am fully on board with this activity for
> current and future kernels.

LTO does require LLVM_IAS=1 at the moment; there are no plans I know
of yet to port LTO to ARCH=arm, but maybe if Sami is bored? :P

> Stable kernels are a different matter, though. I tend to get
> stable-kernel-rules.rst thrown in my face for proposing backports that
> aren't nearly as large or intrusive as this stuff, but for some
> reason, those rules do not seem to apply here.

I understand.  I'm also balancing shipping patches for toolchain
support out of tree, vs upstreaming.  Everything so far has been
upstreamed, but 32b ARM support has been...more involved.  But I'm
hopeful that we will be able to expand our staff soon to better
improve that.

I think all of these patches would be useful to CrOS, so my plan was
to send the series upstream.  We can keep it downstream, where the
number of supported configurations and toolchains is more limited.
4.19+ is of interest for new Android devices this year, but 5.4 in
particular will live much longer, so we will have to carry the
divergence for longer.  I think some of the strictly UAL related
changes are relatively lower risk.

> So my suggestion would be to forget about 4.19 and 5.4 entirely for
> these changes, unless there is an obvious benefit to all consumers of
> these stable trees. Otherwise, exposing them to ongoing breakage like
> this is indefensible IMHO.
-- 
Thanks,
~Nick Desaulniers
