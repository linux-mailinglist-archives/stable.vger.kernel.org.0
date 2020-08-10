Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37432407C8
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 16:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgHJOqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 10:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbgHJOqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 10:46:30 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02368C061756
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 07:46:30 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id o21so9072178oie.12
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 07:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=tZmr9YCihl2pStkHH7P60J5/yFudIQias0fnPTJ54t0=;
        b=M1nUiK7bL+fFbOgnczGKUgFPId/7yRGt/QOQKnQBT+SQ38JKBlierRG8R+jWNYpU1F
         f77a+MeehseAYQrcsnA8vjfa0aX6aNd6JfhuZEVm8Oj4V2j3w9R1yhLTCqckQDY0xwBy
         w8stopWn79gdgR6DT1E4U5hGbZb1hthUwU8yMhl5bPf/Yb1fcs0VogtWr+Qov7v0Rjdv
         FGkk6i9xHPeLABI15WVoMgbqmyg+356rvxFpPBfD6p3vZ+ENaZOZ6Zkb4KFFkfrGGQVi
         aPQMY/sPvBg0obbUJ+mKgmKlF2o+VlkUwPdFmvcN95vxRcKgsZSsXVBbr3DJseQk/RaX
         7ldA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=tZmr9YCihl2pStkHH7P60J5/yFudIQias0fnPTJ54t0=;
        b=qfxW29+3lhfFVHYNG8UWiiLK0x2myg+8db5rTSnqBLoacfru0tDxIhdQcT+O7LmEct
         oZZgREdr5MSfjK6Ve3vQjtTMhmintD97Ec/VTD7lS0RvB3m7SGQljGAn77pzyGKGezcy
         W48HHSI3BAYuAFvnRNMT05Sg/jr7CX8hmkpQnA86Wt2wLMH/Vx9x8ECAMuLDrUjf4scU
         KP1e7OyK9oKDpATWgdS+NpK4Q60guuY1ihnppH81T+4PyxbtkU/CtsLqX/12BPvCCa4x
         /Z3nBKxVdPbEPEpzGavhCZ1+jRL5v6okO7nRXvxh6dVTzAiTEsStwrzs8BFXnZ3ZZKsO
         NthA==
X-Gm-Message-State: AOAM532fIc7zvTY/sblQuRG+Lguhc0jWsoxhjHVQBAwX1o9b0gw1WTMm
        bh2iWA7rUCBRW7Q+zkoV+lQXjvvUzHWOAzyJUhw=
X-Google-Smtp-Source: ABdhPJxKKI2HEdw+e11/GH/E8o0zdlVwdmdfwSnW+5Ae1s6CR1780c0UXmD50FLLdHwcKE4v7sAP5init8oQVTGN+4k=
X-Received: by 2002:aca:724f:: with SMTP id p76mr978298oic.35.1597070789469;
 Mon, 10 Aug 2020 07:46:29 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUW_f4d5_yDg0_Ox8nVd_6R=JNc8Bo9TgEzjLUy_1MdXOw@mail.gmail.com>
 <20200810100125.GA2405194@kroah.com> <20200810100149.GB2405194@kroah.com>
 <CA+icZUWzsHect3v_31-PE_qRfXk7hbORY8JpSkjQmoEFqMykiQ@mail.gmail.com>
 <20200810140551.GH2975990@sasha-vm> <CA+icZUU18HcsT8E4umxgHPWDwdR4YbaX29=Lk4-7AvW2=4c=hw@mail.gmail.com>
 <20200810144322.GA3761375@kroah.com>
In-Reply-To: <20200810144322.GA3761375@kroah.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 10 Aug 2020 16:46:18 +0200
Message-ID: <CA+icZUVEOYnuuK2Ah1AzDpu9Fp0Rf_Ny+sVVF_TYYPT0h-Q6Sw@mail.gmail.com>
Subject: Re: Base for <linux-stable-rc.git#queue/5.8>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 4:43 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Aug 10, 2020 at 04:29:55PM +0200, Sedat Dilek wrote:
> > On Mon, Aug 10, 2020 at 4:05 PM Sasha Levin <sashal@kernel.org> wrote:
> > >
> > > On Mon, Aug 10, 2020 at 12:11:40PM +0200, Sedat Dilek wrote:
> > > >On Mon, Aug 10, 2020 at 12:01 PM Greg Kroah-Hartman
> > > ><gregkh@linuxfoundation.org> wrote:
> > > >>
> > > >> On Mon, Aug 10, 2020 at 12:01:25PM +0200, Greg Kroah-Hartman wrote:
> > > >> > On Mon, Aug 10, 2020 at 11:52:30AM +0200, Sedat Dilek wrote:
> > > >> > > [ Hope I have the correct CC for linux-stable ML ]
> > > >> > >
> > > >> > > Hi Greg and Sasha,
> > > >> > >
> > > >> > > The base for <linux-stable-rc.git#queue/5.8> is Linux v5.7.14 where it
> > > >> > > should be Linux v5.8.
> > > >> >
> > > >> > What exactly do you mean by "#queue/5.8"?
> > > >> >
> > > >> > Is that a branch name?  Ah, never seen those before, maybe they are
> > > >> > something that Sasha creates?
> > > >>
> > > >> But yes, you are right, it seems to mirror queue/5.7 at the moment,
> > > >> which isn't correct.
> > > >>
> > > >> thanks,
> > > >
> > > >[ CC correct stable ML ]
> > > >
> > > >Exactly.
> > > >
> > > >With <linux-stable-rc.git#queue/5.8> I mean [1].
> > >
> > > Ah, thanks for pointing it out! I've fixed the script and pushed out a
> > > correct queue-5.8 branch.
> > >
> >
> > Thanks Sasha.
> >
> > Would you mind to take the random/random32 patches from Linus mainline
> > for queue/5.8 (see Linux v5.7.14)?
>
> Hm, most of them are already in 5.8.0, what ones are missing?  Let me go
> check...
>

For x86-64 I have:

$ KTAG="v5.8" ; git log --oneline $KTAG..
0765242c3a25 (HEAD -> for-5.8/random-5.9) random: random.h should
include archrandom.h, not the other way around
ba4ac1491cff random32: move the pseudo-random 32-bit definitions to prandom.h

- Sedat -
