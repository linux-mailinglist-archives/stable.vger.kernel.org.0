Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445301D95A0
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 13:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbgESLtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 07:49:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728626AbgESLtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 07:49:13 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EFF2207D8;
        Tue, 19 May 2020 11:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589888952;
        bh=yEh+r5LMBWDn147exCmKd4fPSIN/zEvg174HOnJ3QjM=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=xfvy4adUER5m5Q25/kf6S5KzjTTu4AnhaumnXyRmN7a5xfeNecbS893X8Yc6T0wjv
         ncvp/TuYPDpxg0X2BFmmk3go1CiBMJOo5zzak9vZJPt63/OtczxzePQIAC1Okh+3pM
         7TgrXhkwTndI8m4QVjzQVWVpo+yoBdSKefE5X09k=
Date:   Tue, 19 May 2020 11:49:11 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Huacai Chen <chenhc@lemote.com>
To:     Xing Li <lixing@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH V5 01/15] KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
In-Reply-To: <1589359366-1669-2-git-send-email-chenhc@lemote.com>
References: <1589359366-1669-2-git-send-email-chenhc@lemote.com>
Message-Id: <20200519114912.7EFF2207D8@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.13, v5.4.41, v4.19.123, v4.14.180, v4.9.223, v4.4.223.

v5.6.13: Build OK!
v5.4.41: Build OK!
v4.19.123: Build OK!
v4.14.180: Build OK!
v4.9.223: Build OK!
v4.4.223: Failed to apply! Possible dependencies:
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
