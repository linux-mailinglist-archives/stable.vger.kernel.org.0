Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF1126BE4D
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 09:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgIPHkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 03:40:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbgIPHkQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 03:40:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCE7120684;
        Wed, 16 Sep 2020 07:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600242013;
        bh=/TYgk6+v7XDvduTpTKBKv7E9qPpOQ5/7PpwzvHW+BRY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=if9RQP/dVGwTEjJqCwltZV2ld/XG/Pwmzdltce3TyCmNCMA8DeoorJhH1J2P0il0E
         svJEJ4uFlcbPzRZLdmwq5M/sl/qRS17XYL3+xdO2Ggv2inXDMru8bict867iLy3Jy7
         BKIqC9ZVTws86gVo0aSWwi0CfAe+U3sLrVDiH8zM=
Date:   Wed, 16 Sep 2020 09:40:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     akpm@linux-foundation.org, David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, mhocko@suse.com,
        linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mm: replace memmap_context by meminit_context
Message-ID: <20200916074047.GA189144@kroah.com>
References: <20200915121541.GD4649@dhcp22.suse.cz>
 <20200915132624.9723-1-ldufour@linux.ibm.com>
 <20200916063325.GK142621@kroah.com>
 <0b3f2eb1-0efa-a491-c509-d16a7e18d8e8@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0b3f2eb1-0efa-a491-c509-d16a7e18d8e8@linux.ibm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 09:29:22AM +0200, Laurent Dufour wrote:
> Le 16/09/2020 à 08:33, Greg Kroah-Hartman a écrit :
> > On Tue, Sep 15, 2020 at 03:26:24PM +0200, Laurent Dufour wrote:
> > > The memmap_context enum is used to detect whether a memory operation is due
> > > to a hot-add operation or happening at boot time.
> > > 
> > > Make it general to the hotplug operation and rename it as meminit_context.
> > > 
> > > There is no functional change introduced by this patch
> > > 
> > > Suggested-by: David Hildenbrand <david@redhat.com>
> > > Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> > > ---
> > >   arch/ia64/mm/init.c    |  6 +++---
> > >   include/linux/mm.h     |  2 +-
> > >   include/linux/mmzone.h | 11 ++++++++---
> > >   mm/memory_hotplug.c    |  2 +-
> > >   mm/page_alloc.c        | 10 +++++-----
> > >   5 files changed, 18 insertions(+), 13 deletions(-)
> > 
> > <formletter>
> > 
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read:
> >      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > for how to do this properly.
> > 
> > </formletter>
> 
> Hi Greg,
> 
> I'm sorry, I read that document few days ago before sending the series and
> again this morning, but I can't figure out what I missed (following option
> 1).
> 
> Should the "Cc: stable@vger.kernel.org" tag be on each patch of the series
> even if the whole series has been sent to stable ?

That should be on any patch you expect to show up in a stable kernel
release.

> Should the whole series sent again (v4) instead of sending a fix as a reply to ?

It's up to the maintainer what they want, but as it is, this patch is
not going to end up in stable kernel release (which it looks like is the
right thing to do...)

thanks,

greg k-h
