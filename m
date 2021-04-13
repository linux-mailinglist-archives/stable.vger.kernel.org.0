Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50A935D83F
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 08:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbhDMGwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 02:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236569AbhDMGwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 02:52:38 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4248EC061574;
        Mon, 12 Apr 2021 23:52:19 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id b17so13239212ilh.6;
        Mon, 12 Apr 2021 23:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M4M2rpCGtRwRg1+8877RTBO/hucYsuldRGZssGiZkFU=;
        b=GaSOG8KY8ZaZWLXAPHL7vrlSMfr8PXo4xP3uO29spI7irXqCNRyf+p4b4X+96hQ++6
         C05BWz193nKUehM/+jIYGKjPy1xKu1Q3KjL3Xqeinj/xz7IWAHqlZQXpxqaxnvYzRhqT
         aGhs3qQkhhMUuc5OMilbvHOK7AuuSHVhSt4l0BRiM4l5+uXGaTzfY+ccIwfabXgKYkK1
         ZHeZEDtGquWqarzXe7vsxV+iXoVOvG86aeZNDLL5UtJ0YiRZ9w2tEC8mWdChka5sYX7u
         z70hCoH3+M2mqDKItwT3xagkU7WLz4jfOGVgS+cPMzYNtxV7uDBMuKKggSw+nZ9VAIoN
         9ISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M4M2rpCGtRwRg1+8877RTBO/hucYsuldRGZssGiZkFU=;
        b=nTMdX45pVsCStOVF0JH4eW/cR2J7B2JvOXbh/z8fhWYusa2oqTdBy42hiIT0tdmNO9
         bkR5hJ6VLnqVbN3cgDPKxXn5uw97ireOCcow/JtD9g0F8X76s9tUYCKdBCK2yyziB9I2
         z/EEGZxUb4x8GQO2dyrYAhmH41ylbpmFdzVWtQ2TPbIZY9sY/uVIxswAFLtPxnvQ2kKM
         rJO7eFXUvvmkkkokdUwFlD/GnGi8wtG93v5SEw2tpUFevhoMyUcNMjEJI2rmKbF/uMl9
         vRSSL3IbNARjIOWKzaBhHCLomRMtSJ3LuoZjJUjvdnmwpU67AXbaeNrhqSNeqhpNC10A
         MJkw==
X-Gm-Message-State: AOAM531ba4pMgs5PHSbP9hVp/tUn3m+/ziAFkA53lyCDVcENpimrMpzS
        G/C+3wSKxUYjxCy9q6rRvon2F4VRxnXGQNsqJEXjQuEw8vnhhQ==
X-Google-Smtp-Source: ABdhPJwrHdB4Kty/56ZRa5JOtBSFNPRqlb4H2lwFBOov/5dyFRtZC+Yr1D1fJoECc7QtqzoNu+tm1iTflbWH942Iy+E=
X-Received: by 2002:a92:cec3:: with SMTP id z3mr9236418ilq.179.1618296738783;
 Mon, 12 Apr 2021 23:52:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210307194030.8007-1-ilya.lipnitskiy@gmail.com>
 <20210312151934.GA4209@alpha.franken.de> <CALCv0x1AEZanNsVcNuUrbHuLyWYNegEVuye9Gso-Ou9xX8JEAg@mail.gmail.com>
 <YFGip16ObFp/vOZS@kernel.org> <CALCv0x3sGY8t_NCch7qa6KijoxwvFJJYQEZB5kOMuK35C=c3og@mail.gmail.com>
 <20210406131043.GG9505@alpha.franken.de> <CALCv0x3rZXK2KYM+twkd_3v2bzqrVAXaA2NnaP8AJh76NeME8w@mail.gmail.com>
In-Reply-To: <CALCv0x3rZXK2KYM+twkd_3v2bzqrVAXaA2NnaP8AJh76NeME8w@mail.gmail.com>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Mon, 12 Apr 2021 23:52:07 -0700
Message-ID: <CALCv0x2w41HLRLMXSQcnD624kczRGmuR49KSRSDLm5mqmez6cA@mail.gmail.com>
Subject: Re: [PATCH] MIPS: fix memory reservation for non-usermem setups
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Mike Rapoport <rppt@kernel.org>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Jinyang He <hejinyang@loongson.cn>,
        Youling Tang <tangyouling@loongson.cn>,
        Tobias Wolf <dev-NTEO@vplace.de>,
        Marcin Nowakowski <marcin.nowakowski@mips.com>,
        linux-mips@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 11:45 PM Ilya Lipnitskiy
<ilya.lipnitskiy@gmail.com> wrote:
>
> Hi Thomas,
>
> On Tue, Apr 6, 2021 at 6:18 AM Thomas Bogendoerfer
> <tsbogend@alpha.franken.de> wrote:
> >
> > On Sat, Apr 03, 2021 at 07:02:13PM -0700, Ilya Lipnitskiy wrote:
> > > Hi Mike,
> > >
> > > On Tue, Mar 16, 2021 at 11:33 PM Mike Rapoport <rppt@kernel.org> wrote:
> > > >
> > > > Hi Ilya,
> > > >
> > > > On Tue, Mar 16, 2021 at 10:10:09PM -0700, Ilya Lipnitskiy wrote:
> > > > > Hi Thomas,
> > > > >
> > > > > On Fri, Mar 12, 2021 at 7:19 AM Thomas Bogendoerfer
> > > > > <tsbogend@alpha.franken.de> wrote:
> > > > > >
> > > > > > On Sun, Mar 07, 2021 at 11:40:30AM -0800, Ilya Lipnitskiy wrote:
> > > > > > > From: Tobias Wolf <dev-NTEO@vplace.de>
> > > > > > >
> > > > > > > Commit 67a3ba25aa95 ("MIPS: Fix incorrect mem=X@Y handling") introduced a new
> > > > > > > issue for rt288x where "PHYS_OFFSET" is 0x0 but the calculated "ramstart" is
> > > > > > > not. As the prerequisite of custom memory map has been removed, this results
> > > > > > > in the full memory range of 0x0 - 0x8000000 to be marked as reserved for this
> > > > > > > platform.
> > > > > >
> > > > > > and where is the problem here ?
> > > > > Turns out this was already attempted to be upstreamed - not clear why
> > > > > it wasn't merged. Context:
> > > > > https://lore.kernel.org/linux-mips/6504517.U6H5IhoIOn@loki/
> > > > >
> > > > > I hope the thread above helps you understand the problem.
> > > >
> > > > The memory initialization was a bit different then. Do you still see the
> > > > same problem?
> > > Thanks for asking. I obtained a RT2880 device and gave it a try. It
> > > hangs at boot without this patch, however selecting
> >
> > can you provide debug logs with memblock=debug for both good and bad
> > kernels ? I'm curious what's the reason for failing allocation...
> Sorry for taking a while to respond. See attached.
> FWIW, it seems these are the lines that stand out in hang.log:
> [    0.000000] memblock_reserve: [0x00000000-0x07ffffff] setup_arch+0x214/0x5d8
> [    0.000000] Wasting 1048576 bytes for tracking 32768 unused pages
> ...
> [    0.000000]  reserved[0x0]    [0x00000000-0x087137aa], 0x087137ab
> bytes flags: 0x0
Just to be clear, good.log is mips-next tip (dbd815c0dcca) and
hang.log is the same with MIPS_AUTO_PFN_OFFSET _NOT_ selected.

Ilya
