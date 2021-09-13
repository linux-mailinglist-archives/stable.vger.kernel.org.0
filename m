Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132D340A190
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 01:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241349AbhIMXZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 19:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbhIMXZI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 19:25:08 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86DFC061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 16:23:51 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id y28so274096lfb.0
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 16:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bq011lt5dgdAQr/ZuHdy0F7gQGrCf2JBCgapEFXHuqM=;
        b=B5LAKq0e9Lnd5npvhdHcFrbSooQRxBJX1Mid0sG0F3Y8SpqoLVt1M/6eaaJxNPhc6n
         INFlj/Tt1MoyRllidkDtLVM+x6eN87fZX6VP5txNWI92MLfBYCgGHOf3RwiK7p0Kx4Ag
         82m683k6K6uDE2tGwFS+1G0xYpeTnVV6tnskfN1LZcU4NLKxpmgMLVzbhJ1gET8kLl+a
         OecFijs+X1BqnYIeWbaSM059NUhSXkWGEmuCHcOTdTBXQyrqcbV27hzBFV3toN+J7u3h
         Lj1bSuh+muSl1kUSArFWPu9/nKBp518gZrtFshFffdP3E/AtaEduBFN6MqOcpxzu2YAJ
         kghA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bq011lt5dgdAQr/ZuHdy0F7gQGrCf2JBCgapEFXHuqM=;
        b=UIi7ObHy8m4qe5Hbvneb27N6CifoXHJGo+kBh8qOFiib1hd9WLG1APkB1i1/Fq5Y71
         lpw3ytYkRA0Y+c3k0nS8MiomTdPHx0N2grTWfzqP9lvdpkmBcpSY6rKFZbmAWiL7suuz
         AOx8E5+L0rRO0LGC12qCOBDBPPII9Vkm1U9KHoM7R5w7oEpHtRrdgMqXidE3+rbz19H6
         ACCAuVTBjp0sko/PrLrF/jHbb2dh0B5w2/xDJb8TFGDtl/M5cWXwnnfMFrmg8CVpbJ3j
         xYdZ7MVGfM25GRkc0CqhZ7+9RJeW08K/wRuUStwOd1Pz+gK+ZfVYzHvERJWdVW8ZqzsF
         Ty9w==
X-Gm-Message-State: AOAM533Vi2MQul/d5dUA91JNDmSHIVkii+le4DGtoiRJKzHzeGF9Sh8G
        3DZFkz74y7XFER5TuVg9kjhjdOYjgNL8RgTfNW2UkA==
X-Google-Smtp-Source: ABdhPJyRu0132dCsRG8tz1y1crskr9yuGZHfzZNvZ99ClzfCUoixYndoyN2Uj8tpYCdhjmynt9+8gjPGFMCEmh/PV6w=
X-Received: by 2002:a05:6512:1114:: with SMTP id l20mr11222779lfg.550.1631575429882;
 Mon, 13 Sep 2021 16:23:49 -0700 (PDT)
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
 <CAKwvOd=ZG8sf1ZOkuidX_49VGkQE+BJDa19_vR4gh2FNQ2F_9Q@mail.gmail.com>
 <CAKwvOdkz4e3HdNKFvOdDDWVijB7AKaeP14_vAEbxWXD1AviVhA@mail.gmail.com>
 <CAKwvOdmtX8Y8eWESYj4W-H-KF7cZx6w1NbSjoSPt5x5U9ezQUQ@mail.gmail.com> <CAHk-=whjhJgk7hD-ftUy-8+9cenhMDHqaNKXOyeNVoMxZRD-_A@mail.gmail.com>
In-Reply-To: <CAHk-=whjhJgk7hD-ftUy-8+9cenhMDHqaNKXOyeNVoMxZRD-_A@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 13 Sep 2021 16:23:38 -0700
Message-ID: <CAKwvOdnFRhKDZ3XuePSGsuxhOpuS5RmZ1u+MeN=PRPPKSS3wFg@mail.gmail.com>
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

On Mon, Sep 13, 2021 at 4:00 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Sep 13, 2021 at 2:15 PM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > Sorry wrong diff:
>
> Well, this second diff was seriously whitespace-damaged and hard to
> read, but while it seems to be the same number of lines, it sure looks
> a lot more readable in this format.
>
> Except I think that
>
>                 default: dividend / divisor);
>
> should really have parentheses around both of those macro arguments.
>
> That's a preexisting problem, but it should be fixed while at it.

Ok, I'll send a revised v2 based on _Generic; Rasmus can help review
when he's awake.

> I'm also not sure why that (again, preexisting) BUILD_BUG_ON_MSG()
> only checks the size of the dividend, not the divisor. Very strange.
> But probably not worth worrying about.

I sent a not-yet-applied diff of my not-yet-applied diff.  I was
playing with this last week, and IIRC we had divisors that were less
than 32b being promoted to int. But I'll test it some more.
-- 
Thanks,
~Nick Desaulniers
