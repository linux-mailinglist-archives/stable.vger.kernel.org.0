Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822C2382764
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbhEQIsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:48:21 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:44225 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235730AbhEQIsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 04:48:20 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 317AD9FA;
        Mon, 17 May 2021 04:47:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 17 May 2021 04:47:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=zSRxo7
        zgaM38BZ6JpenQXup84U4vjXOMZAG8Z1DRvqI=; b=I9umbVLBtL/5rVGLBB73Js
        5tyoAfIawLw75wVcHUDRcLRCJbqCzy0ZZPvWvLMYwqVdP4066Qd3Bk38YAd7T1rA
        nzl0IPcVPurEk8GsDNSo77alcfKwTQW0NMDa2pnaUvAMKlI9l2G5J520Bc2PZtxe
        ndkHd31woWxtpllvW/uARdoHypiuSeAO9rMFwrx8ht+umClTWsR+0MDPPFiSFg0A
        qCmW5bGSSUVIpVUHArhMpcspwIK4z+mOQ2qXV0tCls9kQY9FYi3SGgSNJik4Uc4x
        +W2e6flXzULYhbKX+8QnGBuuu/OcgBHIuUVEvHOHsUHPJ9k3VHxUVV8/kkWBVljQ
        ==
X-ME-Sender: <xms:hy2iYJoa4lTVcYhkeWc1mknsl9Gox8r9pGs89utAo_KObss_TUkrrg>
    <xme:hy2iYLrLGaKwjGGGWd1FWcb_PaQGoALMrWwm8qQBCfRewj_8U0jpuRavxAuw40G1T
    8NonzKxNORDPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:hy2iYGMy3URlH2b8ZjBJXlXngC_rUiBZNqwXE5V-3vNWBW3QKm5ldg>
    <xmx:hy2iYE7Smp-aeLjo2J4wItMiwiz9kHL4IJ0NicQINOt0zwrf_qB7zg>
    <xmx:hy2iYI5jCc4XXvJAasGUroKmjmHhbBvWyUZQ0DJIHr-USCP6OI8RhA>
    <xmx:hy2iYNgYazBUqlUyDTv0RgN6ukSAbphl2swyqQ6OirJIX4IZlKj2fk8GMDY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 04:47:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Probe and load MSR_TSC_AUX regardless of RDTSCP" failed to apply to 5.12-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 10:47:02 +0200
Message-ID: <162124122226112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
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

