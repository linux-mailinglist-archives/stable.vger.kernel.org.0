Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B10B64F6CF
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 18:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfFVQ1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 12:27:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:52884 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726276AbfFVQ1P (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 12:27:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7A142AE56;
        Sat, 22 Jun 2019 16:27:13 +0000 (UTC)
Date:   Sat, 22 Jun 2019 18:27:10 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "Stable tree ," <stable@vger.kernel.org>,
        "Jason Gunthorpe ," <jgg@mellanox.com>,
        "linux-mm@kvack.org, LKML ," <linux-kernel@vger.kernel.org>,
        "Andrea Arcangeli ," <aarcange@redhat.com>,
        "Jann Horn ," <jannh@google.com>,
        "Oleg Nesterov ," <oleg@redhat.com>,
        "Peter Xu ," <peterx@redhat.com>,
        "Mike Rapoport ," <rppt@linux.ibm.com>,
        "Andrew Morton ," <akpm@linux-foundation.org>,
        "Linus Torvalds ," <torvalds@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH stable-4.4 v3] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Message-ID: <20190622162710.GA15805@dhcp22.suse.cz>
References: <66C05D07-4075-400D-832C-C82120C93922@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66C05D07-4075-400D-832C-C82120C93922@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat 22-06-19 06:30:37, Ajay Kaher wrote:
> 
> > On Mon, Jun 17, 2019 at 08:58:24AM +0200, Michal Hocko wrote:
> > > From: Andrea Arcangeli <aarcange@redhat.com>
> > > 
> > > Upstream 04f5866e41fb70690e28397487d8bd8eea7d712a commit.
> > > 
> > > Signed-off-by: Michal Hocko <mhocko@suse.com>
> > > ---
> > >  drivers/android/binder.c          |  6 ++++++
> > >  drivers/infiniband/hw/mlx4/main.c |  3 +++
> > >  fs/proc/task_mmu.c                | 18 ++++++++++++++++++
> > >  fs/userfaultfd.c                  | 10 ++++++++--
> > >  include/linux/mm.h                | 21 +++++++++++++++++++++
> > >  mm/mmap.c                         |  7 ++++++-
> > >  6 files changed, 62 insertions(+), 3 deletions(-)
> >
> > I've queued this up now, as it looks like everyone agrees with it.  What
> > about a 4.9.y backport?
> 
> Greg, it's here please review.
> https://lore.kernel.org/stable/1561208539-29682-1-git-send-email-akaher@vmware.com/T/#m53eaf6e687cb27e46395173aa74a85c2ccb5c190
> 
> Michal, patched for binder code Thanks, would you like to suggest 
> if mmget_still_valid check require anywhere for khugepaged code.

khugepaged patch has gone its own way. See 59ea6d06cfa9 ("coredump: fix
race condition between collapse_huge_page() and core dumping")
-- 
Michal Hocko
SUSE Labs
