Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6278B2F7CA4
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731707AbhAON2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:28:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:47550 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731632AbhAON2V (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 08:28:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7A8A6AC63;
        Fri, 15 Jan 2021 13:27:56 +0000 (UTC)
Date:   Fri, 15 Jan 2021 14:27:53 +0100
From:   Oscar Salvador <osalvador@suse.de>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     mike.kravetz@oracle.com, akpm@linux-foundation.org,
        n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH v6 5/5] mm: hugetlb: remove VM_BUG_ON_PAGE from
 page_huge_active
Message-ID: <20210115132753.GC10102@linux>
References: <20210115124942.46403-1-songmuchun@bytedance.com>
 <20210115124942.46403-6-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115124942.46403-6-songmuchun@bytedance.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 08:49:42PM +0800, Muchun Song wrote:
> The page_huge_active() can be called from scan_movable_pages() which
> do not hold a reference count to the HugeTLB page. So when we call
> page_huge_active() from scan_movable_pages(), the HugeTLB page can
> be freed parallel. Then we will trigger a BUG_ON which is in the
> page_huge_active() when CONFIG_DEBUG_VM is enabled. Just remove the
> VM_BUG_ON_PAGE.
> 
> Fixes: 7e1f049efb86 ("mm: hugetlb: cleanup using paeg_huge_active()")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Oscar Salvador <osalvador@suse.de>

-- 
Oscar Salvador
SUSE L3
