Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C54264AEB
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 19:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgIJRQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 13:16:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgIJQeU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Sep 2020 12:34:20 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0D1421D81;
        Thu, 10 Sep 2020 16:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599755660;
        bh=uBnRwLuv38RqJ8K3uYlMUsMCJOCQCkwNTv/0ekTsosM=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=KbPsp8hC/XzdIKmngvcR2OBTU3qh4V99zAKMJnopFaGSBvQBGmwlH5XmIfC7JHnrX
         ARlIIPIi1SD6hjk27CrCVt7VQoolK4yj3s095efJlJlS57VH32eYrd2NJqe08nGtEV
         U934xPKfNZrDrnkauSI9aewrVs9sjlL6HCOjtoAM=
Date:   Thu, 10 Sep 2020 16:34:19 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] KVM: MIPS: Change the definition of kvm type
In-Reply-To: <1599734031-28746-1-git-send-email-chenhc@lemote.com>
References: <1599734031-28746-1-git-send-email-chenhc@lemote.com>
Message-Id: <20200910163419.E0D1421D81@mail.kernel.org>
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
v4.14.196: Build OK!
v4.9.235: Failed to apply! Possible dependencies:
    06c158c96ed8 ("KVM: MIPS/MMU: Convert guest physical map to page table")
    1534b3964901 ("KVM: MIPS/MMU: Simplify ASID restoration")
    1581ff3dbf69 ("KVM: MIPS/MMU: Move preempt/ASID handling to implementation")
    91cdee5710d5 ("KVM: MIPS/T&E: Restore host asid on return to host")
    a2c046e40ff1 ("KVM: MIPS: Add vcpu_run() & vcpu_reenter() callbacks")
    a31b50d741bd ("KVM: MIPS/MMU: Invalidate GVA PTs on ASID changes")
    a60b8438bdba ("KVM: MIPS: Convert get/set_regs -> vcpu_load/put")
    a7ebb2e410f8 ("KVM: MIPS/T&E: active_mm = init_mm in guest context")
    a8a3c426772e ("KVM: MIPS: Add VZ & TE capabilities")
    c550d53934d8 ("KVM: MIPS: Remove duplicated ASIDs from vcpu")
    c92701322711 ("KVM: PPC: Book3S HV: Add userspace interfaces for POWER9 MMU")

v4.4.235: Failed to apply! Possible dependencies:
    107d44a2c5bf ("KVM: document KVM_REINJECT_CONTROL ioctl")
    366baf28ee3f ("KVM: PPC: Use RCU for arch.spapr_tce_tables")
    462ee11e58c9 ("KVM: PPC: Replace SPAPR_TCE_SHIFT with IOMMU_PAGE_SHIFT_4K")
    58ded4201ff0 ("KVM: PPC: Add support for 64bit TCE windows")
    5ee7af18642c ("KVM: PPC: Move reusable bits of H_PUT_TCE handler to helpers")
    a8a3c426772e ("KVM: MIPS: Add VZ & TE capabilities")
    c92701322711 ("KVM: PPC: Book3S HV: Add userspace interfaces for POWER9 MMU")
    d3695aa4f452 ("KVM: PPC: Add support for multiple-TCE hcalls")
    f8626985c7c2 ("KVM: PPC: Account TCE-containing pages in locked_vm")
    fcbb2ce67284 ("KVM: PPC: Rework H_PUT_TCE/H_GET_TCE handlers")
    fe26e52712cc ("KVM: PPC: Add @page_shift to kvmppc_spapr_tce_table")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
