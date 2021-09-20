Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E1A412906
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 00:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhITWvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 18:51:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232542AbhITWtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 18:49:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DCA36115B;
        Mon, 20 Sep 2021 22:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632178104;
        bh=U+S/3CoC6CL0vC98vb7/yDPhHMMf5dX0ElDPAf8wRlA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IAghOrLyCDV/8PCC+9edElWmaWiP0TkP83EaoTySkPM/dXCK4GoL1PMz7e31os9rt
         3NiexeSrdrBULfXPArC1fgGGuxqxnsE6AH2kAR/VvU9XttvRU8974Sl2o5SWXFbXNr
         GOcyz9i/kSY6VZ81f/mwUNxxL7qhpxWU5zNOuJCKCpP5pl+p3qXILqK8Qe8aR8IkSa
         Nog7qYXxCERDCZgjlUM8ydqgLe4FAVzFV0XMnhyb0ASd9RQlGSKDZ1+qxfHnqp2ido
         ZFTJgCET7e60QS9khR6dZZZ01+NTpOnQQIgtb8ZwyGmyPn9/D1VBPMW7RhyNlzVrmm
         rg0SqN4u3pMBg==
Date:   Mon, 20 Sep 2021 15:48:18 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        marmarek@invisiblethingslab.com, Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@suse.de>,
        Mike Rapoport <rppt@linux.ibm.com>, stable@vger.kernel.org,
        x86@kernel.org
Subject: Re: [tip: x86/urgent] x86/setup: Call early_reserve_memory() earlier
Message-ID: <YUkPsjUUtRewyOn3@archlinux-ax161>
References: <20210914094108.22482-1-jgross@suse.com>
 <163178944634.25758.17304720937855121489.tip-bot2@tip-bot2>
 <4422257385dbee913eb5270bda5fded7fbb993ab.camel@gmx.de>
 <YUdwMm9ncgNuuN4f@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YUdwMm9ncgNuuN4f@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 19, 2021 at 07:15:30PM +0200, Borislav Petkov wrote:
> On Sun, Sep 19, 2021 at 06:55:16PM +0200, Mike Galbraith wrote:
> > On Thu, 2021-09-16 at 10:50 +0000, tip-bot2 for Juergen Gross wrote:
> > > The following commit has been merged into the x86/urgent branch of
> > > tip:
> > >
> > > Commit-ID:     1c1046581f1a3809e075669a3df0191869d96dd1
> > > Gitweb:       
> > > https://git.kernel.org/tip/1c1046581f1a3809e075669a3df0191869d96dd1
> > > Author:        Juergen Gross <jgross@suse.com>
> > > AuthorDate:    Tue, 14 Sep 2021 11:41:08 +02:00
> > > Committer:     Borislav Petkov <bp@suse.de>
> > > CommitterDate: Thu, 16 Sep 2021 12:38:05 +02:00
> > >
> > > x86/setup: Call early_reserve_memory() earlier
> > 
> > This commit rendered tip toxic to my i4790 desktop box and i5-6200U
> > lappy.  Boot for both is instantly over without so much as a twitch.
> > 
> > Post bisect revert made both all better.
> 
> I had a suspicion that moving stuff around like that would not just
> simply work in all cases, as our boot order is very lovely and fragile.
> 
> And it booted just fine on my machines here.
> 
> ;-\
> 
> Anyway, commit zapped from the x86/urgent lineup. We'll have to have a
> third try later.

Could auto-latest get updated too so that it does not show up in -next?
I just spent a solid chunk of my day bisecting a boot failure on one of
my test boxes on -next down to this change, only to find out it was
already reported :/

Cheers,
Nathan
