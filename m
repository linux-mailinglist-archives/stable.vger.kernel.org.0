Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE59B1E1875
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 02:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387707AbgEZAX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 20:23:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729294AbgEZAX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 May 2020 20:23:58 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC4EA206F1;
        Tue, 26 May 2020 00:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590452637;
        bh=y6jhZuXiG3nQD7O2G1f2dYNMdqnaxtJw+Jh1dlXL3VU=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=TOHJEwYzLQwrmWHSKJDQX/loO7u3Gs0pUF5xLsis8/VSdGQsgpbDJNqypsrSSDGga
         PTQHYGxr9Me6CtYMc1DDbSwUkQSBTRzp1TqIRKaMwX8AjORzyXbtoxWneM78HamdP0
         DuysQcdjqpy/aitmP+9zTdFOAeEFg0lPwdmfU/iw=
Date:   Tue, 26 May 2020 00:23:56 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 01/24] KVM: nSVM: fix condition for filtering async PF
In-Reply-To: <20200520172145.23284-2-pbonzini@redhat.com>
References: <20200520172145.23284-2-pbonzini@redhat.com>
Message-Id: <20200526002356.CC4EA206F1@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.14, v5.4.42, v4.19.124, v4.14.181, v4.9.224, v4.4.224.

v5.6.14: Failed to apply! Possible dependencies:
    320debe5ef6d ("x86/kvm: Convert to new CPU match macros")
    46a010dd6896 ("kVM SVM: Move SVM related files to own sub-directory")
    64b5bd270426 ("KVM: nSVM: ignore L1 interrupt window while running L2 with V_INTR_MASKING=1")
    883b0a91f41a ("KVM: SVM: Move Nested SVM Implementation to nested.c")
    b5ec2e020b70 ("KVM: nSVM: do not change host intercepts while nested VM is running")
    ba5bade4cc0d ("x86/devicetable: Move x86 specific macro out of generic code")

v5.4.42: Failed to apply! Possible dependencies:
    320debe5ef6d ("x86/kvm: Convert to new CPU match macros")
    33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations")
    46a010dd6896 ("kVM SVM: Move SVM related files to own sub-directory")
    4be946728f65 ("KVM: x86/vPMU: Declare kvm_pmu->reprogram_pmi field using DECLARE_BITMAP")
    4e19c36f2df8 ("kvm: x86: Introduce APICv inhibit reason bits")
    575b255c1663 ("KVM: x86: allow compiling as non-module with W=1")
    83af5e65a895 ("KVM: SVM: Guard against DEACTIVATE when performing WBINVD/DF_FLUSH")
    883b0a91f41a ("KVM: SVM: Move Nested SVM Implementation to nested.c")
    98ff80f5b788 ("KVM: x86/vPMU: Rename pmu_ops callbacks from msr_idx to rdpmc_ecx")
    9a0bf0543069 ("svm: Deactivate AVIC when launching guest with nested SVM support")
    a6da0d77e98e ("KVM: x86/vPMU: Reuse perf_event to avoid unnecessary pmc_reprogram_counter")
    b35e5548b411 ("KVM: x86/vPMU: Add lazy mechanism to release perf_event per vPMC")
    ba5bade4cc0d ("x86/devicetable: Move x86 specific macro out of generic code")
    c900c156c518 ("KVM: x86/vPMU: Introduce a new kvm_pmu_ops->msr_idx_to_pmc callback")
    e3b9a9e147db ("KVM: SVM: Serialize access to the SEV ASID bitmap")
    f3515dc3bef8 ("svm: Temporarily deactivate AVIC during ExtINT handling")
    f4fdc0a2edf4 ("kvm: x86: hyperv: Use APICv update request interface")

v4.19.124: Failed to apply! Possible dependencies:
    09abb5e3e5e5 ("KVM: nVMX: call kvm_skip_emulated_instruction in nested_vmx_{fail,succeed}")
    09abe3200266 ("KVM: nVMX: split pieces of prepare_vmcs02() to prepare_vmcs02_early()")
    1438921c6dc1 ("KVM: nVMX: Flush TLB entries tagged by dest EPTP on L1<->L2 transitions")
    199b118ab3d5 ("KVM: VMX: Alphabetize the includes in vmx.c")
    1abf23fb42f5 ("KVM: nVMX: use vm_exit_controls_init() to write exit controls for vmcs02")
    327c072187f7 ("KVM: nVMX: Flush linear and combined mappings on VPID02 related flushes")
    3d5bdae8b164 ("KVM: nVMX: Use correct VPID02 when emulating L1 INVVPID")
    3df5c37e55c8 ("KVM: nVMX: try to set EFER bits correctly when initializing controls")
    453eafbe65f7 ("KVM: VMX: Move VM-Enter + VM-Exit handling to non-inline sub-routines")
    55d2375e58a6 ("KVM: nVMX: Move nested code to dedicated files")
    5b8ba41dafd7 ("KVM: nVMX: move vmcs12 EPTP consistency check to check_vmentry_prereqs()")
    609363cf81fc ("KVM: nVMX: Move vmcs12 code to dedicated files")
    75edce8a4548 ("KVM: VMX: Move eVMCS code to dedicated files")
    883b0a91f41a ("KVM: SVM: Move Nested SVM Implementation to nested.c")
    945679e301ea ("KVM: nVMX: add enlightened VMCS state")
    a633e41e7362 ("KVM: nVMX: assimilate nested_vmx_entry_failure() into nested_vmx_enter_non_root_mode()")
    a821bab2d1ee ("KVM: VMX: Move VMX specific files to a "vmx" subdirectory")
    b8bbab928fb1 ("KVM: nVMX: implement enlightened VMPTRLD and VMCLEAR")
    d63907dc7dd1 ("KVM: nVMX: rename enter_vmx_non_root_mode to nested_vmx_enter_non_root_mode")
    efebf0aaec3d ("KVM: nVMX: Do not flush TLB on L1<->L2 transitions if L1 uses VPID and EPT")

v4.14.181: Failed to apply! Possible dependencies:
    0234bf885236 ("KVM: x86: introduce ISA specific SMM entry/exit callbacks")
    199b118ab3d5 ("KVM: VMX: Alphabetize the includes in vmx.c")
    44900ba65e16 ("KVM: VMX: optimize shadow VMCS copying")
    453eafbe65f7 ("KVM: VMX: Move VM-Enter + VM-Exit handling to non-inline sub-routines")
    55d2375e58a6 ("KVM: nVMX: Move nested code to dedicated files")
    5b15706dbf5b ("kvm: vmx: Introduce VMCS12_MAX_FIELD_INDEX")
    609363cf81fc ("KVM: nVMX: Move vmcs12 code to dedicated files")
    6677f3dad874 ("KVM: nVMX: introduce struct nested_vmx_msrs")
    72d7b374b14d ("KVM: x86: introduce ISA specific smi_allowed callback")
    72e9cbdb4338 ("KVM: nVMX: fix SMI injection in guest mode")
    736fdf72518b ("KVM: VMX: rename RDSEED and RDRAND vmx ctrls to reflect exiting")
    74a497fae754 ("KVM: nVMX: track dirty state of non-shadowed VMCS fields")
    75edce8a4548 ("KVM: VMX: Move eVMCS code to dedicated files")
    883b0a91f41a ("KVM: SVM: Move Nested SVM Implementation to nested.c")
    945679e301ea ("KVM: nVMX: add enlightened VMCS state")
    a821bab2d1ee ("KVM: VMX: Move VMX specific files to a "vmx" subdirectory")
    b8bbab928fb1 ("KVM: nVMX: implement enlightened VMPTRLD and VMCLEAR")
    c5d167b27e00 ("KVM: vmx: shadow more fields that are read/written on every vmexits")
    c9e9deae76b8 ("KVM: VMX: split list of shadowed VMCS field to a separate file")
    f4160e459c57 ("kvm: nVMX: Add support for "VMWRITE to any supported field"")

v4.9.224: Failed to apply! Possible dependencies:
    1279a6b124e4 ("KVM: nVMX: single function for switching between vmcs")
    199b118ab3d5 ("KVM: VMX: Alphabetize the includes in vmx.c")
    27c42a1bb867 ("KVM: nVMX: Enable VMFUNC for the L1 hypervisor")
    2a499e49c2ec ("KVM: vmx: Enable VMFUNCs")
    3899152ccbf4 ("KVM: nVMX: fix checks on CR{0,4} during virtual VMX operation")
    44900ba65e16 ("KVM: VMX: optimize shadow VMCS copying")
    453eafbe65f7 ("KVM: VMX: Move VM-Enter + VM-Exit handling to non-inline sub-routines")
    4f350c6dbcb9 ("kvm: nVMX: Handle deferred early VMLAUNCH/VMRESUME failure properly")
    55d2375e58a6 ("KVM: nVMX: Move nested code to dedicated files")
    5a6a9748b4b4 ("KVM: nVMX: load GUEST_EFER after GUEST_CR0 during emulated VM-entry")
    609363cf81fc ("KVM: nVMX: Move vmcs12 code to dedicated files")
    62cc6b9dc61e ("KVM: nVMX: support restore of VMX capability MSRs")
    72e9cbdb4338 ("KVM: nVMX: fix SMI injection in guest mode")
    74a497fae754 ("KVM: nVMX: track dirty state of non-shadowed VMCS fields")
    75edce8a4548 ("KVM: VMX: Move eVMCS code to dedicated files")
    7ca29de21362 ("KVM: nVMX: fix CR3 load if L2 uses PAE paging and EPT")
    858e25c06fb0 ("kvm: nVMX: Refactor nested_vmx_run()")
    85fd514e2423 ("kvm: nVMX: Shadow "high" parts of shadowed 64-bit VMCS fields")
    883b0a91f41a ("KVM: SVM: Move Nested SVM Implementation to nested.c")
    945679e301ea ("KVM: nVMX: add enlightened VMCS state")
    9ed38ffad473 ("KVM: nVMX: introduce nested_vmx_load_cr3 and call it on vmentry")
    a821bab2d1ee ("KVM: VMX: Move VMX specific files to a "vmx" subdirectory")
    a8bc284eb70f ("kvm: nVMX: Refactor handle_vmptrld()")
    b8bbab928fb1 ("KVM: nVMX: implement enlightened VMPTRLD and VMCLEAR")
    c5d167b27e00 ("KVM: vmx: shadow more fields that are read/written on every vmexits")
    c7c2c709b60e ("kvm: nVMX: Validate CR3 target count on nested VM-entry")
    c9e9deae76b8 ("KVM: VMX: split list of shadowed VMCS field to a separate file")
    ca0bde28f2ed ("kvm: nVMX: Split VMCS checks from nested_vmx_run()")
    cf3215d9394a ("kvm: nVMX: Fetch VM_INSTRUCTION_ERROR from vmcs02 on vmx->fail")
    ee146c1c100d ("KVM: nVMX: propagate errors from prepare_vmcs02")

v4.4.224: Failed to apply! Possible dependencies:
    199b118ab3d5 ("KVM: VMX: Alphabetize the includes in vmx.c")
    355f4fb1405e ("kvm: nVMX: VMCLEAR an active shadow VMCS after last use")
    453eafbe65f7 ("KVM: VMX: Move VM-Enter + VM-Exit handling to non-inline sub-routines")
    4f2777bc9797 ("kvm: x86: nVMX: maintain internal copy of current VMCS")
    55d2375e58a6 ("KVM: nVMX: Move nested code to dedicated files")
    609363cf81fc ("KVM: nVMX: Move vmcs12 code to dedicated files")
    6308630bd3db ("kvm/x86: split ioapic-handled and EOI exit bitmaps")
    74a497fae754 ("KVM: nVMX: track dirty state of non-shadowed VMCS fields")
    75edce8a4548 ("KVM: VMX: Move eVMCS code to dedicated files")
    883b0a91f41a ("KVM: SVM: Move Nested SVM Implementation to nested.c")
    945679e301ea ("KVM: nVMX: add enlightened VMCS state")
    a821bab2d1ee ("KVM: VMX: Move VMX specific files to a "vmx" subdirectory")
    a8bc284eb70f ("kvm: nVMX: Refactor handle_vmptrld()")
    b8bbab928fb1 ("KVM: nVMX: implement enlightened VMPTRLD and VMCLEAR")
    bb3541f175a9 ("KVM: x86: Fix typos")
    d62caabb41f3 ("kvm/x86: per-vcpu apicv deactivation support")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
