Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF7563D56D
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 13:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbiK3MVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 07:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbiK3MVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 07:21:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2E625E82
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 04:21:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19DA961B98
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 12:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A47C433D6;
        Wed, 30 Nov 2022 12:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669810909;
        bh=wTNTV45y0JCjSFLpWdwm7XhpTtIiPTm5L6QRHfQrL0A=;
        h=Subject:To:Cc:From:Date:From;
        b=UkIeef7Hwqw6wAxYdbV2aQRMrhUDk/13YjpN31++DUiaCVPllnXnkfknD79PjBDoA
         lw1QTAVIuvp3jnTa2IgyGFYXZt9eGSqDW0//KDcc7wXu7i6C65YLgprqMRJf5xvtkE
         FxgR3/k7dBxdTcg9K/sQo8r2HrfeH1IaSe7Jvwzg=
Subject: FAILED: patch "[PATCH] KVM: x86: forcibly leave nested mode on vCPU reset" failed to apply to 5.4-stable tree
To:     mlevitsk@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 13:21:44 +0100
Message-ID: <1669810904102102@kroah.com>
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

ed129ec9057f ("KVM: x86: forcibly leave nested mode on vCPU reset")
0aa1837533e5 ("KVM: x86: Properly reset MMU context at vCPU RESET/INIT")
b3646477d458 ("KVM: x86: use static calls to reduce kvm_x86_ops overhead")
15b51dc08a34 ("KVM: x86: Take KVM's SRCU lock only if steal time update is needed")
19979fba9bfa ("KVM: x86: Remove obsolete disabling of page faults in kvm_arch_vcpu_put()")
5719455fbd95 ("KVM: SVM: Do not report support for SMM for an SEV-ES guest")
f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
f9a4d621761a ("KVM: x86: introduce complete_emulated_msr callback")
8b474427cbee ("KVM: x86: use kvm_complete_insn_gp in emulating RDMSR/WRMSR")
2259c17f0188 ("kvm: x86: Sink cpuid update into vendor-specific set_cr4 functions")
fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
c21d54f0307f ("KVM: x86: hyper-v: allow KVM_GET_SUPPORTED_HV_CPUID as a system ioctl")
ee69c92bac61 ("KVM: x86: Return bool instead of int for CR4 and SREGS validity checks")
c2fe3cd4604a ("KVM: x86: Move vendor CR4 validity check to dedicated kvm_x86_ops hook")
a447e38a7fad ("KVM: VMX: Drop explicit 'nested' check from vmx_set_cr4()")
d3a9e4146a6f ("KVM: VMX: Drop guest CPUID check for VMXE in vmx_set_cr4()")
a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
1d8dd6b3f12b ("kvm: x86/mmu: Support changed pte notifier in tdp MMU")
f8e144971c68 ("kvm: x86/mmu: Add access tracking for tdp_mmu")
063afacd8730 ("kvm: x86/mmu: Support invalidate range MMU notifier for TDP MMU")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ed129ec9057f89d615ba0c81a4984a90345a1684 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <mlevitsk@redhat.com>
Date: Thu, 3 Nov 2022 16:13:46 +0200
Subject: [PATCH] KVM: x86: forcibly leave nested mode on vCPU reset

While not obivous, kvm_vcpu_reset() leaves the nested mode by clearing
'vcpu->arch.hflags' but it does so without all the required housekeeping.

On SVM,	it is possible to have a vCPU reset while in guest mode because
unlike VMX, on SVM, INIT's are not latched in SVM non root mode and in
addition to that L1 doesn't have to intercept triple fault, which should
also trigger L1's reset if happens in L2 while L1 didn't intercept it.

If one of the above conditions happen, KVM will	continue to use vmcb02
while not having in the guest mode.

Later the IA32_EFER will be cleared which will lead to freeing of the
nested guest state which will (correctly) free the vmcb02, but since
KVM still uses it (incorrectly) this will lead to a use after free
and kernel crash.

This issue is assigned CVE-2022-3344

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221103141351.50662-5-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff5be7189237..597d7f804d72 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12003,8 +12003,18 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	WARN_ON_ONCE(!init_event &&
 		     (old_cr0 || kvm_read_cr3(vcpu) || kvm_read_cr4(vcpu)));
 
+	/*
+	 * SVM doesn't unconditionally VM-Exit on INIT and SHUTDOWN, thus it's
+	 * possible to INIT the vCPU while L2 is active.  Force the vCPU back
+	 * into L1 as EFER.SVME is cleared on INIT (along with all other EFER
+	 * bits), i.e. virtualization is disabled.
+	 */
+	if (is_guest_mode(vcpu))
+		kvm_leave_nested(vcpu);
+
 	kvm_lapic_reset(vcpu, init_event);
 
+	WARN_ON_ONCE(is_guest_mode(vcpu) || is_smm(vcpu));
 	vcpu->arch.hflags = 0;
 
 	vcpu->arch.smi_pending = 0;

