Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 982039F1C6
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 19:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfH0Rjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 13:39:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:47852 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727306AbfH0Rjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 13:39:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 078F3AF93;
        Tue, 27 Aug 2019 17:39:54 +0000 (UTC)
Date:   Tue, 27 Aug 2019 19:39:50 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Thomas Backlund <tmb@mageia.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH] Partially revert "mm/memcontrol.c: keep local VM
 counters in sync with the hierarchical ones"
Message-ID: <20190827173950.GJ7538@dhcp22.suse.cz>
References: <20190817004726.2530670-1-guro@fb.com>
 <20190817063616.GA11747@kroah.com>
 <20190817191518.GB11125@castle>
 <20190824125750.da9f0aac47cc0a362208f9ff@linux-foundation.org>
 <a082485b-8241-e73d-df09-5c878d181ddc@mageia.org>
 <20190827141016.GH7538@dhcp22.suse.cz>
 <20190827170618.GC21369@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827170618.GC21369@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 27-08-19 19:06:18, Greg KH wrote:
> On Tue, Aug 27, 2019 at 04:10:16PM +0200, Michal Hocko wrote:
> > On Sat 24-08-19 23:23:07, Thomas Backlund wrote:
> > > Den 24-08-2019 kl. 22:57, skrev Andrew Morton:
> > > > On Sat, 17 Aug 2019 19:15:23 +0000 Roman Gushchin <guro@fb.com> wrote:
> > > > 
> > > > > > > Fixes: 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sync with the hierarchical ones")
> > > > > > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > > > > > > Cc: Yafang Shao <laoar.shao@gmail.com>
> > > > > > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > > > > > ---
> > > > > > >   mm/memcontrol.c | 8 +++-----
> > > > > > >   1 file changed, 3 insertions(+), 5 deletions(-)
> > > > > > 
> > > > > > <formletter>
> > > > > > 
> > > > > > This is not the correct way to submit patches for inclusion in the
> > > > > > stable kernel tree.  Please read:
> > > > > >      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > > > > > for how to do this properly.
> > > > > 
> > > > > Oh, I'm sorry, will read and follow next time. Thanks!
> > > > 
> > > > 766a4c19d880 is not present in 5.2 so no -stable backport is needed, yes?
> > > > 
> > > 
> > > Unfortunately it got added in 5.2.7, so backport is needed.
> > 
> > yet another example of patch not marked for stable backported to the
> > stable tree. yay...
> 
> If you do not want autobot to pick up patches for specific
> subsystems/files, just let us know and we will add them to the
> blacklist.

Done that on several occasions over last year and so. I always get "yep
we are going to black list" and whoops and we are back there with
patches going to stable like nothing happened. We've been through this
discussion so many times I am tired of it and to be honest I simply do
not care anymore.

I will keep encouraging people to mark patches for stable but I do not
give a wee bit about any reports for the stable tree. Nor do I care
whether something made it in and we should be careful to mark another
patch for stable as a fixup like this one.

-- 
Michal Hocko
SUSE Labs
