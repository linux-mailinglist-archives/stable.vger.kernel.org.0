Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D55B34085
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 09:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfFDHlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 03:41:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:56060 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726637AbfFDHlJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 03:41:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BB2AEADD5;
        Tue,  4 Jun 2019 07:41:07 +0000 (UTC)
Date:   Tue, 4 Jun 2019 09:41:00 +0200
From:   Oscar Salvador <osalvador@suse.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     akpm@linux-foundation.org, David Hildenbrand <david@redhat.com>,
        Jane Chu <jane.chu@oracle.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Paul Mackerras <paulus@samba.org>,
        Toshi Kani <toshi.kani@hpe.com>,
        Jeff Moyer <jmoyer@redhat.com>, Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>, stable@vger.kernel.org,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        linux-nvdimm@lists.01.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/12] mm: Sub-section memory hotplug support
Message-ID: <20190604074056.GA2853@linux>
References: <155718596657.130019.17139634728875079809.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155718596657.130019.17139634728875079809.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 06, 2019 at 04:39:26PM -0700, Dan Williams wrote:
> Changes since v7 [1]:
> 
> - Make subsection helpers pfn based rather than physical-address based
>   (Oscar and Pavel)
> 
> - Make subsection bitmap definition scalable for different section and
>   sub-section sizes across architectures. As a result:
> 
>       unsigned long map_active
> 
>   ...is converted to:
> 
>       DECLARE_BITMAP(subsection_map, SUBSECTIONS_PER_SECTION)
> 
>   ...and the helpers are renamed with a 'subsection' prefix. (Pavel)
> 
> - New in this version is a touch of arch/powerpc/include/asm/sparsemem.h
>   in "[PATCH v8 01/12] mm/sparsemem: Introduce struct mem_section_usage"
>   to define ARCH_SUBSECTION_SHIFT.
> 
> - Drop "mm/sparsemem: Introduce common definitions for the size and mask
>   of a section" in favor of Robin's "mm/memremap: Rename and consolidate
>   SECTION_SIZE" (Pavel)
> 
> - Collect some more Reviewed-by tags. Patches that still lack review
>   tags: 1, 3, 9 - 12

Hi Dan,

are you planning to send V10 anytime soon?

After you addressed comments from Patch#9, the general implementation looks
fine to me and nothing sticked out from the other patches.
But I would rather wait to see v10 with the comments addressed before stamping
my Reviewed-by.

I am planning to fire my vmemmap patchset again [1], and I would like to re-base
it on top of this work, otherwise we will face many unnecessary collisions.

Thanks

[1] https://patchwork.kernel.org/patch/10875025/

-- 
Oscar Salvador
SUSE L3
