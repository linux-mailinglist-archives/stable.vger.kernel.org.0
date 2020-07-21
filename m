Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412CA2281E2
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 16:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgGUOUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 10:20:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726412AbgGUOUJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 10:20:09 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 676A920714;
        Tue, 21 Jul 2020 14:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595341209;
        bh=YmWHJsfLM9BY+EwJ4vpgR2q+DKDlAGqgo7bInGq+T8M=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=IgY/NMwOyMgHJ1wf6bbEqXnQ9CznrawtjH6jZeVrURbaGvW3abT4MNeAMF9pfWIxG
         xI53u69XK5GX0lC1KuOPsGY7g3Lc/ceNrMRJRCHbbl2kFY3jHFG173C7g6poFKBque
         tUk2/p4sg5+b9Z013jEs4lbzi2muBte5rqmcU5D4=
Date:   Tue, 21 Jul 2020 14:20:08 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Joonsoo Kim <iamjoonsoo.kim@lge.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm/page_alloc: fix non cma alloc context
In-Reply-To: <1595220978-9890-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1595220978-9890-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-Id: <20200721142009.676A920714@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: d7fefcc8de91 ("mm/cma: add PF flag to force non cma alloc").

The bot has tested the following trees: v5.7.9, v5.4.52.

v5.7.9: Failed to apply! Possible dependencies:
    01c0bfe061f30 ("mm: rename gfpflags_to_migratetype to gfp_migratetype for same convention")
    16867664936e3 ("mm,page_alloc,cma: conditionally prefer cma pageblocks for movable allocations")
    3334a45eb9e2b ("mm/page_alloc: use ac->high_zoneidx for classzone_idx")
    63b44f01f1974 ("include/linux/sched/mm.h: optimize current_gfp_context()")
    97a225e69a1f8 ("mm/page_alloc: integrate classzone_idx and high_zoneidx")
    a65064938b815 ("page_alloc: consider highatomic reserve in watermark fast")

v5.4.52: Failed to apply! Possible dependencies:
    01c0bfe061f30 ("mm: rename gfpflags_to_migratetype to gfp_migratetype for same convention")
    16867664936e3 ("mm,page_alloc,cma: conditionally prefer cma pageblocks for movable allocations")
    3334a45eb9e2b ("mm/page_alloc: use ac->high_zoneidx for classzone_idx")
    5644e1fbbfe15 ("mm/vmscan.c: fix data races using kswapd_classzone_idx")
    63b44f01f1974 ("include/linux/sched/mm.h: optimize current_gfp_context()")
    97a225e69a1f8 ("mm/page_alloc: integrate classzone_idx and high_zoneidx")
    a65064938b815 ("page_alloc: consider highatomic reserve in watermark fast")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
