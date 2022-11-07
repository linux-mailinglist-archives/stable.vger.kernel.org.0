Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECFF61FA5B
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 17:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiKGQsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 11:48:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiKGQsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 11:48:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF4F62C7
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 08:48:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEA2FB815D5
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 16:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CFFC433B5;
        Mon,  7 Nov 2022 16:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667839707;
        bh=Da0sHFf7R+ek/NV1K3ny7d5lyVK/V4ENsbJx+P6B8AY=;
        h=Subject:To:Cc:From:Date:From;
        b=B2C2/lKKQFuElhwDDHBPBRmfEQQwiWL7BA6SEUBtyswo1/AjcYNkJDqqUMIzLQs8K
         rNLs2iKERAnEDRIwbo2yZUh0HIrQu/bpFmbIe7SnUeBvg7YllrMxxOGVTql38YjDxD
         c9T6kfwEFKQdpmWYwHMH2XgS5P2YeIcQ0RKHCRd4=
Subject: FAILED: patch "[PATCH] KVM: x86: Mask off reserved bits in CPUID.8000001FH" failed to apply to 5.4-stable tree
To:     jmattson@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Nov 2022 17:48:23 +0100
Message-ID: <166783970395162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

86c4f0d547f6 ("KVM: x86: Mask off reserved bits in CPUID.8000001FH")
e39f00f60ebd ("KVM: x86: Use kernel's x86_phys_bits to handle reduced MAXPHYADDR")
4bf48e3c0aaf ("KVM: x86: Use guest MAXPHYADDR from CPUID.0x8000_0008 iff TDP is enabled")
d9db0fd6c5c9 ("KVM: SEV: Mask CPUID[0x8000001F].eax according to supported features")
013380782d4d ("KVM: x86: Move reverse CPUID helpers to separate header file")
01de8682b32d ("KVM: x86: Add reverse-CPUID lookup support for scattered SGX features")
4e66c0cb79b7 ("KVM: x86: Add support for reverse CPUID lookup of scattered features")
e42033342293 ("KVM: x86: Advertise INVPCID by default")
916391a2d1dc ("KVM: SVM: Add support for SEV-ES capability in KVM")
9d4747d02376 ("KVM: SVM: Remove the call to sev_platform_status() during setup")
dc46515cf838 ("KVM: x86: Move illegal GPA helper out of the MMU code")
1dbf5d68af6f ("KVM: VMX: Add guest physical address check in EPT violation and misconfig")
a0c134347baf ("KVM: VMX: introduce vmx_need_pf_intercept")
ec7771ab471b ("KVM: x86: mmu: Add guest physical address check in translate_gpa()")
cd313569f581 ("KVM: x86: mmu: Move translate_gpa() to mmu.c")
985ab2780164 ("KVM: x86/mmu: Make kvm_mmu_page definition and accessor internal-only")
6ca9a6f3adef ("KVM: x86/mmu: Add MMU-internal header")
06e7852c0ffb ("KVM: SVM: Add vmcb_ prefix to mark_*() functions")
f25a9dec2da3 ("KVM: x86/mmu: Drop kvm_arch_write_log_dirty() wrapper")
2dbebf7ae1ed ("KVM: nVMX: Plumb L2 GPA through to PML emulation")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 86c4f0d547f6460d0426ebb3ba0614f1134b8cda Mon Sep 17 00:00:00 2001
From: Jim Mattson <jmattson@google.com>
Date: Thu, 29 Sep 2022 15:52:03 -0700
Subject: [PATCH] KVM: x86: Mask off reserved bits in CPUID.8000001FH

KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
actually supports. CPUID.8000001FH:EBX[31:16] are reserved bits and
should be masked off.

Fixes: 8765d75329a3 ("KVM: X86: Extend CPUID range to include new leaf")
Signed-off-by: Jim Mattson <jmattson@google.com>
Message-Id: <20220929225203.2234702-6-jmattson@google.com>
Cc: stable@vger.kernel.org
[Clear NumVMPL too. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a0292ba650df..0810e93cbedc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1199,7 +1199,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 		} else {
 			cpuid_entry_override(entry, CPUID_8000_001F_EAX);
-
+			/* Clear NumVMPL since KVM does not support VMPL.  */
+			entry->ebx &= ~GENMASK(31, 12);
 			/*
 			 * Enumerate '0' for "PA bits reduction", the adjusted
 			 * MAXPHYADDR is enumerated directly (see 0x80000008).

