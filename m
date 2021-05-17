Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC780382769
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235730AbhEQIs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:48:28 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:34109 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235717AbhEQIs1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 04:48:27 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 8A821A0E;
        Mon, 17 May 2021 04:47:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 17 May 2021 04:47:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=U1Zs2i
        bBJzcW35GBrdQ0W+4z9zhqiUibgqkNMVtCfMI=; b=ooYPss50B+82orN1ZGAj9X
        gcfbZ6mHmcBcvOrgthGKP95qY9byN8z9pMAFc6T7t+jqVOh5y8CYEIPbJJRHDaDK
        JEBOdvmUKP9l+HvS5FUiik2XrjO9+spld1xVL9ALmQmn0v0bgoQq3eCz5op89chz
        g5imF2B4YdcJHKxwlRCCzN4fHKHWlJ4iLKwNwFsXhnQhvEriJ8oDwKOIysgsWC6s
        iTUquz0gwpTda3VYDjH3hQg+fYfoeDyFOKNWIydfcfhaA6ngqKJ7CpYQYTH8mPc2
        9X0sxSa8/cZEEGC521TuDsZNGxvqtmD2McwjhhNVAn70evL6xLStUZ2Mw/tVzlnA
        ==
X-ME-Sender: <xms:jy2iYHdH5BFcMKA2oUOPK-1rnkmPG4Uw9uHZktwtcmDaSWQfjFoBpQ>
    <xme:jy2iYNNzERLnPaX3kTJi2iVSlDpABS6VcgpEA04lzfdpI2E8cM7PtchhkV2CjT6Kp
    -P6aOYOxbrQdQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:jy2iYAg7Yhenpup33Twvh5plo3z8CpcNfmFEv333KWvcmV2qBe9oWA>
    <xmx:jy2iYI--H9Y5UuhvPg8hc4AsCQE5uAEq-B171aAsmoS5IIamf3rDgg>
    <xmx:jy2iYDth0JpKXjyhL-6F4G_V0GirDJ6d9Z0pHcOvtjdukBR1FzRWuA>
    <xmx:jy2iYB2xyK6uDstW-JdAXbwmsG7Atcy3kGe4kyZk6JrjNzPP63Y7ddkpdL4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 04:47:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Probe and load MSR_TSC_AUX regardless of RDTSCP" failed to apply to 5.10-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 10:47:04 +0200
Message-ID: <162124122445102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0caa0a77c2f6fcd0830cdcd018db1af98fe35e28 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 4 May 2021 10:17:25 -0700
Subject: [PATCH] KVM: SVM: Probe and load MSR_TSC_AUX regardless of RDTSCP
 support in host

Probe MSR_TSC_AUX whether or not RDTSCP is supported in the host, and
if probing succeeds, load the guest's MSR_TSC_AUX into hardware prior to
VMRUN.  Because SVM doesn't support interception of RDPID, RDPID cannot
be disallowed in the guest (without resorting to binary translation).
Leaving the host's MSR_TSC_AUX in hardware would leak the host's value to
the guest if RDTSCP is not supported.

Note, there is also a kernel bug that prevents leaking the host's value.
The host kernel initializes MSR_TSC_AUX if and only if RDTSCP is
supported, even though the vDSO usage consumes MSR_TSC_AUX via RDPID.
I.e. if RDTSCP is not supported, there is no host value to leak.  But,
if/when the host kernel bug is fixed, KVM would start leaking MSR_TSC_AUX
in the case where hardware supports RDPID but RDTSCP is unavailable for
whatever reason.

Probing MSR_TSC_AUX will also allow consolidating the probe and define
logic in common x86, and will make it simpler to condition the existence
of MSR_TSX_AUX (from the guest's perspective) on RDTSCP *or* RDPID.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210504171734.1434054-7-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ebcb5849d69b..13e4dd128177 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -212,7 +212,7 @@ DEFINE_PER_CPU(struct svm_cpu_data *, svm_data);
  * RDTSCP and RDPID are not used in the kernel, specifically to allow KVM to
  * defer the restoration of TSC_AUX until the CPU returns to userspace.
  */
-#define TSC_AUX_URET_SLOT	0
+static int tsc_aux_uret_slot __read_mostly = -1;
 
 static const u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
 
@@ -959,8 +959,10 @@ static __init int svm_hardware_setup(void)
 		kvm_tsc_scaling_ratio_frac_bits = 32;
 	}
 
-	if (boot_cpu_has(X86_FEATURE_RDTSCP))
-		kvm_define_user_return_msr(TSC_AUX_URET_SLOT, MSR_TSC_AUX);
+	if (!kvm_probe_user_return_msr(MSR_TSC_AUX)) {
+		tsc_aux_uret_slot = 0;
+		kvm_define_user_return_msr(tsc_aux_uret_slot, MSR_TSC_AUX);
+	}
 
 	/* Check for pause filtering support */
 	if (!boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
@@ -1454,8 +1456,8 @@ static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	if (static_cpu_has(X86_FEATURE_RDTSCP))
-		kvm_set_user_return_msr(TSC_AUX_URET_SLOT, svm->tsc_aux, -1ull);
+	if (likely(tsc_aux_uret_slot >= 0))
+		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
 
 	svm->guest_state_loaded = true;
 }
@@ -2664,7 +2666,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
 		break;
 	case MSR_TSC_AUX:
-		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
+		if (tsc_aux_uret_slot < 0)
 			return 1;
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
@@ -2885,7 +2887,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->sysenter_esp_hi = guest_cpuid_is_intel(vcpu) ? (data >> 32) : 0;
 		break;
 	case MSR_TSC_AUX:
-		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
+		if (tsc_aux_uret_slot < 0)
 			return 1;
 
 		if (!msr->host_initiated &&
@@ -2908,7 +2910,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * guest via direct_access_msrs, and switch it via user return.
 		 */
 		preempt_disable();
-		r = kvm_set_user_return_msr(TSC_AUX_URET_SLOT, data, -1ull);
+		r = kvm_set_user_return_msr(tsc_aux_uret_slot, data, -1ull);
 		preempt_enable();
 		if (r)
 			return 1;

