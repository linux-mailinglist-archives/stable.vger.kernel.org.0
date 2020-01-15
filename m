Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27DB813C809
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 16:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgAOPiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 10:38:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgAOPiv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 10:38:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D5082053B;
        Wed, 15 Jan 2020 15:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579102731;
        bh=VfAhkaKAnkXX62rx+rVpmNr9hKaz+vBQnrH8Eb5sEB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AWGat0U491gn56f4Zn/NrrYtO03jORHTmWOP7Ilf1CJt8VcyTron/QzXC0528foXg
         v1vrML4Vg8Bn9xqhBofwHahA5viktAz35amHvJCZP0cYqq691dH0wr8pI/pCPXWIS2
         Spglh7pUMjkoVyDYwFe8LTuYmcjLUc1pBp+YQ08k=
Date:   Wed, 15 Jan 2020 16:38:48 +0100
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
Subject: Re: [PATCH for 4.19-stable 08/25] mm, memory_hotplug: update a
 comment in unregister_memory()
Message-ID: <20200115153848.GB3881751@kroah.com>
References: <20200115153339.36409-1-david@redhat.com>
 <20200115153339.36409-9-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115153339.36409-9-david@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 15, 2020 at 04:33:22PM +0100, David Hildenbrand wrote:
> commit 16df1456aa858a86f398dbc7d27649eb6662b0cc upstream.
> 
> The remove_memory_block() function was renamed to in commit
> cc292b0b4302 ("drivers/base/memory.c: rename remove_memory_block() to
> remove_memory_section()").
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  drivers/base/memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

I just picked a random patch out of this series as an example to show
that you lost the authorship information on these.  This was originally
created by Dan, so that needs to be here with a "From:" line.

All of these need to be fixed up that way, I can't take them as-is,
sorry.

thanks,

greg k-h
