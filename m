Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF213FCCBF
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 20:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbhHaSGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 14:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhHaSGT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Aug 2021 14:06:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 176896109E;
        Tue, 31 Aug 2021 18:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630433124;
        bh=lX9CFKri/7RMibznHqcncyqG7bi/W5VDaiK5GKrCPU4=;
        h=Date:From:To:Subject:From;
        b=PvcWd8ycob9XLGf6P08f1BX18eS5bsEBmNeJhqiGIMPlTvAOaYdRYjaf4IGLvopDW
         V7rT2YazWPj/+NQ1QXam4T5Y0CMoDXPx1eRd8Naq98Zfqh5L/rqBJL0G5zqbFxramx
         rzuryBc/wUWIifKO/8INOxDW6pD/0kXzftDUfAaI=
Date:   Tue, 31 Aug 2021 11:05:23 -0700
From:   akpm@linux-foundation.org
To:     cgoldswo@codeaurora.org, david@redhat.com, linmiaohe@huawei.com,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, stable@vger.kernel.org
Subject:  [merged]
 mm-memory_hotplug-fix-potential-permanent-lru-cache-disable.patch removed
 from -mm tree
Message-ID: <20210831180523.p_tfNaDsO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: fix potential permanent lru cache disable
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-fix-potential-permanent-lru-cache-disable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory_hotplug: fix potential permanent lru cache disable

If offline_pages failed after lru_cache_disable(), it forgot to do
lru_cache_enable() in error path.  So we would have lru cache disabled
permanently in this case.

Link: https://lkml.kernel.org/r/20210821094246.10149-3-linmiaohe@huawei.com
Fixes: d479960e44f2 ("mm: disable LRU pagevec during the migration temporarily")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Chris Goldsworthy <cgoldswo@codeaurora.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-potential-permanent-lru-cache-disable
+++ a/mm/memory_hotplug.c
@@ -1731,6 +1731,7 @@ failed_removal_isolated:
 	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
 	memory_notify(MEM_CANCEL_OFFLINE, &arg);
 failed_removal_pcplists_disabled:
+	lru_cache_enable();
 	zone_pcp_enable(zone);
 failed_removal:
 	pr_debug("memory offlining [mem %#010llx-%#010llx] failed due to %s\n",
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-gup-remove-set-but-unused-local-variable-major.patch
mm-gup-remove-unneed-local-variable-orig_refs.patch
mm-gup-remove-useless-bug_on-in-__get_user_pages.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge.patch
mm-gup-use-helper-page_aligned-in-populate_vma_page_range.patch
shmem-remove-unneeded-variable-ret.patch
shmem-remove-unneeded-header-file.patch
shmem-remove-unneeded-function-forward-declaration.patch
shmem-include-header-file-to-declare-swap_info.patch
mm-memcg-remove-unused-functions.patch
mm-memcg-save-some-atomic-ops-when-flush-is-already-true.patch
mm-hwpoison-remove-unneeded-variable-unmap_success.patch
mm-hwpoison-fix-potential-pte_unmap_unlock-pte-error.patch
mm-hwpoison-change-argument-struct-page-hpagep-to-hpage.patch
mm-hwpoison-fix-some-obsolete-comments.patch
mm-vmscan-remove-the-pagedirty-check-after-madv_free-pages-are-page_ref_freezed.patch
mm-vmscan-remove-misleading-setting-to-sc-priority.patch
mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch
mm-vmscan-add-else-to-remove-check_pending-label.patch
mm-vmstat-correct-some-wrong-comments.patch
mm-vmstat-simplify-the-array-size-calculation.patch
mm-vmstat-remove-unneeded-return-value.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

