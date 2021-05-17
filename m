Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD6A382983
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 12:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236255AbhEQKK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 06:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236157AbhEQKK4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 06:10:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CB78611ED;
        Mon, 17 May 2021 10:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621246161;
        bh=ST4gUGDMwZNdueUNMzk7+ZLqMDz+4dbIe1J5sk8iGt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W5A0OhAo/pOfaseEM5leIt/8S+mWA47Ev86sUtR7r+5E4cIGiJ87eX+wCbVTk7oMo
         W292OQ9ExsQtKf+c71Q5EDnlhX8XmtsxmF0xTM6NsDXLsIIRkDKhhvMm1GCFsvxOBK
         3IHYxA+cVe/UcsdgFCbr3hCv6ATAhgsns5Atg9q0=
Date:   Mon, 17 May 2021 12:09:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     stable@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH 5.12] MIPS: Reinstate platform `__div64_32' handler
Message-ID: <YKJAzVrNwEQJ1Y8a@kroah.com>
References: <alpine.DEB.2.21.2105160318070.3032@angie.orcam.me.uk>
 <YKDiQUcuqIDwRvyg@kroah.com>
 <alpine.DEB.2.21.2105161558240.3032@angie.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2105161558240.3032@angie.orcam.me.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 16, 2021 at 04:01:09PM +0200, Maciej W. Rozycki wrote:
> On Sun, 16 May 2021, Greg KH wrote:
> 
> > > Reported-by: Huacai Chen <chenhuacai@kernel.org>
> > > Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> > > Fixes: c21004cd5b4c ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0.")
> > > Cc: stable@vger.kernel.org # v2.6.30+
> > > ---
> > > Hi,
> > > 
> > >  This is a backported version of commit c49f71f60754 with a fix for MIPSr6 
> > > compilation, that is commit 25ab14cbe9d1 included and the commit message 
> > > amended accordingly.  I have folded intermediate commit c1d337d45ec0 into 
> > > this change as well, as trivially obvious and mechanically in the way 
> > > between the two former changes, though strictly speaking an enhancement 
> > > rather than a fix.  This way the state between master and stable branches 
> > > is consistent.
> > > 
> > >  Rationale: the three changes could be applied separately as with master, 
> > > however we'd have an unnecessary intermediate MIPSr6 build regression, 
> > > which caused the drop of the original fix.
> > > 
> > >  This is for 5.12-stable and before.  Let me know if you'd prefer me to 
> > > resolve this differently, or otherwise please apply.
> > > 
> > >  NB verified with a couple of representative defconfigs and booted on hw 
> > > where available (with the test_div64 test module backported and enabled).
> > 
> > I would prefer to take the same exact commits that are in Linus's tree,
> > that makes it easier to track over time and ensure that we have this
> > correct.
> > 
> > So what commit ids should I apply in what order?
> 
>  Sure, this will be commits: c49f71f60754, c1d337d45ec0, 25ab14cbe9d1 in 
> the order given.

Wonderful, all now queued up, thanks.

greg k-h
