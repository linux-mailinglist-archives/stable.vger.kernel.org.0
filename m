Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC8D453C90
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 00:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhKPXOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 18:14:32 -0500
Received: from smtprelay0024.hostedemail.com ([216.40.44.24]:38858 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229704AbhKPXOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 18:14:32 -0500
Received: from omf13.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id E5D631829912D;
        Tue, 16 Nov 2021 23:11:32 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf13.hostedemail.com (Postfix) with ESMTPA id F396A2000266;
        Tue, 16 Nov 2021 23:11:24 +0000 (UTC)
Message-ID: <d4e9430989b427e95448ef57b22605d1f4dbc499.camel@perches.com>
Subject: Re: [PATCH v3 1/3] MAINTAINERS: Update maintainers for paravirt ops
 and VMware hypervisor interface
From:   Joe Perches <joe@perches.com>
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Cc:     Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, jgross@suse.com,
        x86@kernel.org, pv-drivers@vmware.com,
        Alexey Makhalov <amakhalov@vmware.com>,
        Deep Shah <sdeep@vmware.com>, stable@vger.kernel.org,
        virtualization@lists.linux-foundation.org, keerthanak@vmware.com,
        srivatsab@vmware.com, anishs@vmware.com, vithampi@vmware.com,
        linux-kernel@vger.kernel.org, namit@vmware.com, kuba@kernel.org,
        rostedt@goodmis.org
Date:   Tue, 16 Nov 2021 15:11:28 -0800
In-Reply-To: <20211116181837.GA24696@csail.mit.edu>
References: <163657479269.84207.13658789048079672839.stgit@srivatsa-dev>
         <163657487268.84207.5604596767569015608.stgit@srivatsa-dev>
         <YYy9P7Rjg9hntmm3@kroah.com> <20211111153916.GA7966@csail.mit.edu>
         <YY1krlfM5R7uEzJF@kroah.com> <20211111194002.GA8739@csail.mit.edu>
         <YY6hhWtvh+OvOqAl@sashalap> <20211115223900.GA22267@csail.mit.edu>
         <70cd970d6c39a5ea5e88cbf4b86031c22c5d10d4.camel@perches.com>
         <20211116181837.GA24696@csail.mit.edu>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.90
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: F396A2000266
X-Stat-Signature: fopgi45mrrmohs63mm8zh3mmrq316zpw
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18gfxLs9Ei5ua9isHj0ybElXINBrGjr1+s=
X-HE-Tag: 1637104284-88717
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-11-16 at 10:18 -0800, Srivatsa S. Bhat wrote:
> On Mon, Nov 15, 2021 at 08:33:40PM -0800, Joe Perches wrote:
> > On Mon, 2021-11-15 at 14:39 -0800, Srivatsa S. Bhat wrote:
> > > On Fri, Nov 12, 2021 at 12:16:53PM -0500, Sasha Levin wrote:
> > > > Maybe we should just remove MAINTAINERS from stable trees to make it
> > > > obvious.
> > > 
> > > I don't think we should go quite that far. Instead, perhaps we can
> > > modify get_maintainer.pl (if needed) such that it prints out a warning
> > > or reminder to consult the upstream MAINTAINERS file if the script is
> > > invoked on an older stable kernel.
> > 
> > I don't see how that's feasible.
> > 
> 
> Not that I'm pushing for this change, but isn't it straight-forward to
> distinguish upstream and stable kernel releases based on their
> versioning schemes? The SUBLEVEL in the Makefile is always 0 for
> upstream, and positive for stable versions (ignoring ancient kernels
> like v2.6.32, of course). Since stable kernels are behind mainline by
> definition, anytime the get_maintainer.pl script is invoked on a
> kernel with a positive SUBLEVEL value, we can print out the said
> warning/reminder (if it is considered useful).

checkpatch doesn't work on trees, it works on patches.

