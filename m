Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36BB213D6DB
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 10:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730687AbgAPJ0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 04:26:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729274AbgAPJ0W (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 04:26:22 -0500
Received: from localhost (static-140-208-78-212.thenetworkfactory.nl [212.78.208.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A79A1207FF;
        Thu, 16 Jan 2020 09:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579166781;
        bh=/rVgZuyW/YvassNaphB2Q9wK9rEiwLvqe2rtv2zQpMY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qw5TJ5GyLidNA6mr3nKuxn8zYn2QmuNYTg8wdzGdwnZ8o8zsBoYiSNVNa6QH1xnDm
         +0LrxAOGncWKaIAWPkbQ+cfHVz+SoS7YBtW1MepwYL4DDyGwxIQWUCHBWSCeoDy/mJ
         N0DE51B23eOBKrwGDYN3S5qFE/cGRkkeeaawn2vM=
Date:   Thu, 16 Jan 2020 10:26:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     stable@vger.kernel.org, linux-mm@kvack.org,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH for 4.19-stable 00/25] mm/memory_hotplug: backport of
 pending stable fixes
Message-ID: <20200116092618.GA84509@kroah.com>
References: <20200115153339.36409-1-david@redhat.com>
 <20200115153927.GC3881751@kroah.com>
 <4a09f161-e2f1-b506-f0fd-2d6c4ea1437c@redhat.com>
 <20200116083407.GB2359@kroah.com>
 <c32fff77-3fb3-a528-c7e7-7982aaee82e5@redhat.com>
 <20200116085455.GA27815@kroah.com>
 <55fe2656-c044-cbc5-6062-b9cba0354a8f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55fe2656-c044-cbc5-6062-b9cba0354a8f@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 16, 2020 at 09:59:44AM +0100, David Hildenbrand wrote:
> On 16.01.20 09:54, Greg Kroah-Hartman wrote:
> > On Thu, Jan 16, 2020 at 09:42:51AM +0100, David Hildenbrand wrote:
> >> On 16.01.20 09:34, Greg Kroah-Hartman wrote:
> >>> On Wed, Jan 15, 2020 at 04:54:59PM +0100, David Hildenbrand wrote:
> >>>>>
> >>>>> And why would 4.9 and 4.4 care about them?
> >>>>
> >>>> The crashes can be trigger under 4.9 and 4.4. If we decide that we do
> >>>> not care, then this series can be dropped.
> >>>
> >>> Do we have users of memory hotplug that are somehow stuck at those old
> >>> versions that can not upgrade?  Obviously this didn't work previously
> >>> for them, so moving to a modern kernel might be a good reason to get
> >>> this new feature :)
> >>
> >> That's a good point - but usually when you experience a crash it's too
> >> late for you to realize that you have to move to a newer release :) It
> >> used to work before 4.4 IIRC.
> >>
> >> (one case I am concerned with is when memory onlining after memory
> >> hotplug failed (e.g., because the was an OOM event happening
> >> concurrently) - then memory hotunplug will crash your system.)
> >>
> >> But yeah, I am not aware of a report where somebody actually hit any of
> >> these issues on a stable kernel.
> 
> Just to clarify: I can reproduce them of course :)
> 
> > 
> > Ok, let's start with 4.19 and 4.14 for these for now.  Should make
> > things easier, right?
> 
> What do you mean with "start with"? Drop this series and not do the
> backport, meaning people should switch to a stable kernel > 4.19 if they
> don't want surprises on memory unplug?

No, I'm saying I want to take this for 4.19, and 4.14 if you have it.

But your original series you sent needs to be fixed up, I can't take it
as-is for the authorship reasons.

thanks,

greg k-h
