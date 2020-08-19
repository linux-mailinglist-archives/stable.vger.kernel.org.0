Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695C124AA47
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 01:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgHSX5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 19:57:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbgHSX4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 19:56:51 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37F3D208E4;
        Wed, 19 Aug 2020 23:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881410;
        bh=XnmGOm5eCm12LNtj3d4vvWZQL6O//vIVNYM4YdsYL7k=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=jrbsnAB8MEXjd/u6e4H5UE/yy4mMplycrdi4Hb0YZ9BjeamDMRYFt2Nkl/r+lW+IM
         da3WZx/cBUkpJgRBf/3AP97sJzPZ7F7xhz0VMDBrcHNW64mNsnPAZ++s1o0A6CWM/y
         lM/V6vllAxoKQ91xnsjlDaw3OFsXZgTaVbkFI6Cw=
Date:   Wed, 19 Aug 2020 23:56:49 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     stable@vger.kernel.org
Cc:     Liran Alon <liran.alon@oracle.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Morph notification vector IRQ on nested VM-Enter to pending PI
In-Reply-To: <20200812175129.12172-1-sean.j.christopherson@intel.com>
References: <20200812175129.12172-1-sean.j.christopherson@intel.com>
Message-Id: <20200819235650.37F3D208E4@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 705699a13994 ("KVM: nVMX: Enable nested posted interrupt processing").

The bot has tested the following trees: v5.8.1, v5.7.15, v5.4.58, v4.19.139, v4.14.193, v4.9.232, v4.4.232.

v5.8.1: Build OK!
v5.7.15: Build OK!
v5.4.58: Failed to apply! Possible dependencies:
    59508b303e4e ("KVM: X86: Move irrelevant declarations out of ioapic.h")
    5c69d5c113f1 ("KVM: X86: Fix callers of kvm_apic_match_dest() to use correct macros")

v4.19.139: Failed to apply! Possible dependencies:
    0b0a31badb2d ("KVM: x86: hyperv: valid_bank_mask should be 'u64'")
    214ff83d4473 ("KVM: x86: hyperv: implement PV IPI send hypercalls")
    2cefc5feb80c ("KVM: x86: hyperv: optimize kvm_hv_flush_tlb() for vp_index == vcpu_idx case")
    360cae313702 ("KVM: PPC: Book3S HV: Nested guest entry via hypercall")
    59508b303e4e ("KVM: X86: Move irrelevant declarations out of ioapic.h")
    5c69d5c113f1 ("KVM: X86: Fix callers of kvm_apic_match_dest() to use correct macros")
    89329c0be8bd ("KVM: PPC: Book3S HV: Clear partition table entry on vm teardown")
    8e3f5fc1045d ("KVM: PPC: Book3S HV: Framework and hcall stubs for nested virtualization")
    a812297c4fd9 ("KVM: x86: hyperv: optimize 'all cpus' case in kvm_hv_flush_tlb()")
    aa069a996951 ("KVM: PPC: Book3S HV: Add a VM capability to enable nested virtualization")
    e6b6c483ebe9 ("KVM: x86: hyperv: fix 'tlb_lush' typo")
    f21dd494506a ("KVM: x86: hyperv: optimize sparse VP set processing")

v4.14.193: Failed to apply! Possible dependencies:
    0234bf885236 ("KVM: x86: introduce ISA specific SMM entry/exit callbacks")
    05cade71cf3b ("KVM: nSVM: fix SMI injection in guest mode")
    44883f01fe6a ("KVM: x86: ensure all MSRs can always be KVM_GET/SET_MSR'd")
    59508b303e4e ("KVM: X86: Move irrelevant declarations out of ioapic.h")
    5acc5c063196 ("KVM: Introduce KVM_MEMORY_ENCRYPT_OP ioctl")
    5c69d5c113f1 ("KVM: X86: Fix callers of kvm_apic_match_dest() to use correct macros")
    69eaedee411c ("KVM: Introduce KVM_MEMORY_ENCRYPT_{UN,}REG_REGION ioctl")
    72d7b374b14d ("KVM: x86: introduce ISA specific smi_allowed callback")
    a2e164e7f45a ("x86/kvm/hyper-v: add reenlightenment MSRs support")
    cc3d967f7e32 ("KVM: SVM: detect opening of SMI window using STGI intercept")
    f21dd494506a ("KVM: x86: hyperv: optimize sparse VP set processing")
    faeb7833eee0 ("kvm: x86: hyperv: guest->host event signaling via eventfd")

v4.9.232: Failed to apply! Possible dependencies:
    004172bdad64 ("sched/core: Remove unnecessary #include headers")
    174cd4b1e5fb ("sched/headers: Prepare to move signal wakeup & sigpending methods from <linux/sched.h> into <linux/sched/signal.h>")
    3aa53859d23e ("KVM: Documentation: document MCE ioctls")
    3ca0ff571b09 ("locking/mutex: Rework mutex::owner")
    4036e3874a1c ("KVM: s390: ioctls to get and set guest storage attributes")
    44883f01fe6a ("KVM: x86: ensure all MSRs can always be KVM_GET/SET_MSR'd")
    59508b303e4e ("KVM: X86: Move irrelevant declarations out of ioapic.h")
    5acc5c063196 ("KVM: Introduce KVM_MEMORY_ENCRYPT_OP ioctl")
    5c69d5c113f1 ("KVM: X86: Fix callers of kvm_apic_match_dest() to use correct macros")
    69eaedee411c ("KVM: Introduce KVM_MEMORY_ENCRYPT_{UN,}REG_REGION ioctl")
    a2e164e7f45a ("x86/kvm/hyper-v: add reenlightenment MSRs support")
    ae7e81c077d6 ("sched/headers: Prepare for new header dependencies before moving code to <uapi/linux/sched/types.h>")
    b3c045d33218 ("KVM: lapic: remove unnecessary KVM_REQ_EVENT on PPR update")
    c92701322711 ("KVM: PPC: Book3S HV: Add userspace interfaces for POWER9 MMU")
    ea8b1c4a6019 ("drivers: psci: PSCI checker module")
    eb90f3417a0c ("KVM: vmx: speed up TPR below threshold vmexits")
    ef1ead0c3b1d ("KVM: PPC: Book3S HV: HPT resizing documentation and reserved numbers")
    f21dd494506a ("KVM: x86: hyperv: optimize sparse VP set processing")
    faeb7833eee0 ("kvm: x86: hyperv: guest->host event signaling via eventfd")

v4.4.232: Failed to apply! Possible dependencies:
    1e6e2755b635 ("KVM: x86: Misc LAPIC changes to expose helper functions")
    520040146a0a ("KVM: x86: Use vector-hashing to deliver lowest-priority interrupts")
    5c919412fe61 ("kvm/x86: Hyper-V synthetic interrupt controller")
    6308630bd3db ("kvm/x86: split ioapic-handled and EOI exit bitmaps")
    b3c045d33218 ("KVM: lapic: remove unnecessary KVM_REQ_EVENT on PPR update")
    d62caabb41f3 ("kvm/x86: per-vcpu apicv deactivation support")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
