Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75886220FC
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 01:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiKIAxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 19:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiKIAxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 19:53:49 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1581FCD5
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 16:53:47 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id m6so15325830pfb.0
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 16:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lSPwRWjaEF/LeVzWwfEyhyHq6my7W3G8KqemGhh/zlQ=;
        b=KTXPFBq0j8DL7aghY2zF3UtVyVdwG5tWKkoRKkfPk2CGL/kZCHevjQLUilekZPEA4k
         nK3vxdNv20fVQapDOb6SKuM7Gwbmp1NRWJuFoGVsf7f2ayP3r4VW9EnVw9+Zclqj0gDS
         PsZpj9JFHXdN0WgSjKhVAqYdJtY/hVJE5uljMFPEHRe2RmDwnQPkSYwyEXJy69jGMjff
         LhBQVbeQ0pJR2qx9d+eKj7np6bSovO5y7TYBPqhFr8sTitEBIM2Ci2+Zpl0PQqczXsOm
         yiIE85Avse/JxmLgmtfUaPiOVAMCFJT+unGLlnR3mhlEyrIuk9vt4BOh+/qNiLGq+xV2
         vUdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lSPwRWjaEF/LeVzWwfEyhyHq6my7W3G8KqemGhh/zlQ=;
        b=eZvg6M4dCxLV4W5jv5fJ+kCqnISxSGTi8yMhTNZ5IkieNb4gZMHwGM7vOlJ/Yambn4
         FN5hzRPUTgzTeV0KogdrCiek3ylZylVSUY+koqx9/4v3OjykRlsRyeYCi4//co0c4FEm
         5UTYg2G70D+2ph8F0KCUBNaH/x8I4seY6yuJtKK4H59RHnuEST+Ba1XcUJdjjpR8hG7c
         6bETHD1Pdhhu/7lXTBcQPkgEJQxQtMv4rjakk61u4nLiglzvg0wyFiHf0WHgq6a2F/aM
         b46U+Opq22xfwoEvkaItCTfRbZFwAE5/GpKTZtnE4vfNVFqi2nIQkaiAortbgvEotRAG
         hzDQ==
X-Gm-Message-State: ACrzQf2sA43WyXvBqsCvaPOLM3PNHGgL64ceKZP5HOL6et9e1UAVUlgv
        QcGDpXifDcimOOaes54EqYDFgA==
X-Google-Smtp-Source: AMsMyM4Yhi4/gggSnC74XQ5ZkcpZGD6bO98vhJvQj1gcS0CktwwTLuXp5UqTwzwaAUVm48YIp3WoPA==
X-Received: by 2002:a63:185c:0:b0:46f:4a36:9a6f with SMTP id 28-20020a63185c000000b0046f4a369a6fmr48790934pgy.22.1667955227179;
        Tue, 08 Nov 2022 16:53:47 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p5-20020a170902780500b00186b06963f9sm7482264pll.180.2022.11.08.16.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 16:53:46 -0800 (PST)
Date:   Wed, 9 Nov 2022 00:53:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 4/8] KVM: SVM: retrieve VMCB from assembly
Message-ID: <Y2r6FqZyT4XxUkYB@google.com>
References: <20221108151532.1377783-1-pbonzini@redhat.com>
 <20221108151532.1377783-5-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8nC9O1np0SJJrVJV"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221108151532.1377783-5-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8nC9O1np0SJJrVJV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Nov 08, 2022, Paolo Bonzini wrote:
> This is needed in order to keep the number of arguments to 3 or less,
> after adding hsave_pa and spec_ctrl_intercepted.  32-bit builds only
> support passing three arguments in registers, fortunately all other
> data is reachable from the vcpu_svm struct.

Is it actually a problem if parameters are passed on the stack?  The assembly
code mostly creates a stack frame, i.e. %ebp can be used to pull values off the
stack.

I dont think it will matter in the end (more below), but hypothetically if we
ended up with

  void __svm_vcpu_run(struct kvm_vcpu *vcpu, unsigned long vmcb_pa,
		      unsigned long gsave_pa, unsigned long hsave_pa,
		      bool spec_ctrl_intercepted);

then the asm prologue would be something like:

	/*
	 * Save @vcpu, @gsave_pa, @hsave_pa, and @spec_ctrl_intercepted, all of
	 * which are needed after VM-Exit.
	 */
	push %_ASM_ARG1
	push %_ASM_ARG3

  #ifdef CONFIG_X86_64
	push %_ASM_ARG4
	push %_ASM_ARG5
  #else
	push %_ASM_ARG4_EBP(%ebp)
	push %_ASM_ARG5_EBP(%ebp)
  #endif

which is a few extra memory accesses, especially for 32-bit, but no one cares
about 32-bit and I highly doubt a few extra PUSH+POP instructions will be noticeable.

Threading in yesterday's conversation...

> > What about adding dedicated structs to hold the non-regs params for VM-Enter and
> > VMRUN?  Grabbing stuff willy-nilly in the assembly code makes the flows difficult
> > to read as there's nothing in the C code that describes what fields are actually
> > used.
>
> What fields are actually used is (like with any other function)
> "potentially all, you'll have to read the source code and in fact you
> can just read asm-offsets.c instead".  What I mean is, I cannot offhand
> see or remember what fields are touched by svm_prepare_switch_to_guest,
> why would __svm_vcpu_run be any different?

It's different because if it were a normal C function, it would simply take
@vcpu, and maybe @spec_ctrl_intercepted to shave cycles after CLGI.  But because
it's assembly and doesn't have to_svm() readily available (among other restrictions),
__svm_vcpu_run() ends up taking a mishmash of parameters, which for me makes it
rather difficult to understand what to expect.

Oooh, and after much staring I realized that the address of the host save area
is passed in because grabbing it after VM-Exit can't work.  That's subtle, and
passing it in isn't strictly necessary; there's no reason the assembly code can't
grab it and stash it on the stack.

What about killing a few birds with one stone?  Move the host save area PA to
its own per-CPU variable, and then grab that from assembly as well.  Then it's
a bit more obvious why the address needs to be saved on the stack across VMRUN,
and my whining about the prototype being funky goes away.  __svm_vcpu_run() and
__svm_sev_es_vcpu_run() would have identical prototypes too.

Attached patches would slot in early in the series.  Tested SVM and SME-enabled
kernels, didn't test the SEV-ES bits.

--8nC9O1np0SJJrVJV
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-SVM-Add-a-helper-to-convert-a-SME-aware-PA-back-.patch"

From 59a4b14ec509e30e614beaa20ceb920c181e3739 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 8 Nov 2022 15:25:41 -0800
Subject: [PATCH 1/2] KVM: SVM: Add a helper to convert a SME-aware PA back to
 a struct page

Add __sme_pa_to_page() to pair with __sme_page_pa() and use it to replace
open coded equivalents, including for "iopm_base", which previously
avoided having to do __sme_clr() by storing the raw PA in the global
variable.

Opportunistically convert __sme_page_pa() to a helper to provide type
safety.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c |  9 ++++-----
 arch/x86/kvm/svm/svm.h | 16 +++++++++++++++-
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58f0077d9357..bb7427fd1242 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1065,8 +1065,7 @@ static void svm_hardware_unsetup(void)
 	for_each_possible_cpu(cpu)
 		svm_cpu_uninit(cpu);
 
-	__free_pages(pfn_to_page(iopm_base >> PAGE_SHIFT),
-	get_order(IOPM_SIZE));
+	__free_pages(__sme_pa_to_page(iopm_base), get_order(IOPM_SIZE));
 	iopm_base = 0;
 }
 
@@ -1243,7 +1242,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	if (!kvm_hlt_in_guest(vcpu->kvm))
 		svm_set_intercept(svm, INTERCEPT_HLT);
 
-	control->iopm_base_pa = __sme_set(iopm_base);
+	control->iopm_base_pa = iopm_base;
 	control->msrpm_base_pa = __sme_set(__pa(svm->msrpm));
 	control->int_ctl = V_INTR_MASKING_MASK;
 
@@ -1443,7 +1442,7 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 
 	sev_free_vcpu(vcpu);
 
-	__free_page(pfn_to_page(__sme_clr(svm->vmcb01.pa) >> PAGE_SHIFT));
+	__free_page(__sme_pa_to_page(svm->vmcb01.pa));
 	__free_pages(virt_to_page(svm->msrpm), get_order(MSRPM_SIZE));
 }
 
@@ -4970,7 +4969,7 @@ static __init int svm_hardware_setup(void)
 
 	iopm_va = page_address(iopm_pages);
 	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
-	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
+	iopm_base = __sme_page_pa(iopm_pages);
 
 	init_msrpm_offsets();
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6a7686bf6900..9a2567803006 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -24,7 +24,21 @@
 
 #include "kvm_cache_regs.h"
 
-#define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
+/*
+ * Helpers to convert to/from physical addresses for pages whose address is
+ * consumed directly by hardware.  Even though it's a physical address, SVM
+ * often restricts the address to the natural width, hence 'unsigned long'
+ * instead of 'hpa_t'.
+ */
+static inline unsigned long __sme_page_pa(struct page *page)
+{
+	return __sme_set(page_to_pfn(page) << PAGE_SHIFT);
+}
+
+static inline struct page *__sme_pa_to_page(unsigned long pa)
+{
+	return pfn_to_page(__sme_clr(pa) >> PAGE_SHIFT);
+}
 
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2

base-commit: 88cd4a037496682f164e7ae8dac13cd4ec8edc2b
-- 
2.38.1.431.g37b22c650d-goog


--8nC9O1np0SJJrVJV
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-SVM-Snapshot-host-save-area-PA-in-dedicated-per-.patch"

From e9a4f9af27d7d384dc36ad66a9856f9decb8ce02 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 8 Nov 2022 15:32:58 -0800
Subject: [PATCH 2/2] KVM: SVM: Snapshot host save area PA in dedicated per-CPU
 variable

Track the SME-aware physical address of the host save area outside of
"struct svm_cpu_data" so that a future patch can easily reference the
address from assembly code.

The "overhead" of always allocating the per-CPU data is more or less
meaningless in the grand scheme.  And when KVM AMD is built as a module,
it's actually more costly (by a single pointer) to dynamically allocate
the struct, as the per-CPU data is allocated only when the module is
loaded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 30 ++++++++++++++++--------------
 arch/x86/kvm/svm/svm.h |  2 +-
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bb7427fd1242..8fc02bef4f85 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -246,6 +246,7 @@ struct kvm_ldttss_desc {
 } __attribute__((packed));
 
 DEFINE_PER_CPU(struct svm_cpu_data *, svm_data);
+DEFINE_PER_CPU(unsigned long, svm_host_save_area_pa);
 
 /*
  * Only MSR_TSC_AUX is switched via the user return hook.  EFER is switched via
@@ -597,7 +598,7 @@ static int svm_hardware_enable(void)
 
 	wrmsrl(MSR_EFER, efer | EFER_SVME);
 
-	wrmsrl(MSR_VM_HSAVE_PA, __sme_page_pa(sd->save_area));
+	wrmsrl(MSR_VM_HSAVE_PA, per_cpu(svm_host_save_area_pa, me));
 
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
 		/*
@@ -653,12 +654,13 @@ static void svm_cpu_uninit(int cpu)
 
 	per_cpu(svm_data, cpu) = NULL;
 	kfree(sd->sev_vmcbs);
-	__free_page(sd->save_area);
+	__free_page(__sme_pa_to_page(per_cpu(svm_host_save_area_pa, cpu)));
 	kfree(sd);
 }
 
 static int svm_cpu_init(int cpu)
 {
+	struct page *host_save_area;
 	struct svm_cpu_data *sd;
 	int ret = -ENOMEM;
 
@@ -666,20 +668,20 @@ static int svm_cpu_init(int cpu)
 	if (!sd)
 		return ret;
 	sd->cpu = cpu;
-	sd->save_area = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	if (!sd->save_area)
-		goto free_cpu_data;
 
 	ret = sev_cpu_init(sd);
 	if (ret)
-		goto free_save_area;
+		goto free_cpu_data;
+
+	host_save_area = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!host_save_area)
+		goto free_cpu_data;
 
 	per_cpu(svm_data, cpu) = sd;
+	per_cpu(svm_host_save_area_pa, cpu) = __sme_page_pa(host_save_area);
 
 	return 0;
 
-free_save_area:
-	__free_page(sd->save_area);
 free_cpu_data:
 	kfree(sd);
 	return ret;
@@ -1449,7 +1451,6 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
 
 	if (sev_es_guest(vcpu->kvm))
 		sev_es_unmap_ghcb(svm);
@@ -1461,10 +1462,13 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	 * Save additional host state that will be restored on VMEXIT (sev-es)
 	 * or subsequent vmload of host save area.
 	 */
-	vmsave(__sme_page_pa(sd->save_area));
+	vmsave(per_cpu(svm_host_save_area_pa, vcpu->cpu));
 	if (sev_es_guest(vcpu->kvm)) {
 		struct sev_es_save_area *hostsa;
-		hostsa = (struct sev_es_save_area *)(page_address(sd->save_area) + 0x400);
+		struct page *hostsa_page;
+
+		hostsa_page = __sme_pa_to_page(per_cpu(svm_host_save_area_pa, vcpu->cpu));
+		hostsa = (struct sev_es_save_area *)(page_address(hostsa_page) + 0x400);
 
 		sev_es_prepare_switch_to_guest(hostsa);
 	}
@@ -3920,8 +3924,6 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	if (sev_es_guest(vcpu->kvm)) {
 		__svm_sev_es_vcpu_run(vmcb_pa);
 	} else {
-		struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
-
 		/*
 		 * Use a single vmcb (vmcb01 because it's always valid) for
 		 * context switching guest state via VMLOAD/VMSAVE, that way
@@ -3932,7 +3934,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 		__svm_vcpu_run(vmcb_pa, (unsigned long *)&vcpu->arch.regs);
 		vmsave(svm->vmcb01.pa);
 
-		vmload(__sme_page_pa(sd->save_area));
+		vmload(per_cpu(svm_host_save_area_pa, vcpu->cpu));
 	}
 
 	guest_state_exit_irqoff();
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9a2567803006..d9ec8ea69a56 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -303,7 +303,6 @@ struct svm_cpu_data {
 	u32 min_asid;
 	struct kvm_ldttss_desc *tss_desc;
 
-	struct page *save_area;
 	struct vmcb *current_vmcb;
 
 	/* index = sev_asid, value = vmcb pointer */
@@ -311,6 +310,7 @@ struct svm_cpu_data {
 };
 
 DECLARE_PER_CPU(struct svm_cpu_data *, svm_data);
+DECLARE_PER_CPU(unsigned long, svm_host_save_area_pa);
 
 void recalc_intercepts(struct vcpu_svm *svm);
 
-- 
2.38.1.431.g37b22c650d-goog


--8nC9O1np0SJJrVJV--
