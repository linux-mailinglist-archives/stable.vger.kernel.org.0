Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DECD6199722
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 15:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbgCaNLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 09:11:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730543AbgCaNLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 09:11:20 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A832620772;
        Tue, 31 Mar 2020 13:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585660279;
        bh=PC5PgxjIj/JTw0FZeDEEoYDhnVcOZuR1qdco51kVJps=;
        h=Date:From:To:To:To:To:CC:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:
         References:From;
        b=rirx7YUt1ZwGmSK2B8il4Thxh+D0uLDnwL+3V8E7rskXTHFBLuege4AJcC+eiiiKR
         4eOw2u9ATDPdYmnnIjf+lIXHkzNEGgnwNh/8PPyu3ZDHuOt8S2MMmSj/u6GSBXUmGO
         QHDnQcE2GabjBT5xLQa6Dfw1S0nBcAattrqyurdw=
Date:   Tue, 31 Mar 2020 13:11:18 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     "Longpeng(Mike)" <longpeng2@huawei.com>
To:     Longpeng <longpeng2@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC:     <kvm@vger.kernel.org>, <arei.gonglei@huawei.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Matthew Wilcox <willy@infradead.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v4] mm/hugetlb: fix a addressing exception caused by huge_pte_offset
In-Reply-To: <20200327234122.1985-1-longpeng2@huawei.com>
References: <20200327234122.1985-1-longpeng2@huawei.com>
Message-Id: <20200331131119.A832620772@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.13, v5.4.28, v4.19.113, v4.14.174, v4.9.217, v4.4.217.

v5.5.13: Build OK!
v5.4.28: Build OK!
v4.19.113: Build OK!
v4.14.174: Build OK!
v4.9.217: Failed to apply! Possible dependencies:
    166f61b9435a ("mm: codgin-style fixes")
    505a60e22560 ("asm-generic: introduce 5level-fixup.h")
    82b0f8c39a38 ("mm: join struct fault_env and vm_fault")
    953c66c2b22a ("mm: THP page cache support for ppc64")
    c2febafc6773 ("mm: convert generic code to 5-level paging")
    fd60775aea80 ("mm, thp: avoid unlikely branches for split_huge_pmd")

v4.4.217: Failed to apply! Possible dependencies:
    01c8f1c44b83 ("mm, dax, gpu: convert vm_insert_mixed to pfn_t")
    0e749e54244e ("dax: increase granularity of dax_clear_blocks() operations")
    166f61b9435a ("mm: codgin-style fixes")
    34c0fd540e79 ("mm, dax, pmem: introduce pfn_t")
    505a60e22560 ("asm-generic: introduce 5level-fixup.h")
    52db400fcd50 ("pmem, dax: clean up clear_pmem()")
    5c6a84a3f455 ("mm/kasan: Switch to using __pa_symbol and lm_alias")
    82b0f8c39a38 ("mm: join struct fault_env and vm_fault")
    9973c98ecfda ("dax: add support for fsync/sync")
    aac453635549 ("mm, oom: introduce oom reaper")
    ac401cc78242 ("dax: New fault locking")
    b2e0d1625e19 ("dax: fix lifetime of in-kernel dax mappings with dax_map_atomic()")
    bae473a423f6 ("mm: introduce fault_env")
    bc2466e42573 ("dax: Use radix tree entry lock to protect cow faults")
    c2febafc6773 ("mm: convert generic code to 5-level paging")
    e4b274915863 ("DAX: move RADIX_DAX_ definitions to dax.c")
    f9fe48bece3a ("dax: support dirty DAX entries in radix tree")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
