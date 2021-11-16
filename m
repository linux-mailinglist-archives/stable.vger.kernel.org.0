Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7986E453946
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 19:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbhKPSSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 13:18:31 -0500
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:58656 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236111AbhKPSSa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 13:18:30 -0500
Received: from [128.177.79.46] (helo=csail.mit.edu)
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1mn2zO-00026C-FP; Tue, 16 Nov 2021 13:15:26 -0500
Date:   Tue, 16 Nov 2021 10:18:37 -0800
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     Joe Perches <joe@perches.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, jgross@suse.com,
        x86@kernel.org, pv-drivers@vmware.com,
        Alexey Makhalov <amakhalov@vmware.com>,
        Deep Shah <sdeep@vmware.com>, stable@vger.kernel.org,
        virtualization@lists.linux-foundation.org, keerthanak@vmware.com,
        srivatsab@vmware.com, anishs@vmware.com, vithampi@vmware.com,
        linux-kernel@vger.kernel.org, namit@vmware.com, kuba@kernel.org,
        rostedt@goodmis.org
Subject: Re: [PATCH v3 1/3] MAINTAINERS: Update maintainers for paravirt ops
 and VMware hypervisor interface
Message-ID: <20211116181837.GA24696@csail.mit.edu>
References: <163657479269.84207.13658789048079672839.stgit@srivatsa-dev>
 <163657487268.84207.5604596767569015608.stgit@srivatsa-dev>
 <YYy9P7Rjg9hntmm3@kroah.com>
 <20211111153916.GA7966@csail.mit.edu>
 <YY1krlfM5R7uEzJF@kroah.com>
 <20211111194002.GA8739@csail.mit.edu>
 <YY6hhWtvh+OvOqAl@sashalap>
 <20211115223900.GA22267@csail.mit.edu>
 <70cd970d6c39a5ea5e88cbf4b86031c22c5d10d4.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70cd970d6c39a5ea5e88cbf4b86031c22c5d10d4.camel@perches.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 08:33:40PM -0800, Joe Perches wrote:
> On Mon, 2021-11-15 at 14:39 -0800, Srivatsa S. Bhat wrote:
> > On Fri, Nov 12, 2021 at 12:16:53PM -0500, Sasha Levin wrote:
> > > Maybe we should just remove MAINTAINERS from stable trees to make it
> > > obvious.
> > 
> > I don't think we should go quite that far. Instead, perhaps we can
> > modify get_maintainer.pl (if needed) such that it prints out a warning
> > or reminder to consult the upstream MAINTAINERS file if the script is
> > invoked on an older stable kernel.
> 
> I don't see how that's feasible.
> 

Not that I'm pushing for this change, but isn't it straight-forward to
distinguish upstream and stable kernel releases based on their
versioning schemes? The SUBLEVEL in the Makefile is always 0 for
upstream, and positive for stable versions (ignoring ancient kernels
like v2.6.32, of course). Since stable kernels are behind mainline by
definition, anytime the get_maintainer.pl script is invoked on a
kernel with a positive SUBLEVEL value, we can print out the said
warning/reminder (if it is considered useful).

Regards,
Srivatsa
