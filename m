Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B177A49B995
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 18:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238642AbiAYRFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 12:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359423AbiAYRDI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 12:03:08 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5484FC06173B
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 09:03:04 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id l1so36685821uap.8
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 09:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lT2ZEVyfUq+RaCtD1SacFhDgchwqLFLjwZATklfqjQo=;
        b=7kV2ubF4TIQ4dwGGaiZY6131cWDRToAMH/HRzgcl8dHqnGW/u7vnbPaPyT2W7f6wtJ
         tapTLf+rzYrb3PMcA4y2yPx9tULUJH2eDPtW5yj6k1jjRmQZvBQexwuJ9FHvrasO9fMO
         c6KcV9CzdSYCh064A9DhFhH/gvu4tFOKZlTiW0bBo5omThzxkNvkwkIqW+f0MbNVL9c1
         ukaTpDZLYSI/sI1gQYM9zVJI3g5srRQv8IKXXmc8/aeffY8eWY4bQH/1g16oBiqxsAv2
         rXSc7k3Qyov+weW6wiLNAuhE++nqSJE+fAHYwNxvN0RXke6djmViq6qye5rtNqZYVzsX
         jyfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lT2ZEVyfUq+RaCtD1SacFhDgchwqLFLjwZATklfqjQo=;
        b=coWCV/IzIB97kli6SkGUtIWM9UzH+2+YdzTw8CiKjrBt1CWPGG+uj4rzIZjbguwH9B
         MVhLVlGEl5RxrHQUdDpv7O2vY23Q9SGmxV2XU1NOHPQQKZ5eHOdlGb/f47f+HNb/bVRQ
         QhpwGh3k7j02f8O3/JbZAxfegwJq6AY7SIMlQpgqNFgtMaqQWmLJtidRXQcHgCePxdBV
         woBjFL3BG/4narQ6gfzZ+GPrHqNeedSMBdJHaPIBVYvmaMZzB8G7vw21+UzPM8abT243
         f0Cq0WBtgTo6vS24sVwcYihXLT+pMlGlInre24HFEFSHgL8zTxnTnGmMo0gTCYECoYU8
         e+sA==
X-Gm-Message-State: AOAM532+CoLlUDJ35PHljNn8ayOig1wAcgeo3+Kv0OkTC6ukRmFdzDs6
        Rn35OzwpcM06qme2det5onh9BMmgaFaMP5ox7qji3T874h+F6SBZ
X-Google-Smtp-Source: ABdhPJy+Q4MbRbCaNWgzjyIfDeid5bkMbIcQqaOwKnPZ1IalYuAahOQ2HN0GrpLSexg/X+GgIFK06+RLTac33eVQxxw=
X-Received: by 2002:a67:cc07:: with SMTP id q7mr3762136vsl.21.1643130182745;
 Tue, 25 Jan 2022 09:03:02 -0800 (PST)
MIME-Version: 1.0
References: <0af17d6952b3677dcd413fefa74b086d5ffb474b.camel@rajagiritech.edu.in>
 <YfAKYWOMdGJ0NxjE@kroah.com> <CAG=yYwksvQmEsfRyFiQTbSxUL39WGf7ryHaywtAxgdL1Nt67OQ@mail.gmail.com>
 <YfAk90OPjlpjruV5@kroah.com>
In-Reply-To: <YfAk90OPjlpjruV5@kroah.com>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Tue, 25 Jan 2022 22:32:26 +0530
Message-ID: <CAG=yYw=BK1gU0UV8g5_ZT5gOe5P2W2rKHWdFyPi4ZHSy4CGMFw@mail.gmail.com>
Subject: Re: review for 5.16.3-rc2
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 9:57 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jan 25, 2022 at 09:49:00PM +0530, Jeffrin Thalakkottoor wrote:
> > On Tue, Jan 25, 2022 at 8:04 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Jan 25, 2022 at 06:15:46PM +0530, Jeffrin Jose T wrote:
> > > > hello greg,
> > > >
> > > > compile failed for  5.16.3-rc2 related.
> > > > a relevent file attached.
> > > >
> > > > Tested-by : Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
> > >
> > > But it failed for you, how did you test it?
> >
> > i compiled  5.16.3-rc2  related to "make localmodconfig" and  "make  -j4"
>
> So it somehow failed?

Yes i think so

>
> > >
> > > >
> > > >
> > >
> > > >       char *                     typetab;              /*    24     8 */
> > > >
> > > >       /* size: 32, cachelines: 1, members: 4 */
> > > >       /* sum members: 28, holes: 1, sum holes: 4 */
> > > >       /* last cacheline: 32 bytes */
> > > > };
> > > > struct klp_modinfo {
> > > >       Elf64_Ehdr                 hdr;                  /*     0    64 */
> > > >       /* --- cacheline 1 boundary (64 bytes) --- */
> > > >       Elf64_Shdr *               sechdrs;              /*    64     8 */
> > > >       char *                     secstrings;           /*    72     8 */
> > > >       unsigned int               symndx;               /*    80     4 */
> > > >
> > > >       /* size: 88, cachelines: 2, members: 4 */
> > > >       /* padding: 4 */
> > > >       /* last cacheline: 24 bytes */
> > > > };
> > > > Segmentation fault
> > >
> > > What "faulted"?  Look higher up in the log please.
> >
> > a top view...
> >
> >   CALL    scripts/atomic/check-atomics.sh
> >   CALL    scripts/checksyscalls.sh
> >   CHK     include/generated/compile.h
> >   GEN     .version
> >   CHK     include/generated/compile.h
> >   UPD     include/generated/compile.h
> >   CC      init/version.o
> >   AR      init/built-in.a
> >   LD      vmlinux.o
> >   MODPOST vmlinux.symvers
> >   MODINFO modules.builtin.modinfo
> >   GEN     modules.builtin
> >   LD      .tmp_vmlinux.btf
> >   BTF     .btf.vmlinux.bin.o
> > struct list_head {
> >     struct list_head *         next;                 /*     0     8 */
> >     struct list_head *         prev;                 /*     8     8 */
> >
> >     /* size: 16, cachelines: 1, members: 2 */
> >     /* last cacheline: 16 bytes */
> > };
> > struct hlist_head {
> >     struct hlist_node *        first;                /*     0     8 */
> >
> >     /* size: 8, cachelines: 1, members: 1 */
> >     /* last cacheline: 8 bytes */
> > };
> > struct hlist_node {
> >     struct hlist_node *        next;                 /*     0     8 */
> >     struct hlist_node * *      pprev;                /*     8     8 */
> >
> >     /* size: 16, cachelines: 1, members: 2 */
> >     /* last cacheline: 16 bytes */
> > };
> > struct callback_head {
> >     struct callback_head *     next;                 /*     0     8 */
> >     void                       (*func)(struct callback_head *); /*
> > 8     8 */
> > .
> > .
> > .
> > .
> > .
> > .
>
> I do not know what is failing, there is no error message here.  Does
> 5.16.2 build properly for you?

stderr has  captured  the  following...


-------------x-----------------x--------------x---
FAILED: load BTF from vmlinux: No such file or directory
make: *** [Makefile:1161: vmlinux] Error 255
make: *** Deleting file 'vmlinux'
------------x----------------x------------x--
5.16.2-rc1 builds for me.

Will the following link help...

https://unix.stackexchange.com/questions/616392/failed-load-btf-from-vmlinux-unknown-error-2make-makefile1162-vmlinu

-- 
software engineer
rajagiri school of engineering and technology
