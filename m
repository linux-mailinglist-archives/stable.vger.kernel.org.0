Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 817EF13D5FD
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 09:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731035AbgAPIeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 03:34:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726864AbgAPIeL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 03:34:11 -0500
Received: from localhost (static-140-208-78-212.thenetworkfactory.nl [212.78.208.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5340620748;
        Thu, 16 Jan 2020 08:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579163650;
        bh=oB3Kuz80X/AnzqQsD0lo8QTzdhWXofSdjsGKCAOOOOc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yYoYi3bhsdrbCumnUc9ufzCuG2UJ9QRlD/O/Aqlc5ny2coTwpOBmL/4K8+n4oMAzC
         eLnMThkU2dCw+tlaQz7mRhVqwSHgEQJJc0A51tLbEJ0x8e7lVoJUdDV+57r8V7qkV9
         A6Lymmr4lBZxAp0BwA6eVhGZkDcwY9UZw+7S6UnU=
Date:   Thu, 16 Jan 2020 09:34:07 +0100
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
Message-ID: <20200116083407.GB2359@kroah.com>
References: <20200115153339.36409-1-david@redhat.com>
 <20200115153927.GC3881751@kroah.com>
 <4a09f161-e2f1-b506-f0fd-2d6c4ea1437c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a09f161-e2f1-b506-f0fd-2d6c4ea1437c@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 15, 2020 at 04:54:59PM +0100, David Hildenbrand wrote:
> > 
> > And why would 4.9 and 4.4 care about them?
> 
> The crashes can be trigger under 4.9 and 4.4. If we decide that we do
> not care, then this series can be dropped.

Do we have users of memory hotplug that are somehow stuck at those old
versions that can not upgrade?  Obviously this didn't work previously
for them, so moving to a modern kernel might be a good reason to get
this new feature :)

thanks,

greg k-h
