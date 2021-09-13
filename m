Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3520C409E4B
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 22:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242727AbhIMUn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 16:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241297AbhIMUn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 16:43:58 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03EBC061760
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 13:42:41 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id y6so19610305lje.2
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 13:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HWY/EewUPKp73TzxAziJqvXmaqyygdW/b+QHkWc/nhk=;
        b=WUDcnWLSVuipyv/o870gx/3KRDXU/5/pW/w70Iw6g0/mUDCYF5940OAfsqWLvsksEK
         7ykNK7S4TpqCIds/8ffTUxTEHnfLwNVZ/b9beeHJ4pkGgI6UiMzi1Y64I6nBvLCe+zCv
         y2ebJSNNR55jpHO3tEmyEc5E5ilbPqcga0xEY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HWY/EewUPKp73TzxAziJqvXmaqyygdW/b+QHkWc/nhk=;
        b=Qtuf3pra9d+moWpQRm79DhKf3EhvzrvvUHhqgC3deOCwp/G6JQzrO1N2r85tu+qLmx
         ToC0cHHUD4rXOS02PcRmh2va1ebeGT7BaCeua7U03LxeScTT0h2ReaJ+4aq/b4MDjn68
         HGeNo1cHa8vJLuYxvh1dlzvZ6PKkLrsnWxF//oWUoqXwzBTqvyXdamVwL6BYQtDDETPi
         EZKCdaAeey0/OQ4DxS3j/nbHc9/u/XPW5HHLRmORdMqPbYikzLqxm3cAp7mhLOFb+Qab
         ckUj63E5Ki4tiFmgyzaXAzFYZ5QJ21MLNngQhJUzwfPz6V6xS/qU4SGadaSnIAgYaRXJ
         2eZQ==
X-Gm-Message-State: AOAM531h/9nf5bcHVuNjWYFqX+ET74j/mohC0g300N5OCVbF+fmhhZMB
        U5VRZjHlhunvAZst8XjixJLI97LgEVHlbZ/gIJM=
X-Google-Smtp-Source: ABdhPJw0YIUFY9m14GpPMUJTr+TT6RBzW1YapaqsN9Ea9u6IDZTYuTzEFXJg01nBuh1Gq+TKscvxjg==
X-Received: by 2002:a2e:97cf:: with SMTP id m15mr12057428ljj.243.1631565759764;
        Mon, 13 Sep 2021 13:42:39 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id a7sm925999lfs.309.2021.09.13.13.42.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 13:42:36 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id k13so23753980lfv.2
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 13:42:36 -0700 (PDT)
X-Received: by 2002:a19:ae15:: with SMTP id f21mr834776lfc.402.1631565756235;
 Mon, 13 Sep 2021 13:42:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131113.390368911@linuxfoundation.org> <20210913131114.028340332@linuxfoundation.org>
 <CA+G9fYtdPnwf+fi4Oyxng65pWjW9ujZ7dd2Z-EEEHyJimNHN6g@mail.gmail.com>
 <YT+RKemKfg6GFq0S@kroah.com> <CAKwvOdmOAKTkgFK4Oke1SFGR_NxNqXe-buj1uyDgwZ4JdnP2Vg@mail.gmail.com>
 <CAKwvOdmCS5Q7AzUL5nziYVU7RrtRjoE9JjOXfVBWagO1Bzbsew@mail.gmail.com>
 <CA+icZUVuRaMs=bx775gDF88_xzy8LFkBA5xaK21hFDeYvgo12A@mail.gmail.com>
 <CAKwvOdmN3nQe8aL=jUwi0nGXzYQGic=NA2o40Q=yeHeafSsS3g@mail.gmail.com>
 <CAHk-=whwREzjT7=OSi5=qqOkQsvMkCOYVhyKQ5t8Rdq4bBEzuw@mail.gmail.com> <CAKwvOdkf3B41RRe8FDkw1H-0hBt1_PhZtZxBZ5pj0pyh7vDLmA@mail.gmail.com>
In-Reply-To: <CAKwvOdkf3B41RRe8FDkw1H-0hBt1_PhZtZxBZ5pj0pyh7vDLmA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 13 Sep 2021 13:42:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjP2ijctPt2Hw3DagSZ-KgdRsO6zWTTKQNnSk0MajtJgA@mail.gmail.com>
Message-ID: <CAHk-=wjP2ijctPt2Hw3DagSZ-KgdRsO6zWTTKQNnSk0MajtJgA@mail.gmail.com>
Subject: Re: [PATCH 5.14 018/334] nbd: add the check to prevent overflow in __nbd_ioctl()
To:     Nick Desaulniers <ndesaulniers@google.com>
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

On Mon, Sep 13, 2021 at 1:16 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> Do we have access to _Generic in GCC 4.9?

We've ended up using it unconditionally since last year, so yes.

In fact, the compiler version tests got removed when we raised the gcc
version requirement to 4.9 in commit 6ec4476ac825 ("Raise gcc version
requirement to 4.9"):

   "In particular, raising the minimum to 4.9 means that we can now just
    assume _Generic() exists, which is likely the much better replacement
    for a lot of very convoluted built-time magic with conditionals on
    sizeof and/or __builtin_choose_expr() with same_type() etc"

but we haven't used it much since.

The "seqprop" code for picking the right lock for seqlock is perhaps
the main example, and staring at that code will make you go blind, so
look away.

            Linus
