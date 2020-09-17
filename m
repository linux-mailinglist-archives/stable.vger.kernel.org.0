Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE7726E49C
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 20:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgIQSxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 14:53:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728452AbgIQQUv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 12:20:51 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09651208E4;
        Thu, 17 Sep 2020 15:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600358014;
        bh=FhSa5eNN1HgKXqUR3nvhanUj1UeTgTG16CwhxtL+QL4=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=iq8x8OjIiL+Bw7Sgwf/ev1NDoWolTr46v7aAE7lqBa0MUupNht1qL+arHw29eFGxu
         2XXkS6oCflV7RFVo4sbsVSQQcJsnQnWx5XgqP89Dye7OXwgWoBusP8EN/VhSdxIOl+
         ClbSVWS95sAZ4Zx0J1+awOZSYIRa3ms6Nr7tWs2k=
Date:   Thu, 17 Sep 2020 15:53:33 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Vasily Gorbik <gor@linux.ibm.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/gup: fix gup_fast with dynamic page table folding
In-Reply-To: <patch.git-943f1e5dcff2.your-ad-here.call-01599856292-ext-8676@work.hours>
References: <patch.git-943f1e5dcff2.your-ad-here.call-01599856292-ext-8676@work.hours>
Message-Id: <20200917155334.09651208E4@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 1a42010cdc26 ("s390/mm: convert to the generic get_user_pages_fast code").

The bot has tested the following trees: v5.8.9, v5.4.65.

v5.8.9: Build OK!
v5.4.65: Failed to apply! Possible dependencies:
    051a7a94aaa9 ("arm64: hibernate: use get_safe_page directly")
    13373f0e6580 ("arm64: hibernate: rename dst to page in create_safe_exec_page")
    48c963e31bc6 ("KVM: arm/arm64: Release kvm->mmu_lock in loop to prevent starvation")
    68ecabd0e680 ("arm64/mm: Use phys_to_page() to access pgtable memory")
    8a0af66b35f8 ("arm: mm: add p?d_leaf() definitions")
    974b9b2c68f3 ("mm: consolidate pte_index() and pte_offset_*() definitions")
    a2c2e67923ec ("arm64: hibernate: add trans_pgd public functions")
    a89d7ff933b0 ("arm64: hibernate: remove gotos as they are not needed")
    d234332c2815 ("arm64: hibernate: pass the allocated pgdp to ttbr0")
    e9f6376858b9 ("arm64: add support for folded p4d page tables")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
