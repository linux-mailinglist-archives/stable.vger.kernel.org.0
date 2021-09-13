Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604BA409E08
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 22:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242443AbhIMURv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 16:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240553AbhIMURu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 16:17:50 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00469C061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 13:16:33 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id w4so19424581ljh.13
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 13:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E9BTZz7P4136Vx17+j4gvrYMgr1v/N8zIGjbUFEwypk=;
        b=pGWIil2q/K8JwjJfMEfl6tF1g4EZC68ukMYbPMY9ZEi/H4fw12ekTh5g5zL8JoOfiA
         Itg7hB6e6NdOVVs+dDnBzvn4o8dMKsckPAz/60KVdfGqmyoJ6QK8O8XSMvy02fnPUUi2
         tsqShyEUivl97LS4GtdmCzPBQvRoxEzITeFeGmQ07b7Myd1YXOWHnqGKSRpzQDXfoH5m
         LLj38yKo45ErdqEUPpgk0TQF92aWtsPcpLfPj2OV0Nnhf0o3TeKcPyFt1sGjjSy6KFeb
         kU12tBInuUNGU8jbKIRPJeIPDrk8HkuQK3GBrf+7mC354xOIiieTE6E/g36NpPpze6sn
         +weQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E9BTZz7P4136Vx17+j4gvrYMgr1v/N8zIGjbUFEwypk=;
        b=RBhPCMatYFHI7+yM4Zv8G1kNw7p5nJzjP6upoNFjm/q+r4WjFTYTUgt+6Gc1GCnl4l
         VMnzo1vfjvqgAfFh18tpv6d/ePvmoBAP7X39XzZoqxJcItJL390axfWltUwXB59Gfvbh
         YZWXKMB4PcyoFC5KUOO7j3/ca4BfAhOhb+IssCEDLTZ56yExDgFiQcmG9fyyB8WZPlxA
         N7rEooSKLl5Ph2S5OcQB1DYmAefVLrnAfwppDiMpN5eEj1+lXlkvt9MbW3WASkzsnEeV
         +li2baMmsldCpjacqXxvEWT+QpMnQBRSBZ1/A1jp0QFgNNSGjxNojCsmPG5TNtkUEnRR
         EDeg==
X-Gm-Message-State: AOAM533jRMnYakK8KaWDz14wHsNsBr3xHU4zKKrSvspK4ufVtwOH8hgf
        vobOxtG0eiLxSxrSqECI8EIg3TAeTgcJp7za1rr93g==
X-Google-Smtp-Source: ABdhPJwvsVZpZ3HbrlIBen+eVm+S/CxUB3A7WkDio3CDFl0jd61TWcY9H6BM6He7NM1BKpo08LZiDObdovWMLxdbvOw=
X-Received: by 2002:a2e:4e09:: with SMTP id c9mr11984681ljb.62.1631564192079;
 Mon, 13 Sep 2021 13:16:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131113.390368911@linuxfoundation.org> <20210913131114.028340332@linuxfoundation.org>
 <CA+G9fYtdPnwf+fi4Oyxng65pWjW9ujZ7dd2Z-EEEHyJimNHN6g@mail.gmail.com>
 <YT+RKemKfg6GFq0S@kroah.com> <CAKwvOdmOAKTkgFK4Oke1SFGR_NxNqXe-buj1uyDgwZ4JdnP2Vg@mail.gmail.com>
 <CAKwvOdmCS5Q7AzUL5nziYVU7RrtRjoE9JjOXfVBWagO1Bzbsew@mail.gmail.com>
 <CA+icZUVuRaMs=bx775gDF88_xzy8LFkBA5xaK21hFDeYvgo12A@mail.gmail.com>
 <CAKwvOdmN3nQe8aL=jUwi0nGXzYQGic=NA2o40Q=yeHeafSsS3g@mail.gmail.com> <CAHk-=whwREzjT7=OSi5=qqOkQsvMkCOYVhyKQ5t8Rdq4bBEzuw@mail.gmail.com>
In-Reply-To: <CAHk-=whwREzjT7=OSi5=qqOkQsvMkCOYVhyKQ5t8Rdq4bBEzuw@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 13 Sep 2021 13:16:21 -0700
Message-ID: <CAKwvOdkf3B41RRe8FDkw1H-0hBt1_PhZtZxBZ5pj0pyh7vDLmA@mail.gmail.com>
Subject: Re: [PATCH 5.14 018/334] nbd: add the check to prevent overflow in __nbd_ioctl()
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@kernel.org>
Cc:     Sedat Dilek <sedat.dilek@gmail.com>,
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

On Mon, Sep 13, 2021 at 1:10 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Sep 13, 2021 at 1:02 PM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > Ha! I pulled+rebased and this code disappeared...I thought I had
> > rebased on the wrong branch or committed work to master accidentally.
> > Patch to stable-only inbound.
>
> Side note: for stable, can you look into using _Generic() instead of
> __builtin_choose_expression() with typeof, or some
> __builtin_types_compatible_p() magic?
>
> Yes, yes, we use __builtin_choose_expression() elsewhere, but we've
> started using _Generic(), and it's really the more natural model - in
> addition to being the standard C one.
>
> Of course, there may be some reason why _Generic() doesn't work, but
> it _is_ the natural fit for any "for type X, do Y" kind of thing.
>
> No?

Man, c'mon, I just got the __builtin_choose_expression() working! It's
not...too bad...ish. (Besides, I'd actually have to learn how to use
_Generic...I've never quite gotten anything I've written trying to use
it to actually compile).

Do we have access to _Generic in GCC 4.9?
-- 
Thanks,
~Nick Desaulniers
