Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A4166C927
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbjAPQqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbjAPQqA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:46:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B217D1D919
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:33:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71D1AB81059
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4636C433D2;
        Mon, 16 Jan 2023 16:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886833;
        bh=zuleEFNdXrntH7ShTYLOJ+KVEp52bcXNe5ppoMWb214=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFFdRqWPZ9GPHqeaFaxrHFehiAJjp9uab8vow4BHkJDcIznPcRgUamFV23jh2BgbE
         yAXHAUXPdN8aUKPz0l+OBjIZt/ipXLv/aWrWG9V7ibV+obllFok5Plu56iEOEfzp2Z
         aUhclNY2rVXRXsO1iCaQdQ31jbOjPSNpEn3ud+Zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 550/658] KVM: VMX: Fix the spelling of CPU_BASED_USE_TSC_OFFSETTING
Date:   Mon, 16 Jan 2023 16:50:38 +0100
Message-Id: <20230116154934.686098703@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

[ Upstream commit 5e3d394fdd9e6b49cd8b28d85adff100a5bddc66 ]

The mis-spelling is found by checkpatch.pl, so fix them.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 31de69f4eea7 ("KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE control to L1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/vmx.h                               | 2 +-
 arch/x86/kvm/vmx/nested.c                                | 8 ++++----
 arch/x86/kvm/vmx/vmx.c                                   | 6 +++---
 tools/testing/selftests/kvm/include/x86_64/vmx.h         | 2 +-
 tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c | 2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 06d4420508c5..d716fe938fc0 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -20,7 +20,7 @@
  * Definitions of Primary Processor-Based VM-Execution Controls.
  */
 #define CPU_BASED_INTR_WINDOW_EXITING           0x00000004
-#define CPU_BASED_USE_TSC_OFFSETING             0x00000008
+#define CPU_BASED_USE_TSC_OFFSETTING            0x00000008
 #define CPU_BASED_HLT_EXITING                   0x00000080
 #define CPU_BASED_INVLPG_EXITING                0x00000200
 #define CPU_BASED_MWAIT_EXITING                 0x00000400
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index dca2c78db5d0..1dd693d18395 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3090,7 +3090,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	}
 
 	enter_guest_mode(vcpu);
-	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETING)
+	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
 		vcpu->arch.tsc_offset += vmcs12->tsc_offset;
 
 	if (prepare_vmcs02(vcpu, vmcs12, &exit_qual))
@@ -3154,7 +3154,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	 * 26.7 "VM-entry failures during or after loading guest state".
 	 */
 vmentry_fail_vmexit_guest_mode:
-	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETING)
+	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
 		vcpu->arch.tsc_offset -= vmcs12->tsc_offset;
 	leave_guest_mode(vcpu);
 
@@ -4073,7 +4073,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	if (nested_cpu_has_preemption_timer(vmcs12))
 		hrtimer_cancel(&to_vmx(vcpu)->nested.preemption_timer);
 
-	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETING)
+	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
 		vcpu->arch.tsc_offset -= vmcs12->tsc_offset;
 
 	if (likely(!vmx->fail)) {
@@ -5870,7 +5870,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
 	msrs->procbased_ctls_high &=
 		CPU_BASED_INTR_WINDOW_EXITING |
-		CPU_BASED_NMI_WINDOW_EXITING | CPU_BASED_USE_TSC_OFFSETING |
+		CPU_BASED_NMI_WINDOW_EXITING | CPU_BASED_USE_TSC_OFFSETTING |
 		CPU_BASED_HLT_EXITING | CPU_BASED_INVLPG_EXITING |
 		CPU_BASED_MWAIT_EXITING | CPU_BASED_CR3_LOAD_EXITING |
 		CPU_BASED_CR3_STORE_EXITING |
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 470a8f9a0046..df77207d93b0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1780,7 +1780,7 @@ static u64 vmx_read_l1_tsc_offset(struct kvm_vcpu *vcpu)
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
 	if (is_guest_mode(vcpu) &&
-	    (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETING))
+	    (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING))
 		return vcpu->arch.tsc_offset - vmcs12->tsc_offset;
 
 	return vcpu->arch.tsc_offset;
@@ -1798,7 +1798,7 @@ static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	 * to the newly set TSC to get L2's TSC.
 	 */
 	if (is_guest_mode(vcpu) &&
-	    (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETING))
+	    (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING))
 		g_tsc_offset = vmcs12->tsc_offset;
 
 	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
@@ -2425,7 +2425,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      CPU_BASED_CR3_STORE_EXITING |
 	      CPU_BASED_UNCOND_IO_EXITING |
 	      CPU_BASED_MOV_DR_EXITING |
-	      CPU_BASED_USE_TSC_OFFSETING |
+	      CPU_BASED_USE_TSC_OFFSETTING |
 	      CPU_BASED_MWAIT_EXITING |
 	      CPU_BASED_MONITOR_EXITING |
 	      CPU_BASED_INVLPG_EXITING |
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 7eb38451c359..3d27069b9ed9 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -19,7 +19,7 @@
  * Definitions of Primary Processor-Based VM-Execution Controls.
  */
 #define CPU_BASED_INTR_WINDOW_EXITING		0x00000004
-#define CPU_BASED_USE_TSC_OFFSETING		0x00000008
+#define CPU_BASED_USE_TSC_OFFSETTING		0x00000008
 #define CPU_BASED_HLT_EXITING			0x00000080
 #define CPU_BASED_INVLPG_EXITING		0x00000200
 #define CPU_BASED_MWAIT_EXITING			0x00000400
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
index 5590fd2bcf87..69e482a95c47 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
@@ -98,7 +98,7 @@ static void l1_guest_code(struct vmx_pages *vmx_pages)
 	prepare_vmcs(vmx_pages, l2_guest_code,
 		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 	control = vmreadz(CPU_BASED_VM_EXEC_CONTROL);
-	control |= CPU_BASED_USE_MSR_BITMAPS | CPU_BASED_USE_TSC_OFFSETING;
+	control |= CPU_BASED_USE_MSR_BITMAPS | CPU_BASED_USE_TSC_OFFSETTING;
 	vmwrite(CPU_BASED_VM_EXEC_CONTROL, control);
 	vmwrite(TSC_OFFSET, TSC_OFFSET_VALUE);
 
-- 
2.35.1



