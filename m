Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9A34517E0
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 23:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348182AbhKOWsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 17:48:53 -0500
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:46666 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351060AbhKOWiy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 17:38:54 -0500
Received: from [128.177.79.46] (helo=csail.mit.edu)
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1mmkZp-0005ex-25; Mon, 15 Nov 2021 17:35:49 -0500
Date:   Mon, 15 Nov 2021 14:39:00 -0800
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, jgross@suse.com,
        x86@kernel.org, pv-drivers@vmware.com,
        Alexey Makhalov <amakhalov@vmware.com>,
        Deep Shah <sdeep@vmware.com>, stable@vger.kernel.org,
        virtualization@lists.linux-foundation.org, keerthanak@vmware.com,
        srivatsab@vmware.com, anishs@vmware.com, vithampi@vmware.com,
        linux-kernel@vger.kernel.org, namit@vmware.com, joe@perches.com,
        kuba@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH v3 1/3] MAINTAINERS: Update maintainers for paravirt ops
 and VMware hypervisor interface
Message-ID: <20211115223900.GA22267@csail.mit.edu>
References: <163657479269.84207.13658789048079672839.stgit@srivatsa-dev>
 <163657487268.84207.5604596767569015608.stgit@srivatsa-dev>
 <YYy9P7Rjg9hntmm3@kroah.com>
 <20211111153916.GA7966@csail.mit.edu>
 <YY1krlfM5R7uEzJF@kroah.com>
 <20211111194002.GA8739@csail.mit.edu>
 <YY6hhWtvh+OvOqAl@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YY6hhWtvh+OvOqAl@sashalap>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 12, 2021 at 12:16:53PM -0500, Sasha Levin wrote:
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
> If you look at cases like these, I can see an argument around bringing
> it back to -stable. However, changes in the upstream MAINTAINERS file
> aren't limited to just change in maintainers.
> 
> How would we handle addition of maintainers of a new code upstream? Or
> removal of maintainers due to code deletion? Or code movement upstream
> that isn't reflected in the stable tree (think a driver graduating from
> staging).
> 

Good point!

> It becomes a mess quite quickly and the easiest solution here is to just
> use upstream's MAINTAINERS file.
> 

Agreed.

> Maybe we should just remove MAINTAINERS from stable trees to make it
> obvious.
> 

I don't think we should go quite that far. Instead, perhaps we can
modify get_maintainer.pl (if needed) such that it prints out a warning
or reminder to consult the upstream MAINTAINERS file if the script is
invoked on an older stable kernel.

Regards,
Srivatsa
