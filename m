Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDED247F05
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 09:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgHRHKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 03:10:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbgHRHKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 03:10:14 -0400
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E913C20888;
        Tue, 18 Aug 2020 07:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597734613;
        bh=nvaUJNFyV4vcax39lj23nhAOIb3Ku6tgS77eD620sJU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=e0WLaNjpcYHgH6zXxnkBdlCKn0O944BaciZPf+JQNO980yc9TgQNPCD2TcMz5Pjkf
         Ng1v9pjMccdNPSQIJmrbgszTNpWm98fB8zsrHqS3oJ9WA0AnTwXeqzUbYFQ0iRtMCS
         k5wTh75UzMHUECYh/LBWGl0S/F3lWeQnb49qTWoU=
Received: by mail-oi1-f178.google.com with SMTP id h3so17066677oie.11;
        Tue, 18 Aug 2020 00:10:12 -0700 (PDT)
X-Gm-Message-State: AOAM531HtQ/KuLTl1RIBRkciRlKShYAop4G7xC4vAJWJeTbMUa/AFgkS
        K1be+miq1s4YjGdubq47giNmA8Zj2QotONObPfA=
X-Google-Smtp-Source: ABdhPJw9HzTUd9lQlRMwnPZQSdMbm1DoI/CKErme58AW//8FBa3prxqrmj0wo63+SxVt1FSeD/n6r9X9HX4Sh4zSvqE=
X-Received: by 2002:aca:d8c5:: with SMTP id p188mr11327582oig.47.1597734612072;
 Tue, 18 Aug 2020 00:10:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200817220212.338670-1-ndesaulniers@google.com> <20200817220212.338670-2-ndesaulniers@google.com>
In-Reply-To: <20200817220212.338670-2-ndesaulniers@google.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 18 Aug 2020 09:10:01 +0200
X-Gmail-Original-Message-ID: <CAMj1kXH0gRCaoF0NziC870=eSEy0ghi8b0b6A+LMu8PMd58C0Q@mail.gmail.com>
Message-ID: <CAMj1kXH0gRCaoF0NziC870=eSEy0ghi8b0b6A+LMu8PMd58C0Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] Makefile: add -fno-builtin-stpcpy
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Joe Perches <joe@perches.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Daniel Axtens <dja@axtens.net>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Yury Norov <yury.norov@gmail.com>, X86 ML <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Bruce Ashfield <bruce.ashfield@gmail.com>,
        Marco Elver <elver@google.com>,
        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        Andi Kleen <ak@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?B?RMOhdmlkIEJvbHZhbnNrw70=?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Aug 2020 at 00:02, Nick Desaulniers <ndesaulniers@google.com> wr=
ote:
>
> LLVM implemented a recent "libcall optimization" that lowers calls to
> `sprintf(dest, "%s", str)` where the return value is used to
> `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
> in parsing format strings. This optimization was introduced into
> clang-12. Because the kernel does not provide an implementation of
> stpcpy, we observe linkage failures for almost all targets when building
> with ToT clang.
>
> The interface is unsafe as it does not perform any bounds checking.
> Disable this "libcall optimization" via `-fno-builtin-stpcpy`.
>
> Unlike
> commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")
> which cited failures with `-fno-builtin-*` flags being retained in LLVM
> LTO, that bug seems to have been fixed by
> https://reviews.llvm.org/D71193, so the above sha can now be reverted in
> favor of `-fno-builtin-bcmp`.
>
> Cc: stable@vger.kernel.org # 4.4

Why does a fix for Clang-12 have to be backported all the way to v4.4?
How does that meet the requirements for stable patches?

> Link: https://bugs.llvm.org/show_bug.cgi?id=3D47162
> Link: https://github.com/ClangBuiltLinux/linux/issues/1126
> Link: https://reviews.llvm.org/D85963
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Suggested-by: D=C3=A1vid Bolvansk=C3=BD <david.bolvansky@gmail.com>
> Suggested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  Makefile | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/Makefile b/Makefile
> index 9cac6fde3479..211a1b6f6478 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -959,6 +959,12 @@ ifdef CONFIG_RETPOLINE
>  KBUILD_CFLAGS +=3D $(call cc-option,-fcf-protection=3Dnone)
>  endif
>
> +# The compiler may "libcall optimize" certain function calls into the be=
low
> +# functions, for architectures that don't use -ffreestanding. If we don'=
t plan
> +# to provide implementations of these routines, then prevent the compile=
r from
> +# emitting calls to what will be undefined symbols.
> +KBUILD_CFLAGS  +=3D -fno-builtin-stpcpy
> +
>  # include additional Makefiles when needed
>  include-y                      :=3D scripts/Makefile.extrawarn
>  include-$(CONFIG_KASAN)                +=3D scripts/Makefile.kasan
> --
> 2.28.0.220.ged08abb693-goog
>
