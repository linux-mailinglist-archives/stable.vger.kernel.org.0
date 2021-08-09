Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6DA3E46AB
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 15:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbhHINcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 09:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbhHINcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 09:32:05 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB4DC061796;
        Mon,  9 Aug 2021 06:31:44 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id u25so23501896oiv.5;
        Mon, 09 Aug 2021 06:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tKtCgs9wzH8vQFhcPb9WxXt8+IKB3JL2wXyhSG5vzRo=;
        b=J2fg2+t4sPFLj1cMvbz6CNMuBaQg7N1Jyf/Ok5LVt3+HSjDIMV6PXNSUjMMZxdLwvi
         Yu6iyEQ/0KId/td3Pz9onaAmyB9KEgp9OyszAm/oHmE5nf2s1hs9xt84BoCR6Flu5cjn
         /IXSJw8k3WRwLRPUnWHVFRNOfSwQMDC/qCfnWWYEA77IZy1IXj3AjyGBUGt3fgRDQku+
         cFvasW5CPDEwRwDog0uvSS49Jhcg2BiyKbNriQa3MNj1qc3D6qeNaq5UNtKMrx37lo0N
         CQ20rsccyliCbWqNgkc6KR7e83wuWFWqBXwa+IMAJZ6NemfBbH0Au371i7fiH+DumKmx
         ezAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tKtCgs9wzH8vQFhcPb9WxXt8+IKB3JL2wXyhSG5vzRo=;
        b=hAde8M7mhwS9ulhtGaL7fU/p6qhEjW5epIqmTUvMzAUO/mfXiJw6IILPpWG/T1bp4k
         0LjYiQahCBBH/J483alh1AE4959KWH0HerTbDaH3kH7UxIgMchcSBzVsyjYJEQYIw/qH
         LuUfm+wEd2Z5BdHbKplwiUqfjkrZ8ECN7Epmcy6RnlXpXKEXYhLfmBWYD6y7bY4mW64V
         /VVjXhZX5+2UnNIsMqKjd24mGslu+TWzwuoGxj9hDtjZjYOHboCJzFu9JRgzGE1SuA3R
         QuKYSlFvh4fQbPRwJKRRbB492XmgeQVjvwCBy7NBTAlH5rtvCPStIxCUUJI2YFBkeOWD
         H/bQ==
X-Gm-Message-State: AOAM530S9Y+AUhwXStohwrgXulb6qmiCb0BDr4zsFw8MEfGLduGaJTGA
        nnKSeYPSn58YRJI8Be4q8GqTOldgRZNb8qWF5nI=
X-Google-Smtp-Source: ABdhPJy5hTN76hsnz/r6sxWkfpHbCOzkYtie3g0jZCaQRvlHVsnF8fsi5CGvstxwAkZaoX3Naq5v9/U7gy3XRto0yBs=
X-Received: by 2002:a05:6808:601:: with SMTP id y1mr14115396oih.27.1628515904272;
 Mon, 09 Aug 2021 06:31:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAM43=SM4KFE8C1ekwiw_kBYZKSwycnTYcbBXfw5OhUn4h=r9YA@mail.gmail.com>
 <31298797-f791-4ac5-cfda-c95d7c7958a4@linux-m68k.org> <CAM43=SNV4016i2ByssN9tvXDN6ZyQiYM218_NkrebyPA=p6Rcg@mail.gmail.com>
 <380dd57-4b60-ac9c-508c-826d8ec1b0aa@linux-m68k.org>
In-Reply-To: <380dd57-4b60-ac9c-508c-826d8ec1b0aa@linux-m68k.org>
From:   Mikael Pettersson <mikpelinux@gmail.com>
Date:   Mon, 9 Aug 2021 15:31:33 +0200
Message-ID: <CAM43=SO03vCzo4LiwSFJyNbWdVXu_wu1gdm5wzi2ArsWShCqqA@mail.gmail.com>
Subject: Re: [BISECTED][REGRESSION] 5.10.56 longterm kernel breakage on m68k/aranym
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-m68k@lists.linux-m68k.org, stable@vger.kernel.org,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 9, 2021 at 3:59 AM Finn Thain <fthain@linux-m68k.org> wrote:
>
> On Sun, 8 Aug 2021, Mikael Pettersson wrote:
>
> > On Sun, Aug 8, 2021 at 1:20 AM Finn Thain <fthain@linux-m68k.org> wrote:
> > >
> > > On Sat, 7 Aug 2021, Mikael Pettersson wrote:
> > >
> > > > I updated the 5.10 longterm kernel on one of my m68k/aranym VMs from
> > > > 5.10.47 to 5.10.56, and the new kernel failed to boot:
> > > >
> > > > ARAnyM 1.1.0
> > > > Using config file: 'aranym1.headless.config'
> > > > Could not open joystick 0
> > > > ARAnyM RTC Timer: /dev/rtc: Permission denied
> > > > ARAnyM LILO: Error loading ramdisk 'root.bin'
> > > > Blitter tried to read byte from register ff8a00 at 0077ee
> > > >
> > > > At this point it kept running, but produced no output to the console,
> > > > and would never get to the point of starting user-space. Attaching gdb
> > > > to aranym showed nothing interesting, i.e. it seemed to be executing
> > > > normally.
> > > >
> > > > A git bisect identified the following commit between 5.10.52 and
> > > > 5.10.53 as the culprit:
> > > > # first bad commit: [9e1cf2d1ed37c934c9935f2c0b2f8b15d9355654]
> > > > mm/userfaultfd: fix uffd-wp special cases for fork()
> > > >
> > >
> > > That commit appeared in mainline between v5.13 and v5.14-rc1. Is mainline
> > > also affected? e.g. v5.14-rc4.
> >
> > 5.14-rc4 boots fine. I suspect the commit has some dependency that
> > hasn't been backported to 5.10 stable.
> >
>
> On mainline, 9e1cf2d1ed3 is known as commit 8f34f1eac382 ("mm/userfaultfd:
> fix uffd-wp special cases for fork()").
>
> There are differences between the two commits that may be relevant. I
> don't know.
>
> If you checkout 8f34f1eac382 and if that works, it would indicate either
> missing dependencies in -stable, or those differences are important.
>
> OTOH, if 8f34f1eac382 fails in the same way as linux-5.10.y, it would
> indicate that -stable is missing a fix that's present in v5.14-rc4.

My initial bisect was wrong. I tried reverting 8f34f1eac382 from
5.10.57 but that made no difference, so I re-ran the git bisect with
all known good points pre-marked. This landed on:
# first bad commit: [ce6ee46e0f39ed97e23ebf7b5a565e0266a8a1a3]
mm/page_alloc: fix memory map initialization for descending nodes

Reverting _that_ from 5.10.57 does unbreak that kernel.

Sorry about the confusion.
