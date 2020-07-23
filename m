Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FDF22AFDE
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 15:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgGWNCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 09:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbgGWNCN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 09:02:13 -0400
Received: from localhost (unknown [13.85.75.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BACDC20768;
        Thu, 23 Jul 2020 13:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595509332;
        bh=J8uQgUWrIWc0uu/NRgcU4aRyuD1TYn7ImdmzoBralOo=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=sARJ+7JnTNBzD2la/l5oy0PSKoh5lmWEpqOHpI1R95Vz3G/Ie3XA2613aLgPMpeVl
         xq8SbwQpuStJFR+KW9IMnUC9OieVibb3QlNe33kiWuXB7yUZ8XDYmQerJBKBZJNLVr
         0coHP2izFxGO2W92zv+D/K69i0jrWKl2hi5L0UUg=
Date:   Thu, 23 Jul 2020 13:02:12 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Joonsoo Kim <iamjoonsoo.kim@lge.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/page_alloc: fix memalloc_nocma_{save/restore} APIs
In-Reply-To: <1595468942-29687-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1595468942-29687-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-Id: <20200723130212.BACDC20768@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: d7fefcc8de91 ("mm/cma: add PF flag to force non cma alloc").

The bot has tested the following trees: v5.7.10, v5.4.53.

v5.7.10: Failed to apply! Possible dependencies:
    01c0bfe061f3 ("mm: rename gfpflags_to_migratetype to gfp_migratetype for same convention")
    16867664936e ("mm,page_alloc,cma: conditionally prefer cma pageblocks for movable allocations")
    3334a45eb9e2 ("mm/page_alloc: use ac->high_zoneidx for classzone_idx")
    3f08a302f533 ("mm: remove CONFIG_HAVE_MEMBLOCK_NODE_MAP option")
    854e8848c584 ("mm: clean up free_area_init_node() and its helpers")
    97a225e69a1f ("mm/page_alloc: integrate classzone_idx and high_zoneidx")

v5.4.53: Failed to apply! Possible dependencies:
    01c0bfe061f3 ("mm: rename gfpflags_to_migratetype to gfp_migratetype for same convention")
    16867664936e ("mm,page_alloc,cma: conditionally prefer cma pageblocks for movable allocations")
    3334a45eb9e2 ("mm/page_alloc: use ac->high_zoneidx for classzone_idx")
    34dc0ea6bc96 ("dma-direct: provide mmap and get_sgtable method overrides")
    3f08a302f533 ("mm: remove CONFIG_HAVE_MEMBLOCK_NODE_MAP option")
    854e8848c584 ("mm: clean up free_area_init_node() and its helpers")
    97a225e69a1f ("mm/page_alloc: integrate classzone_idx and high_zoneidx")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
