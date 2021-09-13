Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8CF7409EFD
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 23:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348278AbhIMVRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 17:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348257AbhIMVQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 17:16:50 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFEFC061762
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 14:15:34 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id o11so12199867ljp.8
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 14:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KsP30ov9xl9zhULjcWutgVa5WGmRNrz9j2ugExJGuYo=;
        b=mygUPtbJXKFBf25Ytt4weIVj36Yui1nGLTd+cq+lXbA73j0/0gxaMT0z1qklKDwZjP
         oYzbIV8uJoXpVLqWOm88+JSCNtqV5oJK1ekAwjAFKDkYP2JMkh38dpX8b729gelnHLCM
         4SLlGe56m3hX+Trb53z9qVBgR0utshgzVDurHqGX35l9QYyRHVZ4owOVp9qrVetiNWAH
         pynFZ5/s5LpdhpR6CWHyBac4qRy9kt1zN5ZHmylBp8QQfwqrhjs8KvmsdTDHTSHvSc74
         zOsfV7AcfseUdFrfEaskaPe6x85pgcP3h2+G/UI382g+ahpXXdnlQghyJXOzrP7ZNEhA
         GV5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KsP30ov9xl9zhULjcWutgVa5WGmRNrz9j2ugExJGuYo=;
        b=79i5CDEgBEdD1H/YWkCewHViMkhmhxGlAR0iN6MRc2t0pZh/Pm8qVtzoG8McGuroiL
         E/M7xwE9DfxVxa+IJt+j9abl/sLd56iBvRTqR7gfq1XTpSrvN1bP3SN9+jb2Sd6awOSP
         /V7KF1qB+UEtcTBki8JtFXcYOk5uEAcUNbbpGh29EBb/brjvuCz9Yb3boJ5O8Hgfy+Sh
         WJYwAFZyu7AdLarodLY+CGyqMO3dTqCGuEUBAS0l2YZuCbtLPWP7sQMXpqSY7G9xQ6IL
         ffraUZvSiQxks/FeyK9SEfBMw5x9meryfLnlzq2fsmrIKzwY+XwycJB02P5gxUf8h3XQ
         qmYA==
X-Gm-Message-State: AOAM532Qoj9T+9p9mthIL/uhZUOSZ20n527SLm1VVOnr8tWjDFAIVPgT
        yyYGO47kCoN0uMcdV+q0T2qnnWMmvoOFv2ZeW9TPkA==
X-Google-Smtp-Source: ABdhPJzo28mpD6c9vf+D6J9UtP0Lt3zndpgJfN3ZNLmyoo3VdiTr5GeG8q0j15d63LccbyV8mZDyilBazCACdxixi/Y=
X-Received: by 2002:a2e:b551:: with SMTP id a17mr12026583ljn.128.1631567732248;
 Mon, 13 Sep 2021 14:15:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131113.390368911@linuxfoundation.org> <20210913131114.028340332@linuxfoundation.org>
 <CA+G9fYtdPnwf+fi4Oyxng65pWjW9ujZ7dd2Z-EEEHyJimNHN6g@mail.gmail.com>
 <YT+RKemKfg6GFq0S@kroah.com> <CAKwvOdmOAKTkgFK4Oke1SFGR_NxNqXe-buj1uyDgwZ4JdnP2Vg@mail.gmail.com>
 <CAKwvOdmCS5Q7AzUL5nziYVU7RrtRjoE9JjOXfVBWagO1Bzbsew@mail.gmail.com>
 <CA+icZUVuRaMs=bx775gDF88_xzy8LFkBA5xaK21hFDeYvgo12A@mail.gmail.com>
 <CAKwvOdmN3nQe8aL=jUwi0nGXzYQGic=NA2o40Q=yeHeafSsS3g@mail.gmail.com>
 <CAHk-=whwREzjT7=OSi5=qqOkQsvMkCOYVhyKQ5t8Rdq4bBEzuw@mail.gmail.com>
 <CAKwvOdkf3B41RRe8FDkw1H-0hBt1_PhZtZxBZ5pj0pyh7vDLmA@mail.gmail.com>
 <CAHk-=wjP2ijctPt2Hw3DagSZ-KgdRsO6zWTTKQNnSk0MajtJgA@mail.gmail.com>
 <CAKwvOd=ZG8sf1ZOkuidX_49VGkQE+BJDa19_vR4gh2FNQ2F_9Q@mail.gmail.com> <CAKwvOdkz4e3HdNKFvOdDDWVijB7AKaeP14_vAEbxWXD1AviVhA@mail.gmail.com>
In-Reply-To: <CAKwvOdkz4e3HdNKFvOdDDWVijB7AKaeP14_vAEbxWXD1AviVhA@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 13 Sep 2021 14:15:21 -0700
Message-ID: <CAKwvOdmtX8Y8eWESYj4W-H-KF7cZx6w1NbSjoSPt5x5U9ezQUQ@mail.gmail.com>
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

On Mon, Sep 13, 2021 at 2:13 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Mon, Sep 13, 2021 at 1:50 PM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > On Mon, Sep 13, 2021 at 1:42 PM Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > On Mon, Sep 13, 2021 at 1:16 PM Nick Desaulniers
> > > <ndesaulniers@google.com> wrote:
> > > >
> > > > Do we have access to _Generic in GCC 4.9?
> > >
> > > We've ended up using it unconditionally since last year, so yes.
> >
> > Sorry, grepping would have taken < 1s. I'm very lazy.
> > http://threevirtues.com/
> >
> > >
> > > In fact, the compiler version tests got removed when we raised the gcc
> > > version requirement to 4.9 in commit 6ec4476ac825 ("Raise gcc version
> > > requirement to 4.9"):
> > >
> > >    "In particular, raising the minimum to 4.9 means that we can now just
> > >     assume _Generic() exists, which is likely the much better replacement
> > >     for a lot of very convoluted built-time magic with conditionals on
> > >     sizeof and/or __builtin_choose_expr() with same_type() etc"
> > >
> > > but we haven't used it much since.
> > >
> > > The "seqprop" code for picking the right lock for seqlock is perhaps
> > > the main example, and staring at that code will make you go blind, so
> > > look away.
> >
> > Looking at my patch:
> > https://lore.kernel.org/stable/20210913203201.1844253-1-ndesaulniers@google.com/
> > I don't think _Generic helps us in the case of dispatching based on
> > the result of is_signed_type() (the operands could undergo type
> > promotion, so we'd need lots of cases that are more concisely covered
> > by is_signed_type()). It could replace the nested checks in div_64
> > with nested _Generics, I think. Not sure it's a huge win for
> > readability.  Maybe cut the number of expansions of the parameters in
> > half though. Let me give it a try just to see what it looks like.
>
> Is this more readable? Same line count.  I'm not sure if there's such
> a thing as "fallthrough" between the "cases" of _Generic to minimize
> duplication, or whether this could be factored further.  Needs lots
> more () around macro param use and tab'ed out line endings...

Sorry wrong diff:
diff --git a/include/linux/math64.h b/include/linux/math64.h
index bc9c12c168d0..8fc4d56a45b9 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -162,18 +162,18 @@ static inline s64 div_s64(s64 dividend, s32 divisor)
                div_u64(dividend, divisor));            \
 })

+#define __div_64(dividend, divisor) _Generic((divisor),        \
+  s64: div64_x64(dividend, divisor),   \
+  u64: div64_x64(dividend, divisor),   \
+  default: div_x64(dividend, divisor))
+
 #define div_64(dividend, divisor) ({
         \
        BUILD_BUG_ON_MSG(sizeof(dividend) > sizeof(u64),
         \
                         "128b div unsupported");
         \
-       __builtin_choose_expr(
         \
-               __builtin_types_compatible_p(typeof(dividend), s64) ||
         \
-               __builtin_types_compatible_p(typeof(dividend), u64),
         \
-               __builtin_choose_expr(
         \
-                       __builtin_types_compatible_p(typeof(divisor),
s64) ||   \
-                       __builtin_types_compatible_p(typeof(divisor),
u64),     \
-                       div64_x64(dividend, divisor),
         \
-                       div_x64(dividend, divisor)),
         \
-               dividend / divisor);
         \
+       _Generic((dividend),    \
+               s64: __div_64(dividend, divisor),       \
+               u64: __div_64(dividend, divisor),       \
+               default: dividend / divisor);   \
 })
-- 
Thanks,
~Nick Desaulniers
