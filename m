Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FB926BD31
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 08:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgIPGcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 02:32:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgIPGcv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 02:32:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0097C206A5;
        Wed, 16 Sep 2020 06:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600237970;
        bh=POCzdNd7m+wkeL61cJUuuEZiB0GVhYvTSJ+RU8n3mtc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Khx4taHP46JKWz0xNhPjc56ajy3yocLcwlbpX4CWSVQSqHIgluXQucIOOb0+v4y9g
         +rFHMIpwBt7vBuKupjoxnCVhP6fqBc1v5RmLuLJdwQb3VRArxVak4yY8qh8Bzj0mFH
         DEPyzI+C/lbFjvcNxULrxfv+p0jtMyVdJiPt5xF0=
Date:   Wed, 16 Sep 2020 08:33:25 +0200
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
Message-ID: <20200916063325.GK142621@kroah.com>
References: <20200915121541.GD4649@dhcp22.suse.cz>
 <20200915132624.9723-1-ldufour@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915132624.9723-1-ldufour@linux.ibm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 03:26:24PM +0200, Laurent Dufour wrote:
> The memmap_context enum is used to detect whether a memory operation is due
> to a hot-add operation or happening at boot time.
> 
> Make it general to the hotplug operation and rename it as meminit_context.
> 
> There is no functional change introduced by this patch
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> ---
>  arch/ia64/mm/init.c    |  6 +++---
>  include/linux/mm.h     |  2 +-
>  include/linux/mmzone.h | 11 ++++++++---
>  mm/memory_hotplug.c    |  2 +-
>  mm/page_alloc.c        | 10 +++++-----
>  5 files changed, 18 insertions(+), 13 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
