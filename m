Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E266B24525F
	for <lists+stable@lfdr.de>; Sat, 15 Aug 2020 23:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgHOVqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 17:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728091AbgHOVpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Aug 2020 17:45:46 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B766C03D1CD;
        Sat, 15 Aug 2020 14:27:24 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a14so11314465wra.5;
        Sat, 15 Aug 2020 14:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=u28AimZhxuDc0O06Kto7WiSdTEZqFlRZrrriVNz5/Zg=;
        b=EIJxBTj3AD+CPhayl3emCNbyRao/vVZ1wQeMcALRvoMnuXgs5gXU8JEHNcx9R3uW0d
         DuXE8mx8lDbduWqgUqua0gaMUvGpfj0naxkHUQqZde1dF7soP1ITp9zxYFQ2xb5OFO6V
         zyxViF7c3EziK5OUZHR50+kGU9WBwX1xI48SIL1IiMvaq7WZ+xeJl0iyoi+ZDFw4mYug
         UFfgIkotILqh1fuZRNSrKJ/btAnCjC/ZknEGgvwvhLxXay430DKEHSh7vhSYG5SkdJAe
         erah8eghBhV8goDKylFA4jmrCSJAs55bdMzT/Z9927s+T/B41G1beO1aXthqDJdQfDuo
         XYCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=u28AimZhxuDc0O06Kto7WiSdTEZqFlRZrrriVNz5/Zg=;
        b=ZkXCiGbWDuCtnV3RMG6toQaShjIgD0UizeemJ7J86C38ZYOibWUfh9XCgBkoNcCDFR
         Vix4QRwKi/zfNsi6TwgWaNoOf8i4ugTc+dIuzbLOqRtug0c/YcS4EffopvTmElSFsNUs
         1k+3QA8d+Va2szLTRzN+bu/Oli4xa7b65Gsv7wmgRZVQqq/x+4qQP8UhsM/fQ5/zEfoz
         jAC3MjnrAJ6F4dm2ejae32yEvdGyH233rgNu5eeUu+ZaAGLjcd551R2vS9ZbzF4gudz9
         dARdqOhrB8F6z7SrlCje3wm7Qzz5Q1DIEzwMWthXlVVaAi7P1K54PxQCkcwkUtNPLNIK
         JKCQ==
X-Gm-Message-State: AOAM530gHnYsUpy7/u6w1kSjGfL/J6l1bCzuZeNiiguCg5CjVajbjYLy
        MWSLVuxbP47f72EEOfb1kDg=
X-Google-Smtp-Source: ABdhPJyVL5YvxiJInIgkSYVXBXcZdLsXRaPBYWgwX9inZ//zq9Hh09MFN5SJafaOcth831DpWYm0ug==
X-Received: by 2002:a5d:6646:: with SMTP id f6mr8238730wrw.155.1597526843033;
        Sat, 15 Aug 2020 14:27:23 -0700 (PDT)
Received: from [100.64.193.196] ([147.229.117.43])
        by smtp.gmail.com with ESMTPSA id m1sm22377267wmc.28.2020.08.15.14.27.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2020 14:27:21 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   =?utf-8?Q?D=C3=A1vid_Bolvansk=C3=BD?= <david.bolvansky@gmail.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2] lib/string.c: implement stpcpy
Date:   Sat, 15 Aug 2020 23:27:21 +0200
Message-Id: <CAF4EA53-B2B2-4E7C-8EB1-E5696F38CFA0@gmail.com>
References: <457a91183581509abfa00575d0392be543acbe07.camel@perches.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eli Friedman <efriedma@quicinc.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Sami Tolvanen <samitolvanen@google.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Daniel Axtens <dja@axtens.net>, Ingo Molnar <mingo@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
In-Reply-To: <457a91183581509abfa00575d0392be543acbe07.camel@perches.com>
To:     Joe Perches <joe@perches.com>
X-Mailer: iPhone Mail (17F75)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-fno-builtin-stpcpy can be used to disable stpcpy but Nick at llvm bugzilla w=
rote that these flags are broken with LTO.


> D=C5=88a 15. 8. 2020 o 23:24 u=C5=BE=C3=ADvate=C4=BE Joe Perches <joe@perc=
hes.com> nap=C3=ADsal:
>=20
> =EF=BB=BFOn Sat, 2020-08-15 at 13:47 -0700, Nick Desaulniers wrote:
>>> On Sat, Aug 15, 2020 at 9:34 AM Kees Cook <keescook@chromium.org> wrote:=

>>> On Fri, Aug 14, 2020 at 07:09:44PM -0700, Nick Desaulniers wrote:
>>>> LLVM implemented a recent "libcall optimization" that lowers calls to
>>>> `sprintf(dest, "%s", str)` where the return value is used to
>>>> `stpcpy(dest, str) - dest`. This generally avoids the machinery involve=
d
>>>> in parsing format strings.  Calling `sprintf` with overlapping argument=
s
>>>> was clarified in ISO C99 and POSIX.1-2001 to be undefined behavior.
>>>>=20
>>>> `stpcpy` is just like `strcpy` except it returns the pointer to the new=

>>>> tail of `dest`. This allows you to chain multiple calls to `stpcpy` in
>>>> one statement.
>>>=20
>>> O_O What?
>>>=20
>>> No; this is a _terrible_ API: there is no bounds checking, there are no
>>> buffer sizes. Anything using the example sprintf() pattern is _already_
>>> wrong and must be removed from the kernel. (Yes, I realize that the
>>> kernel is *filled* with this bad assumption that "I'll never write more
>>> than PAGE_SIZE bytes to this buffer", but that's both theoretically
>>> wrong ("640k is enough for anybody") and has been known to be wrong in
>>> practice too (e.g. when suddenly your writing routine is reachable by
>>> splice(2) and you may not have a PAGE_SIZE buffer).
>>>=20
>>> But we cannot _add_ another dangerous string API. We're already in a
>>> terrible mess trying to remove strcpy[1], strlcpy[2], and strncpy[3]. Th=
is
>>> needs to be addressed up by removing the unbounded sprintf() uses. (And
>>> to do so without introducing bugs related to using snprintf() when
>>> scnprintf() is expected[4].)
>>=20
>> Well, everything (-next, mainline, stable) is broken right now (with
>> ToT Clang) without providing this symbol.  I'm not going to go clean
>> the entire kernel's use of sprintf to get our CI back to being green.
>=20
> Maybe this should get place in compiler-clang.h so it isn't
> generic and public.
>=20
> Something like:
>=20
> ---
> include/linux/compiler-clang.h | 27 +++++++++++++++++++++++++++
> 1 file changed, 27 insertions(+)
>=20
> diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang=
.h
> index cee0c728d39a..6279f1904e39 100644
> --- a/include/linux/compiler-clang.h
> +++ b/include/linux/compiler-clang.h
> @@ -61,3 +61,30 @@
> #if __has_feature(shadow_call_stack)
> # define __noscs    __attribute__((__no_sanitize__("shadow-call-stack")))
> #endif
> +
> +#ifndef __HAVE_ARCH_STPCPY
> +/**
> + * stpcpy - copy a string from src to dest returning a pointer to the new=
 end
> + *          of dest, including src's NULL terminator. May overrun dest.
> + * @dest: pointer to buffer being copied into.
> + *        Must be large enough to receive copy.
> + * @src: pointer to the beginning of string being copied from.
> + *       Must not overlap dest.
> + *
> + * This function exists _only_ to support clang's possible conversion of
> + * sprintf calls to stpcpy.
> + *
> + * stpcpy differs from strcpy in two key ways:
> + * 1. inputs must not overlap.
> + * 2. return value is dest's NUL termination character after copy.
> + *    (for strcpy, the return value is a pointer to src)
> + */
> +
> +static inline char *stpcpy(char __restrict *dest, const char __restrict *=
src)
> +{
> +    while ((*dest++ =3D *src++) !=3D '\0') {
> +        ;    /* nothing */
> +    }
> +       return --dest;
> +}
> +#endif
>=20
>=20
