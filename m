Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF5544DBBB
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 19:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhKKSry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 13:47:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:34290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233425AbhKKSry (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Nov 2021 13:47:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54ADF61247;
        Thu, 11 Nov 2021 18:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636656304;
        bh=8RZy03sKFmPQxQGWpXw06dPaHhv2NHWVZwLqTolSEBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AgZ16xZyM0xpofvm47bb+5pA7KgECxsSn04+0rcqYZy6FuVFnASXPEEzSyGB6ac06
         lG2CM1rrx0R+mBr7DXTJnczIs3tZwL8SuKJMlszy2YQkB4DJhz6AALtVzgNcJlCsxa
         q/QXVTOEY99q8BKwxL6ikWFdvA2R0qmFstCeSgMI=
Date:   Thu, 11 Nov 2021 19:45:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Cc:     jgross@suse.com, x86@kernel.org, pv-drivers@vmware.com,
        Alexey Makhalov <amakhalov@vmware.com>,
        Deep Shah <sdeep@vmware.com>, stable@vger.kernel.org,
        virtualization@lists.linux-foundation.org, keerthanak@vmware.com,
        srivatsab@vmware.com, anishs@vmware.com, vithampi@vmware.com,
        linux-kernel@vger.kernel.org, namit@vmware.com, joe@perches.com,
        kuba@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH v3 1/3] MAINTAINERS: Update maintainers for paravirt ops
 and VMware hypervisor interface
Message-ID: <YY1krlfM5R7uEzJF@kroah.com>
References: <163657479269.84207.13658789048079672839.stgit@srivatsa-dev>
 <163657487268.84207.5604596767569015608.stgit@srivatsa-dev>
 <YYy9P7Rjg9hntmm3@kroah.com>
 <20211111153916.GA7966@csail.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111153916.GA7966@csail.mit.edu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 11, 2021 at 07:39:16AM -0800, Srivatsa S. Bhat wrote:
> On Thu, Nov 11, 2021 at 07:50:39AM +0100, Greg KH wrote:
> > On Wed, Nov 10, 2021 at 12:08:16PM -0800, Srivatsa S. Bhat wrote:
> > > From: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> > > 
> > > Deep has decided to transfer maintainership of the VMware hypervisor
> > > interface to Srivatsa, and the joint-maintainership of paravirt ops in
> > > the Linux kernel to Srivatsa and Alexey. Update the MAINTAINERS file
> > > to reflect this change.
> > > 
> > > Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> > > Acked-by: Alexey Makhalov <amakhalov@vmware.com>
> > > Acked-by: Deep Shah <sdeep@vmware.com>
> > > Acked-by: Juergen Gross <jgross@suse.com>
> > > Cc: stable@vger.kernel.org
> > 
> > Why are MAINTAINERS updates needed for stable?  That's not normal :(
> 
> So that people posting bug-fixes / backports to these subsystems for
> older kernels (stable and LTS releases) will CC the new subsystem
> maintainers.

That's not how stable releases work at all.

> That's why I added CC stable tag only to the first two
> patches which add/replace maintainers and not the third patch which is
> just a cleanup.

Patches for stable kernels need to go into Linus's tree first, and if
you have the MAINTAINERS file updated properly there, then you will be
properly cc:ed.  We do not look at the MAINTAINERS file for the older
kernel when sending patches out, it's totally ignored as that was the
snapshot at a point in time, which is usually no longer the true state.

So this would have no affect at all, sorry.  That's why I asked if you
all really realized what you were doing here :)

thanks,

greg k-h
