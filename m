Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86202407F4
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 16:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgHJO5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 10:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbgHJO5l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 10:57:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F10B2078D;
        Mon, 10 Aug 2020 14:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597071460;
        bh=pxMN1LFiKbW7Jz3h7hfE4Cp1D6x8Ajz4Iv86hx7nHeI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X8ySlCU7+ac4RHYdMKw72gCrmzP+ndpWW6kHSzHSv/NUOxflfSja4vVXaxFQkImfH
         9PU6Fg2Y/bhtUlq4CedQ9nkpT8vDtTHinxEyE8NF/7Y3GGOHzkWtIb4YSmO4SUnHn5
         EajUYG7hEq5JkOMozyEWnu28xwdip9jS8sWP8jPE=
Date:   Mon, 10 Aug 2020 16:57:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        stable@vger.kernel.org
Subject: Re: Base for <linux-stable-rc.git#queue/5.8>
Message-ID: <20200810145751.GA3961561@kroah.com>
References: <CA+icZUW_f4d5_yDg0_Ox8nVd_6R=JNc8Bo9TgEzjLUy_1MdXOw@mail.gmail.com>
 <20200810100125.GA2405194@kroah.com>
 <20200810100149.GB2405194@kroah.com>
 <CA+icZUWzsHect3v_31-PE_qRfXk7hbORY8JpSkjQmoEFqMykiQ@mail.gmail.com>
 <20200810140551.GH2975990@sasha-vm>
 <CA+icZUU18HcsT8E4umxgHPWDwdR4YbaX29=Lk4-7AvW2=4c=hw@mail.gmail.com>
 <20200810144322.GA3761375@kroah.com>
 <CA+icZUVEOYnuuK2Ah1AzDpu9Fp0Rf_Ny+sVVF_TYYPT0h-Q6Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVEOYnuuK2Ah1AzDpu9Fp0Rf_Ny+sVVF_TYYPT0h-Q6Sw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 04:46:18PM +0200, Sedat Dilek wrote:
> On Mon, Aug 10, 2020 at 4:43 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Aug 10, 2020 at 04:29:55PM +0200, Sedat Dilek wrote:
> > > On Mon, Aug 10, 2020 at 4:05 PM Sasha Levin <sashal@kernel.org> wrote:
> > > >
> > > > On Mon, Aug 10, 2020 at 12:11:40PM +0200, Sedat Dilek wrote:
> > > > >On Mon, Aug 10, 2020 at 12:01 PM Greg Kroah-Hartman
> > > > ><gregkh@linuxfoundation.org> wrote:
> > > > >>
> > > > >> On Mon, Aug 10, 2020 at 12:01:25PM +0200, Greg Kroah-Hartman wrote:
> > > > >> > On Mon, Aug 10, 2020 at 11:52:30AM +0200, Sedat Dilek wrote:
> > > > >> > > [ Hope I have the correct CC for linux-stable ML ]
> > > > >> > >
> > > > >> > > Hi Greg and Sasha,
> > > > >> > >
> > > > >> > > The base for <linux-stable-rc.git#queue/5.8> is Linux v5.7.14 where it
> > > > >> > > should be Linux v5.8.
> > > > >> >
> > > > >> > What exactly do you mean by "#queue/5.8"?
> > > > >> >
> > > > >> > Is that a branch name?  Ah, never seen those before, maybe they are
> > > > >> > something that Sasha creates?
> > > > >>
> > > > >> But yes, you are right, it seems to mirror queue/5.7 at the moment,
> > > > >> which isn't correct.
> > > > >>
> > > > >> thanks,
> > > > >
> > > > >[ CC correct stable ML ]
> > > > >
> > > > >Exactly.
> > > > >
> > > > >With <linux-stable-rc.git#queue/5.8> I mean [1].
> > > >
> > > > Ah, thanks for pointing it out! I've fixed the script and pushed out a
> > > > correct queue-5.8 branch.
> > > >
> > >
> > > Thanks Sasha.
> > >
> > > Would you mind to take the random/random32 patches from Linus mainline
> > > for queue/5.8 (see Linux v5.7.14)?
> >
> > Hm, most of them are already in 5.8.0, what ones are missing?  Let me go
> > check...
> >
> 
> For x86-64 I have:
> 
> $ KTAG="v5.8" ; git log --oneline $KTAG..
> 0765242c3a25 (HEAD -> for-5.8/random-5.9) random: random.h should
> include archrandom.h, not the other way around
> ba4ac1491cff random32: move the pseudo-random 32-bit definitions to prandom.h

I have no idea what these commits mean, sorry.

The linux-stable-rc tree is rebased all the time, and I don't know what
the queue/ directories are, Sasha uses those for stuff.

So if you could provide the upstream git commit id that you are missing
here, that would be great.

thanks,

greg k-h
