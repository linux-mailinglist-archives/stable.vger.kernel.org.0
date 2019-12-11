Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B348E11B8F4
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730177AbfLKQgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:36:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:53908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729260AbfLKQgn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 11:36:43 -0500
Received: from localhost (unknown [40.117.208.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91567206A5;
        Wed, 11 Dec 2019 16:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576082201;
        bh=yb6fhQ8MZR+X/3cVB0+ufP2Yk2jR747xOpy7WOBO6rU=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=tpczmveGVICETHKuVwzWZZcljSQ2PvqYJVAixI9c+rxW/JyiTmgmSWZOivMgoH6Hi
         9OT1caIa3cC+lrj5/7cO84X/O7rbTV4c0v/iPB7cmFIvLc+r77LyEfWComGyu/LPz0
         /x4FwSAVQYMzcfXPyyAaxGGrZrx+6PuHKBU3qPWQ=
Date:   Wed, 11 Dec 2019 16:36:40 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: use CPUID to locate host page table reserved bits
In-Reply-To: <1575471060-55790-1-git-send-email-pbonzini@redhat.com>
References: <1575471060-55790-1-git-send-email-pbonzini@redhat.com>
Message-Id: <20191211163641.91567206A5@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.4.2, v5.3.15, v4.19.88, v4.14.158, v4.9.206, v4.4.206.

v5.4.2: Build OK!
v5.3.15: Failed to apply! Possible dependencies:
    Unable to calculate

v4.19.88: Failed to apply! Possible dependencies:
    7b6f8a06e482 ("kvm: x86: Move kvm_set_mmio_spte_mask() from x86.c to mmu.c")
    f3ecb59dd49f ("kvm: x86: Fix reserved bits related calculation errors caused by MKTME")

v4.14.158: Failed to apply! Possible dependencies:
    7b6f8a06e482 ("kvm: x86: Move kvm_set_mmio_spte_mask() from x86.c to mmu.c")
    f3ecb59dd49f ("kvm: x86: Fix reserved bits related calculation errors caused by MKTME")

v4.9.206: Failed to apply! Possible dependencies:
    114df303a7ee ("kvm: x86: reduce collisions in mmu_page_hash")
    28a1f3ac1d0c ("kvm: x86: Set highest physical address bits in non-present/reserved SPTEs")
    312b616b30d8 ("kvm: x86: mmu: Set SPTE_SPECIAL_MASK within mmu.c")
    37f0e8fe6b10 ("kvm: x86: mmu: Do not use bit 63 for tracking special SPTEs")
    66d73e12f278 ("KVM: X86: MMU: no mmu_notifier_seq++ in kvm_age_hva")
    83ef6c8155c0 ("kvm: x86: mmu: Refactor accessed/dirty checks in mmu_spte_update/clear")
    97dceba29a6a ("kvm: x86: mmu: Fast Page Fault path retries")
    daa07cbc9ae3 ("KVM: x86: fix L1TF's MMIO GFN calculation")
    dcdca5fed5f6 ("x86: kvm: mmu: make spte mmio mask more explicit")
    ea4114bcd3a8 ("kvm: x86: mmu: Rename spte_is_locklessly_modifiable()")
    f160c7b7bb32 ("kvm: x86: mmu: Lockless access tracking for Intel CPUs without EPT A bits.")
    f3ecb59dd49f ("kvm: x86: Fix reserved bits related calculation errors caused by MKTME")

v4.4.206: Failed to apply! Possible dependencies:
    018aabb56d61 ("KVM: x86: MMU: Encapsulate the type of rmap-chain head in a new struct")
    0e3d0648bd90 ("KVM: x86: MMU: always set accessed bit in shadow PTEs")
    114df303a7ee ("kvm: x86: reduce collisions in mmu_page_hash")
    14f4760562e4 ("kvm: set page dirty only if page has been writable")
    28a1f3ac1d0c ("kvm: x86: Set highest physical address bits in non-present/reserved SPTEs")
    37f0e8fe6b10 ("kvm: x86: mmu: Do not use bit 63 for tracking special SPTEs")
    83ef6c8155c0 ("kvm: x86: mmu: Refactor accessed/dirty checks in mmu_spte_update/clear")
    8d5cf1610da5 ("kvm: mmu: extend the is_present check to 32 bits")
    daa07cbc9ae3 ("KVM: x86: fix L1TF's MMIO GFN calculation")
    ea4114bcd3a8 ("kvm: x86: mmu: Rename spte_is_locklessly_modifiable()")
    f160c7b7bb32 ("kvm: x86: mmu: Lockless access tracking for Intel CPUs without EPT A bits.")
    f3ecb59dd49f ("kvm: x86: Fix reserved bits related calculation errors caused by MKTME")
    ffb128c89b77 ("kvm: mmu: don't set the present bit unconditionally")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks,
Sasha
