Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB2F2D571B
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 10:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbgLJJ2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 04:28:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgLJJ2X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 04:28:23 -0500
Date:   Thu, 10 Dec 2020 10:28:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607592463;
        bh=ALsu4fv9LUiXbofV9loYFZ/nlLyNOedi/phCg2wg4rA=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=S46lt3jyJFpy8iVMc0TVwN5okhxSQd+4Ux13XmKk/d5B/yn92N5eI0KVIjbVf5HFz
         2QSeX0hHyxcHyDyN70FT7nVregU8s68f7/+oOdAUyF47RTV1AZdms65w1DhsfrxhIg
         aoyjuWvVEvklkvZB41AN0L8YT815Zx3m56mLC7Xg=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: memblock: enforce overlap of memory.memblock
 and memory.reserved
Message-ID: <X9HqWd97rmIkOzLX@kroah.com>
References: <20201209214304.6812-1-rppt@kernel.org>
 <20201209214304.6812-2-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209214304.6812-2-rppt@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 09, 2020 at 11:43:03PM +0200, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> memblock does not require that the reserved memory ranges will be a subset
> of memblock.memory.
> 
> As the result there maybe reserved pages that are not in the range of any
> zone or node because zone and node boundaries are detected based on
> memblock.memory and pages that only present in memblock.reserved are not
> taken into account during zone/node size detection.
> 
> Make sure that all ranges in memblock.reserved are added to memblock.memory
> before calculating node and zone boundaries.
> 
> Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
> Reported-by: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>  include/linux/memblock.h |  1 +
>  mm/memblock.c            | 24 ++++++++++++++++++++++++
>  mm/page_alloc.c          |  7 +++++++
>  3 files changed, 32 insertions(+)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
