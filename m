Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD96F2F4968
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 12:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbhAMLBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 06:01:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:49604 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727748AbhAMLBf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 06:01:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 90C19AB92;
        Wed, 13 Jan 2021 11:00:53 +0000 (UTC)
Date:   Wed, 13 Jan 2021 12:00:51 +0100
From:   Oscar Salvador <osalvador@suse.de>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     mike.kravetz@oracle.com, akpm@linux-foundation.org,
        n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH v4 2/6] mm: hugetlbfs: fix cannot migrate the fallocated
 HugeTLB page
Message-ID: <20210113110051.GB26599@linux>
References: <20210113052209.75531-1-songmuchun@bytedance.com>
 <20210113052209.75531-3-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113052209.75531-3-songmuchun@bytedance.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 13, 2021 at 01:22:05PM +0800, Muchun Song wrote:
> If a new hugetlb page is allocated during fallocate it will not be
> marked as active (set_page_huge_active) which will result in a later
> isolate_huge_page failure when the page migration code would like to
> move that page. Such a failure would be unexpected and wrong.
> 
> Only export set_page_huge_active, just leave clear_page_huge_active
> as static. Because there are no external users.
> 
> Fixes: 70c3547e36f5 (hugetlbfs: add hugetlbfs_fallocate())
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Oscar Salvador <osalvador@suse.de>

-- 
Oscar Salvador
SUSE L3
