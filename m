Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1005E49B885
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 17:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbiAYQXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 11:23:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1583559AbiAYQTi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 11:19:38 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9BCC06173D
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 08:19:37 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id b16so38318172uaq.4
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 08:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WK50/giNFFmbEVk612ndwWi9mtGwH/spkBw7w7HrQ6E=;
        b=KajrRUW19CXUqPth3IrcJq7sQE0Fq7jZLkRx/ASPFoV0c0HbjhdJE+CdXF4TOOktX/
         vJNOxHotIhFpNLUGNujG2C1LewTcDgwktCQ+/1PCnhdqkOszNbWks/oXVZUzn0woDXP5
         2DsnVBbWKbfjP/5D/HpbF3Th+PIlZns4Rv/NiCPP958nCYSPhfKWWg5FDVFxbNLKs5CG
         O2upCEU2B3lLbK72yx0NyadnEfodBg5aaw+i+CQ6DanOhwLMy6yvLHxuHOAgqnlOI1FT
         gUsyqBaajW1EDVIdDci1EUBwxsRNUspJPqs/5AEq7jb927BCpnaw5yb7QOr73r12vF1H
         68LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WK50/giNFFmbEVk612ndwWi9mtGwH/spkBw7w7HrQ6E=;
        b=asXP2NbLmqGcUsO+xmgqZdkc9LHxuMqI3NORe8HOaoTLLALh/G21Z36G3Hn3N+m0i0
         akBALB5SLw2dkzf41Ji7VinPJIF9ufgEnxdieZjYTXZLiB1KBqv/fmA2FkKM/OAQYtg9
         R4ytyRmaly/nnWPXySeY/U4yNyhxY/bHfgi2o6Txje7ybWGLTwzTy7nsDgXZrShKRLOJ
         PtsEYieyDUnCl0Rfo8rhVFOibype/DNiee/o72pj/Uo+s5cDKClcAoypFvdVomHjZE7w
         iHKBOB1Yg7pdauAVpqD/QEvtgNVxjBszwH5uiKMaqRV4ABn1T4IV8ZHQmkVAZiq6PtFz
         AC9g==
X-Gm-Message-State: AOAM532YJmMI2ytZdu9lK9FYcfgHWEZ5yXkKFUQSAyBlSqvMkZ2Hx+UQ
        OkG/yIZFs+zCcDifqCOS5Ave0LKLih3JOUXZWJrad1tstxS688cQ
X-Google-Smtp-Source: ABdhPJydDWlZYMs02b/kYQmve8iB73g7hIl9QnHpdTipWkVOS6DcHur66zgJZpJYbAvUbjiypX8TQuaFuWSF0gR41D8=
X-Received: by 2002:ab0:781a:: with SMTP id x26mr7599654uaq.61.1643127576841;
 Tue, 25 Jan 2022 08:19:36 -0800 (PST)
MIME-Version: 1.0
References: <0af17d6952b3677dcd413fefa74b086d5ffb474b.camel@rajagiritech.edu.in>
 <YfAKYWOMdGJ0NxjE@kroah.com>
In-Reply-To: <YfAKYWOMdGJ0NxjE@kroah.com>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Tue, 25 Jan 2022 21:49:00 +0530
Message-ID: <CAG=yYwksvQmEsfRyFiQTbSxUL39WGf7ryHaywtAxgdL1Nt67OQ@mail.gmail.com>
Subject: Re: review for 5.16.3-rc2
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 8:04 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jan 25, 2022 at 06:15:46PM +0530, Jeffrin Jose T wrote:
> > hello greg,
> >
> > compile failed for  5.16.3-rc2 related.
> > a relevent file attached.
> >
> > Tested-by : Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
>
> But it failed for you, how did you test it?

i compiled  5.16.3-rc2  related to "make localmodconfig" and  "make  -j4"


>
> >
> >
>
> >       char *                     typetab;              /*    24     8 */
> >
> >       /* size: 32, cachelines: 1, members: 4 */
> >       /* sum members: 28, holes: 1, sum holes: 4 */
> >       /* last cacheline: 32 bytes */
> > };
> > struct klp_modinfo {
> >       Elf64_Ehdr                 hdr;                  /*     0    64 */
> >       /* --- cacheline 1 boundary (64 bytes) --- */
> >       Elf64_Shdr *               sechdrs;              /*    64     8 */
> >       char *                     secstrings;           /*    72     8 */
> >       unsigned int               symndx;               /*    80     4 */
> >
> >       /* size: 88, cachelines: 2, members: 4 */
> >       /* padding: 4 */
> >       /* last cacheline: 24 bytes */
> > };
> > Segmentation fault
>
> What "faulted"?  Look higher up in the log please.

a top view...

  CALL    scripts/atomic/check-atomics.sh
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  AR      init/built-in.a
  LD      vmlinux.o
  MODPOST vmlinux.symvers
  MODINFO modules.builtin.modinfo
  GEN     modules.builtin
  LD      .tmp_vmlinux.btf
  BTF     .btf.vmlinux.bin.o
struct list_head {
    struct list_head *         next;                 /*     0     8 */
    struct list_head *         prev;                 /*     8     8 */

    /* size: 16, cachelines: 1, members: 2 */
    /* last cacheline: 16 bytes */
};
struct hlist_head {
    struct hlist_node *        first;                /*     0     8 */

    /* size: 8, cachelines: 1, members: 1 */
    /* last cacheline: 8 bytes */
};
struct hlist_node {
    struct hlist_node *        next;                 /*     0     8 */
    struct hlist_node * *      pprev;                /*     8     8 */

    /* size: 16, cachelines: 1, members: 2 */
    /* last cacheline: 16 bytes */
};
struct callback_head {
    struct callback_head *     next;                 /*     0     8 */
    void                       (*func)(struct callback_head *); /*
8     8 */
.
.
.
.
.
.


$

-- 
software engineer
rajagiri school of engineering and technology
