Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193DB23D512
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 03:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgHFBY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 21:24:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbgHFBYM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 21:24:12 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 801B022D03;
        Thu,  6 Aug 2020 01:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596677051;
        bh=J2m/4Kmff4FTlUt20OWwTJX4FeqSWst0MbPSRsxU6Ns=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=THMmMf+UpuXGKS9WQIKcXiq74D1omKRL7PK3tmZSpDwDsVm4fED9IDwsVZ6Q39xYy
         shw44Jajr9BPur2sAo5znXRC4WeMnY8/mTKrtLUdPerC16Bw5082mFTBV/GHNo04jP
         izavT5veDpJ3HN97T7RC1vnjV2ek05vuO8ji5qs4=
Date:   Thu, 06 Aug 2020 01:24:10 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     stable@vger.kernel.org
Cc:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     stable@vger.kernel.org
Subject: Re: [RFC PATCH] KVM: SVM: Disallow SEV if NPT is disabled
In-Reply-To: <20200731205116.14891-1-sean.j.christopherson@intel.com>
References: <20200731205116.14891-1-sean.j.christopherson@intel.com>
Message-Id: <20200806012411.801B022D03@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: e9df09428996 ("KVM: SVM: Add sev module_param").

The bot has tested the following trees: v5.7.11, v5.4.54, v4.19.135.

v5.7.11: Failed to apply! Possible dependencies:
    3bae0459bcd5 ("KVM: x86/mmu: Drop KVM's hugepage enums in favor of the kernel's enums")
    b2f432f872d9 ("KVM: x86/mmu: Tweak PSE hugepage handling to avoid 2M vs 4M conundrum")
    e662ec3e0705 ("KVM: x86/mmu: Move max hugepage level to a separate #define")

v5.4.54: Failed to apply! Possible dependencies:
    106ee47dc633 ("docs: kvm: Convert api.txt to ReST format")
    213e0e1f500b ("KVM: SVM: Refactor logging of NPT enabled/disabled")
    3bae0459bcd5 ("KVM: x86/mmu: Drop KVM's hugepage enums in favor of the kernel's enums")
    3c9bd4006bfc ("KVM: x86: enable dirty log gradually in small chunks")
    80b10aa92448 ("Documentation: kvm: Fix mention to number of ioctls classes")
    c726200dd106 ("KVM: arm/arm64: Allow reporting non-ISV data aborts to userspace")
    cb9b88c66939 ("KVM: x86/mmu: Refactor handling of cache consistency with TDP")
    da345174ceca ("KVM: arm/arm64: Allow user injection of external data aborts")
    e662ec3e0705 ("KVM: x86/mmu: Move max hugepage level to a separate #define")

v4.19.135: Failed to apply! Possible dependencies:
    213e0e1f500b ("KVM: SVM: Refactor logging of NPT enabled/disabled")
    3bae0459bcd5 ("KVM: x86/mmu: Drop KVM's hugepage enums in favor of the kernel's enums")
    44dd3ffa7bb3 ("x86/kvm/mmu: make vcpu->mmu a pointer to the current MMU")
    4fef0f491347 ("KVM: x86: move definition PT_MAX_HUGEPAGE_LEVEL and KVM_NR_PAGE_SIZES together")
    91e86d225ef3 ("kvm: x86: Add payload operands to kvm_multiple_exception")
    c851436a34ca ("kvm: x86: Add has_payload and payload to kvm_queued_exception")
    cb9b88c66939 ("KVM: x86/mmu: Refactor handling of cache consistency with TDP")
    d647eb63e671 ("KVM: svm: add nrips module parameter")
    da998b46d244 ("kvm: x86: Defer setting of CR2 until #PF delivery")
    e662ec3e0705 ("KVM: x86/mmu: Move max hugepage level to a separate #define")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
