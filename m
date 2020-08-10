Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D62C240816
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgHJPCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgHJPCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 11:02:10 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAEBC061756
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 08:02:10 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id k4so9171357oik.2
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 08:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=PhSJwqqxHd3pEHWQKv9KWseV+VTAsDJX62SInVDKsCI=;
        b=O2WkW5kbVpQPecrZK+LfUIy1NZuaGwMcDPh9b6ZJjfFxRirSZl3umFAFP9PglJ9eJn
         1f72Eic/TNfaqsjzuH6RCAL12RWUpFkcB9Kk25CNq2Ns9YkniglNVe9CYzMYkVCfjp0I
         duwpSutUJ8G4cfrEawLPjOKh7mv8vRis1KmEOd8LCYXpWxoMm8EwcvEd3j8oydpC7r7W
         v6Z2sexpBJwiodJuxj3VRB+CcUIFTy+HYi7pvtGZ6RD2fU3VxzTmY2/V9Dtd1iJnQ3B9
         hqQU+nGtqcwKLIRXo45Y9nYsMeOKIPERlM+Hm3AEHN5q+NXUs5DtlbAOMLoMZUf7le6T
         Hgyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=PhSJwqqxHd3pEHWQKv9KWseV+VTAsDJX62SInVDKsCI=;
        b=o86g6F2KXZzIroOvs2+9PF2FqX+Fr8tpyL1vjUpTo8rv1DgRYTdzT6IrjGYfB4DFLd
         SJbx2cKF4KMdAUs4+6RWcyFToTcklb9xv52T4lbkM+H0gq+ndl5+40arcrLSP1+I1nOU
         /SpEQlAC+FXVqq16tJtSJRivGb71O/mbcpkMh1WH38KOpvJU+hK+0u+/ZSWuOGzh6jsk
         KCDeQfMz/ttXaOm8ImyitI4jrfooEyf5h7ig6i4yxyYnb8/0zCS6ZrgS+J2fbTQe7jgf
         n4AgDWvuVc9D3suirm5sWp/fU7ksYDvErQE2jApWUsmUecl8QMJ7brW7I4ZvcJeIHowb
         2MCA==
X-Gm-Message-State: AOAM533ER0CLa3Ih0Wyba4jp9vDQkZB4WQCrTtzZXwVPruZqZGX8M3tz
        EVG4kJhPO1Tqt856v/4R6U75cRfHm1Fj0GwlQSo=
X-Google-Smtp-Source: ABdhPJwyTyfkG6ThmzduanTVmXAjlZLAuevewFaRrFw47UK7303uizZgQMMO0IJk+EJzKK2tUQZMT1UI18hFJYcEwd8=
X-Received: by 2002:aca:4e92:: with SMTP id c140mr984991oib.70.1597071729237;
 Mon, 10 Aug 2020 08:02:09 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUW_f4d5_yDg0_Ox8nVd_6R=JNc8Bo9TgEzjLUy_1MdXOw@mail.gmail.com>
 <20200810100125.GA2405194@kroah.com> <20200810100149.GB2405194@kroah.com>
 <CA+icZUWzsHect3v_31-PE_qRfXk7hbORY8JpSkjQmoEFqMykiQ@mail.gmail.com>
 <20200810140551.GH2975990@sasha-vm> <CA+icZUU18HcsT8E4umxgHPWDwdR4YbaX29=Lk4-7AvW2=4c=hw@mail.gmail.com>
 <20200810144322.GA3761375@kroah.com> <CA+icZUVEOYnuuK2Ah1AzDpu9Fp0Rf_Ny+sVVF_TYYPT0h-Q6Sw@mail.gmail.com>
 <20200810145751.GA3961561@kroah.com> <CA+icZUU=kSmepa4pok6vV8FzrL1AGmo6DpkHV_9PSpbBA4iMdg@mail.gmail.com>
 <20200810150106.GA3962761@kroah.com>
In-Reply-To: <20200810150106.GA3962761@kroah.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 10 Aug 2020 17:01:57 +0200
Message-ID: <CA+icZUVw6Rx8OGN+Eo6ExhGfzHSjDBpbROn_Vq1P65xxGTb4pw@mail.gmail.com>
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

On Mon, Aug 10, 2020 at 5:00 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Aug 10, 2020 at 04:59:22PM +0200, Sedat Dilek wrote:
> > On Mon, Aug 10, 2020 at 4:57 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, Aug 10, 2020 at 04:46:18PM +0200, Sedat Dilek wrote:
> > > > On Mon, Aug 10, 2020 at 4:43 PM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > On Mon, Aug 10, 2020 at 04:29:55PM +0200, Sedat Dilek wrote:
> > > > > > On Mon, Aug 10, 2020 at 4:05 PM Sasha Levin <sashal@kernel.org> wrote:
> > > > > > >
> > > > > > > On Mon, Aug 10, 2020 at 12:11:40PM +0200, Sedat Dilek wrote:
> > > > > > > >On Mon, Aug 10, 2020 at 12:01 PM Greg Kroah-Hartman
> > > > > > > ><gregkh@linuxfoundation.org> wrote:
> > > > > > > >>
> > > > > > > >> On Mon, Aug 10, 2020 at 12:01:25PM +0200, Greg Kroah-Hartman wrote:
> > > > > > > >> > On Mon, Aug 10, 2020 at 11:52:30AM +0200, Sedat Dilek wrote:
> > > > > > > >> > > [ Hope I have the correct CC for linux-stable ML ]
> > > > > > > >> > >
> > > > > > > >> > > Hi Greg and Sasha,
> > > > > > > >> > >
> > > > > > > >> > > The base for <linux-stable-rc.git#queue/5.8> is Linux v5.7.14 where it
> > > > > > > >> > > should be Linux v5.8.
> > > > > > > >> >
> > > > > > > >> > What exactly do you mean by "#queue/5.8"?
> > > > > > > >> >
> > > > > > > >> > Is that a branch name?  Ah, never seen those before, maybe they are
> > > > > > > >> > something that Sasha creates?
> > > > > > > >>
> > > > > > > >> But yes, you are right, it seems to mirror queue/5.7 at the moment,
> > > > > > > >> which isn't correct.
> > > > > > > >>
> > > > > > > >> thanks,
> > > > > > > >
> > > > > > > >[ CC correct stable ML ]
> > > > > > > >
> > > > > > > >Exactly.
> > > > > > > >
> > > > > > > >With <linux-stable-rc.git#queue/5.8> I mean [1].
> > > > > > >
> > > > > > > Ah, thanks for pointing it out! I've fixed the script and pushed out a
> > > > > > > correct queue-5.8 branch.
> > > > > > >
> > > > > >
> > > > > > Thanks Sasha.
> > > > > >
> > > > > > Would you mind to take the random/random32 patches from Linus mainline
> > > > > > for queue/5.8 (see Linux v5.7.14)?
> > > > >
> > > > > Hm, most of them are already in 5.8.0, what ones are missing?  Let me go
> > > > > check...
> > > > >
> > > >
> > > > For x86-64 I have:
> > > >
> > > > $ KTAG="v5.8" ; git log --oneline $KTAG..
> > > > 0765242c3a25 (HEAD -> for-5.8/random-5.9) random: random.h should
> > > > include archrandom.h, not the other way around
> > > > ba4ac1491cff random32: move the pseudo-random 32-bit definitions to prandom.h
> > >
> > > I have no idea what these commits mean, sorry.
> > >
> > > The linux-stable-rc tree is rebased all the time, and I don't know what
> > > the queue/ directories are, Sasha uses those for stuff.
> > >
> > > So if you could provide the upstream git commit id that you are missing
> > > here, that would be great.
> > >
> > > thanks,
> > >
> >
> > My apologies...
> >
> > commit c0842fbc1b18c7a044e6ff3e8fa78bfa822c7d1a
> > random32: move the pseudo-random 32-bit definitions to prandom.h
> >
> > commit 585524081ecdcde1c719e63916c514866d898217
> > random: random.h should include archrandom.h, not the other way around
>
> Great, those are the two I queued up about 5 minutes ago.  I'll try to
> push out a -rc for 5.8 later today with these fixes in it.
>
> thanks,
>

Yupp, that would be fine.

- Sedat -
