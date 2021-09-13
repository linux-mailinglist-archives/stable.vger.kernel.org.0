Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B241A409EF2
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 23:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348099AbhIMVP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 17:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348193AbhIMVP0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 17:15:26 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A671FC061760
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 14:14:09 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id i25so19950579lfg.6
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 14:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h6laIf/b4mPqz9ieIo0BoLxfadBv/pBLzz57FwMCWS8=;
        b=SEu7xaZSAjVMKNw5hjypkoLJ+5JYwWZcOY2BABqYuBro/CZPK17EczUQuLCrutTPGL
         16Qz1HYIlWBLiIz9fuIN+11uBldPo/W5AePdN6GsQEA+SUtc8P+uASAYS6tS0ldHx07E
         2lonLGUWd9SBbHuElL3JERelxOI/WCQiYZQMZ+cnIB22lorehJTp1jfpHpUXPGwAVLsr
         iug/4lH2iw/Q756RGmEMyqecg2b3vt+REqwODu74njL+3uIRYmD7FhCYQoWZA7S/e7X4
         zbL4RRw54fmrJ/xhPMXQuEF33NXAg8H1490G0IrDnCzFSwlQt8KLs4uiBLXAehRStlz0
         T9Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h6laIf/b4mPqz9ieIo0BoLxfadBv/pBLzz57FwMCWS8=;
        b=dTVQkFOqIZGdwd2xm07832pyZiOCC8gfnBU3uRc/EYBr1jy5c0PeH8AfSmGO5a8OcR
         ncfNtbWGr9Hd0US5XXDLTSkaY9tP41SDl9wqQdB6hItHMgrwtNZ/SZswUtAH/THhf58v
         LfQm0Y7Tk0yAYZbJ5QYowoEdrI5OSMSyZpH2AGa1ZmfUlc0wqt5Gy7G6nACjTlSzHTzD
         DQ/r4M5C8ZxyMmIEtGH+DlGRqnq1ClYOXS5LQO2VLXKM/Lnii2qkidXJSQ1NyZ+E8/yD
         LvBDjE8EygnXUWQCWmfzcPgYjwqjywnko3YPeBOpuXkVWEyyI9EbN7E0DEsDNjLBiKzh
         krOQ==
X-Gm-Message-State: AOAM532RPf1+uDzhYfrtbV8c9D0ZpoobUypuJd1O/8m3zhgbbNzNtiy/
        2RtCTvi3J4OLgwZu1ZDeQAd8y11lkv7Xc4XzplJCwA==
X-Google-Smtp-Source: ABdhPJxkLmqkKxedt4K1O1ibv9lFvdfqJ+fiA/MxD/66QbtZI4YNO+29iajeZ9ssOU5ujtimoPSmNKGFx6XRwVjLntg=
X-Received: by 2002:a05:6512:3b9e:: with SMTP id g30mr10188187lfv.651.1631567647760;
 Mon, 13 Sep 2021 14:14:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131113.390368911@linuxfoundation.org> <20210913131114.028340332@linuxfoundation.org>
 <CA+G9fYtdPnwf+fi4Oyxng65pWjW9ujZ7dd2Z-EEEHyJimNHN6g@mail.gmail.com>
 <YT+RKemKfg6GFq0S@kroah.com> <CAKwvOdmOAKTkgFK4Oke1SFGR_NxNqXe-buj1uyDgwZ4JdnP2Vg@mail.gmail.com>
 <CAKwvOdmCS5Q7AzUL5nziYVU7RrtRjoE9JjOXfVBWagO1Bzbsew@mail.gmail.com>
 <CA+icZUVuRaMs=bx775gDF88_xzy8LFkBA5xaK21hFDeYvgo12A@mail.gmail.com>
 <CAKwvOdmN3nQe8aL=jUwi0nGXzYQGic=NA2o40Q=yeHeafSsS3g@mail.gmail.com>
 <CAHk-=whwREzjT7=OSi5=qqOkQsvMkCOYVhyKQ5t8Rdq4bBEzuw@mail.gmail.com>
 <CAKwvOdkf3B41RRe8FDkw1H-0hBt1_PhZtZxBZ5pj0pyh7vDLmA@mail.gmail.com>
 <CAHk-=wjP2ijctPt2Hw3DagSZ-KgdRsO6zWTTKQNnSk0MajtJgA@mail.gmail.com> <CAKwvOd=ZG8sf1ZOkuidX_49VGkQE+BJDa19_vR4gh2FNQ2F_9Q@mail.gmail.com>
In-Reply-To: <CAKwvOd=ZG8sf1ZOkuidX_49VGkQE+BJDa19_vR4gh2FNQ2F_9Q@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 13 Sep 2021 14:13:56 -0700
Message-ID: <CAKwvOdkz4e3HdNKFvOdDDWVijB7AKaeP14_vAEbxWXD1AviVhA@mail.gmail.com>
Subject: Re: [PATCH 5.14 018/334] nbd: add the check to prevent overflow in __nbd_ioctl()
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Baokun Li <libaokun1@huawei.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        lkft-triage@lists.linaro.org, llvm@lists.linux.dev,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 13, 2021 at 1:50 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Mon, Sep 13, 2021 at 1:42 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Mon, Sep 13, 2021 at 1:16 PM Nick Desaulniers
> > <ndesaulniers@google.com> wrote:
> > >
> > > Do we have access to _Generic in GCC 4.9?
> >
> > We've ended up using it unconditionally since last year, so yes.
>
> Sorry, grepping would have taken < 1s. I'm very lazy.
> http://threevirtues.com/
>
> >
> > In fact, the compiler version tests got removed when we raised the gcc
> > version requirement to 4.9 in commit 6ec4476ac825 ("Raise gcc version
> > requirement to 4.9"):
> >
> >    "In particular, raising the minimum to 4.9 means that we can now just
> >     assume _Generic() exists, which is likely the much better replacement
> >     for a lot of very convoluted built-time magic with conditionals on
> >     sizeof and/or __builtin_choose_expr() with same_type() etc"
> >
> > but we haven't used it much since.
> >
> > The "seqprop" code for picking the right lock for seqlock is perhaps
> > the main example, and staring at that code will make you go blind, so
> > look away.
>
> Looking at my patch:
> https://lore.kernel.org/stable/20210913203201.1844253-1-ndesaulniers@google.com/
> I don't think _Generic helps us in the case of dispatching based on
> the result of is_signed_type() (the operands could undergo type
> promotion, so we'd need lots of cases that are more concisely covered
> by is_signed_type()). It could replace the nested checks in div_64
> with nested _Generics, I think. Not sure it's a huge win for
> readability.  Maybe cut the number of expansions of the parameters in
> half though. Let me give it a try just to see what it looks like.

Is this more readable? Same line count.  I'm not sure if there's such
a thing as "fallthrough" between the "cases" of _Generic to minimize
duplication, or whether this could be factored further.  Needs lots
more () around macro param use and tab'ed out line endings...






diff --git a/include/linux/math64.h b/include/linux/math64.h
index 8652a8a35d70..8fc4d56a45b9 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -162,17 +162,17 @@ static inline s64 div_s64(s64 dividend, s32 divisor)
                div_u64(dividend, divisor));            \
 })

-#define __div_64(dividend) _Generic((divisor), \
-  s64: div64_x64,      \
-  u64: div64_x64,      \
-  default: div_x64)
+#define __div_64(dividend, divisor) _Generic((divisor),        \
+  s64: div64_x64(dividend, divisor),   \
+  u64: div64_x64(dividend, divisor),   \
+  default: div_x64(dividend, divisor))

 #define div_64(dividend, divisor) ({
         \
        BUILD_BUG_ON_MSG(sizeof(dividend) > sizeof(u64),
         \
                         "128b div unsupported");
         \
        _Generic((dividend),    \
-               s64: __div_64(dividend)(dividend, divisor),     \
-               u64: __div_64(dividend)(dividend, divisor),     \
+               s64: __div_64(dividend, divisor),       \
+               u64: __div_64(dividend, divisor),       \
                default: dividend / divisor);   \
 })

-- 
Thanks,
~Nick Desaulniers
