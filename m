Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35ED91C7E10
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 01:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgEFXmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 19:42:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728216AbgEFXmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 19:42:14 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2887220735;
        Wed,  6 May 2020 23:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588808534;
        bh=oTiGYE58Jca6Xx3gU8+PRrpZQe7ddnxuxF7H2ZBOZHY=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=yF7TFSd/I7mUzdXd+egLX7pWB/iTLy7UNEgkSIfdWJOX1hx9jHC5W8QCgygMgXSe3
         msEqUSIwaEHOuP1M7mf7+cA59i7sSxpQK5T5LHIzTt/XBJDGhW9sFa6/3N6AMlGHdC
         GFOWnNNDcFp5AW0HIwZecpB09CYRFZjjOdEzgHRY=
Date:   Wed, 06 May 2020 23:42:13 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Huacai Chen <chenhc@lemote.com>
To:     Xing Li <lixing@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH V3 01/14] KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
In-Reply-To: <1588500367-1056-2-git-send-email-chenhc@lemote.com>
References: <1588500367-1056-2-git-send-email-chenhc@lemote.com>
Message-Id: <20200506234214.2887220735@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.10, v5.4.38, v4.19.120, v4.14.178, v4.9.221, v4.4.221.

v5.6.10: Build OK!
v5.4.38: Build OK!
v4.19.120: Build OK!
v4.14.178: Build OK!
v4.9.221: Build OK!
v4.4.221: Failed to apply! Possible dependencies:
    029499b47738 ("KVM: x86: MMU: Make mmu_set_spte() return emulate value")
    19d194c62b25 ("MIPS: KVM: Simplify TLB_* macros")
    403015b323a2 ("MIPS: KVM: Move non-TLB handling code out of tlb.c")
    7ee0e5b29d27 ("KVM: x86: MMU: Remove unused parameter of __direct_map()")
    9fbfb06a4065 ("MIPS: KVM: Arrayify struct kvm_mips_tlb::tlb_lo*")
    ba049e93aef7 ("kvm: rename pfn_t to kvm_pfn_t")
    bdb7ed8608f8 ("MIPS: KVM: Convert headers to kernel sized types")
    ca64c2beecd4 ("MIPS: KVM: Abstract guest ASID mask")
    caa1faa7aba6 ("MIPS: KVM: Trivial whitespace and style fixes")
    e6207bbea16c ("MIPS: KVM: Use MIPS_ENTRYLO_* defs from mipsregs.h")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
