Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A361213D639
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 09:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgAPIy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 03:54:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbgAPIy7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 03:54:59 -0500
Received: from localhost (static-140-208-78-212.thenetworkfactory.nl [212.78.208.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 279BD2077B;
        Thu, 16 Jan 2020 08:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579164898;
        bh=im6PH8G5iv9p2TMDcipnhtQ7gjuFRc6yjB1ZyTlIgTo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VZm4MXe3srwoo2p6n2vvF0dVJ/eP/E3GehgNvMe3jEncQW1I1w9gYBqfmy9Q7/HcK
         H83QNZqvIFcBQAvYH6HyMhw4QCgA1QPCqg/o1g/Ka57FSZnGAoQhxjjCdEV2soq7Ra
         XS623AmUIvi/UKdOQJKHNiJUJU7LxzPigUKvnn4E=
Date:   Thu, 16 Jan 2020 09:54:55 +0100
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
Message-ID: <20200116085455.GA27815@kroah.com>
References: <20200115153339.36409-1-david@redhat.com>
 <20200115153927.GC3881751@kroah.com>
 <4a09f161-e2f1-b506-f0fd-2d6c4ea1437c@redhat.com>
 <20200116083407.GB2359@kroah.com>
 <c32fff77-3fb3-a528-c7e7-7982aaee82e5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c32fff77-3fb3-a528-c7e7-7982aaee82e5@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 16, 2020 at 09:42:51AM +0100, David Hildenbrand wrote:
> On 16.01.20 09:34, Greg Kroah-Hartman wrote:
> > On Wed, Jan 15, 2020 at 04:54:59PM +0100, David Hildenbrand wrote:
> >>>
> >>> And why would 4.9 and 4.4 care about them?
> >>
> >> The crashes can be trigger under 4.9 and 4.4. If we decide that we do
> >> not care, then this series can be dropped.
> > 
> > Do we have users of memory hotplug that are somehow stuck at those old
> > versions that can not upgrade?  Obviously this didn't work previously
> > for them, so moving to a modern kernel might be a good reason to get
> > this new feature :)
> 
> That's a good point - but usually when you experience a crash it's too
> late for you to realize that you have to move to a newer release :) It
> used to work before 4.4 IIRC.
> 
> (one case I am concerned with is when memory onlining after memory
> hotplug failed (e.g., because the was an OOM event happening
> concurrently) - then memory hotunplug will crash your system.)
> 
> But yeah, I am not aware of a report where somebody actually hit any of
> these issues on a stable kernel.

Ok, let's start with 4.19 and 4.14 for these for now.  Should make
things easier, right?

thanks,

greg k-h
