Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26AAE240801
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 16:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgHJO7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 10:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727825AbgHJO7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 10:59:34 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A843C061756
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 07:59:34 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id 93so7523770otx.2
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 07:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=NrLXB4EpbZs7evTYbTVC/6YZfyiq6nh5twMdon4wvLo=;
        b=Mvz8zn0ICpTZGvWumZTkzyTto5trXkfDkMqL4tEBKf5gBbAi8nA31LYuZs2RODb6NU
         DhE+U96SSx1x8mXj1ayzl8hex7U5BcTE6rd5Eb/L83m4gDzoxUze8VYUn3Qc8oG/do8F
         TCHt1H5XeU1L/hXfn7Xp8sDNlUYzgiv5lgZK4rNn0XcaRWuLPjOKLLLMlvNSrJdatqNH
         I5bAV9nQWg5Bv2SSxoPbJ+qxpp7lqMXZGwup9Z9gQ9cFSBJ7TS883cNk63fjVg+hlVC8
         CXxBmdBVDV2VgTsJfuqclbuK7ssYQ0zA2nTOagZUMAclUEm5pMTMranmafXSG73sJbA6
         R0CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=NrLXB4EpbZs7evTYbTVC/6YZfyiq6nh5twMdon4wvLo=;
        b=YAbYIxYiJP1vCn+Zhcj4Exy4pcVwMtWs51gCIswCTMRd05fv46fR4CbzxnMGLiLDlH
         uSzin/e4377/bUIBeG65q+nzq+OPYEd08Lbu2EIS4AYq8hjnOr19/ML0Owdok66fhPIY
         FYY1maM7sVx1g5MmBkUsDc4K1Ec/i+Cg2jrHzXvUf27cI0mtOsssmdGHj/GukOwxdUfe
         65EJ06m4xjjIdlhD0RJzi6PFBf35TtDb6IJVnRf6L6qPIxvII7O5skgnXFORKKuNsuCJ
         kF5H68psfJlNd525wP/pmvXnUsRib10qSLzFmJT4y4yQSa+UX+91uMTUGZIWIz6RQ1Hp
         HFAg==
X-Gm-Message-State: AOAM530QkERCbTiLtbJloC00nWzQtouePDqUJGhcznaQB3mzSqtkC3GC
        epzO5N7xFr3HjKV0/yaYcj21nDZB6GPhp9Btw9c=
X-Google-Smtp-Source: ABdhPJybXRRfn6VTJl4rrt2dU1vGFT+xcQZP9IyktHMd8LXnd5V8X5W2f73Luw9lPZGMRvgkbIImXDwfX+t9+ZqOeQ0=
X-Received: by 2002:a9d:5e9a:: with SMTP id f26mr1037113otl.109.1597071573978;
 Mon, 10 Aug 2020 07:59:33 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUW_f4d5_yDg0_Ox8nVd_6R=JNc8Bo9TgEzjLUy_1MdXOw@mail.gmail.com>
 <20200810100125.GA2405194@kroah.com> <20200810100149.GB2405194@kroah.com>
 <CA+icZUWzsHect3v_31-PE_qRfXk7hbORY8JpSkjQmoEFqMykiQ@mail.gmail.com>
 <20200810140551.GH2975990@sasha-vm> <CA+icZUU18HcsT8E4umxgHPWDwdR4YbaX29=Lk4-7AvW2=4c=hw@mail.gmail.com>
 <20200810144322.GA3761375@kroah.com> <CA+icZUVEOYnuuK2Ah1AzDpu9Fp0Rf_Ny+sVVF_TYYPT0h-Q6Sw@mail.gmail.com>
 <20200810145751.GA3961561@kroah.com>
In-Reply-To: <20200810145751.GA3961561@kroah.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 10 Aug 2020 16:59:22 +0200
Message-ID: <CA+icZUU=kSmepa4pok6vV8FzrL1AGmo6DpkHV_9PSpbBA4iMdg@mail.gmail.com>
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

On Mon, Aug 10, 2020 at 4:57 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Aug 10, 2020 at 04:46:18PM +0200, Sedat Dilek wrote:
> > On Mon, Aug 10, 2020 at 4:43 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, Aug 10, 2020 at 04:29:55PM +0200, Sedat Dilek wrote:
> > > > On Mon, Aug 10, 2020 at 4:05 PM Sasha Levin <sashal@kernel.org> wrote:
> > > > >
> > > > > On Mon, Aug 10, 2020 at 12:11:40PM +0200, Sedat Dilek wrote:
> > > > > >On Mon, Aug 10, 2020 at 12:01 PM Greg Kroah-Hartman
> > > > > ><gregkh@linuxfoundation.org> wrote:
> > > > > >>
> > > > > >> On Mon, Aug 10, 2020 at 12:01:25PM +0200, Greg Kroah-Hartman wrote:
> > > > > >> > On Mon, Aug 10, 2020 at 11:52:30AM +0200, Sedat Dilek wrote:
> > > > > >> > > [ Hope I have the correct CC for linux-stable ML ]
> > > > > >> > >
> > > > > >> > > Hi Greg and Sasha,
> > > > > >> > >
> > > > > >> > > The base for <linux-stable-rc.git#queue/5.8> is Linux v5.7.14 where it
> > > > > >> > > should be Linux v5.8.
> > > > > >> >
> > > > > >> > What exactly do you mean by "#queue/5.8"?
> > > > > >> >
> > > > > >> > Is that a branch name?  Ah, never seen those before, maybe they are
> > > > > >> > something that Sasha creates?
> > > > > >>
> > > > > >> But yes, you are right, it seems to mirror queue/5.7 at the moment,
> > > > > >> which isn't correct.
> > > > > >>
> > > > > >> thanks,
> > > > > >
> > > > > >[ CC correct stable ML ]
> > > > > >
> > > > > >Exactly.
> > > > > >
> > > > > >With <linux-stable-rc.git#queue/5.8> I mean [1].
> > > > >
> > > > > Ah, thanks for pointing it out! I've fixed the script and pushed out a
> > > > > correct queue-5.8 branch.
> > > > >
> > > >
> > > > Thanks Sasha.
> > > >
> > > > Would you mind to take the random/random32 patches from Linus mainline
> > > > for queue/5.8 (see Linux v5.7.14)?
> > >
> > > Hm, most of them are already in 5.8.0, what ones are missing?  Let me go
> > > check...
> > >
> >
> > For x86-64 I have:
> >
> > $ KTAG="v5.8" ; git log --oneline $KTAG..
> > 0765242c3a25 (HEAD -> for-5.8/random-5.9) random: random.h should
> > include archrandom.h, not the other way around
> > ba4ac1491cff random32: move the pseudo-random 32-bit definitions to prandom.h
>
> I have no idea what these commits mean, sorry.
>
> The linux-stable-rc tree is rebased all the time, and I don't know what
> the queue/ directories are, Sasha uses those for stuff.
>
> So if you could provide the upstream git commit id that you are missing
> here, that would be great.
>
> thanks,
>

My apologies...

commit c0842fbc1b18c7a044e6ff3e8fa78bfa822c7d1a
random32: move the pseudo-random 32-bit definitions to prandom.h

commit 585524081ecdcde1c719e63916c514866d898217
random: random.h should include archrandom.h, not the other way around

Thanks,
- Sedat -
