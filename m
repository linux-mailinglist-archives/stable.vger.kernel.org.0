Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56FF342BAA
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhCTLM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:12:29 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:44861 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229878AbhCTLMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 07:12:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 906EB1940A2A;
        Sat, 20 Mar 2021 06:49:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 20 Mar 2021 06:49:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=CF+aTc
        +D/8wXLDiOKbyHFpPKS0WMH9MvAfJi2GfQWyI=; b=mkH90TjVdDkti1uEETtZfX
        ii8Fii0FOMRTt0JIiw1gpWeqLfG3LPy24maVfTwzI70HwG4BUpneatlhqzHOIGbz
        KiLXLfQZVqqrWbjcgbn2CbgUFL9oSlAVCS0rbq4JO6/Mhbnj+hvvR2hdjCuS0G0C
        G95/Tvknj3vNN5dEFUR7iuGTVNI5GYuEgZoOjFAYE8ZovKfP1wRDLrmYNaO4FJ7I
        bcSTOCTmwQ6CJ6u7ufan1UrEFjXSHhbfAOerQw6CAHAI2cYKALILJvuSdxodqDqe
        wLklhqbuXji9+qd5lIMn4RjJSm1hj4U1s3mgICndNUn5bqHTnhY1lJEXeBOaQIfg
        ==
X-ME-Sender: <xms:J9NVYJg7z6ebWUsFR675jiWuztgoAr9d3tKhtjQnkTUjm8KuBEC7qA>
    <xme:J9NVYOAL3ao_-GI_lTozIE8afPxT82UxM9oXUQOEfboOD-mkcLMp88rC85e2X6yiC
    zGKNRT7VBScMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegtddgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:J9NVYJGmqYJiz9hSKUyyPjVfxzWqFdqPvrA-pJYX_zLaVQ3JaHb-lw>
    <xmx:J9NVYOSdcZ557WUUkeBTqP9BratVEse6Hf2IOACD4ERKCubUAPMYjA>
    <xmx:J9NVYGzWrgwMiZ8JqgJh2UwAMCK9Z1CllbHYUUrZ3rsP8PCIjfWwkQ>
    <xmx:J9NVYB_FHQjXojc1X1cHHY0Oz4iWq-mwNo7jOn1x8JC3khrI-DS0lw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3B0AE108005C;
        Sat, 20 Mar 2021 06:49:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Protect userspace MSR filter with SRCU, and set" failed to apply to 5.11-stable tree
To:     seanjc@google.com, graf@amazon.com, pbonzini@redhat.com,
        yaoyuan0329os@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 20 Mar 2021 11:49:01 +0100
Message-ID: <1616237341147131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b318e8decf6b9ef1bcf4ca06fae6d6a2cb5d5c5c Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 16 Mar 2021 11:44:33 -0700
Subject: [PATCH] KVM: x86: Protect userspace MSR filter with SRCU, and set
 atomically-ish

Fix a plethora of issues with MSR filtering by installing the resulting
filter as an atomic bundle instead of updating the live filter one range
at a time.  The KVM_X86_SET_MSR_FILTER ioctl() isn't truly atomic, as
the hardware MSR bitmaps won't be updated until the next VM-Enter, but
the relevant software struct is atomically updated, which is what KVM
really needs.

Similar to the approach used for modifying memslots, make arch.msr_filter
a SRCU-protected pointer, do all the work configuring the new filter
outside of kvm->lock, and then acquire kvm->lock only when the new filter
has been vetted and created.  That way vCPU readers either see the old
filter or the new filter in their entirety, not some half-baked state.

Yuan Yao pointed out a use-after-free in ksm_msr_allowed() due to a
TOCTOU bug, but that's just the tip of the iceberg...

  - Nothing is __rcu annotated, making it nigh impossible to audit the
    code for correctness.
  - kvm_add_msr_filter() has an unpaired smp_wmb().  Violation of kernel
    coding style aside, the lack of a smb_rmb() anywhere casts all code
    into doubt.
  - kvm_clear_msr_filter() has a double free TOCTOU bug, as it grabs
    count before taking the lock.
  - kvm_clear_msr_filter() also has memory leak due to the same TOCTOU bug.

The entire approach of updating the live filter is also flawed.  While
installing a new filter is inherently racy if vCPUs are running, fixing
the above issues also makes it trivial to ensure certain behavior is
deterministic, e.g. KVM can provide deterministic behavior for MSRs with
identical settings in the old and new filters.  An atomic update of the
filter also prevents KVM from getting into a half-baked state, e.g. if
installing a filter fails, the existing approach would leave the filter
in a half-baked state, having already committed whatever bits of the
filter were already processed.

[*] https://lkml.kernel.org/r/20210312083157.25403-1-yaoyuan0329os@gmail.com

Fixes: 1a155254ff93 ("KVM: x86: Introduce MSR filtering")
Cc: stable@vger.kernel.org
Cc: Alexander Graf <graf@amazon.com>
Reported-by: Yuan Yao <yaoyuan0329os@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210316184436.2544875-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 38e327d4b479..2898d3e86b08 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4806,8 +4806,10 @@ If an MSR access is not permitted through the filtering, it generates a
 allows user space to deflect and potentially handle various MSR accesses
 into user space.
 
-If a vCPU is in running state while this ioctl is invoked, the vCPU may
-experience inconsistent filtering behavior on MSR accesses.
+Note, invoking this ioctl with a vCPU is running is inherently racy.  However,
+KVM does guarantee that vCPUs will see either the previous filter or the new
+filter, e.g. MSRs with identical settings in both the old and new filter will
+have deterministic behavior.
 
 4.127 KVM_XEN_HVM_SET_ATTR
 --------------------------
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e1b6e2edc828..3768819693e5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -948,6 +948,12 @@ enum kvm_irqchip_mode {
 	KVM_IRQCHIP_SPLIT,        /* created with KVM_CAP_SPLIT_IRQCHIP */
 };
 
+struct kvm_x86_msr_filter {
+	u8 count;
+	bool default_allow:1;
+	struct msr_bitmap_range ranges[16];
+};
+
 #define APICV_INHIBIT_REASON_DISABLE    0
 #define APICV_INHIBIT_REASON_HYPERV     1
 #define APICV_INHIBIT_REASON_NESTED     2
@@ -1042,16 +1048,11 @@ struct kvm_arch {
 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;
 
+	bool bus_lock_detection_enabled;
+
 	/* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
 	u32 user_space_msr_mask;
-
-	struct {
-		u8 count;
-		bool default_allow:1;
-		struct msr_bitmap_range ranges[16];
-	} msr_filter;
-
-	bool bus_lock_detection_enabled;
+	struct kvm_x86_msr_filter __rcu *msr_filter;
 
 	struct kvm_pmu_event_filter __rcu *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a5c5b38735e1..a04e78b89637 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1526,35 +1526,44 @@ EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
 
 bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
 {
+	struct kvm_x86_msr_filter *msr_filter;
+	struct msr_bitmap_range *ranges;
 	struct kvm *kvm = vcpu->kvm;
-	struct msr_bitmap_range *ranges = kvm->arch.msr_filter.ranges;
-	u32 count = kvm->arch.msr_filter.count;
-	u32 i;
-	bool r = kvm->arch.msr_filter.default_allow;
+	bool allowed;
 	int idx;
+	u32 i;
 
-	/* MSR filtering not set up or x2APIC enabled, allow everything */
-	if (!count || (index >= 0x800 && index <= 0x8ff))
+	/* x2APIC MSRs do not support filtering. */
+	if (index >= 0x800 && index <= 0x8ff)
 		return true;
 
-	/* Prevent collision with set_msr_filter */
 	idx = srcu_read_lock(&kvm->srcu);
 
-	for (i = 0; i < count; i++) {
+	msr_filter = srcu_dereference(kvm->arch.msr_filter, &kvm->srcu);
+	if (!msr_filter) {
+		allowed = true;
+		goto out;
+	}
+
+	allowed = msr_filter->default_allow;
+	ranges = msr_filter->ranges;
+
+	for (i = 0; i < msr_filter->count; i++) {
 		u32 start = ranges[i].base;
 		u32 end = start + ranges[i].nmsrs;
 		u32 flags = ranges[i].flags;
 		unsigned long *bitmap = ranges[i].bitmap;
 
 		if ((index >= start) && (index < end) && (flags & type)) {
-			r = !!test_bit(index - start, bitmap);
+			allowed = !!test_bit(index - start, bitmap);
 			break;
 		}
 	}
 
+out:
 	srcu_read_unlock(&kvm->srcu, idx);
 
-	return r;
+	return allowed;
 }
 EXPORT_SYMBOL_GPL(kvm_msr_allowed);
 
@@ -5354,25 +5363,34 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	return r;
 }
 
-static void kvm_clear_msr_filter(struct kvm *kvm)
+static struct kvm_x86_msr_filter *kvm_alloc_msr_filter(bool default_allow)
+{
+	struct kvm_x86_msr_filter *msr_filter;
+
+	msr_filter = kzalloc(sizeof(*msr_filter), GFP_KERNEL_ACCOUNT);
+	if (!msr_filter)
+		return NULL;
+
+	msr_filter->default_allow = default_allow;
+	return msr_filter;
+}
+
+static void kvm_free_msr_filter(struct kvm_x86_msr_filter *msr_filter)
 {
 	u32 i;
-	u32 count = kvm->arch.msr_filter.count;
-	struct msr_bitmap_range ranges[16];
 
-	mutex_lock(&kvm->lock);
-	kvm->arch.msr_filter.count = 0;
-	memcpy(ranges, kvm->arch.msr_filter.ranges, count * sizeof(ranges[0]));
-	mutex_unlock(&kvm->lock);
-	synchronize_srcu(&kvm->srcu);
+	if (!msr_filter)
+		return;
+
+	for (i = 0; i < msr_filter->count; i++)
+		kfree(msr_filter->ranges[i].bitmap);
 
-	for (i = 0; i < count; i++)
-		kfree(ranges[i].bitmap);
+	kfree(msr_filter);
 }
 
-static int kvm_add_msr_filter(struct kvm *kvm, struct kvm_msr_filter_range *user_range)
+static int kvm_add_msr_filter(struct kvm_x86_msr_filter *msr_filter,
+			      struct kvm_msr_filter_range *user_range)
 {
-	struct msr_bitmap_range *ranges = kvm->arch.msr_filter.ranges;
 	struct msr_bitmap_range range;
 	unsigned long *bitmap = NULL;
 	size_t bitmap_size;
@@ -5406,11 +5424,9 @@ static int kvm_add_msr_filter(struct kvm *kvm, struct kvm_msr_filter_range *user
 		goto err;
 	}
 
-	/* Everything ok, add this range identifier to our global pool */
-	ranges[kvm->arch.msr_filter.count] = range;
-	/* Make sure we filled the array before we tell anyone to walk it */
-	smp_wmb();
-	kvm->arch.msr_filter.count++;
+	/* Everything ok, add this range identifier. */
+	msr_filter->ranges[msr_filter->count] = range;
+	msr_filter->count++;
 
 	return 0;
 err:
@@ -5421,10 +5437,11 @@ static int kvm_add_msr_filter(struct kvm *kvm, struct kvm_msr_filter_range *user
 static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_msr_filter __user *user_msr_filter = argp;
+	struct kvm_x86_msr_filter *new_filter, *old_filter;
 	struct kvm_msr_filter filter;
 	bool default_allow;
-	int r = 0;
 	bool empty = true;
+	int r = 0;
 	u32 i;
 
 	if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
@@ -5437,25 +5454,32 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
 	if (empty && !default_allow)
 		return -EINVAL;
 
-	kvm_clear_msr_filter(kvm);
-
-	kvm->arch.msr_filter.default_allow = default_allow;
+	new_filter = kvm_alloc_msr_filter(default_allow);
+	if (!new_filter)
+		return -ENOMEM;
 
-	/*
-	 * Protect from concurrent calls to this function that could trigger
-	 * a TOCTOU violation on kvm->arch.msr_filter.count.
-	 */
-	mutex_lock(&kvm->lock);
 	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++) {
-		r = kvm_add_msr_filter(kvm, &filter.ranges[i]);
-		if (r)
-			break;
+		r = kvm_add_msr_filter(new_filter, &filter.ranges[i]);
+		if (r) {
+			kvm_free_msr_filter(new_filter);
+			return r;
+		}
 	}
 
+	mutex_lock(&kvm->lock);
+
+	/* The per-VM filter is protected by kvm->lock... */
+	old_filter = srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1);
+
+	rcu_assign_pointer(kvm->arch.msr_filter, new_filter);
+	synchronize_srcu(&kvm->srcu);
+
+	kvm_free_msr_filter(old_filter);
+
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MSR_FILTER_CHANGED);
 	mutex_unlock(&kvm->lock);
 
-	return r;
+	return 0;
 }
 
 long kvm_arch_vm_ioctl(struct file *filp,
@@ -10636,8 +10660,6 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
-	u32 i;
-
 	if (current->mm == kvm->mm) {
 		/*
 		 * Free memory regions allocated on behalf of userspace,
@@ -10653,8 +10675,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		mutex_unlock(&kvm->slots_lock);
 	}
 	static_call_cond(kvm_x86_vm_destroy)(kvm);
-	for (i = 0; i < kvm->arch.msr_filter.count; i++)
-		kfree(kvm->arch.msr_filter.ranges[i].bitmap);
+	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
 	kvm_free_vcpus(kvm);

