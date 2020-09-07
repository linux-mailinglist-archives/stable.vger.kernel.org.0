Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1A325FCA5
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 17:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730119AbgIGPJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 11:09:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730072AbgIGPDv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 11:03:51 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D2782137B;
        Mon,  7 Sep 2020 15:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599491019;
        bh=s02ihlFCpYIFCfeyr2IlfeANF9z5bE3QywJdCTN81+E=;
        h=Date:From:To:To:To:cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=V86W9bPy72xP8yEZBkTXzUZUedBf/aGKiYv9N9WYK+6jHZS4MMloxoeGBqR8/Vdl9
         G/EhsYhvtv719u1q0IB8uCq06CK+Yi/CIJcQzTZefcRot/J8Uuds+120FEoGASsgZd
         csGxXOLM7OM87VS4epmTFp4ZfXNU36HikuRY0stw=
Date:   Mon, 07 Sep 2020 15:03:38 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>
cc:     Jann Horn <jannh@google.com>, Christoph Hellwig <hch@lst.de>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ext2: don't update mtime on COW faults
In-Reply-To: <alpine.LRH.2.02.2009050811200.12419@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2009050811200.12419@file01.intranet.prod.int.rdu2.redhat.com>
Message-Id: <20200907150339.0D2782137B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.7, v5.4.63, v4.19.143, v4.14.196, v4.9.235, v4.4.235.

v5.8.7: Build OK!
v5.4.63: Build OK!
v4.19.143: Build OK!
v4.14.196: Failed to apply! Possible dependencies:
    06856938112b ("fs: ext2: Adding new return type vm_fault_t")
    1b5a1cb21e0c ("dax: Inline dax_insert_mapping() into the callsite")
    31a6f1a6e5a4 ("dax: Simplify arguments of dax_insert_mapping()")
    5e161e4066d3 ("dax: Factor out getting of pfn out of iomap")
    9a0dd4225143 ("dax: Allow dax_iomap_fault() to return pfn")
    a0987ad5c576 ("dax: Create local variable for VMA in dax_iomap_pte_fault()")
    aaa422c4c3f6 ("fs, dax: unify IOMAP_F_DIRTY read vs write handling policy in the dax core")
    c0b246259792 ("dax: pass detailed error code from dax_iomap_fault()")
    caa51d26f85c ("dax, iomap: Add support for synchronous faults")
    cec04e8c825e ("dax: Fix comment describing dax_iomap_fault()")
    d2c43ef13327 ("dax: Create local variable for vmf->flags & FAULT_FLAG_WRITE test")
    f5b7b74876cf ("dax: Allow tuning whether dax_insert_mapping_entry() dirties entry")

v4.9.235: Failed to apply! Possible dependencies:
    024b6a63138c ("gpu: drm: gma500: Use vma_pages()")
    11bac8000449 ("mm, fs: reduce fault, page_mkwrite, and pfn_mkwrite to take only vmf")
    1a29d85eb0f1 ("mm: use vmf->address instead of of vmf->virtual_address")
    82b0f8c39a38 ("mm: join struct fault_env and vm_fault")

v4.4.235: Failed to apply! Possible dependencies:
    11bac8000449 ("mm, fs: reduce fault, page_mkwrite, and pfn_mkwrite to take only vmf")
    366baf28ee3f ("KVM: PPC: Use RCU for arch.spapr_tce_tables")
    462ee11e58c9 ("KVM: PPC: Replace SPAPR_TCE_SHIFT with IOMMU_PAGE_SHIFT_4K")
    5ee7af18642c ("KVM: PPC: Move reusable bits of H_PUT_TCE handler to helpers")
    d3695aa4f452 ("KVM: PPC: Add support for multiple-TCE hcalls")
    f8626985c7c2 ("KVM: PPC: Account TCE-containing pages in locked_vm")
    fcbb2ce67284 ("KVM: PPC: Rework H_PUT_TCE/H_GET_TCE handlers")
    fe26e52712cc ("KVM: PPC: Add @page_shift to kvmppc_spapr_tce_table")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
