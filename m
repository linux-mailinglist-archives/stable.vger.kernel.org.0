Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A3744EBF8
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 18:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbhKLRbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 12:31:24 -0500
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:43413 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232231AbhKLRbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Nov 2021 12:31:22 -0500
Received: from [128.177.79.46] (helo=csail.mit.edu)
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1mlaLj-0005KE-Ea; Fri, 12 Nov 2021 12:28:27 -0500
Date:   Fri, 12 Nov 2021 09:31:36 -0800
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     jgross@suse.com, x86@kernel.org, pv-drivers@vmware.com,
        Alexey Makhalov <amakhalov@vmware.com>,
        Deep Shah <sdeep@vmware.com>, stable@vger.kernel.org,
        virtualization@lists.linux-foundation.org, keerthanak@vmware.com,
        srivatsab@vmware.com, anishs@vmware.com, vithampi@vmware.com,
        linux-kernel@vger.kernel.org, namit@vmware.com, joe@perches.com,
        kuba@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH v3 1/3] MAINTAINERS: Update maintainers for paravirt ops
 and VMware hypervisor interface
Message-ID: <20211112173136.GA11364@csail.mit.edu>
References: <163657479269.84207.13658789048079672839.stgit@srivatsa-dev>
 <163657487268.84207.5604596767569015608.stgit@srivatsa-dev>
 <YYy9P7Rjg9hntmm3@kroah.com>
 <20211111153916.GA7966@csail.mit.edu>
 <YY1krlfM5R7uEzJF@kroah.com>
 <20211111194002.GA8739@csail.mit.edu>
 <YY4P0lxIDNcOlc+2@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YY4P0lxIDNcOlc+2@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 12, 2021 at 07:55:14AM +0100, Greg KH wrote:
> On Thu, Nov 11, 2021 at 11:40:02AM -0800, Srivatsa S. Bhat wrote:
> > On Thu, Nov 11, 2021 at 07:45:02PM +0100, Greg KH wrote:
> > > On Thu, Nov 11, 2021 at 07:39:16AM -0800, Srivatsa S. Bhat wrote:
> > > > On Thu, Nov 11, 2021 at 07:50:39AM +0100, Greg KH wrote:
> > > > > On Wed, Nov 10, 2021 at 12:08:16PM -0800, Srivatsa S. Bhat wrote:
> > > > > > From: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> > > > > > 
> > > > > > Deep has decided to transfer maintainership of the VMware hypervisor
> > > > > > interface to Srivatsa, and the joint-maintainership of paravirt ops in
> > > > > > the Linux kernel to Srivatsa and Alexey. Update the MAINTAINERS file
> > > > > > to reflect this change.
> > > > > > 
> > > > > > Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> > > > > > Acked-by: Alexey Makhalov <amakhalov@vmware.com>
> > > > > > Acked-by: Deep Shah <sdeep@vmware.com>
> > > > > > Acked-by: Juergen Gross <jgross@suse.com>
> > > > > > Cc: stable@vger.kernel.org
> > > > > 
> > > > > Why are MAINTAINERS updates needed for stable?  That's not normal :(
> > > > 
> > > > So that people posting bug-fixes / backports to these subsystems for
> > > > older kernels (stable and LTS releases) will CC the new subsystem
> > > > maintainers.
> > > 
> > > That's not how stable releases work at all.
> > > 
> > > > That's why I added CC stable tag only to the first two
> > > > patches which add/replace maintainers and not the third patch which is
> > > > just a cleanup.
> > > 
> > > Patches for stable kernels need to go into Linus's tree first, and if
> > > you have the MAINTAINERS file updated properly there, then you will be
> > > properly cc:ed.  We do not look at the MAINTAINERS file for the older
> > > kernel when sending patches out, it's totally ignored as that was the
> > > snapshot at a point in time, which is usually no longer the true state.
> > > 
> > 
> > Sure, but that's the case for patches that get mainlined (and
> > subsequently backported to -stable) /after/ this update to the
> > MAINTAINERS file gets merged into mainline.
> > 
> > When adding the CC stable tag, the case I was trying to address was
> > for patches that are already in mainline but weren't CC'ed to stable,
> > and at some later point, somebody decides to backport them to older
> > stable kernels. In that case, there is a chance that the contributor
> > might run ./get_maintainer.pl against the stable tree (as that's the
> > tree they are backporting the upstream commit against) and end up not
> > CC'ing the new maintainers. So, I thought it would be good to keep the
> > maintainer info updated in the older stable kernels too.
> 
> I always ask that the current maintainers of the code be cc:ed when
> asking for commits to be backported to the stable tree, so I think this
> is not something you need to worry about.  I don't want to have to deal
> with hundreds of patches to try to keep the MAINTAINERS file "up to
> date" for this very very rare event.
> 

Sounds good, thank you!

> You can prove me wrong by looking at our email archives and see where I
> have missed ever doing this in the past 18 years and what the frequency
> of it is...
>

I believe you :-)

> But for now, no, this is not stable kernel material.
>

I understand, and thank you for the clarification!

Regards,
Srivatsa
