Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB4F4A7A0A
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 22:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245090AbiBBVKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 16:10:45 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:54579 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347506AbiBBVKn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 16:10:43 -0500
Received: from mail-oi1-f171.google.com ([209.85.167.171]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MMXYH-1myWhi2ciN-00Jb5k; Wed, 02 Feb 2022 22:10:41 +0100
Received: by mail-oi1-f171.google.com with SMTP id u13so780990oie.5;
        Wed, 02 Feb 2022 13:10:41 -0800 (PST)
X-Gm-Message-State: AOAM530qkSl4+UfMV8A9YCv2RTbLfzxA767mifVOMTVtTNiFCKLNV2Rg
        B/jv6BnmoA5aKMx9ahkwEZOZlARXc24GxEhIhGg=
X-Google-Smtp-Source: ABdhPJzNNV1PsobnG4ytJe/wQRKYy2+E1S6E16gyzyR5hGbLwWH2WkP08ud6edjeejSYC3jt2abMaIRC7f80+kKHXDU=
X-Received: by 2002:aca:2b16:: with SMTP id i22mr5181074oik.128.1643836239885;
 Wed, 02 Feb 2022 13:10:39 -0800 (PST)
MIME-Version: 1.0
References: <20220201232229.2992968-1-nathan@kernel.org> <CAK8P3a2Y8nQ55sycxbpfN=71BNO9wuEDt=Q24ELS_u_WNRpqZw@mail.gmail.com>
 <YfqwnMB2lLXOuahI@dev-arch.archlinux-ax161>
In-Reply-To: <YfqwnMB2lLXOuahI@dev-arch.archlinux-ax161>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 2 Feb 2022 22:10:23 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2FjtM-dEkCnUAG8y8-EL7tqBk7qvyfaAs853jpFsfiPQ@mail.gmail.com>
Message-ID: <CAK8P3a2FjtM-dEkCnUAG8y8-EL7tqBk7qvyfaAs853jpFsfiPQ@mail.gmail.com>
Subject: Re: [PATCH] Makefile.extrawarn: Move -Wunaligned-access to W=2
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev, "# 3.4.x" <stable@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:n3NVUWI6c5VgDykHIuBin0hYgDycraNwG551Xxxssvht+iKoQRG
 XueLS1r78eRjX+Y7wzdhfiPFEYs9MSm4y8cl8tnDuQS0R9IN/ZUHoIX5uj72QphUOXqILUk
 kIj4GtUTFcLOtw/jG3ic8brB+4APgAfQyQMoizPwkQbF6ixiBES/EhMB+S006IYIq8jBhXz
 Fi6shtZdke8BmTPTPFZ/g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:bdofIytOYTM=:rSHZBqdFBhzEDpPxuH2K36
 uPcrSePq4fykTYwfzK24p4Pb/Mvl7iKqqm0vKOEpBvNQhy90HD+NT2b58m1Wavqq9lToOOy1f
 jYPxPWl1ZylZI7PUyyv+5dszhWpuuxkx8pU1wTCsiLGSkCBjlqYuzokRAFfBq/yGCdUDCp7gE
 NkNoVl41QYrzGrVGUyBG4Q9po3M4Gykjb4iNLz29+q0a2fK+EQNlRtkIsB4tZC5HCtCMEK0yc
 tnaL3qJ1FjMLUCpIDREsD+58BxrS8heiTj8CBIk9JdNLKuaoS/gfVJhlmUVh1hedVogdCp88N
 See5Ardn0c7Ru3twSORBGyAtY+a5b3aSxJLaEn/LgU9a8o42UlapzvyYYGbv6eNx2G26H2mhv
 LokCFjikjDd6QKEh7kiYwgAnqimxSjcBqJYjrFwXABrACkrn3voTZ7aHV3zjjEkoF+iHLwDb5
 XAB+3AqIB70T2t14IctXMxlBZLTu3chhMLEfIKEJj0YSrmuqLvd9q68xd1ai9kxRgtLtiAj6+
 IDdMKar+88PEUnX3FTt+GSC60ItA6pgIAPtiujIAOonL0ReUYE+TWNFDBhXdm3FwCNCFYywMM
 zUJbmeKodtRmxdOJYo4BuMLLUenwc8tBt0LeO/npvGzxcy0ZeleXGMHGJQ8g5g3MlikF9dkX4
 Eso9nQ9YLlOkkFWcDi3ROBMdZsena9DVzMMmjn2FWZzJV2DGOhRkpp31B9nK4+Np6es8=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 2, 2022 at 5:26 PM Nathan Chancellor <nathan@kernel.org> wrote:
> On Wed, Feb 02, 2022 at 09:12:06AM +0100, Arnd Bergmann wrote:
> > On Wed, Feb 2, 2022 at 12:22 AM Nathan Chancellor <nathan@kernel.org> wrote:

>
> Fair point, I suppose barely anyone does W=2 builds, which means we
> might as well just disable it outright.
>
> > Can you point post the (sufficiently trimmed) output that you get with
> > the warning
> > enabled in an allmodconfig build?
>
> Sure thing.
>
> Here is the trimmed version:
>
> https://gist.github.com/nathanchance/6682e6894f75790059ca698c29212c71/raw/f63d54819afeb96f3ea0bb055096849912ac0185/trimmed.log
>
> Here is the full output of 'make ARCH=arm LLVM=1 allmodconfig':
>
> https://gist.github.com/nathanchance/6682e6894f75790059ca698c29212c71/raw/f63d54819afeb96f3ea0bb055096849912ac0185/full.log

Thanks, that does sound useful, and not that hard to fix. Since these
only warn about
structure definitions, I think in most cases we can either mark the
outer structure
as aligned or the inner one as unaligned, which will then avoid the
warning as well
as make the accesses to the inner structures standard conformant.

> > I'm not sure why this is enabled by default for arm64, which does not have
> > the problem with fixup handlers.
>
> It is not enabled for arm64 for the kernel. If I am reading the commit
> right, it is only enabled for arm64 when -mno-unaligned-access is passed
> or building for OpenBSD, which obviously don't apply to the kernel (see
> AArch64.cpp).

Ok

> For ARM, we see it in the kernel because it is enabled for any version less
> than 7, according to this block in clang/lib/Driver/ToolChains/Arch/ARM.cpp:
>
>     } else if (Triple.isOSLinux() || Triple.isOSNaCl() ||
>                Triple.isOSWindows()) {
>       if (VersionNum < 7) {
>         Features.push_back("+strict-align");
>         if (!ForAS)
>           CmdArgs.push_back("-Wunaligned-access");
>       }
>
> There is this comment above this block in the source code:
>
>     // Assume pre-ARMv6 doesn't support unaligned accesses.
>     //
>     // ARMv6 may or may not support unaligned accesses depending on the
>     // SCTLR.U bit, which is architecture-specific. We assume ARMv6
>     // Darwin and NetBSD targets support unaligned accesses, and others don't.

This does not match what we do on Linux though: While this is correct on ARMv5
and below, which has  there is no support for unaligned access and
also on ARMv7,
which has limited unaligned access in both LE and BE8 mode, Linux treats ARMv6
the same way as ARMv7 in practice. The reason is that ARMv6 can support
unaligned accesses both on little-endian mode and in BE8-mode, but obviously not
in ARMv5-style BE32 mode (this would swap the wrong bytes). Linux itself does
not run in ARMv6 BE32 mode because that would in turn not work on ARMv7,
in addition to not having unaligned accesses.

>     // ARMv7 always has SCTLR.U set to 1, but it has a new SCTLR.A bit
>     // which raises an alignment fault on unaligned accesses. Linux
>     // defaults this bit to 0 and handles it as a system-wide (not
>     // per-process) setting. It is therefore safe to assume that ARMv7+
>     // Linux targets support unaligned accesses. The same goes for NaCl
>     // and Windows.
>     //
>     // The above behavior is consistent with GCC.
>
> I notice that CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS under certain
> conditions in arch/arm/Kconfig. Would it be worth telling clang that it
> can generate unaligned accesses in those cases via -munaligned-access or
> would that be too expensive? If we did, these warnings would be
> eliminated for configs with CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y,
> then it could be safely placed under W=1.

It's complicated. For ARMv4/v5, we must never set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS because unaligned
accesses are not efficient there. For v6 and higher, most unaligned accesses
are fast and don't trap, so we set the flag, but there are two conflicting
interpretations of what the flag actually means:

- traditionally, it was interpreted as allowing architectures to safely pass
  around misaligned pointers and dereference them with normal load/store
  instructions, in violation of the ABI. This however does not work when
  the compiler generates ARMv6/v7/v8 aarch32 ldm/stm/ldrd/strd instructions
  that trigger an alignment fault, or with recent gcc versions that may cause
  unintended behavior when passed a misaligned pointer regardless of
  the architecture

- the new interpretation of the flag is that using get_unaligned()/
  put_unaligned() for accessing  a pointer is turned into a normal load/store
  instruction, which avoids both problems but requires code changes
  in some places that rely on direct pointer dereferences.

Ard has made some progress converting the remaining instances that get it
wrong, but I don't know how many more remain.

For the -munaligned-access flag, I did a quick test about the defaults,
and found that it does not behave as I would expect, see
https://www.godbolt.org/z/dxd9jMs3h :

- Building for ARMv6, an unaligned store gets turned into individual
  byte accesses in both gcc and clang, which matches the
  -mno-unaligned-access behavior and your exaplanation above.
  I'm fairly sure this is not what we want though, as the kernel already
  assumes that it can do unaligned ldr/str, just not ldrd/strd.
  A little more research would help here regarding why gcc and
  linux make different assumptions about ARMv6, but I think
  we actually want to pass -munaligned-access on ARMv6.

- For a trivial aligned store, clang and gcc behave differently --
  gcc uses strd for a 64-bit store, while clang uses two str.
  I don't know if this is an intentional difference, but I like the
  clang behavior here, because this avoids alignment faults in
  case we do get passed an unaligned pointer, at the expense
  of potentially wasting a few CPU cycles and some i-cache.
  Ideally there would be a third compiler flag in addition to
  -munaligned-access and -mno-unaligned-access that tells the
  compiler (ideally both gcc and clang of course) that unaligned
  ldr/str is allowed, but ldrd/strd/ldm/stm must be avoided even
  for pointers that are assumed to be aligned.

For the warning flag, I think we probably want this to be enabled
all the time (after we address the known problems), to be sure
that this does not cause traps on ARMv5, or on ARMv7 with gcc
generating ldrd/strd instructions on misaligned struct members.

         Arnd
