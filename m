Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150DC409D88
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 21:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347627AbhIMT7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 15:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242202AbhIMT66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 15:58:58 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EF7C061574;
        Mon, 13 Sep 2021 12:57:42 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id i13so11406148ilm.4;
        Mon, 13 Sep 2021 12:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=TWTMVvhvJotwJPk/ze26bZ/qP+vFniaofcsTjFnegRQ=;
        b=C39pM3/I8tOoAoI7Wu65UGq1fOtrlr0vE4t+ukOt6bYdNi5dPCXqr6X+Zb8O69IwfU
         x25yCGUAwf8TJdmGPJ8YViTEbCVawWcjq5skN9JR/kuJW1bfv0HQqzOdisiitLZwJEgI
         ZnJ4x6p8KnDuHZ2D97B0ESOA3q0fLVrO75bhx+cY0S9bP5ZSboc3oWtEOXFo2lp7qVqt
         alBTz95njw8gAfu4ncrxm97wVs+t8lC66ekuXJvLKpcnIzBlDh7Gf4nDf/xCAcL6+GEx
         V7zSGqKeUaYw9BgeDEL1+OOCiUkLqI0KCW78SxVPo0VodZnw0zG+UCLVbm1MQlBclE0u
         JGwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=TWTMVvhvJotwJPk/ze26bZ/qP+vFniaofcsTjFnegRQ=;
        b=7tTPCMY5fPUiy9MuNGtOFwLr7Eqj/U3iA2z5KltK6fWXkbGcccPLRFjdN6ZSDHpr6n
         DdivJtWP/xbmqu86d5puUBB84c4lDe5OeK3XyHyGJZVlYloKZSCGePyUMo/58J0pE6yU
         4MfUm7PRJXRrzI3rx6edIUiddEJ3xyzAkn//lH1rUs9pSm0Xt1LJXBCZAwOHFoF+YIUL
         ex6xrrZZXMNMZbBFKeQ0rr/8+49cdmWzJlCg1N/lxTU893xtTy4yuXI9NKlX32Fr2asT
         v6y8iPZEfk+3gFYA7PVdMfv4cXDhcYHkfJyI5pfPxQwVtjE2KWSYgSfWKT0PP/i6Q+cG
         spiw==
X-Gm-Message-State: AOAM532AEbs20paF9fHAFl9yBKk5UVmT702DSD+Pfc6hm3TSXBt6M2Rd
        VpqEbEm0MaLaK6+yPwggMsKgrK2qtkQEgzueDT38pHDQ/ZA5lA==
X-Google-Smtp-Source: ABdhPJzL27/IrLITeAiH3QjKzG0xNJZMD4qIf1Tae+nJvnnBP8sLSlfrVVRK4Sc9el0HDm0TLgyCOenB3utZWShOxJk=
X-Received: by 2002:a05:6e02:ee1:: with SMTP id j1mr9357308ilk.61.1631563061774;
 Mon, 13 Sep 2021 12:57:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131113.390368911@linuxfoundation.org> <20210913131114.028340332@linuxfoundation.org>
 <CA+G9fYtdPnwf+fi4Oyxng65pWjW9ujZ7dd2Z-EEEHyJimNHN6g@mail.gmail.com>
 <YT+RKemKfg6GFq0S@kroah.com> <CAKwvOdmOAKTkgFK4Oke1SFGR_NxNqXe-buj1uyDgwZ4JdnP2Vg@mail.gmail.com>
 <CAKwvOdmCS5Q7AzUL5nziYVU7RrtRjoE9JjOXfVBWagO1Bzbsew@mail.gmail.com>
In-Reply-To: <CAKwvOdmCS5Q7AzUL5nziYVU7RrtRjoE9JjOXfVBWagO1Bzbsew@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 13 Sep 2021 21:57:05 +0200
Message-ID: <CA+icZUVuRaMs=bx775gDF88_xzy8LFkBA5xaK21hFDeYvgo12A@mail.gmail.com>
Subject: Re: [PATCH 5.14 018/334] nbd: add the check to prevent overflow in __nbd_ioctl()
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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

On Mon, Sep 13, 2021 at 9:53 PM 'Nick Desaulniers' via Clang Built
Linux <clang-built-linux@googlegroups.com> wrote:
>
> On Mon, Sep 13, 2021 at 11:39 AM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > On Mon, Sep 13, 2021 at 10:58 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, Sep 13, 2021 at 09:52:33PM +0530, Naresh Kamboju wrote:
> > > > [PATCH 00/10] raise minimum GCC version to 5.1
> > > > https://lore.kernel.org/lkml/20210910234047.1019925-1-ndesaulniers@google.com/
> > >
> > > Has anyone submitted a fix for this upstream yet?  I can't seem to find
> > > one :(
> >
> > That lore link has a series to address this, though that's maybe
> > something we don't want to backport to stable.
> >
> > I thought about this all weekend; I think I might be able to work
> > around the one concern I had with my other approach, using
> > __builtin_choose_expr().
> >
> > There's an issue with my alternative approach
> > (https://gist.github.com/nickdesaulniers/2479818f4983bbf2d688cebbab435863)
> > with declaring the local variable z in div_64() since either operand
> > could be 64b, which result in an unwanted truncation if the dividend
> > is 32b (or less, and divisor is 64b). I think (what I realized this
> > weekend) is that we might be able to replace the `if` with
> > `__builtin_choose_expr`, then have that whole expression be the final
> > statement and thus the "return value" of the statement expression.
>
> Christ...that...works? Though, did Linus just merge my patches for gcc 5.1?
>

"Merge branch 'gcc-min-version-5.1' (make gcc-5.1 the minimum version)"

- Sedat -

https://git.kernel.org/linus/316346243be6df12799c0b64b788e06bad97c30b

> Anyways, I'll send something like this for stable:
> ---
>
> diff --git a/include/linux/math64.h b/include/linux/math64.h
> index 2928f03d6d46..e9ab8c25f8d3 100644
> --- a/include/linux/math64.h
> +++ b/include/linux/math64.h
> @@ -11,6 +11,9 @@
>
>  #define div64_long(x, y) div64_s64((x), (y))
>  #define div64_ul(x, y)   div64_u64((x), (y))
> +#ifndef is_signed_type
> +#define is_signed_type(type)       (((type)(-1)) < (type)1)
> +#endif
>
>  /**
>   * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
> @@ -112,6 +115,15 @@ extern s64 div64_s64(s64 dividend, s64 divisor);
>
>  #endif /* BITS_PER_LONG */
>
> +#define div64_x64(dividend, divisor) ({                        \
> +       BUILD_BUG_ON_MSG(sizeof(dividend) < sizeof(u64),\
> +                        "prefer div_x64");             \
> +       __builtin_choose_expr(                          \
> +               is_signed_type(typeof(dividend)),       \
> +               div64_s64(dividend, divisor),           \
> +               div64_u64(dividend, divisor));          \
> +})
> +
>  /**
>   * div_u64 - unsigned 64bit divide with 32bit divisor
>   * @dividend: unsigned 64bit dividend
> @@ -142,6 +154,28 @@ static inline s64 div_s64(s64 dividend, s32 divisor)
>  }
>  #endif
>
> +#define div_x64(dividend, divisor) ({                  \
> +       BUILD_BUG_ON_MSG(sizeof(dividend) > sizeof(u32),\
> +                        "prefer div64_x64");           \
> +       __builtin_choose_expr(                          \
> +               is_signed_type(typeof(dividend)),       \
> +               div_s64(dividend, divisor),             \
> +               div_u64(dividend, divisor));            \
> +})
> +
> +// TODO: what if divisor is 128b?
> +#define div_64(dividend, divisor) ({
>          \
> +       __builtin_choose_expr(
>          \
> +               __builtin_types_compatible_p(typeof(dividend), s64) ||
>          \
> +               __builtin_types_compatible_p(typeof(dividend), u64),
>          \
> +               __builtin_choose_expr(
>          \
> +                       __builtin_types_compatible_p(typeof(divisor),
> s64) ||   \
> +                       __builtin_types_compatible_p(typeof(divisor),
> u64),     \
> +                       div64_x64(dividend, divisor),
>          \
> +                       div_x64(dividend, divisor)),
>          \
> +               dividend / divisor);
>          \
> +})
> +
>  u32 iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder);
>
>  #ifndef mul_u32_u32
> ---
> --
> Thanks,
> ~Nick Desaulniers
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/CAKwvOdmCS5Q7AzUL5nziYVU7RrtRjoE9JjOXfVBWagO1Bzbsew%40mail.gmail.com.
